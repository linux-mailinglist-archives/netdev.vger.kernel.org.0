Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AA324B13
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhBYHMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:12:41 -0500
Received: from z11.mailgun.us ([104.130.96.11]:16520 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233365AbhBYHK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 02:10:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614237005; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fhKevOHehiegfOXn/eFOQhWNvbp+UhxyIGdicHbL2tM=; b=jkOWZqRqxUtghAaxzly3BzUocisGH/qfb4+gOjhty9b0G8DL0x94juWCHdLl/Da5sB+8ajer
 GMX1U14cQFcii8gFJ7yyeJMWZzZ9ApMza1HOMFjyUlaaNvtyNsMXXewUfgVSqO2pBs4Hqkkw
 KYLDFrRQQIVroPGKDTEOuCDg0n4=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60374d2f095efe1816afd5b0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 25 Feb 2021 07:09:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A6F7C43462; Thu, 25 Feb 2021 07:09:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2299AC433C6;
        Thu, 25 Feb 2021 07:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2299AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <marcus.folkesson@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
References: <20210224163706.519658-1-marcus.folkesson@gmail.com>
        <87pn0pfmb4.fsf@codeaurora.org>
        <1b8270b5-047e-568e-8546-732bac6f9b0f@microchip.com>
Date:   Thu, 25 Feb 2021 09:09:30 +0200
In-Reply-To: <1b8270b5-047e-568e-8546-732bac6f9b0f@microchip.com> (Ajay
        Kathat's message of "Thu, 25 Feb 2021 05:06:59 +0000")
Message-ID: <87lfbcfwt1.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> On 24/02/21 10:13 pm, Kalle Valo wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>> 
>> Marcus Folkesson <marcus.folkesson@gmail.com> writes:
>> 
>>> Write the value instead of reading it twice.
>>>
>>> Fixes: 5e63a598441a ("staging: wilc1000: added 'wilc_' prefix for function in wilc_sdio.c file")
>>>
>>> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
>>> ---
>>>  drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> index 351ff909ab1c..e14b9fc2c67a 100644
>>> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> @@ -947,7 +947,7 @@ static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
>>>                       for (i = 0; (i < 3) && (nint > 0); i++, nint--)
>>>                               reg |= BIT(i);
>>>
>>> -                     ret = wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
>>> +                     ret = wilc_sdio_write_reg(wilc, WILC_INTR2_ENABLE, reg);
>> 
>> To me it looks like the bug existed before commit 5e63a598441a:
>
>
> Yes, you are correct. The bug existed from commit c5c77ba18ea6:
>
> https://git.kernel.org/linus/c5c77ba18ea6

So the fixes tag should be:

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")

I can change that during commit, ok?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
