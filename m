Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9A9607C40
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJUQae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiJUQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:30:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC44DCEB8;
        Fri, 21 Oct 2022 09:30:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m15so7843765edb.13;
        Fri, 21 Oct 2022 09:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=diC8NAGcMEsNdERayclB3yX1bYh/brVTx+qg6EEm8xY=;
        b=QuCjTmmNppPf/d2WZbw804dsVjsBi340rAtZVZBKAdL56fNNBr1wJsqU6uehAaZ4uG
         ZtNSVVp1WySs2XoXeGLLjrLOQ2/UPjvVqzt0nE48zKk/lEn51q5YwoeNTyaWjDpCr4ro
         rEEtRW/plhq9pEAd5d282djUJQcff2x5nnmiZL8ObV7Ftlxj+u9V6Wmmc+rPu+HC554S
         SQXQ+C4Di/dR0DgOjpgfOvcamTaZ4UxeBHSLnN9nSGPv+aGxbp4wL2HNetoY+mkGHl37
         SRiV4Enc2XcTkoX3a2qs0/CNN4LPYg+jxr7LHk0ksefOcZ8x4woYWzX95F6ix3YkfteB
         z52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diC8NAGcMEsNdERayclB3yX1bYh/brVTx+qg6EEm8xY=;
        b=kEXcJFDaK6tyH8oO9+Zs4LSujA5Qo6Bu3ZjNm/j4uI3zU6txeh8V3n663ptweEutEL
         IXTyvOW4C9axdzyIfXPsZQ6kme9xiACqBjVA/0//ACFurGs7STyjlGAO4aWMrDR3W2fc
         w/1EG+A+NgoE8SQ5mQ2l9PrGWFNcr2cdG9MvnykfqcMS4oxU4SjYeNIEltiOy8u0h7wM
         Klj90zBjIgFiuJ9Inn7SkS2AlcuZZoAlJxh5NxHr4bNyaQ708NBmOdchDhgQqCnLJG9u
         cMS7otqJ+YCduuHLTHQH3s8xpP6vy0h8N0Nei5BOSlJBAD1PgwCRnD4I5teGpjGInCmI
         LRaA==
X-Gm-Message-State: ACrzQf2Im8apH7abLeNDyB79whcehqjKOeQ6s03gd1sSTyfuC+GFMhXJ
        kpw/Y+CT/0TnMxv/exZif1E=
X-Google-Smtp-Source: AMsMyM78n56+svgX29OjlxCyk6mv2WVNTWp9uU9Jnba9JeGUv0mD6os2HIJ6ZxfS90tmLdfQOT0Awg==
X-Received: by 2002:a05:6402:3896:b0:45c:93c3:3569 with SMTP id fd22-20020a056402389600b0045c93c33569mr18660749edb.37.1666369810213;
        Fri, 21 Oct 2022 09:30:10 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090618f200b007828150a2f1sm11938898ejf.36.2022.10.21.09.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 09:30:09 -0700 (PDT)
Date:   Fri, 21 Oct 2022 19:30:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221021163005.xljk2j3fkikr6uge@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 03:16:21PM +0200, netdev@kapio-technology.com wrote:
> As it is now in the bridge, the locked port part is handled before learning
> in the ingress data path, so with BR_LEARNING and BR_PORT_LOCKED, I think it
> will work as it does now except link local packages.

If link-local learning is enabled on a locked port, I think those
addresses should also be learned with the BR_FDB_LOCKED flag. The
creation of those locked FDB entries can be further suppressed by the
BROPT_NO_LL_LEARN flag.

> If your suggestion of BR_LEARNING causing BR_FDB_LOCKED on a locked port, I
> guess it would be implemented under br_fdb_update() and BR_LEARNING +
> BR_PORT_LOCKED would go together, forcing BR_LEARNING in this case, thus also
> for all drivers?

Yes, basically where this is placed right now (in br_handle_frame_finish):

	if (p->flags & BR_PORT_LOCKED) {
		struct net_bridge_fdb_entry *fdb_src =
			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);

		if (!fdb_src) {
			unsigned long flags = 0;

			if (p->flags & BR_PORT_MAB) {
			   ~~~~~~~~~~~~~~~~~~~~~~~~
			   except check for BR_LEARNING

				__set_bit(BR_FDB_LOCKED, &flags);
				br_fdb_update(br, p, eth_hdr(skb)->h_source,
					      vid, flags);
			}
			goto drop;
		} else if (READ_ONCE(fdb_src->dst) != p ||
			   test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
			   test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {
			goto drop;
		}
	}
