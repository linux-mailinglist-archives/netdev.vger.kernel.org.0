Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DEF2AD705
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgKJNCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJNC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 08:02:29 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7BFC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 05:02:29 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so17438698ejb.7
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 05:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Tu26tgPcSzxp0jQayLJ0lZvINdp+uKPsES6yIreZi1Q=;
        b=J37h17ukYjnSQ06PMZH5y5/tzwpw0UAVvpQcZ4n7aJNVAP1KfdTU+SAyebZbGkb/gx
         JkW1aY8B/ImWJ2+SdKR3pyWJ113065WzkEKZUJQ87VSnH58zdQ5VYpclo5eK2mxCjUUQ
         7jK68BNNzPAim2Fce1tVyS4D9zF9+jxPqFvQR+bRJ9r+C1KV+VQ25Cl7u2kn+a7xvYUS
         AP28yDfhZ0KnKslfKBYBXRWjz1hHTRlhkBRyz3P8oEv0oTOhLxdN2XanOjsvUO5wBidn
         TioyayLMQ+HkhcVU6ZJIqQJY9nIfNDGV29VqiLyBpWlLLW/8ssjnXVcY0A0ArJrHW+40
         nrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Tu26tgPcSzxp0jQayLJ0lZvINdp+uKPsES6yIreZi1Q=;
        b=YLoA8V3BKi8ihcR2qp4uSHFYhrbyFAyc0d4fCXfJmZ2xzlS04V34cM2zTD+49p2uMI
         6gIbalZ/mFc3CUUGpPxnN8l77c2yflyiVSBGuit0wt9Nwj1wl+RtZ7g5yl2fAS4+Y2eE
         zH1KKefiGsCm4tzNAfaN3LIrOOlh3eghuppwghn9qi1Imc29s0wiG931cvvFwZPelf7b
         uDJiQhDqf4ZdWLxkXS7fs/kdyOIwRXhfMoplfkYODCs5J6f1A81AJAFAxGRXns0Ioi/m
         3mW+tNEBFgaallguncWOO7sKp/0zw1QXvln+3SJopoRVos/w3y9+9uxB9r3Hzzcb5ZEC
         8njQ==
X-Gm-Message-State: AOAM531T1+CbiW0515I3Wfm7OyqVowFD0XedhtyOLGbXbaxXIBfVGEsZ
        fgsCVCsQAr3msvgugnIB4s0g5lecm+wiUBz4oJ7GnA==
X-Google-Smtp-Source: ABdhPJwuyoPs8El5On7U+y39tdjDDjB2kFrwRvDLNnSTklVWmV/GlCYDQiy/n5BDlXgqD3X/nyFVhztXCMVnKimvvbo=
X-Received: by 2002:a17:906:82c4:: with SMTP id a4mr18897731ejy.131.1605013348332;
 Tue, 10 Nov 2020 05:02:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:380d:0:0:0:0:0 with HTTP; Tue, 10 Nov 2020 05:02:27
 -0800 (PST)
X-Originating-IP: [5.35.10.61]
In-Reply-To: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com>
References: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 10 Nov 2020 16:02:27 +0300
Message-ID: <CAOJe8K2tL5x-dESsV+PFq1Gii-yB=fJh7i-=E-FbrJeioo6pqA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
To:     xiakaixu1987@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20, xiakaixu1987@gmail.com <xiakaixu1987@gmail.com> wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
>
> The unsigned variable datasec_id is assigned a return value from the call
> to check_pseudo_btf_id(), which may return negative error code.
>
> Fixes coccicheck warning:
>
> ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared
> with zero: datasec_id > 0
>
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  kernel/bpf/verifier.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6200519582a6..e9d8d4309bb4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9572,7 +9572,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env
> *env,
>  			       struct bpf_insn *insn,
>  			       struct bpf_insn_aux_data *aux)
>  {
> -	u32 datasec_id, type, id = insn->imm;
> +	s32 datasec_id, type, id = insn->imm;

but the value is passed as u32 to btf_type_by_id()...

btf_find_by_name_kind() returns s32


>  	const struct btf_var_secinfo *vsi;
>  	const struct btf_type *datasec;
>  	const struct btf_type *t;
> --
> 2.20.0
>
>
