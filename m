Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFA92DF553
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 13:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgLTMF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 07:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgLTMF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 07:05:28 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8ACC0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 04:04:47 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e25so7966779wme.0
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 04:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qrn+x9lX3jcTz2wVgUBrM7DkKsxjXEra+Jy1eyLqErQ=;
        b=naOTe06SHxPS/6OBbwjbFP5gEyKx1oosTrOeIpFENcucHkj6M4BfldEb5/KPevKmPh
         GEvTH5RMMRe8fhVSGC9wo6nFZZgYw7UuM5HUcD11IYQnXd9kNy3KL0KT73L/CUfAd/zr
         VqwkA7HvmRn839TISjpwe3EHBnX2wevB/duyQQGMN/q2vNXgBIwvahKUWHWKkeo+picP
         an/z/7NZC0ZBN9sH+GcEFEn0pGKl2erSIACTjL2vrUkSXWaQqrFrZmXOKPlcUF39/qrd
         tTjO1+HcQBilpqR+04mYryhDX+0xRWnwVe6rI5tgRh/6A1aPAovhMMOGYvrQB0QO91YH
         vOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qrn+x9lX3jcTz2wVgUBrM7DkKsxjXEra+Jy1eyLqErQ=;
        b=M1tRC+UX0o9UTDKr/IFJNh/BawgHOIyjF2mho5qdxbpNYUMX6sBQ2H4zmxkfi79I1d
         F1OU29NokPYeC0MD0o8IHty9cSCDoZ2V4U73XxtkEovJDIz3o4Dx3OxjG/kTpFQzzOLH
         qSXArmdvEXL6YBLlRrGwBxqhFhksyKbTquMXW2evw0114vy6cFOPKO+hRhRpPfULAVe5
         ZOSF6rx/ZkjGIYegMFdwun3SM0p80luwLA+DiAhrgX2S2TF4+eEBbDCYnA4Z59m/miX0
         juhpYM1xkSiHjQWNNAVYZdfTqK4Swdngg5ix6ucBtIBCXCAAny0qzhn7xp7ed3ugqhAs
         4BOA==
X-Gm-Message-State: AOAM532AJ/ybvdacMLc70HAG46daeAJkf9hJ6sb/mfjg+RXGmhRguqhb
        vajpWgmUCuE/W1ECNvnkKRRkVw==
X-Google-Smtp-Source: ABdhPJxKHrA3iDITLiCdMUF/9mnzJFyxnL6Rem0UwUvdhjFOojYMyvms6s//StCF5cJVpP/1sBw0Mg==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr11862312wmi.179.1608465886268;
        Sun, 20 Dec 2020 04:04:46 -0800 (PST)
Received: from larix.localdomain ([2001:1715:4e26:a7e0:ed35:e18a:5e36:8c84])
        by smtp.gmail.com with ESMTPSA id g5sm21652517wro.60.2020.12.20.04.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 04:04:45 -0800 (PST)
Date:   Sun, 20 Dec 2020 13:05:19 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 08/10] selftests/bpf: Fix array access with
 signed variable test
Message-ID: <X989/9omnIGyDvzV@larix.localdomain>
References: <20201220033457.2728519-1-sashal@kernel.org>
 <20201220033457.2728519-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201220033457.2728519-8-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Dec 19, 2020 at 10:34:55PM -0500, Sasha Levin wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> [ Upstream commit 77ce220c0549dcc3db8226c61c60e83fc59dfafc ]
> 
> The test fails because of a recent fix to the verifier, even though this

That fix is commit b02709587ea3 ("bpf: Fix propagation of 32-bit signed
bounds from 64-bit bounds.") upstream, which only needed backport to 5.9.
So although backporting this patch to 5.4 shouldn't break anything, I
wouldn't bother. 

Thanks,
Jean

> program is valid. In details what happens is:
> 
>     7: (61) r1 = *(u32 *)(r0 +0)
> 
> Load a 32-bit value, with signed bounds [S32_MIN, S32_MAX]. The bounds
> of the 64-bit value are [0, U32_MAX]...
> 
>     8: (65) if r1 s> 0xffffffff goto pc+1
> 
> ... therefore this is always true (the operand is sign-extended).
> 
>     10: (b4) w2 = 11
>     11: (6d) if r2 s> r1 goto pc+1
> 
> When true, the 64-bit bounds become [0, 10]. The 32-bit bounds are still
> [S32_MIN, 10].
> 
>     13: (64) w1 <<= 2
> 
> Because this is a 32-bit operation, the verifier propagates the new
> 32-bit bounds to the 64-bit ones, and the knowledge gained from insn 11
> is lost.
> 
>     14: (0f) r0 += r1
>     15: (7a) *(u64 *)(r0 +0) = 4
> 
> Then the verifier considers r0 unbounded here, rejecting the test. To
> make the test work, change insn 8 to check the sign of the 32-bit value.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
> index f3c33e128709b..a80d806ead15f 100644
> --- a/tools/testing/selftests/bpf/verifier/array_access.c
> +++ b/tools/testing/selftests/bpf/verifier/array_access.c
> @@ -68,7 +68,7 @@
>  	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
>  	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
>  	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
> -	BPF_JMP_IMM(BPF_JSGT, BPF_REG_1, 0xffffffff, 1),
> +	BPF_JMP32_IMM(BPF_JSGT, BPF_REG_1, 0xffffffff, 1),
>  	BPF_MOV32_IMM(BPF_REG_1, 0),
>  	BPF_MOV32_IMM(BPF_REG_2, MAX_ENTRIES),
>  	BPF_JMP_REG(BPF_JSGT, BPF_REG_2, BPF_REG_1, 1),
> -- 
> 2.27.0
> 
