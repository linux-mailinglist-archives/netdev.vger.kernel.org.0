Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAF3F4BE6
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhHWNxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:53:05 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:64763 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhHWNxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:53:04 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb6123a804ec8-05972; Mon, 23 Aug 2021 21:52:04 +0800 (CST)
X-RM-TRANSID: 2eeb6123a804ec8-05972
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.26.114] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56123a803594-cd5d4;
        Mon, 23 Aug 2021 21:52:04 +0800 (CST)
X-RM-TRANSID: 2ee56123a803594-cd5d4
Subject: Re: [PATCH 3/3] can: mscan: mpc5xxx_can: Useof_device_get_match_data
 to simplify code
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     davem@davemloft.net, wg@grandegger.com, kuba@kernel.org,
        kevinbrace@bracecomputerlab.com, romieu@fr.zoreil.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
 <20210823113338.3568-4-tangbin@cmss.chinamobile.com>
 <20210823123715.j4khoyld5mfl6kdv@pengutronix.de>
From:   tangbin <tangbin@cmss.chinamobile.com>
Message-ID: <eafd35fd-bf71-167a-b1c8-50e3117e4be4@cmss.chinamobile.com>
Date:   Mon, 23 Aug 2021 21:52:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210823123715.j4khoyld5mfl6kdv@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc:

On 2021/8/23 20:37, Marc Kleine-Budde wrote:
> On 23.08.2021 19:33:38, Tang Bin wrote:
>> Retrieve OF match data, it's better and cleaner to use
>> 'of_device_get_match_data' over 'of_match_device'.
>>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Thanks for the patch!
>
> LGTM, comment inside.
>
>> ---
>>   drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
>> index e254e04ae..3b7465acd 100644
>> --- a/drivers/net/can/mscan/mpc5xxx_can.c
>> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
>> @@ -279,7 +279,6 @@ static u32 mpc512x_can_get_clock(struct platform_device *ofdev,
>>   static const struct of_device_id mpc5xxx_can_table[];
>>   static int mpc5xxx_can_probe(struct platform_device *ofdev)
>>   {
>> -	const struct of_device_id *match;
>>   	const struct mpc5xxx_can_data *data;
>>   	struct device_node *np = ofdev->dev.of_node;
>>   	struct net_device *dev;
>> @@ -289,10 +288,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
>>   	int irq, mscan_clksrc = 0;
>>   	int err = -ENOMEM;
>>   
>> -	match = of_match_device(mpc5xxx_can_table, &ofdev->dev);
>> -	if (!match)
>> +	data = of_device_get_match_data(&ofdev->dev);
>> +	if (!data)
>>   		return -EINVAL;
> Please remove the "BUG_ON(!data)", which comes later.

For this place, may I send another patch to fix this 'BUG_ON()' by 
itself, not in this patch series?

Thanks

Tang Bin

>
>> -	data = match->data;
>>   
>>   	base = of_iomap(np, 0);
>>   	if (!base) {
>> -- 
>> 2.20.1.windows.1
>>
>>
>>
>>
> regards,
> Marc
>


