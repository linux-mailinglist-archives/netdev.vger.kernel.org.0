Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0254F77B04
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfG0SYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:24:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44294 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0SYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:24:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id 44so24826154qtg.11;
        Sat, 27 Jul 2019 11:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSZzeCEsm4nsXZ5ynIhIs66RHBvK6ubd2BmbREFA9Mc=;
        b=sazxP5vsGGZgLQpvMjWUzg3juRl9OrRTxK3VUOaqwotxKYnFAUMU7SWzNAGk3+qhTw
         doUf1EP0V1K7+iAjGgEd2HEOMFOEZ2pVGwUo02xrBs5bMgfKxk7pUpjcaLaoHJ7GoD9W
         rwFKOdgAR8CZgaAW0GBzYcPGI9gQqVH5glonZ3rF+pyBBbzDpPH5PQSuMEPMWlNwFzQH
         CGEnraNQUQLBKoyUgfMb4Bu/v1q3yut6bJ8v2NvvNkobJOpk/XFERZvupU6reXoe9F9s
         N2OCk6MI7aeUqW4wm3x3aA+H5ILhdBkTFgygccY62EUxzCCDM3W6cSutmQq7se+Ls/cL
         MwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSZzeCEsm4nsXZ5ynIhIs66RHBvK6ubd2BmbREFA9Mc=;
        b=kfv0g9ca+ifZQgf4r8p6u/852a5U/mcy+il42kxhd1frcF34bQBLQJrvOlI2GaXcXR
         7QqRGrMGKFrNdPT2LEWAnE4mwho5IxN0dnAE1EOp5i3pOWMhJBPVJplyTX9MQ8oSR8ff
         knp+4BEHjTydVjXD+jcIvRtRRa0HGhA4zdNaySz830uQWkgijflJV2NXaO2ESVeXyoDU
         P+EI//BIv2sj1sqljomxnBzaJ4zeStJNe8a6NVd/HR/LeQTiRFNZUS5HP0K9U9vLMJgt
         QM6GkosE09CbVh7a9pH4feQPgNUeckBIxh7+9F7IAcly95rJ3i5GtpgdSW+BgtDc2Skf
         8Fmg==
X-Gm-Message-State: APjAAAXd9Lhxq7mA2UhnlXWezr0gRvqbu34+lzEhMpQdnVD6ah0uBwV7
        Nl4ffW2XD+InSqqt5QClm9ohP/o1Gf03Df5vcjY=
X-Google-Smtp-Source: APXvYqz0k7c7QBhfSALdauT1EsFkp4hll3hKFyJkfMHIXPh69kPkX3I9pjZt+d6mr4E8k3+JueTg/t22qf8IOphZTlU=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr72046973qvh.150.1564251891722;
 Sat, 27 Jul 2019 11:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-3-andriin@fb.com>
 <20190725231831.7v7mswluomcymy2l@ast-mbp> <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
 <957fff81-d845-ebc9-0e80-dbb1f1736b40@fb.com>
In-Reply-To: <957fff81-d845-ebc9-0e80-dbb1f1736b40@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 11:24:40 -0700
Message-ID: <CAEf4Bzbt4+mT8GfQG4xMj4tCnWd2ZqJiY3r8cwOankFFQo8wWA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 10:00 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 7/26/19 11:25 PM, Andrii Nakryiko wrote:
> >>> +     } else if (class == BPF_ST && BPF_MODE(insn->code) == BPF_MEM) {
> >>> +             if (insn->imm != orig_off)
> >>> +                     return -EINVAL;
> >>> +             insn->imm = new_off;
> >>> +             pr_debug("prog '%s': patched insn #%d (ST | MEM) imm %d -> %d\n",
> >>> +                      bpf_program__title(prog, false),
> >>> +                      insn_idx, orig_off, new_off);
> >> I'm pretty sure llvm was not capable of emitting BPF_ST insn.
> >> When did that change?
> > I just looked at possible instructions that could have 32-bit
> > immediate value. This is `*(rX) = offsetof(struct s, field)`, which I
> > though is conceivable. Do you think I should drop it?
>
> Just trying to point out that since it's not emitted by llvm
> this code is likely untested ?
> Or you've created a bpf asm test for this?


Yeah, it's untested right now. Let me try to come up with LLVM
assembly + relocation (not yet sure how/whether builtin works with
inline assembly), if that works out, I'll leave this, if not, I'll
drop BPF_ST|BPF_MEM part.

>
>
