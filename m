Return-Path: <netdev+bounces-7105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEB2719F93
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BC851C20FD3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D1F21CE7;
	Thu,  1 Jun 2023 14:18:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3155323423
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:18:16 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2075.outbound.protection.outlook.com [40.107.113.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E218E;
	Thu,  1 Jun 2023 07:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdT1iZuZMa+LGRtXsZXCG60+iLqtyBrXwUzCRMRBMvrGhMQA5p2AxIHgNzycZPVbEGAwH5y6M7ghqNe2/w6ExJ9LXv/hFJgdNIBOTfR5KLgm6xEnZE6TfHPfg71pM9iN2TfNLVU3D0lepfTTRDrY2ORlyqCQHrxtH8wox0kgdQg7sCP6qcQ244xDyKqXpoFCdIjyWCgm+jb4mzgUr1fqK7uqr5V1MTsuoL9OXYSCFFIrJEbIv6VOLWgw/DawjW36fW2/T75k8O6EbT5y1dH38GnDb/zG0KE2RRrh/bQFXMDIenjsHF/k70wHP1qMjZEJvTJJrqJDxFvPPSi6IetvAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMPIfiubD7Orf6U9XKO8Y0nmbLqoABVhuumwQXdzV6E=;
 b=d5wJYIazmj2l7U2XcXN77MHQVZCucMiN/u7yEMiVElzsSj40P1lu7UNPKxJTp9lh/exoQMdQtZ0Rn+kcCEB8X6MyN9QRS8pj3BhcEIDM7CidNBHaWx0YI36MIdeHlj3X3UPwPG2PiiTXfiyHj4bS60ndJN1AGfDEmYvVT4XSL3gLcK997AFG5pterBt/MGUdzDmmKaJWY6S39afKwEmAhNqvaxRhZTG0TATqMfmMDJZ7hiuSablSbczY3hP02WjJZKN5he+/tYvOZZmoQehGdeS8IGDmRhrh+TCqTklwQ3m2xWE8V9jBE2j/R5DBgh/O6sq8zfqqRg/Y0pZ3iRYl+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMPIfiubD7Orf6U9XKO8Y0nmbLqoABVhuumwQXdzV6E=;
 b=WycEz7UK7VbNfAKNrkYGbe+8USquv5KRIM4SyUZ6JZBeM8bFR3Ky7H0F8lHKkXYML9T715sziSuIGPCEbyd7CV81jiV0MkjK9AW2Y3UydV1RFyd4Pv3gmHbciB1ywz45jGtbwaQl3TNxoaQAepM40UNHEODvF/ihlsWWZc5EaqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by TYVPR01MB11213.jpnprd01.prod.outlook.com (2603:1096:400:369::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 14:17:54 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6455.024; Thu, 1 Jun 2023
 14:17:54 +0000
Message-ID: <919bdf79-1b53-9578-b428-a8ad969ef0d6@sord.co.jp>
Date: Thu, 1 Jun 2023 23:17:52 +0900
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
 <50ae1bda-3acf-8bce-c86c-036bc953c730@sord.co.jp>
 <cc5cae94-effa-4246-85b8-8d3ec8fada66@lunn.ch>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
In-Reply-To: <cc5cae94-effa-4246-85b8-8d3ec8fada66@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:404:a6::20) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|TYVPR01MB11213:EE_
X-MS-Office365-Filtering-Correlation-Id: 15f13266-473f-4521-96a2-08db62aafd95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LV3JFOUUPyvjmWW6gY2296KTXk69YMgmH12erp3RS/efyI0IsqlMOGUaIoJQmrZl99YXpKzrcpVP4uWx0oOPaRD9vu0ChAwMUFDPH0KcS+tR2kAGi5yk1V89bqwajuXAwMktpxToVsyPs5Ywd5WIpG3IJIfZWsZT4cyHkuzTc6PttS35W9u6/rAObh+6hWYISO9mHAiz6wTsPztUBa3DGstwkmABqOoZExSLOjj3Li5VEdpqrhevowg4OmQQofeHRMQVice1blcTlrq2SYZuYMNMfoRdfXjKsY0OZres1ixwqBID+8WUaSf/UCN97n5ajB684F38rdibVHvF449BIWnGzLV+T6Gxc8hvGLvfCSpZ+InQ6xVPqrC9G0Rhcqs7RWr1nk8OFXXlclcXT647gnV+hBVPcuhu3bznDotYnoWggKUwgrXuFws7H7AKbs9AXW6yndGYdX/Y8CzIjD+4JfpaDq2GfMA2hr0sUULnHaJO7J+FXp8qkch3yxuMzgB4qeBen+44Vxf/30GqHWdtKfkX0u+DiY6aVccxKnqYYrHjqUKVYkg3glw5Rj8UVHu4J5HecdBNuCJYuiTUbd40TrAq3HMLG3U09dtvSm2ijuXlIp5N7gErxzVk+l6i2i94c4WSInoCsQe3gdkOqP705w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(396003)(39850400004)(451199021)(83380400001)(66946007)(6512007)(6916009)(66556008)(66476007)(26005)(6486002)(53546011)(6506007)(966005)(478600001)(54906003)(2616005)(186003)(86362001)(44832011)(7416002)(5660300002)(31696002)(8676002)(8936002)(2906002)(41300700001)(36756003)(4326008)(38100700002)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnhWVU5UZ0xSWlMzZzlqNVU5SnlhUW1sK290UGwyUk5rMDJZYktqRkJTQnpN?=
 =?utf-8?B?U001MjRmd1NwaHkrVlpYQmlYSDFCcjlZNnNrT1RhSW9zQ2QrWnhmU0NDVUo3?=
 =?utf-8?B?NnJIQ3RDcHlQNXZoM3FzU1Y5MExkQmxxdU5ISWlibGxVVDluZjhObHVwdW55?=
 =?utf-8?B?c2tKdHg2QnlCY25hdzFUQkFZTXI1UHFqTXd0RFFBdkJqT2Q3dE5KNWIwZHZn?=
 =?utf-8?B?Y1d3UUZoQVZvc09ySmlGcXZjMTRVblVZQUxhTmtwQ0FpcTV3T2RoMHhzT2RH?=
 =?utf-8?B?WmV0SGZ6Qk1LL2xZTjEzSDlnUWZRTjRES0NiNTBjbG40NFBRY1lUNkJ1WWxy?=
 =?utf-8?B?YmVnTTdacHBoVzEzK0FYd3ppcjJ4eTZXV0EzMVFsWWExbWEvTmc0TGNDTlNJ?=
 =?utf-8?B?QThwUGNkT2p0Yzg1dCttdVNrbHNXT3RLbTFOM0wrUlh3WmQ5bzJsN2Vud0xD?=
 =?utf-8?B?RXNjdW1ldllkclowNFZKQXMraVg1angvU0FiLzhTaDRyK1hJMURFTStMNHZQ?=
 =?utf-8?B?NlViMkdSYnYwREI0UXZlU1hvd1h4K3IyTnBxa3pUc2M3VVUvVWpsVzl5SGN4?=
 =?utf-8?B?ZEk5RDRwQ2diZ3ZUT1ovbVRtZzQxcWRVLzBYMW11Y0hNSnZRNFVDK3oxN3JM?=
 =?utf-8?B?NzFkMVFDS2Z4QnR2ZFJmYjZpbFZXYW51VFNmeFVqdi9qT2ZEd0w1UHRrdW9x?=
 =?utf-8?B?UUdReGdkNGh3Rk9ud3VjUjQ1SHNuNkNDOGJKWmJXUEM5a1hSTlZ6OUxsZ1cv?=
 =?utf-8?B?emx5cUpVZytERWlUMjZWUUcvSWtRMjAxdEp6TjBKQy9IeDl5ci8vZGZDd3po?=
 =?utf-8?B?Q3VXZEliSVl0WjI0eXVKcWRGQkY0OHZXVzhzeTUreGxBRmlObmp4UjZMMnN2?=
 =?utf-8?B?amhhRUpqQ05zb3M4ZXRlbUZzNkxGYXAyanlJOWxZOWFNU1hSUmNLMXdJdDJX?=
 =?utf-8?B?QlNZTlJ0di8weFhrN0lYeWJ0NGxmMzFZZkNGTndUVlJ3RDVxNmp4TXJFc3N3?=
 =?utf-8?B?TTFWWlZuMURERHd5SkZFRjFZbExiU3kyMUNtYzhCeitvT1ZrNHJmck5vdmJY?=
 =?utf-8?B?TE41Y3ExWDNLZEFGVkdZN0FXMHdwTnZuYmEvZ09HcUp4SFV4MjkzdFV5bW9E?=
 =?utf-8?B?K0ViUFI3L0JyYTN6YlZsMmdKQlVuRHVrVDhTWG9XVUtxMjVoVFRiR2lWenZZ?=
 =?utf-8?B?VGxFK0ZmeW12T3pMb1JlQ3NoMjR4N0FlNDY1ZkZweHNQYTU2NGdYTVIwWExs?=
 =?utf-8?B?a2w4Y0tWWGdOQm4zK3ZiYy9yN2ZCN1FYNjZkRnd5MmxoS2wzV1pqNURtZ2lR?=
 =?utf-8?B?VSsxVW5kR0txOXBrRGd1TTl0YnVLaGVSWklGYldVVCt5RGs4eHhNc29QWHAr?=
 =?utf-8?B?R2U3cmdmR3pITXl5R1BndjRGUEk5aWs2WnFRaVFGTFF3b1dnMnFyazBCYW1S?=
 =?utf-8?B?cXJjelQ1VFlSZE5BQm94a1Jyb0xWRHl4ZVdGWEZmQjNmSUY0ZlQ0RmFQZ3JW?=
 =?utf-8?B?Yy94TmlaTWNjVmx4MFdVcmhETVpMOTdnVkdtM2J5bmJKWjZpaDlKeG0zL3N0?=
 =?utf-8?B?ckNMREM2cUp1NnQ2ODdkUUV4ZXIzS29uOElsQ0Z5MVVscTFON1E1T0NjVit5?=
 =?utf-8?B?c1I0VDAzK1ZOeHFiRGtkNC9CQXEycklPRlBTS2xKc3JHUWd3eGQreWhzU1NI?=
 =?utf-8?B?cE92Nk43eHR6dk11UjRXaWdxaFNLN05mQkFsK3FoZjlpK2JFSEJ5WXNZaFp4?=
 =?utf-8?B?WTZjWEdEeFI0Y1BRZlNTd2ZZaXR6OCtVUE1waWh1eHVtSUxBelhYWGdGMmI3?=
 =?utf-8?B?R2JwSjdBMmcycU5ycmI1Q3lnSUQwMDV6YlAxZWxxVHF0ckdFRy94dEZhemdX?=
 =?utf-8?B?eW9ZSHZheFBRWUo4TnBNOFo1a2xxWVQwYmJyYUtUSGhYTXluYjNTTzJPeU00?=
 =?utf-8?B?azFZdmdGTHF6d3BYMUhRY0tXMFZPbVFvaTdQVm1wZkhPdm5sTHlrbUxCekJ3?=
 =?utf-8?B?NDBFLytSb2ZmVWJhdkIvRU9ScFVLUkFGZHd6TEZOajRabG9YWXBwYjI0MVpI?=
 =?utf-8?B?ZGdKSWlneWRGaGdUcHJxRDh1YklFNUVtSlBPdUV5ampPTFI5UzJBSi9vK1Fy?=
 =?utf-8?B?YWtlZ0tSVEtNbVNlSFdkVTd2NGNJeXEwVVNiQ21tR3lmZFI3M3kvcE9maWYy?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f13266-473f-4521-96a2-08db62aafd95
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 14:17:54.2368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tmlg79J+q154mWcdZosyBDCoDPCOWs/EMAEGyBhuiy4Za2tnPFE+XchLVWf+x+yt0m5CoLp+WEXsz2n0lwWTL0C+UUi7CunLKcZMpQ89Jtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11213
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/06/01 22:36, Andrew Lunn wrote:
>> But in this case, LINK_ST is also connected to MII_RXLINK pin of
>> the MAC module in SoC. MII_RXLINK also expects low-active signal input.
>> (though I only wrote about LED, sorry)
> 
> This is why the Commit message should contain the answer to 'Why?'.
> The code tells us 'What', but without knowing the 'Why', it is hard to
> say if you are doing the right or wrong thing.

Yes, then how about this?
---
The LINK_ST is active-high by default. This can be inverted by the
GE_LNK_STAT_INV_REG register, meaning that link up is indicated by
setting LINK_ST low. LINK_ST is not a generic LED signal but a
dedicated signal for the link status. So use device specific propery
instead of a LED subsystem.
---
 
> O.K. so the signal is also connected to the SoC. Why? This is very
> unusual. The MAC does not really care if there is link or not, it just
> sends a bitstream to the PHY. phylib will be monitoring the PHY and
> when it detects the link is down it will tell the MAC via the
> adjust_link callback.
> 
> What SoC is this?

PRU in TI Sitara SoC.
This is actually a Software MAC controlled by TI firmware. So unusual.

Please look at a block diagram in this page:
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Foundational_Components/PRU-ICSS/Linux_Drivers/PRU-ICSS_Ethernet.html

I don't know why it needs MII_RXLINK signal...

---
Atsushi Nemoto


