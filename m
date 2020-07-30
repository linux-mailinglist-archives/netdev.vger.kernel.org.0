Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421DF23392B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgG3Tjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgG3Tjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:39:52 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9D6C061574;
        Thu, 30 Jul 2020 12:39:52 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id n141so12854885ybf.3;
        Thu, 30 Jul 2020 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TL91OFsbW6CpAgMDF7roOTLMqqvCnVNJ85XQj3M3+w=;
        b=G5sWAqT6a78ycsALH20XGq/U/j0W3S+Cgam28Q7O+ETiV7XU5HBSQnLQIjzqv/F0iL
         FOhgTsMGcFR4i1NzRT/b6lsLcW7ScPIVH7rNxsrBxEpYqNYucNpebyvu+R3gJl5s14UZ
         6xdjSyHjyqgmRPiwdKWp79eWrCi6Kcik00VHrLijmylDUcap656DsPjhXoZEA6DD+JNG
         NZk0HEM1DI1xq3XCjFUF6U1q+DVSFVwN/cj/sPN3A1x5rbp3FowDFeLtsdfMupleVlr2
         JjidEpSJ8pd6WD+wapoBKCGBZ+fwW1/7JB16hoSbEBRIn0gWoyb3DezQL/UX0urRXiqx
         yV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TL91OFsbW6CpAgMDF7roOTLMqqvCnVNJ85XQj3M3+w=;
        b=LLDzvAzymZ9DOqREN2PuXD6w2iq9VpBHoNP4tHjTy8P7BtXd3ttwefIat6oOCfxLhg
         Jziz7921psRtkr1/XFC0BXaibZkw65l7HWCOhH21VCLaSqX1inW8/GPfNiBnDEE8oJqB
         tFOLOGPPPLmAQqtWccoHeWRCB8rHQWByLfutOvCUuy6KXS6BrYsCgkcw+cg0/b+rrBKm
         9BydsPOaIhaEZIOYiunGFbzUbFchNoJKh/14aVck/FB9iGqdrs/wRZGSJ4k5koyP+36f
         UY/Rlrux7RTxdH1lofbpiopMkVs51i+9URT8C8f+FFnY5kBQwkie6WSTJ2vvBARMRXxD
         FGpw==
X-Gm-Message-State: AOAM5304szvrIAGV4YtymDQHE+J+vjTzWXZJn6MXlJAB0IgAwuafBok6
        Vt5qUrvKWyAMkuZD6cH6rWgPcTWSSY5houEM9YE=
X-Google-Smtp-Source: ABdhPJylJzV1bWJOD2Mn4vqOEK+5YuzuxGuPPndvpK0NsyEq//FbylkViIVDABRew3ThSJmNxEAJFgIjibfl2igIIXk=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr669331ybg.459.1596137992019;
 Thu, 30 Jul 2020 12:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
 <20200727231538.GA352883@carbon.DHCP.thefacebook.com> <CAEf4BzamC4RQrQuAgH1DK-qcW3cKFuBEbYRhVz-8UMU+mbTcvA@mail.gmail.com>
 <20200730013836.GA637520@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200730013836.GA637520@carbon.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 12:39:40 -0700
Message-ID: <CAEf4BzaZhyus7Kd-08vrVW9sr6gHGj1mCBgUY-NCWUOfdEJgHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 6:38 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Jul 27, 2020 at 10:59:33PM -0700, Andrii Nakryiko wrote:
> > On Mon, Jul 27, 2020 at 4:15 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Mon, Jul 27, 2020 at 03:05:11PM -0700, Andrii Nakryiko wrote:
> > > > On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > > > As bpf is not using memlock rlimit for memory accounting anymore,
> > > > > let's remove the related code from libbpf.
> > > > >
> > > > > Bpf operations can't fail because of exceeding the limit anymore.
> > > > >
> > > >
> > > > They can't in the newest kernel, but libbpf will keep working and
> > > > supporting old kernels for a very long time now. So please don't
> > > > remove any of this.
> > >
> > > Yeah, good point, agree.
> > > So we just can drop this patch from the series, no other changes
> > > are needed.
> > >
> > > >
> > > > But it would be nice to add a detection of whether kernel needs a
> > > > RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> > > > detect this from user-space?
>
> Btw, do you mean we should add a new function to the libbpf API?
> Or just extend pr_perm_msg() to skip guessing on new kernels?
>

I think we have to do both. There is libbpf_util.h in libbpf, we could
add two functions there:

- libbpf_needs_memlock() that would return true/false if kernel is old
and needs RLIMIT_MEMLOCK
- as a convenience, we can also add libbpf_inc_memlock_by() and
libbpf_set_memlock_to(), which will optionally (if kernel needs it)
adjust RLIMIT_MEMLOCK?

I think for your patch set, given it's pretty big already, let's not
touch runqslower, libbpf, and perf code (I think samples/bpf are fine
to just remove memlock adjustment), and we'll deal with detection and
optional bumping of RLIMIT_MEMLOCK as a separate patch once your
change land.


> The problem with the latter one is that it's called on a failed attempt
> to create a map, so unlikely we'll be able to create a new one just to test
> for the "memlock" value. But it also raises a question what should we do
> if the creation of this temporarily map fails? Assume the old kernel and
> bump the limit?

Yeah, I think we'll have to make assumptions like that. Ideally, of
course, detection of this would be just a simple sysfs value or
something, don't know. Maybe there is already a way for kernel to
communicate something like that?

> Idk, maybe it's better to just leave the userspace code as it is for some time.
>
> Thanks!
