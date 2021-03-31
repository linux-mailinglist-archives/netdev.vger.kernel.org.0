Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318563501CA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhCaN7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbhCaN7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:59:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6267C06175F
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:59:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so30181633ejo.13
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghwcCn9upZo2ScDVOGrOotVx0dDg7jQeJeG/I9cIPPU=;
        b=vav4qwDMP7i6EjFBmJn6551WnKNbAVSoVqU8Z6vejfTYXV3iFII7fDe2WExeA2RqIE
         bM0wcMOanXWeLSY/nP0Do802ZmKO/aUAHizmV0KSHY/TC35KvM6J529BYc3Ka5q5oIg2
         JJ0Dx8PRWRPm1KNIxfQvbITACKqd/Y6JEK49c8tWJIE6tfF6boqcbVW+HWfls+Lp2Z00
         aA0h6jX4e2O1hDWbFzomMcDWmFxBBdpbnH2EeFhj9grLKotics7yHAfigpEwqxdlab+7
         C4ZcVQgjB7QD4+1MiKiGV0biSoNHR8mHUKfo3B1T5f9CG3TCZCgCB/Lgn/JHdfWgO5xa
         Zowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghwcCn9upZo2ScDVOGrOotVx0dDg7jQeJeG/I9cIPPU=;
        b=htbt9I5Vtsr0HcPLeRVXg7JevOha4ccleijZSCQYogijjbZ9LpxHWo8zzwXLKFL/xr
         mAnp+BvCK0++Bx7JCbCp+aPEnnn3Rv2zT/roDAL/s1jPo8/zOOJQM/KiszuP/B28qvyI
         7wX/nX9qFoL6+erCrfJ6+/volt3QMQhyzSE63tVMVi+mHyERJVzTerVoQuuO888iWjiT
         Mru3A/M4SKPsKQqv7gYF9m1y92Pe9d5w5JP+m8m1UK0Nh6CDZp9dhUJw1sixIZ1wYAX9
         V5WzZvDoJPyWueJ5LmuTTSVPbsb+ip7v7zU2TUx+jjsaTwR1OBoA7BL3yzdwsRof/j2k
         1AcQ==
X-Gm-Message-State: AOAM533WBg0tacaZoXBv7f7KT1OMn4h6Fxe7TLxwJ+FZh6NqvUVir78X
        UTQqR1MUTClPTIQGNVuzYHfjALxqPnDh1wTjM4gs
X-Google-Smtp-Source: ABdhPJy1F+1dndmaWxm19LJTyn2LKz2YWhIRQirh52O3KYWsmxmJWiuRe+aQHvYGuBIKQa4hIAktI/HirP2Vh0GTAVU=
X-Received: by 2002:a17:906:86c6:: with SMTP id j6mr3559138ejy.197.1617199157271;
 Wed, 31 Mar 2021 06:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-2-xieyongji@bytedance.com>
 <20210331091545.lr572rwpyvrnji3w@wittgenstein> <CACycT3vRhurgcuNvEW7JKuhCQdy__5ZX=5m1AFnVKDk8UwUa7A@mail.gmail.com>
 <20210331122315.uas3n44vgxz5z5io@wittgenstein>
In-Reply-To: <20210331122315.uas3n44vgxz5z5io@wittgenstein>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 31 Mar 2021 21:59:07 +0800
Message-ID: <CACycT3vm_XvitXV+kXivAhrfwN6U0Nm5kZwcYhY+GrriVAKq8g@mail.gmail.com>
Subject: Re: Re: [PATCH v6 01/10] file: Export receive_fd() to modules
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 8:23 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Wed, Mar 31, 2021 at 07:32:33PM +0800, Yongji Xie wrote:
> > On Wed, Mar 31, 2021 at 5:15 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> > > > Export receive_fd() so that some modules can use
> > > > it to pass file descriptor between processes without
> > > > missing any security stuffs.
> > > >
> > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > ---
> > >
> > > Yeah, as I said in the other mail I'd be comfortable with exposing just
> > > this variant of the helper.
> >
> > Thanks, I got it now.
> >
> > > Maybe this should be a separate patch bundled together with Christoph's
> > > patch to split parts of receive_fd() into a separate helper.
> >
> > Do we need to add the seccomp notifier into the separate helper? In
> > our case, the file passed to the separate helper is from another
> > process.
>
> Not sure what you mean. Christoph has proposed
> https://lore.kernel.org/linux-fsdevel/20210325082209.1067987-2-hch@lst.de
> I was just saying that if we think this patch is useful we might bundle
> it together with the
> EXPORT_SYMBOL(receive_fd)
> part here, convert all drivers that currently open-code get_unused_fd()
> + fd_install() to use receive_fd(), and make this a separate patchset.
>

Yes, I see. We can split the parts (get_unused_fd() + fd_install()) of
receive_fd() into a separate helper and convert all drivers to use
that. What I mean is that I also would like to use
security_file_receive() in my modules. So I'm not sure if it's ok to
add security_file_receive() into the separate helper. Or do I need to
export security_file_receive() separately?

Thanks,
Yongji
