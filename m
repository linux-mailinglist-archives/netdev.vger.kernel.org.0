Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D487642EC88
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhJOIjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 04:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235726AbhJOIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 04:39:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BECAC061570;
        Fri, 15 Oct 2021 01:37:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso8831283pjb.4;
        Fri, 15 Oct 2021 01:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CXlRCtGL7o0DzwzbIwbfJ2qRa+xgnxwuo7fjUGe9gzE=;
        b=IRt2SM/IS0fu266dFWyoQfxvRKB2Ma/1LgkI19fHHKzJqRm59Z/EpaHG9efk/m2e+B
         GB6HQaso0B6JlLrRasVi+aiQxVF2NwQyeW3V2AhgaBivfMqYS/ZcK02j72tHsjq6m5eU
         vvuqAK6OVBpBNRGmu0aAcFvi3d/61JxHNB4SWrnCj/qtWbvJPa5FSSG9sfcwbHBoykG6
         e8jh9jVkETAkux2aFM8hF7JrrF7f9hMQ0xQxxhZtGELNJS9E4vnrfRwKA56jz633TTlA
         6TlszRHraNvY2M2xCTh+eIiUbtWozJiBWKZmm2d5VM/1Dad2s8oNfjqURMG6YgqMQQ7J
         VxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CXlRCtGL7o0DzwzbIwbfJ2qRa+xgnxwuo7fjUGe9gzE=;
        b=VFFmyutrRGePYcNaYvtMVtzpdEERvusfI8I/9XuSRKqEGoEDKNifzt9mxwZdXStUP7
         rYx9rHyQFr1VJ0oaqf2UpUTNErrLmcNcKpIWbuIoWQv0dRBoollbaPi+kUDheBiORWdf
         2AZMegh/KMWfrOQyTFWRzowcXIkHwdEdF8SyUbiFgG6ZkJXKVMw0k/hiOEkBT6F0k+6r
         Ebqe0lgENuX6iyyRsGRU7X5tQK7CXiaDgdplOiWw5KATdoKPOuH6QNtbgSVGtXWEzp6z
         kP2uq+VGlk/5cnwh75Q5lbhDh0XJ1FDD20O4tf9LZ8QM+QXi1t/VnnexVvCQBbmHTpoc
         4GmQ==
X-Gm-Message-State: AOAM531yzl84RP5KzjecgQ/rGOz5W6hMwieVkew2/IlWFBxdzw4L4m4F
        ihkNThGKg85cXx2j6/W1uRG7dKFrzPQ=
X-Google-Smtp-Source: ABdhPJxBaQcV9BBNyIgR3hqz3y3dQApwi6IK+DRsCF18ofgA6GBK63UZELMgxRxFVMDEjHxl6tC3cg==
X-Received: by 2002:a17:90a:bb82:: with SMTP id v2mr26433089pjr.57.1634287028654;
        Fri, 15 Oct 2021 01:37:08 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t9sm10809162pjm.36.2021.10.15.01.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 01:37:08 -0700 (PDT)
Date:   Fri, 15 Oct 2021 16:37:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: add SM4 GCM/CCM to tls selftests
Message-ID: <YWk9ruGFxRA/1On6@Laptop-X1>
References: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tianjia,

The new added tls selftest failed with latest net-next in RedHat CKI
test env. Would you like to help check if we missed anything?

Here is the pipeline page
https://datawarehouse.cki-project.org/kcidb/builds/67720
Config URL:
http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/388570846/redhat:388570846/redhat:388570846_x86_64_debug/.config
Build Log URL:
http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/388570846/redhat:388570846/redhat:388570846_x86_64_debug/build.log
TLS test log:
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/redhat:388570846/build_x86_64_redhat:388570846_x86_64_debug/tests/1/results_0001/job.01/recipes/10799149/tasks/19/results/1634231959/logs/resultoutputfile.log
Command: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
Architecture: x86_64

Please tell me if you need any other info.

Thanks
Hangbin

On Fri, Oct 08, 2021 at 05:17:45PM +0800, Tianjia Zhang wrote:
> Add new cipher as a variant of standard tls selftests.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  tools/testing/selftests/net/tls.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 97fceb9be9ed..d3047e251fe9 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -29,6 +29,8 @@ struct tls_crypto_info_keys {
>  	union {
>  		struct tls12_crypto_info_aes_gcm_128 aes128;
>  		struct tls12_crypto_info_chacha20_poly1305 chacha20;
> +		struct tls12_crypto_info_sm4_gcm sm4gcm;
> +		struct tls12_crypto_info_sm4_ccm sm4ccm;
>  	};
>  	size_t len;
>  };
> @@ -49,6 +51,16 @@ static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
>  		tls12->aes128.info.version = tls_version;
>  		tls12->aes128.info.cipher_type = cipher_type;
>  		break;
> +	case TLS_CIPHER_SM4_GCM:
> +		tls12->len = sizeof(struct tls12_crypto_info_sm4_gcm);
> +		tls12->sm4gcm.info.version = tls_version;
> +		tls12->sm4gcm.info.cipher_type = cipher_type;
> +		break;
> +	case TLS_CIPHER_SM4_CCM:
> +		tls12->len = sizeof(struct tls12_crypto_info_sm4_ccm);
> +		tls12->sm4ccm.info.version = tls_version;
> +		tls12->sm4ccm.info.cipher_type = cipher_type;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -148,13 +160,13 @@ FIXTURE_VARIANT(tls)
>  	uint16_t cipher_type;
>  };
>  
> -FIXTURE_VARIANT_ADD(tls, 12_gcm)
> +FIXTURE_VARIANT_ADD(tls, 12_aes_gcm)
>  {
>  	.tls_version = TLS_1_2_VERSION,
>  	.cipher_type = TLS_CIPHER_AES_GCM_128,
>  };
>  
> -FIXTURE_VARIANT_ADD(tls, 13_gcm)
> +FIXTURE_VARIANT_ADD(tls, 13_aes_gcm)
>  {
>  	.tls_version = TLS_1_3_VERSION,
>  	.cipher_type = TLS_CIPHER_AES_GCM_128,
> @@ -172,6 +184,18 @@ FIXTURE_VARIANT_ADD(tls, 13_chacha)
>  	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
>  };
>  
> +FIXTURE_VARIANT_ADD(tls, 13_sm4_gcm)
> +{
> +	.tls_version = TLS_1_3_VERSION,
> +	.cipher_type = TLS_CIPHER_SM4_GCM,
> +};
> +
> +FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
> +{
> +	.tls_version = TLS_1_3_VERSION,
> +	.cipher_type = TLS_CIPHER_SM4_CCM,
> +};
> +
>  FIXTURE_SETUP(tls)
>  {
>  	struct tls_crypto_info_keys tls12;
> -- 
> 2.19.1.3.ge56e4f7
> 
