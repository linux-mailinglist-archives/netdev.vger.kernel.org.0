Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD4524F4C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354923AbiELODS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354922AbiELODR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:03:17 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5853656C02
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:03:16 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e93bbb54f9so6689909fac.12
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zpeylgT4mGSttmqaINCgp8x7iqSgPb4iQWwUo2BT6Z0=;
        b=FL19/N0nl0okfu4PDiPPkNA8QZ0Vaj5Cdt4am7jHqbO4wHTH122YVQNxnfSfnLzcml
         nh29WMk4NmeaKaz5aSFDiAPMAVu/tVV9WEx4z0fKI7TMZiAHt7FDOFBpkXMHAO6+dwE6
         A20dJyLAcNjLWLCZuticBxbMxi12I3Ce0cgUC20GS/JngiblNZQYaPRMaZXh5364mqcI
         70Ctr+bVfLURvp4cj3rQISY8NYP6tU5pNnqk06lVh2A3C/XGjFYOEscyUww2XnQG2c5i
         tfoBJRqrlizi4FfKbLO+/pxsOMNUcz/X9Cip5ecR10oCh59OjyXDWWSpXKyJzjERgZcN
         42XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zpeylgT4mGSttmqaINCgp8x7iqSgPb4iQWwUo2BT6Z0=;
        b=aFpmpe3JEbLpsGJxjqXgxCFYlRH69Q6vOEIVUI5kUvcmthDLj7WsHUHenQJW+k9+SM
         ymnO/OY4AubQEPzbISSMadP0T44V0fP/DpM/diLH8eyADy4IvpFdoPFhCM5A3lXv+cGq
         UHu8I5KeqLPe0TbLsU83sQEmp1OONjcf4HDBkgaot0kp/RC9iFXd0NdID5s+B23vACyC
         MrvD0FpUGfV0TeEPnBMYJYO7yrOrLqusM891r2B4psa+7leQykArNz+qfUlpNTAAZFNO
         A/fOYoWCXLdC9GAThr8GPYrhnfPSRNtrPGJcOwvv02LcGpv7RfCgEutcAs4l0Qx6qYO7
         siog==
X-Gm-Message-State: AOAM533jghc4cjNeZSKscce2CM9C/7oGWXjOxkMjuU2wFZzbejzUiky5
        pEng1Z08R7j9Mfuj+/KsHFCBMW0J+i4=
X-Google-Smtp-Source: ABdhPJwtkwq1vZfGG8Nix2sDRGDdMIWsYgj69mPjJ7CgcAbxDm5ESeSFAWFlMnieFVeVY5p6zpHcLA==
X-Received: by 2002:a05:6870:e754:b0:ee:1586:44f with SMTP id t20-20020a056870e75400b000ee1586044fmr24176oak.167.1652364195754;
        Thu, 12 May 2022 07:03:15 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id h26-20020a4add9a000000b0035eb4e5a6d1sm2100994oov.39.2022.05.12.07.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 07:03:15 -0700 (PDT)
Message-ID: <5e5292e6-2560-7780-d813-ea278c7ebba7@gmail.com>
Date:   Thu, 12 May 2022 08:03:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make the test more
 robust
Content-Language: en-US
To:     Amit Cohen <amcohen@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shuah@kernel.org" <shuah@kernel.org>, mlxsw <mlxsw@nvidia.com>
References: <20220512131207.2617437-1-amcohen@nvidia.com>
 <DM6PR12MB30664C27CAD526E0376BEE8DCBCB9@DM6PR12MB3066.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <DM6PR12MB30664C27CAD526E0376BEE8DCBCB9@DM6PR12MB3066.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/22 7:31 AM, Amit Cohen wrote:
> + David Ahern
> 
>> -----Original Message-----
>> From: Amit Cohen <amcohen@nvidia.com>
>> Sent: Thursday, May 12, 2022 4:12 PM
>> To: netdev@vger.kernel.org
>> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; shuah@kernel.org; mlxsw
>> <mlxsw@nvidia.com>; Amit Cohen <amcohen@nvidia.com>
>> Subject: [PATCH net-next] selftests: fib_nexthops: Make the test more robust
>>
>> Rarely some of the test cases fail. Make the test more robust by increasing
>> the timeout of ping commands to 5 seconds.
>>
>> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
>> ---
>>  tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
>>  1 file changed, 24 insertions(+), 24 deletions(-)
>>

Reviewed-by: David Ahern <dsahern@kernel.org>


