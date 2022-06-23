Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41625572A3
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 07:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiFWFmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 01:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiFWFme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 01:42:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77133C4B9;
        Wed, 22 Jun 2022 22:42:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so1532852pjr.0;
        Wed, 22 Jun 2022 22:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=csQMNlHKEW+As1/6RYdVgr16BLm5VIjZDeqyZjFfTjM=;
        b=i8exCuwEqrWoP439dwoNzzujK/PCcX9CScZ3KJA6H4h7zMDA395etdFGoGB+5jGJr3
         ShmucnrZJg3PkqpL/mg+2ZZJneHfanmnQBp0SoFGT9LThd6mcCtoFKKlwhjvVeJlco+y
         hv8qwD6n3CZnAD6Xs7G81s/QZ1g1dGyWtTlJ68EYbpKL2NybaBfRi7hnbM5rGbqvQaT7
         iTICbxBpk7o+ZJLR8EE3BC9j99Uznu4EyA7VkFU6qEZXXE2aXoEwg67iTF8Omwsb7Abj
         s9UXBHiGMSC51JJvIsqTHhgqwTeuuvtJACDoPkbzklKPiijjxOIw04uXlUU45lVjbaqd
         c+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=csQMNlHKEW+As1/6RYdVgr16BLm5VIjZDeqyZjFfTjM=;
        b=PRKfpdlMqpL2liWkNmBABJzTjbcm2moards56pC0hsSNuyig6scYZfYMwibFfwm0g9
         nW8BU49Msca+5vNPt14I1mgTPAzH+/t8hOTi9vNN6wxWN7Vw6swF0W0ve26NvV/1Azs1
         qpVJr0sjd0nHIXW/Nn9KiEphXm69w+lNtATJO3UQQumF7sJTrEplV2doaE9DrEpbH4iB
         0lVQCB2Tylm3n9FHEl0p+iiMXXJlHW6Xmsn4GtqE3Wyp8aVRu5G/V54YmspYyVvhtC3i
         W0iq6yRU5JdfES6RImIycXBLuHICI2xpWFx4PCQKndTtTVYtJ2MV65AG3s+IMCevwk2M
         hSqg==
X-Gm-Message-State: AJIora8LAhIPis/f43VBf5kVMyfQ43lH8vUc7vFGVNMKIbHsMFdKM6Rk
        ZwaZz+K9vlkSJCLC4XhaagI=
X-Google-Smtp-Source: AGRyM1uT6X3Hs63rl+MIUBmZ9eQJiYEdk6cEl1dDO4eCENe7gvqxEWTKm9lp+CpPvg8RhP/hSyoYpA==
X-Received: by 2002:a17:902:f687:b0:167:58bb:c43f with SMTP id l7-20020a170902f68700b0016758bbc43fmr37169283plg.136.1655962953192;
        Wed, 22 Jun 2022 22:42:33 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090a5a0400b001ecb29de3e4sm801314pjd.49.2022.06.22.22.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 22:42:32 -0700 (PDT)
Date:   Wed, 22 Jun 2022 22:42:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
Message-ID: <62b3fd46af42c_70b1d2086a@john.notmuch>
In-Reply-To: <20220622172407.411411-1-jakub@cloudflare.com>
References: <20220620191353.1184629-2-kuba@kernel.org>
 <20220622172407.411411-1-jakub@cloudflare.com>
Subject: RE: [PATCH net] selftests/bpf: Test sockmap update when socket has
 ULP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Cover the scenario when we cannot insert a socket into the sockmap, because
> it has it is using ULP. Failed insert should not have any effect on the ULP
> state. This is a regression test.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Thanks, looks good. One small nit.

>  
> +#include <netinet/tcp.h>
>  #include "test_progs.h"
>  
>  #define MAX_TEST_NAME 80
> @@ -92,9 +93,78 @@ static void test_sockmap_ktls_disconnect_after_delete(int family, int map)
>  	close(srv);
>  }
>  
> +static void test_sockmap_ktls_update_fails_when_sock_has_ulp(int family, int map)
> +{
> +	struct sockaddr_storage addr = {};
> +	socklen_t len = sizeof(addr);
> +	struct sockaddr_in6 *v6;
> +	struct sockaddr_in *v4;
> +	int err, s, zero = 0;
> +
> +	s = socket(family, SOCK_STREAM, 0);
> +	if (!ASSERT_GE(s, 0, "socket"))
> +		return;
> +
> +	switch (family) {
> +	case AF_INET:
> +		v4 = (struct sockaddr_in *)&addr;
> +		v4->sin_family = AF_INET;
> +		break;
> +	case AF_INET6:
> +		v6 = (struct sockaddr_in6 *)&addr;
> +		v6->sin6_family = AF_INET6;
>k+		break;
> +	default:
> +		PRINT_FAIL("unsupported socket family %d", family);

Probably want goto close here right?

> +		return;
> +	}
> +
> +	err = bind(s, (struct sockaddr *)&addr, len);
> +	if (!ASSERT_OK(err, "bind"))
> +		goto close;
> +
> +	err = getsockname(s, (struct sockaddr *)&addr, &len);
> +	if (!ASSERT_OK(err, "getsockname"))
> +		goto close;
> +
> +	err = connect(s, (struct sockaddr *)&addr, len);
> +	if (!ASSERT_OK(err, "connect"))
> +		goto close;
> +
> +	/* save sk->sk_prot and set it to tls_prots */
> +	err = setsockopt(s, IPPROTO_TCP, TCP_ULP, "tls", strlen("tls"));
> +	if (!ASSERT_OK(err, "setsockopt(TCP_ULP)"))
> +		goto close;
> +
> +	/* sockmap update should not affect saved sk_prot */
> +	err = bpf_map_update_elem(map, &zero, &s, BPF_ANY);
> +	if (!ASSERT_ERR(err, "sockmap update elem"))
> +		goto close;
> +
> +	/* call sk->sk_prot->setsockopt to dispatch to saved sk_prot */
> +	err = setsockopt(s, IPPROTO_TCP, TCP_NODELAY, &zero, sizeof(zero));
> +	ASSERT_OK(err, "setsockopt(TCP_NODELAY)");
> +
> +close:
> +	close(s);
