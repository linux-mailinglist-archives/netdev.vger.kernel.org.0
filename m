Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A354C1CEB45
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgELDQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728564AbgELDQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:16:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81AFC061A0C;
        Mon, 11 May 2020 20:16:36 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z80so6711253qka.0;
        Mon, 11 May 2020 20:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIFX7kmG2/Q3MDiSfvpMuV5jMlA8i4sGq+DYN+oNW2A=;
        b=swVsrBgY/qAerqcHjlkYlCe0b3fXy2KAwithmRb46YSQO5osRsj3f/26Bj6WhrEgkX
         XWqzZOPxB7baP+rRNZrw0qZcl8/5OoOhOZToN95JV3ZPH//CL4WV/D5weuKe1pLdjn0/
         gSPIZaItgHv7gLovzA459WWHGugC8EQglLS3qDnRok6tU1Ylpb9z/SPFX8gndHdnuMNc
         yDyMhLUgUrZvIDzdk1ZrN5ZfBhsgsc3nOzewsOHJfSDydDMMekIK84Lj/r7X8VU3vCir
         xLQ9OXMWvGfhppwey1x4VYiZMdrA5SnSPLTuc7luIj+1Dtk/LXJofcbBUCIrF4U3jsw9
         vEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIFX7kmG2/Q3MDiSfvpMuV5jMlA8i4sGq+DYN+oNW2A=;
        b=rUlY/wEkaq9THtkic9+uO19/Ncve81RDcysUvzPf/QyOW6ao7gjvnuqsNxav8c860o
         oLqPmvHAqqRW2ZWjQxBzZRAzsDA7JgNf9fFJTnP+fNqu3NT/lN/21y7to3Xag+TrAwO9
         hUO3OU5rYe/sBbpemx3kWahioPoTxtrc2dTVkw1qwvh5zoD518+fZB+0fxdbmub/szp/
         8gbX3wf/I3OuIDUpI3PTbhXydiuq+HLChvwY3tHUPSt3MMoJW28N1YDYHC1S6KhnmXWU
         oNFeBE7WURYL9geFPZgxK87H5Yg4Xb4zC8Ji6E1WJhLpTEzi6UlfPUMdvuQEj9j2y5bF
         nBFQ==
X-Gm-Message-State: AGi0PuZB10uDQoG8kCBGb0Jy7rg7Q2u7KDoJVgSr5/FFyEC+vgr5JnnM
        xPlsqAJZIxqIZNs9f7pYIXcFyW6uPAyVsfu4QnI=
X-Google-Smtp-Source: APiQypJZuu8e69wpV+nOcpVW045faO5OuigqlwaSDBzXPQIdNkYmqpvvBQ3HyazRlganXX5U8kwdTR8011XLQSMqa5A=
X-Received: by 2002:a37:68f:: with SMTP id 137mr19087682qkg.36.1589253396160;
 Mon, 11 May 2020 20:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053924.1543103-1-yhs@fb.com>
 <CAEf4BzZ1vD_F74gy5mx_s8+cbw4OuZwJxpW36CijE-RWxOf__g@mail.gmail.com> <a847e0ef-2308-ebf1-ca21-f30372fa2678@fb.com>
In-Reply-To: <a847e0ef-2308-ebf1-ca21-f30372fa2678@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 May 2020 20:16:25 -0700
Message-ID: <CAEf4Bza1yqHfLKWDDksG4owobM8M_0pqhTORgKprMuGZiOSj=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/21] bpf: implement common macros/helpers
 for target iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 8:18 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/8/20 12:07 PM, Andrii Nakryiko wrote:
> > On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Macro DEFINE_BPF_ITER_FUNC is implemented so target
> >> can define an init function to capture the BTF type
> >> which represents the target.
> >>
> >> The bpf_iter_meta is a structure holding meta data, common
> >> to all targets in the bpf program.
> >>
> >> Additional marker functions are called before or after
> >> bpf_seq_read() show()/next()/stop() callback functions
> >> to help calculate precise seq_num and whether call bpf_prog
> >> inside stop().
> >>
> >> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
> >> are implemented so target can get needed information from
> >> bpf_iter infrastructure and can run the program.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h   | 11 ++++++
> >>   kernel/bpf/bpf_iter.c | 86 ++++++++++++++++++++++++++++++++++++++++---
> >>   2 files changed, 92 insertions(+), 5 deletions(-)
> >>
> >
> > Looks good. I was worried about re-using seq_num when element is
> > skipped, but this could already happen that same seq_num is associated
> > with different objects: overflow + retry returns different object
> > (because iteration is not a snapshot, so the element could be gone on
> > retry). Both cases will have to be handled in about the same fashion,
> > so it's fine.
>
> This is what I thought as well.
>
> >
> > Hm... Could this be a problem for start() implementation? E.g., if
> > object is still there, but iterator wants to skip it permanently.
> > Re-using seq_num will mean that start() will keep trying to fetch same
> > to-be-skipped element? Not sure, please think about it, but we can fix
> > it up later, if necessary.
>
> The seq_num is for bpf_program context. It does not affect how start()
> behaves. The start() MAY retry the same element over and over again
> if show() overflows or returns <0, but in which case, user space
> should check the return error code to decide to retry or give up.

ah, right seq_num vs internal id, makes sense, never mind :)

>
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > [...]
> >
> >> @@ -112,11 +143,16 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> >>                          err = PTR_ERR(p);
> >>                          break;
> >>                  }
> >> +
> >> +               /* get a valid next object, increase seq_num */
> >
> > typo: get -> got
>
> Ack.
>
> >
> >> +               bpf_iter_inc_seq_num(seq);
> >> +
> >>                  if (seq->count >= size)
> >>                          break;
> >>
> >>                  err = seq->op->show(seq, p);
> >>                  if (err > 0) {
> >> +                       bpf_iter_dec_seq_num(seq);
> >>                          seq->count = offs;
> >>                  } else if (err < 0 || seq_has_overflowed(seq)) {
> >>                          seq->count = offs;
> >
> > [...]
> >
