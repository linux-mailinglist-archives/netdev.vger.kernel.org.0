Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C747046F39C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhLITJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhLITJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:09:00 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7141C0617A1;
        Thu,  9 Dec 2021 11:05:26 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id l5so6283604ilv.7;
        Thu, 09 Dec 2021 11:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=whDASlWsvn8ElvpjSYq4yIvM0F0+s8je6qXAh87TnZE=;
        b=Fb2Tjujt9h7pDtTb/03uocALiESZZpLf3HWQrRtAC22WyTn0aESNm2irUedMKAHoVo
         7QeM9YYk74OjTVbzB9CvYB012bCb5vRsMQvRBDVex8uH5EYxaK7Xv6cXNBxgT5dUDBtG
         eqcCAJSNxEEGf2pfnZynB+FApq091uSLVvxY3SLuY3iTf0sLSJsjbZW3tFXub9rqFn52
         jeKoDLLfs+j35UrztwhoPFM1K1nX8QOl++Df6KsXrGcaMrsM1eRGzkmxy3uvo7ORKUK8
         Gfu58Abt0o/iI4xstHpWvAPZUqBtn8re88UeNXKm0xoAjSqTN9VL/A2/1xMMWiMVA0dW
         AL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=whDASlWsvn8ElvpjSYq4yIvM0F0+s8je6qXAh87TnZE=;
        b=c3szuen5G0+U8ZOjKnEdsVr++PXF8sorSLQvwbRfZg6+A+9TWAhqv9PSQLQevZ6ltV
         JAj/pNtE/2x7YsrMEet/snBfX906Z7BI++aFxOtfUAkXKOP2bAexQxQJzmzkDMYKTMU3
         WXeYYhtkKCe/fosBEZosde7iWGZcwwfdnoZ7jeQJnTdM7G9e93bcJdYbyCxge/2Hz1AH
         CfU8dBXOP/gHaF9OCAfgjRwj+lU7ry9hckXz8mVg1Jc83OfvKWK3n/Mw0wQWxe3fRe+P
         q6xqCGIAXpiSvlLT674h40xEsyS5etE26cXzQHXTf2/q5KWvqgKFnAnAK8WrEHbSFHIR
         sDHw==
X-Gm-Message-State: AOAM533f7U8Bw26JlLWvqetOBiicisxqoVT0WjQwjQ22YJ9WFZGc3PEI
        snkebsafci3xSr3GAB4Re0s=
X-Google-Smtp-Source: ABdhPJyERbjdICPv6yJnsI13N4HZudZML8dsKHdzduV+A0xmBmYPD84FeK+KvkGhKVlcZOnOaqnmxQ==
X-Received: by 2002:a05:6e02:188b:: with SMTP id o11mr14455636ilu.43.1639076726320;
        Thu, 09 Dec 2021 11:05:26 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id b6sm394550ilv.56.2021.12.09.11.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 11:05:25 -0800 (PST)
Date:   Thu, 09 Dec 2021 11:05:18 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org
Message-ID: <61b2536e5161d_6bfb2089@john.notmuch>
In-Reply-To: <20211209134038.41388-1-cascardo@canonical.com>
References: <20211209134038.41388-1-cascardo@canonical.com>
Subject: RE: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not
 possible
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:
> When a CBPF program is JITed and CONFIG_BPF_JIT_ALWAYS_ON is enabled, and
> the JIT fails, it would return ENOTSUPP, which is not a valid userspace
> error code.  Instead, EOPNOTSUPP should be returned.
> 
> Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  kernel/bpf/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index de3e5bc6781f..5c89bae0d6f9 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1931,7 +1931,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
>  		fp = bpf_int_jit_compile(fp);
>  		bpf_prog_jit_attempt_done(fp);
>  		if (!fp->jited && jit_needed) {
> -			*err = -ENOTSUPP;
> +			*err = -EOPNOTSUPP;
>  			return fp;
>  		}
>  	} else {
> -- 
> 2.32.0
> 

It seems BPF subsys returns ENOTSUPP in multiple places. This fixes one
paticular case and is user facing. Not sure we want to one-off fix them
here creating user facing changes over multiple kernel versions. On the
fence with this one curious to see what others think. Haven't apps
already adapted to the current convention or they don't care?

.John
