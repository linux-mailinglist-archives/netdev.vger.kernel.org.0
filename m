Return-Path: <netdev+bounces-11931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5FE735521
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DD501C20324
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C3BBA32;
	Mon, 19 Jun 2023 11:01:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E2CC123
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:01:41 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2083.outbound.protection.outlook.com [40.107.105.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26810C3;
	Mon, 19 Jun 2023 04:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dR7o+6hSmlAbCaeKAxnytMC8gT6yDDwkYalKkZX+PXD5iEtzbg48EB9X1y+qzBjagpRJcZ2erp0+dPoNb0wK9TfHki8Mmy+/OoDpm3gzTVwxGlH3cS5D1NQ+M8vAn7JCCnQWOljqhBXvquR0IPnSw+teyaj766hurCRPi7wUK7cWwPvEQNir3ZkU8zBA93mNG5mOm8Wml6zhu0yQ5Uuj97AjsIFyXhk7mT4Eb3BE2jZTXvW0hbVb40tPwJcXvo63TTzmhqpQ3wAzDFSVZos2ZdlfwGEwUVz+sPmFYKos+JEmykAXm7ncCFfxXlauLaOgDIVQ7G059cWbZHQHZB2kOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/VirKOb/VegtRN9ukliv7S7P/NBISFaazgMCrLHwbM=;
 b=HjzvpQWwnqJEeXWqh1SuW8W9hQ1BHHRca6J93DwJ47UNjgGzcRS6L9WwSwotX4UXZeB9CQ4jz4W6+jbRbazizbSecH2zMBAtutgaT9zGVsf6BrDkSqcTWKGGRd0j022JZtdlZqQ6RgmpV7RurwU6V8OczVsMzPDy7Fn6PNdVn+87NKBM7xvaadEdErtX45W8ZxG/DQoxAAGPMxFiUtyVhE8EwynMXpV1UsgS5WwLLZ/ldG0/V+twk/uQl/JaXKqEfpJPZqG9vTqAMoYY/ZLic1qbkP/8vNfEKitfrgTcQ/dqGnI8ib56uA1jmFDkWT9is+7UBY86FSQpYPGwwTDRwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/VirKOb/VegtRN9ukliv7S7P/NBISFaazgMCrLHwbM=;
 b=DpjYXhFn9sj+zP6TL5M7FhFe8cn+QPa8CM1D9ICWosLoLopNKWdxXQ23/vglTkAsMbkU51YysleoJAaszQxBhQJlUtHDfjMs73/uDCsq2d2dky2cMcIo/Vqah9xLSD7Hhvqd7fpzZ5VcXch2TabdFKmGKTWMIWgSUb5acVVoxBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 11:01:33 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 11:01:34 +0000
Message-ID: <8f172e44-3dc5-2293-8bfd-c5964ce8038a@oss.nxp.com>
Date: Mon, 19 Jun 2023 14:01:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 06/14] net: phy: add 1000baseT1 to
 phy_basic_t1_features
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-7-radu-nicolae.pirea@oss.nxp.com>
 <a1d6e35c-3f70-4cb1-978a-7b0cf3f63ffa@lunn.ch>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <a1d6e35c-3f70-4cb1-978a-7b0cf3f63ffa@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0137.eurprd04.prod.outlook.com
 (2603:10a6:208:55::42) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b1cd29-098b-4cec-0028-08db70b48bbc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eBYiXhed32mA5wQi/MysrS2VZH7HjaA8UHR2Q5zbigJpjNnaOM3oRnDmz3e5fAUOwo8z6Sag8nTaVidZsZVjrqGgwahcGaCS2WsNu3xmsq9Dora1brOIAwNKS4E0Az88pRbMjxXd8ZLoF3/nJHBqj+AME34BUBr6w0XyRfrzjAJHNFNZd484Ybc3Gt17aPdKUk1L6D4A6souip2E0p4lROI8cjdG2daM2k0nRGhnHNl1be5rN0alJLffnCcZ+WrTEEtQKVeuZ7IFB0g7vXsREQV3QwHKcnMfm6ATTjP/WmMpsKw3ZI27OMkl8fruhRCz+1Yoop64rWUKwuOJ3qpCcv2nV/ONYdnapXqjKIc+eiC07V98fscfVVabU5R3o41F7otdiOcjBtMAXXLNqr5b6RR1ixqwVaJ3aZ4vyYK/wJKkaFQMv3NBzoj3xiLdeopD7UIwuz42eHQG3lGL9e5+89fj/PRlSXjhiGKPICxGTd2Xnn2YWdLWv+slP5fcL74s4MrGDHcPkw5t/lj/YwCbfS90GMWN+6o3v18Mr3AHcSVOmvWDXk3VCnxsWOWgGtmweOPXS3bZ/GCY/5/ofYHGxvsSxURTfGHNLjDGmnjXLWMSGeld2/FjRcyLD0IEC9WyzLNGIovpjmUa/p3dF1o72A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(53546011)(7416002)(66946007)(8936002)(8676002)(66556008)(66476007)(26005)(186003)(6506007)(6512007)(83380400001)(31686004)(41300700001)(38100700002)(5660300002)(4326008)(6916009)(316002)(2616005)(6486002)(31696002)(478600001)(2906002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWxxZHIvRVdkcmczUUVLUTZkMENuUC9uYnFsazh5UnFnSGdEd0FXc2ZZdUtI?=
 =?utf-8?B?RUdzUXBJRlIzVlVlM3RITk1aTmpYditzQnhGNmRYOGRSdVpBWG9MRVRKak0r?=
 =?utf-8?B?ZGxXbWM1S2VENzBScWdyY3RiRmpKbHcvK29lVll0TDB4OFpkaXFhVnowSzVv?=
 =?utf-8?B?S0g4Wk5VUGowVVdvckJWWUVUSFZmSElpb2VSWUxieUVQbEEwZ0lCQU1TVjdR?=
 =?utf-8?B?VHlMWTlORVErS0htS0U3Q3FpcC85YzkrN2VCQlF6R2JoZEJueWVSL09DY2xZ?=
 =?utf-8?B?U1VranR3c0JOaStpRzJNMm5zR2RDWkVnK3RoVE1UWjJYaUxpVTFUWjZDaDNC?=
 =?utf-8?B?MmtjNmVVNzBqYlhKRGxZc25lbzRJUzRTRG1SKzhrbXl1U2dPbnN5eXV1MzZh?=
 =?utf-8?B?ZUJVdmNpSmZ0SjNET1R6RVB2OWorODdWWWt5VmxHZEQ3WEJLeGIwTG1jQ1cv?=
 =?utf-8?B?MlZka1ZqYzRpaE8vUEV6RWMvVGFMamZDMGxvY2U2eDlabU1oSXg1RjlJT2Jw?=
 =?utf-8?B?ZXNnK3E0dDV6dXdwUVkvelJkdkFxeXpWdzBJRmtuNFM2bEJrOTFiR2JQaGZ6?=
 =?utf-8?B?UG9qa2VyUDdra0kyUHdjNDM4czI0UWt6eldlajVsZ1IxaFNDam5hcWV3TmRD?=
 =?utf-8?B?cGk1OUsrTmdYTks4NjZ4T3A0T25TTTd5ejBSQ212eWFzUEh6ZUpXcC93VmNn?=
 =?utf-8?B?RjVtUG9haGE5Z2dIeGIyZWhRa1N1RVRpZHZ5UXBBUE96RzVBSDE4NzlNZisr?=
 =?utf-8?B?RmUxZEN6NWdURHkzSmpULzdER2ZscXJRdHE0Zy9GR0Uzd2x6L3NCWk5seU1l?=
 =?utf-8?B?TFAwbm9BTE1QMHh5WXpncHBiM2cxRHBQN2lhUGRxbUF3aGp6bll1QVhUU3Vj?=
 =?utf-8?B?TWIxQ0xCbWt5Wk9KczF6Wk05Zit6a3hyK1d5VHlUdnZVYlgxTmNxeU9namk0?=
 =?utf-8?B?ZndEVUg4Y1hMTnErTTYvQkM2Uk1hbFNGYmdQcGtndk4ycHBvNG5WZjY1VlEv?=
 =?utf-8?B?aENaZStxRldiREFET2NuTjY2OXRRSnM4dHZVRjZFeUpPbnhuN002SHBNUm9a?=
 =?utf-8?B?Z05WZWNnckMzS2pzeW9jZXUxS1ZFTFZsM2xRWlBacXFhb3R0SFUzclcxSDNu?=
 =?utf-8?B?WWhJNC81bTVCd0NKWjFaRS8xWG9hbmtSV0xYOGVVblY2TUIyTFZINFIwZTVB?=
 =?utf-8?B?V2pyajhzU3VUcnd2Yk4rZ1ZTWHdVUXNybFB3NjZNcExWUnpuRWF5R24xakNn?=
 =?utf-8?B?MlE0TlBzWHpTaUQvMW04RjFhcGRoOXZSRk1GdC9PR0dyai9VaUU0VEgvMWky?=
 =?utf-8?B?NC90U1AwSEtZRkJMVXVIalB6YkZNc2o4WU1qalNvOUMreVNpYU4zTjIrM1Y1?=
 =?utf-8?B?Z0w1SHlHcHdTYkZkZDRHVEp4ZFFGZWxOYm9CekVMOWNNZkpCYzJxRkNsV0lj?=
 =?utf-8?B?SS9hUWFPV0dVSFBMcFBJSEpxSXZOMXlJbi9iTFM5bWt4TXdpQlBBcjdkMXZG?=
 =?utf-8?B?bEEyQkQ4Q1BBRGtkUHZ0MnlieHVXdndYd0FqVVRvRThaY0t4KzJqaEpaVExy?=
 =?utf-8?B?ZmlRcEw2REhObStROHFEL0ZZTDRUTG54M3hzYW1Zbmcrc29tblAvbkxoSDd2?=
 =?utf-8?B?R1hzYjRwRWQrME41aTl4cVZFeGpJZU81dGpnS3FYU3Bhbkx5MFFpTFhOdkVr?=
 =?utf-8?B?Vmc3dXBDVnhYR0FMVkpHcWJQYmpLYWtKelo3S1BWdmlmUU0yMkFMMkFRTzZ5?=
 =?utf-8?B?MDhoVTlDNDVPakxjMDhCVzhZaHhLTnNtNkE1bCtBQ2lac0k3SVhpTTBERzZ3?=
 =?utf-8?B?SzhCQlNtQWZxeE93blNQbGprQUR6SVJZS2hZUWZCTUlwUzdvSlpqcE5BS2JN?=
 =?utf-8?B?Qlhxa2lSdGgvRDFKMEJydlZ1R3paMXljeW1HV2tqMjBXbUV6NTMxWjJ5S0FC?=
 =?utf-8?B?QVpnbkVPbFJRRGZtK3Z6SXdCbURsSndLdkZWcTBUVE1nMlNwZm5iQTU2SU1j?=
 =?utf-8?B?U04ydVpOVmFmUmoreGVGRWVYN1BDMmxkRXp4cjNYZms1SGs5bnZWYksxSnhV?=
 =?utf-8?B?MWhpWUxXQTcweE9YZXJFcmhyUDh6dWJYMzhkRldqN2VFRzVzS0NLZXBFOXph?=
 =?utf-8?B?RGdyNWtCZVBNWmdVTG43M0trYzNGQUU3eW9CWmRrYWIveE44MUZTVFV6UUNF?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b1cd29-098b-4cec-0028-08db70b48bbc
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 11:01:34.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ukSX0LWsdDed5Ob4N8m0I0cftAVAmQbUaNY6kuB3Iq+QFyiFRSBaTNSx35kADzuXbU/Kyr3zFfpmk+XcQmNLsXU67mc6h8FxtntLso+3zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 16.06.2023 23:49, Andrew Lunn wrote:
> Caution: This is an external email. Please take care when clicking links or opening attachments. When in doubt, report the message using the 'Report this email' button
> 
> 
> On Fri, Jun 16, 2023 at 04:53:15PM +0300, Radu Pirea (NXP OSS) wrote:
>> Add 1000baseT1 bit to phy_basic_t1_features.
> 
> Please add an explanation why this is safe. For example, why the
> RTL9000AA does not start saying it supports 1000BaseT1_Full.

I added 1000BaseT1_Full to that array because all the baseT1 features 
are in the same array. However this is not looking right to me. For 
example, the output of ethtool for TJA1120 looks like this:
[root@alarm ~]# ethtool end0
Settings for end0:
         Supported ports: [ TP ]
         Supported link modes:   100baseT1/Full
                                 1000baseT1/Full
                                 10baseT1L/Full
         Supported pause frame use: Symmetric
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  100baseT1/Full
                                 1000baseT1/Full
                                 10baseT1L/Full
         Advertised pause frame use: Symmetric
         Advertised auto-negotiation: No
         Advertised FEC modes: Not reported
         Speed: 100Mb/s
         Duplex: Full
         Auto-negotiation: off
         master-slave cfg: forced master
         master-slave status: master
         Port: Twisted Pair
         PHYAD: 1
         Transceiver: external
         MDI-X: Unknown
         Supports Wake-on: g
         Wake-on: d

Which is wrong. TJA1120 does not support 10baseT1L nor 100baseT1.
We should have a phylib function that determines the features for T1 PHYs.

> 
> Has 1000BaseT1_Full been standardised? If there a feature bit in a
> register to indicate the hardware supports it? That would be the
> preferred method to determine what the hardware can do.

Yes, it was standardized in IEEE802.3bp and there are bits in the MMD 1 
that tells you if the PHY supports 1000BaseT1. And here I am talking
about BASE_T1_PMA_XTD_ABILITY(0x12).1.

> 
>          Andrew

-- 
Radu P.

