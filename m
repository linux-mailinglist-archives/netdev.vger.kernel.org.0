Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121F73BEB27
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhGGPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231685AbhGGPpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625672548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FxiqlKxow8FjTCNwE/2P6m22W/8IvlZgfCn7oIbgOPU=;
        b=WX/bEyZpfyi5xbST6Xc/cNFsBE8+awVOXZg3bbayWbnoorptyWaDgGwyq1i271hDTSd66p
        uNa7o/2aTShcqj41nPn/sJzRTK+YrTVY8tBj/0jjzQhlUbL6VmsfCAKOe/ONxra9xLt2LI
        PyGs1UG41ulY0cA4JwlD4HPH1W+Ltgo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-ldzO7fidPdyUP4eGp16USA-1; Wed, 07 Jul 2021 11:42:26 -0400
X-MC-Unique: ldzO7fidPdyUP4eGp16USA-1
Received: by mail-wr1-f69.google.com with SMTP id m9-20020a0560000089b02901362e1cd6a3so906901wrx.13
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 08:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FxiqlKxow8FjTCNwE/2P6m22W/8IvlZgfCn7oIbgOPU=;
        b=Hvd1C9aRbZH0Dy7JVS1QWwNYjjPlb2qN4LN1uKbqPSG3lDusx3kxnPmRHfrwo6zThi
         gWmVB83hB9BMwCb5EcusqOgLYKlKyTvI3qBpEtfdBjU/R01urnWbtybsrVmdeD8YJRc3
         8rksMTbA5jCZ5B4A0wlGHx12KbJQZeeHsNSyTyuiTWsNEEBQt8JgAap8Vyw5SRzEpxfG
         We7OSExcNBEEwuWyHomYUY1kEy+5+0NTc7BqUvH4Xtt85QRVoi3XiYAupY9kPWFZUxWD
         CiIR4Tcw2sjZy2tHRxBFGEvz4S7SJgvWxxxSyhn1oEEWxb3HJo7UuClLZnFb0LS12zGI
         pXDg==
X-Gm-Message-State: AOAM531Z/N3K6ZBXWeUp71BRrUoK7apov73kxRC3swYvqX4MUyVe8cZj
        fciC/IV3nsAJtjzPgtlHsJIchTxCLI//OHmefsMsVMk02P+VI5CwBW/Ax5zN4gu59/Twam+3P/T
        Fy5HhevDVmT81jW+w
X-Received: by 2002:a05:600c:4fc7:: with SMTP id o7mr27151072wmq.16.1625672545790;
        Wed, 07 Jul 2021 08:42:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycGbtcGkYaToVyE1M+PrlOG7wrSy70gaKcWKhq4VI1PbakfKtdO/6S3glWwoCP5eQCL2c3uA==
X-Received: by 2002:a05:600c:4fc7:: with SMTP id o7mr27151049wmq.16.1625672545606;
        Wed, 07 Jul 2021 08:42:25 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id o11sm18637723wmq.1.2021.07.07.08.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:42:25 -0700 (PDT)
Date:   Wed, 7 Jul 2021 17:42:23 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
Message-ID: <20210707154223.GA12339@pc-32.home>
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder>
 <20210701145943.GA3933@pc-32.home>
 <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
 <20210706190253.GA23236@pc-32.home>
 <f017bb67-73ff-7745-0da5-b267fe0f0501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f017bb67-73ff-7745-0da5-b267fe0f0501@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 09:05:24AM -0600, David Ahern wrote:
> On 7/6/21 1:02 PM, Guillaume Nault wrote:
> > On Thu, Jul 01, 2021 at 09:38:44AM -0600, David Ahern wrote:
> >> On 7/1/21 8:59 AM, Guillaume Nault wrote:
> >>> I first tried to write this selftest using VRFs, but there were some
> >>> problems that made me switch to namespaces (I don't remember precisely
> >>> which ones, probably virtual tunnel devices in collect_md mode).
> >>
> >> if you hit a problem with the test not working, send me the test script
> >> and I will take a look.
> > 
> > So I've looked again at what it'd take to make a VRF-based selftest.
> > The problem is that we currently can't create collect_md tunnel
> > interfaces in different VRFs, if the VRFs are part of the same netns.
> > 
> > Most tunnels explicitely refuse to create a collect_md device if
> > another one already exists in the netns, no matter the rest of the
> > tunnel parameters. This is the behaviour of ip_gre, ipip, ip6_gre and
> > ip6_tunnel.
> > 
> > Then there's sit, which allows the creation of the second collect_md
> > device in the other VRF. However, iproute2 doesn't set the
> > IFLA_IPTUN_LINK attribute when it creates an external device, so it
> > can't set up such a configuration.
> > 
> > Bareudp simply doesn't support VRF.
> > 
> > Finally, vxlan allows devices with different IFLA_VXLAN_LINK attributes
> > to be created, but only when VXLAN_F_IPV6_LINKLOCAL is set. Removing
> > the VXLAN_F_IPV6_LINKLOCAL test at the end of vxlan_config_validate()
> > is enough to make two VXLAN-GPE devices work in a multi-VRF setup:
> 
> Thanks for the details. In short, some work is needed to extend VRF
> support to these tunnels. That is worth doing if you have the time.

I probably won't have the time in the immediate future, but I've added
this work to my todo list. Meanwhile, I'll move the selftests to net/
and repost when net-next reopens.

