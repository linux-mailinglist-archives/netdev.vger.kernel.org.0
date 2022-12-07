Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F06452CB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLGEBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLGEBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:01:39 -0500
Received: from pv50p00im-ztdg10012101.me.com (pv50p00im-ztdg10012101.me.com [17.58.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7471954B02
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1670385696;
        bh=RH16D7d4KZWO1+9ckND1BBAhK2hU1iiMrJQe/a56u8k=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=XWzr9wllFyCncqLTw2WwfDhjlvlp1/HW3q4qRBRTnE2jweuQnruh87GmLd4lVexY9
         bAz5325C4MnPUzk7BhvyDtjVEDmILTAOeyAHt9Vnrk0xaWTq6YoGUIVElw+GtGXyxM
         LcS9fJpl+FspSu49rX4stwcbXZflAvEJUDfeot3VeTwUI6BuVOwUpIYnz1vx39hNTJ
         gg7ZyHnBhPmJHjn8+nggtbq881Hx5voTV1dMuG/ylZZrH2RbDAp9QsNl9BcVmxHMPl
         M5IZnLv1dNihic+I1W5gcIp88ZP5vTgNqLl/ezZ9M5TM6c3gZEsVyxWb3rPMx/zPu3
         loqgE8yX4rPOQ==
Received: from [192.168.1.28] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012101.me.com (Postfix) with ESMTPSA id 1ED2C74064F;
        Wed,  7 Dec 2022 04:01:32 +0000 (UTC)
Message-ID: <363010d3-b9f4-cf83-11d1-20174e7c0d14@zzy040330.moe>
Date:   Wed, 7 Dec 2022 12:01:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
 <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
 <b4b65c74-792f-4df1-18bf-5c6f80845814@zzy040330.moe>
 <159ac3a296164b05b319bfb254a7901b@realtek.com>
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <159ac3a296164b05b319bfb254a7901b@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: iAiE7nLz3jMdDG1L84geIUJloUJCSIjn
X-Proofpoint-ORIG-GUID: iAiE7nLz3jMdDG1L84geIUJloUJCSIjn
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 clxscore=1030 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=277
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212070029
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/12/2022 11:55, Ping-Ke Shih wrote:
>
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Wednesday, December 7, 2022 11:51 AM
>> To: Ping-Ke Shih <pkshih@realtek.com>; Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>
>> On 07/12/2022 11:43, Ping-Ke Shih wrote:
>>>> -----Original Message-----
>>>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>>>> Sent: Wednesday, December 7, 2022 11:39 AM
>>>> To: Jes.Sorensen@gmail.com
>>>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>>>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>>>> <JunASAKA@zzy040330.moe>; Ping-Ke Shih <pkshih@realtek.com>
>>>> Subject: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>>>
>>>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>>>> issues for rtl8192eu chips by replacing the arguments with
>>>> the ones in the updated official driver as shown below.
>>>> 1. https://github.com/Mange/rtl8192eu-linux-driver
>>>> 2. vendor driver version: 5.6.4
>>>>
>>>> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>>>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>>>> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
>>>> ---
>>>> v5:
>>>>    - no modification.
>>> Then, why do you need v5?
>> Well,  I just want to add the "Reviewed-By" line to the commit message.
>> Sorry for the noise if there is no need to do that.
>>
> No need to add "Reviewed-By". Kalle will add it when this patch gets merged.
>
> Ping-Ke
>
Oh, I see. Sorry for bothering you.
