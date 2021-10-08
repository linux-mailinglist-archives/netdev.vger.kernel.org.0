Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BAA426C8F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhJHONt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhJHONt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4A160F39;
        Fri,  8 Oct 2021 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702313;
        bh=6Uon4oYuBa3M89dsedwcQldb1b6f2oOY4kSANIFPB4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fx0ejEs7cecsN9IcOKXp2uwbch5t8gSJlG76LtcconNKZiWrgSR0T4RWoQT4wmqNi
         iiNxBCy6338Xdg0pz3/7gryVsrdBpH0fV7X5ytD5uCjoCORTkeMSQ2Z1ps/IuiSNA2
         ASYIDTbQEK5QLjo3nLQhNuAq6yG2BkGGaAQp9mhsvZfJ6Ds5Rt3znSZKVU/A8XW5JN
         Qo/uW8da0sHmyZ2hzz/Wy9XCncpO/26BgS6noYNaaXru9o/kICvvCPP2WI+AUjxEFs
         zrgB8WcSn2HC7l2ia43bnvnRMVjqWK3e65jkX96Nr15iwGWLMD/CvPSwhMmvPJieWP
         ++G5rugYcH3Ow==
Date:   Fri, 8 Oct 2021 07:11:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-pf: Add devlink param to vary
 cqe size
Message-ID: <20211008071152.2799e0c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupD4Rb3d2hAtzoA5rtgqqFayXiYhAKUbgcpv0myVGpvPw@mail.gmail.com>
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
        <1633454136-14679-3-git-send-email-sbhatta@marvell.com>
        <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupNJC7EJAir+0iN6p4UGR0oU0by=N2Hf+zWaj2U8RrE4A@mail.gmail.com>
        <20211006064027.66a22a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupD4Rb3d2hAtzoA5rtgqqFayXiYhAKUbgcpv0myVGpvPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 12:42:34 +0530 sundeep subbaraya wrote:
> On Wed, Oct 6, 2021 at 7:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 6 Oct 2021 12:29:51 +0530 sundeep subbaraya wrote:  
> > > We do use ethtool -G for setting the number of receive buffers to
> > > allocate from the kernel and give those pointers to hardware memory pool(NPA).  
> >
> > You can extend the ethtool API.  
> 
> I will rework on this patch. Is it okay I drop this patch in this
> series and send only patches 1 and 3 for v3?

The first patch looks fine. But the last is where I think a common
interface is most likely to succeed, so no, patch 3 is not fine. 

The documentation (which BTW is required for devlink params) is lacking
so I can't be sure but patch 3 looks similar to what Huawei has been
working on, take a look:

https://lore.kernel.org/all/20210924142959.7798-4-huangguangbin2@huawei.com/
