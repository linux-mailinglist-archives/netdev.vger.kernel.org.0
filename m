Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2D3F174C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbhHSKbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:31:12 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34532 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbhHSKbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:31:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629369032; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Hu2wSL9evcSmVbFdigxDinq0Nbyloz4ZFXU0qiw54g0=; b=kFl3UNW+3mr0tIgb3UdPCfe1k+SQ7kirUKaFGd5oCVusPMXudBvJTsTvXpeXUdj84bF8NBCO
 dwEGAHlPJjnd2bZoj2QY9w6mgWw+TqKnRuxlqB7CtNb9BHNcCXpqdb43NpHq7QH4xk7zFtOe
 EjZ3qEPSOj3obV+Yz67gYy4I8LQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 611e32c79507ca1a34a7db25 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 19 Aug 2021 10:30:31
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2AE0BC4360D; Thu, 19 Aug 2021 10:30:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.52] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2D2DC4338F;
        Thu, 19 Aug 2021 10:30:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org F2D2DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, sricharan@codeaurora.org
References: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
 <20210818074102.78006-1-michael@walle.cc>
 <9aa1543b-e1b8-fba2-1b93-c954dd2e3e50@codeaurora.org>
 <YR0+uXdKoXrFEhpZ@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <20957be7-6a7e-4a41-706f-4e4222c11b1c@codeaurora.org>
Date:   Thu, 19 Aug 2021 18:30:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YR0+uXdKoXrFEhpZ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/19/2021 1:09 AM, Andrew Lunn wrote:
> On Wed, Aug 18, 2021 at 09:34:40PM +0800, Jie Luo wrote:
>> On 8/18/2021 3:41 PM, Michael Walle wrote:
>>>> qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in
>>>> the near future,
>>>>
>>>> so it may be a good idea to keep it out from at803x code.
>>> The AR8031 also supports PTP. Unfortunately, there is no public datasheet
>>> for the QCA8081, so I can't have a look if both are similar.
>>>
>>> See also,
>>> https://lore.kernel.org/netdev/20200228180226.22986-1-michael@walle.cc/
>>>
>>> -michael
>> Hi Michael,
>>
>> Thanks for this comment. it is true that AR8031 supports basic PTP features.
>>
>> please refer to the following link for the outline features of qca801.
>>
>> https://www.qualcomm.com/products/qca8081
> Is the PTP hardware in the qca8081 the same as the ar8031? When you
> add PTP support, will it be for both PHYs?
>
> What about the cable diagnostics? The at803x already has this
> implemented. Will the same work for the qca8081?
>
>      Andrew

Hi Andrew,

qca8081 enhances the ptp feature from AR8031, the new ptp driver should 
be for qca8081, which is fully

tested on qca8081, but it is not verified on AR8031 currently.

the cable diagnostics feature of qca8081 is almost same as ar8031 but 
the register is changed, will correct it

for qca8081 in the next patch correspondingly.

thanks.

