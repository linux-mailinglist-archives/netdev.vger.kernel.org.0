Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2521567953F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjAXKdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjAXKdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:33:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B96F14206
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:33:08 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r2so13392066wrv.7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=F3+6syDFUyI6M3rChIO3ZkAIigKcy5+yay4DpMq73Pc=;
        b=fWvh5EMLDgsV8nWFi71aMBXmmkXYwriQuIY0vo8b7JX2IyUqWV0X+nfinLeMiSFSMR
         vkK+b7K8Nz9WypRwA1YivzwPvP0fV/rdvhbeuWa+6aqJbJ3pQH2mXQ3e9VDXQHoEnxl1
         sENtG8e4D2iREPrHSOkPjb/mypdxL6YUB6KVF5f5kdZADCLduYQbL8Rg329QiWaO/mF4
         Eq366KZfhg+9QTP4wQqSZIeXVckRHNEtMJQlSqgvywSWXbjSHd0bxlGZLjMcdUj/cL1+
         B60/oEzHTHsh/YG0f9jDX0jC36T4Pcy28wTIHFWul0KaKBwO7OQHOmSI92vQcWxjq+1h
         oTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F3+6syDFUyI6M3rChIO3ZkAIigKcy5+yay4DpMq73Pc=;
        b=3THk910Ix/q28UYye6WqIkkm1LbFR31fB4gIhmsmXCIjFLoFFZk+lJUZ/GR6OgfcZN
         mI+HUiEIXZAwExE3cDnO9vo3feJdEcmaLLIlSeC60q+wRKJTXpTCW/6lbH1dxEX43w4x
         TlPBpgc1i9sgZKgQviuKtw/wi/8uKfDFitnnUjFKYTcqLxReFcbgXqXV0UWmzSM1DaZX
         NoqvjBSbvJPOxeMQrk3fJyuRU19VlJnMJn/T5lvSXwV/jPNsZWiKmlbggFBjRWLS6SLJ
         crsf+QvR+FehyQuY2tejUGWpRCy6g0ZbZP31KM/kZd1hywFx/WNSzmO0sfcmQ1N/MBU7
         5R2w==
X-Gm-Message-State: AO0yUKX3yIZiwpZv7Wq0aTjwcAGQRp+gFsf+gBFG2SF6vNiEhghaXAbM
        DUKnsCK2ajIACJs/BJwtkPU=
X-Google-Smtp-Source: AK7set+JU8c+PH/A/IYhZ161TUxLFicFiF2m+OfBsx0eKt6IGkY4QOAzWNpq1omOxjOkkJiajHglTw==
X-Received: by 2002:adf:f352:0:b0:2bf:ae51:807c with SMTP id e18-20020adff352000000b002bfae51807cmr1928093wrp.22.1674556387097;
        Tue, 24 Jan 2023 02:33:07 -0800 (PST)
Received: from ?IPV6:2a06:c701:476b:e300:4999:e1c1:94d2:c10f? ([2a06:c701:476b:e300:4999:e1c1:94d2:c10f])
        by smtp.gmail.com with ESMTPSA id u7-20020adfdb87000000b002bc7e5a1171sm1517603wri.116.2023.01.24.02.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 02:33:06 -0800 (PST)
From:   Bar Shapira <bar.shapira.work@gmail.com>
X-Google-Original-From: Bar Shapira <barshapirawork@gmail.com>
Message-ID: <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
Date:   Tue, 24 Jan 2023 12:33:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
References: <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org> <87y1pt6qgc.fsf@nvidia.com>
 <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
In-Reply-To: <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/01/2023 0:36, Richard Cochran wrote:
> On Mon, Jan 23, 2023 at 10:44:35AM -0800, Rahul Rameshbabu wrote:
> 
>> 1. Can the PHC servo change the frequency and not be expected to reset
>>     it back to the frequency before the phase control word is issued? If
>>     it's an expectation for the phase control word to reset the frequency
>>     back, I think that needs to be updated in the comments as a
>>     requirement.
> 
> I would expect the PHC to restore the previously dialed frequency once
> the ADJ_OFFSET (adjphase) calls stop.
> 

Hi Richard,
I guess this expectation should be part of the documentation too, right? 
Are there more expectations when calling adjphase?
In previous responses on the mailing list it said that adjphase should 
not cause the time to 'jump' - is it also correct?

It seems that "Feeds the given phase offset into the hardware clock's 
servo" is still missing some information.
Can you help clarify the expected result after calling adjphase from SW?

Thanks,
Bar

> Thanks,
> Richard
