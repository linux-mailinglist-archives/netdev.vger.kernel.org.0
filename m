Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03035BB22
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhDLHqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDLHp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:45:58 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E030FC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:45:40 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b10so12475591iot.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYU4gbLeGAQPc5kjLRfVjCz/thSfTR7vClu5eRNAKVs=;
        b=pyowjiPGf2w/246JdUtszTOP+JlnvdvqDq1euQF5Y1vDruWC9FrBmDKjHcKz0aphXC
         uiU+kFZBkeIARVPcGCgxzE6yDzCD5gHhfmU5Z7EHc8RaDcigJYZwk5l7/jIObybPUylL
         LYwXzn4teL8p7Yadf2nc8K23nVGREAtHfUGsYhU6531A0Ca6hau1Ka/4e+WC9T9BwWhk
         vT6ajvuSzOxOZK4gd3k+ywzyLch7AZOvcWFwe4BDklJ4/aY/D0SYQm9AAXsRDPyCmphA
         ctTUeitUfyYLRr0jwryT44bfvTlmPrWhvVt15GlTLguBWFqz0WTtX56sWwZI0tP5Df11
         MI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYU4gbLeGAQPc5kjLRfVjCz/thSfTR7vClu5eRNAKVs=;
        b=sW9gzhQNWesE2jv4Rw476NRnaITEGpXc51gl70nWO31u19olZHF6uXs+WFpYW5su5N
         b7Z8vMa8/rMLlJ9gidV9to+2ikitFUlE0ODigSdAJA8PSVtQoLC5aKPAqGL/pUV02eGu
         VYD6yWtFP63APHZdG5E69YflX5FP/UKVNsPw+6OJLV+PiWcKl9xb7I3B8n+eIebyyKSd
         yE+a7Z1oIJ02E8lSf0b5klnN7b+dY/BSR8JMc8k1HsLX+Tgkf0Tml9xiQMykAxadIvDA
         aSt0caszFw/BBFUSOnLsVGD+qkT3ZGZFZTDvlPpG2v1PVQnQUPNvBAuKMpFYVJXsqv87
         G7+Q==
X-Gm-Message-State: AOAM533UOD4h4jdwGseUuF/uoNglCldseev+Tw6xBLYp5I+MDzjeoMgo
        ih88durYfU8pH7Er8q+tRvZV9g==
X-Google-Smtp-Source: ABdhPJyzPIwAfz1B+C3mFdUnREI4S1utijqYga+TvACLWidNuWbqve+fwxg4SaEAVta8XHdz0UbxLQ==
X-Received: by 2002:a02:b1ca:: with SMTP id u10mr26782374jah.99.1618213540056;
        Mon, 12 Apr 2021 00:45:40 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id g8sm5174600iln.83.2021.04.12.00.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:45:39 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org> <YHKYWCkPl5pucFZo@unreal>
 <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org> <YHL5fwkYyHvQG2Z4@unreal>
 <6e0c08a0-aebd-83b2-26b5-98f7d46d6b2b@linaro.org> <YHP2IKZ7pB+l4a6O@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <dcfa0fae-1321-1583-cb46-1665e1a4ea93@linaro.org>
Date:   Mon, 12 Apr 2021 02:45:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHP2IKZ7pB+l4a6O@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/21 2:26 AM, Leon Romanovsky wrote:
> On Sun, Apr 11, 2021 at 08:42:15AM -0500, Alex Elder wrote:
>> On 4/11/21 8:28 AM, Leon Romanovsky wrote:
>>>> I think *not* checking an available return value is questionable
>>>> practice.  I'd really rather have a build option for a
>>>> "__need_not_check" tag and have "must_check" be the default.
>>> __need_not_check == void ???
>>
>> I'm not sure I understand your statement here, but...
> 
> We are talking about the same thing. My point was that __need_not_check
> is actually void. The API author was supposed to declare that by
> declaring that function doesn't return anything.

No, we are not.

Functions like strcpy() return a value, but that value is almost
never checked.  The returned value isn't an error, so there is
no real need to check that return value.  This is the kind of
thing I'm talking about that might be tagged __need_not_check.

A function that returns a value for no reason should be void,
I agree with that.

In the ipa_stop() case, the value *must* be returned because
it serves as an ->ndo_stop() function and has to adhere to
that function prototype.  The point of the current patch
was to simplify the code (defined privately in the current
source file), given knowledge that it never returns an error.

The compiler could ensure all calls to functions that return
a value actually check the return value.  And because I think
that's the best practice, I'd like to be able to run such a
check in my code.  But there are always exceptions, and that
would be the purpose of a __need_not_check tag.

I don't think this is worthy of any more discussion.

					-Alex
