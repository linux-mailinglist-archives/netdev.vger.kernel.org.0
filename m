Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CEC11616B
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 11:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLHKr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 05:47:59 -0500
Received: from first.geanix.com ([116.203.34.67]:57442 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfLHKr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 05:47:59 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 204BB3A5;
        Sun,  8 Dec 2019 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575802062; bh=8JJ2WWNtIyjqJWE2jFzKqze80hNlWeVD7m4N5/Zmsp0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ADiubZ8GlcAy1iCs1TiQZMFSkvIL93Tp8V9NNiXYiFSOOVc0+DQzK9qRnN7ks81tf
         SmxxTU6yR4O945pp0i8I2ysVBcHQYE6jGY7oV01rnK2vl/33fu6ImuMUONnujCugHs
         pfexBtooG2vKhi57ume3nJlev2AQuLCMauutWXJFaVvqtbNHseHzuJ9F7toXwpomQr
         0bH6Jp77EbWBo2Tat5fRnSKMI8mZGu9a9ZUf3uy4+TAXcFAEr796mKK9VDa11peflS
         TOXa5xlG5OmZP/AtXL4K6x78WCTYHwL5ol7LVrdjJ+QSiFAXU8ELKTMH1gyiYLOcIy
         G4qaihxayxIpQ==
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
 <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
 <DB7PR04MB46184164EAC5719BDCF3822CE65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <e7bef254-9762-0b77-1ace-2040113982ec@geanix.com>
 <DB7PR04MB461820120FF61E08B8B5B0B5E65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <3a4102bc-8a86-3425-e227-590c005df044@geanix.com>
 <2c8f83aa-e7e6-ba15-1e42-2cb834da1c48@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <cdf11f66-92f5-7431-9e76-6a5c92eb4d91@geanix.com>
Date:   Sun, 8 Dec 2019 11:47:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2c8f83aa-e7e6-ba15-1e42-2cb834da1c48@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/12/2019 21.32, Marc Kleine-Budde wrote:
> On 12/5/19 12:32 PM, Sean Nyekjaer wrote:
>>> If yes, I think we don't need check stop mode in probe stage, since
>>> issue has disappeared automatically.
>>
>> If one have devices deployed where:
>> "can: flexcan: fix deadlock when using self wakeup" isn't applied.
>> They could have devices stuck in stop-mode.
> 
> Ok.
> 
> But both patches:
> 
>      can: flexcan: fix deadlock when using self wakeup
>      can: flexcan: try to exit stop mode during probe stage
> 
> are not yet mainline, so if "can: flexcan: fix deadlock when using self
> wakeup" fixes the problem and goes into stable we don't need "can:
> flexcan: try to exit stop mode during probe stage", right?
> 
>> That's what i meant by this patch doesn't do any harm to have the check
>> included.
> 
> I don't want to have code in the driver that serves no purpose.
> 

Fine with me, I'm continuing to have the patch included in my tree until 
all devices are upgraded with:
	can: flexcan: fix deadlock when using self wakeup

/Sean

> regards,
> Marc
> 
