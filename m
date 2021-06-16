Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFEF3A91C2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhFPGT2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 02:19:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7451 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhFPGT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:19:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4Zdq2jVYzZhqL;
        Wed, 16 Jun 2021 14:14:23 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:17:18 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:17:18 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Wed, 16 Jun 2021 14:17:18 +0800
From:   liweihang <liweihang@huawei.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>,
        "quentin.schulz@bootlin.com" <quentin.schulz@bootlin.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Topic: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Index: AQHXXoyj+/PMfnJFTUeRrSlQbtB9Kw==
Date:   Wed, 16 Jun 2021 06:17:18 +0000
Message-ID: <fae9811cf0404034b0da9d14fb088df1@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-9-git-send-email-liweihang@huawei.com>
 <7c07e865cfeb467c8f6a9eca218c5fdf@AcuMS.aculab.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.100.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/14 22:28, David Laight wrote:
> From: Weihang Li
>> Sent: 11 June 2021 07:37
>>
>> Prefer __packed over __attribute__((__packed__)).
>>
>> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/net/phy/mscc/mscc_ptp.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
>> index da34653..01f78b4 100644
> ...
>>  /* Represents an entry in the timestamping FIFO */
>>  struct vsc85xx_ts_fifo {
>>  	u32 ns;
>>  	u64 secs:48;
>>  	u8 sig[16];
>> -} __attribute__((__packed__));
>> +} __packed;
> 
> Hmmmm I'd take some convincing that 'u64 secs:48' is anything
> other than 'implementation defined'.
> So using it to map a hardware structure seems wrong.
> 
> If this does map a hardware structure it ought to have
> 'endianness' annotations.
> If it doesn't then why the bitfield and why packed?
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 

Hi David,

Thank you for your attention. You are right, I found the contents of structure
vsc85xx_ts_fifo is got from hardware. But I'm not sure if any issues or warnings
will be introduced into this driver after just changing 'u64 secs:48' to '__be64
secs:48'.

Let's keep this patch as it is. I cc the developers of the code, maybe they
didn't realize it or had some reasons to define it like that.

Thanks
Weihang
