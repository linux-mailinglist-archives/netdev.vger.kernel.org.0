Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371011E5733
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgE1GDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:03:34 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6144
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725859AbgE1GDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 02:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwPi9gbVpm7e84GhW0LvBDMV3a/gwoDBAqw5LgoGuN8P9bswpXVgpsczJ05hcrrOyGyLK9yEbMOuZ9V6Wog6/kLi5oziW0YhNV6CGUGWfbCen4R2KmIaPQUnQknoPNKqeDzq8D7sZy3ibPGVsj91HKWHemBSvVWsDJm51YaUw4TSPOwIzbsJ7/U3xF8MpL82w4YuECCNrifAWYTJ/bCjUYZBWQxVhamQ4voOjr095mbmnrkTviGRMtGFNl8eji+ZzJYbcrjMM+ajGv5BB9Cqd4SRexeQQDf6/CCi8OcX9F4IBa9+uj6artY7w7KW9iLQt/nP1XObS60S/HqsUHwJrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0GH7pCsDCaFwhEmbHVsHnjlj8a5dXB8E0Z+IzPnyrQ=;
 b=DzuMlfCWBYOG+JRDYiHYEwqOyDBhMeIxAeA2VbV2Gnmui51JR/EnP7oWmel/EgmDW5YWHgCqwu7mVfh89y84jNm4SQTl5Z1Dbh1fdxQ5Kn8Mh0rdNsEute6LAMNd9W3ThgNv3NL2DL0nQfiuFMgpmcanDZthpZpLV/BreCloaTR3r4xp4YU8zsVPV+JiXomDzyVe5BCxNzwB2/FiMJEM4KR5kjP4ViGvtZxjyar9sL8dOtUlrnXht+2dGwfx9/70trnjtxRqVxZ2awUm4WsM7Ye4QIdM2iDOFdowHdL4gHNtK4IG45R5Ecatkj8Z11E0xzTuj4CXy/v92OD+7d/Lcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0GH7pCsDCaFwhEmbHVsHnjlj8a5dXB8E0Z+IzPnyrQ=;
 b=N390yqfe28fFJxiMtK3xvawvox2NIBSq0hUjbu4penjUW97zur2gI+26H/uBPaz1xDNgLIlDmL7M56XUF7YzHwUfN04Jd2ydA9P662LclIsKPluWitoCINOj3O4oZdeJ/vf3FZvTt1H17M9yAdYds5KyvguCbsk4jT2vWGfns1U=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB6824.eurprd05.prod.outlook.com (2603:10a6:20b:131::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 06:03:29 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f%8]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 06:03:29 +0000
Subject: Re: [PATCH net] net/tls: Fix driver request resync
To:     Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
References: <20200520151408.8080-1-tariqt@mellanox.com>
 <20200520133428.786bd4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <6d488bcb-48ac-f084-069e-1b29d0088c07@mellanox.com>
Date:   Thu, 28 May 2020 09:03:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200520133428.786bd4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20)
 To AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 06:03:28 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b706ff3b-9c86-4904-7c09-08d802ccd80f
X-MS-TrafficTypeDiagnostic: AM7PR05MB6824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6824750C0F21F4266879D685B08E0@AM7PR05MB6824.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zd+nISJVkdCaPNcxFBlc2DxOVd/2kgVvFF8YAQtIwgrb8eLZp+bjp0QPEpiH3MnIbdzkLWs6rxNBT1qzrtp3/C7xAjeRgFjdyGmPidl5mlE4Qo8hTSgHPx+vyVWBTxfHpwSTK2v9B3pOQuo13z+xu2gJg671hiRL99RZF9ba2Oe03+2GvP1AET0jYKSKeY4XxbBhseIwvtDCG4JZI2cSzi4hKu4YIKUS6JGkYpgjFBgpI6FmjdooTq6PcVsQ0XvKTCPXc+AjyMWE6DUxGJyx/ZjRyMKQPMzw8ZZ7oiTKOFq/K/mD36SfY4FYLWK2CYG2ITY4/bu0kZkJsV0ZQoxduIr1qEZCQZS832UiDasggDRhxgKkfcaSghFvxNOUkNTI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(186003)(16526019)(31686004)(53546011)(8676002)(107886003)(8936002)(86362001)(2906002)(316002)(6486002)(31696002)(4326008)(6636002)(16576012)(110136005)(54906003)(6666004)(52116002)(26005)(83380400001)(478600001)(36756003)(5660300002)(66556008)(2616005)(66476007)(66946007)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +HXjZpuA1+2+y6rt2d+zSuZcE0ulFTyaLh8B53UXFX5xaPvLtoM/a84EgrJwGeojf+5sIVyUeim/Wj/xhBmenTNVngP36Hi7M0F2iGY80h41NzzoIxqemrnc/zgPWe3RfeW0LsVLHXjyi5SW/TcC0ceQTJqjp4cZsRygAfWsqnn0nYFxtxW3IosdZG/S8KUwp1flNRdSweGjfFXkhrITLmlq6NDitMKLTTGMcmXMZDWT2L7LCHWQBZxrE3MLOFFa4xs5k1EKJY0YN2L4M7RG0BCnrzMlKReJtefCYyDNevMtzEAXQxEwueboYSs0CW8Lg6My+G0G0fSXUHnnx/ApOfwg75zQ5fsrYQRnoAqOkch5u0CTBISMe8qcIF4TzaV0X5QqIelnEx/wjOjxqsDk4RLLWg5eRH2QP1wTkiy2heO6tIs++dnXqWt5JYjjHQdnFSyR+qiAgx9cEG8M5gjjv4D7qOHmsHgzPvbXlBOGd0ztC9VlHOKhOgu/blwUiqEi
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b706ff3b-9c86-4904-7c09-08d802ccd80f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 06:03:29.5358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgmnwKMidTPJM1tuvOepwoJ+bGvbkLlJUqbUNGheRjUN0c22NuCfdDF16GZq50zFgofSgoBVbldtGKDeBGIf8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/05/2020 23:34, Jakub Kicinski wrote:
> On Wed, 20 May 2020 18:14:08 +0300 Tariq Toukan wrote:
>> From: Boris Pismenny <borisp@mellanox.com>
>>
>> In driver request resync, the hardware requests a resynchronization
>> request at some TCP sequence number. If that TCP sequence number does
>> not point to a TLS record header, then the resync attempt has failed.
>>
>> Failed resync should reset the resync request to avoid spurious resyncs
>> after the TCP sequence number has wrapped around.
>>
>> Fix this by resetting the resync request when the TLS record header
>> sequence number is not before the requested sequence number.
>> As a result, drivers may be called with a sequence number that is not
>> equal to the requested sequence number.
>>
>> Fixes: f953d33ba122 ("net/tls: add kernel-driven TLS RX resync")
>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>> ---
>>  net/tls/tls_device.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index a562ebaaa33c..cbb13001b4a9 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -714,7 +714,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
>>  		seq += TLS_HEADER_SIZE - 1;
>>  		is_req_pending = resync_req;
>>  
>> -		if (likely(!is_req_pending) || req_seq != seq ||
>> +		if (likely(!is_req_pending) || before(seq, req_seq) ||
> So the kernel is going to send the sync message to the device with at
> sequence number the device never asked about? 

Yes, although I would phrase it differently: the kernel would indicate to the driver,
that the resync request is wrong, and that it can go back to searching for a header.
If there are any drivers that need an extra check, then we can add it in the driver itself.

>
> Kernel usually can't guarantee that the notification will happen,
> (memory allocation errors, etc.) so the device needs to do the
> restarting itself. The notification should not be necessary.
>

Usually, all is best effort, but in principle, reliability should be guaranteed by higher layers to simplify the design.
On the one hand, resync depends on packet arrival, which may take a while, and implementing different heuristics in each driver to timeout is complex.
On the other hand, assuming the user reads the record data eventually, ktls will be able to deliver the resync request, so implementing this in the tls layer is simple.

In this case, I see no reason for the tls layer to fail --- did you have a specific flow in mind?
AFAICT, there are no memory allocation/error flows that will prevent the driver to receive a resync without an error on the socket (bad tls header).
If tls received the header, then the driver will receive the resync call, and it will take responsibility for reliably delivering it to HW.

Boris
