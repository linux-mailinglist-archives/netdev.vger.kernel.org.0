Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4291A46E2F9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhLIHN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhLIHN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 02:13:57 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B4C061746;
        Wed,  8 Dec 2021 23:10:24 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e136so11524592ybc.4;
        Wed, 08 Dec 2021 23:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8/zQVMqJ3oaRLl2KbvluVtKang7j1BEzSF7SOiZ1qo=;
        b=DKRS877Fdf15OnPM+rHpkTXlleysdJyVI5SFXfigVczW+VtE8G4ELiSec/rz+nJ1qT
         qkwzSDjjpqhP90KqtW/ithyeCm8uzEIc89ZkD6+fGMEQYiYMhHt6eaIdlvv98kUHqEXb
         eF1g5nSINV00wm6v9oK+JWCfQqw0yfdMAv3dchmGaio3e61iytKtQoPZX9NesGs9iQcO
         1ruJPo0KswN7EQoMbUPTPU2EexSvcYsY1vm7UzjwKckWI0qrs5Y85jhFYTyIw6X3N7r5
         yDmUUYVRKfCi7Kgl3HwPU1M1fxTNi49u80mwo7g45aGRcD4QXggirX8aoj86FeKT1B4k
         mYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8/zQVMqJ3oaRLl2KbvluVtKang7j1BEzSF7SOiZ1qo=;
        b=XQGDmuS8BsL2/kkpk56CoAwk0EO/FsIuLQcUpxk4Nm1bqX7dbD0iZdNlxWrqsXs62G
         W7QZptHvBegei04KQVgPXsJnfnab3U7Cvhagp/6lQGxA5E18jol0tXz/pGN0itgJjCEv
         wEQEoygqHDTr7ko3qaVKtfoxmTpWJOoVrvopzE7/1576U9yNnF6BQiKNDjwvp0anpFJb
         1T+uBUf4PNiZC84IGi7uMmlL5DBb329g+fmcid+fcKebGT48gDN448M1AjWsX5P3fJfK
         PwwQbnzCMDef+lm+V31e3yle+1qkrnq/KMmOKvoyqK8qrPee35Xf1Icaiq2Zx/wxktCQ
         s9ew==
X-Gm-Message-State: AOAM530fXU8JaE4ss/K+lPJgOMrHBJIlK6Y39KXlC+hJOwKqbBz31sGI
        PE8YC0ZJVMQ4/SXeu9ZUwNcCvliDvtv/Fqj2agSCQpxtokE=
X-Google-Smtp-Source: ABdhPJx04MnMs9lClxuYtJlPwMHvlp2/P4s1Lc40fGaBtkstwsUnSrMpgoLoHJNil/AatKlfFX1/7ycWYD8VK25IEcM=
X-Received: by 2002:a25:e406:: with SMTP id b6mr4281128ybh.529.1639033823646;
 Wed, 08 Dec 2021 23:10:23 -0800 (PST)
MIME-Version: 1.0
References: <20211208113408.45237-1-hanyihao@vivo.com>
In-Reply-To: <20211208113408.45237-1-hanyihao@vivo.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Dec 2021 23:10:12 -0800
Message-ID: <CAEf4BzZcMo0ud-9_58939G8NxYYFmro7kO2rguCAM4hgDXEpOA@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: fix swap.cocci warning
To:     Yihao Han <hanyihao@vivo.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 3:34 AM Yihao Han <hanyihao@vivo.com> wrote:
>
> Fix following swap.cocci warning:
> ./samples/bpf/xsk_fwd.c:660:22-23:
> WARNING opportunity for swap()
>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  samples/bpf/xsk_fwd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
> index 1cd97c84c337..e82582b225d3 100644
> --- a/samples/bpf/xsk_fwd.c
> +++ b/samples/bpf/xsk_fwd.c
> @@ -653,9 +653,7 @@ static void swap_mac_addresses(void *data)
>         struct ether_addr *dst_addr = (struct ether_addr *)&eth->ether_dhost;
>         struct ether_addr tmp;

this variable needs to be removed as well then

>
> -       tmp = *src_addr;
> -       *src_addr = *dst_addr;
> -       *dst_addr = tmp;
> +       swap(*src_addr, *dst_addr);
>  }
>
>  static void *
> --
> 2.17.1
>
