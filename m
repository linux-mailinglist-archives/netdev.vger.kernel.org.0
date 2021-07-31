Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DB63DC4C6
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 10:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhGaIEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 04:04:23 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:47661 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232462AbhGaIDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 04:03:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id AD67E2B01381;
        Sat, 31 Jul 2021 04:03:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 31 Jul 2021 04:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=HaF70jJIwVgzmQByN2MvzfEuB4C
        s9uu4puwwbbsEWXw=; b=ip8Zjpp4kk00bDvde12tpXFrWj0X4lVgrydAqKkTAjT
        h9URjOHRfTjL7DIAr5cpe5JplyV5UAnC+glL2m3hPIbchgsw2UfoSyNacOjNxRWP
        M49SkMwrPdH0UadqcSyOivFkkB0H6gt27b2yLVg9oVNMA366LiWU/1/sXA/dYW1q
        wvzNncf8r9AyVTknFRVp4LUI3/DSaD6PYAPmc/7lJ8thVNbHlEcIyZFjfrj6/SM0
        zmYIND8ED8YFuDcbTCrCfC4Sn2rfJfRubuYDWOgz1Exm5I+eLpKRVFd8PL4Uao+n
        Ia0KMjckOHCt5oEJyXLWBBxJoa4Ut+mqvzvnQd6HZTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HaF70j
        JIwVgzmQByN2MvzfEuB4Cs9uu4puwwbbsEWXw=; b=cOXjQgJ+LZFOUBUQ64WiZ9
        6d3lpXS1wQrsTMQupnbwQY9A/BJ441TxcmjURvDcCZdNhnoVUw++5Gzut/rKGwe6
        G/g6S3k6/OVHhEp1xW9XkGds1nkzVzp93R4hgJELe6nrLTpL2eOW8gR6h4UzM8sK
        p08x4X46dyt5iZ+GMtZGFBdFSK3FLTlOR7d9dnnOtrclh/A9onoOoKJhRWlVD9+I
        qptKNmVhYceSwzFN02NvtZ3E7M8NEnlM/6zlSlYUZaLJ1EtQ/6Unql45wgmsee4y
        O6ezVGKreStnjVf8KtirC881XTl2m1ETMSieJBJVFKpszx7Axz1+jI1/65i0Vq4w
        ==
X-ME-Sender: <xms:tQMFYbc7XnpDjHqYDpm5ZoFskQIBFtQ4gAUalQtTLC-HXmJsY6rjiw>
    <xme:tQMFYRPzb8pKhsx4Zx_q98f5eY5hGX_J6EgNBY5oRICXAg-Rx14p7m5taLz6rEqHy
    2YVvFUsBEP0Tw>
X-ME-Received: <xmr:tQMFYUjp8UyyvXUEV4lsC6aCwrSlboloFxQE8UZoxLOc60lA-3r55oEFBmRIdpzpq-Vr6bM1-9k6hf8nmv4Fmjl5PHEutNNv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheeigdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedutdeivd
    ejgedufffgvdfhtdejuefghfehvdejhefggfeludeugfefkeegvdelhfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tQMFYc9v2t0KGttYcJMOb3ctEelF6MYjebdTCgz2-c5fKgnpJDr8yA>
    <xmx:tQMFYXtZjYcvDF0BS62NIjjDVX7v-aFua_Zmu5bVIG0de66p3ggpXg>
    <xmx:tQMFYbE33l3qd3Qg2RHhReP_t8hFbiS93S4uy_4rHWVwuJ_1kIWqHA>
    <xmx:tgMFYQ_IqByBo7m0m_9TQKBjbCFTH3oI6VBqfaD1zXzAjE99RhAhzvbBFZc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jul 2021 04:03:01 -0400 (EDT)
Date:   Sat, 31 Jul 2021 10:02:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH V2] cfg80211: Fix possible memory leak in function
 cfg80211_bss_update
Message-ID: <YQUDsiFItvqsVxdz@kroah.com>
References: <20210628132334.851095-1-phind.uet@gmail.com>
 <YQKELjKuAQsjmpLY@kroah.com>
 <877dh6dimf.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dh6dimf.fsf@tynnyri.adurom.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 10:53:28AM +0300, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Mon, Jun 28, 2021 at 09:23:34PM +0800, Nguyen Dinh Phi wrote:
> >> When we exceed the limit of BSS entries, this function will free the
> >> new entry, however, at this time, it is the last door to access the
> >> inputed ies, so these ies will be unreferenced objects and cause memory
> >> leak.
> >> Therefore we should free its ies before deallocating the new entry, beside
> >> of dropping it from hidden_list.
> >> 
> >> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
> 
> [...]
> 
> > Did this change get lost somewhere?
> 
> Johannes applied it to the macc80211 tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=f9a5c358c8d26fed0cc45f2afc64633d4ba21dff
> 
> Ah, and it's already in Linus' tree as well.

Ah, thanks, I had missed that it just landed there.

greg k-h
