Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874FE309079
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhA2XNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhA2XNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:13:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCCDC061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:13:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id md11so6562494pjb.0
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enD4craQAIRxwqu7dors3eF10cWwOOY308c/j556Nqo=;
        b=DhOVFtQp+zxIptwE/rr0X/hrtn8NqnAiIAAN8KsEc6RWmw5VJ7wDaq427KdrYXq3kY
         xnywJTdiC2+7pPsdGzTkeXofCTz03CfkPY4ztumi58m2SA62n8S7xIH912fKrCSr4C2y
         j7cSrkd4xqt5tw36qojz625q49jgB8KKzBmMOCohNJCg0tPrLZMi1XGHVWQCzNITl0Th
         wZqmHIxrisDNImj9OV3UtlBdTe59MUyqkUq9nAG4Go9mBRtYQOuhVCubL9QqtAyiwT6b
         Q5qhUDhHPJudCTtTReIRIgCVU7s6n/qFHc5kcdHxfnXEXgz4G2dXaOyNloMROAWAZMg2
         I8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enD4craQAIRxwqu7dors3eF10cWwOOY308c/j556Nqo=;
        b=rJrHncjX2GOmf4MXuJn6zCYRfBVYIbqQgn3Dbbw6P255UwNdF+EmSrSj86fUWI59w2
         VjCCUEzmBT8Fh0Wgnu2U6RVSfKg1pwVCEvMM5hzsHmypl/bLV4od66ShzQIJQf4wNlIL
         2ppXh89ACtMhdGIRzWZHAHhvstEl4Jbv9i5grpfn/cmB6zwLnt1KwkM1GFcTbLZeE6f5
         1vm7/oEtihJ2XP5GdOIYqHH/cQSKRbIcPKpFxZ+SocTWQO4ILA4ta3UudoOwPDaoC2uW
         91F0oxUXd8/GY41cJTdlCMISMbJ0jCwar9Nx7bObvEJq5vOwopyLS5eGZ2CrwJ+pd779
         44aA==
X-Gm-Message-State: AOAM53397Bghu136nxbycPXPvjhv7EkFnv60U9SgRrI6z0IFoH9XPqEg
        cfJOBngPJFFKmKpHQP69umtj4ym+pPx0k8byxls=
X-Google-Smtp-Source: ABdhPJw6K6Rd4U5YaB70dYCh8UPXfNlrGMoz6bSqXwI/jdYfIWfrAp5NLa42sNlH0xfrLFbl6/LQ1hAf/gbbHAaFaoE=
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr6917830pjh.52.1611961990549;
 Fri, 29 Jan 2021 15:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
 <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com>
 <20210128212130.6bda5d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpUGR1OjeEcsFqkeZZRHDkiQ=+=OiSAB8EgzxG9Dh-5c5w@mail.gmail.com> <20210129100007.4dd35815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129100007.4dd35815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Jan 2021 15:12:59 -0800
Message-ID: <CAM_iQpWxTVQ01NqR8CGuWK6H_YKPS7FNWHgs=07XQEkw=Wu7KQ@mail.gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 10:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 Jan 2021 21:47:04 -0800 Cong Wang wrote:
> > On Thu, Jan 28, 2021 at 9:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 28 Jan 2021 21:08:05 -0800 Cong Wang wrote:
> > > > On Thu, Jan 28, 2021 at 12:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:
> > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > >
> > > > > > dev_ifsioc_locked() is called with only RCU read lock, so when
> > > > > > there is a parallel writer changing the mac address, it could
> > > > > > get a partially updated mac address, as shown below:
> > > > > >
> > > > > > Thread 1                      Thread 2
> > > > > > // eth_commit_mac_addr_change()
> > > > > > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> > > > > >                               // dev_ifsioc_locked()
> > > > > >                               memcpy(ifr->ifr_hwaddr.sa_data,
> > > > > >                                       dev->dev_addr,...);
> > > > > >
> > > > > > Close this race condition by guarding them with a RW semaphore,
> > > > > > like netdev_get_name(). The writers take RTNL anyway, so this
> > > > > > will not affect the slow path.
> > > > > >
> > > > > > Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> > > > > > Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> > > > > > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > The addition of the write lock scares me a little for a fix, there's a
> > > > > lot of code which can potentially run under the callbacks and notifiers
> > > > > there.
> > > > >
> > > > > What about using a seqlock?
> > > >
> > > > Actually I did use seqlock in my initial version (not posted), it does not
> > > > allow blocking inside write_seqlock() protection, so I have to change
> > > > to rwsem.
> > >
> > > Argh, you're right. No way we can construct something that tries to
> > > read once and if it fails falls back to waiting for RTNL?
> >
> > I don't think there is any way to tell whether the read fails, a partially
> > updated address can not be detected without additional flags etc..
>
> Let me pseudo code it, I can't English that well:
>
> void reader(obj)
> {
>         unsigned int seq;
>
>         seq = READ_ONCE(seqcnt);
>         if (seq & 1)
>                 goto slow_path;
>         smb_rmb();
>
>         obj = read_the_thing();
>
>         smb_rmb();
>         if (seq == READ_ONCE(seqcnt))
>                 return;
>
> slow_path:
>         rtnl_lock();
>         obj = read_the_thing();
>         rtnl_unlock();
> }
>
> void writer()
> {
>         ASSERT_RNTL();
>
>         seqcnt++;
>         smb_wmb();
>
>         modify_the_thing();
>
>         smb_wmb();
>         seqcnt++;
> }
>
>
> I think raw_seqcount helpers should do here?

Not sure why you want to kinda rewrite seqlock here. Please see below.

>
> > And devnet_rename_sem is already there, pretty much similar to this
> > one.
>
> Ack, I don't see rename triggering cascading notifications, tho.
> I think you've seen the recent patch for locking in team, that's
> pretty much what I'm afraid will happen here.

Right, I should make only user-facing callers (ioctl, rtnetlink) use this
writer semaphore, and leave other callers of dev_set_mac_address()
untouched. Something like:

dev_set_mac_address_locked(...)
{
  down_write(&dev_addr_sem);
  dev_set_mac_address(...);
  up_write(&dev_addr_sem);
  ...
}

With this, we don't need to reinvent seqlock.

>
> But if I'm missing something about the seqcount or you strongly prefer
> the rwlock, we can do that, too. Although I'd rather take this patch
> to net-next in that case.

I have no problem with applying to net-next. I will send v2 targeting
net-next instead.

Thanks.
