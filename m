Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E74606B67
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJTWn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJTWnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:43:52 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D50322C801;
        Thu, 20 Oct 2022 15:43:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b12so1715783edd.6;
        Thu, 20 Oct 2022 15:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JglhUSuAsvyo/02iuoDdhbFLRdL0c14GOno7/e71c6I=;
        b=UVFcLtLRlFJ23BO5nFdHnG4XQRcYTdnQfD3m/QakLfwgOixkkCd7UJlVA+CHErZDSK
         yqcpu2eHqMGfmTPApN2EotBAlWuycXT2OjFAFM1+5hggxKMnxWXGuezOaAd4WEJlzw/E
         QwfCAicGgtNoOd8NE+jP3QuxiLJQ5qMyH/pDBuCnlZYt4z3r6VCKUlsfCNk+YLZNLAOA
         jZfpDE2kC2IhtsQcsYya9US9kOGVA9O8AzfTEwo/8FQZKplzXol7D+K0m8g9+ZJMdMlA
         7qnuH1rqNqLEFKQ+7QqHXn3BuFaESpqJ+j9E4Q1RUqqQor0Pmd9ogjMf6JpK5JbYc/PN
         U2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JglhUSuAsvyo/02iuoDdhbFLRdL0c14GOno7/e71c6I=;
        b=U7nGKDNnITWBgWJ7fdu3/isGxxQah2zaOX/mK7kEShsHJCHilFu6JQYA7m+mekBEBH
         lwd414b5tLQSjR2CGI0ex8RCQsQ6ddNyVGPXuGWenSpexU59VvlxX4tHoZ+a6L/bTzQt
         uGq2SRXAobZVkvfRO4WBsI5J9BHugvBha8CEQgXEXo3i0fb98t3Hx2NbYuRAPO3lgPvY
         UtvrtoR2pS3eUE+SU+KqcopQqy+EeW0+oBvpwEUSrrHpt3BTybI/UuvhRaCp9UKZ6IUL
         5uHWkYbfkaJZ9JM0HBQ38ioKtsC/xswAq2Sta3+kdNBReB/k7cudM6ztPYPUFSSOxaEJ
         vACQ==
X-Gm-Message-State: ACrzQf1v+F0415UupESRzNKHIWjcKQZ9HN4OeI8UE0b3HqsBvMCJUTK9
        P9ncfko2xbNDZ7Ikv5sFVyE=
X-Google-Smtp-Source: AMsMyM5MjXkVhqFJ0DzPxQqFB+bWxrQP/KKt/X60NxMrSXVU8VHjgZ1HhV+RGAF8iAk/TVSu8j+SmA==
X-Received: by 2002:a05:6402:518b:b0:45d:9a19:66d2 with SMTP id q11-20020a056402518b00b0045d9a1966d2mr14121112edd.43.1666305818360;
        Thu, 20 Oct 2022 15:43:38 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906384e00b0078246b1360fsm10790195ejc.131.2022.10.20.15.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:43:37 -0700 (PDT)
Date:   Fri, 21 Oct 2022 01:43:34 +0300
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
Subject: Re: [PATCH v8 net-next 03/12] net: bridge: enable bridge to install
 locked fdb entries from drivers
Message-ID: <20221020224334.ksh4xciad7yro3cj@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-4-netdev@kapio-technology.com>
 <20221020125549.v6kls2lk7etvay7c@skbuf>
 <e1184c879642c35e4ff6f19e0fd5de46@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1184c879642c35e4ff6f19e0fd5de46@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 09:29:06PM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-20 14:55, Vladimir Oltean wrote:
> > On Tue, Oct 18, 2022 at 06:56:10PM +0200, Hans J. Schultz wrote:
> > > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > > index 8f3d76c751dd..c6b938c01a74 100644
> > > --- a/net/bridge/br_switchdev.c
> > > +++ b/net/bridge/br_switchdev.c
> > > @@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct
> > > net_bridge *br,
> > >  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> > >  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
> > >  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> > > +	item->locked = test_bit(BR_FDB_LOCKED, &fdb->flags);
> > 
> > Shouldn't this be set to 0 here, since it is the bridge->driver
> > direction?
> 
> Wouldn't it be a good idea to allow drivers to add what corresponds to a blackhole
> entry when using the bridge input chain to activate the MAB feature, or in general
> to leave the decision of what to do to the driver implementation?

The patch doesn't propose that. It proposes:

| net: bridge: enable bridge to install locked fdb entries from drivers
| 
| The bridge will be able to install locked entries when receiving
| SWITCHDEV_FDB_ADD_TO_BRIDGE notifications from drivers.

Please write patches which make just one logical change, and explain the
justification for that change and precisely that change in the commit
message.
