Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475235E84EE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiIWVbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiIWVbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:31:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA313D863;
        Fri, 23 Sep 2022 14:31:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lh5so3170871ejb.10;
        Fri, 23 Sep 2022 14:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PNe1IOPZZRAElJQvbFrNHmFIjgRyuMkrbemeQcf55Mc=;
        b=U7iUDhSzWpn6eUoq6O+J6MVCDtL4PSi25fIpv0Zxyi7nnoPEDVrryFmxtkcnRk74OY
         P2ysSpDGyLS09yNMI/stWlG5x41UUZlwV51a3JfehzGUUzi8d55RcmkYGRWjg1Dsc29a
         OciRMWmS7M392oyQ0IvI4zAdnO3F+b4r3J6NTp03YrR29h0aVMwIQ5zMJJ3w5/IY5yDf
         R/JqcIQ0uQ3kaTL1Xnox0lQsWrx1KvmxbxxF+KiyvLUMxy+hYIzh/sSEvmsFK+cRhjzb
         NzdBRRjwdMpZwxJ1PhsJC/8PU9iJS2o82FctafG0uMh0LW/2uPcvtK4QljSVJBZ7xKoY
         mx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PNe1IOPZZRAElJQvbFrNHmFIjgRyuMkrbemeQcf55Mc=;
        b=aZOcSteEz/wEUkaZM5v6tmmbdi+h6xaSjTP17lpBIOT5gSp8vV/WVoSJRXLJDxk4k7
         KUW3PKNeFG8lwl3cIH3gZGL9fNN9GFJ4gp4VQHlMgkORpcQ+Yu/KUg6QZyPLXpIuc3wQ
         NQVQ8zb0R4yDV6jC+4fkBaGp87zvVsC7MgUR6tMHwiHHgCUxGwj48HAyZ3uf6v+jFrXO
         7yt7VPQ49qG4rNzDv13UkJs4Lj1evfmRnknjxOXDXwTAqGdvCZfWUhk9fB998pU/BdBb
         A3Nc2NoFEovnXnH8ec9LmtnpIJzPR8sEZNq2JJgPWGcGR/+DVcdqT7hx1NS3+aHBA0TR
         y6JA==
X-Gm-Message-State: ACrzQf0pInUY2kvSOsliWE5Y4GXjYCfnTW74Pbie2eUnLDvvjlZaUNgO
        Be08ZX8Di6ruz/+43enjPlvF8+oKkE3daotHC9c=
X-Google-Smtp-Source: AMsMyM7feHuUoVXLUCMrfwsW2N2pC7DMsOGDMcdxi4iqTP4DHbKrZyvphFgCTaODLPxVZtTSrjTUSKJ6SFJ6dmwUng0=
X-Received: by 2002:a17:907:3d86:b0:782:1175:153f with SMTP id
 he6-20020a1709073d8600b007821175153fmr8899830ejc.226.1663968665007; Fri, 23
 Sep 2022 14:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <1663828124-10437-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663828124-10437-1-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Sep 2022 14:30:53 -0700
Message-ID: <CAEf4BzZuw57ywTOe8Yjar11r_A=XZLJjxx1mCJwG0y2PHhf6pg@mail.gmail.com>
Subject: Re: [bpf-next v4] libbpf: Add pathname_concat() helper
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 11:08 PM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Move snprintf and len check to common helper pathname_concat() to make the
> code simpler.
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 47 deletions(-)
>

You went a bit overboard with libbpf_err(). We need it only in
directly user-facing functions. I've fixed it up while applying. Also
moved buf and buffer size to be first two arguments to match
snprintf() order of arguments a bit closer. Applied to bpf-next,
thanks.

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2ca30cc..2d8b195 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2096,19 +2096,30 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
>         return true;
>  }

[...]
