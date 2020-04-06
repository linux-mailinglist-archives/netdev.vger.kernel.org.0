Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC42819F77B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgDFOD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:03:27 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:56283 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728512AbgDFOD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:03:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586181807; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ddRHNrTYuHRZ9Qp05MVsdiWN86Gi1Yd/jbkzWd681IA=; b=UcSLmAMXe7IdJL9SLmJjE24+xB3UwwORB7jZuS6NfGtpgK5eY6eUdCtjbIM/IIB+E56hhKOx
 gv6R4kVsxw1SOzo9MU3DlvWwrfO1c/sTMVzO4ugDcu2xK4+CXBnQ1D99KSjW6KXTPRy9Rqj8
 OOfHfcA1khpMGdaSXqW7eYXRTU4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b369a.7fc899cd3998-smtp-out-n02;
 Mon, 06 Apr 2020 14:03:06 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50DCBC43636; Mon,  6 Apr 2020 14:03:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0FBE0C433D2;
        Mon,  6 Apr 2020 14:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0FBE0C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list\:REALTEK WIRELESS DRIVER \(rtw88\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtw88: Add delay on polling h2c command status bit
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
        <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
        <94EAAF7E-66C5-40E2-B6A9-0787CB13A3A9@canonical.com>
        <87zhboycfr.fsf@kamboji.qca.qualcomm.com>
        <83B3A3D8-833A-42BE-9EB0-59C95B349B01@canonical.com>
Date:   Mon, 06 Apr 2020 17:03:00 +0300
In-Reply-To: <83B3A3D8-833A-42BE-9EB0-59C95B349B01@canonical.com> (Kai-Heng
        Feng's message of "Mon, 6 Apr 2020 21:35:29 +0800")
Message-ID: <87k12syanf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

>> On Apr 6, 2020, at 21:24, Kalle Valo <kvalo@codeaurora.org> wrote:
>> 
>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>> 
>>>> On Apr 6, 2020, at 20:17, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> 
>>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>> 
>>>>> --- a/drivers/net/wireless/realtek/rtw88/hci.h
>>>>> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
>>>>> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32
>>>>> addr, u32 mask, u8 data)
>>>>> 	rtw_write8(rtwdev, addr, set);
>>>>> }
>>>>> 
>>>>> +#define rr8(addr)      rtw_read8(rtwdev, addr)
>>>>> +#define rr16(addr)     rtw_read16(rtwdev, addr)
>>>>> +#define rr32(addr)     rtw_read32(rtwdev, addr)
>>>> 
>>>> For me these macros reduce code readability, not improve anything. They
>>>> hide the use of rtwdev variable, which is evil, and a name like rr8() is
>>>> just way too vague. Please keep the original function names as is.
>>> 
>>> The inspiration is from another driver.
>>> readx_poll_timeout macro only takes one argument for the op.
>>> Some other drivers have their own poll_timeout implementation,
>>> and I guess it makes sense to make one specific for rtw88.
>> 
>> I'm not even understanding the problem you are tying to fix with these
>> macros. The upstream philosopyhy is to have the source code readable and
>> maintainable, not to use minimal number of characters. There's a reason
>> why we don't name our functions a(), b(), c() and so on.
>
> The current h2c polling doesn't have delay between each interval, so
> the polling is too fast and the following logic considers it's a
> timeout.
> The readx_poll_timeout() macro provides a generic mechanism to setup
> an interval delay and timeout which is what we need here.
> However readx_poll_timeout only accepts one parameter which usually is
> memory address, while we need to pass both rtwdev and address.
>
> So if hiding rtwdev is evil, we can roll our own variant of
> readx_poll_timeout() to make the polling readable.

Can't you do:

ret = read_poll_timeout(rtw_read8, box_state,
                        !((box_state >> box) & 0x1), 100,
                        3000, false, rtw_dev, REG_HMETFR);

No ugly macros needed and it should function the same. But I did not
test this in any way, so no idea if it even compiles.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
