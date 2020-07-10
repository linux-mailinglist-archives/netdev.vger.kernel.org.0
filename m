Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6A21BB97
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgGJQyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgGJQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:54:05 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFEBC08C5DD
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:54:05 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f5so7218472ljj.10
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0UCI+vE/H5YEMNhzArkLPkiIfli4eA98Ddz6rfQoAE=;
        b=jZK/7OrVXtX30S+NFpQlALDPq6xCyQiqDzUDKtmbnBYpY5pbNM8KZNfjFeOJZG+MyM
         /oH7lHovV8Oz/nPDSvoPOKWmC2PTkGeq2MzaUf6b4b4jiEZGyfjwwTquQpiYy117Lju1
         5cyccxAqVAAanN0yF+02cnIKObq+0JIOQqDVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0UCI+vE/H5YEMNhzArkLPkiIfli4eA98Ddz6rfQoAE=;
        b=ENgcCjhDELnw5GUX4FvTXG3IbBLA18/haPGdqyGj9l6Txpsr8Y7shp2lRlOfATf5FJ
         XB6itC5njYMyM9x2ptc9jaoj5fFHnaORtnCgQQuyaYnYwxz3FmLIdksZAY68RTl4YSbA
         tJSsP+8d1IE7m0/J+9feYywUzUDfraWLXPO49ZkDAt8QfC2WOI+hStz8DrEUHQiVUKo+
         nYCdyC8oTdcPVy3UPonuN2gJMfd4lRiXpLQ9RXu0p8KkxFiLTwHQ7BTBGZgosvEwt6xz
         +n09uDdD6WSLyzb3ZEWw3IZzrcOQ/bAeiZ7SBgzuL5GXi6A5pRGxebYsrZJsodItrLuv
         mfeQ==
X-Gm-Message-State: AOAM533MU+BdSutuJVJUGGv5bxj2srSFgtYx/iNyvdQUD+TjVc+yTKci
        INg9e3gO0rNEgMfE9BloTdeTrw==
X-Google-Smtp-Source: ABdhPJxcE085DZvWGPSpPnNdiuGFrUCCovySUBZOmQpIGKEtFXT01kX3wYYa1mdUgjSozvjPAhUZPw==
X-Received: by 2002:a2e:a54a:: with SMTP id e10mr41905143ljn.198.1594400043603;
        Fri, 10 Jul 2020 09:54:03 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id x30sm2347043lfn.3.2020.07.10.09.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 09:54:03 -0700 (PDT)
Date:   Fri, 10 Jul 2020 18:54:00 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, sdf@google.com
Subject: Re: [PATCH bpf] selftests/bpf: Fix cgroup sockopt verifier test
Message-ID: <20200710185400.153cef3b@toad>
In-Reply-To: <20200710150439.126627-1-jean-philippe@linaro.org>
References: <20200710150439.126627-1-jean-philippe@linaro.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 17:04:40 +0200
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> Since the BPF_PROG_TYPE_CGROUP_SOCKOPT verifier test does not set an
> attach type, bpf_prog_load_check_attach() disallows loading the program
> and the test is always skipped:
> 
>  #434/p perfevent for cgroup sockopt SKIP (unsupported program type 25)
> 
> Fix the issue by setting a valid attach type.
> 
> Fixes: 0456ea170cd6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  tools/testing/selftests/bpf/verifier/event_output.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
> index 99f8f582c02b..c5e805980409 100644
> --- a/tools/testing/selftests/bpf/verifier/event_output.c
> +++ b/tools/testing/selftests/bpf/verifier/event_output.c
> @@ -112,6 +112,7 @@
>  	"perfevent for cgroup sockopt",
>  	.insns =  { __PERF_EVENT_INSNS__ },
>  	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
> +	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
>  	.fixup_map_event_output = { 4 },
>  	.result = ACCEPT,
>  	.retval = 1,

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
