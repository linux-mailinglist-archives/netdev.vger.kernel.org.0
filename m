Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9BD263270
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgIIQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730994AbgIIQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:49 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D72C0617BD
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:43:46 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u20so2347860ilk.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wzRfPI8VPUjN9UUY3Djh37yv6ix7hIv2rZzunO2y6YU=;
        b=VuxVtlS7tRUJRgKbX6B92xD/alpWvZmwy0QcPUOJka6AklyudrnjCYnvg2MN7/kTiy
         Eju4t6MsQBRWUiI4HgKmZeQpgaai/AJ5utoqDQFRdzKfQpGVZaPd7ZP1KgM3eTFDoC/P
         RDFMHhmwOfjadPsROfab/T/wWDz2dV0gc2a7j9otYGEP+2oF7FuTpObi+EdOXb7ygJ5z
         /7NxrBiBFUArJ5Gahh9Cu/AyAV7VP8GekjGc7ggBO3prmthyyQmW+3DWjzzPsj192uXS
         Z37vsixhJz15sQGX+G08UZXWaUY05HdUGarpsm3V9oD0b6aPnpdcbv9eelRcR5c4FSQs
         EG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wzRfPI8VPUjN9UUY3Djh37yv6ix7hIv2rZzunO2y6YU=;
        b=YJNzBXEKBTGl/dM/X1KT6yzB1k2+Zdh3Z7MonPhbgpY2WvFfaS/rbSe8fnG8hOVWVw
         b1CNdvaT0VJywoXBAy5L/RoCD6WDkLQoD/takROfxW079qaWQvBHMtOlgGtYfrtr1PbV
         AzQoVAK+CqAGII8DlRioKv3fdP8jo8rIBvF7SWn7cYudXilBs29IxFD4RtIqCUPUqHFu
         yP48f2ckWqPSsKE+Z2hIJYkxSfVyUNAhqUxf3maQ52D6TUPK1iUvMkQl7LWOTtcCs9zw
         frrGFELyW8Pv6m4ziox6+vERJxDWXAgQWUYyybES2YUVCDnkWBWLkKtJboN5IrlayuEr
         Spqw==
X-Gm-Message-State: AOAM533f8A8ATfptlXO/nHfwuoJOZWt2K3rPnDuBcG3kpVojMaTHvlO6
        AoOVuKhyc9S90Xnt75LDyakUHA==
X-Google-Smtp-Source: ABdhPJwIGrbK4KyNTds5smWJJ4zAFhQ5IOHVVyhL0gObMVN3sTRsWG+b+dllHjOw03HyY0O4b+99fw==
X-Received: by 2002:a92:512:: with SMTP id q18mr3637460ile.196.1599659025914;
        Wed, 09 Sep 2020 06:43:45 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id e28sm1437589ill.79.2020.09.09.06.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 06:43:45 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: ipa: use atomic exchange for suspend
 reference
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200909002127.21089-1-elder@linaro.org>
 <20200909002127.21089-2-elder@linaro.org>
 <20200908.202731.923992684489468023.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <bd61d3fb-44b7-9bc3-ccad-1101c5c34ebc@linaro.org>
Date:   Wed, 9 Sep 2020 08:43:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908.202731.923992684489468023.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 10:27 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Tue,  8 Sep 2020 19:21:23 -0500
> 
>> We take a single IPA clock reference to keep the clock running
>> until we get a system suspend operation.  When a system suspend
>> request arrives, we drop that reference, and if that's the last
>> reference (likely) we'll proceed with suspending endpoints and
>> disabling the IPA core clock and interconnects.
>>
>> In most places we simply set the reference count to 0 or 1
>> atomically.  Instead--primarily to catch coding errors--use an
>> atomic exchange to update the reference count value, and report
>> an error in the event the previous value was unexpected.
>>
>> In a few cases it's not hard to see that the error message should
>> never be reported.  Report them anyway, but add some excitement
>> to the message by ending it with an exclamation point.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> Please use refcount_t if you're wanting to validate things like
> this.

There is exactly one reference here; the "reference" is
essentially a Boolean flag.  So the value is always either
0 or 1.

I can use refcount_dec_if_one() for the 1->0 transition,
but I'm not sure how I can do the 0->1 transition with
refcount_t.  I admit I might be missing something.

Would you like me to add refcount_inc_if_zero()?

Otherwise would you prefer a different naming convention
to use for this Boolean "reference count"?

Thanks.

					-Alex

> 
> Thank you.
> 

