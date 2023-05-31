Return-Path: <netdev+bounces-6655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDD57173A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B3272813E5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36291390;
	Wed, 31 May 2023 02:20:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91FC1385
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:20:09 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E234A12B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:20:03 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id BC7C9846F1;
	Wed, 31 May 2023 04:19:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685499596;
	bh=gNzryhBCogzHM7Kd4jAnC6tpsGljjaKdhrXly9Lw92U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bDzYaWnKSbVRX8IdTiYBF4TPgWV2R6H5l2ue275kZrS+BaelQU+/j0JD0Q4cnNnGZ
	 c36r5FrFkyR6zVySSaUQ3kn+FJb0E+aXI9oVa7nWG4wVCSFgz4GE5fp+9Ml/+a8JKA
	 1b07twpwhECCAsSsvey0Sr52M0eurNBcavCNWIqL8sQOMFnLL7gvRTnfHS3Z0GLFfq
	 utDASTEd5WdBkLBzEGR5WIfq9bmVZUBvSH4mV6dHaCXj/HiERlPoPbftlS/tjt2OBU
	 b5suLfaGeRs/OewfQShH94BQ92qak+g5zKYNFKL9AuRZN2enQBvaHNJvnKU7XTWXcr
	 CMpZu300YfXiA==
Message-ID: <8605c773-0778-a256-0cc2-7d76eebe3cfe@denx.de>
Date: Wed, 31 May 2023 04:19:55 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: ks8851: Drop IRQ threading
Content-Language: en-US
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Geoff Levand <geoff@infradead.org>,
 Jakub Kicinski <kuba@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Paolo Abeni <pabeni@redhat.com>, Petr Machata <petrm@nvidia.com>,
 Wolfram Sang <wsa+renesas@sang-engineering.com>
References: <20221216124731.122459-1-marex@denx.de>
 <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
 <Y5zpMILXRnW2+dBU@google.com> <7a50a241-0a93-3e44-bcc7-b9e07c62d616@denx.de>
 <Y5zx8F508bzyy32A@google.com>
From: Marek Vasut <marex@denx.de>
In-Reply-To: <Y5zx8F508bzyy32A@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/16/22 23:32, Dmitry Torokhov wrote:
> On Fri, Dec 16, 2022 at 11:19:27PM +0100, Marek Vasut wrote:
>> On 12/16/22 22:54, Dmitry Torokhov wrote:
>>> On Fri, Dec 16, 2022 at 02:23:04PM +0100, Eric Dumazet wrote:
>>>> On Fri, Dec 16, 2022 at 1:47 PM Marek Vasut <marex@denx.de> wrote:
>>>>>
>>>>> Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
>>>>> "
>>>>> NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
>>>>
>>>> This changelog is a bit terse.
>>>>
>>>> Why can other drivers use request_threaded_irq(), but not this one ?
>>>
>>> This one actually *has* to use threading, as (as far as I can see) the
>>> "lock" that is being taken in ks8851_irq for the SPI variant of the
>>> device is actually a mutex, so we have to be able to sleep in the
>>> interrupt handler...
>>
>> So maybe we should use threaded one for the SPI variant and non-threaded one
>> for the Parallel bus variant ?
> 
> I do not think the threading itself is the issue. I did a quick search
> and "Non-RCU local softirq work is pending" seems to be a somewhat
> common issue in network drivers. I think you should follow for example
> thread in https://lore.kernel.org/all/87y28b9nyn.ffs@tglx/t/ and collect
> the trace data and bug tglx and Paul. I see you are even on CC in that
> thread...

I ran into this again, with Linux 6.1.30, the machine with this MAC just 
flat out freezes when the MAC comes up, if I add this patch the machine 
works as it should. I don't have a good explanation however. Any ideas?

