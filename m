Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890796521B0
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiLTNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLTNsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:48:55 -0500
Received: from pv50p00im-ztdg10021901.me.com (pv50p00im-ztdg10021901.me.com [17.58.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4363EC
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1671544134;
        bh=urUTsBdrwL9I2ZT1boNQEfwYLQQMShMrrqH0rVVbrRQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=hxXLRvEY1Rw90AMW1xuOflDjkIAEi6yOifccnQqfhTN+rHhYIqQGQi36UP+dTULY2
         dC1j0dXbnd+Lwdiu8kkMVFiSJ6CGBPcLc7i1xtwMhSZe1LkS7hzZZHCtUEe3AIQQBu
         OxRaEC3CuaDMZcRKHQbyJBVAMQCsxcUCkdTOpDNn6sSzfTFodJEJdttsgZawo1TbNS
         836qnX6RXG662HKxiR7ksNFhK9jZmDzJdxVer7VhGf6Ua5hGvPNvxBLlR8bxeZTxm+
         6GKQiF8avPyHipXPG/DJHfQ9AHb77OJQSrDyun+TxnHM6fz8JL/a6xLkk89/cRA8M4
         2Ju7/P70wM8Kw==
Received: from [192.168.1.30] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021901.me.com (Postfix) with ESMTPSA id A408C814DA;
        Tue, 20 Dec 2022 13:48:50 +0000 (UTC)
Message-ID: <192a31a9-ea33-0c51-6549-0525fd3a5b4e@zzy040330.moe>
Date:   Tue, 20 Dec 2022 21:48:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Content-Language: en-US
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
 <33b2b585-c5b1-5888-bcee-ca74ce809a44@gmail.com>
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <33b2b585-c5b1-5888-bcee-ca74ce809a44@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: q507JHXLFw3SkZ5kvQgEzDwMs_YeXnWm
X-Proofpoint-GUID: q507JHXLFw3SkZ5kvQgEzDwMs_YeXnWm
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.883,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2020-02-14=5F02,2022-06-21=5F08,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1030 bulkscore=0
 mlxlogscore=692 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212200113
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/12/2022 21:03, Bitterblue Smith wrote:

> On 20/12/2022 07:44, Ping-Ke Shih wrote:
>>
>>> -----Original Message-----
>>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>>> Sent: Saturday, December 17, 2022 11:07 AM
>>> To: Jes.Sorensen@gmail.com
>>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>>> <JunASAKA@zzy040330.moe>
>>> Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
>>>
>>> Fixing transmission failure which results in
>>> "authentication with ... timed out". This can be
>>> fixed by disable the REG_TXPAUSE.
>>>
>>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>>> ---
>>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> index a7d76693c02d..9d0ed6760cb6 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>>   	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>>   	val8 &= ~BIT(0);
>>>   	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>>> +
>>> +	/*
>>> +	 * Fix transmission failure of rtl8192e.
>>> +	 */
>>> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
>> I trace when rtl8xxxu set REG_TXPAUSE=0xff that will stop TX.
>> The occasions include RF calibration, LPS mode (called by power off), and
>> going to stop. So, I think RF calibration does TX pause but not restore
>> settings after calibration, and causes TX stuck. As the flow I traced,
>> this patch looks reasonable. But, I wonder why other people don't meet
>> this problem.
>>
> Other people have this problem too:
> https://bugzilla.kernel.org/show_bug.cgi?id=196769
> https://bugzilla.kernel.org/show_bug.cgi?id=216746
Actually, one of the two bug was issued by me. Also, my friend who is 
using a TP-Link rtl8192eu device said that his device doesn't work as well.
>
> The RF calibration does restore REG_TXPAUSE at the end. What happens is
> when you plug in the device, something (mac80211? wpa_supplicant?) calls
> rtl8xxxu_start(), then rtl8xxxu_stop(), then rtl8xxxu_start() again.
> rtl8xxxu_stop() sets REG_TXPAUSE to 0xff and nothing sets it back to 0.
