Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2890B26386A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIIVXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIVXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:23:30 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B423C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:23:28 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r25so4858021ioj.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 14:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SMie+bfHqpuPuJrlp3QXXsieaeYhE6v5BnpMbW6FXnY=;
        b=i1fqaG82ElqP4v14cdNAzd+s2XgzH6u6ZDP/HIBk0RUZgw5f2coByN7IJ26jIARkB+
         ogPSWrd9v6MdlFr7scU+Eg+/dXz6PwkMYjG9guxeKXzWIwFAp9OjSTsIeqDqRUlZNGq0
         JNrH3ybtzWrj5fcof+EwaJDOamphGIea2FT0nrQlZ6JQ9K4+IPHOxmziO3sYW97ehL0W
         /bUnqggV2fwZG2GJ8JS4AkHbnfMWte+aBThvqyFBN0iDN7jVEjMgz5fJz+sLY0OHMl1b
         CK7Nw3/JxUbxxt6OM5S+rPHBcfUkWuRArOfQTfQDR7OqirYobJnWRbG3Kprktxv6kLx5
         hrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SMie+bfHqpuPuJrlp3QXXsieaeYhE6v5BnpMbW6FXnY=;
        b=UIptsuOgeMzcoWjm+D1ca38CqtcVWo6CAf0Sou7uVMv12eNjRuDJhBYJJ6qjWBVh2g
         ugxX3BoSkW7ugh1HlXYJtyV8hLgNHhbNMUbTSMeLHwWWZZgi7n4FQf195+L3yExHCLyN
         XNB1IEnbuLzZXRRXo3/gSH/tq2sjsZuNbJG/hDIDWgJB7sfuewdKacgJgbMEzEXhkq2p
         Y/FJpd0Yal8LnEzit4rWuE0SePRkyzruChjNkAfI6OOQE1Mynv75gbN/bOaLL6JemwrL
         MadZXiAPCW27hcv8F4dF0i4CGPwuzrAm/pnq1tu09BtkxxgXcHe1GX1WsEbBHKJhfKun
         bNlw==
X-Gm-Message-State: AOAM531HQMv+g4mRBrYdhyqd5h3JLPApoHx/4NMsZ/+7wfeXZRLGmFSP
        /s16Vg2iKhj6JYiGyNY6RocYqTqwrBetTw==
X-Google-Smtp-Source: ABdhPJyKpowS4ikByJciRpYyio9tOAU8nV4FRiT+Jm+bB7xriInhv1hY4AREDMVM3oOxHS3almRpzw==
X-Received: by 2002:a05:6602:2a4b:: with SMTP id k11mr4947999iov.85.1599686607346;
        Wed, 09 Sep 2020 14:23:27 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p12sm1288824iom.47.2020.09.09.14.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 14:23:26 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: ipa: use atomic exchange for suspend
 reference
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200909002127.21089-2-elder@linaro.org>
 <20200908.202731.923992684489468023.davem@davemloft.net>
 <bd61d3fb-44b7-9bc3-ccad-1101c5c34ebc@linaro.org>
 <20200909.141402.826324173736678429.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <0261349f-cf2e-9fc8-c543-f6cc5c912096@linaro.org>
Date:   Wed, 9 Sep 2020 16:23:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909.141402.826324173736678429.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 4:14 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Wed, 9 Sep 2020 08:43:44 -0500
> 
>> There is exactly one reference here; the "reference" is
>> essentially a Boolean flag.  So the value is always either
>> 0 or 1.
> 
> Aha, then why not use a bitmask and test_and_set_bit() et al.?

OK I'll go take a look at that option.  It's overkill for
bits used but it makes it more obvious it's a single bit,
so it's probably a better idea.

I'll try to turn this around again by tomorrow.  Thank you.

					-Alex
