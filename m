Return-Path: <netdev+bounces-7088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F323E719D21
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD66528149F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B0BE553;
	Thu,  1 Jun 2023 13:17:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD523414
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:17:06 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2043.outbound.protection.outlook.com [40.107.113.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA213124;
	Thu,  1 Jun 2023 06:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnsu7xuwi+ELdKbUtL8dPmY9gDLgnnoCcp5yQx8+0Ob99ZifCO22wydliem697pa2WcvntMBLGsmeDO39vvnP7Hux2MHloUlycEmB+FkTUgWvp+xRToZd94oQcJGXrlYm138LAfQdi+emfy/kdv/Ehhn9rcbfMV/svhTo2PINBFxWGD2jADo9JiVUaDT4XWwVq9owcWTkvGOiShOZ/GZ/1E3QQVhAfFCLbdxL658QjmNsUxEK26jPmVaTAJZrOiaXeLQ8AOABjrQoRiXI4ddyOfhyg+RUaL6sTl7y7mQMNWi9onL8K5SZDp2t4dsCBMtCW/2clKtZzgcgyGknDG2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01hlhArD4A1xNTll2cNQg8qlvypq21YNU/ag1kHgvIc=;
 b=XpGKlMYH5kupF6RbcYxZ3CWibhWfZY5YU2gdfLOax2d8NGPqEJs4YcCtEbiED/TmPwpe50XG6XWfhRm2a6SC+dmcLlvQjlMfsC+uLWApc/mMjlVR9Yku6fR6AbT/qnR2x3hjMOJci4UYzGd7AJcTi1HmLVcwVq6opQSHjPmeQNg3S4TCiW2GO4BNjeFVuYULdBoRkH+ztfbO8DkRvIUmFUavlTa4IElBtzIAdXXSWQaqnoTG/uKDuqgi7sbfWhK6I8ZKJbFIeORLHtwc1Y4GX+X8jKY5BjfcoXRco4+HE4l8Aindl6MT22s8Az6jRMfYedVcDY7AlzRvlkX5lyoqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01hlhArD4A1xNTll2cNQg8qlvypq21YNU/ag1kHgvIc=;
 b=Ee/0J+jUwBdPTGaDm7NW/qVQDzEbzvQUREgyjD//86g5rZNuJKmOciMb31vW6LE4MEkm1SAI7vUAUDZdF0v5BEhiXMS2PT0Un+8dg2ABhwSPsrHPnkUzQjs5middEyo3+no7O1JC8X6fnpfKCQ4i9+R2Ar6AYM47T2o/nkJGZeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by OS3PR01MB5992.jpnprd01.prod.outlook.com (2603:1096:604:d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 13:16:59 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6455.024; Thu, 1 Jun 2023
 13:16:59 +0000
Message-ID: <50ae1bda-3acf-8bce-c86c-036bc953c730@sord.co.jp>
Date: Thu, 1 Jun 2023 22:16:57 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
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
 <6e0c87e0-224f-c68b-9ce5-446e1b7334c1@sord.co.jp>
 <8cc9699c-92e3-4736-86b4-fe59049b3b18@lunn.ch>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
In-Reply-To: <8cc9699c-92e3-4736-86b4-fe59049b3b18@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0188.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::17) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|OS3PR01MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: c912a2ae-ddd5-40b9-f045-08db62a27b13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TDR3nPlYKEm5/LEYfvb3eVwDU6SoE6glRHv11fJfZ1ZG6/wvfBP2QY1uWW7vP1Jlzq6IQqlnXGf8ZI5NsS+3mctymQhCtM9Z2jvuMC+LRoFq1wkvVZKoObaxrrjRtkdM90LgXIy7Q3Cl/W0k25QR3rNJCbzyUhfuw5KZ72seFmLcfZ6M3mvDJWIQ3MA1cht51dznFM6XaPHn6T2CK3ptW35KLdAoezKJauyhgXHzYgMqDAidwPKCqRj448x/dlETLowsZpnJW0dFgm2bJtFkG444ZEskVC22eCOurjUQyD8VogZ/KcOsNmGcSRvN+xzVRCZNK/Q3wX1TFk0fWToj+wqXuQ/dOz1n6OwnRFWuDz6OkhO3f40sipb0UaJgLR1gsmfox/FLS8e2Y31K+HC+jIinR6iExHeA5bqTHDA7Gs75OxH0SoB2YXS9aO4/ryVfnH6Sl8KoijNdsX6TIy4n0ybz0XBZkXd4L84Bfe6S8/K9syvsWy2iFzCuY5n7zwk2OadTRmwPNd5BPkt7CmY3NZXRC3sIX64Q/Iq3pVfPMTUe3lnGzdEJDguzo0jhQ8OdwXzTI3h0Z9vPpFtt3+LtLyCSqLfCZM4V0MJq1E9IEwQQ2nU6zfFAceQWqYTSLFg0j91DB95p2WaCdvWi5zbqXQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(136003)(346002)(376002)(396003)(366004)(451199021)(5660300002)(478600001)(44832011)(2616005)(7416002)(53546011)(186003)(2906002)(4744005)(54906003)(26005)(36756003)(6512007)(6506007)(41300700001)(83380400001)(31686004)(31696002)(4326008)(6916009)(38100700002)(6486002)(86362001)(66476007)(66556008)(66946007)(8936002)(316002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHVjU2ZjYnlTZWlLeE5PUk1lS0RwbU9UV3VwVDcvSUF5UDI4VGVJZVVPTHhk?=
 =?utf-8?B?VWFUS3F5ZkM1aGJRRzU2OWF5cnF3WTVLRmZyY2VpT0tvaXhDQVRQektLeVRs?=
 =?utf-8?B?S0pYdXVlN3BMUjY3QlpIZHRqMW8wWTQ2dzlkOHc5UE10NFhWMXllR05MYU9x?=
 =?utf-8?B?RDFVR0o2SVpmK3owTDJ3N2hDMGFnaUZGSUJZWmRKeGRUTTBybjhvK2ZublVI?=
 =?utf-8?B?aWxmYng1TS9qYTM4ZnlKeUVmQ2d1Y0dlWjNMMTB3OHYvS21IMkMxMXlUVHhB?=
 =?utf-8?B?Zy90Mzc3d094OG9nZnhmaXJKbEIvZVhxTHk4N01nY2RYM29sS1dLeG1WY1Fw?=
 =?utf-8?B?VzRWQk1VVHFPK2VObTM5K2NVT0hyRXEzNTJzZEQ5bFVVUDlpYloxT2gwS29u?=
 =?utf-8?B?eUVxa3E3Y2dHMHNjSit6akhBbzZQN01qM2ZadFU0RHVjRitBZHJXQjZ4azBt?=
 =?utf-8?B?SHR2dm9rSG5XOTJsWEZ5OGdSM1U0TnppZmI4cHhuUjhTQlkzbDNnVkI2MzVN?=
 =?utf-8?B?eHhUZlFRRVBQeVJIRGVpNmxrUEtyTHZuSUtIQ2Nac082UmpualNJV05YbTN6?=
 =?utf-8?B?N0ZLaDZueEdrSmhTSXJCUElMWXJWTXBOdEZyTlovSTRrbHZwUjlVZ0M2S3oy?=
 =?utf-8?B?VmttZnhaNUZQUmZ6ckpuZlpPbTNzWEJST1RSUU9EQkZlT3BGTXhhTjVjcEZB?=
 =?utf-8?B?R0xUVzlkYTd3MU9sVzdkMUdGekZYWW94VW1DUFlESEdDQTR0SzZ2ZHZMOW16?=
 =?utf-8?B?RWlZTDZnMzdIc0RFMDJpQ2UvMFozeWQxbGFKU0wxWkpZeHJIZ0NreU1KeFpS?=
 =?utf-8?B?Q3pRY3BtV0I4V1I0ZnBSU0dsajVCUlh2VmdwRWVoM21QU3pVWHorcmxSM2l1?=
 =?utf-8?B?am4zQXhSWUhUVU05cGpDZ1gzYTQxc2NsNzVONzZGdk9pODl3UEpBK2x2dG1p?=
 =?utf-8?B?SUZKSFZYTXVvSXU2c3djOVdiTUxUc1RvTDVLUllEckJ3K3N1VzN1c3RQeXYr?=
 =?utf-8?B?V1ordWNtZ3FmN0NIZ2ZwdVA5ZFRyWXRYZG80UHFvMFpUa2dzMHI2Z0hoZnFp?=
 =?utf-8?B?b00rVmhoL0VUUHVhUm9tZzZ4QXBuWTlXSEptcWtvZVhwNzhmRVdLU0ZPaE1J?=
 =?utf-8?B?emJJakxmcjY0anpJZTFJWFBUbjJRR3F4OEZaUmNzMk9mU0V0WjUxWi8zNnRK?=
 =?utf-8?B?dzVtOGxUQXZLOVZ4YmFMek8xTGxueldMa3kva0hqRDQrMi9oa25TQy9Ebk01?=
 =?utf-8?B?TGo1Sm5oZDFKTUxVMmdoNkNtMEs0dnNTN0drK1dBallZank1bXYwbnpYaHhw?=
 =?utf-8?B?VE0xb3p4RUdhZjFlSjlkenZ6UCtvWVdBc080L2hJc2lqTHdzM1JJSlp5S3Yx?=
 =?utf-8?B?aWtnOTFyZU05dUxpSHpmOGx6dnZieUNaVXV6QXhrTkNEZkI0a0lKOGNyL1Fj?=
 =?utf-8?B?QzdlYkREMDBrcWVTOVV6Z25uaENhNUNsN3NtSXR6N0hSSCtFT3RiZGdCdWx5?=
 =?utf-8?B?TDBEamcvZ2ZSNFRBNGVWbnBReXlHeXdOZit5Qnk1QURKMWpBZFhsT3RNS1Fj?=
 =?utf-8?B?cnBkcnduVjd2YVdiQlVseldHbm13bFdmL3RPMmpIWHk3K2dEWVg3Wi95SmRC?=
 =?utf-8?B?WkJrZUJRODlIMnR5NXExVmQvTW9OWG5sTjhibmV3WG9yamNKOUlYTnJUVUhP?=
 =?utf-8?B?UG1LdzU3MTAyc2ZzaWhzaXI0bGo1Z283a1puTFRnN3lNYzgyTFBuZ1lWQXdZ?=
 =?utf-8?B?Rk1MaDFodDdTMDJXelBvTno2YlJOemlhM2l2RTdlK1Y3TnlGZG5MWm4waEJ0?=
 =?utf-8?B?Y3pOcjZRZ1JVc2Y1Mk0wTGt2OWRCMndLSE03RElrMjNqTlQxOEpObGNjVlUz?=
 =?utf-8?B?Z2w1UEN4aWlNL2c4MXRFOURQV2ZGWmhIMlZUOXZNYkIrdDJLcWtTclRneWlT?=
 =?utf-8?B?UzIyVWZmMUZERTJqTkh1TUV1dE9PaFBWUk5HVXRkZlhLdmdmRS9lcnFLUGt0?=
 =?utf-8?B?VisrUHVFdXZRU3Rmc0lLeXJNaE4xc1U0ZFgzWVZUVjloTEQxRDc3ek1CeUVm?=
 =?utf-8?B?TUM5dDFMcEdsV0N4YzJSRkhDTC9vcUNJTnhpbXo5eDFCVnk1cXlRY3pidFJJ?=
 =?utf-8?B?dGVMTzhsUzRLQnEwVFNoekZqdEp6VzAxNVJWeFJPdHE0dElVdUZKYlhncUtC?=
 =?utf-8?B?TWc9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: c912a2ae-ddd5-40b9-f045-08db62a27b13
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 13:16:59.3877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0vUl8lG8cJ11A+IpbFHJV7HQn3VzCQTwnit7sRXKxcQXO3rg6UgRsJ2E0lWivC026LVN2Us7C/JMEGCmbHcMQUmRAuNR4+rshAbWkz9ehY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5992
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/06/01 21:28, Andrew Lunn wrote:
>>> Please could you add an explanation to the commit message why you
>>> would want to do this?  Is this because there is an LED connected to
>>> it, but its polarity is inverted?
>>
>> Yes, the LINK_ST pin of AD1200/1300 is active-high but our custom
>> board designer connected it to an LED as an active-low signal.
> 
> O.K. LED is the magic word here. And the fact that there is nothing
> specific to this PHY. Being able to specify the polarity of an output
> to an LED is pretty common.
> 
> Please take a look at:
> 
> ocumentation/devicetree/bindings/net/ethernet-phy.yaml

Thanks for your advice.

But in this case, LINK_ST is also connected to MII_RXLINK pin of
the MAC module in SoC. MII_RXLINK also expects low-active signal input.
(though I only wrote about LED, sorry)

AD1200/AD1200 have another LED_0 pin and it should be appropriate for
the LED subsystem.

So I still like to use this device specific property device.

---
Atsushi Nemoto


