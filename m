Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAD3E29DD
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245607AbhHFLkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245589AbhHFLkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:40:06 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A53DC061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 04:39:51 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id l20so8691832iom.4
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HTJLeUnlm3HtnOmw9AAXerWvRuxCJs/WvRfnWYzh2PA=;
        b=kEsijTWFCPQG7e/0Vestxk4EAdKk04Z+mg2YXFdiKpcJVHVZ6lMpy8uDnOsWk6GuMn
         ax53mKRkUyUUZlvZi7rHIRCfNEGo9dqj0ynsy9vcCYr8hN3yvhx6j2P91YrL1aP3I39T
         z7RXttj/tq+F+O3DjeuOacOM3kmyd2gxA25UVz5cUkg7ombsNE3f4bW5ybV6ogxrXCYB
         P6U8lRs7Ugq13sfVIYWax+LPYkYkhVUcWVoyi70gRQLE/vEdmYTY1vxbFWh5iQfDvgwi
         NA5lFBikR+QLcT/nm9LwLlaxjFa/S4/4LHRo1VMsiEd62DoyRkJH4OC0hjGdthL8QKQI
         /9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HTJLeUnlm3HtnOmw9AAXerWvRuxCJs/WvRfnWYzh2PA=;
        b=bJhz7lzaYBU9PV/2ZenU9x68BMBN8RPjowtd/JwPjeIdpl3qVqlkzwfKz+svgnRdvs
         QxAhJPUuoGHxYtJmihykxln67ySKeejS8+PxWyzlBV0w0I/K8J7ftog/n4GMSfkRdBP9
         eGYZ23JJ2HQO69gSAQNHbeDN3JxX4hWxIVubpKb5VVo9SDyKdT1iD+S9u1usaKrU2EBi
         kZtqeOPt+lqv50Mr6Sd/vYaNIV2JeXJ5A44Xad9cfOMSkEicfPOLPNS4Kv7VlwrHyyNh
         AIwr/or7uEWqvAHgVpIaTT21WzhtC/NjbsrTZ0ysdDIYU80uEgrse5Lc5pOUe88ELTXe
         sT/Q==
X-Gm-Message-State: AOAM533AaHrDxg2ZrWGXtr6d99Xpr7Q4T68EP/UqUgM4OmwWkqsZam83
        5Imgi95TSwk4mFRVRnC02xAYvg==
X-Google-Smtp-Source: ABdhPJzHI+3fg+nkXsxbfuCn/x8UIxQF7yeDhXRa0apW6c57HRme9NAuzxdL4DUawKwZbw5GO8Oigg==
X-Received: by 2002:a5e:8d16:: with SMTP id m22mr167287ioj.60.1628249990676;
        Fri, 06 Aug 2021 04:39:50 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f5sm4528229ilr.72.2021.08.06.04.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:39:50 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: ipa: reorder netdev pointer assignments
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210804153626.1549001-1-elder@linaro.org>
 <20210804153626.1549001-3-elder@linaro.org>
 <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <5b2a7fbc-f485-3c6c-af05-d8df18f55406@linaro.org>
Date:   Fri, 6 Aug 2021 06:39:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 8:27 PM, Jakub Kicinski wrote:
> On Wed,  4 Aug 2021 10:36:22 -0500 Alex Elder wrote:
>> Assign the ipa->modem_netdev and endpoint->netdev pointers *before*
>> registering the network device.  As soon as the device is
>> registered it can be opened, and by that time we'll want those
>> pointers valid.
>>
>> Similarly, don't make those pointers NULL until *after* the modem
>> network device is unregistered in ipa_modem_stop().
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> This one seems like a pretty legit race, net would be better if you
> don't mind.

I don't mind at all.  But now that it's accepted, I'm not sure how
to go about getting it back-ported.  Mainly I don't want to interfere
with any interaction between net/master and net-next/master...  Maybe
you're in a better position to do that.  And if so:

Fixes: 57f63faf0562 ("net: ipa: only set endpoint netdev pointer when in 
use")

I'll happily do it if you can tell me the best way how.  Thanks.

					-Alex
