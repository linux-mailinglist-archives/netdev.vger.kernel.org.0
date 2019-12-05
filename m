Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC29114027
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 12:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLELca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 06:32:30 -0500
Received: from first.geanix.com ([116.203.34.67]:36216 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbfLELca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 06:32:30 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id BA429378;
        Thu,  5 Dec 2019 11:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575545546; bh=wMxZmNxsosLnmhaJ4IotGzJVo81drt1nz897yLHZcag=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Pr//vjJHUaATVEBS7brHtlkbwZQrMrbk2QuA9rHoAy0ezps/PktgE1+eFkdMH6FOA
         MV4T+0paXPqoOaFDfZPH84677t92+f0YoSbNnBKFIjjTjGK4yN4Gaepjw5fPBmwEec
         Qfy5Cf5nB99T5CRY9HfIF0PLd20JfN9vQwBCwa/zhKoBXTD8eCM7A8xRUnAgCtm4Qo
         fjZ6u2RxVFT1zhhk2PV/nhywYJH6o0XeaHMm1rpNGkfjXdNk/eCUhsrm70kGgwZYSE
         E4R+qx0n4O+D7SDTOJXmZ/LP62aqGRM0JK6jV9v32hv4yN1NRvxhiS/jjsuBhR49xH
         h91ZEFfD1ejUA==
Subject: Re: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
 <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
 <DB7PR04MB46184164EAC5719BDCF3822CE65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <e7bef254-9762-0b77-1ace-2040113982ec@geanix.com>
 <DB7PR04MB461820120FF61E08B8B5B0B5E65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <3a4102bc-8a86-3425-e227-590c005df044@geanix.com>
Date:   Thu, 5 Dec 2019 12:32:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB461820120FF61E08B8B5B0B5E65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/12/2019 12.19, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Sean Nyekjaer <sean@geanix.com>
>> Sent: 2019年12月5日 19:12
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Marc Kleine-Budde
>> <mkl@pengutronix.de>; linux-can@vger.kernel.org
>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org
>> Subject: Re: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
>> stage
>>
>>
>>
>> On 05/12/2019 12.04, Joakim Zhang wrote:
>>> Hi Sean,
>>>
>>> At my side, both Power-On-Reset and reboot from console can get CAN-IP out
>> of stop mode, HW is i.MX7D-SDB/i.MX8QXP-mek.
>>> I think HW design could make difference.
>>>
>>> We more care about how does CAN-IP stuck in stop mode, could you please
>> explain in details? We want figure out the root cause.
>>
>> When running only with the first stop mode commit:
>> de3578c198c6 ("can: flexcan: add self wakeup support") And there is incoming
>> traffic on both CAN lines.
>> I happens when going into suspend.
>> Then the CAN-IP is stuck in stop mode..
> 
> That means with below patch then CAN-IP could not been stuck in stop mode, right?
> 	can: flexcan: fix deadlock when using self wakeup
Yes :)
> 
> If yes, I think we don't need check stop mode in probe stage, since issue has disappeared automatically.

If one have devices deployed where:
"can: flexcan: fix deadlock when using self wakeup" isn't applied.
They could have devices stuck in stop-mode.

That's what i meant by this patch doesn't do any harm to have the check 
included.

/Sean
