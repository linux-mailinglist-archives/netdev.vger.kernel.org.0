Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED8445609
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhKDPLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:11:19 -0400
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:25057
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhKDPLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 11:11:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2vwMWifcc9f124Mgdfz3PXmx1xgp34+SSTxinw7By00Hu3aCCyj7LnVR8CRshWKfwIRKcDZwA087EDJC/K2K9brkKOBVmwwhAgcPDX3XKARSzZqZA252s0qAkdMgNUZhccV/MP2FrhRsEcQoV/1E2P8uE1Vtwd5HbblsHS6JIdd4Xf1ZiqH7SFyFdo80GJJ636LC9GA5lWJ+EH3tMgVzoCRTlgFE1i2Xi1d84Zk3aGhP+LhSWYYcXUKQW4BAE/1C5xaSRF5y7PE5epzMnQzo5EcOxhfEu1MG4iwKVPi3rRIPFQbGy9NuYVGjUjxCNNM3BiYHSZo6LntQ3oKQbDPUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9p8HZ+40yjY5uIo9ADtCuSPu8HEw0K4A11Vm1r2s5Q=;
 b=NjYbp9THZEu+5QvA3FJQU5/DnyB+Qu86WYdi6KKgItwVjLIxu4ckimeLkpaSupVB323BEiXUEnqC1bbT5CODeprBJUo5v9xJ1yGm4RYV7ewzD1Ww0JVQjGJSw4xvEMnyZZTM4RJWUcUZyxv2VtpVdesuZyRGnniNkM8ENMhPdWTpH9UoMdXvpVHJt2yxU8Ri9LpSRrXbYSo9bVj99G82iMii2IxID//TpxZvjTwNIFv+O4hr0ZPb+EgqteX1HG5xdgfgpPFfHcl+3HEtgd7nc5fmA+34+3sTuWRdVeVg7zwtsVF6AxjyPxJ0q7FIUO+ukThRRy+zWPExDO87dYPWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9p8HZ+40yjY5uIo9ADtCuSPu8HEw0K4A11Vm1r2s5Q=;
 b=fZZf3Xn+9UguPHhu8mVZFn+BiVrtLatk4US+f2T4sqNwvMTju4LvWnLjyghhIksb4iHSybIfEQQjJZcDtg1NJ7zZ+4oqs54I0P1CE/Lqlj6bQ8oI0vF7mZeRZs9RQ4nhaBh/xyx/fWxLElTlUSEPs05vL8qT+t/PR0Y5oOXjOxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5367.eurprd03.prod.outlook.com (2603:10a6:10:dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 4 Nov
 2021 15:08:36 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4649.021; Thu, 4 Nov 2021
 15:08:35 +0000
Subject: Re: [net-next PATCH v5] net: macb: Fix several edge cases in validate
To:     Parshuram Raju Thombare <pthombar@cadence.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Milind Parab <mparab@cadence.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20211101150422.2811030-1-sean.anderson@seco.com>
 <CY4PR07MB27576B46D37E39F9F1789A31C18C9@CY4PR07MB2757.namprd07.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <1978350d-b67b-d538-5985-c204c6b549a6@seco.com>
Date:   Thu, 4 Nov 2021 11:08:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CY4PR07MB27576B46D37E39F9F1789A31C18C9@CY4PR07MB2757.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::24) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0079.namprd13.prod.outlook.com (2603:10b6:208:2b8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 15:08:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57a54b36-4924-4837-a9fd-08d99fa4f970
X-MS-TrafficTypeDiagnostic: DBBPR03MB5367:
X-Microsoft-Antispam-PRVS: <DBBPR03MB5367630CFAD534BEADB7DE00968D9@DBBPR03MB5367.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZExBsQJH2ppcVKcyP5Gp6UGDx7x6feccyxWTqW0hZ+A3JldYBdR+fnQt8dqqFiA+68TpRHsliUHL3PuKkYyh8bLCuBKAkKgLXBlGn4/8QymT/W6DdXVtIXJXRlXm7xN992he/ynOlRwjdZRcmSVLG7K4pCq00SiZbKR8fwCT5iFbvJKz4cUmfDtJ8t0FKlJKpX/wnaIHcbpdqdB12JI0Vbx958xwXBY8guBv5PEpE4ZvXZ1SrQMUiDMlx9cLtB2W4biIRhkwkM7bqo2a5FV0sNfMWwyuVkgwmPRM269HjwapLxZeSI23lsVgk7fJBwmdQIxG5pSZ4AtXj5uksQ3LGy6kCoX52qIlkVhZN8xRMi8xcEAdaQdmoP0zKK064vw2jC2S4oHITg0AtwHVpUUXuXmHGDJm+5QcuuyOqKhqvyMGe1qyrU99K53OegR0MIkl/m8KEKIBi5h1sr7TkQTNqciPiht/yTMMfotT6T968LMd0o7jnb3CbnO0mU/qFi6kpmHfeVOuA5rWCmzMdZM0bFxvAtOkE+D9jjEnjN5eCCPcqYPBOnfXO/N9znaw3uypVz8Bv5mUF28GviIgoX3accPcsaVlCauihjE8+lfIyu5QDKSktBCjM0T6yrRU+lsrM6iOyqta6FpyAWijMoodwkMuEuYwE5Zoe77C7k4FgaFMOI0yZ/qWwqttDZbgmzsoaSNbyta/z1dG9M1KURa99sXl8sfnKbSsU6r2XXrtGLc5WV204tpEdNfFpV+cJK8iHBL+dTFvwoT98/ekMcgi+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(54906003)(6486002)(31696002)(4326008)(16576012)(186003)(316002)(110136005)(26005)(508600001)(8676002)(66476007)(66946007)(6666004)(38350700002)(38100700002)(44832011)(53546011)(36756003)(5660300002)(956004)(86362001)(2906002)(8936002)(2616005)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU14dG9rM0IzN2J6Tml5T3hnQ203TkJFQWlPcFVMVG9jV2tOTmRCZDRFN3A3?=
 =?utf-8?B?OGYrcCtHeVVmRjg2TFhZeTFoeFhreVpOczB3dVhWUDRLZmY4SlNhUUJDeFM0?=
 =?utf-8?B?MUgzVmdzSEFIQjVoZDdMcyswT0FmUXZDRTRHT1dQLzEzY2xyY0twKyt6TjVF?=
 =?utf-8?B?QzVNbUh2d1EzQktMb2VFVmZ3NTFsdUdxR25SS1NMYWxYRTd0eFVXclozQVJD?=
 =?utf-8?B?ckZ1blk3ZUlaY256SSt1ZFBxd3F3Vnk4ZVQ1NGVTY3ZOL1h3WWlmSUFmNGZj?=
 =?utf-8?B?clVVd2xLdm1uR2RrVk9Jc1VMRmJ6SjF5dktwNnFHV3BnbGsvUmtLTjRoOUtu?=
 =?utf-8?B?UDZ3dmhRam9heE5semZ2MkgrT2dXdUNhc2VvdzBTQU8rZmFjVGhSaDM4a0Rw?=
 =?utf-8?B?VldlV3cwYTNBTFdPTk5nNTF2LzRCcmdyR2Zzblk0eFg5eHV4enpyUlRjSEFa?=
 =?utf-8?B?ZmZ6NTdoL2Rnb3hkeURienlOa3hla0FJaDZSU0dUVmZlVUpzMWdCQy9JOFpH?=
 =?utf-8?B?SUM0WStQT2Jad2c4NC9keHBmNDExWDlra0ROZTlEVi96MTU4STVLdHlvUzBX?=
 =?utf-8?B?MityQWY4MmRwcXFkSUVXRUhyMUFMZ0x1SklleXRFM0ZYTjZ2eEU4bzAraEdT?=
 =?utf-8?B?bEE5eUtRUFhLNGg1RUhnMDdBTTFJd3BFZ1kyN2h0UHFlbW9CN3l5TUlWUVB2?=
 =?utf-8?B?bHRabjJQdVhCOFlCOVVwZHp4OUM4ZHJTZE0rU1QzcjFQYjJaVjkrek8rTlZC?=
 =?utf-8?B?OXgzbDlqNlgzU0d0bEtoeEl3bzdUVXQ4dWorQVEzQmxmanRIbDQ2MWtCNU5D?=
 =?utf-8?B?MDlsMmVqZlcxeHc2dzlqYUZ6c1RqM2pHdERUYlF6YytsNk8yN09idUdyVllE?=
 =?utf-8?B?cGJmYTIxWWhVdTZkK2RSSnRRRm80eWlHdThleHdZeE9YbUs1RGI3S29CSEYw?=
 =?utf-8?B?VFBHdEg0MTJGc2N2OWhCZE13MXN2WUtyVUpIeVpJN0J2LzhVenExVGczMlpw?=
 =?utf-8?B?OHducWZheWZBQWpoUEdJeitGY2Q0bzdIUGVIV2ZCR1dhRkRqY0NBaW1EdWNV?=
 =?utf-8?B?R1BaK1FRRUpRZ254MUg4cWpqMnRwUjhmLzBLZnYySG82TERWdnpuQ1JaaDdD?=
 =?utf-8?B?TlhPS3k2c0dCSXp2bXNsSnpjamUxR1UwU0NOMHNVQVJMcHdCSG1BUWF1eWox?=
 =?utf-8?B?OUF2c3E5eGw1YVU5VVc1dVhmaElaTnQ5YWpDdXY3OTFDTkowWVBta205U3RY?=
 =?utf-8?B?NWhmQ3U1ZUdyOENLQ3lkbzhjdUJxOHBKMW9hYUZscG9sR21kMDNLZlVEU3oz?=
 =?utf-8?B?QlA5QlE5eFlxMXB4aEpZdmVUQUpjR21nU0s5cFlxWHBWWldLZ2xKd08vSEd4?=
 =?utf-8?B?bnF3WHZmdE90TTJRaEdNTFVEMi9oNGpXaUg5WkI1SVg3cmZJR1RKdWs0RWtq?=
 =?utf-8?B?SW5RWktPMnZlNkhpVlRCSU16dm4xdHp0RDhNbGM0TmJOcTJ3b3h6MkNiQTZZ?=
 =?utf-8?B?akxZUEIrS0p1SjRabFRoeVkyelZTVWc5aTBtT1pZRTFsY2dpcVliUVlTbWs5?=
 =?utf-8?B?TWdjVnI3cDc5dHMvV2NnQ3VuWlVHSjFwVlk1VFRTcWIzVi91SzllbDVNNVdj?=
 =?utf-8?B?YlQwZGUrbkJrK0pYbXRqd1NiVTdXMmZYYlczM3J2Sk1PaUN1NjFWeVRUYVY2?=
 =?utf-8?B?TllSV1ZjWUtLYTQwVlY4bi9hMjBoZVg4N1JTc2dxYnEvMlR0SzV0V0JqcUY5?=
 =?utf-8?B?enQwQUl6aldYMjVUYk1BTjdPYkNWcVhyTGFqMUNReFdEcFpNNkRFUmVHeVRn?=
 =?utf-8?B?eFp5NmdsMzdEbHhnKzF2RVdDOWRUbE5IWmJ5TUR4R21rZ2FiNC9KUjcwdWxQ?=
 =?utf-8?B?ZUZMUkRwQTQ0K2pZd0lSRXhvUzVQL00wS2RmZTh0WE1qTC9xdXhtSGxIUzlV?=
 =?utf-8?B?TjBnZnRSd0lWZi8vUEFlZ3lkOWkwREY1WGRheGs0UE16TkJ4bE1TLzhYcXNw?=
 =?utf-8?B?Yms0ZGlVcEc1V3pubEVIV3RoK3V6V3hYYWlqajJ5Q3J0RVdtZnlreEpweEpO?=
 =?utf-8?B?Y2R5MUQ2czd1a3lDbWUrc0JvNWVFd1FMaXc5TjBGcHlpOGM4QTk1TU80dmVV?=
 =?utf-8?B?UGpBSFN6MS8rUlJSWEJ6cXdyTCtRcTVObSthUzdqbmUvejFRdjU1bzY1azRM?=
 =?utf-8?Q?yi20YKO4Fb068w8mY6OTY1M=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a54b36-4924-4837-a9fd-08d99fa4f970
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:08:35.9238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBl4dvaukOJYBPgnnd6vBAhkQZQaymjUxwbrKq/5G9ENqx8wV8XrASuLpZv9KexE0bFKTjz9OSB2Cc1Q/YgbOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5367
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/21 6:14 AM, Parshuram Raju Thombare wrote:
> Hi Sean,
> 
> Thanks for this improvement.
> 
>>+	if (!macb_is_gem(bp) ||
>>+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>>+		have_1g = true;
>>+		if (bp->caps & MACB_CAPS_PCS)
>>+			have_sgmii = true;
>>+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
>>+			have_10g = true;
> 
> As I understand, MACB_CAPS_GIGABIT_MODE_AVAILABLE is used as a quirk in configs
> to prevent giga bit operation support, Nicolas should have more information about this.
> 
> macb_is_gem() tells whether giga bit operations is supported by HW, MACB_CAPS_PCS indicate
> whether PCS is included in the design (needed for SGMII and 10G operation), MACB_CAPS_HIGH_SPEED
> indicate if design supports 10G operation.
> 
> I believe this should be
> 
>>+	if (macb_is_gem(bp) &&
>>+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>>+		have_1g = true;
>>+		if (bp->caps & MACB_CAPS_PCS)
>>+			have_sgmii = true;
>>+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
>>+			have_10g = true;

Ah, you are correct. It seems I forgot to invert this condition.

--Sean
