Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174CC2ADE8D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgKJSlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJSlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:41:23 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11414C0613D1;
        Tue, 10 Nov 2020 10:41:22 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id t33so285041ybd.0;
        Tue, 10 Nov 2020 10:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wpJ5lPaXtgiF4jb8/8Ul562NL/AWQ6eFgS7XO9bceks=;
        b=RUT1/dsGddDLZa8O7Lq0juEg8peHH5XcGzBzWdLs34c6F0zj0kiTRxktHDdyPhNrwa
         BvBVz0d+vyLRXhkGNy9P9MapxdSbt26mPeIUhhkMxxL9oJDZnHep3rPkY7/aaLo1ZtWS
         HbOVkEsxgIjjkZOvoWCf85lUzoVKe+f1zMvKTIZdA2TjbdUbKZ5Yaq7TUO/1Kziya0Gv
         omGaOpVFUov/1t19chQRY/j3nq7b7hcjo4f3hi/IvAIK5mUmfNcwP2R+O+mZbmp5AlvO
         wwIVGpRV6s7UvHa7LM/Y+JIMWP+VdfKoRzZmAL3+yGgo5Ng6a+MTocgRsxY+VUCFGzER
         qAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wpJ5lPaXtgiF4jb8/8Ul562NL/AWQ6eFgS7XO9bceks=;
        b=FYq+PsNCBwLboVLqsCSQ+gWDWM+Zs3WOdC2jYUWpiEShy+3jiXjBYUKGi9uzt/sunQ
         tNJJX4vqGLERjdqiIt/KRJmFj0aTmKWZAQLid4dzr/BDPq8Xrcr/OQWFAAdZI6HqrdFO
         5la0QnH/JsAw8y1BY0vMhVbZuPHf0BRaEyF4c5/YS0VdcYyhaHlb3a4H7ZtJIqaRpXKy
         CpPccQE8OxzB7c+0YS5L/+iTRxZlfX8b6NDVpJ+oSAWhhnjXZd36QV/8SxNN5xQMswLc
         yeGZytGhRIuujZV2iOm/yoyBw/+iIg7hcrBN5foChL7MZ6qy1V9GM4B65fa1mDg6Wpfk
         vj8g==
X-Gm-Message-State: AOAM532xuELJ66ekKhcVrVShJ3u1km7Wt278NHd1W4WcHHu668JRpskJ
        Rx/2fXQn19O5Tkg/Cs0oux40fmm2Pij0Msq3RnM=
X-Google-Smtp-Source: ABdhPJwoWlvUAx5wdNafJmm9h4F7cD6LfDv7C2qg26O74l7AxqBJQo7YQf+lYNGTCiIp6A28GQtKTlUSoT8yO1uVL4k=
X-Received: by 2002:a25:e701:: with SMTP id e1mr3977083ybh.510.1605033681253;
 Tue, 10 Nov 2020 10:41:21 -0800 (PST)
MIME-Version: 1.0
References: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com>
In-Reply-To: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 10:41:10 -0800
Message-ID: <CAEf4BzbUW+rzk1KE3---j3d2-YD_HOxKLNUPW=_AL63Qn5pHkg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
To:     xiakaixu1987@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 3:50 AM <xiakaixu1987@gmail.com> wrote:
>
> From: Kaixu Xia <kaixuxia@tencent.com>
>
> The unsigned variable datasec_id is assigned a return value from the call
> to check_pseudo_btf_id(), which may return negative error code.
>
> Fixes coccicheck warning:
>
> ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0
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
> @@ -9572,7 +9572,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>                                struct bpf_insn *insn,
>                                struct bpf_insn_aux_data *aux)
>  {
> -       u32 datasec_id, type, id = insn->imm;
> +       s32 datasec_id, type, id = insn->imm;

you are changing types for type and id variables here, so split out
datasec_id definition into a separate line

>         const struct btf_var_secinfo *vsi;
>         const struct btf_type *datasec;
>         const struct btf_type *t;
> --
> 2.20.0
>
