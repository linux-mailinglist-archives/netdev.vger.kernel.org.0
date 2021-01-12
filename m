Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741AD2F3A91
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437063AbhALTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406895AbhALTaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:30:14 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E22C061575;
        Tue, 12 Jan 2021 11:29:33 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id j17so3204031ybt.9;
        Tue, 12 Jan 2021 11:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbc/zWy3iomPmhTWA0FQ2KcSGDNkO0iZis0nqjkkkMo=;
        b=F/RFkXqS5+qZhY3ihPiQIHmIlUCNn/NhYRIsvDVI/Wh6vG5bbXsvA2zeoeJsJStqzh
         n1jn2YyLHWScLbVr1y5b2QTp9KQo0ZGjIEZXpXyIDOuxEKrcglU+cTkbF9NqUp4yP0iv
         zX2cu61K06BTN9b2Np5KUZakOvTBNtymuFVv87MxlJyaLDgGmv6eN3g7J71Y7qH20qQV
         jyIboRQSA0GSsBbFTr+B/O3PCpe07fOhWdlp6YGwiFRLXVXIDRlnDOy522hC6F6VOEuD
         uukBrr0gOOV913amJqQ4ip9i8H7yjPhCRhSKeLYhimNm2QXS3vbQwOSFQav7fJq2Cvmj
         mwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbc/zWy3iomPmhTWA0FQ2KcSGDNkO0iZis0nqjkkkMo=;
        b=EhgOifYdZDLXM6JospV/LTppljM+BKQoxdyWDlThd4OS23faXqmwYIceNwrlrIssj0
         pTZMdL+l/fdbzSYfKolKAI+7WoFvMGERyT+u/NUjzyxVxgY1cCWbCGATpxNK27A0Ru3U
         xjy0YrolExrRWm3BLq+vE4kZKPtyCRUDLzVLUbOWjgSVFhCIW/agKCl0QFuLAHLi8YUr
         oEpItLOCjEcEHpc/KJGzri+++0Vj3MHY+Yk32LAEzR7VUIVSEG/wNnjgduxQVTU6X6X5
         WY9BRHzfvjjjTpqX1jOYbeHamXvFBMDgdiS1aAO7SIxeLDln9+XrdxzGvycC0D30A1F4
         cTRw==
X-Gm-Message-State: AOAM533Wn+Pl2h0bHvmQExy/H3W952iiNdUbANICGha75XjbjMtHEx1D
        FOn0AVEvkP427Cfz8p0LFpXff8ai18UdpwnUGbg=
X-Google-Smtp-Source: ABdhPJyX2sk9erF3XPlMl5bgB/PCcEmFn/glFFy+95G9BtmNkSM3tEtQZpkCngKUEgK0+WrwnfEYlxfhxJ+fa8e/YTk=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr1428532yba.260.1610479773278;
 Tue, 12 Jan 2021 11:29:33 -0800 (PST)
MIME-Version: 1.0
References: <161047346644.4003084.2653117664787086168.stgit@firesoul> <161047353609.4003084.8490543345104346164.stgit@firesoul>
In-Reply-To: <161047353609.4003084.8490543345104346164.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 11:29:22 -0800
Message-ID: <CAEf4BzbqgTxT6Dmx=6-hKoKEKhe+vahRjShBT=3gJf7FRpBERA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V11 7/7] bpf/selftests: tests using bpf_check_mtu BPF-helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:49 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
>
> V11:
>  - Addresse nitpicks from Andrii Nakryiko
>
> V10:
>  - Remove errno non-zero test in CHECK_ATTR()
>  - Addresse comments from Andrii Nakryiko
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Looks good from the generic BPF selftest perspective.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |  216 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |  198 ++++++++++++++++++
>  2 files changed, 414 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
>

[...]
