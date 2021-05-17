Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4238252C
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhEQHSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 03:18:34 -0400
Received: from mail-eopbgr00095.outbound.protection.outlook.com ([40.107.0.95]:28487
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231668AbhEQHSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 03:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jbt7eTwLz+Oadmlr6MhqZV+Ao3lgD2PqXx1Be5qwplV6yUxNw2RtGNz6wJ0S7oqJkUBJVmpyEURmNPjEYz8GLzC0QMqDrZw7bLeoTxLIXYQFt5f90M3alj13xKXzvh5Hsg6kuq4QXQpvjAU0uvdiuXRqqOniAcjCo4CKsTHZ4rp8qicR4BrDLeMWdDioaBAv7L+x6LahPn6YK8T4B18IlkSbcp9NhJZcG/As9f7uwGzJwvfvNs69Uh5XPtZviOaCGr35PRvIzlcVIazmJwvrLe3JQaTMDuLmAJGK3nA2VpnLhlGoUmjiRKYS9c+SP/e1q2zZvQSBBzR1oEuoEiN2gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh8fQoYQT8bUAwK86WISLH1evF7hI5IMqUzNjiNz1LQ=;
 b=W0qIr7aQMPjNwhcbAlEmjRkqVdqyfyDKqRFWaCq8M1Iv4N6I2KrkgBvztAKULELCmNIuhq0FC+MiNVhdI+1fqeUYezDuIYpx5nbB7jAh4cfJS5lqEpbJ1I1wmr2xw2zGN+ITB5FWjytlv6eGLjM31cDjI7jySA9MCFTr1xHHL3pXkpmusn4VOOLW1GLxPjGpvPa5wpOQ2tU/QB3GVI6+lkRn7tBblWLNMBSGTV6pulbzxU1Td/CnBdCftA4UqARAfYDdGuUg+y3JJgU77zTYCh6YYx4CrGiqfPZzMXna+RLjbff4OXh/YVPmERAJngqpUgf/qKTB2px1VSCG/ZA7LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh8fQoYQT8bUAwK86WISLH1evF7hI5IMqUzNjiNz1LQ=;
 b=k+O78QkjL0fOZ9QweMP3CZOPpUkx63ePnhSwM/9VAANZjFV8GKQBn7Bqi6Hzp3kuHJMpNV66sFUp1WrZrQ7WQy1USkA+9KrsoJ4Cdq2DIQ+QiZyBlltQs4/s0J45HrZwvFbrzjxbGzF4uQoFTV0SmrIHkq4Im01sVuqDFCcDbWE=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM8PR10MB4627.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:365::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 07:17:14 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 07:17:14 +0000
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67958B0138DDDDEAD20949FAE6519@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <494cd993-aa45-ff11-8d76-f2233fcf7295@kontron.de>
Date:   Mon, 17 May 2021 09:17:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <DB8PR04MB67958B0138DDDDEAD20949FAE6519@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [109.250.142.188]
X-ClientProxiedBy: FR3P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::13) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.17] (109.250.142.188) by FR3P281CA0032.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Mon, 17 May 2021 07:17:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a6ac8f7-5b38-484e-a8c3-08d91903cbf5
X-MS-TrafficTypeDiagnostic: AM8PR10MB4627:
X-Microsoft-Antispam-PRVS: <AM8PR10MB46275D0174A398180431A49BE92D9@AM8PR10MB4627.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJH29PhA0YoNMwWwrq3kuiECnjJzgKURcl7wcrv9wcmBqR9feGEVvMkeZ0o1CFHhvTLmUmLVvwMQ8fpxmOLHtLT5uPsZE8Jmg2Y/P7mV1pPWTQ0XMBGNhXHgAG08bYW6C8cDUOFI43Vgw1o/oY13WShJU+kAAdbwueOq84Ir/Gw/otyLo3LgGLGdXjGyQBvK4f0uXF+MWWAAQrNfPDLLoL771k69wkn1S7eOKB4YtVrCctvjRwtDT8oOL15rolVGlgoFjdLnC2n1FlduJoUp07tNG0OmIzKNl2ZwiOoJeeM54xxabW8DXeovadEy7QOycE48HMu/1cTVItFUlYq5KHVhnc5rAo6LbbUtKNbFSnWtfJrlfUbYvmwZb7Bsdgo07Knem/MLduZyIdRdv7PluW3L3dorZFUD5zVxXXcm7sJbzJdd1RzdXwnSDv1s0ztBqvcsF+bAeXxkjf/yH1+QrwwC1ayj3chWeBf9xhANanvmks3wJRFHZbVEvDLYn0EoEpYS18V0+p2ApMzmT7OJiHnVgYOcVex0c0NR3/VGLxIrFxa735mEi1Xb4jLyXZgHfB26z/kSm83pF/wZTSUq9JAPVdU4Q4Y5KBB0z3btEHQYUh3KXYBQdP6PJFzR/4HOl5q5SKO1xOddXDFcyp95V3D8BJFhq9FUMaBvy+mZeSjIKN2vw1n9Ol6Z5eKihfRYUFmRRwybm/1spPtVqz0GyZ0zQ0UfyPcSc9AoJov3PNHUyegLOBDhj8VVYB6mcusGFUNigSaNRui3mQayTs5b25Y05DXl6l/QCv7r5VmBBFan+Y/Xab9M96fHLeC/zgxl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(53546011)(316002)(83380400001)(66556008)(16576012)(66476007)(6486002)(2906002)(16526019)(31696002)(38100700002)(478600001)(110136005)(86362001)(66946007)(36756003)(2616005)(956004)(5660300002)(8676002)(44832011)(966005)(26005)(186003)(31686004)(8936002)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?T0VjWklCN3hGa1JyQlF5THhKcWxuNFYwZHg2U1dNMWV0TWdLbDUzR3A3dUZp?=
 =?gb2312?B?UGlPOHRaT2FhQWxlQmQ0RFF2aUo2MlRvMTU0eGlScnBMTS9PNVd0bHc1WXJE?=
 =?gb2312?B?dVRheDBtSzZIZDJ1dXdlYitGb1BWMC9meFU2dEcxaTdxRndkUE1DcDFkM1hL?=
 =?gb2312?B?K3hpVXhXdmZld1g0T0ZJck00T0dreCtZS1pMKys0UTJMa255ck1aeU13M0Zu?=
 =?gb2312?B?NERjSkkrUThqODA4UjdHR0o1czF5cnB4NzgyMEo2dEI2dmQ1WXlHL3hUMUYr?=
 =?gb2312?B?MTdOeklKRkw2U2tpL1Zjc2lXN2Z2L0NoL0NwM05ReEp6YlVCTFpsWjFIRzMx?=
 =?gb2312?B?elJEM1I2a0pIa3hFcFQ4aExZWjBhSk9LREM1aHV4TkUxbmFIY2QxZ3RraFVZ?=
 =?gb2312?B?b1J2RnBsdXFuUUM3MjBwaFJFWnRReW93clFFNXlqdnlha0FaOHQ0NWpDWkJR?=
 =?gb2312?B?UytWMTV0REZTbnd4ZFhnWkY2RTR3QXdKU2ZBVGVnaEdKRU96VGRNbzFxak8z?=
 =?gb2312?B?d1BhZWxna05IY2RkTnRTZGZHOHExUXpzbm1ZMVowVEhuWTdOY2N2dVk0UlZn?=
 =?gb2312?B?MWJ0bEtUUmNCQjlHM2xNZUVENzNTRitEUGZwbHV1YzVjQXBzY1EzZnVyZ051?=
 =?gb2312?B?TTBmbE8vZjJnWWcwTlJldmVXTHNCV1NTdmZzdXlvQmkwdEVJaTMzNlNFN2M3?=
 =?gb2312?B?eXFDSVlKVG8zOGZUN2VlWHBKYTd3T1dhc0V0dWhuK2l4Rkd4QlFxZG9nMGlt?=
 =?gb2312?B?Q2RFb09leFRsYk03endtcnR5cm51R0Jhb2JjQlp0RkRPL1NSdFRsd0hzMlYv?=
 =?gb2312?B?TUFzb0lSeCtKMHBFUTE0d1lOZzM0c1B5Qk9BMkVoL2hWcWxKSkFod1hFOUFt?=
 =?gb2312?B?MzhUY1FkblZITTFmNmRhM2d2MldwREd0Lzc4NzgwNVV1WEozMEZQU25ncGF1?=
 =?gb2312?B?U0p6MHFRNkxOejhBWERGN1Bua3lWc3hLT1g2aTFaUTJwSzJFdEpMU0VrWW1l?=
 =?gb2312?B?ZW80TlBSUktDYUcwZXBNYkIzWjBmSmg0cURqU2Vqa1pxcEVkdEQ5K3grRjJ4?=
 =?gb2312?B?Q21JQ3JScm1DdU15VlF0bmVtSThDQlFUeXNkQ253ekhPU1ZZdFBVNDgwYTQv?=
 =?gb2312?B?VVZCMDJQZDdjcEQ0KzlZYzdocnN1NlJUOHMwM256cFNQMTdWNm1GM1pHSXdn?=
 =?gb2312?B?N0ZpZll3TlVodmJyTkY1dVM5S3VWdURMdnBzWklKdDJYRVJ4VFpoSkoxVHBH?=
 =?gb2312?B?K0l0bEhNbmVGNGhBSXlqZGx4Q1l5Y3BrZ1BVM0RITkxJRkZ4V3ZlQ0pwYm91?=
 =?gb2312?B?L0k1SlVoaVIrRGdvTTJKNW5SM1BLMFJBTC9WYmlPNnF1NXBESEJPd0xvbE5Z?=
 =?gb2312?B?L0FEYlB6ellqakN2N0VlamZDSUxMN1ZmVVFuNnk3T21nMnRTbnpvdFVrZW1i?=
 =?gb2312?B?NC9wSTNkR3dkZEt0bXhmemxCdTlPekVXL2tORGpDbGVZT0gyck16bmFETkw5?=
 =?gb2312?B?bFRVRUUvZjl2eFMxVlViaUxhYXhYSGR5OXVTM0c4SGVpeWpkakJyZllBMDFa?=
 =?gb2312?B?Qk8vOHBsSFZ6UTVLK1l0SGM5WFArcHZ2YlNtUDBlTW9PQjhJMVVDbXZVcjdm?=
 =?gb2312?B?RkNTN2F4amVleHVxc0J6Q2tUSzI5UE5YU2hNR3VjSHFLRFdqbEJXVGlLdmVW?=
 =?gb2312?B?dmJwNU1NaVo2Z2dvQnZjRWtPeUphK0ZZWk96NUJBcnJmaVNvbTlwQXEzejRB?=
 =?gb2312?Q?naLNxFa62K+RXbEo3kwxPZeiVr8v+vhWNzqvY7/?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6ac8f7-5b38-484e-a8c3-08d91903cbf5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 07:17:14.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXNM3axvyuBuOq9QGmNkhTqy8O8ddfLLtb8eK5k4epS89i3UwnvUaVjBdFScSnDD7T222aYP9K+JAVxJEDJGvhlqclNdYffEXvrfV/BteX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On 13.05.21 14:36, Joakim Zhang wrote:
> 
> Hi Frieder,
> 
> For NXP release kernel, I tested on i.MX8MQ/MM/MP, I can reproduce on L5.10, and can't reproduce on L5.4.
> According to your description, you can reproduce this issue both L5.4 and L5.10? So I need confirm with you.

Thanks for looking into this. I could reproduce this on 5.4 and 5.10 but both kernels were official mainline kernels and **not** from the linux-imx downstream tree.

Maybe there is some problem in the mainline tree and it got included in the NXP release kernel starting from L5.10?

Best regards
Frieder

> 
> Best Regards,
> Joakim Zhang
> 
>> -----Original Message-----
>> From: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Sent: 2021年5月12日 19:59
>> To: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org
>> Subject: RE: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>
>>
>> Hi Frieder,
>>
>> Sorry, I missed this mail before, I can reproduce this issue at my side, I will try
>> my best to look into this issue.
>>
>> Best Regards,
>> Joakim Zhang
>>
>>> -----Original Message-----
>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>> Sent: 2021年5月6日 22:46
>>> To: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>> linux-arm-kernel@lists.infradead.org
>>> Subject: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>
>>> Hi,
>>>
>>> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini
>>> boards. It happens quite often that the measured bandwidth in TX
>>> direction drops from its expected/nominal value to something like 50%
>>> (for 100M) or ~67% (for 1G) connections.
>>>
>>> So far we reproduced this with two different hardware designs using
>>> two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different
>>> kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
>>>
>>> To measure the throughput we simply run iperf3 on the target (with a
>>> short p2p connection to the host PC) like this:
>>>
>>> 	iperf3 -c 192.168.1.10 --bidir
>>>
>>> But even something more simple like this can be used to get the info
>>> (with 'nc -l -p 1122 > /dev/null' running on the host):
>>>
>>> 	dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>>>
>>> The results fluctuate between each test run and are sometimes 'good' (e.g.
>>> ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M
>> link).
>>> There is nothing else running on the system in parallel. Some more
>>> info is also available in this post: [1].
>>>
>>> If there's anyone around who has an idea on what might be the reason
>>> for this, please let me know!
>>> Or maybe someone would be willing to do a quick test on his own hardware.
>>> That would also be highly appreciated!
>>>
>>> Thanks and best regards
>>> Frieder
>>>
>>> [1]:
>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fcomm
>>> u
>>>
>> nity.nxp.com%2Ft5%2Fi-MX-Processors%2Fi-MX8MM-Ethernet-TX-Bandwidth-
>>>
>> Fluctuations%2Fm-p%2F1242467%23M170563&amp;data=04%7C01%7Cqiang
>>>
>> qing.zhang%40nxp.com%7C5d4866d4565e4cbc36a008d9109da0ff%7C686ea1d
>>>
>> 3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637559091463792932%7CUnkno
>>>
>> wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
>>>
>> WwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ygcThQOLIzp0lzhXacRLjSjnjm1FEj
>>> YSxakXwZtxde8%3D&amp;reserved=0
