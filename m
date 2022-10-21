Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F4607D8D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJURaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiJURaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:30:22 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686594D148;
        Fri, 21 Oct 2022 10:30:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t16so8523112edd.2;
        Fri, 21 Oct 2022 10:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eODYg6i1slVemJXiAd3VXkmdvCvejpnoks2e1b1sQZA=;
        b=kWmjcACfBGi4HGfSDqndyHtIVP5QX7I1bLM11RrayrZIHqCnhQks9SjBSlMCCHEK80
         3Olz0moI9h1U0OlYkoEqiu2hmUXnePYex6ofPDYB+7XQyM6xvTTUlsKpGxQ7A00r8Qiz
         2+yiokVqPbgJw3B97d9FN4gxPBWlld6vPoLR+yVJp0cxnR4nuH0HQlVF9u+Mt8Y9WJsF
         S5C1i/6ryyquWA+8VoY9IbDLwHRD3s79dKSRYFUQ8vmbRB9XAksydxeCCCfLeVenCyhs
         T5+eBUYX/+qKlh6s7y2e4VyeezWIF2MQsYA3j9ja+JFF71uvZwts4f4aPzxQtv5neO41
         vulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eODYg6i1slVemJXiAd3VXkmdvCvejpnoks2e1b1sQZA=;
        b=awKiwMXq6fZjRmSnPAJ0N1AAXx0hNvvNVZcWYAFiICSbsG+81aIlMfrxaiVkDZbL5v
         fWHkwpkHWVQeWVVrj45lDw92ISWH8UUadb+eNNyaisRw9cl3sEFvBIA9BKVEpiap18vQ
         rFy7Xl7UmAV0LuCH+G3mXGqpgQPa/2/JBfqqWlfChA1Z1az6HlFw6FBsQQ0t9T9MPMtw
         AzbxPq/NT15MWYgVn6rPq4vuOVofYp3njKRu8W82VJzPdnsZDV/AxaLkHebjFxQSMEC+
         YbnHnlRxSW5G+M7zdNPXiGEL05ikJqX6tVmWglXt4Wa79Fjl14Z+/QfhxBPemoPLdskP
         IdMw==
X-Gm-Message-State: ACrzQf0h5SyICZ6vmqcnSWHV3pKAYG4xw2o4dlk4dG4Fo8jtG4audTRA
        cUsbNG5Ta9TirUbm7cwLeGc=
X-Google-Smtp-Source: AMsMyM4s9UluzXOoPf7cYQVSBAmze6LMyEYjVNnYAFVkJdkbmtuP1IWFdO4gUJPrPwh+bE9aZswPGA==
X-Received: by 2002:a17:907:7611:b0:78d:9d69:adf9 with SMTP id jx17-20020a170907761100b0078d9d69adf9mr16728025ejc.283.1666373418592;
        Fri, 21 Oct 2022 10:30:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g13-20020a170906538d00b0073d638a7a89sm11999567ejo.99.2022.10.21.10.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 10:30:17 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:30:14 +0300
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
Message-ID: <20221021173014.oit3qmpkrsjwzbgu@skbuf>
References: <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 07:18:59PM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-21 18:30, Vladimir Oltean wrote:
> > On Fri, Oct 21, 2022 at 03:16:21PM +0200, netdev@kapio-technology.com wrote:
> > > As it is now in the bridge, the locked port part is handled before learning
> > > in the ingress data path, so with BR_LEARNING and BR_PORT_LOCKED, I think it
> > > will work as it does now except link local packages.
> > 
> > If link-local learning is enabled on a locked port, I think those
> > addresses should also be learned with the BR_FDB_LOCKED flag. The
> > creation of those locked FDB entries can be further suppressed by the
> > BROPT_NO_LL_LEARN flag.
> > 
> > > If your suggestion of BR_LEARNING causing BR_FDB_LOCKED on a locked port, I
> > > guess it would be implemented under br_fdb_update() and BR_LEARNING +
> > > BR_PORT_LOCKED would go together, forcing BR_LEARNING in this case, thus also
> > > for all drivers?
> > 
> > Yes, basically where this is placed right now (in br_handle_frame_finish):
> 
> As I don't know what implications it would have for other drivers to have learning
> forced enabled on locked ports, I cannot say if it is a good idea or not.
> Right now learning is not forced either way as is, but the consensus is that learning
> should be off with locked ports, which it would be either way in the common case I
> think.

I don't think I fully understand what you mean by forcing BR_LEARNING.
A bridge port gets created with a default set of flags as can be seen in new_nbp().
Those flags include BR_LEARNING but don't include BR_PORT_LOCKED.

The user can decide he wants to make the port use 802.1X without MAB, so
he enables BR_PORT_LOCKED and disables BR_LEARNING, all with the same
netlink command (ip link set swp0 type bridge_slave learning off locked on).

How was the driver forced into anything?
