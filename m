Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC4E188F3F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgCQUqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:46:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41196 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCQUqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:46:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id z65so12594212pfz.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mPDz0BzN1ITiZwsAROIyJH10tNV4hhAAcNsJOYU4Snk=;
        b=PwN9et7O2fLi7u0joL99yoHPbLTkSsukKHRDcM4FRtxUIGqcSBdDCqQTyWgK/ED110
         kgUl8ZZh2yGIVqwqRpRmaxo/yohkb3CttZLd7czElBRN3Kmwog6PyaVGyIQ+TZuxSi4F
         +m5GvrXMwapSDS/DykcHny70rWW8JuySXNxjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mPDz0BzN1ITiZwsAROIyJH10tNV4hhAAcNsJOYU4Snk=;
        b=BX7zAhgFJo4WRVJu7ruZsdOIRaOBqhlQEgG2UQ40Cqs0lMKeTL6TBtgtkLA7VLFX1K
         jyO2QRb/RRx6XLbmKw9WbosPOf6/b1fmS751VwyKkKkIZG9ZjvkfqM4EiBmRpoDNx5cy
         0IuTwczT20J5K2wJAwZphUVzlSWBwk5xJPFd0N061eg38TTkRUtRMOjCvJ43MNw/LBF1
         lMNqXrQ0UUFb9bRTFHNvl1ya6xPi8rLI2DEADVEfWIjE89yEsSl9SaKt7FSbV2syG7c/
         pefjpfepgajllcxmaxULb5lonAMCb9+ECgdK/FeIAZlkNOX/Pv1GtL+R/ZzhiEgxN17V
         WTAQ==
X-Gm-Message-State: ANhLgQ1OrbcFItIFRMw85pacoBEENJr7/RfYde16wv+4aoPS2T10C+c0
        Jjjyw+5FS3P72NroDxa1KdstZQ==
X-Google-Smtp-Source: ADFU+vtum99lFjhO4NcdtK3u57Y5a6tjGbDRM03nRyftMHg7s1Dd+puqGoWf8Oqn30D0O0mk3zM33Q==
X-Received: by 2002:a62:e803:: with SMTP id c3mr629425pfi.31.1584477969009;
        Tue, 17 Mar 2020 13:46:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w15sm1629028pfj.28.2020.03.17.13.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 13:46:08 -0700 (PDT)
Date:   Tue, 17 Mar 2020 13:46:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v3 6/6] selftests: tls: run all tests for TLS 1.2 and TLS
 1.3
Message-ID: <202003171345.CA27652B@keescook>
References: <20200316225647.3129354-1-kuba@kernel.org>
 <20200316225647.3129354-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225647.3129354-8-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 03:56:47PM -0700, Jakub Kicinski wrote:
> TLS 1.2 and TLS 1.3 differ in the implementation.
> Use fixture parameters to run all tests for both
> versions, and remove the one-off TLS 1.2 test.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/testing/selftests/net/tls.c | 93 ++++++-------------------------
>  1 file changed, 17 insertions(+), 76 deletions(-)

The diffstat alone justifies the variants feature! :) Thanks for this!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 0ea44d975b6c..c5282e62df75 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -101,6 +101,21 @@ FIXTURE(tls)
>  	bool notls;
>  };
>  
> +FIXTURE_VARIANT(tls)
> +{
> +	unsigned int tls_version;
> +};
> +
> +FIXTURE_VARIANT_ADD(tls, 12)
> +{
> +	.tls_version = TLS_1_2_VERSION,
> +};
> +
> +FIXTURE_VARIANT_ADD(tls, 13)
> +{
> +	.tls_version = TLS_1_3_VERSION,
> +};
> +
>  FIXTURE_SETUP(tls)
>  {
>  	struct tls12_crypto_info_aes_gcm_128 tls12;
> @@ -112,7 +127,7 @@ FIXTURE_SETUP(tls)
>  	len = sizeof(addr);
>  
>  	memset(&tls12, 0, sizeof(tls12));
> -	tls12.info.version = TLS_1_3_VERSION;
> +	tls12.info.version = variant->tls_version;
>  	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
>  
>  	addr.sin_family = AF_INET;
> @@ -733,7 +748,7 @@ TEST_F(tls, bidir)
>  		struct tls12_crypto_info_aes_gcm_128 tls12;
>  
>  		memset(&tls12, 0, sizeof(tls12));
> -		tls12.info.version = TLS_1_3_VERSION;
> +		tls12.info.version = variant->tls_version;
>  		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
>  
>  		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
> @@ -1258,78 +1273,4 @@ TEST(keysizes) {
>  	close(cfd);
>  }
>  
> -TEST(tls12) {
> -	int fd, cfd;
> -	bool notls;
> -
> -	struct tls12_crypto_info_aes_gcm_128 tls12;
> -	struct sockaddr_in addr;
> -	socklen_t len;
> -	int sfd, ret;
> -
> -	notls = false;
> -	len = sizeof(addr);
> -
> -	memset(&tls12, 0, sizeof(tls12));
> -	tls12.info.version = TLS_1_2_VERSION;
> -	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
> -
> -	addr.sin_family = AF_INET;
> -	addr.sin_addr.s_addr = htonl(INADDR_ANY);
> -	addr.sin_port = 0;
> -
> -	fd = socket(AF_INET, SOCK_STREAM, 0);
> -	sfd = socket(AF_INET, SOCK_STREAM, 0);
> -
> -	ret = bind(sfd, &addr, sizeof(addr));
> -	ASSERT_EQ(ret, 0);
> -	ret = listen(sfd, 10);
> -	ASSERT_EQ(ret, 0);
> -
> -	ret = getsockname(sfd, &addr, &len);
> -	ASSERT_EQ(ret, 0);
> -
> -	ret = connect(fd, &addr, sizeof(addr));
> -	ASSERT_EQ(ret, 0);
> -
> -	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
> -	if (ret != 0) {
> -		notls = true;
> -		printf("Failure setting TCP_ULP, testing without tls\n");
> -	}
> -
> -	if (!notls) {
> -		ret = setsockopt(fd, SOL_TLS, TLS_TX, &tls12,
> -				 sizeof(tls12));
> -		ASSERT_EQ(ret, 0);
> -	}
> -
> -	cfd = accept(sfd, &addr, &len);
> -	ASSERT_GE(cfd, 0);
> -
> -	if (!notls) {
> -		ret = setsockopt(cfd, IPPROTO_TCP, TCP_ULP, "tls",
> -				 sizeof("tls"));
> -		ASSERT_EQ(ret, 0);
> -
> -		ret = setsockopt(cfd, SOL_TLS, TLS_RX, &tls12,
> -				 sizeof(tls12));
> -		ASSERT_EQ(ret, 0);
> -	}
> -
> -	close(sfd);
> -
> -	char const *test_str = "test_read";
> -	int send_len = 10;
> -	char buf[10];
> -
> -	send_len = strlen(test_str) + 1;
> -	EXPECT_EQ(send(fd, test_str, send_len, 0), send_len);
> -	EXPECT_NE(recv(cfd, buf, send_len, 0), -1);
> -	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
> -
> -	close(fd);
> -	close(cfd);
> -}
> -
>  TEST_HARNESS_MAIN
> -- 
> 2.24.1
> 

-- 
Kees Cook
