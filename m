Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0651814EB61
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgAaLD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:03:57 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:27464 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbgAaLD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 06:03:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580468636; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=rNOUhYWPTelGWLCs3FtWi8wsKS2uU5eRrCt6VpYAPQ0=; b=FuvKaCKb5Ix343TAsrO28+fU15XYvHT34kqDfcBzZ7SLQjlWFl0OWgzc+aghGV11sD1K4mKb
 PYeeV5sipo5D+Hz3WRobsnRZb6FWOUToaJrFFgET1876vDw4i5XVui9quUnu7FwEF7NhQFCn
 ygto1wk35t5VBg5SJfgO5ERtCoY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e340999.7efdf0508f48-smtp-out-n03;
 Fri, 31 Jan 2020 11:03:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D055BC433A2; Fri, 31 Jan 2020 11:03:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 57225C433A2;
        Fri, 31 Jan 2020 11:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 57225C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux\@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
References: <20200130013308.16395-1-natechancellor@gmail.com>
        <e0fb1ead6dcc4ecc973b3b9b5399ef66@realtek.com>
Date:   Fri, 31 Jan 2020 13:03:48 +0200
In-Reply-To: <e0fb1ead6dcc4ecc973b3b9b5399ef66@realtek.com> (Tony Chuang's
        message of "Fri, 31 Jan 2020 10:23:40 +0000")
Message-ID: <87mua3c2gb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

> From: Nathan Chancellor
>> Subject: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
>> 
>> Clang warns a few times (trimmed for brevity):
>> 
>> ../drivers/net/wireless/realtek/rtw88/wow.c:295:7: warning: variable
>> 'ret' is used uninitialized whenever 'if' condition is false
>> [-Wsometimes-uninitialized]
>> 
>> Initialize ret to true and change the other assignments to false because
>> it is a boolean value.
>> 
>> Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/850
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtw88/wow.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtw88/wow.c
>> b/drivers/net/wireless/realtek/rtw88/wow.c
>> index af5c27e1bb07..5db49802c72c 100644
>> --- a/drivers/net/wireless/realtek/rtw88/wow.c
>> +++ b/drivers/net/wireless/realtek/rtw88/wow.c
>> @@ -283,18 +283,18 @@ static void rtw_wow_rx_dma_start(struct rtw_dev
>> *rtwdev)
>> 
>>  static bool rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool
>> wow_enable)
>>  {
>> -	bool ret;
>> +	bool ret = true;
>> 
>>  	/* wait 100ms for wow firmware to finish work */
>>  	msleep(100);
>> 
>>  	if (wow_enable) {
>>  		if (!rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
>> -			ret = 0;
>> +			ret = false;
>>  	} else {
>>  		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) == 0
>> &&
>>  		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM,
>> BIT_RW_RELEASE) == 0)
>> -			ret = 0;
>> +			ret = false;
>>  	}
>> 
>>  	if (ret)
>> --
>> 2.25.0
>
> NACK.
>
> This patch could lead to incorrect behavior of WOW.
> I will send a new patch to fix it, and change the type to "int".

Please send it separately so that I can queue it to v5.6.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
