Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F3C279540
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgIYX4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIYX4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:56:24 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B997CC0613CE;
        Fri, 25 Sep 2020 16:56:23 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id k25so3790442ljg.9;
        Fri, 25 Sep 2020 16:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Uqu6+9M4Zs0hycbaOsCnW7fLudpuf/w+ief3nLrjVs=;
        b=PQhG7ZdfxPF+I5oqb+SNngGw8juJR1rj8Bq3SRmAGPqDAW08bWua4lTntsy9JfD+7Y
         /EFmlV9FJmvZBfd5o79DC2Zw1R8Rkwfc3Km7lCXHurrStMk1AIHa5hR9ueGCeAXgrLAL
         W8IhSt5iifUsuH2rjrJujIp363vYWf57KMlNLqghioWiKT+hRQTxzWitMXvaGUtmsJvA
         9V9E+DGOo0EuUyNX2ZEM20xTsI/Pdr00qxm5ikiEGQ3c3S91L5qFY6vOlBfViMz2BXJ7
         1bNaLfLoA6lIzLmL1cz0pL6InLH7OLbf5rrhNVTqP+IpbiIdttWXoqL6ThoBUj+AgS8w
         cZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Uqu6+9M4Zs0hycbaOsCnW7fLudpuf/w+ief3nLrjVs=;
        b=Khw9vVHwVLWhqmG1vDf0uaP+2aOdkxWd/TP3S5ansnLArRb1FYdIL2fnxjQz3/yM1z
         OsYtXDySpfQAa9qw5HIRAlobwXi4NKnyGs1/+1eEbQsiopn/Mhrn0QIERV7Z3DywP0yZ
         RE2iW7sT42c+aJxOVk3jgIQJxTBGKOX1mUeXGsZadik5SNP0KHeEntao5MZZxb3MUarI
         IVwLpu0UkjMcIZWgG7NS5F8zNbTSkx35QyzWT5LLa3iX8XYa3r8kZnxpOInuICATYpWp
         JhsUNQsPcEaWS7l2WKzpAV2a/MukZEnk27ucwgmmhEKpum5G2IGd32VKU0OTyjwCWwaG
         caqw==
X-Gm-Message-State: AOAM532Aj8s3OnognDTcdozwK2dXd5Ssyw3FOT2YVikxZlXvZn5z2ZgR
        fIqV3b6cgx7xflpE5vpIpPm60nsJsQSIuR58P/0=
X-Google-Smtp-Source: ABdhPJypVDbi6lIR6Xt9BqTiGlwM8eTglGgJq/GXwjxVJm7at6LLudI45ep09eV76RccS74SmQglTOLGj2zDR69mlrY=
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr2197977lji.283.1601078182178;
 Fri, 25 Sep 2020 16:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
In-Reply-To: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Sep 2020 16:56:10 -0700
Message-ID: <CAADnVQ+5CbptcUpjJN8bP64zrwu1j3doz+iyDEoH6mApELLNWQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/2] bpf, verifier: Remove redundant
 var_off.value ops in scalar known reg cases
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:45 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> In BPF_AND and BPF_OR alu cases we have this pattern when the src and dst
> tnum is a constant.
>
>  1 dst_reg->var_off = tnum_[op](dst_reg->var_off, src_reg.var_off)
>  2 scalar32_min_max_[op]
>  3       if (known) return
>  4 scalar_min_max_[op]
>  5       if (known)
>  6          __mark_reg_known(dst_reg,
>                    dst_reg->var_off.value [op] src_reg.var_off.value)
>
> The result is in 1 we calculate the var_off value and store it in the
> dst_reg. Then in 6 we duplicate this logic doing the op again on the
> value.
>
> The duplication comes from the the tnum_[op] handlers because they have
> already done the value calcuation. For example this is tnum_and().
>
>  struct tnum tnum_and(struct tnum a, struct tnum b)
>  {
>         u64 alpha, beta, v;
>
>         alpha = a.value | a.mask;
>         beta = b.value | b.mask;
>         v = a.value & b.value;
>         return TNUM(v, alpha & beta & ~v);
>  }
>
> So lets remove the redundant op calculation. Its confusing for readers
> and unnecessary. Its also not harmful because those ops have the
> property, r1 & r1 = r1 and r1 | r1 = r1.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks for the follow up.
In the future please always cc bpf@vger for two reasons:
- to get proper 'Link:' integrated in git commit
- to get them into a new instance of
https://patchwork.kernel.org/project/bpf/list
  which we will start using soon to send automatic 'applied' emails.
