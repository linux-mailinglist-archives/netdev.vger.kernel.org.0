Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B519345392
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhCWAEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhCWADq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:03:46 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2ADC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 17:03:45 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id t14so6698515ilu.3
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 17:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OwTS27lmdu1IYVtfbP6cul5sYprN6Y0AzhhQLQ6dKzs=;
        b=vXZF9RCKjPousn00RfXby2OHMFqI6CWIZ5uvJuzY2rF85yWRPF+Scujn49PlX5zLng
         EGVucFBSXnJDnDrH7X+XdZCCArX2/ZUw4bMwvh/1XOTmFZF3UiitqlLdazkfTn/Tj70e
         8BFtdUKewkrB1cKg4sJ/prWVn5HBhgdYl928hW+YG9XgNKR3u/tCa7YuQKBDMoQfTAx4
         B8PSFe0DpqtCRVCDUZpJsVWq2ZjXOh18jygs/Bz5XvNmXRiGqIyxF3GCxD78/yC9Yx5v
         AOJ2HliW1umV6qVfNnYbbmvrWcmlrAwbSpVWT6E72Y7RCQpv2yHoYOxfHBLmj2VaYx3s
         PbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OwTS27lmdu1IYVtfbP6cul5sYprN6Y0AzhhQLQ6dKzs=;
        b=CvjnWF/m4a04Oz47rFRGF9JY5HXucc9zG6s+7bGzCKdwqO//qkkg1vxk2yBMV/zp6T
         xneSyqwEBld7FCnsPxCoUmBxmi6WdlUmncUjH26sdEJVtt3VcoLyCy89Lg7LFSc9lh5A
         1rAMHoRU9giYKvVLSTYSi5FJ0BoPJwlO1fXG46JXUDszWGKnhw/mEFdLbqtNH4IPfW5L
         h9Epz/iUh91X5krT7mO+i23HjpAKYbObbv4QWOsbPzl2HnjiBL3Usux4R07uzSQuaHDT
         vwBb3dICw7XOaxoqj3upDlgS+q5mtvIVtPuT30QrHCsvotIz4TJ9SoffS2m9xabKqs61
         /QJQ==
X-Gm-Message-State: AOAM531r6T8J83td0qdeDHmKSQ8y78G+BM4rvqs+PqM881pduTUdylla
        gE/LdvVrqvOEFIN9nitDcPcn1Q==
X-Google-Smtp-Source: ABdhPJy+gtujtGv55KnZhN7pqmjC0X5LL4xK9I4liITDzlvYnOOp1msEbt5i8Dgj0jqRcnUH/uYQEg==
X-Received: by 2002:a05:6e02:1a02:: with SMTP id s2mr2284719ild.48.1616457825182;
        Mon, 22 Mar 2021 17:03:45 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b9sm8409627iof.54.2021.03.22.17.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 17:03:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org> <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org> <YFdO6UnWsm4DAkwc@unreal>
 <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org> <YFg7yHUeYvQZt+/Z@unreal>
 <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org> <YFkgsHfldCNkaLSB@lunn.ch>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b24adfcd-1dac-581a-93bb-0ce38133bc0f@linaro.org>
Date:   Mon, 22 Mar 2021 19:03:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFkgsHfldCNkaLSB@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 5:56 PM, Andrew Lunn wrote:
>> The solution is to create a user space tool inside the
>> drivers/net/ipa directory that will link with the kernel
>> source files and will perform all the basic one-time checks
>> I want to make.
> 
> Hi Alex
> 
> Have you found any other driver doing this?  Where do they keep there
> code?
> 
> Could this be a selftest, put somewhere in tools/testing/selftests.
> 
> Or can this be a test kernel module. Eg. we have crypt/testmsg.c which
> runs a number of tests on the crypto subsystem,
> ./kernel/time/test_udelay.c which runs times on udelay.
> 
> Rather than inventing something new, please follow other examples
> already in the kernel.

I will.  I did see the tools/testing directory and I'll
look at how people have done things there.

I need to try to get it working first, then I'll figure
out where it belongs.  I think I'll be able to do a user
space test, but it's a little tricky to be sure it's
actually testing what I want.  If that ends up being
too hard, I'll look into kernel test module.

Thanks for the suggestions.

					-Alex

>         Andrew
> 

