Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503675A23FC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbiHZJQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiHZJQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:16:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7035CD31E0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:16:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bs25so1076004wrb.2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=lu7t59Y/6eA1q6IQ9qzo0I3g1dYmEshSQSj7OaC0EW8=;
        b=dvcCrMXMBs0DCb7ARVAJu7t+jiT75dydGgkrAu9UTeywyKhEzYBOO5aNexjt2pIx0+
         K7MkHMPBzQghhTXWSS1Toqy02QbRGmxnsMlmLIHLKwDRkCtYWrwazDyixvtCmIUaSAZZ
         iYIySOy7OcSPaWAMXutbQ5WDw70DSs3B3xl4BVG848jVIHdiPWMmrWYYhGoc61hzuuyo
         vlkHZx1wftk9PboEXIyBJEYW2OI9/CDrRzyhy8aTxyJ60no+qBhaMpW5nxdGQJk/3kIc
         Ooskhseo2rs58jBrHz9XyQNBqp6nDxZHVK+9s1jKtOXEuziecLY7K1ooQb5qK/WtMb99
         eKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=lu7t59Y/6eA1q6IQ9qzo0I3g1dYmEshSQSj7OaC0EW8=;
        b=RydeKHXDcpu9gwlgr/TcKmP40WYjuHOEbTb7Kt9RMDmBwoWwciajK7amMoFd068IaO
         v99f19nuNoKmtAKIYlx32Ya+PA6nyMhvHfwJR3cFJKwW8POk7XBhjA7kERxXVB0Xul4R
         o35m35hVl1YnJGYjkAvBije9eIZB+fSUiz/oEwz2wY8P9I8u+MV3JWsscHRoMC1OnB04
         SUuUFKScAoKiMNmSNuXNnFoYxOS/opGOa9PGMld+o8Ksx+MPfAiHeRjb1Q7stFQlFQxT
         Ds7udEeBiv1EfLzUdglZl5LuZ9lK78KnFpMPkiPgLaal3BySR6tiJfcyprObMpMhmlVs
         zrUA==
X-Gm-Message-State: ACgBeo2SGBanlfX6izbuF2zKtUy7fSUl8ncfzkcJl9inftcJ4BLcIDST
        vpCjRgyuwCMaKQmDfWPcX5ZhGg==
X-Google-Smtp-Source: AA6agR7xPbWca+rrzIehQRM92IvHTy6OG6rwG2aP/MoK/VzAI6XGc0rUVXUwLjGSnAvlheKNOwCTUQ==
X-Received: by 2002:a5d:6d8f:0:b0:225:6285:47fb with SMTP id l15-20020a5d6d8f000000b00225628547fbmr4504845wrs.211.1661505373884;
        Fri, 26 Aug 2022 02:16:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d94:b816:24d3:cd91? ([2a01:e0a:b41:c160:5d94:b816:24d3:cd91])
        by smtp.gmail.com with ESMTPSA id t63-20020a1c4642000000b003a673055e68sm8907387wma.0.2022.08.26.02.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 02:16:13 -0700 (PDT)
Message-ID: <a0e1b167-2a80-abe3-c01e-48dc89a7d543@6wind.com>
Date:   Fri, 26 Aug 2022 11:16:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: 747c143 caused icmp redirect to fail
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        edwin.brossette@6wind.com, pabeni@redhat.com
References: <1661485971-57887-1-git-send-email-hengqi@linux.alibaba.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <1661485971-57887-1-git-send-email-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 26/08/2022 à 05:52, Heng Qi a écrit :
> The detailed description: When testing with selftests/net/icmp_redirect.sh, a redirect exception FAIL occurred for IPv4.
> This is not in line with actual expectations. r1 changes the route to the destination network 172.16.2.0/24 from 10.1.1.2 to 172.16.1.254. After h1 sends the ping packet, h1 continues to obtain the route to 172.16.2.2, and the result is not as expected.
> This flaw was introduced by 747c14307214b55dbd8250e1ab44cad8305756f1. When this commit is rolled back, the test will pass.
> 
> bug commit: 747c14307214b55dbd8250e1ab44cad8305756f1

Thanks for the report. I will investigate.
