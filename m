Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCC716B6D5
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgBYAmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:42:20 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35015 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYAmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:42:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so12130762ljb.2;
        Mon, 24 Feb 2020 16:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lA69AZrelbjB6ZozmKLqS29rj9UvPNFt448gKkt1TTU=;
        b=eWN2NQqF8H9E8iqjqcRhAq8mfdZexJPS1qljBBJW/NanjLjXH13l3200u1FuzAjoyL
         VBbxFpMlaktno1iR8LaitoQ5SMoL8z1IKpmZGUNxFtO0xooZbzNro0XQ+pewMzZ3fpXq
         l45crp+4x0h8MHSrpEgwmtWS7DsYswQ1C5oj7YA5WT+4TOpZrcytr2Qb6H50XyWcwHeC
         rxejTHWxkmDV8kWcUMkX4lmaxyoBAk0cpIAEFYbwK19zbo3DovYMTVmm1ieixbmP1elf
         SB1pcrX2hHVCktYdG39FwrFlH+X5BFN6nTKBnnhzs1yYtyR+LCIDvCtPMavkR7G2URJf
         TQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lA69AZrelbjB6ZozmKLqS29rj9UvPNFt448gKkt1TTU=;
        b=unEEUJeeIEljnDl7PYK+gZONTQ38u1Xd7ATJcjiyhGOBMqtFKodiVYT0lEH1J6jz06
         UcU0KCPGojC3EYRW5tE4GrZez8dfRLEm0h3CN8eFg4YReUNz8A3Smq7mkfq/oqbFXdZ5
         PUaTYjrSBFV+TmxgmVUvwnB/ZLFFp301/GcHjMBVFCw2bFncdBA2gDMERoqVa2puGFaS
         Z6pIJH7/OljK42vS7R16JUIO3iU0Z/js/b2Y92FTMIaOGVLkqDaQDxEw6pF+nLIrDzQm
         U5qjuH14Vun8IKr4HQHFNiIYLZmALUFWAap3Tw0mh2OSC3fiYDOldccrjfe9lyvyYpWu
         jDcg==
X-Gm-Message-State: APjAAAWUVqbjqXnkxSyEnaZRn1VtAojJmyVq68wLm1oBN14it2o4NuJf
        3Ei6FTKPvgx1M8m45Q7ukAXDeoK5EoKdZa0sz5g=
X-Google-Smtp-Source: APXvYqzXfk38ncOBiqWLLtL3ANUuqOkZ6lI3WcgNsksE+wsyFWFQjVmFwXajjHPeQu9ShCfoYJJd1T9Z1h6M1+72y8I=
X-Received: by 2002:a2e:a404:: with SMTP id p4mr32991570ljn.234.1582591336526;
 Mon, 24 Feb 2020 16:42:16 -0800 (PST)
MIME-Version: 1.0
References: <20200220041608.30289-1-lukenels@cs.washington.edu>
In-Reply-To: <20200220041608.30289-1-lukenels@cs.washington.edu>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Feb 2020 16:42:05 -0800
Message-ID: <CAADnVQJTtNu5a2oM=8poe6FHXeQttG44S+7XvuqQtv1Cgui8tg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 8:20 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
> the 32-bit ARM JIT.
...
> v2 -> v3:
>   * Added support for far jumps / branches similar to RV64 JIT.
>   * Added support for tail calls.
>   * Cleaned up code with more optimizations and comments.
>   * Removed special zero-extension instruction from BPF_ALU64
>     case, pointed out by Jiong Wang.
>
> v1 -> v2:
>   * Added support for far conditional branches.
>   * Added the zero-extension optimization pointed out by Jiong Wang.
>   * Added more optimizations for operations with an immediate operand.
>
> Cc: Jiong Wang <jiong.wang@netronome.com>
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <lukenels@cs.washington.edu>

Bjorn,

please review.
