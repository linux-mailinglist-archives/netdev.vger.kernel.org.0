Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943783DAB29
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhG2Snj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhG2Sna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 14:43:30 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1BC0613C1;
        Thu, 29 Jul 2021 11:43:26 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id k65so11695264yba.13;
        Thu, 29 Jul 2021 11:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owNknewlmhVeJ08NL+mS9WBCYdMfCebsDj9YXkcDEGs=;
        b=MF1+nABM8/LM5ttc7U9pCYCBkGdaer0WLgV88kUjltyY4WLTKAmaqgOawu910OSNL3
         JirwubSa9+OQgs9LymM8ZLMMUQqOLhQTM61/xmBO+E7WGS1V9TOumxkbQfJ+HgLB0nck
         ZOTx+nJYciX/JxbveoALv1msokP5lpws1A9Oa016J1+1ylBc7oDtyqY0ES1iKxa/L/Gq
         Neu+nX9KKCwNZFEkae6IvdUZCPys6PMwF3/ri1qSTIWAovg5zMK8CAuJmi0D3EPEEaCh
         43Ix0tNuVST/0Nb6jZqgPpg5sEUCUWTqwXHX0cWZSBLNwfH6f+4fZSxCeyFaOuBph7kd
         KNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owNknewlmhVeJ08NL+mS9WBCYdMfCebsDj9YXkcDEGs=;
        b=o1dbWx/FWpXdu8PnbfvG29TPFX5OYEnluiUGbQWREd+J0o0UvvUZLxkD0akOkMGbOa
         msWRLY9YyaFwolAbuDY31fXhmU9iCxRtI38LnG1hcEjNcXCoPEgKcU0ykWVOZ9s5ZS6W
         ZcMiYJFTLLzbnMCzvnwFK3ucq1pAuF5+BeulNJcVnC3VDkJlG+xZI2RY6GJ/Q9T8Fzpn
         LEoSg74InaADsJbcFfsbb33G89IvBLwD59kiSXOgN3+CFHp/wFRieHAUx/Hf+Bmwk39I
         JsXdvVhwuXzxYBVwKvuGISHgYViisHF06MAsg9I2QWv8uD2P1RuTGjXaeX1SyjTJRHiH
         prWw==
X-Gm-Message-State: AOAM532a9fO30dby1LM8J+8wa3vfmu+ekRFTk4zDD4karT1ZRoWboSHB
        FqbKQNfSfCKbo1nQrQCJtSJw2CHBHlU51enMT4A=
X-Google-Smtp-Source: ABdhPJx9fOQiF2W+2x8TKf/QgDvKM+aSVKwdXOkT6EVVwQxtpSYrOhmnw7KFGRxM3X4S2HqVPgzaQXdSVaPsGJ+jKNA=
X-Received: by 2002:a25:6148:: with SMTP id v69mr8076071ybb.510.1627584205552;
 Thu, 29 Jul 2021 11:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
 <CAEf4Bza3nAgUVdaP6sh9XG4oMdawCp55UeAB3Lgjf9opCw_UnA@mail.gmail.com> <CAADnVQ+4j1snfhygHh6=+y9-Rb52iKewP5qoQ54WX85kZN5qCg@mail.gmail.com>
In-Reply-To: <CAADnVQ+4j1snfhygHh6=+y9-Rb52iKewP5qoQ54WX85kZN5qCg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Jul 2021 11:43:14 -0700
Message-ID: <CAEf4Bzakn6A=TAEE2C07JOxHZE8CA7xWMviJxoBZ3ZGMUgTBBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: Move CO-RE logic into separate file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 9:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jul 26, 2021 at 12:38 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jul 20, 2021 at 5:08 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Split CO-RE processing logic from libbpf into separate file
> > > with an interface that doesn't dependend on libbpf internal details.
> > > As the next step relo_core.c will be compiled with libbpf and with the kernel.
> > > The _internal_ interface between libbpf/CO-RE and kernel/CO-RE will be:
> > > int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
> > >                              int insn_idx,
> > >                              const struct bpf_core_relo *relo,
> > >                              int relo_idx,
> > >                              const struct btf *local_btf,
> > >                              struct bpf_core_cand_list *cands);
> > > where bpf_core_relo and bpf_core_cand_list are simple types
> > > prepared by kernel and libbpf.
> > >
> > > Though diff stat shows a lot of lines inserted/deleted they are moved lines.
> > > Pls review with diff.colorMoved.
> > >
> > > Alexei Starovoitov (4):
> > >   libbpf: Cleanup the layering between CORE and bpf_program.
> > >   libbpf: Split bpf_core_apply_relo() into bpf_program indepdent helper.
> > >   libbpf: Move CO-RE types into relo_core.h.
> > >   libbpf: Split CO-RE logic into relo_core.c.
> > >
> >
> > LGTM. Applied to bpf-next, fixed typo in patch 3 subject, and also
> > made few adjustments. Let me know if you object to any of them:
> >
> > 1. I felt like the original copyright year should be preserved when
> > moving code into a new file, so I've changed relo_core.h's year to
> > 2019. Hope that's fine.
> > 2. relo_core.c didn't have a Copyright line, so I added the /*
> > Copyright (c) 2019 Facebook */ as well.
> > 3. I trimmed down the list of #includes in core_relo.c, because most
> > of them were absolutely irrelevant and just preserved as-is from
> > libbpf.c Everything seems to compile just fine without those.
>
> Thanks! Much appreciate it.
> It was on my todo list. I lazily copy-pasted them to avoid
> accidental breakage on some archs that I don't have access to
> (since I didn't wait for the kernel build bot to process them before I
> sent them).
> fyi intel folks can include your private tree as well, so you'd have to respin
> your patches due to odd 32-bit build breakage. Just email them with
> your git tree location.

yeah, that's a good idea, I'll email them
