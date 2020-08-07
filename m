Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE823EA76
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHGJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:36:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9352 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgHGJgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 05:36:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 43F3866F4F5373A0D409;
        Fri,  7 Aug 2020 17:36:44 +0800 (CST)
Received: from [10.174.179.72] (10.174.179.72) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 7 Aug 2020 17:36:39 +0800
Subject: Re: [PATCH net 0/4] support multipacket broadcast message
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>
References: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
 <20200806161027.py5ged3a23xpmxgi@pengutronix.de>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <24c3daa5-8243-0b80-9f4c-aa5883cb75da@huawei.com>
Date:   Fri, 7 Aug 2020 17:36:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806161027.py5ged3a23xpmxgi@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.72]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

We have tested this j1939 stack according to SAE J1939-21. It works fine for
most cases, but when we test multipacket broadcast message function we found
the receiver can't receive those packets.

You can reproduce on CAN bus or vcan, for vcan case use cangw to connect vcan0
and vcan1:
sudo cangw -A -s vcan0 -d vcan1 -e
sudo cangw -A -s vcan1 -d vcan0 -e

To reproduce it use following commands:
testj1939 -B -r vcan1:0x90 &
testj1939 -B -s20 vcan0:0x80 :,0x12300

Besides, candump receives correct packets while testj1939 receives nothing.

Regards,
Zhang Changzhong

On 2020/8/7 0:10, Oleksij Rempel wrote:
> Hello,
> 
> Thank you for your patches! Currently I'm busy, but I'll take a look at it as
> soon possible.
> 
> btw. can you tell me about more of your use case/work. I would like to
> have some feedback about this stack. You can write a personal message,
> if it is not for public.
> 
> On Wed, Aug 05, 2020 at 11:50:21AM +0800, Zhang Changzhong wrote:
>> Zhang Changzhong (4):
>>   can: j1939: fix support for multipacket broadcast message
>>   can: j1939: cancel rxtimer on multipacket broadcast session complete
>>   can: j1939: abort multipacket broadcast session when timeout occurs
>>   can: j1939: add rxtimer for multipacket broadcast session
>>
>>  net/can/j1939/transport.c | 48 +++++++++++++++++++++++++++++++++++------------
>>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> Regards,
> Oleksij
> 
