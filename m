Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488CC5ED313
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 04:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiI1CkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 22:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI1CkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 22:40:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316967DF5E
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 19:39:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u12so2778340pjj.1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 19:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4I8AoLqqTBpkILztOJnlpMHMHnkgltLXuTruxEQ7Nw8=;
        b=iYvQ1xSFM1QvGeWEUBXymfu3T1O948tKjP1H+AQFV5wxJZUTg0GywLN/Re/Z+RZTYx
         pkZ5AEg+RC/xJN1mXuSiMTr4J+JyEExOYr3+IvNpXBzh5azcJcNWqqta5QiKc/WlLTgG
         kA5FMDwg3i8xk9M0VrAkKZZwqgOPEdKDwQN27w/pDT8rCyLpn5J/lS45BXqUqp8T9c6y
         OV8z3XR8IcCnXULtpzjBpveZg6afXMITJQFR1kr7C+aGziRbVM11qqx/WE/MMbMfUrcj
         CKvCeiO0ukfRxt/+7fMzUXQgDRgdj33NZwIa3DGC/JuBjVm/UoSqfOJaRs2B1mvAVGnz
         jqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4I8AoLqqTBpkILztOJnlpMHMHnkgltLXuTruxEQ7Nw8=;
        b=fQFumAZ+PDtxIMdRTK/Nu8Bxj9EppP4CJpUtTxygnNKsjzROMXE1lOiZTi4l++KlGN
         Edzcg5FcaQwseVs2hIXhbLiybveB1muCpD2WYl+sAOPUBB4qlIN2yVsd7Eytrx8h3p4U
         hu9Vi02OOJsOaH+nQcidVqa3oC02mJcNavDTW56tidwXnzDrqOA9Gi/ycDeDnLSNAoHa
         US8FxoVgG2aDs1jLI6NsF4OUHdHu8g4TNtHOTq/Hvtt6zS28CoKHDD/a7HMsPIw2WCfO
         uxeLt98d2oQb8K4U/OM2g9dOfYgbPbyTOBl87xTJXrDZQlcweA0pAaa59Ulv+lxXqmGA
         1Sog==
X-Gm-Message-State: ACrzQf2Wdr/ydcrs7L0Yz3MY2lLjHaY03J/d1hoHjADNBGdqSG0lRvfl
        opmBO9jogLLwTlr4Av/58ag=
X-Google-Smtp-Source: AMsMyM4cEfQlzR1r/aWwnYdNLMOIhS2LwQ9xCpx41sYbq835QfrNrxM9qbGcukJGIxAlp5rFhxAX/g==
X-Received: by 2002:a17:90b:350d:b0:202:ff91:a0bd with SMTP id ls13-20020a17090b350d00b00202ff91a0bdmr7964532pjb.46.1664332795617;
        Tue, 27 Sep 2022 19:39:55 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b00172a670607asm2286906ple.300.2022.09.27.19.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 19:39:54 -0700 (PDT)
Date:   Wed, 28 Sep 2022 10:39:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <YzOz9ePdsIMGg0s+@Laptop-X1>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
 <20220927072130.6d5204a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927072130.6d5204a3@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:21:30AM -0700, Jakub Kicinski wrote:
> On Tue, 27 Sep 2022 12:13:03 +0800 Hangbin Liu wrote:
> > @@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> >  		if (err)
> >  			goto out_unregister;
> >  	}
> > +
> > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > +				      0, pid, nlh->nlmsg_seq);
> > +	if (nskb)
> > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> > +
> >  out:
> >  	if (link_net)
> >  		put_net(link_net);
> 
> I'm surprised you're adding new notifications. Does the kernel not
> already notify about new links? I thought rtnl_newlink_create() ->
> rtnl_configure_link() -> __dev_notify_flags() sends a notification,
> already.

I think __dev_notify_flags() only sends notification when dev flag changed.
On the other hand, the notification is sent via multicast, while this patch
is intend to unicast the notification to the user space.

Thanks
Hangbin
