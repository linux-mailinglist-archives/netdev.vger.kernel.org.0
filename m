Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27BA77C18
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfG0Vgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:36:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33890 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfG0Vgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:36:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id k10so56160109qtq.1;
        Sat, 27 Jul 2019 14:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79/Oy0HkICvBfbMtx7+8dDegRPctNVaxsRp2EyYDzME=;
        b=lLRWOwf3EiTQqwuBb2++1YbILkyPDvrw35KXhQGu5lA2OFO8q6V4zXutdhpaBfj6Z6
         uvGH0BInYHP++v9R9vi8Cm1VE0s08+gOkFxxZbwK/t/UDi9LLKIctwFK91DHZCUp4xaa
         t++3Fd/RFlTERYneoVkSAsxDksYAP3AxbRBTShdmV1TebPnUCY/VCl5APzXf3oSLiMDP
         PQJnep5KumqRbflHYFpVQ5kJIr5YgEXtc0iJHxf15r9Os932SNZga0aYXn2nY7aXjfS1
         inQpfXDOroxVZWbISI6x+hZ0RFvtqremnTaTuk/jbX8ZuZtwXYGBCkmGGQ3ByOCszwxT
         6OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79/Oy0HkICvBfbMtx7+8dDegRPctNVaxsRp2EyYDzME=;
        b=FMXEF6OxcUCaAaEd/pOzFI29gP34CUizgvcGINaoMVuWctbX9pkLmSKbxv0fqVDscU
         ZPdhqawTu1DmJkQOTq0wBOHzYsKyswQQLwjx0cW7GV0Sd5EP7yHpifAdOz5Be+uJh7MB
         CKXqpAzjoHzEWMQfuj+RFuA/zuG0aUydMeEIh7To0QoD3A2wxqUL+tnvDJFSmjmQyP/o
         /6zhACRJ26aQ3UmCb513jOGgCXi14yGnmD48UOelLyCnv+Qgj/7h6AM+zSkbhF58FXyL
         EyWwnoFctdDd8Pdd8wZmch9FQ7v/ZbengNrX5cMFd/ZN9fh16NtXpxsjc84F47EHPbwS
         0AXQ==
X-Gm-Message-State: APjAAAU7mXS9TxVA2T/L0oMx9ZJl33eVB35XGO/2ju4aH9aTK/9mmIug
        aalhD+IirTujpzAohPclVg3I3xAZGH4N7Xe77+0=
X-Google-Smtp-Source: APXvYqzdhospRPZMf3oGiCOeYQxjmn/QlIfdBK2UfI+qbV5Dv52/8MWcBGjARpn9DOgqvYKGX5BiDxf/Jo6bnKrQfro=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr69934608qty.141.1564263392236;
 Sat, 27 Jul 2019 14:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-3-andriin@fb.com>
 <20190725231831.7v7mswluomcymy2l@ast-mbp> <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
 <957fff81-d845-ebc9-0e80-dbb1f1736b40@fb.com> <CAEf4Bzbt4+mT8GfQG4xMj4tCnWd2ZqJiY3r8cwOankFFQo8wWA@mail.gmail.com>
 <363f7363-7031-3160-9f5f-583a1662fe25@fb.com>
In-Reply-To: <363f7363-7031-3160-9f5f-583a1662fe25@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 14:36:21 -0700
Message-ID: <CAEf4BzZrN-GKMHmLSkdh3JZT_h226RK_F3Tu3tPxrVqKYNSoUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 2:29 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/27/19 11:24 AM, Andrii Nakryiko wrote:
> > On Sat, Jul 27, 2019 at 10:00 AM Alexei Starovoitov <ast@fb.com> wrote:
> >>
> >> On 7/26/19 11:25 PM, Andrii Nakryiko wrote:
> >>>>> +     } else if (class == BPF_ST && BPF_MODE(insn->code) == BPF_MEM) {
> >>>>> +             if (insn->imm != orig_off)
> >>>>> +                     return -EINVAL;
> >>>>> +             insn->imm = new_off;
> >>>>> +             pr_debug("prog '%s': patched insn #%d (ST | MEM) imm %d -> %d\n",
> >>>>> +                      bpf_program__title(prog, false),
> >>>>> +                      insn_idx, orig_off, new_off);
> >>>> I'm pretty sure llvm was not capable of emitting BPF_ST insn.
> >>>> When did that change?
> >>> I just looked at possible instructions that could have 32-bit
> >>> immediate value. This is `*(rX) = offsetof(struct s, field)`, which I
> >>> though is conceivable. Do you think I should drop it?
> >>
> >> Just trying to point out that since it's not emitted by llvm
> >> this code is likely untested ?
> >> Or you've created a bpf asm test for this?
> >
> >
> > Yeah, it's untested right now. Let me try to come up with LLVM
> > assembly + relocation (not yet sure how/whether builtin works with
> > inline assembly), if that works out, I'll leave this, if not, I'll
> > drop BPF_ST|BPF_MEM part.
>
> FYI. The llvm does not have assembly code format for BPF_ST instructions
> as it does not generate code for it. So inline asm through llvm won't
> work. llvm disasseembler won't be able to decode BPF_ST either.

Well then, I'll just drop it for now. Thanks!

>
> >>
> >>
