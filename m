Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358AC431040
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhJRGRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhJRGRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 02:17:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99075C06161C;
        Sun, 17 Oct 2021 23:15:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o24so292480wms.0;
        Sun, 17 Oct 2021 23:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WQhK9newMuT4ZcfEVTu2O6OOxhG5FSs8pfq23mZQ9b8=;
        b=IU6s7L+v4s0/VflIrjGqDc+A21kMuoTSuD8fw/5h+PKaJcHoeA0GIjHE/yccgSfss3
         j/2wa+P8gnqL6Aa9WPzCcZ4eOB1bvmHD6MW4wiRcR6KGbbafNxloYv76HE6sYsABF6iL
         3IIW3b1BdgKPatNsN3YHj1WciZ2YTWYCsA+xwiAbrLkwnSEJazWr63w59qkkHBdT6Mc5
         qtNJ4fl61L6stAnOOVlMFk39rhnU1189y8xIoQnXQBFFHQi6NVelT5k2Hl2CVHC0hvpN
         QBSKmU3wWRMgBbEl0fEjaIvsd7Ii0nqJtesePyWPqKwIIO96lZoeHF3WRatFjI17NkFs
         +KDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WQhK9newMuT4ZcfEVTu2O6OOxhG5FSs8pfq23mZQ9b8=;
        b=x6tH1ujLeoStJujBi0ConT+O6fthZJZ+LjOmVuY8EZ1tVKpx86goxBu3WmJ4p+9WUY
         AsVNe27Ug20jLpjm95T4l0Uvs11b4i7CpNs8DDhehgRQXQIQSmJL4uYa+wWWgtmglpAg
         Z1Z/gvZMaMSIknRqIojWzoA/ZMumi1E5gHSCv0OQFesAniGpHoCiltHN7evLH/4T7Ss1
         c15z7XghEohC38WN8bc4G8N1QiroroyFzi5t8FPwEk1/3BIfWw9Kf9YV0ZFazvR+fRlJ
         V0brYzykyHyXFyvn3pg2ypcu7aFBhlr0HbKz90i2YSGhWlfFefwuozhxkuZeiYcJmMEi
         qYrA==
X-Gm-Message-State: AOAM533AKRSe6lKvz5WAYF3LKSgYhXzX+BUSq22rWIZueH3tOrL2RMig
        eaViCvt5Ek1L6ZcESrf6fj+YCdHAttWS539o6Zm4b0C5dfw=
X-Google-Smtp-Source: ABdhPJzIWJApevckci5qatLKjWalU8JmJdnGMPtIihNA04JRK/++WitE4TYuQZePvX7gfpQTma1rFv+7dMmpPjJx4WI=
X-Received: by 2002:a1c:750b:: with SMTP id o11mr28786227wmc.5.1634537712218;
 Sun, 17 Oct 2021 23:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211014142554.53120-1-lmb@cloudflare.com> <20211014142554.53120-2-lmb@cloudflare.com>
In-Reply-To: <20211014142554.53120-2-lmb@cloudflare.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 18 Oct 2021 08:14:59 +0200
Message-ID: <CAJ+HfNjwYtg+8ZWBNaL08afQJpOQ6m0tUiTjhTtLBBoLDdxAmg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] bpf: define bpf_jit_alloc_exec_limit for riscv JIT
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     nicolas.dichtel@6wind.com, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kernel-team@cloudflare.com,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 at 16:26, Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Expose the maximum amount of useable memory from the riscv JIT.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Luke Nelson <luke.r.nels@gmail.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> ---
>  arch/riscv/net/bpf_jit_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.=
c
> index fed86f42dfbe..0fee2cbaaf53 100644
> --- a/arch/riscv/net/bpf_jit_core.c
> +++ b/arch/riscv/net/bpf_jit_core.c
> @@ -166,6 +166,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
>         return prog;
>  }
>
> +u64 bpf_jit_alloc_exec_limit(void)
> +{
> +       return BPF_JIT_REGION_SIZE;
> +}
> +
>  void *bpf_jit_alloc_exec(unsigned long size)
>  {
>         return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START=
,
> --
> 2.30.2
>
