Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2A112879F
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLUFka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:40:30 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34307 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:40:30 -0500
Received: by mail-qt1-f194.google.com with SMTP id 5so10263758qtz.1;
        Fri, 20 Dec 2019 21:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DInoTaRogGS3Ud5i8imN5LsSNyxk5kc73MapUyS7J9E=;
        b=tyTDM0MNTBEqjbM3QK94+VIYEPP1jFBNI1IJ77S6R2ONVJrP4TtA3euUNC4/S5/FQz
         lmR/gQJGQNf1GLvFuRY2bFaolCOnnvY6cos8JwWvAmsoFvhVvco7EMCFrVsh0lERwbtk
         TmU6yhnpHJLtvMFsnX7t29moZrrAV83BoZtRuLC5QAhLX23Cfjr8LUT9FQqww+rSmjIW
         QwwjcaZD5p5mJ0XVUUq+vwKTZ4nF/8zD6I69T/9mhlyjHfILSBwIhpc2h9La5554xcBp
         AvIFwhkB4lIhClKS1iYoxSKn2wWccnLVAMuQ0EoSWFc7vAJEdeFiBplBhxtybcGeyjYa
         eC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DInoTaRogGS3Ud5i8imN5LsSNyxk5kc73MapUyS7J9E=;
        b=EdtIS34kQyHVLjmtlYkJV8G/zrC1avweu44vOKCj784J0gqo6xJIseDdhqUYQZdw4N
         N+yXXynKPSdnl2dMfZlyvX426E5vAN6KSoyCELHxqh621ZJX4xXSMkdzRhgEHko6nXE7
         2Csbzgku+/lGMK5EFx8PKxVudP4D2mydLpn1v2XL3rief6U2F5CXiOCgcGEOvQPjYVij
         yMG+eQ6LexPAnLDRoWhhyWmoEcVF0XV5GqfEp6FNBYRqSSBzMfYIlLjx6ZP3e2S8i8/S
         tYvmvRMnlIGbrmG6BasBx17Uou6E5qWP+F+Vqf8IZPRMVQBk0dL5hf60/O45IyVib0zN
         Td4w==
X-Gm-Message-State: APjAAAWccTd4Oilwm6y7oL0nawRF7xFDSiGAWlsq9EiNanj4ezDlg/2G
        TF71pm1jQ4wsNLwaG4Wbe00wRZtLkIOmzzbezR0=
X-Google-Smtp-Source: APXvYqyLEMOL5elQRd4GYGFUYjz/vJv0dlMoH/hU5vu1gtnfpMu0lkPFIQwCve7bWCWJJUluvZMjrlXLWr2kyrAeZr4=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr14126090qtq.93.1576906828937;
 Fri, 20 Dec 2019 21:40:28 -0800 (PST)
MIME-Version: 1.0
References: <20191219070659.424273-1-andriin@fb.com> <20191219070659.424273-2-andriin@fb.com>
 <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com>
 <20191219220402.cdmxkkz3nmwmk6rc@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzayg2UZi1H1NZaFgAUabtS5a=-yCE7NsUmtaO7kS5CJmw@mail.gmail.com> <20191221032147.b7s2zm5pkzatbu57@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191221032147.b7s2zm5pkzatbu57@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 21:40:17 -0800
Message-ID: <CAEf4BzY4ffWaeFckPuqNGNAU1uBG3TmTK+CjY1LVa2G+RGz=cA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump command
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 7:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 20, 2019 at 09:40:31AM -0800, Andrii Nakryiko wrote:
> >
> > This one is a small line-number-wise. But the big difference between
> > `format c` and `format core` is that the latter assumes we are dumping
> > *vmlinux's BTF* for use with *BPF CO-RE from BPF side*. `format c`
> > doesn't make any assumptions and faithfully dumps whatever BTF
> > information is provided, which can be some other BPF program, or just
> > any userspace program, on which pahole -J was executed.
>
> When 'format c' was introduced it was specifically targeting CO-RE framework.

No it wasn't. Here's "motivational" part of BTF-to-C dump API patch set:

  "This patch set adds BTF-to-C dumping APIs to libbpf, allowing to output
  a subset of BTF types as a compilable C type definitions. This is useful by
  itself, as raw BTF output is not easy to inspect and comprehend. But it's also
  a big part of BPF CO-RE (compile once - run everywhere) initiative aimed at
  allowing to write relocatable BPF programs, that won't require on-the-host
  kernel headers (and would be able to inspect internal kernel structures, not
  exposed through kernel headers)."

And here's `format c` patch commit message:

  "Utilize new libbpf's btf_dump API to emit BTF as a C definitions."

It was never **just** for CO-RE framework, rather as a convenient
C-syntax view of BTF types.

> It is useful with BPF_CORE_READ macro and with builtin_preserve_access_index.
> Then we realized that both macro and builtin(({ ... })) are quite cumbersome to
> use and came with new clang attribute((preserve_access_index)) which makes
> programs read like normal C without any extra gotchas. Obviously it's nice if
> vmlinux.h already contains this attribute. Hence the need to either add extra
> flag to bpftool to emit this attribute or just emit it by default. So
> introducing new 'format core' (which is 99% the same as 'format c') and
> deprecating 'format c' to 'this is just .h dump of BTF' when it was around for
> few month only is absolutely no go. You need to find a way to extend 'format c'

I found the way, that's not the point of this discussion and
absolutely **not why** I'm adding `format core`. I feel like having
plain C dump of BTF is useful by itself (at least as a diagnostics
tool for BTF, similarly to objdump/readelf for ELF). But if no one
else cares, sure, I'll just reuse `format c` as CO-RE-specific BTF
dumper.

> without breaking existing users. Yes. Likely there are no such users, but that
> doesn't matter. Once new api is introduced we have to stick to it. 'format c'
> is such api.
