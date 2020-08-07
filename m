Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1423EA5E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHGJcM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Aug 2020 05:32:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:56084 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgHGJcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:32:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-210-SVT2GwbWMVi2mGcbTk0Ssg-1; Fri, 07 Aug 2020 10:32:08 +0100
X-MC-Unique: SVT2GwbWMVi2mGcbTk0Ssg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 7 Aug 2020 10:32:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 7 Aug 2020 10:32:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Luo bin' <luobin9@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "luoxianjun@huawei.com" <luoxianjun@huawei.com>,
        "yin.yinshi@huawei.com" <yin.yinshi@huawei.com>,
        "cloud.wangxiaoyun@huawei.com" <cloud.wangxiaoyun@huawei.com>,
        "chiqijun@huawei.com" <chiqijun@huawei.com>
Subject: RE: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Topic: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Index: AQHWbF+/LM1G8mFmIkykQEWb0Xuu7aksYh5w
Date:   Fri, 7 Aug 2020 09:32:07 +0000
Message-ID: <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
In-Reply-To: <20200807020914.3123-1-luobin9@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin
> Sent: 07 August 2020 03:09
> 
> fix the compile warnings of 'strncpy' output truncated before
> terminating nul copying N bytes from a string of the same length
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
> V0~V1:
> - use the strlen()+1 pattern consistently
> 
>  drivers/net/ethernet/huawei/hinic/hinic_devlink.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index c6adc776f3c8..1ec88ebf81d6 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
> 
>  	level = event->event.chip.err_level;
>  	if (level < FAULT_LEVEL_MAX)
> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);

Have you even considered what that code is actually doing?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

