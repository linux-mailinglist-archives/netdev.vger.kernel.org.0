Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9C43A04D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhJYT3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:29:43 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:28155
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235539AbhJYT2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YginAnrOLGkZxwdurb3rSwvus5qFISz19VZ4MOyCcQQFlOpsC5tqXgT1s/Gwj1XGDqOCOJRji5F0uSsQk9lPGGNxx8JFVWNgS+nmHF6i5+urvj3EQ0blHqWwD6xXyFXS2ejR2FnyHmFM4lTSD9flNylJkUEFDIStJqmbk7F2kwHAreiEhoEAtolASvub6V67uADgnLGSypkKryMh1cmhyEVdOtE2cgMynad32oZv3zxNbAjJIG9bDfwfAYez+hCIkPTKSyAK5EYz+G+WiD6Pckln6MFaXHriWPFpN30U4D9T4Bb8wGH6RhsodfOJdJ/Fn6CyxA4A0kTfyWz5tOEcSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBYx9YtucKogYssn0WwC48a3DdIxzbzZb6ITwwzKImc=;
 b=NJJFaZpQf9VNSRb1c86qAf5RT+QSPUEZjE/QRUqU5SNADecija2o4qA5W/gsklMMBRb2Ux1KEYbehQG68+j6Vn/hI7v++CxfnkDCmw4EQcmkZVRKfDjYp6lZP4bu4qmWz4K0u7LHqieRrpWDrodzDbnkHYLR7ae7nahTu1RmiiJdWeaMkMQ3GA6qtTn7kjqcPukhHBaL30izLhRQ3uoelF7A4xKErZNb+tXn2CLEEAcIry4Idn59X7j8QZTCpggNekhEE/5kITGzEOpygntjicZFrXhIH5B2u5iaUBlLm/LIz1Mb+DSmTLr5Vgqtzs+ScDWiVlr0fHyfF3/Qvl9tkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBYx9YtucKogYssn0WwC48a3DdIxzbzZb6ITwwzKImc=;
 b=SDzYg3Sei4HhmfRIAEaFJWirVamGsp1SKj13TeGkQIOx8n0/2ZI+l62ba8W1qfJzWX2xyG6wsWPRIXsw7J9heP0lIl4jQNT0jw+PneTb9ove1l/cwFfbN73LNEstIP4sNsRwV+7a0ciNY73Gmj1f9M+t9jbyqv/w+uD1BpSLx9Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3516.eurprd03.prod.outlook.com (2603:10a6:5:5::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Mon, 25 Oct 2021 19:26:21 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 19:26:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH] net: convert users of bitmap_foo() to
 linkmode_foo()
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org
References: <20211022224104.3541725-1-sean.anderson@seco.com>
 <YXWrBZJGof6uIQnq@lunn.ch>
 <20211025122000.7da7eaaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <de2f09e8-6f3b-7d6b-03ba-770c603e2f92@seco.com>
Date:   Mon, 25 Oct 2021 15:26:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211025122000.7da7eaaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:208:120::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR10CA0001.namprd10.prod.outlook.com (2603:10b6:208:120::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Mon, 25 Oct 2021 19:26:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42abe5ba-980b-42b9-ee68-08d997ed5314
X-MS-TrafficTypeDiagnostic: DB7PR03MB3516:
X-Microsoft-Antispam-PRVS: <DB7PR03MB3516AD3E5B5836D96C228B3596839@DB7PR03MB3516.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jd251wKRDh4iz3/8agXu2jDbigdNqTWZzM5xKRNphIJhWogL2a9Q6I+Wgn30Ug9tqr+t99LnHSdzrCnG9D6wbsBHQ0/rJt3ie3Af6CKzejqhnsKWlTy2yltP/7yTKhrWS2ymOGmx6q0ktRPBj3VNoOxhoMNIR1Qm0jnqlzIw3bR9ZSNM7aG3YaJX3usEKR2QaX/+vwFyfx6frLdswJ0h50JM+5dhtWZB+IZW5+8rg1dl1ZNHIFBW621t3WhyG1sXHIgLEP3AxwOBiU2rZxL91QUqK5IAQDTyRFw+ZTqLMOsVktWFO/JFibP31OBlDdwlbXDrj7IvHPuxQ1CD0X3sTql6FDjemZIyDPWfQ1iw+NysHEZHzY2ZXZXpB6TAUzazBCGn3e6nYSKyBoMfaYOr8nY30b73E6SdKMhB9m64BiN8azSQYy3VldOIGREPxCH+XlWGfJ/r5KU8bQxGDMxTVIPHwkqEZ+fq7O1x6vjwAsTf0eCDcNe2ybBRSyCPS0U6iQMo53RSEjjFSYgYQhjzmWWSC8LN2TqcGdM5+JESR5qy6Mycp6yjpuuJ0gcDEwnenp1EsXvDsLcu1Y++dnTNRAlKl7Q+KwaN3vXgMb99mVVDN/W2+9oEFfHG994dl+cRT22TNkKP5PI0BnOyr95HX9LrIP6A6zgrJ22O8kdnd85xxguVhCSCjUktg4Rr2GxQxB6llI9gksd1ICA2it1z4kF0x1uvmkEuj8+bbNC0dI9qScaNAm1K5HnEr6usCGn8zRV/6kysCuxgMu5Mv0PvSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(66476007)(31696002)(6486002)(38100700002)(86362001)(38350700002)(4326008)(44832011)(956004)(66556008)(2616005)(2906002)(8936002)(54906003)(110136005)(31686004)(508600001)(52116002)(26005)(5660300002)(6666004)(36756003)(8676002)(16576012)(53546011)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2xidFNOeDZIWExORTRvS1JsWFJZUTk1MUlTRFAwYzRLbE5tY1l5WWxyQlBu?=
 =?utf-8?B?Wmh0UWlXWDFXRm4vMmhzd0JCWGRxUVVwTGgyR3RNTUdQR1RsaVo5WUNsdmFR?=
 =?utf-8?B?WGMxNnhCYkhBVzlteGs2eFhXK0RIK1ZOUDhQODFrN3ZZWnFUU3B1djFzd2t1?=
 =?utf-8?B?eTUyUmc0NWxnZ3o3SDd1MWFHZ05wRVRQcEFkbWdWS1lNNlN5MzRFYVpkcnF6?=
 =?utf-8?B?UGxDOHd3TU5rMjVpYjRGQXRZSUJDTDRnSGZuYmNoUkphbC8xUDlyU1BQWUx2?=
 =?utf-8?B?Zkwzd0N3aW8wZ1VZWUxjcGR5UkNEazN5ZW5kNUJFdzhQUTMvWmVVTkZNMjRG?=
 =?utf-8?B?am0yTDlKb2d6a3J6a3BNM0d0UThjWWhBTnNuK1lnNUpnVUJPN2hQVmc4dkth?=
 =?utf-8?B?bmVOZUk4dlptQmNoakNSeTRNYmxMVjZZYnFGRHhRbTBHUlFLV1lmSG42WlAx?=
 =?utf-8?B?R3lPYlFiVUIxeWRSUkl5MGNpYmJxVks4VzFYb0FZR0pRaXM3ck9tSjFsMXR6?=
 =?utf-8?B?aVNZS2g0Q21vL1hOWlFyaE5yalNudVVNM3hQcmVYTGFaYzVqL3BjdzlUdmZm?=
 =?utf-8?B?U2gxZFdOM3hab1R5RS9HeVczb1RENEI1Qi9aV25MSDBrS3V3dWswUkgrVUVY?=
 =?utf-8?B?NDhwemlST1VVWmVrQ2liVlZQVG15YzdpZzZHRWFpcFJJSHlyVlIzRGh3YW4z?=
 =?utf-8?B?eXd1OEJSNHZGeVVLSXNJUVRlc0JmdDZBR25QZ015b0xzUGo5djFhQnFPMC9H?=
 =?utf-8?B?T25kYWMrMDJWZHNXa2I3WjR5SVZqaWJyWTQxc2tJeDUrQ3R6WW92MjJWd3hw?=
 =?utf-8?B?aElzZ0VtcGRpRk95d1RWNWJmRE84cUEwK3dHWDhtNmp6d0xSZjRsVE1BbUxz?=
 =?utf-8?B?ZFY4dUt4dkl0SXlHVjR2OEdwaTZsZExNbWRDNzkxWGY4QW9kMlZaa0VUdk51?=
 =?utf-8?B?YUE4aW5ncXh2UFFhMmpHU2gwbG9LRzNkVkVBazJuUHJKUW5mYmtFcDRYajlk?=
 =?utf-8?B?bUprQXZ3WXFsTFdkWW9VOExlRkVrc0hNVzZUZG11RnNKVTRJYmJPeTBmSlVC?=
 =?utf-8?B?YW1LRHZHWEhDZWV4c3M1RFVkWjRjWjZ0MHdPZ0YzNGFQMi9wZTRkZTN3Vkha?=
 =?utf-8?B?OEdlbHFCaGZ0cXA2dFBPbmZkc2swTW9MaEd2UjI2cVFXdFNxM3JSNzZyODhs?=
 =?utf-8?B?ejZqUnhCKytmeGxTRkFXUEdvV3VENTlFeGRtZ0pwQy9PL3RGT0Fna3cyTFJ0?=
 =?utf-8?B?dFI4bHNTRUg1Q3JLZ1F6Y2VpYXkxZHFYU1RhNkdpS3hyWWVYR1FkQXhqR0VF?=
 =?utf-8?B?bFNGdHlJQTdPUDlDejhkcXQwSU04Y0k1QTdTN0dUNm5ISHVvcUFjZGR2TDdB?=
 =?utf-8?B?NVpiTVNSb2U2aHFESjNLZk5qTUlqS3RhYWRTSU5DVkFtdnVoN3luOXJndjdL?=
 =?utf-8?B?bGtBOGhjRHdRcTB0ZXErdWFra2paS25VY1hqNERnQ25qZTZsVHhzUXlCcDBz?=
 =?utf-8?B?Uk5TY2RpUk9BUFFKMGIxUXgzdll2TldXNE1KZmZrK09ZbUhHVVBMczN0cm53?=
 =?utf-8?B?cE1MMDRQVEttRGdJVlI2ajNWRGtmc3I0bi9Yd1ZsanV1SVJmQWszYUpKVW5p?=
 =?utf-8?B?MHc0RGtkOWNlVURSRUxlVitLb3N0cjlYcDJmOEt2bE1uOGV3S1ljZ2l0dUVQ?=
 =?utf-8?B?c0VVRVdaU21IZHVvVHBsRW40SFk4WGh2Nm8zVHptd080akVMUWltVllCNEN0?=
 =?utf-8?B?TkJNdnc0Wnc2d2dwT3IvYlZnN3psOTlOeXRjNHhRRkVsYWpqdVF3TExZWFIz?=
 =?utf-8?B?Tmo2NUNla3E2S3prc3ZUQ3BMcTUyUVdVWHdZWUxBOWRNNWJ5MFZCSEQ0dVhs?=
 =?utf-8?B?eHpqU1Q3bGJtOU9BMVFHY21JaFU1eWFLUnVTdTJyQWVpaitMRDlEUng3U3pl?=
 =?utf-8?B?WmJUR3R3NHFoVjFmbFU5Z3JnZ3FKNHhEOHlEN2tRQXYwRTBVNTVJZEt0eEhZ?=
 =?utf-8?B?VmNQR3Q3cFNkZnA3UXh0emdBNGNLcllFOVRlaXhuNUZBRUtvUmU1eldvLzFR?=
 =?utf-8?B?Y1U1Vm5HSk1Hd0l4anJJUjZXaFc4TkUrY0UyT2xqNjU0elljK1I2dExBbVFN?=
 =?utf-8?B?a0FpaHp4Q2JZN1ZlMWxoWm1MVDhGNlhtMG00d1l5bjJ6ZUFtcVJxdHQxbTk1?=
 =?utf-8?Q?XZACPcTafT1k9v2Hm/IMl/g=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42abe5ba-980b-42b9-ee68-08d997ed5314
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 19:26:20.8808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxdxSmLBbrFM4XGGD+ynisiuqjU/rxtpfq7Y17fXqsO6DLny3750KWFUHkJFjsBbQ4V5nfsRFqYsTEQm8IX9cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3516
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 10/25/21 3:20 PM, Jakub Kicinski wrote:
> On Sun, 24 Oct 2021 20:50:45 +0200 Andrew Lunn wrote:
>> On Fri, Oct 22, 2021 at 06:41:04PM -0400, Sean Anderson wrote:
>> > This converts instances of
>> > 	bitmap_foo(args..., __ETHTOOL_LINK_MODE_MASK_NBITS)
>> > to
>> > 	linkmode_foo(args...)
>>
>> It does touch a lot of files, but it does help keep the API uniform.
>>
>> > I manually fixed up some lines to prevent them from being excessively
>> > long. Otherwise, this change was generated with the following semantic
>> > patch:
>>
>> How many did you fix?
>
> Strange, I thought coccinelle does pretty well on checkpatch compliance.

It does, but the problem is there is no obvious place to break

	long_function_name(another_long_function_name(and_some_variable)))

without introducing a variable.

>> > Because this touches so many files in the net tree, you may want to
>> > generate a new diff using the semantic patch above when you apply this.
>>
>> If it still applies cleanly, i would just apply it.
>
> It seems to apply but does not build (missing include in mlx4?)

Hmm. I tried to determine if the correct headers were included, but it
looks like there was an error there. In any case, it seems like David
fixed it up when he applied it.

--Sean
