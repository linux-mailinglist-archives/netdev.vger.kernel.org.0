Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C09107C6F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 03:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWC25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 21:28:57 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41486 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfKWC25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 21:28:57 -0500
Received: by mail-lj1-f195.google.com with SMTP id m4so9474667ljj.8;
        Fri, 22 Nov 2019 18:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7KHy6c0WaArjzD5NzA8oaCyhccUeeP7nTZcJLmdY6w=;
        b=ja8GNQ6nIwOTJa8bS2XiddtmfK4TSHrWDcuClzCC3uQqaUYxfvzanFnXLrIOT44r1N
         qyG3f0m0Z1lD8055VxQtjdkPnW35fYl756Grh+sss7Q8vM5Lz2SPI17GbMl1vkD5B2TO
         yx9UCPrBM6Y3bZwMqN57YERoKlCuIh5zM9m5uWufqiro76H0QJCG/hRuejjGdc4BkUi5
         6MhkqOG5bxlbtp3dAbHKXR4N32xf3fTs9tei5K7TgEw9E29pWaZJFinyNncJwULA4ZY5
         0XD3W5KKhT150V+va+SexU7vZGGR+O8fnpEE/iIt7JDYZnKuMdAVPrppLEs38NIZyDRP
         +hMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7KHy6c0WaArjzD5NzA8oaCyhccUeeP7nTZcJLmdY6w=;
        b=X00KiMrpRMm+RPRply/S0DbHCd/FVi9ClPD6CXsfKwf48eDO18fHNskePUd85B9Mih
         eobQS7YMYfsQTS/HbuotNgLZe/0kBhSUFMqbc/3y244uQAIYivVw/Uyj7YTSRsmISon3
         aPIIiRnNJSyKm83eH/NhCPqsPBFsgBF7ZWAVo3+5S/w/4bK2/xi8Y5kQLEqdTnw7Dkys
         rwjYzvVsqTqf4gsFix4tTZcU9cyG+26dTyDQsZf8R5nbw6Xb+D4ZL7EEO8eH7AHO9EME
         nQQO8IY/u+v2q1dn5lzqr16YKMCoNxGQqyT36npB5+vxrNyMGdWH/eakFtSwhuKk8lx/
         xg0A==
X-Gm-Message-State: APjAAAWMEhNxkZrrqrZkf04n8qmRgeDl0RUo1Ct/hsTaV5JNbkideOCe
        bJa2Skjac09Q7sjo6CHDhRE0vUrmJu5PvVw58FCyarQt
X-Google-Smtp-Source: APXvYqwQn+4tDpZVgBHk7Mq8pLwfOEf6cIgoD52we74YvAZyfxJGja68z1WKi7vnYLMOwWBUmmStgmsPr63V9SQJLE8=
X-Received: by 2002:a2e:574d:: with SMTP id r13mr14088822ljd.10.1574476133495;
 Fri, 22 Nov 2019 18:28:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <6ada4c1c9d35eeb5f4ecfab94593dafa6b5c4b09.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com> <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net>
In-Reply-To: <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 22 Nov 2019 18:28:42 -0800
Message-ID: <CAADnVQJqYE5TAdJ=o8nHSF1mXoXpsVNXcJtWSPQJDn7wUvxR=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] bpf, x86: emit patchable direct jump as
 tail call
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 3:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> +       case BPF_MOD_CALL_TO_NOP:
> >> +       case BPF_MOD_JUMP_TO_NOP:
> >> +               if (old_addr && !new_addr) {
> >> +                       memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
> >> +
> >> +                       prog = old_insn;
> >> +                       ret = emit_patch_fn(&prog, old_addr, ip);
> >> +                       if (ret)
> >> +                               return ret;
> >> +                       break;
> >> +               }
> >> +               return -ENXIO;
> >> +       default:
> >
> > There is this redundancy between BPF_MOD_xxx enums and
> > old_addr+new_addr (both encode what kind of transition it is), which
> > leads to this cumbersome logic. Would it be simpler to have
> > old_addr/new_addr determine whether it's X-to-NOP, NOP-to-Y, or X-to-Y
> > transition, while separate bool or simple BPF_MOD_CALL/BPF_MOD_JUMP
> > enum determining whether it's a call or a jump that we want to update.
> > Seems like that should be a simpler interface overall and cleaner
> > implementation?
>
> Right we can probably simplify it further, I kept preserving the original
> switch from Alexei's code where my assumption was that having the transition
> explicitly spelled out was preferred in here and then based on that doing
> the sanity checks to make sure we don't get bad input from any call-site
> since we're modifying kernel text, e.g. in the bpf_trampoline_update() as
> one example the BPF_MOD_* is a fixed constant input there.

I guess we can try adding one more argument
bpf_arch_text_poke(ip, BPF_MOD_NOP, old_addr, BPF_MOD_INTO_CALL, new_addr);
Not sure whether it's gonna be any cleaner.
Intuitively doesn't feel so.
