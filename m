Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F635027D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhCaOiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbhCaOiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:38:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EEBC06174A
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:38:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w18so22692228edc.0
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0v3tO8WIVOu3cbWCEHO7EWG9rbszGj09tVtwGQ2u48=;
        b=INkoj9BwuZXkzj7sifj66MsgCXXWy3vXWevwiRC7rleg4ICwFcQXUyosm4ihnob25Z
         DfDIx5MVnO5DYfDmqvyRhhVn2eR8d8ftwqixz0sT20gZWzCsWOUe/aoQG2c6/Q6tmGH+
         YDCpIxnNZqYZhAmkwLMEet6Wgrb8r9DyhIKV73wK/tA+Bo3PxGZd5EoGMN2mAqTq2RXZ
         SItPzmoMCV/ocg9XNCDl0oGTg28rLhjjsOEIiZMSYlU7u8Xl+/dubyoD8/C54HFDuSRt
         OaFZ05JUUF2nINRx6OSYhjVki4amAOtENRF0VakR6TC3Yu6LAuwPFmgQenZO2vER5zpl
         aFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0v3tO8WIVOu3cbWCEHO7EWG9rbszGj09tVtwGQ2u48=;
        b=ibjHahju3ds+h/My3WnrHo5lUNl5Hj6zbFjIsDAYv5qRS+POEfQX6z8Ot+8co60V75
         okQTQtbgXF4LMFvw57VsDoP5JG+iRwGySzIRT9LCP28kBr6V+Y+bkg4jMg33Yp082Kwy
         64C18qrQj9sNeSgz2u+VyiDPFwVclZyMzRnoJIbnmjb7qFpsnwUczX/I+whh4ysNzYCL
         cfGiBUdH7+83hW2SBIQ7SgDjQZ9TYUnOIoQLhHeIJZOR6DtT0GN+Q0OOPUV5gVwf88CG
         TSgg57YvY22JcPSWm1rEcwGDwbI2qXATpJCdm7ci5uxv1roD6mDUV0GjCNVL5kFFajF1
         sQ+w==
X-Gm-Message-State: AOAM5326bZLQeCYdPaMm/URkklb3WBWrZAALd/vv1y4noKsvmsy1Zk13
        QLhNs31YwtYb3XkByrcUvluokSEQ9SgUipSVzEKC
X-Google-Smtp-Source: ABdhPJyuVH4uhYsCsfz9A35iRVq47A0bNBHoLadKLLbXfwa65wg7f400ZenSxaRizbI1OEn6gVbiThn7HQ9rJqWPoSk=
X-Received: by 2002:a05:6402:180b:: with SMTP id g11mr4039186edy.195.1617201484431;
 Wed, 31 Mar 2021 07:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-2-xieyongji@bytedance.com>
 <20210331091545.lr572rwpyvrnji3w@wittgenstein> <CACycT3vRhurgcuNvEW7JKuhCQdy__5ZX=5m1AFnVKDk8UwUa7A@mail.gmail.com>
 <20210331122315.uas3n44vgxz5z5io@wittgenstein> <CACycT3vm_XvitXV+kXivAhrfwN6U0Nm5kZwcYhY+GrriVAKq8g@mail.gmail.com>
 <20210331140759.rxfpfcavzus3lomp@wittgenstein>
In-Reply-To: <20210331140759.rxfpfcavzus3lomp@wittgenstein>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 31 Mar 2021 22:37:55 +0800
Message-ID: <CACycT3vnmobQTPqENTwE_4idUzurgQzmcpMnsPSNzZb8=WYYbg@mail.gmail.com>
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

On Wed, Mar 31, 2021 at 10:08 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Wed, Mar 31, 2021 at 09:59:07PM +0800, Yongji Xie wrote:
> > On Wed, Mar 31, 2021 at 8:23 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > On Wed, Mar 31, 2021 at 07:32:33PM +0800, Yongji Xie wrote:
> > > > On Wed, Mar 31, 2021 at 5:15 PM Christian Brauner
> > > > <christian.brauner@ubuntu.com> wrote:
> > > > >
> > > > > On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> > > > > > Export receive_fd() so that some modules can use
> > > > > > it to pass file descriptor between processes without
> > > > > > missing any security stuffs.
> > > > > >
> > > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > > ---
> > > > >
> > > > > Yeah, as I said in the other mail I'd be comfortable with exposing just
> > > > > this variant of the helper.
> > > >
> > > > Thanks, I got it now.
> > > >
> > > > > Maybe this should be a separate patch bundled together with Christoph's
> > > > > patch to split parts of receive_fd() into a separate helper.
> > > >
> > > > Do we need to add the seccomp notifier into the separate helper? In
> > > > our case, the file passed to the separate helper is from another
> > > > process.
> > >
> > > Not sure what you mean. Christoph has proposed
> > > https://lore.kernel.org/linux-fsdevel/20210325082209.1067987-2-hch@lst.de
> > > I was just saying that if we think this patch is useful we might bundle
> > > it together with the
> > > EXPORT_SYMBOL(receive_fd)
> > > part here, convert all drivers that currently open-code get_unused_fd()
> > > + fd_install() to use receive_fd(), and make this a separate patchset.
> > >
> >
> > Yes, I see. We can split the parts (get_unused_fd() + fd_install()) of
> > receive_fd() into a separate helper and convert all drivers to use
> > that. What I mean is that I also would like to use
> > security_file_receive() in my modules. So I'm not sure if it's ok to
> > add security_file_receive() into the separate helper. Or do I need to
> > export security_file_receive() separately?
>
> I think I confused you which is my bad. What you do here is - in my
> opinion - correct.
> I'm just saying that exporting receive_fd() allows further cleanups and
> your export here could go on top of Christoph's change in a separate
> series.
>

Oh, I get you now! I'm glad to do that.

Thanks,
Yongji
