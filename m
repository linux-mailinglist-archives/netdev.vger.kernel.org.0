Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592D743B223
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhJZMUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:20:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29939 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhJZMUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:20:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HdrLh3x9dzbnFt;
        Tue, 26 Oct 2021 20:13:00 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 20:17:38 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 20:17:37 +0800
Subject: Re: [PATCH net] usbnet: fix error return code in usbnet_probe()
To:     Johan Hovold <johan@kernel.org>
CC:     <oneukum@suse.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211026112526.2878177-1-wanghai38@huawei.com>
 <YXfsclAOm8Zhbac1@hovoldconsulting.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <f7eec28b-1e4a-c03b-3503-39efff9d45ff@huawei.com>
Date:   Tue, 26 Oct 2021 20:17:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YXfsclAOm8Zhbac1@hovoldconsulting.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/10/26 19:54, Johan Hovold Ð´µÀ:
> On Tue, Oct 26, 2021 at 07:25:26PM +0800, Wang Hai wrote:
>> Return error code if usb_maxpacket() returns 0 in usbnet_probe().
>>
>> Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
> Good catch. This is embarrassing. I double checked the error path but
> failed to notice the missing return value.
>
>>   drivers/net/usb/usbnet.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>> index 80432ee0ce69..fb5bf7d36d50 100644
>> --- a/drivers/net/usb/usbnet.c
>> +++ b/drivers/net/usb/usbnet.c
>> @@ -1790,6 +1790,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>>   	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
>>   	if (dev->maxpacket == 0) {
>>   		/* that is a broken device */
>> +		status = -EINVAL;
> But please use -ENODEV here. -EINVAL is typically reserved for bad user
> input.
Ok, I will send v2
>>   		goto out4;
>>   	}
> Johan
> .
>
-- 
Wang Hai

