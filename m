Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA636999D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhDWS3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWS3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:29:47 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF594C061574;
        Fri, 23 Apr 2021 11:29:06 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a36so45860244ljq.8;
        Fri, 23 Apr 2021 11:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdnChyNU5g40Ppr1HDFtoA5EP8QpR8VEp8VbrhDcU3s=;
        b=p6eTsfwEvWd4VkkEjTNw1bRnfUg5rwYnRBn1BQ56teSGg8EY91MQ9i7dTJfhs+dvFi
         GmDWRGcAgAev6pAq+0gwR/J02HeVEHpetz2AZ0x2I6GAhb6/dzauY3lIK014HVb+rFcb
         iXSKcGJ6WBYorGRrPkjTlITOdthofGHL3MPKKvCsTHceBfucDq7cekkrjBXMtA5ulFiG
         EdpltVEqubsg5gilsV8fbVfa/Pnr6lEMEobp7EBcmArsNHXiyb3QXlT/WgZkbMVVzxl8
         u9YQC5niaERMvD9+qOAe/K4NQ9GOhRPUrlqD/FX4NznOGPQHACQZeTBS1EcLREKC3HPH
         Nekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdnChyNU5g40Ppr1HDFtoA5EP8QpR8VEp8VbrhDcU3s=;
        b=CrwkP90ld62Jh2RZm8/5uwg7Qo2X1UfFk+UOo2Sy3q7WBlhArKpcQb9vJrydBOqkyA
         blACQ+gfzyl9iLTm/0/bnvfkel98y6GQ/XXSn/zXTmm3Otio9wSCuZWrAU/FcIa4NdwN
         hekKm6y7Tnyj5hfQSeo/auzkhnPngFrlp/YR/+RbWfMhcmmebE0HdZiz48L/tO0CmfZB
         HO7mHDAqNwh1EIRWTgBJNZ04KpbObXPDXYMlmhczyv/4a4oXkKzJ2zKwMHec9pR38YIa
         2JQgl6DlgiFjvCp2hTAp8b4CV3Q5O3GZqC8x+4v9YHyW4KaibEIwuMsAMNsx+oDL5Xcj
         8QAg==
X-Gm-Message-State: AOAM5307x6+vV0G/bBMCmTLzM4vkoL1GNXHFk6OO9noun2djA4uG7iXD
        gKPjrLjg3yxYX+TpOSaFhg46fu6WcxDjx9q2xeQHDkVn
X-Google-Smtp-Source: ABdhPJzYg7F+Z5Pd5pFP1HF2U3lK0ZknNAozZnDci2bFLCxNnlQu/pW4mvwEIXD5x6biuTTh4upINmdN+bdA43YX6lE=
X-Received: by 2002:a2e:8356:: with SMTP id l22mr3598313ljh.204.1619202545334;
 Fri, 23 Apr 2021 11:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-2-alexei.starovoitov@gmail.com> <75b1c0b2-12f6-57f3-0cd0-2a59285b6aa5@fb.com>
In-Reply-To: <75b1c0b2-12f6-57f3-0cd0-2a59285b6aa5@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 11:28:54 -0700
Message-ID: <CAADnVQLCUrQUknQf12fHSHe1-VwV9Nkh_tbyR=zoXGrXWmzEhA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and
 program type.
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 11:16 AM Yonghong Song <yhs@fb.com> wrote:
> > +
> > +static bool syscall_prog_is_valid_access(int off, int size,
> > +                                      enum bpf_access_type type,
> > +                                      const struct bpf_prog *prog,
> > +                                      struct bpf_insn_access_aux *info)
> > +{
> > +     if (off < 0 || off >= U16_MAX)
> > +             return false;
>
> Is this enough? If I understand correctly, the new program type
> allows any arbitrary context data from user as long as its size
> meets the following constraints:
>     if (ctx_size_in < prog->aux->max_ctx_offset ||
>             ctx_size_in > U16_MAX)
>                 return -EINVAL;
>
> So if user provides a ctx with size say 40 and inside the program looks
> it is still able to read/write to say offset 400.
> Should we be a little more restrictive on this?

At the load time the program can have a read/write at offset 400,
but it will be rejected at prog_test_run time.
That's similar to tp and raw_tp test_run-s and attach-es.
That's why test_run has that check you've quoted.
It's a two step verification.
The verifier rejects <0 || > u16_max right away and
keeps the track of max_ctx_offset.
Then at attach/test_run the final check is done with an actual ctx_size_in.
