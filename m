Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1682ACE8F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgKJEeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKJEeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 23:34:01 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6DC0613CF;
        Mon,  9 Nov 2020 20:34:01 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id f8so2284921oou.0;
        Mon, 09 Nov 2020 20:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5F+LG0H8FwJz3uR/PMa+Xyrt4zLmKFAZ+p5c6pKyZAA=;
        b=ftHMIlvuwLcWtYdGKJp32CEkZYul7r2CHP8MLtwLIXqFPeirJxVvyfLt7FM1kuB0U4
         N1po/qn3kR1ZNHoj8a02bys9zThS9pCG98ziwvHzwEZTYpxYB5vOmK2+wfpcUyxRqqAJ
         vfJdV6cIrrzf93NYjXWq8M+RSbuHFGxDTWJszNh5msrvUjVQUidouYqV9KoRGYN2qMg/
         iThmqFs1aGSwEbEajq5SChC3WDrH+epJ1HPwHk0uuz8h8MfokEK7ycXDd4lN8g74uBjl
         LfRIZc6U3rtpAOGDVJDHj6CShlFsQP0Hlb6WISaRDTzgvs6PrllqHaOMdMLUa829w/+j
         FcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5F+LG0H8FwJz3uR/PMa+Xyrt4zLmKFAZ+p5c6pKyZAA=;
        b=uN5qssBAdVVpNYsKjiNaH/JpdoJN6LMMpAuzYnRH/a36P/xuX3Y93gLadTQetSFiCb
         tc+y9B5dhqWWS0nNjYshE3e+JHCYTmm/5DNQu2ER/E00FKqkSXZPRcxlVDLKd43UP12K
         JTx8oGsLlDu7AKNFMTcOaQ8YLFLIp/QGbQ+K9WUJOS5PzCEJsInD7/o/UVyl3n/Gk/YP
         FUjZ4k3bofDNtOVliLWHfoZoVcVvVmOgzmu24RUwOxvEX8GCpi7RHQNGP4rAByY/lv30
         OI3VAU8CApnmK0kkeiM2FaOUB8UUgnX/jM0n7OjqsHFFcVl/vcomBk2iKRpkT0qEZeVn
         r8Nw==
X-Gm-Message-State: AOAM530CQQbF1U7lPKIp8cL07a0ewRYFpon8TJq3D/Jlp+YcPF1XvUMv
        EU5GiA6Avwef2QCSDJCOBcE=
X-Google-Smtp-Source: ABdhPJzlr3PKDMTi+GB0/SwUhcWdUNgB9zHfAoWwMpTrTmMfhNo7/dFOBi52QasLAGkmKIaxPtNNng==
X-Received: by 2002:a4a:c68d:: with SMTP id m13mr12363549ooq.64.1604982840702;
        Mon, 09 Nov 2020 20:34:00 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v5sm2391289oob.40.2020.11.09.20.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 20:34:00 -0800 (PST)
Date:   Mon, 09 Nov 2020 20:33:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>, quentin@isovalent.com,
        mrostecki@opensuse.org, john.fastabend@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        kpsingh@chromium.org, toke@redhat.com, danieltimlee@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5faa18319b71_3e187208f@john-XPS-13-9370.notmuch>
In-Reply-To: <20201110014637.6055-1-wanghai38@huawei.com>
References: <20201110014637.6055-1-wanghai38@huawei.com>
Subject: RE: [PATCH v2 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote:
> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> it should be closed.
> 
> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: use cleanup tag instead of repeated closes
>  tools/bpf/bpftool/net.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 910e7bac6e9e..1ac7228167e6 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
>  
>  	ifindex = net_parse_dev(&argc, &argv);
>  	if (ifindex < 1) {
> -		close(progfd);
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto cleanup;
>  	}
>  
>  	if (argc) {
> @@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
>  			overwrite = true;
>  		} else {
>  			p_err("expected 'overwrite', got: '%s'?", *argv);
> -			close(progfd);
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto cleanup;
>  		}
>  	}
>  
> @@ -600,13 +600,15 @@ static int do_attach(int argc, char **argv)

I think now that return value depends on this err it should be 'if (err)'
otherwise we risk retunring non-zero error code from do_attach which
will cause programs to fail.

>  	if (err < 0) {
        ^^^^^^^^^^^^
        if (err) {

>  		p_err("interface %s attach failed: %s",
>  		      attach_type_strings[attach_type], strerror(-err));
> -		return err;
> +		goto cleanup;
>  	}
>  
>  	if (json_output)
>  		jsonw_null(json_wtr);
>  
> -	return 0;


Alternatively we could add an 'err = 0' here, but above should never
return a value >0 as far as I can see.

Thanks,
John

> +cleanup:
> +	close(progfd);
> +	return err;
>  }
>  
>  static int do_detach(int argc, char **argv)
> -- 
> 2.17.1
> 


