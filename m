Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A6A2FD09D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbhATMqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:46:19 -0500
Received: from mail-eopbgr00124.outbound.protection.outlook.com ([40.107.0.124]:13828
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728627AbhATL03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 06:26:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2Wvcydy+06T/26Em08V+SXOjCHgtOm5FI1SSye0pCYfFink01YJ6vnIaRLXC0Ur03UY2OC5M6p6pRIiRzuG9YslaGm2Y8dampwCLS0JI5T+j0T+B3D4Lzj4c7WTNUOy+0xjlZK4uNFgIOG+P1rqwBosNfCyF2/wOnaEs3z5zhrYLP/ULUY9h0dLfncWS7Fg56T2F3xUpcLvlHYSQpo/3bYJY87hZ1gSdsBT+jI/QGmyPONe5VfKOkQf8MW399UWaw4uI3SsYHA3ElIZCJpTSVOIeoB6H3/B+An/EtLFJdQs4bkhC+WdweRaqtstBi8k0CSpekfb0zBTMDqqZwBPQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCoV+VO9zl1sQUyePeEM0v9hSducP6xSA2U7CSa5rY8=;
 b=icftcVC5xcMB+6o2SeNIrrLUdkx9epMfYfZZe6kO8BDAQI0hVjBRvPEg5+Jpy7NM70wln0TjTLlvw/fzNDKKVElRJP/iZJONy5Ma73L1P53PjnUCixy7L/ON655gxc+mGZQkjaZmtvirf5KJ4z2qzRGdR76zLcmDHmNoWgFgBtFUgVlAHYx7GdYiw6i8mxDgrXOpgejHTgPgjcW2o8Ck8gtFyAO4rWcokl44K6cFxv+/DhLy2FmhwvS1kmTcakj6fbM7e7l1gY8A6E++toUwF61+zyJmawscw9YbpaJ3rX5WtaTp/vv6WMq17G4vINXO9ojcBjOyW8nqBxeo7vf14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCoV+VO9zl1sQUyePeEM0v9hSducP6xSA2U7CSa5rY8=;
 b=XeXVMv1W+zuVYEFIb+jzl9nglXNKHjlwett/8nU99egU6+JSdRPPsAAuhxoLpuP09jSF8c+hFa6BGRkkhJpWqCV3ugwBCVFvaSA0x2tlu0QO1z73aszSZUah7JUd59tJhffphbTHwIm1Bi1GuE1QnQsyFR8E1JqgRw63aGtb+k4=
Authentication-Results: infinera.com; dkim=none (message not signed)
 header.d=none;infinera.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3492.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:158::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Wed, 20 Jan
 2021 11:25:04 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 11:25:04 +0000
Subject: Re: [PATCH net-next v2 11/17] ethernet: ucc_geth: don't statically
 allocate eight ucc_geth_info
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-12-rasmus.villemoes@prevas.dk>
 <fa391dc7-9870-dd7b-503d-c0f1468328c2@csgroup.eu>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <582b6ef6-e913-5aaa-61d4-de75c96abb8b@prevas.dk>
Date:   Wed, 20 Jan 2021 12:25:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <fa391dc7-9870-dd7b-503d-c0f1468328c2@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: BEXP281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::26)
 To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by BEXP281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Wed, 20 Jan 2021 11:25:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1ec388c-2784-4451-7b2d-08d8bd36084e
X-MS-TrafficTypeDiagnostic: AM0PR10MB3492:
X-Microsoft-Antispam-PRVS: <AM0PR10MB34923A20C92125E9C3CF1FA693A20@AM0PR10MB3492.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QaOGcEcGLBFFtqZ9vfY33y+0xjjeoDvdFMCvlCFUO8IqJEszL2+daIBjW0pQarWsirI6hfxUGqTHH1j2DPBJxuOtOwSqZKXumLY65+D9t2yRqacSu6iYQK2wGdsI/v8TofC3tLAO1IusuGIxcJsaIZZ8LsyiTEc/r86MbshN+CYHoW1uwGlv/UZ6owVtyuDIGrB/alHUS0grBFfv6cUs4XADTGUeFsY5IrSP4n02Hi+WfSUmi1ZjR1g/1K3Rna1ZISoH2Soxz9iyMVm9VhbrmtExQNtanNP5uMinF4u6TmE57Bu496G/gw4CQ/tYnR53ZbL27dVAGWjfa/1rqs3siV+P3sNJ9GMILxsrU8AFYTOKrqmaQu4O7IRupNa6KK9Y0vkx8KIbLlI8Uslpps1zhLdrWF8YgPCBINF+3HjJuBAvRGtYrqjPEe8o/Q+I2NZtdiMIdwEqEZm+iYt9jpndpQ3I9OfHnnSUiwjAAh0590taAhHjqDWUVMXBH8jQDmsGy+Htwjy8SggUUnLdTyvbUTZwApj1Sh1i8xf5JQ6JJJD+xKeOpB0qQbQn7tWyHvpcP5GPtgbH/LcMvjVCkqeoJXBY33ZwCMpzSOBdZTw4fwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(346002)(376002)(136003)(366004)(396003)(186003)(316002)(52116002)(4326008)(16526019)(6486002)(5660300002)(66556008)(478600001)(86362001)(66476007)(66946007)(83380400001)(8676002)(8976002)(16576012)(31686004)(44832011)(54906003)(4744005)(31696002)(8936002)(26005)(2906002)(956004)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXRtK1BaaG9UbkV5Qk5hUzdsa00yT1FtUVJDN2dERFdySlBsQ2ZnakxFcldx?=
 =?utf-8?B?RFFPOHpjRTZDT3Fhd01XOGIwcXJqcU56OVZmRXNUMnJrS0ErZVdKaFAyVk5G?=
 =?utf-8?B?SW1paUcvTnM4SWRBV3NmRG9NK01DcjF0ZFU2SlNpRWtyS1BtbEdZaHFBMXFr?=
 =?utf-8?B?V3R0U1JiSEtYYk9Iak1qaTU3ZWxDZEZuemJlbGtRZ1NiWjh1V3F2eEdpYlI1?=
 =?utf-8?B?c1A4MHBuRHRWYTNRanBrbFhWbnJ6KzBoNktwRFJhV0w0RW40d043TDgxY3hI?=
 =?utf-8?B?L0g5emwyU3Rna3RiaGE3RVpIZzdnSXYyNHpiNzNEWlRhOXl5bnRGaldxVHZi?=
 =?utf-8?B?Qm9rOGM4V0padWVEMVUyZjFZazErOXBWMXVFbWFXeUk5aXIzTHFTZ3U2RkFD?=
 =?utf-8?B?amhMM0IveVBtMFdLbGxZeHFhVW1JMm02RXBFZ0xyd0U2TEs1b1I0S25hdEJr?=
 =?utf-8?B?UHVxK3BXUWYvWVZDSmtzYlJraGFyaVRRdmpRL0piSkc3R25JRHdEWmNRUVJW?=
 =?utf-8?B?VmZNMFRoQ1NhNDk0ZHhsa05uV3BLbXJQdlFCeU5zay80WGtGQXdYRTlNWGpx?=
 =?utf-8?B?eCs0SllsVGQ2OURqb1czczZFdStiRzVLVktydUxTQlh1dyt1d1V1QUZtSHJL?=
 =?utf-8?B?dTFBZXRJdE5HMFVYaGlLQ21QZW5xVlEvSlpBcGhoQWMrRmJSdGx3c3FvYWh1?=
 =?utf-8?B?a1p6enhrbUtBVWJla0UxWW53YldFckJmTDUveGUzUjlaOXQ0S2ZFWWd2MC9K?=
 =?utf-8?B?S0t1V3VycExNU1FwUElXV1gremFOYitscUI1M1pZR091QUI1cUwxVDNCTTdp?=
 =?utf-8?B?MUZpRGNnWUFaMmlKNjZRMWxiU1hJRFlxOTlSZGhhNzJRYkNhaTJrMm9YaXJz?=
 =?utf-8?B?bTkxcnBtMHpnRkdLaXNpcWk4SlREczNoM2ZOaWF3TEhBZktrNk04UVdrQVIv?=
 =?utf-8?B?UE9BejlNU0xRa29iWVk1WG56Y1pMQjIxSWhQVTJ4TTQzUmdDbm5VQ3I3WHhR?=
 =?utf-8?B?bkpNYU1uRXpCTEV5MnNRWGVmajFTTUk5eDJWOWlhTnFpMzBMV3dUQnN4ZUxC?=
 =?utf-8?B?VU9BQS9BVTZHVEE2YytpMldLQmNKa05wNDUxUnpNcXFtTmRkamZzTUtseUNN?=
 =?utf-8?B?N1EraUl0Rm1RU3Z5akduMCs1cjVpNUMyWGRhNGJLbFFock5SQS80aklVb2dr?=
 =?utf-8?B?eXdDT0FWenZQMzZuWkpHMlVIeVJzeHhTUlpEaDVXS1NPOEpOQnpnWm5ZdjlL?=
 =?utf-8?B?N1l4Yk0vSTNKaWNZcUdnam1VbnJpU25rdjRUNm8zcC9JNHBkMmwvcXl2MWdR?=
 =?utf-8?Q?Rl5FJjqb15Jgp1bqWAG19/MNFKNuKO4hcX?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ec388c-2784-4451-7b2d-08d8bd36084e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 11:25:03.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWdh/r2zsdY8NwhBA7jo8kSmxAyXw/NrtYFSf9JCOg3uhtXtF+HevG2wT15jEjSUxWQthWjAN0efsGGgB87cg9uUI7LE4D0xRRaK+QjQmQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2021 08.02, Christophe Leroy wrote:
>
>> @@ -3715,25 +3713,23 @@ static int ucc_geth_probe(struct
>> platform_device* ofdev)
>>       if ((ucc_num < 0) || (ucc_num > 7))
>>           return -ENODEV;
>>   -    ug_info = &ugeth_info[ucc_num];
>> -    if (ug_info == NULL) {
>> -        if (netif_msg_probe(&debug))
>> -            pr_err("[%d] Missing additional data!\n", ucc_num);
>> -        return -ENODEV;
>> -    }
>> +    ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
> 
> What about using devm_kmalloc() and avoid those kfree and associated goto ?

I already replied to that: I'd rather not mix kmalloc() and
devm_kmalloc() as that makes it much harder to reason about the order in
which stuff gets deallocated. But sure, if you insist.

Rasmus
