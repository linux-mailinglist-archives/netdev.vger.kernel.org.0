Return-Path: <netdev+bounces-9012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 360EF7268D9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89B321C20BCA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6224614AAD;
	Wed,  7 Jun 2023 18:35:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5647C10FC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:35:05 +0000 (UTC)
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAA21725;
	Wed,  7 Jun 2023 11:35:03 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-33b1e83e204so5333895ab.1;
        Wed, 07 Jun 2023 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686162903; x=1688754903;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6E9HtQWu+wxXQljB9IRZI4B80QvXd4zRcBNeOLNbiAo=;
        b=cMtjM/HhRXzl0I+q96CV/C4tPHx1GoaqPp+z/zaqjFBxH2GZEvFwh5eVt8o5a3Hiez
         5Yy89oRK99Xcf6uG0J/a4pCX5+wIQa8XfoCdeIbs/yHDecmO8afYlGcOSv+gkAMaeRPy
         IHI3qDtcP8Ri1fqK+c6AhU1y5ie92ukZi5h/eJ2HKMW/gvNdg6E5RDHJYzp1xyKSLoxj
         tp07oncZSOU1Mz61hKyJ6UaIQOxrV7kM5fPKrIuElpK4mGglFlKFWhNoKdoEV1wnyZZX
         s8WUoAVAk8fbug5wQebvrA2fV/5GGMG6dDBxgr0MBElbA/ynh2rL3RPd4XiMBES6LV9w
         tNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686162903; x=1688754903;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6E9HtQWu+wxXQljB9IRZI4B80QvXd4zRcBNeOLNbiAo=;
        b=CXcT8mwqxMjLVuVID75NcpP6ByDgUhuH1Whaeerscus1GX4w9gZ1mRKSBULSblFC2E
         cAo+ACW2Ut80fMgwuD/1lQujWkIMkcZwOfTBRIA3l9RWVTXHc9NZYTbUHLJ/s9S894at
         DWMWZXG5gd4sa6V7B8mvp26ibN1q512zdZfShAh9WHCVL/zgENKvOyS1Ge0+5u/Nmiae
         2kBYfM6vRVlp3r4QB8cmNJF3Y6gpjLTDkJAeOA7amv5LWjuvX1RZQroRFS7izKoOESj3
         40Cu89F8kwgF6b0rB6arHgLFsELkpQALua3wDZw05riZBOl4ZZt7s9Zv2HIzrm0HOMxN
         KTuw==
X-Gm-Message-State: AC+VfDzMgzt/jC43CzZfrHvSsTchsnVhV/RBTdxmgdzb05VLGPp/B1yY
	YVGo8Z4xgtC1PeVtAcsTGZ0=
X-Google-Smtp-Source: ACHHUZ638dehw0fB0PQtnifXtzYGnipo3WmZRJnXJ3drE+azBfoYrOm8MiP6oBiVLri53Fi0KUOFPQ==
X-Received: by 2002:a92:dc09:0:b0:33b:1fe1:9a84 with SMTP id t9-20020a92dc09000000b0033b1fe19a84mr6515737iln.21.1686162903204;
        Wed, 07 Jun 2023 11:35:03 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:6ca6:e764:8524:ec9f? ([2601:282:800:7ed0:6ca6:e764:8524:ec9f])
        by smtp.googlemail.com with ESMTPSA id o17-20020a056638125100b0041fb2506011sm1511914jas.172.2023.06.07.11.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 11:35:02 -0700 (PDT)
Message-ID: <8df72efd-334a-40b6-7d4c-62c8e5a36fc0@gmail.com>
Date: Wed, 7 Jun 2023 12:35:01 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net 2/3] selftests: net: vrf-xfrm-tests: change
 authentication and encryption algos
Content-Language: en-US
To: Magali Lemes <magali.lemes@canonical.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org
Cc: andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230607174302.19542-1-magali.lemes@canonical.com>
 <20230607174302.19542-3-magali.lemes@canonical.com>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <20230607174302.19542-3-magali.lemes@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 11:43 AM, Magali Lemes wrote:
> The vrf-xfrm-tests tests use the hmac(md5) and cbc(des3_ede)
> algorithms for performing authentication and encryption, respectively.
> This causes the tests to fail when fips=1 is set, since these algorithms
> are not allowed in FIPS mode. Therefore, switch from hmac(md5) and
> cbc(des3_ede) to hmac(sha1) and cbc(aes), which are FIPS compliant.
> 
> Fixes: 3f251d741150 ("selftests: Add tests for vrf and xfrms")
> Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
> ---
>  tools/testing/selftests/net/vrf-xfrm-tests.sh | 32 +++++++++----------
>  1 file changed, 16 insertions(+), 16 deletions(-)

Reviewed-by: David Ahern <dsahern@kernel.org>


