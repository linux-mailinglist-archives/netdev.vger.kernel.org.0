Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA711B4AAB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDVQfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgDVQfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:35:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A818C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:35:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hi11so1170590pjb.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u2ScrTFtpLFJxVN4XFMf9MuOT7jfLP+hNX2x6Ndf3VU=;
        b=knxoKKVhnNk5QjdqRCA5AIjmeF34Q/wTFe1DqR5Aod0K7Dzh0r9japbanoKDAM8nJl
         pmCxLHdjZxYhlSVGsed62obUiqucayoqM25d5sljlZfoPsWH/vhrC06y2rxpuvLWNiBU
         ehPKA5tZSlf4wwO55hrFRHx4yCiCfc0gGMeUgN9EBvuUjSf2OhLMyqtvYVhIdbb14sn6
         OwbrsYjazVqFINpJq/1TmoYtpyujST5whHTrspbXiT1tOJloG+b9O6HRAp/hbhQhKVtZ
         0g4YI48/K0cd9+OzhyWDtHg2Geqs3Ow6ieKcuB1xGFrdOyX2ityOJdMP33oKUBHZaMa+
         wajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2ScrTFtpLFJxVN4XFMf9MuOT7jfLP+hNX2x6Ndf3VU=;
        b=PdlHjFMkkDOZ/PKEQ5lsG3ORyQKxIVeC24xKxrKjdXaQ8UfRNIgAl3T4++U2PSGMGz
         TVfM2ylpEbYg82HdkcGU99JTNCQvwWO/lvQG5Iw1jfzJ8WQkQ/prTl7TLn//CcE+f+w8
         2yHgkQMJcXggf2QnyvGI2YmUcERdIlOvl9Dq0x/fEEytZOaya0R8HrmuQdgn4KJh5b8K
         zMFiGi1oS4kbRDNyQghx4HjVqGyF++1iifFNZZ9PuS5pZxGegm1Svhae2Lpeo037L7uD
         Vhh0b90TivunIiGt82v3xKSagw1JI9DVuHz1hdvqgs7ElDA1ySvsOJf9oSo+aY2po4SP
         uO1Q==
X-Gm-Message-State: AGi0PuYC9LZ20gl7nbl3PSOkuGHq5npwo7GXfJHW3jqFavX69osBcfP5
        Cs+YWgnARGRWYBovgewXozyB3g==
X-Google-Smtp-Source: APiQypI2AvCfy40ie2FJqPMBX/BccFfnq4Qew41/+vLGp8Fnag/ClFg+/93kozb73FAT+zRRKUobPQ==
X-Received: by 2002:a17:902:740a:: with SMTP id g10mr27366370pll.137.1587573339811;
        Wed, 22 Apr 2020 09:35:39 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k63sm6046958pjb.6.2020.04.22.09.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 09:35:39 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:35:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning
 is used
Message-ID: <20200422093531.4d9364c9@hermes.lan>
In-Reply-To: <20200422102808.9197-2-jhs@emojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
        <20200422102808.9197-2-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 06:28:07 -0400
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> From: Jamal Hadi Salim <hadi@mojatatu.com>
> 

This is not a sufficient commit message. You need to describe what the
problem is and why this fixes it.


> Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
> 
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  lib/bpf.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 10cf9bf4..656cad02 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1509,15 +1509,15 @@ out:
>  static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>  				const char *todo)
>  {
> -	char *tmp = NULL;
> +	char tmp[PATH_MAX] = {};

Initializing the whole string to 0 is over kill here.

>  	char *rem = NULL;
>  	char *sub;
>  	int ret;
>  
> -	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> +	ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));

snprintf will never return -1.

>  	if (ret < 0) {
> -		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
> -		goto out;
> +		fprintf(stderr, "snprintf failed: %s\n", strerror(errno));
> +		return ret;
>  	}
>  
>  	ret = asprintf(&rem, "%s/", todo);
> @@ -1547,7 +1547,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>  	ret = 0;
>  out:
>  	free(rem);
> -	free(tmp);
>  	return ret;
>  }
>  

This patch needs to be reworked.
