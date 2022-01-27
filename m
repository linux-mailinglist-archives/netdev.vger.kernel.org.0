Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECE949DFBE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiA0KsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbiA0KsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:48:18 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBBBC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:48:18 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id s13so4929194ejy.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AzOHmZ2n9+gsqUuicrYJlhYW5U/YGENeiTXZgdwdecQ=;
        b=GjFYtKexJXjCC2HBI1UDTG+OgIPhwu5Xdb2VPH+val+8BijKTI/NCUsMgy85sqBx9U
         IwRaTauFhD5r4ENsT0Xw5/ZrBeJYEVwaacKxYKhIVvU+VL9biwSLVfWlNvBMkCpVB82T
         Vlqlckjrga4eRNT6+ZD0zaVlFKeNRTV5/VDCbpj7EIcxPrihERYxkITY5Is4LkFhgD5a
         cc6dZubXrc00xtXRZ5QupfV1cn2QQSbuIxyYYnnCJbG8QSLEVLdGU4pLgaUrHAuvQE59
         h0eeELZC4tYhgJXxpEsoisnLe6we/bJyXnH5tCKQ1EesovMivAxrTVfpqR7KE3ypTWkw
         xcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AzOHmZ2n9+gsqUuicrYJlhYW5U/YGENeiTXZgdwdecQ=;
        b=LOr2pN7BTogDDXo6gSRzJLSrgHTBMLZWDL+fHGIl9jPGjENPs7TCXC8rTkPUg59b6c
         ZUomLWQr/e7v7QR1SWTl8iKBBr8FZweXzasl1QkyF2pittw7qe9yo5mX5PLkB+yAoo5p
         0YsfxgnBJQJWhvlKZRYy2YCsvH+UgbonjbI5O5CHV0x414eyHPdF//OqZMcvk0BqfdRI
         zRES+xhu55KlTdOanftzDOKigDQ36mkSelRCiTsF6jbHxqets7nfjOZd7tvSFuj6f2rF
         8xW/GPVnH5x0p3XZ0/0F32OMUoxRFET8qHHNnqbaXL7C+Upm4XeiIRA0gbEM3fHVsSY0
         dQrg==
X-Gm-Message-State: AOAM533uGk16EMkQo0xf8HMk7tsP8VCwIV98F0joEPLN3hiNpXmx+HhZ
        aKxpbkYnqei/tU92u9O78/lMw4az9e2MsX75pCc6KQ==
X-Google-Smtp-Source: ABdhPJwUvrZCQQ3V4jxxg3A1li1+Vftf/mj2106/RMlhBLDJD9f9yDvtRBh3SX+om2TI+Ket5Oaqk2ycOeGV+kBIOA4=
X-Received: by 2002:a17:907:6091:: with SMTP id ht17mr2504214ejc.626.1643280496825;
 Thu, 27 Jan 2022 02:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20220127083240.1425481-1-houtao1@huawei.com>
In-Reply-To: <20220127083240.1425481-1-houtao1@huawei.com>
From:   Brendan Jackman <jackmanb@google.com>
Date:   Thu, 27 Jan 2022 11:48:02 +0100
Message-ID: <CA+i-1C2HBja-8Am4gHkcrYdkruw0+sOaGDejc9DS-HfYVXVfyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, x86: remove unnecessary handling of BPF_SUB
 atomic op
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yep - BPF_SUB is also excluded in Documentation/networking/filter.rst,
plus the interpreter and verifier don't support it.

Thanks,

Acked-by: Brendan Jackman <jackmanb@google.com>


On Thu, 27 Jan 2022 at 09:17, Hou Tao <houtao1@huawei.com> wrote:
>
> According to the LLVM commit (https://reviews.llvm.org/D72184),
> sync_fetch_and_sub() is implemented as a negation followed by
> sync_fetch_and_add(), so there will be no BPF_SUB op and just
> remove it.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index ce1f86f245c9..5d643ebb1e56 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -787,7 +787,6 @@ static int emit_atomic(u8 **pprog, u8 atomic_op,
>         /* emit opcode */
>         switch (atomic_op) {
>         case BPF_ADD:
> -       case BPF_SUB:
>         case BPF_AND:
>         case BPF_OR:
>         case BPF_XOR:
> --
> 2.29.2
>
