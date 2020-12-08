Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630672D2571
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLHIN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:13:57 -0500
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:48673
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727512AbgLHIN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 03:13:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llOcEb8FhbkQqmfQpZjShENvI0QFJrlapjKILZgrNPl8mV6kfWVmrVabcHK5wH8lQ88PAbZzTfyi3A/eaqiYru5rMYYGrBKKEeRsapi9ZmhokW6pHo4vttavPOPV7RTUsFdEWXrgAO/d5gI3P94zKhSKZfWjsns1JdPfb8BYGKni0AmUfGU6ayEkygZa3kSHeI1Vu/Id4/sQgpPOwBVCb254eQ6eBiF7y2kaXyWyjexVMVKnY8VXCqNwwYafiOkEzTIWLs6hz2BR9fKeQ6/JyF+PqnNEiDlDolaGMbE7RkwNKKmWHq7+UT1GO5jUAbbGlExwccGopemBNgy+Gdok/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgqCQyHB2xX7B6fiN2jHEfPUyR9Uso5RR2Vf54Uuk6o=;
 b=SZzeXn8VBF2bkVtCu3+U72ZwssKd38rkNYpQxfKukDAQ8pe3aXb2PCmuFH9+FcYb06KpTW1fpPF20sqU64thZeoyVSBK/0b3otwyiTSW9RQX3hYarpKtR0Q/F3EyfdVp+qirU1pKK2aEIKB1S8alKp+APy/qsS6hYfLjnWasPm9sqGQbeq0UBuQ3kIsocsVHCzr4m2X9jsXMQva+3ubkZrkTFNRBa5wHO6NyKPPolnXxwgqZTmQodNdTPfM4HB4aY3UJrMnimvsRiWzaCyoInEYH9X+Q+2FmF5PzbOm2oNSptfb2qsn7zBa6tebBIK0Lo/K6pAaFDUjUQ92QKjBGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgqCQyHB2xX7B6fiN2jHEfPUyR9Uso5RR2Vf54Uuk6o=;
 b=m2Yh6lLoKdmebgWsTEs0pIyhr1AEdyp+Niyeprrhq0n9fyMlQV87vMnLkiRbGx7b8wViG03ZbCkqQ0MbHdvMp0kUEY7xGAh6KvqYoN6CL/Drzt97HWYP4qOUcyScBWW/NfejxSvKpUOnNM7TCiD2KJYOL2F231xNjSJAbWvgulg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3250.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:189::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 08:13:07 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 08:13:07 +0000
Subject: Re: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
To:     Qiang Zhao <qiang.zhao@nxp.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Leo Li <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
 <VE1PR04MB676805F3EEDF86A8BE370F8691CD0@VE1PR04MB6768.eurprd04.prod.outlook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <0ebe1b4d-c22a-c361-89f0-8e6e48efde1b@prevas.dk>
Date:   Tue, 8 Dec 2020 09:13:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VE1PR04MB676805F3EEDF86A8BE370F8691CD0@VE1PR04MB6768.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P192CA0071.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::48) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P192CA0071.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 08:13:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8618fc77-0c8c-4027-6fcf-08d89b5117db
X-MS-TrafficTypeDiagnostic: AM0PR10MB3250:
X-Microsoft-Antispam-PRVS: <AM0PR10MB32501B019709F402F05A7F1A93CD0@AM0PR10MB3250.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqpY6fSnzPVfFMoR8i8PzifqxXb9kXQdImvM/+mB4rI90frTKGPA7QPEmDBqCNQHJq/0DIzU5Jkob5zaTH7nAovVP5Jx3mg4LAfroVKmSpf23sJsSwTHZxcasaR0drCmMdxiPwupDh8fgRwFXTkZ7Rm9qAO+/tLyFMa4CzOlIVOazWymiWSrFFQhcjPhVcfn/+8icY4ecFTPkpnWxptnirtD2eWFm8Bju9+q7gGAGzH/ULxalQuBTQqRIbVKtKSfMUk+ZN9lX2ljrbgk+3MjT6/02/9Dpc/fYnEP9aehDLiHgu/o596w4xsKq/sS1F3zQA1fdINBVHZPkBiiA10su3oUynNxi8w9rYFi38yiFFca40i1J0PG7fLdbkGN67IFIIwOsDpeowWwfN29iC5d63cMtE8GpdCY71Ew5upJf8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(53546011)(6486002)(16576012)(2616005)(956004)(16526019)(186003)(26005)(44832011)(52116002)(110136005)(86362001)(54906003)(31686004)(508600001)(36756003)(31696002)(5660300002)(8936002)(8676002)(2906002)(4744005)(66556008)(66476007)(66946007)(4326008)(8976002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2I3WFkxaEZBQ0ZSUHhrdjhydE5QNUhobHdCMzc2SkdsUUtyTElXR09aSm9h?=
 =?utf-8?B?b3A1aFFvNk5SRjlzYWg0RnNOOVRDdTJkU3I4RWlOanlnd1RuVDdjdi9iWEUr?=
 =?utf-8?B?cVRWbVBkU3dIaHhwTUQ1amRHaytyQ3FyWVAvLzI3M3VUa2VJZEZSRTlPdDVp?=
 =?utf-8?B?SjdjbUM0QlV6NUo5bmRNVG5JdkRzN1l0LzBlZEpXaUtFc1dPTG5LdmpBemZa?=
 =?utf-8?B?Z1VDUitZUTYxQnpMeFMxa1BXTUZxZjltNitEeDY3Sk1sVmc0MnFoK0pCZzcv?=
 =?utf-8?B?MUpPZDI2RzUvb3lDK2YwUWhIMWV6TUNXU0JoQ3o0QjRmMHFyY05SMVhhdnkv?=
 =?utf-8?B?LzVobk4wZ0h1UERhcWl3TmxBZ3hUM3d6KzBmRDA0OWtjMFAzU1JpeWZTL0Ns?=
 =?utf-8?B?NE01eGxOWFpCejlKaUU5TXB1VyszeGVXcW5qTGdKTGc4MXBCZ2VuMU1HY01M?=
 =?utf-8?B?eFBGVlg2cVNsSlhFa3JKdG5USHRqVW52d1ZpMnl5ZDF5UzV4STNOVU93Z0Zk?=
 =?utf-8?B?SldjaUZNdDg0QlE1dW5HOUF3YkkrMW10MXZaTE5PSENFSXJmeUhhNmZMMTN5?=
 =?utf-8?B?QjY1ZXovMUxuNEF1UFN4dWo3SU9zMktwanNHRUcrMk9pd0xUNzVqYlRJZ1A1?=
 =?utf-8?B?czM0eHFtRU4vMkJCOEVQc3pXbzlLQ3ZQeGhzempHTC9CQ25FMG85M3R6VjVm?=
 =?utf-8?B?OSs5QWEraFo5MEk1d0lyS3ViWHo3KzM3S3k2VUY1dXREbVE1TjRMZ0RTVE9z?=
 =?utf-8?B?T3RYaEdUYWhoYjRJcWhuM05tWExHTTIxUm53ZTZUZ2VPeWNpd1J2WVJZcUVD?=
 =?utf-8?B?Q3FBRDJqVXRjaW04dXNCM3VTVW1lQm9Yb2dzWER4VTVWRkEzclRablhYRUpx?=
 =?utf-8?B?bXMxMzhWOGorNEp5UGpHb09Ha09hMG13cmNkRTdEVUxtN1BadElHeU5mOHlI?=
 =?utf-8?B?YW5Fc0NpWUtIOGx2QnArZCtZaUJ6aXptSnJWeWJXRW5pZVQvdnB4bFVnMUlj?=
 =?utf-8?B?NDJrdVMzMlFMdm1YdEZ1MUdDWnJ5NVRUUTc5eVZ5QjRtazFIVWJTTTNYM014?=
 =?utf-8?B?UWFYb2R0eUZYYmJEU1dwcFVjZCtUVmZlN3NTUkJhSVd6ZVZYd1pidWkya2hv?=
 =?utf-8?B?Uy84clJlSXZyaEczUmFsUkFtNWlVd0tvbVg5SGN0QTdLK0IxMVhaS2o3N2NL?=
 =?utf-8?B?NlptRDFPUExQM1ZMWkRlNlFLMmZIajhObnNVTFNHZEQrQmZ5cmd5eCtEWWo5?=
 =?utf-8?B?d21oblIxVjZnckhwWkNXM2o4S3FNYWV2ZWxlZkg4RjFOcWljOFBXRFlnL3Rl?=
 =?utf-8?Q?2KTFUdgv9CCAMqCOJg1bEec1tw51GmsTR4?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8618fc77-0c8c-4027-6fcf-08d89b5117db
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 08:13:07.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0FwXUU4cBwCAXu6WhlPvHOtVYI3ZIgDToBW+p0mhTdzIPfPdS+86aNhDbr+j68xltDMR+/erWL0AY079WEXV71+ikt3abvvQLPzHsvJC9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3250
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 04.07, Qiang Zhao wrote:
> On 06/12/2020 05:12, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> 

>> I think patch 2 is a bug fix as well, but I'd like someone from NXP to comment.
> 
> It 's ok for me.

I was hoping for something a bit more than that. Can you please go check
with the people who made the hardware and those who wrote the manual
(probably not the same ones) what is actually up and down, and then
report on what they said.

It's fairly obvious that allocating 192 bytes instead of 128 should
never hurt (unless we run out of muram), but it would be nice with an
official "Yes, table 8-111 is wrong, it should say 192", or
alternatively, "No, table 8-53 is wrong, those MTU etc. fields don't
really exist". Extra points for providing details such as "first
revision of the IP had $foo, but that was never shipped in real
products, then $bar was changed", etc.

Thanks,
Rasmus
