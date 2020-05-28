Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E11E6962
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405849AbgE1Sem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405831AbgE1Sej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:34:39 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E52C08C5C6;
        Thu, 28 May 2020 11:34:39 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so4068077qkf.9;
        Thu, 28 May 2020 11:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DrK+nlSE8fWyydBa/BxyXKvC67NSQZxVCHU0aPhkfzA=;
        b=i+qwcWWGjVfNAnpXXgA+vCCmiuQTw7bThfut4HpZ/2X6FtCMgCtQiesLYJLyhf3YyJ
         G5oQH4x+DWlsFuCRN8Qt3Zc2ReMAB3x0suEWPZzsbDxaRthTSWlolP6vMSRHW/A8wWTf
         xjghj71+g2h0p5l06ou0mb4bYMMkL4TMpp+ZVvS1F8qAY7qUx5T4hu8js19FJi3+aKhL
         /l2lbRuEmoSF7N5zwCWfsfInjo2G1pV2NH7PGEOOxAJ97KzzcCnN1VU6uQgYLBAjYtYM
         PuqLAdFW1RrDAW47Vg/ErZ8NdsJtyuxv9NjhXJ5ll33Uk//PqfiGth5SZUgpglh0J+J1
         denw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DrK+nlSE8fWyydBa/BxyXKvC67NSQZxVCHU0aPhkfzA=;
        b=gvwTEuENkgsI3PhxxndJJUhWdjEI0ixkjVDYbzu/nYTTPqaO/OWHwqBnNCqsZ4cymo
         yx5oznflfk7cU7T6aXcAXMRHyAGxHKvyRlPxPmNWkW5wHwS6QCkFsi1a2EphQTCKkpIS
         obYjhiWj69ODarIX+qyoYiniJ8PvKEsul+3bRPc/zKXizMzSAisIp/1IewcdDhA88TCN
         /gwqNfL0qR4Yszd8WHIT8jr0IInASGkjGuJLktDZjGvdVrIBr0Jt8dd0l3IUbldGtE2M
         oHasrC36izXJDSrOblY6jaHg7JccgbSpulh5WtKRgP/EiBMA8zdDK7gnGfQt1WuxqvY/
         Yj9Q==
X-Gm-Message-State: AOAM5315qGSKES76EW56gA3u8MJKQPuNRAZXm+bnS2bjNdpxkHeLDCc6
        hU+qOkWf+8q/OuD3n5HLdzrVjwH5WGhmPNAYRLE=
X-Google-Smtp-Source: ABdhPJxHIJaijQGVGt4J7VFlFnpm+fHBMOcm6yDEkhzLyizj/o2AKkKihujlAX+A305iqR/zOFNNocd0RLEffDyRMgc=
X-Received: by 2002:a37:4595:: with SMTP id s143mr4546043qka.449.1590690878252;
 Thu, 28 May 2020 11:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <6561a67d-6dac-0302-8590-5f46bb0205c2@linux.alibaba.com>
 <CAEf4BzYwO59x0kJWNk1sfwKz=Lw+Sb_ouyRpx8-v1x8XFoqMOw@mail.gmail.com> <9a78329c-8bfe-2b83-b418-3de88e972c5a@linux.alibaba.com>
In-Reply-To: <9a78329c-8bfe-2b83-b418-3de88e972c5a@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 11:34:25 -0700
Message-ID: <CAEf4BzYHFAbOeVbs8Y2j5HjYOavDC+M+HtOst69Qtm2h5A3M=A@mail.gmail.com>
Subject: Re: [RFC PATCH] samples:bpf: introduce task detector
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 1:14 AM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.=
com> wrote:
>
> Hi, Andrii
>
> Thanks for your comments :-)
>
> On 2020/5/28 =E4=B8=8B=E5=8D=882:36, Andrii Nakryiko wrote:
> [snip]
> >> ---
> >
> > I haven't looked through implementation thoroughly yet. But I have few
> > general remarks.
> >
> > This looks like a useful and generic tool. I think it will get most
> > attention and be most useful if it will be part of BCC tools. There is
> > already a set of generic tools that use libbpf and CO-RE, see [0]. It
> > feels like this belongs there.
> >
> > Some of the annoying parts (e.g., syscall name translation) is already
> > generalized as part of syscount tool PR (to be hopefully merged soon),
> > so you'll be able to save quite a lot of code with this. There is also
> > a common build infra that takes care of things like vmlinux.h, which
> > would provide definitions for all those xxx_args structs that you had
> > to manually define.
> >
> > With CO-RE, it also will allow to compile this tool once and run it on
> > many different kernels without recompilation. Please do take a look
> > and submit a PR there, it will be a good addition to the toolkit (and
> > will force you write a bit of README explaining use of this tool as
> > well ;).
>
> Aha, I used to think bcc only support python and cpp :-P
>

libbpf-tools don't use BCC at all, they are just co-located with BCC
and BCC tools in the same repository and are lightweight alternatives
to BCC-based tools. But it needs kernel with BTF built-in, which is
the only (temporary) downside.

> I'll try to rework it and submit PR, I'm glad to know that you think
> this tool as a helpful one, we do solved some tough issue with it
> already.
>
> >
> > As for the code itself, I haven't gone through it much, but please
> > convert map definition syntax to BTF-defined one. The one you are
> > using is a legacy one. Thanks!
> >
> >   [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools
>
> Will check the example there :-)
>
> Regards,
> Michael Wang
>
> >
> >>  samples/bpf/Makefile             |   3 +
> >>  samples/bpf/task_detector.h      | 382 ++++++++++++++++++++++++++++++=
+++++++++
> >>  samples/bpf/task_detector_kern.c | 329 ++++++++++++++++++++++++++++++=
+++
> >>  samples/bpf/task_detector_user.c | 314 ++++++++++++++++++++++++++++++=
++
> >>  4 files changed, 1028 insertions(+)
> >>  create mode 100644 samples/bpf/task_detector.h
> >>  create mode 100644 samples/bpf/task_detector_kern.c
> >>  create mode 100644 samples/bpf/task_detector_user.c
> >>
> >
> > [...]
> >
