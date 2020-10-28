Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBD829DC05
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390878AbgJ2ATB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731428AbgJ1WpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:45:13 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17171C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:45:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 15so701865pgd.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hvfu2O4x70zfOMPRKar/p0Ao3IuBnxAMAZDvJC8rl68=;
        b=zoof0+raMu/he+76Q9IaQ8w/GqD3T0dWynKY3ZLIejbNzYdWEPv+hT4wf64OGRdHrz
         eX6HseZHjxRB9kzvRbRKAfYDP3Bu5FYM2bDW+JDzsCJ4Bly0VbtiSxaA7KF4X/6EatYU
         TadbOvoVZBNcDYRzcNNvJTGAjaE8GnrjybD4QvfaQpgsSECkHDNJkIrW+FeTpZuE2CnK
         hnV6jBVqsIaCXlVTWrfORfZoQI7k/1fTfoA7csEqTA9eFUteZscv4KGPdip2v0yQjgeP
         RhG0A4RycKaGcmzey0lGPfF5nmF90L50aRJdED3hV5s3YW57vtS4fj3Z9qTqnCdijLky
         Qkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hvfu2O4x70zfOMPRKar/p0Ao3IuBnxAMAZDvJC8rl68=;
        b=P5v4qDfXZucWjP5l1+TxrlFS+U8WD8izavwOMstq3b0awImg05CcAowaYl/DKa5h+q
         NsDxTfGdBqcuJji6Fd3WbzQdWdN7QeaiuXvCWHUaARYC8x31ALq3LFcPKF0bmJ1UV3ax
         N5VBhRdEOdd8qL4F5Nm7Cjfb0f2B8F8CTR7XYY4D3D3/ayABu8qD/V6djrtqgvXBEbxc
         vzAfkGS+0mp8xo71M0gR74Pe3ieW4BiFVaXDAXAs68WhZwDqTkZbwCXn1AZNvFceueGr
         MCPv+eJYTbtU+HuewGBtMaY4fdCrT2X+3m9X200MQnmMQe5W7/XjJ784jGej2FZKRBIU
         AJZQ==
X-Gm-Message-State: AOAM531Ms5XzixwIlW5HMfICU2EwoJShsMyOq62rpT/P8tRR7f8glpmA
        dQBaYH9xGzI4+d5uA8aUcgUR0O2BiE3FtkgC
X-Google-Smtp-Source: ABdhPJw5nHKnt9TZvp0aBVHgiiUiftX46fk75iMXXqiiQv4OKF3yjXJiExJgv4ZU17o39DPteg5CsQ==
X-Received: by 2002:a92:ddd1:: with SMTP id d17mr5514566ilr.275.1603891847202;
        Wed, 28 Oct 2020 06:30:47 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id n15sm2747094ilt.58.2020.10.28.06.30.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 06:30:45 -0700 (PDT)
Subject: Re: [PATCH net 5/5] net: ipa: avoid going past end of resource group
 array
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, evgreen@chromium.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20201027161120.5575-1-elder@linaro.org>
 <20201027161120.5575-6-elder@linaro.org>
 <CA+FuTSdGCBG0tZXfPTJqTnV7zRNv2VmuThOydwj080NWw4PU9Q@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <d8611e9f-acef-d354-c776-f06b27365945@linaro.org>
Date:   Wed, 28 Oct 2020 08:30:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdGCBG0tZXfPTJqTnV7zRNv2VmuThOydwj080NWw4PU9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 7:14 PM, Willem de Bruijn wrote:
> On Tue, Oct 27, 2020 at 12:38 PM Alex Elder <elder@linaro.org> wrote:
>>
>> The minimum and maximum limits for resources assigned to a given
>> resource group are programmed in pairs, with the limits for two
>> groups set in a single register.
>>
>> If the number of supported resource groups is odd, only half of the
>> register that defines these limits is valid for the last group; that
>> group has no second group in the pair.
>>
>> Currently we ignore this constraint, and it turns out to be harmless,
> 
> If nothing currently calls it with an odd number of registers, is this
> a bugfix or a new feature (anticipating future expansion, I guess)?

. . .

Sorry, I missed this comment.  Yes, I'm working on support for
an upcoming IPA hardware version that has 5 resources of each
type.  And it is a bug fix, though the bug doesn't bite us
(because the maximum number of resources supported is even),
so "it turns out to be harmless."

					-Alex
