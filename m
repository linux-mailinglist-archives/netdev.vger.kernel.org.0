Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E453AE379
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFUGsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhFUGsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:48:36 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA9C061574;
        Sun, 20 Jun 2021 23:46:21 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id d196so27708026qkg.12;
        Sun, 20 Jun 2021 23:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMFsT7JR74+GVg+w1ThONFPwyNlcIAkOuiSUyJy9N14=;
        b=S+CNxQ589/dBSQ6Ry4o5zvK3BB8VgWgytxQ0lWINFRh3rJqYJJgUiUJ0oo4/TNlUtE
         6S/i5SRzCZ7UCpxbblZtBEXwQSTChqSXF7BjSewUe7Jt0ZzF9kGkcmwpl9JNabAddsDP
         fXtuoz9+BLliPGtglCtQYa7SJlLv3N/lazqPGSpv+ftt3RnUhZntx8r2s+Ds6XjQQDyj
         dXEvIncW0E5M6tQOSPODtOJamEJddZLpzx3rkNPwICWNmw3egVhIQWfJQno6+SoPfUUe
         MFWOkcIHG4PXPrHWJFR1VNX5US902V9i6yzsAwW7/XxFZeWMTGnJr0dyloUiTM4pA+Fy
         T20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMFsT7JR74+GVg+w1ThONFPwyNlcIAkOuiSUyJy9N14=;
        b=VjFudWUI8HKZjKkNtHyenRl4IGKlrLSppK0xAzIYnrgKWHXQCErNb6gEchHQeabwrV
         uiNSQCdTGbpbdvxn/zE0SQPwImE7KrqD4J8rF4xmZA3ISBx4c1roK0LMYK2F6WeYiuGo
         pmc5RTAtOCUcz88z+hY37NAeddooCTAc8bhDgAgGM/u32M8uwsJEh+qZsjJxqXwyL2/z
         JIoxlOEHQDA7JaVbdLE42J+b5YgVM6QchaZzpFHtNb/yXrXnxqI9peIedUg7S2ksZBYP
         hY+uyWDDziGCK/0FRjfcnLLhXm3ksJYXn8Ni1uYbqwRXr84zDwABf8aLSA4G11nyMpul
         /6PA==
X-Gm-Message-State: AOAM533lmn8GE8u1ZrerdV5kIVnB+PsSdAocyzu/6B0EIyULXkNwPz9j
        emPGR8P11U4RmTyT0jVV8ZbMGD92ZhbYbcQAPlw=
X-Google-Smtp-Source: ABdhPJxr+KZBNNIVo3Sjy/UelsZeCBfH/JyVY5HW6Ga7P3yroaMndtK0OkPu/lCGG9RmOuAZn1Ce3d7JyOtbJuReXlg=
X-Received: by 2002:a25:870b:: with SMTP id a11mr24882824ybl.260.1624257980890;
 Sun, 20 Jun 2021 23:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava> <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
 <YM4kxcCMHpIJeKum@krava> <e8f7ab9f-545a-2f43-82a6-91332a301a77@fb.com> <CAADnVQJFzGd-7C9Gn1XqhBWKY+fyr=4WooDSokkff+Ga-2U+nw@mail.gmail.com>
In-Reply-To: <CAADnVQJFzGd-7C9Gn1XqhBWKY+fyr=4WooDSokkff+Ga-2U+nw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Jun 2021 09:46:09 +0300
Message-ID: <CAEf4BzYyvHO_ooGrMFQVwt5xvDo=r3YTgNCK9uRTnNQtZY4q6g@mail.gmail.com>
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 8:47 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Jun 20, 2021 at 9:57 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > > ah right, should have checked it.. so how about we change
> > > trampoline code to store ip in ctx-8 and make bpf_get_func_ip(ctx)
> > > to return [ctx-8]
> >
> > This should work. Thanks!
>
> +1
> and pls make it always inline into single LDX insn in the verifier.
> For both mass attach and normal fentry/fexit.

Yep.

And we should do it for kprobes (trivial, PT_REGS_IP(ctx)) and
kretprobe (less trivial but simple from inside the kernel, Masami
showed how to do it in one of the previous emails). I hope BPF infra
allows inlining of helpers for some program types but not the others.
