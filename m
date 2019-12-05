Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91F3113DB2
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfLEJVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:21:39 -0500
Received: from first.geanix.com ([116.203.34.67]:54610 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfLEJVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 04:21:38 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 939D5270;
        Thu,  5 Dec 2019 09:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575537694; bh=tB9aZZpuOVnbm6VcKYyMzI82WOA403rLw2lY36HOyWE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jurS4YIS8UzRj591FbNotRklfD+QJnJ1JS1cvDR6zLjR7QVU8AEM1pwXcuumfGSZA
         AcgD1f+2D9E62EEsuePdKRi1Yki9mj9ypTEJyNz4jpLllJwpgjS78BfFSqvTWf5u0k
         D8S/eVqY2hCnQQTQTfniTBOsMTM9DHlMnvmCY9QLV/mtTuDN1Dk3ZJdsVyK0M8NlTd
         yjOxNIaJxP5x9Npt7ELTPo/E0mU5dK8AdMag++WeUu9R9NqOs/ULKOyIOQb3H8VTU+
         gUVlexEhuWmiZ9VuiT8b4kZGyXO+zad+cvNLM067tAmEFeWBSi9edm2Ax4KTm4cB8c
         wjQ98b+4iQ/kg==
Subject: Re: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
Date:   Thu, 5 Dec 2019 10:21:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
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



On 04/12/2019 09.45, Marc Kleine-Budde wrote:
> On 12/4/19 3:22 AM, Joakim Zhang wrote:
>>
>>> -----Original Message-----
>>> From: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Sent: 2019年12月4日 2:15
>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; sean@geanix.com;
>>> linux-can@vger.kernel.org
>>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org
>>> Subject: Re: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
>>> stage
>>>
>>> On 11/27/19 6:56 AM, Joakim Zhang wrote:
>>>> CAN controller could be stucked in stop mode once it enters stop mode
>>>                            ^^^^^^^ stuck
>>>> when suspend, and then it fails to exit stop mode when resume.
>>>
>>> How can this happen?
>>
>> I am also confused how can this happen, as I asked Sean, only CAN
>> enter stop mode when suspend, then system hang,
> How do you recover the system when suspended?
> 
>> it could let CAN
>> stuck in stop mode. However, Sean said this indeed happen at his
>> side, @sean@geanix.com, could you explain how this happen in
>> details?
> That would be good.
> 
>>>> Only code reset can get CAN out of stop mode,
>>>
>>> What is "code reset"?
>>
>> As I know, "code reset" is to press the POWER KEY from the board. At
>> my side, reboot command from OS also can get CAN out of stop mode.
> Do you mean "cold reset", also known as Power-On-Reset, POR or power cycle?
> 
> What does pressing the POWER KEY do? A power cycle of the system or
> toggling the reset line of the imx?
> 
> We need to describe in detail, as not everyone has the same board as
> you, and these boards might not even have a power key :)
> 
>> Below is experiment I did:
>> 	Firstly, do a hacking to let CAN stuck into stop mode, then:
> 
> You mean you put the CAN into stop mode without keeping track in the CAN
> driver that the CAN-IP is in stop mode, e.g. by hacking the driver.
> 
> Then you try several methods to recover:
> 
>> 	(1) press power on/off key, get CAN out of stop mode;
>> 	(2) reboot command from console, get CAN out of stop mode;
>> 	(3) unbind/bind driver, cannot get CAN out of stop mode;
>> 	(4) remod/insmod module, cannot get CAN out of stop mode;
> 
> (2) resets the complete imx, including the CAN-IP core, (1) probably, too.
No, if the CAN-IP core is in stop-mode it will stay that way even after 
a reboot from the console.
At least it's what we are seeing in the field.

This could be because we are missing a wire from the watchdog out to the 
RESETBMCU/PWRON on the PMIC.
But i guess a check for if the CAN-Ip is in stop-mode doesn't hurt 
anything :)

/Sean
