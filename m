Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77A28F91B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391426AbgJOTD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391414AbgJOTD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:03:28 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5808C061755;
        Thu, 15 Oct 2020 12:03:27 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f21so4250291ljh.7;
        Thu, 15 Oct 2020 12:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CyXpjKQXQowVOzd2/NVdHefkoQIV4RLZ1yMexmhPMTI=;
        b=JEbpRsyiwyYuDWMS/jcCy6N0i02nKMRGCxcfuQ7FsZGaHZ8ig/FgApufpAq+X1Eu52
         EUJESVaUCFAM/ojd1FVaYZl//pK6Jtu8iI6nYB/B4v4keFMhnIvT11q0IUzxrN3fzZfL
         Xg9OTv/6MFNKgZXwiqYwZK05MyX19tBDX0l0Y3GDFmHxcPw8lLtyv74YpedhMwMCE1Kq
         t+sKinn2H1LiPADa6SqN6vYJQQRDTlGCLw8OD45umkGadCLHg1XFGkxXZOYOWJmrNlha
         fKHqjf63JfaPU9ltQmoN0ajSu+G3+YGpMP1utWvkMvilxUtp3O/s7BHTv0DULIN857s5
         hBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CyXpjKQXQowVOzd2/NVdHefkoQIV4RLZ1yMexmhPMTI=;
        b=KQdsPN0arkqqKz3W1gRQR7JmaydsSx0X/9CdlAszHDkhYU6RXxv8c2Yy3Se6GWuCaI
         GCm23iegyBO10LQxWEbu9oYRIYoEWu84QVhzA9t15QKlgVzpNMjp71aHcVWwf0fpA9EN
         UzkBiQzk5egKF+0GEzbS1CHPnSkoii3hJvV3/dTsS2vCV9+iYDcGI728rYxWMnIZlp0q
         zvUVghSSBDkURIdApVd1cJsFT89ocNL7jDIoSi82cx5eHcyoVw1NAprclEzkWgVUo5CU
         GmMT5EIkQqGcV1Bnr2uVG4R6hUBnPAaFB2YlybQl1zVfuEyRxzmzpbMkWphr6Vonzfoj
         tcFQ==
X-Gm-Message-State: AOAM5336pTP58gXU1kjg8bhJR1vozLpljC2zoIITWCX844B1F/M4+/np
        hwmZuFNslvtIqQmweNeQZOWRglGyRgZq4mvMHr2vOukyGdo=
X-Google-Smtp-Source: ABdhPJzBhvLFav5bbdU1VvjtQMAvsVFUDlRA1ezc27v9bcUmw3XV+hG4Sy8LmhQ+oHm6DhGf/sDUZCroXUC+WnGJa58=
X-Received: by 2002:a2e:a162:: with SMTP id u2mr70611ljl.283.1602788606206;
 Thu, 15 Oct 2020 12:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201014091749.25488-1-yuehaibing@huawei.com> <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com> <20201015115643.3a4d4820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015115643.3a4d4820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Oct 2020 12:03:14 -0700
Message-ID: <CAADnVQLVvd_2zJTQJ7m=322H7M7NdTFfFE7f800XA=9HXVY28Q@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 11:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Oct 2020 11:53:08 -0700 Alexei Starovoitov wrote:
> > On Thu, Oct 15, 2020 at 9:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 14 Oct 2020 17:17:49 +0800 YueHaibing wrote:
> > > > IF CONFIG_BPFILTER_UMH is set, building fails:
> > > >
> > > > In file included from /usr/include/sys/socket.h:33:0,
> > > >                  from net/bpfilter/main.c:6:
> > > > /usr/include/bits/socket.h:390:10: fatal error: asm/socket.h: No such file or directory
> > > >  #include <asm/socket.h>
> > > >           ^~~~~~~~~~~~~~
> > > > compilation terminated.
> > > > scripts/Makefile.userprogs:43: recipe for target 'net/bpfilter/main.o' failed
> > > > make[2]: *** [net/bpfilter/main.o] Error 1
> > > >
> > > > Add missing include path to fix this.
> > > >
> > > > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > >
> > > Applied, thank you!
> >
> > Please revert. The patch makes no sense.
>
> How so? It's using in-tree headers instead of system ones.
> Many samples seem to be doing the same thing.

There is no such thing as "usr/include" in the kernel build and source trees.

> > Also please don't take bpf patches.
>
> You had it marked it as netdev in your patchwork :/

It was delegated automatically by the patchwork system.
I didn't have time to reassign, but you should have known better
when you saw 'bpfilter' in the subject.
