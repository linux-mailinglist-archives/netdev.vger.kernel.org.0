Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164ED378F8E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbhEJNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:42:21 -0400
Received: from mail-eopbgr80091.outbound.protection.outlook.com ([40.107.8.91]:58956
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350534AbhEJM6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCKpzxxClyJd9DFYipmCe6eCQkBciO+bnScOhsSZRzqzZ/nNmEkIBTyf99/xa6Yfhfb4I0nqCZBnykISvOQASzHmpvBYv9ujMlKdEou6IptSSkDV3Pgk+E97dHIf1TaqxB6ot0U0EPt+NO7TFIO+CXCoLEB+AKl57REK04dbb/Ee7ImYHZfXOH6G2WeC6EJLF363/aqSw1gY/OhMFp6NgDgztNVTMHcZ6/a05q1BL7fDF+vJGlJRZmY1EwODfTeIL8BNLzYFK0Za57nYIvKIu+xHF1XIp3/fWkYYazb66w6udnEss1PRwJzhbkP+0HiHQCZtV1h81IbD3GXAj0xzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lafmq8sLXeNxNi5na84nvb4gwPcw0YX7LccGbS6OGZI=;
 b=TtdX6qoKSzlwszpTNi46eLcg9S/EgzcwfygnEICA/Sr4FzuM9jKJVhMMptLpj1F4/FftQ5VcF5rwzA9myU7lsuXATm26sRk2AFZ+/GhMy95nbR87MyapBvOYFPMiiO0fEJobMaKM/Dymg7XKZCgxhXF9P6vEabJRPm7ejiYgcOVsc3AgtimdLpQTqddiCCERFn/+xFUQDY/ceyVvsPXez0pbzTSRl4XHeiSpGCfSS3RzDnSOMIALenya3tvxhNGuTAAa03FT2N0SrtofySvA27Ugqzxo+Kjm6ZdveC070eYTlOQaqx2kRGXoE4igPeDEmRv4/GchrlGNK8rynLE+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lafmq8sLXeNxNi5na84nvb4gwPcw0YX7LccGbS6OGZI=;
 b=TYNa2ZmzE86c81/Ln+eh2hgIo7o9eaTdKgBfNQ4WYJR4VmQ01LapksXNXiRCxuvczDVMZzOtf8jGG4o/oM4lOt7WWXDFEYKxKYwz4pxgUd13tnbBufvSEN4blyLzmBcOBihyAaWa+pAdU4EZF7bMcz2VG8RyGA0nJ9PFOiyG7zM=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3105.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:129::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 12:57:12 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 12:57:12 +0000
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Tim Harvey <tharvey@gateworks.com>, Adam Ford <aford173@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
 <CAJ+vNU2_VQRYzJKnHkLpJUYY7KZNGC8_fHj_7VcUdvHkbzFWGQ@mail.gmail.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <c18d0ed9-2f6e-1df2-e7aa-973e0aebfc45@kontron.de>
Date:   Mon, 10 May 2021 14:57:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAJ+vNU2_VQRYzJKnHkLpJUYY7KZNGC8_fHj_7VcUdvHkbzFWGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.79.33]
X-ClientProxiedBy: AM9P193CA0021.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::26) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (46.142.79.33) by AM9P193CA0021.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:57:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0abd59cd-796d-4caf-8651-08d913b3210e
X-MS-TrafficTypeDiagnostic: AM0PR10MB3105:
X-Microsoft-Antispam-PRVS: <AM0PR10MB31052660F4EB38C65F5D96BAE9549@AM0PR10MB3105.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPif9VV5YfkMXcnwbIxWUcmUJDg8TyAvwYaJcVRn5OnFe5lCvYfNURYdwlJGkPrE3Oi6so64e2MAFjojTtXYR44XSma9NR3vdW5NzjTEQ54xWqTmaio9gMftWaWqDBoVlPaGBX7mxHVPmUOEkX/rmmjIJ4u3+Q1fUU3cDkH+Dd/So4NfrSxiaIMs/PVS0K1W3U9RP3G7SKTCxObTQseRE5znqt3t51d2xARedkQZlx8dvBfv7ZkVg6m7yv96UEXUIybcDxWhY4NL47kOH27zYCgKXKkABbhoxvB9Olfb8kzvFVelon8XgDh1Ul0VWov3rikO5ZYpTNh/vF9mTwf+ulveyj8pAZeDyeDjVEXAbD8c/n+oi8MhNqEOeH1LW06fKrqA8OAKoEWf5RvC1wMsZs6iP+rEwSGvRUgru1HRXQQA9Hh19YkLQJGRaiQ4dnuu6r4vovH868uKouqj+U5JKO3CZNvc/CjDd98KEa8Oapv0VoPB7voj/JRwm4utYvpNU1Rl41LX0CWg7goOL9zflXM2Z6wARzwbxv6xrhKpgPuGyoZWWQOxwxsRfw8k79XNqnnk0CK22vPXKcnrhbgYKRLFX294IyJR4fRiHko24pKslxglSAeKwT9X0QhnLlNIoXNWdJMSHiy6u6zjCqaQbI/qp2JVtnNSzK/eZ9AUJZM6S1GhTZ2AkMihS4uRQ4Va
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(2906002)(31686004)(44832011)(2616005)(6486002)(54906003)(53546011)(8676002)(5660300002)(83380400001)(956004)(4326008)(110136005)(26005)(31696002)(86362001)(66946007)(66476007)(36756003)(38100700002)(316002)(66556008)(16576012)(186003)(478600001)(8936002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGhuL2VkeHZZVDRLZjJ4eE80SFo4blBvdDlLaHd3N09yZzZjSFV2ZmRTOWYr?=
 =?utf-8?B?eEIzTGVnWHFVb0FOc095dFJKdjBrWElMQlZJNWlJdW42WWl2bnVWQ3plMUpC?=
 =?utf-8?B?SzFyaVNsd2ZsMklyQzUvWmxGc3FqZTdRd3pzRUNhbldraENVQXJSdStxekZZ?=
 =?utf-8?B?UThROEZxemxpMVZSdU5CcUVuUzBHSk4vU0trR2tLdE82RE5aVVhEcndxeUJT?=
 =?utf-8?B?NUlQcmVyaHpEaEZkazV3Ky9ZTkM5dk83RFo4RDdxSHlEVlUvZUwvb3dCZUl0?=
 =?utf-8?B?UUE1aXhJUXRwYmRxS1BYeVZHQzV6c0ZkSktyMEpBKzZMUHZMdEJHQ2tWcUtL?=
 =?utf-8?B?enh0UXZCajFFVnk1bTlqR21PZzF1M2xwTFJXa00wZlBPYVFFUVV5WDMvYkds?=
 =?utf-8?B?WXk4MVRReFFKblFZV1hzbTVaN0x4V2xjY2dXL2xWNHV4TEc3V1M1M1hKaTUw?=
 =?utf-8?B?aVdEVGl3L2dpNFd5eGpYRkQ0T3dycldnRW0rQ3licmtjbVVZazl6NlRQWCs1?=
 =?utf-8?B?RmorUnhJeTRBSEhXcjVuMXlTeXVndlhqSlJQd1RVMEQ2NU93YnhWRStwLzhw?=
 =?utf-8?B?NXNkaU92NysrK013eEh5RjBjcjFhS1BCUnVCZlAzQkF6a2dSdEpaZm4rUFVF?=
 =?utf-8?B?bndOZVRDeGYvaGJSY044dm5uS0xlR0I4MEZBTjFUemZvSjI2UTlFVnJ5a2dS?=
 =?utf-8?B?Rk5nTjJkZjg4Q2VLN1p0UEc2M2s0Vjh4QWY2TXlWZllMUkFZYld1NzB0Qkdt?=
 =?utf-8?B?WGRXbThNVEMvVnV5eDZ5d2p4dTU2QTNGNTU1QlJiZnc2RnBudXlueTRiMG56?=
 =?utf-8?B?V3hQUzA4d0NvTTNNYndKN1NCMWRyUHB1dDd2WVJhY0UyaXhGbVZ4Um9Xa00x?=
 =?utf-8?B?cWxFU3BkeGRGbDNGYXQremNNNEJTTXFuckxCcXlzMkU0UEVDSEZtbzk3cE1K?=
 =?utf-8?B?dTl1YmFBRG9QTVBjc25rSFZTWjlmYjhoOFNQV0o2RkM4QVkxSnJkekZJZlFt?=
 =?utf-8?B?Y0VGVmp2SkZLdlNDVFd1SUJFQWVtM0drdHpYeEV4eElEUWdMd1U5akFuRnRS?=
 =?utf-8?B?d1BBTWxmNlh0cUJoTGFMMEVxbUFGZitUUExxK05oMkM1US91S0tpY0g5SHIy?=
 =?utf-8?B?NTF3WlljdGtqZCtQK2FlUmJDZWhFTFBzUGJ2elBKWkxSdFBEVkMwS0N5Rk41?=
 =?utf-8?B?MXMxc2R0aU95WlNzZHZEVGhmcVd0VGR2Um5UdnZXTXFPKzJIdHlacXU5Vks0?=
 =?utf-8?B?czZkb2Vwalg3eGhDbHAvck1PS1ArVXBNVTV2aXBldStkdWZweXdXV3p1Zm81?=
 =?utf-8?B?ZlFBN2I5aUVZNmxVWHpPdGtiUnZUTHJML0VESERvZytRLzdydmF1NmszVkxY?=
 =?utf-8?B?T0tMSm85VHM3REN5bkRIdXpvakgvN1c2TThZcXJhMFBnaTdDNUt2eVUxTm9s?=
 =?utf-8?B?U3pHZ3JCQk1kNXV4MzdScWZiWXhuOWQ5WXNYZGNpK3g3VEVhUnVDemlrMklF?=
 =?utf-8?B?eW0vdGc1c3p3UzV4UjVLamJ0dUNOTFBQZFFYSUlJNjRROTBqMitDWlhXbnFJ?=
 =?utf-8?B?NlpES1VwNWlIZnFndlo2ZGtvVjBXQ3Z0d1RpOVZiZEw3UzVkNFhqaThZaTdT?=
 =?utf-8?B?OU9Fclpabk5hcFprTnpkekQwYitoTEFhTVY3U1BGWDZxODB2MGZGYmxYSmtR?=
 =?utf-8?B?cGtPcTJEODN5SVI4Qm84MHFOekV0ZCtxT05FemJCbnJ3SnoxM2VnUjl1Mkk2?=
 =?utf-8?Q?sS4lFHCGEnWxyuXrPlIhEKMUVLiHENXbHnMqGNs?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abd59cd-796d-4caf-8651-08d913b3210e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:57:12.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ev9x3FZdNBLY94CtAaAWi8UtaW4jS8u+TyX2W/jIQ2mGPz0Rk6KrYk/YG5+aIG2cI9yy4aogQ4zUCtq1l3kbWv3kWfQxTW0/5y4oxlP8aaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim,

On 07.05.21 17:34, Tim Harvey wrote:
> On Thu, May 6, 2021 at 12:20 PM Adam Ford <aford173@gmail.com> wrote:
>>
>> On Thu, May 6, 2021 at 9:51 AM Frieder Schrempf
>> <frieder.schrempf@kontron.de> wrote:
>>>
>>> Hi,
>>>
>>> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
>>>
>>> So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
>>>
>>> To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
>>>
>>>         iperf3 -c 192.168.1.10 --bidir
>>>
>>> But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
>>>
>>>         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>>>
>>> The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
>>> There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
>>>
>>> If there's anyone around who has an idea on what might be the reason for this, please let me know!
>>> Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!
>>
>> I have seen a similar regression on linux-next on both Mini and Nano.
>> I thought I broke something, but it returned to normal after a reboot.
>>   However, with a 1Gb connection, I was running at ~450 Mbs which is
>> consistent with what you were seeing with a 100Mb link.
>>
>> adam
>>
> 
> Frieder,
> 
> I've noticed this as well on our designs with IMX8MN+DP83867 and
> IMX8MM+KSZ9897S. I also notice it with IMX8MN+DP83867. I have noticed
> it on all kernels I've tested and it appears to latch back and forth
> every few times I run a 10s iperf3 between 50% and 100% line speed.
> 
> I have no idea what it is but glad you are asking and hope someone
> knows how to fix it!

Thanks for providing that information. Yes, the latching effect between "slow" and normal speed now and then is exactly what I'm seeing, too. Good to know that this is something not only happening at my end!

Best regards
Frieder
