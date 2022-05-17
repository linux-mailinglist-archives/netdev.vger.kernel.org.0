Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C3529A1B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiEQHB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240694AbiEQHBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:01:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F08420BC9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:01:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd25so8537723edb.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DRGKs1GN7uGV/MGON3ombxJkQtTa5l08+qO7U3wn8nU=;
        b=hr37GqZwcTl34bfUcDXbDv43lSD547/gPK3gP9hcAMulCEwmOpQd/pv2hIV/oltxrm
         Tz4EwFb4J3IEBktK0JhsWNTU6g9OMMVoR6lOgREFHs0crVdMubphUOSSx+4mgG8hDXru
         TDqgKTy9ac3CdLthzlUIRPABfpPK1E149d5A3UDdVsnHxnc1P1QYW1LxCIgBozUZ7bzN
         cy3SQ8owigksOzkrJnoPkoI478/o1odxQn2QZZrQcxr6s3F9ZOrnjY2n99axIkQEO0AF
         FlkoPuF/AEKWSQRHHxbNZkk2Jnp1mZr1tUkxJzy6FT+bAXvcMputmBH8LpluPO31nQmg
         amHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DRGKs1GN7uGV/MGON3ombxJkQtTa5l08+qO7U3wn8nU=;
        b=qZs4SiRNZsC5YsPilgbmfCoV1JUMXfOLVVZOwWVYn8aW578rQluSU28mWsbaeMv/sl
         PtloP1CiGWwpowPrPctmMgn6Y1POWQjJOEcUTTM/GnpPs8J/6zhnaKBwX4P9V/gGTVdK
         bkLbOPpCAzlZnM1FxKkARAhgHGNHm6T5uOdKd4rGdwu/BHYrxnNSHns2/9WhSElPRgzx
         pJWiG2Tss5W4X4oZkb1OAiToj++mI8Ns8pMBUt3rLNfldMv8HlGXkU3TEB7P5qc9RZ+g
         GBVKTBk1qz9ACUGG+9gpxFIM+//bMElhVywhQGa3RJa0Uxn0NtTCC4EkC79Y2EQRVbKn
         X0yA==
X-Gm-Message-State: AOAM530FSVi4fTY6WES85cXQxxaFiTb1KGOplPcwHUrL7wKiZ4bP6nwv
        +B8PBZTLh7Q4EU3R6khc/mTz/g==
X-Google-Smtp-Source: ABdhPJwC9pvT00blFTgIzjqRizPpW4p8jwKdqqkW4kW+Gecj3wcm9Bv6gaGyNgoQZizs2DSdugjVTA==
X-Received: by 2002:a50:9b08:0:b0:42a:2d15:e15a with SMTP id o8-20020a509b08000000b0042a2d15e15amr16966095edi.361.1652770888308;
        Tue, 17 May 2022 00:01:28 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:e69d:55f5:f7d9:4300? ([2a02:578:8593:1200:e69d:55f5:f7d9:4300])
        by smtp.gmail.com with ESMTPSA id u7-20020a1709060b0700b006f3ef214dc1sm670444ejg.39.2022.05.17.00.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 00:01:27 -0700 (PDT)
Message-ID: <49ee2e2e-8fd3-dedd-8aac-566b6e0e07c9@tessares.net>
Date:   Tue, 17 May 2022 09:01:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next 1/3] selftests: mptcp: fix a mp_fail test warning
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        mptcp@lists.linux.dev
References: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
 <20220514002115.725976-2-mathew.j.martineau@linux.intel.com>
 <20220516131346.1f1f95d9@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220516131346.1f1f95d9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for the review and for having applied the patches!

On 16/05/2022 22:13, Jakub Kicinski wrote:
> On Fri, 13 May 2022 17:21:13 -0700 Mat Martineau wrote:
>>  	tc -n $ns2 -j -s action show action pedit index 100 | \
>> +		grep "packets" | \
>>  		sed 's/.*"packets":\([0-9]\+\),.*/\1/'
> 
> sed can do the grepping for you:
> 
> sed -n 's/.*"packets":\([0-9]\+\),.*/\1/p'

Yes, thank you, that would have been shorter!

> But really grepping JSON output seems weird. Why not use jq?

We started to use 'jq' because we originally had to extract a few values
from this command. At the end, we only needed to extract the number of
packets and we didn't want all MPTCP tests to depend on 'jq' just for that.

But because 'jq' is already needed for a few other selftests, next time
we need to parse a JSON, we should use 'jq'!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
