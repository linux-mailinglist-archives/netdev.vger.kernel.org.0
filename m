Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B65E568C
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfJYWnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:43:21 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34129 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJYWnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:43:21 -0400
Received: by mail-qk1-f194.google.com with SMTP id f18so3263395qkm.1;
        Fri, 25 Oct 2019 15:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+2E0rH9gnao9G50mrtVlqLqlh+I5+1po+LaLlLD8SKg=;
        b=ow6OD+X+WKKpGgEPtOwjm2qe2G+iKtXkEaqdglb6vq9KOYlI21/+XhUZkOjswgFUBx
         oU14TA5Su22Mp/sl1ZutEiIU/0Iq2lBhKq42x5KXIg9L/xfU7jpziTckvX3NPaZBGilu
         SA472R9szK7nh6vFmfVKdaIZ/WprwD8NwqC4jr166/7yaHoO/rNw6JUFynIchweLR1PA
         QULbd33+afumdcz4IJ+d8phoY17K/vsSrA2vge1EYcRXa7PDt70lz7eR2UYicQ1o9UbA
         F4dip0uha/Isy7b4J6WhiJQP2JTaZAJ2KGETgI6/BozJ0EupM3PASsOxqAoIsHy66Nnv
         Ay3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+2E0rH9gnao9G50mrtVlqLqlh+I5+1po+LaLlLD8SKg=;
        b=K7ehNDjqEzi0157BMze4DNPsZ1TvOaS4jjoYRAJW0x3hc40HNE4p6j4OGP79ik+t8g
         7+jl3zSYCZ5z8G7tgUkkNEUksameNdHha4yp2e9BfAsGYg/9gF5pCqmapenZ7dSpQb/8
         OPy0DZAKSdm9jwStFLofStZ0c4+rO9sb7QM2KeXagiOD1N7OClajEAy5TqBogqDO3Z2M
         I+tCzT8LOBJlC1TLgi3qNXCx37KOxq3R6qjmyZX0wdgFzVZNJ2H0Vwhu0Sx1vN9khZO3
         ENydRW5TKcu+dUJ36EO55mBquqVANOlJUnBRouVgMioKipuJP/81xl3f/DJPjPh6CueE
         AR5Q==
X-Gm-Message-State: APjAAAUkJwbTlnC6ncMhXoJTgLK+d/oZJlOEErasa5VcuxTs7fNAntgc
        s55vQuoueWYRWqj05k8AwZBwS2kESS1wKQBCLieeshf/
X-Google-Smtp-Source: APXvYqwHdfbYgejwUsgPAp1c12ilxYS+VZ4XPhy7iuvoBn5eLwPPsPR2UTTSEji/CBRLcC9l3m3wuPqpU2pT+1OTAUE=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr5318532qka.449.1572043400366;
 Fri, 25 Oct 2019 15:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <8e63f4005c7139d88c5c78e2a19f539b2a1ff988.1572010897.git.daniel@iogearbox.net>
 <CAEf4BzbTKeBabyb3C3Yj5iT8TQC7A7SeUAe=PafaKnqeA4zoVQ@mail.gmail.com> <20191025221530.GD14547@pc-63.home>
In-Reply-To: <20191025221530.GD14547@pc-63.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 15:43:08 -0700
Message-ID: <CAEf4BzbUk31xTyTEZgoZLaQjhgge=KEiR_GX0RnJDUZVaOu44A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] uaccess: Add non-pagefault user-space write function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 3:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Fri, Oct 25, 2019 at 02:53:07PM -0700, Andrii Nakryiko wrote:
> > On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > Commit 3d7081822f7f ("uaccess: Add non-pagefault user-space read functions")
> > > missed to add probe write function, therefore factor out a probe_write_common()
> > > helper with most logic of probe_kernel_write() except setting KERNEL_DS, and
> > > add a new probe_user_write() helper so it can be used from BPF side.
> > >
> > > Again, on some archs, the user address space and kernel address space can
> > > co-exist and be overlapping, so in such case, setting KERNEL_DS would mean
> > > that the given address is treated as being in kernel address space.
> > >
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >
> > LGTM. See an EFAULT comment below, though.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > [...]
> >
> > > +/**
> > > + * probe_user_write(): safely attempt to write to a user-space location
> > > + * @dst: address to write to
> > > + * @src: pointer to the data that shall be written
> > > + * @size: size of the data chunk
> > > + *
> > > + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> > > + * happens, handle that and return -EFAULT.
> > > + */
> > > +
> > > +long __weak probe_user_write(void __user *dst, const void *src, size_t size)
> > > +    __attribute__((alias("__probe_user_write")));
> >
> > curious, why is there this dance of probe_user_write alias to
> > __probe_user_write (and for other pairs of functions as well)?
>
> Seems done by convention to allow archs to override the __weak marked
> functions in order to add additional checks and being able to then call
> into the __ prefixed variant.
>
> > > +long __probe_user_write(void __user *dst, const void *src, size_t size)
> > > +{
> > > +       long ret = -EFAULT;
> >
> > This initialization is not necessary, is it? Similarly in
> > __probe_user_read higher in this file.
>
> Not entirely sure what you mean. In both there's access_ok() check before
> invoking the common helper.

ah, right, if, yeah, never mind then.

>
> > > +       mm_segment_t old_fs = get_fs();
> > > +
> > > +       set_fs(USER_DS);
> > > +       if (access_ok(dst, size))
> > > +               ret = probe_write_common(dst, src, size);
> > > +       set_fs(old_fs);
> > > +
> > > +       return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(probe_user_write);
> > >
> > >  /**
> > >   * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
> > > --
> > > 2.21.0
> > >
