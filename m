Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F049310A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbiARWxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350089AbiARWww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:52:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B055C061574;
        Tue, 18 Jan 2022 14:52:52 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u11so308659plh.13;
        Tue, 18 Jan 2022 14:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPT2Qt1/Su+U4kJvcZiKjiQCbHS9sJHOdDbLi+KIKCA=;
        b=fVY0gxgJeuOCT6TC1+GSDHZgAUwcsLBsWG7qBMW4l3jYsvDLXpOD4szf5XLRYfKaTJ
         FC/pwvcXrX+7oLPHGh0vjDML5k9qYPeg4+cvFNILrxednJ357MUWtKIzyKtMinzG0MBd
         JHck2IrSfBv9P3ddnl4eLejWaj9xxLPCWbdc+AFndUHyyA8wNIbNBVd07s1ygjJaJrBl
         Ml+2LpKIDlhT2zABVfE9BnXE/nzEwy87+JpgrmrrzvKCDqU9z2H6nmrfIeMcS8QVs8B6
         2OXxECaJiebYldlgMsVvAPH/ZvCcabxCDNxiHagDn/qljdtxd/uW7UXQFfXSKlKAc2F7
         kogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPT2Qt1/Su+U4kJvcZiKjiQCbHS9sJHOdDbLi+KIKCA=;
        b=BuGasdUqfOR5fMkzzYmF+rf0X9GVjGXpx69J8JdIL7U/ON1ZDMP4/EvdBI71/GVha+
         3DXr1vY1iJ/aREkJqFV1HK0rcLg3o614timbOAbuB2q4pGyk+XuwO5qUZGzvSmMqovKr
         BO0Q89r0Tp2o+lTGEO5Rr4F+ZjHOjD0uvjw6ZCN4vlnm5cyNbJt5wgtaQ/eHvqqeDuuE
         OqGxmpy5TLDW5GDpbXfKjiu0jnUiLkq4/kQMXsdbhqok1H2y8BhSBfQ7oJQqZfcvodNw
         /Z7ppHEDzzRmaoYElCO6Pd+FeLfiedh6gMEpXpewIu+lj6W65YO9TRK850QXsNUQ6/Pc
         Sclw==
X-Gm-Message-State: AOAM5315DP+xdx/9YqTutoZB0RfhDRL27l2KgptqfDHSYYVQQI0xU7ik
        DA6InGYHWDPL5nRh8D8/RMqba5wAcf1FcTcYApE=
X-Google-Smtp-Source: ABdhPJx3TqwiHsWjCdbqBwFxsG/SmBgq2d2iwQ4Vv6UECtd3ojmoLNnZpnzEGaJZe5Pr92vKuI1Gsozz2HXQnRkaqE8=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr28631553plk.126.1642546371668; Tue, 18
 Jan 2022 14:52:51 -0800 (PST)
MIME-Version: 1.0
References: <20220114163953.1455836-1-memxor@gmail.com> <20220114163953.1455836-11-memxor@gmail.com>
In-Reply-To: <20220114163953.1455836-11-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 14:52:40 -0800
Message-ID: <CAADnVQ+FuDDNZ=toHYtrQ=-u+ZSx2Xb2R-k0=grKoy5AfODkpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 10/10] selftests/bpf: Add test for race in btf_try_get_module
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 8:41 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds a complete test case to ensure we never take references to
> modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> ensures we never access btf->kfunc_set_tab in an inconsistent state.
>
> The test uses userfaultfd to artificially widen the race.
>
> When run on an unpatched kernel, it leads to the following splat:
>
> [root@(none) bpf]# ./test_progs -t bpf_mod_race/ksym
> [   55.498171] BUG: unable to handle page fault for address: fffffbfff802548b                                                                      [   55.499206] #PF: supervisor read access in kernel mode
> [   55.499855] #PF: error_code(0x0000) - not-present page
> [   55.500555] PGD a4fa9067 P4D a4fa9067 PUD a4fa5067 PMD 1b44067 PTE 0
> [   55.501499] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
> [   55.502195] CPU: 0 PID: 83 Comm: kworker/0:2 Tainted: G           OE     5.16.0-rc4+ #151                                                       [   55.503388] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.15.0-1 04/01/2014

The commit log was messed up in a few places.
I've cleaned it up while applying.
Thanks!
