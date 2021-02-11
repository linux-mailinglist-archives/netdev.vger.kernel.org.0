Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300C6319325
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBKTcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhBKTcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:32:10 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D08C0613D6;
        Thu, 11 Feb 2021 11:31:30 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p186so6746222ybg.2;
        Thu, 11 Feb 2021 11:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2hqDBYN7cQp7+g4S9dE/2ZF4z47f6o1qL/EGha7wOU=;
        b=uVhId0RBVVZBUZ1tvS4fZPBSDZuNAmO6t3ieIx5KdOQxjORG4DjfzVRYi/O/DsMiKa
         KGo+eoduaecDYzAer2tRaDe0QT58Iw2ZHCoWD5a4Jd9D1X5Z2EXoXlk2KvRoG9tHzAfQ
         GqIvinB9k6RPxjxPS1h27aFiKkMyvjB3sTJTu/EGzB5VPHFvnXq2Bemndp1gyr6nMgZR
         K3u6CjRLw4oPMscShwUh4e6Y1PhAj5jzLHOdRyYMA0LkAlGz/F3dawGB4IbmRj83sE+z
         7mARDq/uaTp7HLFYd4yke+qi80Po28FerC/3+7pY7gpx8/B1zj2/eELPNYd9+goPFZX4
         w+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B2hqDBYN7cQp7+g4S9dE/2ZF4z47f6o1qL/EGha7wOU=;
        b=ZRTQU2HmehU5p3kAaobm7wDQBAHKkmM1qkxlUiwWFQE+as0W6thZWr6TJKrA6fnSjf
         QJOKkFMZsPwKH7AirWZoKqPzRh3XIQ/pRlJPxapJZaOO80jkOd0fyw0MMHkNa6tFIpul
         Yz/XEigtNMomevMGusWYCy4vXPQwDAcjtkkyiUVIwsPdT+0DCRv5s4y1A2JeJLJ96mBZ
         HlLw/hVvL4uRMl5qYqtGc3im1rCo4RLXoVMFwkVZqm6+SrIUjdThkkDYi4KpA6Vg4yan
         iR6HUnUE4cd9SJuNm0c0wgTjTaHQaSjjSahfTmlyv1sTyJcgY29HHvklN99ONejc9nO0
         5TAA==
X-Gm-Message-State: AOAM532b2VyRgULuGofCPsm/7MeeyFtkCrWZVrrvl/mUlthCm9Ka2b9K
        nCQCXqCaBXtLq6/TpKQdW8OT84G3f9dA7Oevb9RhbvZjJLw=
X-Google-Smtp-Source: ABdhPJy78OQm4nyMwLkArXdnJ8o62AmyO81Sr2NdyRnwWmktcXYQZew7pk0Yv4UbrTMOgUCxcsakkmJPFvbIUuEhtWY=
X-Received: by 2002:a25:3805:: with SMTP id f5mr13518485yba.27.1613071889515;
 Thu, 11 Feb 2021 11:31:29 -0800 (PST)
MIME-Version: 1.0
References: <20210209193105.1752743-1-kafai@fb.com> <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
 <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com>
 <20210211015510.zd7tn6efiimfel3v@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza_cNDTuu8jQ3K4qeb3e_nMEasmGqZqePy4B=XJqyXuMg@mail.gmail.com> <20210211024201.3uz4yhxfqdzhqa35@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210211024201.3uz4yhxfqdzhqa35@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Feb 2021 11:31:18 -0800
Message-ID: <CAEf4Bzbw7JT8n1j1hCfH2Z+LWQY=w3fGrXNE4He3LR_X_5qsUw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 6:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Feb 10, 2021 at 06:07:04PM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 10, 2021 at 5:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Feb 10, 2021 at 02:54:40PM -0800, Andrii Nakryiko wrote:
> > > > On Wed, Feb 10, 2021 at 1:17 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> > > > > > On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > This patch adds a "void *owner" member.  The existing
> > > > > > > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > > > > > > can be loaded.
> > > > > > >
> > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > ---
> > > > > >
> > > > > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > > > >
> > > > > > What will happen if BPF code initializes such non-func ptr member?
> > > > > > Will libbpf complain or just ignore those values? Ignoring initialized
> > > > > > members isn't great.
> > > > > The latter. libbpf will ignore non-func ptr member.  The non-func ptr
> > > > > member stays zero when it is passed to the kernel.
> > > > >
> > > > > libbpf can be changed to copy this non-func ptr value.
> > > > > The kernel will decide what to do with it.  It will
> > > > > then be consistent with int/array member like ".name"
> > > > > and ".flags" where the kernel will verify the value.
> > > > > I can spin v2 to do that.
> > > >
> > > > I was thinking about erroring out on non-zero fields, but if you think
> > > > it's useful to pass through values, it could be done, but will require
> > > > more and careful code, probably. So, basically, don't feel obligated
> > > > to do this in this patch set.
> > > You meant it needs different handling in copying ptr value
> > > than copying int/char[]?
> >
> > Hm.. If we are talking about copying pointer values, then I don't see
> > how you can provide a valid kernel pointer from the BPF program?...
> I am thinking the kernel is already rejecting members that is supposed
> to be zero (e.g. non func ptr here), so there is no need to add codes
> to libbpf to do this again.
>
> > But if we are talking about copying field values in general, then
> > you'll need to handle enums, struct/union, etc, no? If int/char[] is
> > supported (I probably missed that it is), that might be the only
> > things you'd need to support. So for non function pointers, I'd just
> > enforce zeroes.
> Sure, we can reject everything else for non zero in libbpf.
> I think we can use a different patch set for that?

Sure. My original point was that if someone initialized, say, owner
field with some meaningless number, it would be nice for libbpf to
reject this with error instead of ignoring. It's unlikely, though, so
no big deal.
