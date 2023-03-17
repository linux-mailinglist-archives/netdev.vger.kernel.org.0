Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6316BEEEF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCQQzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQQzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:55:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3234044A4;
        Fri, 17 Mar 2023 09:55:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso9647230pjb.3;
        Fri, 17 Mar 2023 09:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQBpav1FYobf3FdN98BFiGZMbqLp2dtSePWz+wd/wDU=;
        b=DItLMS1d3mWz/5TcrtphrYofycA1jCPq6/0jEmwewNozlTUqCH3XAvDPhZjpEF/kXB
         JXPaxpP8d+YlQGdzVB/AKSPX0R0XRVCRD5320YS/BEQKRaRgfbQKidC+ftfFjl1D5o0X
         hKf6n0hd3nsuF6x48cRS9bochchQKNBCzuT6N7zflTzo9uiT2SqpO/5ZI2MBCHuAHY0K
         7pSTK4rDOZJ594FNjrOoIr6xfznzGIcu6crcfeYDEJPK46whZYEx7Apn8KzInWx+kfTf
         wuYth7ifK51zVJaA7pxHFgkUB3lOI+i6x+wk7qj/oZfXnOpjg26HNcYlqRFyiMB3nNEx
         XmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQBpav1FYobf3FdN98BFiGZMbqLp2dtSePWz+wd/wDU=;
        b=DwrVDRlBYZVXlKlej46ujTtrPqazHHe1SNGCPLDbB6pUnsQ6Z7GQe9J7IuFlMRLWoN
         2sHpSqTXGp4ia9s6prVB0JtpV70gRuWL8jey07m94VqFk1X5jUJaE9e6AA2nHSjGzgk6
         nE1VRi7Om/mhDigx27n77mt5DwdxtaxXM0GgIgyTrSxVK0s3zMNVfiYjJluXSwlmL4ds
         L80LPKlahejcB+FUMbeMl84/+VdFTMWXA8WJMhHw9ZJWybzofaNbGx7iGau7zptLCVoY
         2GpYkOlWq5EmJfwJ7nHt9EAhV2+UAzA0Y7T3uc+85FxQ5IpuTGqSScC3VaDGbq6AQNEP
         cong==
X-Gm-Message-State: AO0yUKXqLNncohtIFybrBYaXoGpQRo0YL6II8sMZFhSG2vu1pCVjbB5M
        CPw2XMNb/IiM7A4rKCBL1+8=
X-Google-Smtp-Source: AK7set/wdNYlcSaXja9Wy9Rv5RxF6uNAeWSUfwiDKTYXBDQh0ik9TYkps4sAmgW0dU0OHT/i1OYWsQ==
X-Received: by 2002:a05:6a21:99a6:b0:d6:532:6671 with SMTP id ve38-20020a056a2199a600b000d605326671mr3791392pzb.14.1679072106382;
        Fri, 17 Mar 2023 09:55:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a3-20020a637f03000000b005034a46fbf7sm1703624pgd.28.2023.03.17.09.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:55:05 -0700 (PDT)
Message-ID: <9f771318-5a59-ac31-a333-e2ad9947679f@gmail.com>
Date:   Fri, 17 Mar 2023 09:54:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Content-Language: en-US
To:     Jonas Gorski <jonas.gorski@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230317120815.321871-1-noltari@gmail.com>
 <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
 <CAOiHx==TiSZKE4AP3PZ9Ah4zuAsrfpOTvRADWpT2kMS9UVRH9Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAOiHx==TiSZKE4AP3PZ9Ah4zuAsrfpOTvRADWpT2kMS9UVRH9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 09:49, Jonas Gorski wrote:
> On Fri, 17 Mar 2023 at 17:32, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Fri, Mar 17, 2023 at 01:08:15PM +0100, Álvaro Fernández Rojas wrote:
>>> When BCM63xx internal switches are connected to switches with a 4-byte
>>> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
>>> based on its PVID (which is likely 0).
>>> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
>>> tag is properly processed. The next step would to decode the corresponding
>>> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
>>> 6-byte tag and the 4-byte tag handling fails.
>>> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
>>> tag before passing it to the 4-byte tag decoding.
>>
>> Is there an errata for this invalid VLAN tag? Or is the driver simply
>> missing some configuration for it to produce a valid VLAN tag?
>>
>> The description does not convince me you are fixing the correct
>> problem.
> 
> This isn't a bug per se, it's just the interaction of a packet going
> through two tagging CPU ports.
> 
> My understanding of the behaviour is:
> 
> 1. The external switch inserts a 4-byte Broadcom header before the
> VLAN tag, and sends it to the internal switch.
> 2. The internal switch looks at the EtherType, finds it is not a VLAN
> EtherType, so assumes it is untagged, and adds a VLAN tag based on the
> configured PVID (which 0 in the default case).
> 3. The internal switch inserts a legacy 6-byte Broadcom header before
> the VLAN tag when forwarding to its CPU port.
> 
> The internal switch does not know how to handle the (non-legacy)
> Broadcom tag, so it does not know that there is a VLAN tag after it.
> 
> The internal switch enforces VLAN tags on its CPU port when it is in
> VLAN enabled mode, regardless what the VLAN table's untag bit says.
> 
> The result is a bogus VID 0 and priority 0 tag between the two
> Broadcom Headers. The VID would likely change based on the PVID of the
> port of the external switch.

My understanding matches yours, at the very least, we should only strip 
off the VLAN tag == 0, in case we are stacked onto a 4-bytes Broadcom 
tag speaking switch, otherwise it seems to me we are stripping of VLAN 
tags a bait too greedily.
-- 
Florian

