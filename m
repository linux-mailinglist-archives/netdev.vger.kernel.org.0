Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CBE4F9D97
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiDHTUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiDHTUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:20:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE613E10
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:18:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p15so19176342ejc.7
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 12:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usILc+lI6W+fa4vLGY8wa8PPo5QmjT5ZdrYLSQwUY0U=;
        b=NBwnvojB+DEMeuw1aPj31Tr0ZXrdbcSenkiXSgA0t1wtvrVgn++uvCdmaG2S4n2mnP
         yhzuqcgeNboF1gyqAtB0f1REITk52ppUQeeRpioBJTq63FbENCnXhBYzObkYqOyOmXDR
         0sQPn0jf2e5CapiapiTxebwnXmW+DpThKp8V7mDC1V43ZjTqugZ+FqJE9v8/9T4qy5DL
         38P2reeQaOmgbpgUH79hbuEs9FnP5t8qSzCb4jI50Pc3berqqHNNuL1f4ZdtvJKU/ERv
         PZQDyMEQc/Q3hqlKmVzrJ7AWOTw3GW9oOqjgeIZ3RdHi3/Wizh9Z96MvBhcLGylQiNJd
         9FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usILc+lI6W+fa4vLGY8wa8PPo5QmjT5ZdrYLSQwUY0U=;
        b=SyaHCTURWypjYOUA62kSIEPU66iVLUJa56YDCZ5UqHNzrEoUf0AeYA8ZV20399X1md
         wzmORsXttBYrUqTPL659pvMzbSY+WadclYN818jdPXkhEgIxIC1n48eiK5uoNm5yx4gy
         19jEnL3VBLpnmkgQ3ToRlXKSKGKlqO3Qs6O4EXM6d9qtMNZZ56Wun248RNIDw4n7Jj3A
         syRjapeY67nbeYFqNz1WF6cjgfPhyqVvl/OUepPDr3+JQDZkOVZYgOBpNm50Y90gIkMx
         wy9uO+J702Tmej6ez18zD+ksv/QSRbHpDj1LkzuHhHMh78GNctghV6nlPDeyhwX8qEGk
         B/cg==
X-Gm-Message-State: AOAM532wTbEH3g5ebMZrhvTw7zx21MfVIP2JQHEQKbBbUO+bLs+Tqw2e
        /x50A42jbo8SuZZxqGvVzs4=
X-Google-Smtp-Source: ABdhPJxpimcdd9oug5KgM2amOoixvqISjnHdkdYUUL5FUDcz+wG8TSjDL3/o4/3T5GXBoWL5RonJOg==
X-Received: by 2002:a17:906:9746:b0:6e0:5c9a:1a20 with SMTP id o6-20020a170906974600b006e05c9a1a20mr20341699ejy.714.1649445479047;
        Fri, 08 Apr 2022 12:17:59 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm11503873eda.2.2022.04.08.12.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 12:17:58 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:17:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220408191757.dllq7ztaefdyb4i6@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408115054.7471233b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 11:50:54AM -0700, Jakub Kicinski wrote:
> On Fri, 8 Apr 2022 21:30:45 +0300 Vladimir Oltean wrote:
> > Hello,
> > 
> > I am trying to understand why dev->gflags, which holds a mask of
> > IFF_PROMISC | IFF_ALLMULTI, exists independently of dev->flags.
> > 
> > I do see that __dev_change_flags() (called from the ioctl/rtnetlink/sysfs
> > code paths) updates the IFF_PROMISC and IFF_ALLMULTI bits of
> > dev->gflags, while the direct calls to dev_set_promiscuity()/
> > dev_set_allmulti() don't.
> > 
> > So at first I'd be tempted to say: IFF_PROMISC | IFF_ALLMULTI are
> > exposed to user space when set in dev->gflags, hidden otherwise.
> > This would be consistent with the implementation of dev_get_flags().
> > 
> > [ side note: why is that even desirable? why does it matter who made an
> >   interface promiscuous as long as it's promiscuous? ]
> 
> Isn't that just a mechanism to make sure user space gets one "refcount"
> on PROMISC and ALLMULTI, while in-kernel calls are tracked individually
> in dev->promiscuity? User space can request promisc while say bridge
> already put ifc into promisc mode, in that case we want promisc to stay
> up even if ifc is unbridged. But setting promisc from user space
> multiple times has no effect, since clear with remove it. Does that
> help? 

Yes, that helps to explain one side of it, thanks. But I guess I'm still
confused as to why should a promiscuity setting incremented by the
bridge be invisible to callers of dev_get_flags (SIOCGIFFLAGS,
ifinfomsg::ifi_flags [ *not* IFLA_PROMISCUITY ]).

> > But in the process of digging deeper I stumbled upon Nicolas' commit
> > 991fb3f74c14 ("dev: always advertise rx_flags changes via netlink")
> > which I am still struggling to understand.
> >
> > There, a call to __dev_notify_flags(gchanges=IFF_PROMISC) was added to
> > __dev_set_promiscuity(), called with "notify=true" from dev_set_promiscuity().
> > In my understanding, "gchanges" means "changes to gflags", i.e. to what
> > user space should know about. But as discussed above, direct calls to
> > dev_set_promiscuity() don't update dev->gflags, yet user space is
> > notified via rtmsg_ifinfo() of the promiscuity change.
> > 
> > Another oddity with Nicolas' commit: the other added call to
> > __dev_notify_flags(), this time from __dev_set_allmulti().
> > The logic is:
> > 
> > static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
> > {
> > 	unsigned int old_flags = dev->flags, old_gflags = dev->gflags;
> > 
> > 	dev->flags |= IFF_ALLMULTI;
> > 
> > 	(bla bla, stuff that doesn't modify dev->gflags)
> > 
> > 	if (dev->flags ^ old_flags) {
> > 
> > 		(bla bla, more stuff that doesn't modify dev->gflags)
> > 
> > 		if (notify)
> > 			__dev_notify_flags(dev, old_flags,
> > 					   dev->gflags ^ old_gflags);
> > 					   ~~~~~~~~~~~~~~~~~~~~~~~~
> > 					   oops, dev->gflags was never
> > 					   modified, so this call to
> > 					   __dev_notify_flags() is
> > 					   effectively dead code, since
> > 					   user space is not notified,
> > 					   and a NETDEV_CHANGE netdev
> > 					   notifier isn't emitted
> > 					   either, since IFF_ALLMULTI is
> > 					   excluded from that
> > 	}
> > 	return 0;
> > }
> > 
> > Can someone please clarify what is at least the intention? As can be
> > seen I'm highly confused.
> > 
> > Thanks.
> 
