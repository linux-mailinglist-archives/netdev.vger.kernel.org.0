Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2A1443B5D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhKCCb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhKCCb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:31:58 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A31C061714;
        Tue,  2 Nov 2021 19:29:23 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o10-20020a9d718a000000b00554a0fe7ba0so1511856otj.11;
        Tue, 02 Nov 2021 19:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qh1t8cHvIxJkSuVFMWej9fhmrge5wN7IrBSDo7Kwx50=;
        b=LrUNk3zmyt1WvH4YHdYpw3RuPT6eUK1iz6Q2gdAQn7AaQmaW4u0aS0NUZD1E8bJQ8K
         ExuCnynMEmes6oHe3oHvg6fcJG+QQazEfBxlXA45Y13DDTqiRJkcpZdczE6a0aIavBJ2
         c/9wMscfJrDRr1YzrPELZO4oy7AndvQxlAmFHpa4MyFcZmRMBECTtODLG8nDbTLJdFrB
         Yex+n3LLBNGijjWFPjEL180u7I4Vidh6zQq2hOoBFpgmksSh7vRBikUuQVfF0bxKM3LK
         PTLXI3pTaePl4Jn9kaDSuwfJxHv5AqAV5h1WYEbf4TK98riwMsi0JpYl0f+qA5a+eqjW
         K8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qh1t8cHvIxJkSuVFMWej9fhmrge5wN7IrBSDo7Kwx50=;
        b=HzOx/FlM5ALhq6o9W52xOT0yqVQ3vnuDj1xraj1s7dOouq4zXsiSp8mbQkQo9LRz0y
         yFg9JKXXT+mGgxtxlFUMQdAXS3EvBsj/Qbm2i9k5xD0hsUwKNu6JNGDqqeOFGdydMsKT
         dJaC3PKXxu9RBrCl2JWsBkHg42arWNKaZZ9QGo79ubae50k6R1rq7le38LFqPttTPySs
         PfGgeGD+mwO1tZTqOMBNuv2QAyGvgVqgsvlzRYxn0hl4eYTLVlf+iGOmJbrEG7Zn8mbh
         fe+gveJ0YjmvbmVDkLd5ruCMWuVk4OcfMX/pXiLaW6pW5L0rRdFkG21GjVFggHPg+1uk
         rcmQ==
X-Gm-Message-State: AOAM531k3IPC37wWPK2GXcU7D1ILU7SCcNFiGs3MCXts/rfnm1+brabK
        2PH2nnhM7gc6SK1MW2A42fc=
X-Google-Smtp-Source: ABdhPJzje6z/g6P3WXMsf5dWpd1mfTtzSPs0L93o4FpmOSKLWJpREPfUyU/smtFJGWAj9WB6rqW30Q==
X-Received: by 2002:a9d:a64:: with SMTP id 91mr23167682otg.198.1635906562337;
        Tue, 02 Nov 2021 19:29:22 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e20sm234868oow.5.2021.11.02.19.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 19:29:21 -0700 (PDT)
Message-ID: <54e31e3f-d6b3-2124-b57a-4e791938ff2f@gmail.com>
Date:   Tue, 2 Nov 2021 20:29:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
> new file mode 100644
> index 000000000000..c412a712f229
> --- /dev/null
> +++ b/net/ipv4/tcp_authopt.c
> @@ -0,0 +1,263 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <linux/kernel.h>
> +#include <net/tcp.h>
> +#include <net/tcp_authopt.h>
> +#include <crypto/hash.h>
> +
> +/* checks that ipv4 or ipv6 addr matches. */
> +static bool ipvx_addr_match(struct sockaddr_storage *a1,
> +			    struct sockaddr_storage *a2)
> +{
> +	if (a1->ss_family != a2->ss_family)
> +		return false;
> +	if (a1->ss_family == AF_INET &&
> +	    (((struct sockaddr_in *)a1)->sin_addr.s_addr !=
> +	     ((struct sockaddr_in *)a2)->sin_addr.s_addr))
> +		return false;
> +	if (a1->ss_family == AF_INET6 &&
> +	    !ipv6_addr_equal(&((struct sockaddr_in6 *)a1)->sin6_addr,
> +			     &((struct sockaddr_in6 *)a2)->sin6_addr))
> +		return false;

The above 2 could just be

	if (a1->ss_family == AF_INET)
		return (((struct sockaddr_in *)a1)->sin_addr.s_addr ==
			((struct sockaddr_in *)a2)->sin_addr.s_addr))

