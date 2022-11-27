Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32884639A63
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 13:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiK0MSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 07:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiK0MSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 07:18:00 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387495BD;
        Sun, 27 Nov 2022 04:17:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 82so128999pgc.0;
        Sun, 27 Nov 2022 04:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUhQv/daKQeezlrY3ZB6WhoE6/PRhmS/zNtKOTupELQ=;
        b=Xnw9aFX36vj0szDVrRgKXyPgNZ5KzNIz0MlTNCTJVQwVNZR6flooWcpJoafN07Y1/P
         F0JFOVzQh7G4PwjFei0z63aXBf9Ttw5kzSBZf6LhRSUPxq/fU9dzozhwPEvtqVOhxJti
         gOPakfzzw3B35JL/ziWtSPw7Q4ECOrq4jkw8sLX8qwIXDnDwf+NFpLYutkqmk0C6RJGT
         XifaoJ4Z4igEP9pOqb8PcCGVq4t5bfUOepeQKQA29DZ4KEieNxpOyyFutb3ATEAUJDyC
         9qE+C3rY7iAZKUL7lTMpo9fXLIGh8qnJe0HrTNYQcIR4MAeHYclyRbYnNWa/tVY316f9
         3DEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUhQv/daKQeezlrY3ZB6WhoE6/PRhmS/zNtKOTupELQ=;
        b=l6w/OpRBYz1dSnHZhx9W6RjSnbgMN/t0/rU/OK2I74f+nQ+zZqtkD0Fg1xiGFqKj3r
         9OosG1KMxFvraiBYCKqUjlx+EeD7h2igHDJWj+T5EOiDdAjAapleFi7p1oekkuYfFYCi
         tO0XVvnGvuhdloqIrG6K2GbXQNv3dkORq+lFs7L5rOeDQZBVCEaUYAQg4kEoAytWcF2U
         UDYC11cMgHuE6WvLhQqWihMQ7JmkDcL4dcI/Suzx94WcJTlzljRF7dn8+57ipxY4GRGu
         /jyz0yluyjL6sv2dmpUE6+ybgV9HRKuh6O0DE6avSkyoi3S2ic+7J9PG4jrSr8sbch2p
         i6vQ==
X-Gm-Message-State: ANoB5pmIfzUzcuwDIjMvP0NIamTZBK1/MlYaVy8p05KQH5CN5UO/8fjc
        3rgDsI23w11GwOTSae7Ov+w=
X-Google-Smtp-Source: AA0mqf4AsHrt670+XPpilnfBQfcbj2ubdhnGK3RgfUUHLttNjp9TAXUM18N289VlwM+2Lbk51wKY7w==
X-Received: by 2002:a63:1142:0:b0:477:e0f7:aba3 with SMTP id 2-20020a631142000000b00477e0f7aba3mr9822638pgr.388.1669551479061;
        Sun, 27 Nov 2022 04:17:59 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id mm24-20020a17090b359800b002192529a692sm1710851pjb.9.2022.11.27.04.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 04:17:57 -0800 (PST)
Date:   Sun, 27 Nov 2022 20:17:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: Fix tls selftests dependency to correct
 algorithm
Message-ID: <Y4NVcV1D/MhFJpOc@Laptop-X1>
References: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 08:19:05PM +0800, Tianjia Zhang wrote:
> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
> the SM3 and SM4 stand-alone library and the algorithm implementation for
> the Crypto API into the same directory, and the corresponding relationship
> of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
> library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
> algorithm implementation for the Crypto API. Therefore, it is necessary
> for this module to depend on the correct algorithm.
> 
> Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: stable@vger.kernel.org # v5.19+
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  tools/testing/selftests/net/config | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> index ead7963b9bf0..bd89198cd817 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
>  CONFIG_NET_ACT_MIRRED=m
>  CONFIG_BAREUDP=m
>  CONFIG_IPV6_IOAM6_LWTUNNEL=y
> -CONFIG_CRYPTO_SM4=y
> +CONFIG_CRYPTO_SM4_GENERIC=y
>  CONFIG_AMT=m
> -- 
> 2.24.3 (Apple Git-128)
> 

Looks the issue in this discuss
https://lore.kernel.org/netdev/Y3c9zMbKsR+tcLHk@Laptop-X1/
related to your fix.

Thanks
Hangbin
