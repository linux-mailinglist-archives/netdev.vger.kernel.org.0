Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA81C69CA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEFHIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727832AbgEFHIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:08:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3770CC061A0F;
        Wed,  6 May 2020 00:08:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r26so1271508wmh.0;
        Wed, 06 May 2020 00:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i1McQv5JxS+S3dpHPfoR+SRFx7AO1GcGwXm3Mh9ZmIw=;
        b=FLnYnHqJH1U3gU09Sqx/ZBdsyli2VND4iZgspbc9VISSBTT3y17lgp5dXe4LxMa81+
         md7sot+kcTyCqcu6EeTMAt+0L0RSrhzzaZ4jQgttSiZnI/geHJzSEYoGJCsyx/LFb+7l
         7eTHJKjUzfChc54f6iBO9xmmVE6VudIAtGAgwdD24JErTkCb8gUWQrfj6rViGZ2T4h9I
         74bqVkmvA4qIHe9VW30CK3fvIsnh0d3FkTw0PPEuMwxasv3hi0HwiZClysYya7VZ23ym
         0edoLm+0RDqUPgNpZCzrnY08bARddy+4zf3/0ZYjSQE1lklzrXFIUpfRPOxCipSizBvL
         WpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i1McQv5JxS+S3dpHPfoR+SRFx7AO1GcGwXm3Mh9ZmIw=;
        b=n5+jcICRX4XUjIzlRrl/Cu6nbkd2Nk6Lanhn+WivKZ9qVrXFZlnk8cI5iqxWWovRl1
         fJvruIcyaL7x6y5bEHqajVG6kypQGfuDJQgCGgA3lszeDBWcREnRR6G0+YIfRpczGFfN
         jvm6C5LrKGGji+eOR3ztR9H3FvquDcjiRPlMJRkl437S3Hrzy4wdJgQHiCHRRIlYUnb9
         cUpYIzT9EU/szr4i0FgE3AGMzT1Pyyzj18Eo5o3hBxuqzYb0ieuUfWb+roXgT2PbZwG4
         ofngDPPRsy0swBqxSsRA+1iqlcbkC3Pq7+QWWtlPzJbFqdK8uHEf/X6EK0kbNVcJ+ION
         Gksw==
X-Gm-Message-State: AGi0PuaxW56ne3R9/lx+LOzP0dmXiyA+A0WnNv7qmfRZ06eAtYb9/zAE
        piWxpBZ91asWWvk61+OGHi2JXkQdaFcIa9E2j+M=
X-Google-Smtp-Source: APiQypLonxc2SJgZ3t+ABye4ETFW+KuYGgzgoiH27uLerIQZ3u+pO2iInq911uZepzHOpZi9JGpmgKNSZrBBZK/DNrc=
X-Received: by 2002:a1c:6787:: with SMTP id b129mr2820878wmc.165.1588748912923;
 Wed, 06 May 2020 00:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200506000320.28965-1-luke.r.nels@gmail.com>
In-Reply-To: <20200506000320.28965-1-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 6 May 2020 09:08:21 +0200
Message-ID: <CAJ+HfNgbuBoMTrU+TM3JCd1stEM1Zi3hG5k=PazT=CxAWa4wBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] RV64 BPF JIT Optimizations
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 at 02:03, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> This patch series introduces a set of optimizations to the BPF JIT
> on RV64. The optimizations are related to the verifier zero-extension
> optimization and BPF_JMP BPF_K.
>
> We tested the optimizations on a QEMU riscv64 virt machine, using
> lib/test_bpf and test_verifier, and formally verified their correctness
> using Serval.
>

Luke and Xi,

Thanks a lot for working on this! Very nice series!

For the series:
Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

> Luke Nelson (4):
>   bpf, riscv: Enable missing verifier_zext optimizations on RV64
>   bpf, riscv: Optimize FROM_LE using verifier_zext on RV64
>   bpf, riscv: Optimize BPF_JMP BPF_K when imm =3D=3D 0 on RV64
>   bpf, riscv: Optimize BPF_JSET BPF_K using andi on RV64
>
>  arch/riscv/net/bpf_jit_comp64.c | 64 ++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 20 deletions(-)
>
> Cc: Xi Wang <xi.wang@gmail.com>
>
> --
> 2.17.1
>
