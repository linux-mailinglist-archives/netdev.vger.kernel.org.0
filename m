Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D448C497
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353429AbiALNQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353437AbiALNQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:16:19 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEBBC06175C
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:16:15 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d14so2313494ila.1
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zkoZ5MryXhebSZqM6IHkMPC6B3Uzbqu2YHVeALw+ZY8=;
        b=bSv4N9wBD7O1xG7UR7RLPQc1rmgwwjnh33e1bTAHHIzJLoWgc1furTXL6U72ZCiVXF
         dA8XLW69kOrY+DS2ljpSW2CoU2kolTI30jKjFEb+pgX8Rjl8I2DNO2bfvVo+0akJNAWO
         WNXcakUC29BMQdkcSfFz8lyRnFo5/Np650dEC+1xWTMIAyI8SldzRReSYVxRho2rGIH9
         bEGB/CDJq0iGVSDBZ+zU0mUXBWWKP3n74JRQ7qKAB8K8t/qo3mT2HYdydVtuiDNq2xq2
         jBNLVPntykoU3VAj99MDhA4Pd0hKSvJvujvpMwzsZMP5UfYI3a5xmTtgf22Mc9TJDSWm
         OtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zkoZ5MryXhebSZqM6IHkMPC6B3Uzbqu2YHVeALw+ZY8=;
        b=zRuoen8GC/9ilXWTjOrwXpyM8LDHKbFlCfY6AEWphaWijlxFJC57cFUw26UbRjVNxm
         g8foiX/Hi9ZAYPCdyAHDhFzQvvHCkMDYrbYOyfD+JvH9NOGeFsK65+tGhnI2I3+4Jd6H
         spf+vcbRpenhMYXPzIw9JnlmEDlyRD0kHcyx+35W0hiqyO9rGCmlyEvqk4zVhvfqCLJR
         wNa4GJHnUGasSblWqUSLh0pGpz1/bI5r+1mBRCA9Q2EDG+VVv2ybWbPQAZfL1ZVnkaV6
         jCBYLivtyTFRShy05tnx6g6TlX1XvqV4q4+kmQB8dw9zqnh0ADnl0AWHxJm66iFH9WoR
         2BPw==
X-Gm-Message-State: AOAM5331A139zKtnv7WrDHxN5cmLSPeeYXBOz51nB/1BBTgo0KcJEfnM
        F1Nb+9dq5ZmBl0T0ABYBTU3cvg==
X-Google-Smtp-Source: ABdhPJzoWjW0vEAx2LmHQfkuags0Yw5wQHhmf1tbbd9Y8n1vH54WKWDKVUkF7VNR5ZslNwl0n0iB6g==
X-Received: by 2002:a05:6e02:b2b:: with SMTP id e11mr5003588ilu.48.1641993375027;
        Wed, 12 Jan 2022 05:16:15 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o21sm8169043iov.48.2022.01.12.05.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 05:16:13 -0800 (PST)
Message-ID: <9cb552e5-7bae-c591-a0b7-14f25a41eaf9@linaro.org>
Date:   Wed, 12 Jan 2022 07:16:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH net 2/2] net: ipa: prevent concurrent replenish
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111192150.379274-1-elder@linaro.org>
 <20220111192150.379274-3-elder@linaro.org>
 <20220111200426.37fd9f67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220111200426.37fd9f67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 10:04 PM, Jakub Kicinski wrote:
> On Tue, 11 Jan 2022 13:21:50 -0600 Alex Elder wrote:
>> Use a new atomic variable to ensure only replenish instance for an
>> endpoint executes at a time.
> 
> Why atomic_t? test_and_set_bit() + clear_bit() should do nicely here?

I think it foreshadows the replenish logic improvements
I'm experimenting with.  The bit operations are probably
best to represent Booleans, so I'll send version 2 that
adds and uses a bitmask instead.

Thanks.

					-Alex
