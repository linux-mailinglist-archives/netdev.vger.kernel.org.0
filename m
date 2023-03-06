Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9690D6AD2F9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCFXqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCFXqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:46:20 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A887532A5;
        Mon,  6 Mar 2023 15:46:18 -0800 (PST)
Received: from [192.168.1.90] (unknown [188.24.156.231])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 3BA6B6602F5E;
        Mon,  6 Mar 2023 23:46:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678146376;
        bh=NEoWyHe0xORmwmkapLJCDAiOtq7Nhqyrhrxnf11E9X0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b7wEyD48eZrqKBBwbQBZGMDDqMv7sy8/YQfCNfrJlB94wRymvBrK30IppzEUOccJg
         EMi7WAao0h0YenfHKwuoTwA8eKHToT6ZoBkyjppspncS+qBobyyuBUoZUeZOoRRVGd
         nleQJwIJCrxzdyMzcLGeVhykAaNIffgea13u3HiWF4LH0iBCQxDMvEGRDwLi8dKk2z
         w+OXPZ3X29oxw7AM+9ZNaJCEWrQIHsq1/2F2mQYo6Q6+OyK3MBXR8iR9SplMEntAP9
         yl4y5mQIqv0cNpHkh5jEFW/QGk+m7o/9PSs6iyFhQN9eaLlYyuIyaguPanA4/nNbR5
         5FXdYSDVr4gKg==
Message-ID: <243aebb3-70d8-3d83-cb8f-bd1e67e6707e@collabora.com>
Date:   Tue, 7 Mar 2023 01:46:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 03/12] soc: sifive: ccache: Add StarFive JH7100 support
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-4-cristian.ciocaltea@collabora.com>
 <b969cf86-d5df-462a-982b-c5b67f97c3d6@spud>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <b969cf86-d5df-462a-982b-c5b67f97c3d6@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 01:32, Conor Dooley wrote:
> On Sat, Feb 11, 2023 at 05:18:12AM +0200, Cristian Ciocaltea wrote:
>> From: Emil Renner Berthing <kernel@esmil.dk>
>>
>> This adds support for the StarFive JH7100 SoC which also feature this
>> SiFive cache controller.
>>
>> Unfortunately the interrupt for uncorrected data is broken on the JH7100
>> and fires continuously, so add a quirk to not register a handler for it.
>>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> [drop JH7110, rework Kconfig]
>> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> 
> This driver doesn't really do very much of anything as things stand, so
> I don't see really see all that much value in picking it up right now,
> since the non-coherent bits aren't usable yet.
> 
>> ---
>>   drivers/soc/sifive/Kconfig         |  1 +
>>   drivers/soc/sifive/sifive_ccache.c | 11 ++++++++++-
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/soc/sifive/Kconfig b/drivers/soc/sifive/Kconfig
>> index e86870be34c9..867cf16273a4 100644
>> --- a/drivers/soc/sifive/Kconfig
>> +++ b/drivers/soc/sifive/Kconfig
>> @@ -4,6 +4,7 @@ if SOC_SIFIVE || SOC_STARFIVE
>>   
>>   config SIFIVE_CCACHE
>>   	bool "Sifive Composable Cache controller"
>> +	default SOC_STARFIVE
> 
> I don't think this should have a default set w/ the support that this
> patch brings in. Perhaps later we should be doing defaulting, but not at
> this point in the series.

I will handle this is v2 as soon as the non-coherency stuff is ready.

> Other than that, this is fine by me:
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks for reviewing,
Cristian

> Thanks,
> Conor.
