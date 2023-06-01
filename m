Return-Path: <netdev+bounces-6948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88493718F84
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 02:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F893281648
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52358EA1;
	Thu,  1 Jun 2023 00:29:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427F0A55
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 00:29:07 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2088.outbound.protection.outlook.com [40.107.114.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A011F;
	Wed, 31 May 2023 17:29:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsKwqI0kZcMEltgkI06l5JwiAKIxaNjiuxrqyrEYQltTSY4UYyGwVRfBpFCFWVm8iQ4zW38Y+kvayU4CFJcgdo7te7ub9bf/j6TyeIAk2DVyaV0FH6q9rqgo2Lndq92bBt49TJRNfTDVi3ebOVarXxVIqiFzoic+sH1z9vI+RfsC33jiJWYygCDQ2IRd4DC/YxJSijkhAiVfFXb5DJy7K9BEcrd1HzuvMhiFFnL2wTwDsGWnAVm9NLg488kEmm0ZI7Iy53KWnOgNt5C869yKOBcMyD+CPUukIE+9v4864aX5q42TkLrTtD4u/ofBA0FwUfrD+54/2DOBYwX/z9D80A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hp/xWfhVgpNWcSDvR5ebiEsbYpoD3eEeVAnA6WiEC74=;
 b=cRwvBEfbqYOec7aF4h8X7MSiA6IWc0uyZ9RszgewZLC1RPiIFTnM90M4kgiJei1wtn0C1KuAfOFrrX75FRQqP4rmP435nw/wQTKRmbbr02v7MJ1GYCBZ27p929h3Ah6BvG7Dns6XNYZleeEdApfWbKJilPnParG/GqxlvsmdWJlUXE7TnYS3MIe6Y2RhRR7PffMjpB5KW/uJdd+1b6UHUsNrzo5dhJDw1TqOFOd/m3wbv5M3e2zk1By2sU3XN2sPjaca6s7+DiCUF8d/4BzwlQmXo2B0IagLpXwYxPAuz28caq5pjlP7CPLA9ETLYEaZ1DMngbayMcM48IKiWP9Lkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp/xWfhVgpNWcSDvR5ebiEsbYpoD3eEeVAnA6WiEC74=;
 b=WQ/c5SzJRgwOhedBFeAN4VLAbcMQLDQz1hY75pScpXpmU2ou9geYGZ3lXGDLuhnuVNUZ5h2LkSlx0ujfIgNfGfaYNUz6KEL7jPfLg8yCjuta/jbhOO2UyUXzD1bgqZPbx4Od/IjUJwhMjW80zZ48qOfbpGGo2ACQd6BXfGMTzwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by TYWPR01MB9987.jpnprd01.prod.outlook.com (2603:1096:400:1e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 00:29:03 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 00:29:03 +0000
Message-ID: <6e0c87e0-224f-c68b-9ce5-446e1b7334c1@sord.co.jp>
Date: Thu, 1 Jun 2023 09:29:01 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Horatiu Vultur <horatiu.vultur@microchip.com>
References: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
 <7d2c7842-2295-4f42-a18a-12f641042972@lunn.ch>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
In-Reply-To: <7d2c7842-2295-4f42-a18a-12f641042972@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0215.jpnprd01.prod.outlook.com
 (2603:1096:404:29::35) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|TYWPR01MB9987:EE_
X-MS-Office365-Filtering-Correlation-Id: acf445b9-f6fb-4eae-b692-08db623733b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LpROF4Z3GT/Fdl9VTwekOLUjHPdSFF7U1T+hdw/A2ZCWbUAxUvu6hKd1AbVC/4meeAfroTxj3a5KF0/qpRofgwnxdpo5qA+ZQwE2xkiabaItcnEbg6sIfODNlNKS1ILImR31y4Ww+7tc7zvuCiKcXhyELKgeWSQyFk6XA5V8AYRm80OcKiVM7gRry5hoTmY7/vnFBs2ESyDVlBoomoEsbzTpbuj2tyLRF6j1//gM7SrjiL9Hyz3GhEaHpAzbY4kULhctMPH1C6FN4Y8dybEi3UopSed31zcetAcMiUl+lvZmkuvoToexKBCadkYbuG7ii0QKF/u2RVmPdE77khnekUnm5v/cyfa/ZUCK4tkxjeOiM54nYgOf44jqljUgtUx/eXBCGkHqBLouM+TpUWiS3t4iyV8ZwVdn7yREnhwA05X3trP54hXBWvZNZf1toPs8yX2H193UNY/CtDKPkpviD2fEGVleejKbol3c3KsKapoy/mvRBoodJUrb13V93YYNJCc+XpiSp2wDqeea28Q4pxD4Gn1GUpbIijMs9pvABNbfFHVb1SaPViimeQX+ZQ2WgczEJYU9EHPNb0po0rTkbc5y33kbxOKAIqHZjI6Cew5INNrWVsFly8WvubZRMniEhHnRSmx05MQZ+7YOdd5Q1w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(39850400004)(376002)(346002)(451199021)(31686004)(83380400001)(53546011)(26005)(6506007)(6512007)(41300700001)(38100700002)(186003)(6486002)(2616005)(478600001)(54906003)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(5660300002)(7416002)(8936002)(8676002)(44832011)(2906002)(4744005)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDdCeGEwWnBwZyt2MlQ3U2ttQ0cwdTZrcGlqZ3FMNnRaVWloQTgrcG0wVFh6?=
 =?utf-8?B?cGNiV3Zrc1hHS3Y2NDVDeTV3QkJVN1psQVVvZmxEY2phakk1RDA2d1ZPMjdO?=
 =?utf-8?B?MmtKK2pCNWJhaSs0MjRYbjlBci90azFQOWpURzREdlFwNzEydHJxVE9mUmpZ?=
 =?utf-8?B?VVZJRGdFZ0pNdlI5a1hQaW8zdnp3N2QzekZoQmdIU2ZuQlVDeTVDS2tHeGNK?=
 =?utf-8?B?WTdpSHlQU0dEOU05akR5SVVJd05PRTFOYjNPVHljK3p4amdzNVVFS0V1VmVL?=
 =?utf-8?B?QTFRVWdDeDJybG16RHBFM3pkVVpvSzVjWWV3VlhjK1VtWW5LS00yZWdjcGJR?=
 =?utf-8?B?cHJqM3A0TGhlWTJsVjQ0VjU4MVJFcXZXZUdNdGdWRVZzczRmdXlCTlBzRUZK?=
 =?utf-8?B?R1hZRGR1MUdHY0J1aFN4cVpJTGpudld1R21KWWpwdmdIZExaVmxtWktPYnFk?=
 =?utf-8?B?TnJlaHZINlNEYkxxK3hqY29PcFFUMnNmdjJjakFyRzZaOEQvNEdVVnZyaG5M?=
 =?utf-8?B?MzFVa011dWhYaWFzcmp6OFBVVUtkOGNyK2RmODM2STdvWTNRSGhQWWFaNnBL?=
 =?utf-8?B?RytsbXJWdS8xNmNYanF5TzM0eG5OTjdtMnR3TWk1TkZGcXVzSEpRTWR6ZnVo?=
 =?utf-8?B?RzNsMGxUZmNINGJ5T1JSVzE4WkJObTZTNk5BUC9uTmtrd0I4WDQ2algrMXNI?=
 =?utf-8?B?UHJNTU1MSlphSjdudm1zcktQQWRLZzBEa01HVmUvNUF6WFN5VTU3SE13Sk5h?=
 =?utf-8?B?NGlmMTBsSFZsYTJjQWRYa0krc1oyUTJLTUJydXMyRDV6Nk4wbXhFY3ptTXgr?=
 =?utf-8?B?U0xOTi9NUzdsbW1idHpDempPZGVWdWlhdEtCc3hScThvNFBVY3JyMXdkZFJp?=
 =?utf-8?B?bnlDOXBlVXFLUnFyMnQrck9ybEZkNUNFUUM2VEVHT1FmQ3ZaZmF2WjlDY2VT?=
 =?utf-8?B?S2ZaSUJuSVkyNCsxUGE0S2ZVUks1TFJ2bU1DZDNUb3lucE14alpXOWNuZmdF?=
 =?utf-8?B?bjR0R0JnUDluSm1SYW56V1FFc25jdWdMTzMzaW9mRWhQbmNOKzd2L0J6Q1Zk?=
 =?utf-8?B?UE9ZUThybmtidWRUK2lMc0x2OUR0T2dBSllYYk5rZnBZbmFBOFRzWitySnFl?=
 =?utf-8?B?SVRxOUF1cm5yMGVoNzBCZTZERDNndTBxY09xanFoc1RaeFBveUQycmdnc3E1?=
 =?utf-8?B?SXBqbGM0Nm1XeTQ0K1VieTljZUlQdHBVUjVpNUhGdkRDQ3RDdFE2clZ5blUy?=
 =?utf-8?B?SnQ4ellqeTZwaktKSS9FdFFuR0txUGhaS3FXY1NJSmJEOThBdjBkWFFSdFht?=
 =?utf-8?B?NU85ZFJycTRSR3Ivb3J1TXk1MjVWaXA2OW91NjB1Y2Z3OG9VVDlPaC9oTC91?=
 =?utf-8?B?RHQ1RG1la1JtVGhwd0dLWWlCcm9iY0dsMURMUkRTems1bG1LTlAxL1Qrb3pE?=
 =?utf-8?B?SVJkYU82eHdSWFE2MmRiQnNpQ1FJN2RBRGQ3US9qZCtWWERZeHNJUXFraEc3?=
 =?utf-8?B?UEZPaE5maTdqZmlpQldMRHpyeWZrVHFqZDlpNXlKckozUUNhVXlsVlFqdE81?=
 =?utf-8?B?SHFSSEFVaFNsNXZ0ZGtyN3RIak80ZWxVT1lCUWROOXVMYzdsT2Q3ZFdvSkxW?=
 =?utf-8?B?dnhlSGNVZHlCUXZnaFowaTFtamN4MGRGclJYZTFxcklzZ295OVNYN0J3SWhu?=
 =?utf-8?B?MDl6eGwybVNIVnZmaU55OVh4SGR4S0xmSHJOdnc1T1gwbStxcmVybVgyN0hx?=
 =?utf-8?B?YTNiSGNUaEFoN044MEtUVWpuQ05YdkgwaHpzMkpRZzROY0hXbWRxZlNFbnM4?=
 =?utf-8?B?aDRodmlUK2FzbkdFYXFWR2gwN1p4Mk84NmFoOUlzNFRHUGJFR3lGTGdOMlFV?=
 =?utf-8?B?LzhSWUo5ZWRnQzhlOFJYTXpSL1UzRW93VEcrVDZVUVRmRERUVFpDM2RNZHln?=
 =?utf-8?B?bXNJYTh4V0lNQUpOUS9manJRb0swdzZLaWc0ckxjaTN1T3gyTzlBWlFielJN?=
 =?utf-8?B?VkxLSUtXaEh3R1IyOWg2LzAyUWZCUEtuTTNDWm1aTnFvbzQvR2lhWVFCSktG?=
 =?utf-8?B?S0p2dHdadjBSSk1MUmpOTmI5amp6Q00zTlE3cldiZldBUTNJNk1KMzVmQS8y?=
 =?utf-8?B?SnNtUG1ER2J2V3A2V3hXMWRsdWpYY2pIWWNqUmdBNzhhMzh5RXk5eGpDMmhF?=
 =?utf-8?B?SkE9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: acf445b9-f6fb-4eae-b692-08db623733b6
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:29:03.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGwT75MPwdxmaFneqS5Kgb1BRtpMhh6f20DRJ4U1RljVv2f+tMp7x4/sNWfYrITmi9Yuya3Di5AhUol5K40ajlqSN9SEaFx8k98qx4tV3oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9987
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/05/31 23:35, Andrew Lunn wrote:
>> The ADIN1200/ADIN1300 supports inverting the link status output signal
>> on the LINK_ST pin.
> 
> Please could you add an explanation to the commit message why you
> would want to do this?  Is this because there is an LED connected to
> it, but its polarity is inverted?

Yes, the LINK_ST pin of AD1200/1300 is active-high but our custom
board designer connected it to an LED as an active-low signal.

I'd like to change the description as follows:

---
The ADIN1200/ADIN1300 supports inverting the link status output signal
on the LINK_ST pin.

The LINK_ST is active-high by default. This can be inverted by the
GE_LNK_STAT_INV_REG register, meaning that link up is indicated by
setting LINK_ST low.

Add support for selecting this feature via device-tree properties.

---
Atsushi Nemoto


