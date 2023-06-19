Return-Path: <netdev+bounces-11832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCD6734B9F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB65280F83
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 06:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0813D82;
	Mon, 19 Jun 2023 06:17:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2A23C7
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 06:17:09 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2054.outbound.protection.outlook.com [40.107.14.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E1D9B;
	Sun, 18 Jun 2023 23:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoehTbZ7oTmBrvWd+XnLxpdkXmRJo3zNWOnieqyuaFFD0+za2VWkGkWVtnE3S6wQ1zBW8KWHFiTjJ6cGpnvekRDRtMXJ3nNFjif2ejhJMnJcwD1Q4dpiu+jZ20qG2QYLDyJx5jw6ciBZxZZ3LCxY43bcLL2LqKF//gCVnmexL7J8y+8XK3C/2xtX3skGdqUafQP2OmI6RAp1xrhhX0D1BB7VURxiQx6XHwW+cJDYmUUN/zjq3c1C9DHP4e3tRKTpZKaDQi0gcYxho82WPORpcZt51YOyfQrtitSrMyhyWoS4/qziPdnh8WhLgVjvgEEdXTOw03QPPpcqL9mCh0B32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjrjLaGo1NV9cHkuk/A6QUwRuqUxv9G4xKmt8DZZc7M=;
 b=i6OQjwpOE2nzBhlBPFfzXzH4T2f62aphicHyHZ3bdzasB5q7EyiVbDbegf4FXUWOcLzzr4gzbrH+y/q6tSSHvGVwPUUv7PjfTL9ubG5f4KMK7/2J1iH8Ygq84f1cx0qZOacgz0E3VPCc8lFUrUWqSUZ05N6QrTBQHI4YzzfXmmO09L/WYUIgW4LhweOF0tTL/JXKLmtMttB0Lze9ro/+bFg3a/cIpAQvworXsYU2dZEeN32BwrENbgSbfRyjzCwX0a92MuXGr/uW8I6xPQe1tBV5Ic/34c20Fo+mZ9OJ2/ZMRDNO27l8K+AGg1TdiMDO7pu6+FQKJJPr5PZ0Ut5ACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjrjLaGo1NV9cHkuk/A6QUwRuqUxv9G4xKmt8DZZc7M=;
 b=TpM3j/wOZKyDo7u54MyQoqT9yo3qHfsArzy28JzubHLPpc3j8gN+HNtXV7u/OFsczfuKd7lgyRJUrtwNMNYdiHAVQaHeQlJ+bInJYO7PND6XOt7lsZnJY2TpxbC4lAuXmlpOq8bOyGJxn6QauKagSSvvznL1OvfA0WkyXcDxQvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 06:17:04 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 06:17:04 +0000
Message-ID: <db4cb7b6-42f0-17de-7e9f-ab28977edf78@oss.nxp.com>
Date: Mon, 19 Jun 2023 09:17:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 13/14] net: phy: nxp-c45-tja11xx: reset PCS if
 the link goes down
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-14-radu-nicolae.pirea@oss.nxp.com>
 <d483be85-2d63-4b37-9cc3-f8924c53bd08@lunn.ch>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <d483be85-2d63-4b37-9cc3-f8924c53bd08@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0181.eurprd09.prod.outlook.com
 (2603:10a6:800:120::35) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DB8PR04MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: ab750fbc-5785-4138-f25e-08db708ccccc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mqU1yPcX0vQeSKvLt7cAmTe+KrSQgv3ENXADrzJGGyRmO1Sv/ctK2RswGm04u6yHMXJrWot2SYbCtFBgcQu/vmA4bNEGT6qADAOzr9bCn+jOQt8FTUykLg7fnvrSlCItRQGToKAHrBPwORlhqDgqBAjM1OfhkB/hj3wMjF5kEg7d3U/WpK7DqorcUrBdlvMW61ynCPp2uNwYaoK2+ETVZVVTOVHD3fpVhO1Snk/bt/JLhgEtaK19II81D2pcK4lREGFTg/+FTau7n/GSyGteDnHSEDF/aUAXJSoyuPTx+7k1syp63A2YP3/Mvq5/F/AfQrQyN3/Gb7tvKC655vAKZA7CELmCVHzEattkLs5gMUQ7mr2vW4MubtKB1HpZ6UG7YLBO+4wbbTrLGxhKz7Yf82sDXiSFRf/lzdsDNQIO6u+qQa2nE12xc+S3G9aVaFpvm+M2Wus6fcZeAKDiiT/TjHKrzURxxty6pIQ46ibIogLh9SALfvWWtLfibzrvnzk0tvePtOiHh5EJH12Ps+xx1IeuXPKiEep02m7p/r7u5Xi9RpoVI1lirdWhCUgb2m2/w7v1ju8xjmY9fw5/D1HEoD0VsM8vXa/U4m7asgezngBG/oCXhfONMMMm/OJdu/pF7pBvFbF3vBjfsN22QvTMEg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(41300700001)(5660300002)(7416002)(8936002)(8676002)(2906002)(86362001)(31696002)(53546011)(26005)(6506007)(6512007)(186003)(478600001)(6486002)(66946007)(66556008)(6916009)(66476007)(4326008)(316002)(38100700002)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjcvS0JyQXlRbWlZMkx1U1prZnprSkY0d0RKeENBWkNQQWJtNTR2SWh3VEJt?=
 =?utf-8?B?b3FXYmw3anMwYUVGcU1KUDg4YjVtUm4wb3RpTm5NOFRNd1RSbWdrT2FrYXFW?=
 =?utf-8?B?NzRkVnJJZDBJbWV1aGg2bnk2aWZvSXVrdy9aa1pjbkxNNkx4MTR0OWp0SURx?=
 =?utf-8?B?ZVNsRXBGdlBhMjNnSmhFSEgvM3BWWGowMWMwT3Q2QkJOc3lUNU9sWGdQNUYz?=
 =?utf-8?B?VFpDdWxMMXNYTm5jNnBuMi9sTzNoR1YyNFl4bENtNUplM3JWR0E3bXloeUJi?=
 =?utf-8?B?bWVLU29sblNrUFZIRDJnTHBESnZYWDA1dWM1R2tEcmZqNm9XL0h5RHBiUzhp?=
 =?utf-8?B?VEY4eEw3eXFIenBMZFNiU20ra1c2eXBOMDQyL2o4SzRWY2x1M0tNamowRG1H?=
 =?utf-8?B?ZWJlblh6S2dTS0c4MTVzWTVyTHQvK3ZiUElKemZDczkwRVdFOExScDl6NUNw?=
 =?utf-8?B?TEJVaVovUDVBSE1NZFdXOFdHVE00MHlOK2hYVXgwR3RCbkpnTWcvenUvNDRp?=
 =?utf-8?B?aXE2NEwzYlc5N1ZSc3JsQ1l4M0NBTThMWDlZbHlIeU5wU3RJUVhoZjVlMDlS?=
 =?utf-8?B?TnZBdGNBb0pPbGpUb1hTeDY2NExMSXVkR215d0locWZ4akpaaVNUZUZhektF?=
 =?utf-8?B?bnp2L29NaW55dS9sWTQ3Yzg4V0xrUEpNKzc1eHMvVG1tUkxDM2RNRzhnOFNE?=
 =?utf-8?B?bWx1ZkdiOEo5QmZ0dXZoVGtKOXA3QjA4M012VlpiM2toTW5zVFlKMllRcWIr?=
 =?utf-8?B?NFpDcnFPQU5Nc3ZCTW4yN2tCSWlmRWxTbTkrNXJ5UHZUZkRhTkpQdWh4aFkw?=
 =?utf-8?B?TGhHbTZheUkrR1QwVGozVmhYZ3Rzemw0alJTTjhXSmFMaWVydmw5N0E2NHFJ?=
 =?utf-8?B?SllNcWdod0Q5VHhHZ2krY0xZeVBzVXpwWi9EcVQzNlJDY0dxYmFvYi8vWjRj?=
 =?utf-8?B?WG5QL1lubmJRMnNLTnVpNzRWQWNsMXRucFpGSnBrbW0rRmJjU1dNanJVaVU5?=
 =?utf-8?B?dWpEbWd4eWNMVGN1YWpsTTNCZXFNZGVrM0MyZy9wMUloUlpZckE4d1BOM0Yw?=
 =?utf-8?B?bFhERXlkZThYZTFobGUyU29CcnRlYlZMNWxxaS9nekloYmt3djBkVUFFTkIx?=
 =?utf-8?B?VDlTZkF6VWwzWElEd1ZTYmJtbzFIdTVMY2lTcnlpWmxPeG9oWEVVbzhEcUxV?=
 =?utf-8?B?aUxhRmlkcXZhazU4eVYxOVJWejhXQnRLMWUyL1Rsb0tGalhJeWtWaWpoVUVu?=
 =?utf-8?B?K1hDR1g0aDlwMXNQcjRNNE9JZ2pyblM4V2RHaEUxdDduTHVzeG1PSjZNdHds?=
 =?utf-8?B?VlNiWnUwc3pyZUlVaGtHNTE3YWJXUE13YzN1VUtTZ1VUOHNUSXFVbENiZXhu?=
 =?utf-8?B?YytNdlN6QmxuWko4SXFYekY5MlZlSU5NejU1a2FLcnUyOWZBbU9JdDhvUHNU?=
 =?utf-8?B?U1kzZWFPclZmbXFDd3d3UVJkQmszVHdjQjZXTlYwcWFLWnJuQkE2N0Q5SWZO?=
 =?utf-8?B?K2RnMUUvTUFzKzlHdFRONnlDRS9IeDlCV1pka01yWDlic3cvQkhHb0NsU2Uy?=
 =?utf-8?B?VklvODdFZmdxMlRDanhjYzZDQytYajlIclZSdkREYlgycWN0QU5QbTB4NGFy?=
 =?utf-8?B?dngzeVNZYUJnajBtVS94dXJUaElnYnY2dWlzbmY3aU1GbTVCRDZjeG14dnJE?=
 =?utf-8?B?ZEdMMEhPV3NNZVJORGpWMWdzaFNROVFSZHFtbzE4MUtYUWY5eWRIak83Nnc1?=
 =?utf-8?B?aWRKK3lYNGRydUpoNEovOUs4QU80NTYwNTRaaVUyNlM5TUVZdUcrazJULzlM?=
 =?utf-8?B?S3JJQXZ6N0cycis4R3R6YldpQkZac1IxWkkvZENWcmJja3N0dDhEZXdkZDJY?=
 =?utf-8?B?TEhwWlZzMi8wZVRTSXViUWFKMHJTYjNkcklMWUsyZlg5R2VkNkI5SzB4WS9y?=
 =?utf-8?B?MHNHSEd0aVk4akQ3RzdHTmlMdmZCeDBQK3pFUjluYmZaN2lTSXBJamdKS3Rw?=
 =?utf-8?B?UmFKR1JvMm9DaEFaR0orVGRpaWY3K091NlJTMXZqMjZOVDFsWDV5di82OXVt?=
 =?utf-8?B?RVdCY0dJbWYxckFSOVhGblAzVFl2UVNKa21iYlZ3Unp0VlJGSDJkajI1Vkdz?=
 =?utf-8?B?cFhsejAzQTJaRy9XU2JKdVdKam9keGVnTVlkMHVzd3hpaTV0WGtHTVFMMTlH?=
 =?utf-8?B?NHc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab750fbc-5785-4138-f25e-08db708ccccc
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 06:17:04.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ja3jFqPPvQARsjiOFc1AdsJOA5NqNM2Vo753Y3BYdMCBQzbAKpeRrd9lCba3X+RleMMgc/W/jfIT3SrT8GRExRwAf/Exe/yYe/PXK7UTgn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17.06.2023 00:00, Andrew Lunn wrote:
> On Fri, Jun 16, 2023 at 04:53:22PM +0300, Radu Pirea (NXP OSS) wrote:
>> During PTP testing on early TJA1120 engineering samples I observed that
>> if the link is lost and recovered, the tx timestamps will be randomly
>> lost. To avoid this HW issue, the PCS should be reseted.
>>
>> Resetting the PCS will break the link and we should reset the PCS on
>> LINK UP -> LINK DOWN transition, otherwise we will trigger and infinite
>> loop of LINK UP -> LINK DOWN events.
> 
>> +static int tja1120_read_status(struct phy_device *phydev)
>> +{
>> +     unsigned int link = phydev->link;
>> +     int ret;
> 
> Maybe consider using link_change_notify:
> 
>          /**
>           * @link_change_notify: Called to inform a PHY device driver
>           * when the core is about to change the link state. This
>           * callback is supposed to be used as fixup hook for drivers
>           * that need to take action when the link state
>           * changes. Drivers are by no means allowed to mess with the
>           * PHY device structure in their implementations.
>           */
>          void (*link_change_notify)(struct phy_device *dev);
> 
> Seems like a fixup to me.
> 
>        Andrew

Ok. link_change_notify seems the right callback for this fix.
Thank you.

-- 
Radu P.

