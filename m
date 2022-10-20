Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234886060AE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJTMz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJTMz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:55:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5006A50D;
        Thu, 20 Oct 2022 05:55:55 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t16so10511290edd.2;
        Thu, 20 Oct 2022 05:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdvrcAZE1EPFKfjlz9uiWm6tLrgoi3e11AtXEZMwK1w=;
        b=IWGLeBFGsZqMWZu8NBa/5dv5ja5/cw8FaXj7wp6edzJDwcLJj6NIDrLC+M4WHRna9D
         W/HVQMcSF6esNg0rdN16No22xc3RXNXtqC+d9MIwWWH6OraR3CEpdZlZkXd0vUfIPJmc
         r76gdPx5puJhBChIud7soYMaAJ0xDETQQUIVLRMeRctA0r9t2d7V5VzVBTljkqjwVwzN
         xk+sjzPjB9NuQXcw43TV0QX8WHVLExkPruQp0pob9BJFWnTMsxqoV6Lp9yXB/rKr+P2X
         2pqwPSREhVfXotOpf0+Nbs64TnnBegLM9Dc0G+er8ZPI55mGP3UBqvZXxq5cUyuqaNJQ
         NTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdvrcAZE1EPFKfjlz9uiWm6tLrgoi3e11AtXEZMwK1w=;
        b=StQg2wVy465CUTjClT89XxsSzDhKW1vdRjvGCYlpFno/jiByDRdAmUrNTSjS8vEWbH
         ONJO/idNxFJXYmfSr96LHo08X087ryPcvvOBheq61ZMan3c+TWHcLa8EA81Oqf1j8Svc
         cYENtNJTwMH/N6adwxIy8nLzrYG/+8wsdhZtQ+w5iOkzajSztdXyoN8w6qLuVNhTvetK
         0AxJl80Ty+FtYryOS6Oo7l/RqAxvhNgF/y0T85zpc9R4ZwRkDn1oVz335m6jPNn2XNHz
         cduOzmH1re8q3p8h98MnNFkq0AabbvgUaJj7Cb4cgV/X62ym/pmbn6XnEzAyddnoL0y8
         /RIw==
X-Gm-Message-State: ACrzQf31juS5kIqQxSBZt/ft9UIfRJyu+2mRg9JxwjIJ7zeX2mniaIla
        cm261xRKACgSjsCX3cw7XqU=
X-Google-Smtp-Source: AMsMyM6HB1XTjI180WP9OH8hwcZzkR92cAa1uSRgWwfsf86U4j6iQ/5OrlRR6/R6eQbEuvuZKarM3Q==
X-Received: by 2002:a05:6402:1393:b0:457:ea9e:ba20 with SMTP id b19-20020a056402139300b00457ea9eba20mr12266779edv.109.1666270553914;
        Thu, 20 Oct 2022 05:55:53 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q5-20020aa7d445000000b0044bfdbd8a33sm11955944edr.88.2022.10.20.05.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 05:55:53 -0700 (PDT)
Date:   Thu, 20 Oct 2022 15:55:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
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
Subject: Re: [PATCH v8 net-next 03/12] net: bridge: enable bridge to install
 locked fdb entries from drivers
Message-ID: <20221020125549.v6kls2lk7etvay7c@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018165619.134535-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:56:10PM +0200, Hans J. Schultz wrote:
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 8f3d76c751dd..c6b938c01a74 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
>  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> +	item->locked = test_bit(BR_FDB_LOCKED, &fdb->flags);

Shouldn't this be set to 0 here, since it is the bridge->driver
direction?

>  	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
>  	item->info.ctx = ctx;
>  }
> -- 
> 2.34.1
> 
