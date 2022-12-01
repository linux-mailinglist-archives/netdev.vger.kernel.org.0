Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1363E8C9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLAELk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLAELc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:11:32 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2082.outbound.protection.outlook.com [40.107.14.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0440B9838B;
        Wed, 30 Nov 2022 20:11:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWr7jcUG9WDFGAm+vVy0eV6i1tUrWVYO/Bvwdg/rLrutbJOjcGly+iw5ij6YBNS7xYVIraxmfXbZoRBoN8lgvLv/stjtG/7UJpe2Duf/8IsdUPJb5d+QwaLjpw8+F/WYOT3JgtTV0H6EuifTiXaix5wGxi3EqCI5bNrkJ9Y1nT1KLZzDr107VbvgcKfBdtfDDi1h+CYptqSgktDB7vzfIJdpZ5yhJ8NDQVSnI+iGFr6ViGW1G0HaL24H/0kY7fjOqlGv0dk3BMT6xsxWZcZLFfzLdPHUYb3OfrdaYvt/i4u1lad100zGeEMHnPvYFOzwdky7vuVGy1DkChVKuRFhHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=788usBSCMQMU2rrjse/znmauf869N5yVpkf7LitcVXM=;
 b=R3hXBR1LzB3TIFtjnjSiTC32Vm4VJJngeMXBid4UW5ik6DjXjbz8m9Wzfp+TeLvzMUJgYSaF1PsduVdJrQS7El55XZ6Zr7A4Q3mBcAnbFuLBPe2B6/1gvR7v7HofHy4P0DiOOnJJdL1hvNwKnE+9wSLCXE4lBUhdqj1YCdyyMOmFkK9TTaR+QwsoA6MV7dL79KiwQLRSXDkFm+KBjhnHjgTxAkYsNciEqKylp+41uDeZGmyDeoyMfiOZ48U+AyoMH/5UlFyQdEPMif2duAgeTNjQ2bDUZcK+ZRR6QIYTPkYqL/on+NUVvsPclPUZ697JfxFCn/0LhUDOop2bfocb8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=788usBSCMQMU2rrjse/znmauf869N5yVpkf7LitcVXM=;
 b=V2t6WnzUd8ljpOpmRnzg34u70UJ2OD4/gSQ4Bu2nszgeO6O8FDjPHWTUaPzgTjx2MzZrMlO/U+AmWt2sf/euZBWVVgZ7DD4zjupY+reIYLCulxv4VARjShGPmcR8jFUsQ6SERMlPzL59xMEugVraG8vOwpKRoMov+WWgUaK++HgrJZKbBejy30fDiM5ycgOi88La4w2AquLA9F7KWffihhvkjsi0Kxqx9BPD5dK/Ll1bbx9NewsFGWKcBqFqiSGrktRhOolCXjuHjQnemM+omZ4ly+0Oceh+SZqdi1YYGflCNVqhheOeRUkwnXoYpDmhAJvt6zfqGagSZP09o3d7bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by AS1PR04MB9335.eurprd04.prod.outlook.com (2603:10a6:20b:4dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 04:11:27 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%3]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 04:11:26 +0000
Date:   Thu, 1 Dec 2022 12:11:12 +0800
From:   Firo Yang <firo.yang@suse.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     marcelo.leitner@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, mkubecek@suse.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH v2 1/1] sctp: sysctl: make extra pointers netns aware
Message-ID: <Y4gpYPlWNLe5o8Hy@suse.com>
References: <20221125121127.40815-1-firo.yang@suse.com>
 <20221129204818.7d8204b4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221129204818.7d8204b4@kernel.org>
X-ClientProxiedBy: TYCP286CA0041.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::16) To AS8PR04MB9009.eurprd04.prod.outlook.com
 (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|AS1PR04MB9335:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e3ae42-026b-4bf2-44ba-08dad3521d72
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRBZClc7sI/GdLfLcVNiLNkiH88j+SOZZXWXcLqgTeQSKqYFKOefAm/ktPxBuqAYs/ZCFQ7VTUr05kIF3PLRqqwOVdylA3G6rWtrPHc/ZVThSZ4Mq+KGW09pyPDc3l88cg94Kj1ed0gu45uTxdHpNLYBmlT+TWr0htZ59DS/gZPAEAFUHYdtQztiW4SmErQfmjjCCYqEJHZudySuwjzOQ4Uh3T6rCGDM9yi76JGBl9rLEfQ9Dp9ZnpInm+Sk+1xwTHVdxGSmR+/MpuffCa/2NaEkeyUbR2UTS7dlrQzvZj0Kyq3SBM0Lmf/jFmBgSy2h8YW2adSPxG3XaEtaqavYjv/Ozw8B5Mb74h/5ZMEL3HdaMooxINTzERbqQgY8gXbBUHwYj4MZZB6M/i5yqmBaAcjKZVfBOZC6R4NnYNx7dxFaJFZ2Wgt0gnM82v6T8HmYBCb7v1NmsW/WKcO9O7B2ey4o7E1KP9UOSKtAenHVzvcBv9P1kf7VJimNy+YOzFTeqLoUN+spFSV9n7e/0ZrE+XM7UwwY8zsCDBdclablz8upSHDJ1nwE9KG+rCW5ghbV++IRrlyqpCxiQFnggAMNzbxl4h8VniTUnnxdk1mzLMm3JeNqmHEvjrGNEI0kMkSuEMTghJTE9I/gJm1NFyU1hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199015)(2906002)(8676002)(4326008)(5660300002)(66556008)(66946007)(41300700001)(6506007)(66476007)(6916009)(38100700002)(186003)(2616005)(316002)(36756003)(86362001)(4744005)(8936002)(44832011)(7416002)(6512007)(478600001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0tWMHZqaGYzR0h3c3BrRCt4dkpNbVk5clJDRVBzMHNNc1pQSDNHUDhVaVV1?=
 =?utf-8?B?bWZKejQvZjdSR3FhY2tmOWlaeXorRnFqZ3ZlVU52bHZJR1gvTjQrVHVMZ2ZK?=
 =?utf-8?B?K2J0K2tFMzZERU5LTmsvWVc5WmFVTUxQeG9EMEJJSXNiZjhMM2hHMlpaUEJO?=
 =?utf-8?B?bEdyeXg3d2lnVEZpcDYrbmdQK3FCSHozRE5IMXp3R3dwTmJtQlcxYjd0a2xm?=
 =?utf-8?B?Yys0a2Ywc1huZTUvZ3JuVHBST0RVSWF3eFd4bnRJemNoVkJIRHlHRS9sNzZ3?=
 =?utf-8?B?VWpGbHlHWDI3UlFrUHhzcXRWZ1FVYjhVWHBQaDRSdDI3ZjZHRTdaMFdzaHVr?=
 =?utf-8?B?Yk13SDBwNldEUVFidE11VHJOY1c0cGFra3NtTlRHZUpxTjdhL2RJNGFYc21W?=
 =?utf-8?B?QmFTSnUwdmMzNGtITEIyb2w2N2ZEc05JQld5Z29CS2FwVGwvYW9uL3lXVk10?=
 =?utf-8?B?NW9DbTRxZUFZNVVSVU5QS3hNSTBSYVdNdGhUOWJ0ZG04M2pmcmhKbmRvQk4r?=
 =?utf-8?B?Z21tU2hBY0VHMURiOFZjbGNzZzhQK3dFaXcvUjZ4azB2SVczWml2SXpiL3cr?=
 =?utf-8?B?U1NNcXZXNklGdDdnT3JiOFI4NUh5Z0RpV1AyeVBtcXBLQkMzYTY2N0tSRzJx?=
 =?utf-8?B?bXFlcnpwWWNLbFVUMFZrUEdTcks4OXIxVXIzNlpkSlZGdWdGRDRDWmxsSVRI?=
 =?utf-8?B?ZWdCbWQ0d0pPWlBYZEI1TFR1eHpCamlBeUp6NlZZWTZPREU0V1ZPbkJQVU1o?=
 =?utf-8?B?UERZVVhicExGbHBvRkkwbTlETTlmcUxEcnQzalNmeG03YzFJdjNzTDh2c1Bn?=
 =?utf-8?B?QnpOaUx2TDFPTEdZa2FDQ2s5NmtoR2M2Y3dPVS8yTGd2UmgyV3NxRTNzQkkr?=
 =?utf-8?B?R1hud3BXS3gyMUQ2YnVnVUJrTjJld1MxNnVNYWpLYnNqbzVJWGRSbGlRRE1m?=
 =?utf-8?B?eWhjWGRzblN4NzVKTjRvZ0FQYUpaeWd1OFhndHlNdXlsRDZIWHBrQWxGRnlV?=
 =?utf-8?B?NDRtbVJnTWFKOWxudzJubFFMVTBGaHltN1laWENxaFQ4bEs1Zm5OSHFjeDBH?=
 =?utf-8?B?Y1VIZS9DYmZDc09QV01RcEljYzB1VjBvSEtEaXRTY1czb2pTVFhGbTJyV1VQ?=
 =?utf-8?B?WkwwcUhNY0RDaGhUU3A1YUxINW5lSFQ0RUUyNmZKOHlyTysvYk1lK0w4WWJN?=
 =?utf-8?B?ODZZbTFQZm4yTEtWZm55VkpMMzlveG9oVUFKS0NySlRmbTBiL0JpYlJvYk1X?=
 =?utf-8?B?QytqWnJlSXFMRStEdndoVVgyOWk1UXROSWRyTy9GckRkcVpKdjdWMzFMSmx1?=
 =?utf-8?B?SzNzNzJlem9NcWozZEJCdHc2UXdlVk0ydy8wa3JkS1oyNURQOUE0TXBIeFox?=
 =?utf-8?B?cWN5S2d6RHJIRm9OSWxPY2RkS2ZSVWJ4Z0hOeTVBVnpvbTN5Y3dWbmlCcW1S?=
 =?utf-8?B?cHN3czFQMUFGUkE0QXc3dGs4dDhBZC9lTjhFa0lJMng0a1RCZnNpZjlpeFZj?=
 =?utf-8?B?QWZpUi91amZoN1FnYmd6Z1JQM2JweVYyNERBOFpJZ3U3Q1hVZStCTzEzb3Q2?=
 =?utf-8?B?MGdldHVIbGJQRU52ODc5bndYRUMybW5qeitSMitrcXBMakFLSU9kd0E1eXpl?=
 =?utf-8?B?eFZSd0hYdDVzVzRvd2pXN3dtS1E4dE1BNVJDbDJUZjNOR3MrQTJMNTNDU0NB?=
 =?utf-8?B?SCtTK1dkTzRaSENFdXRCa3hZR2c3V2YvS0pmTk5ST3hTb09JZmQxNW9sdnFQ?=
 =?utf-8?B?ZmMvbDZCRC9iZ3d5TEhlSEVzdWJmRFhqMUVuZG56bTJLMk1aa1A3enNhSmRp?=
 =?utf-8?B?ZG1SUHloQmJMcDdiMlo3UXMrTTBoaWxYeFdsYmllYjhrdDRhbkxlRHBoOFBT?=
 =?utf-8?B?OFBpMHFZYzRXZjJRRnErSisyQTVPcVU0NGhHLzlVQ0xob1B3aFg4RWJyZzVh?=
 =?utf-8?B?YTIwNHVRS1dHNFVwMWtXWm5rdVhqSGRsYW9Fb2FEZnRwQmxlcUF4T0ExcnZP?=
 =?utf-8?B?VkpqOWZPUERZQmxBdy9XL2NHblZ6aGJZNEc4QU9aa2RHMVZBdVlYTnl5Snk4?=
 =?utf-8?B?T0xTTEw4eXNiekVmVXBwRUpKcmxHaTY2bmxSYmwydEtZVVoxUE1SSmNyOHdL?=
 =?utf-8?B?WEJmRUxaclVURzIxVXlGcnVTZlpINVVyd05abnNZbHJaMlRGL2Y0VWVjWXdj?=
 =?utf-8?Q?BJFIlB/UF9Zqrerwm/UuJ1XSqCUOJ9DFQhnF3ZDDdPhC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e3ae42-026b-4bf2-44ba-08dad3521d72
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 04:11:26.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyCLkEZXT7HftVFETUxrnSySZ6kPwRALLUJ+TM6dwX4PJYdpK5M6x391637b/F9FueLrCs/u2VPvdOIBp96F0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/29/2022 20:48, Jakub Kicinski wrote:
> On Fri, 25 Nov 2022 20:11:27 +0800 Firo Yang wrote:
> > +#define SCTP_RTO_MIN_IDX       1
> > +#define SCTP_RTO_MAX_IDX       2
> > +#define SCTP_PF_RETRANS_IDX    3
> > +#define SCTP_PS_RETRANS_IDX    4
> 
> Use these to index the entries, please, like this:
> 
> struct bla table[] = {
> 	[MY_INDEX_ONE] = {
> 		.whatever = 1,
> 	},
> 	[MY_INDEX_TWO] = {
> 		.fields = 2,
> 	},
> 	{
> 		.there = 3,
> 	},
> 	{
> 		.are = 4,
> 	},
> };
> 
> I think that works even without all entries in the table having the
> index.. ?
> 

Cool. I will send a V3.

Thanks,
// Firo
