Return-Path: <netdev+bounces-11833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 496F6734BC0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008E7280FD1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 06:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF5123C0;
	Mon, 19 Jun 2023 06:31:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE5B210F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 06:31:09 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855F1130;
	Sun, 18 Jun 2023 23:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvfpRnzCPdJZX22y3iBhs2I1P5IPA/u1rS5VehqZUSXOykmJ2+H7pC6+ddc6GHpsJEEQqe/Y3ef1i1VRGDDDR9u4Ye/nLWkMlw+bticeIyf5ZgALkPpkuE3lSE4nxL1ivXash6vLC3QB56BEXzJnqGBJMCXxtnwpv5wHSSZAPLIL6tAagyfXV3Su+BCICqtUp6HgUfmusmhQeh5Puhc6uURbH3g/QgtpfRcB4NYAmkLMdlU6JpopUL/725BWTHTF8f4oPVcQToxwF4nnZZ8gjVf13WRxyeNCYgPGbNGxJWcBc9yJDaifm9488n5gJXRunpYekqTfHjxPsVycEP3AMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLZFBR+LNOOF7UCEaFMiImc1TTm39RO1dtArSHdV45Y=;
 b=EpvVuaVMB8pCLOvHrzg3T4xuoA3lyUW3vyvuo1GlRlqOZUQbvx469JnaYNPgc0vJ5fHJbkkk7Bk+MKedj9V+m99N5GG4bQJ7fJONP0kiPajdYkIKA3XiCA885h6Pr6IQjmlfbUVNHYaUOH9ssK7GXMCk/HsffwqiDg1aFBMtwH0DfS5yC7Lh8DUstYvD1lcaB/6UqweTJcSc+7husKS7ZNRci48lKJ7oW7M5Y8KhpN7QIgieo5RXx0OzEfDjkstD1vPBTgS6s5ZdIlBAJGdAzFHAlhhqveJCmlY1DTPUQ+vp4Pq5wgmnQu7/bCgO+RIAEL4zvc+RMY4caGMphPghQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLZFBR+LNOOF7UCEaFMiImc1TTm39RO1dtArSHdV45Y=;
 b=jAWhw+NXdpAG011hPPZ9O92FOqW6VEuRktA1Wy68Clf+K71kr01Cd5zTDprwMTfNMqcIkcDpjFIbavks7mzPK/+HhEWd4oswUm5ulPz5A15P43tiCRv8hF3Rb/8fYcFqeZ0rquU9Pnng9K8yLfLgfv0XLN/vvpXlHKUanvl5DNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS8PR04MB8835.eurprd04.prod.outlook.com (2603:10a6:20b:42e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 06:31:05 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 06:31:04 +0000
Message-ID: <93845886-484c-f05e-823d-f5df9c418495@oss.nxp.com>
Date: Mon, 19 Jun 2023 09:31:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 10/14] net: phy: nxp-c45-tja11xx: handle FUSA
 irq
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-11-radu-nicolae.pirea@oss.nxp.com>
 <2f4e3219-6c74-4ea7-bd4e-21f3ce23d8e4@lunn.ch>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <2f4e3219-6c74-4ea7-bd4e-21f3ce23d8e4@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS8PR04MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: 896c188e-97aa-4327-3f95-08db708ec20c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3gbmkCcW4QXeYWC+UhEFCLV9lqvLHm3a1LoFgDziBtg9bSGfqwk7i3WV565doWKGUmmYRZS9yqr4htn4nfDNsDLks+1Z8+ky/6AuUWrtUMOuqVVZGyatO4g1kT8VZfKszF8a+7rKwbropF1H2GDjx3ztDowbN3+NLG5Er7ka7xdVVAjAzcMnEyYksfFKg4cSTzGgwkX7d2PN5nERUp1DEqpSbKY62tfkKZTnsqUj7xgpI8xtWhB+l0DMFlkKdEv5MHXGWKAAXKl+LFikVx97lZGtGLpnl8TeLUDxcJNw5CmFZhCH9mqer3TE/PxtClLE5gChWrzzvVEBWEUhJRRruK6hr203dagLX0Q4eaptLIoS32dsKTPFVBCbPy1EU4F9FGxJraDkw1SfKTRRces7ZeusMHYVNAFCRm3kuNgCaMbR1zYjsRe/7oV9EAWz60xFwTz80KduqD93f8Yg3Yy6dTVjVaWmkJmPX5XYFMUwzkW9+SLSi5jVRtZD60Wxsk4/NgGo6o9P45/VDGbrOcLWXd2WKCjzhOXih5fVLWP1Ekz5FBxOiwGNq7gnPF1JBlmrBjWOm71AFLoCodbF3X7nqdqD+G7MGMhgz3nafNFhkdBEGvU7/GyODIirINK5EzITuG2pLhVn3jFlkFIaFyn9vA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(4326008)(478600001)(6506007)(53546011)(6512007)(26005)(186003)(6486002)(4744005)(2906002)(8676002)(41300700001)(8936002)(66946007)(6916009)(66556008)(66476007)(316002)(5660300002)(7416002)(31696002)(86362001)(83380400001)(38100700002)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHVyOXVPVUJrOGdVaDR1aHlGT2p4NGkwR2hMUWtiZ3hBRTZnR1ZIME1oaHN1?=
 =?utf-8?B?TTRPZkJiSk1JaElNVUFHV0NnWmpoYkthRS85Sml5Zk9MSk1kdk9rYmhMRlJz?=
 =?utf-8?B?MVcxeUMzZjFqUVl2N2JQN3RlQjBkYkNWcjM0LzI1MDRwUVYzZk81b2pHVENW?=
 =?utf-8?B?ZS9rclJ3OExRZDVBdGRBb3NsSUs2UGhIUC9KOTNUQXd4dmxtV3E3UGtzVkJS?=
 =?utf-8?B?MjMxM1lOUStiMGl3b2Q3R1BFa3U4ekE3TkVuWnB5R1JBWFVxZW1aMTEyRVVk?=
 =?utf-8?B?ZWUzeEgyT2ovS3o4VG1DOXlDVzZEK1prMytPZGpyNGxwVHNoY0E3Zm5BbFM5?=
 =?utf-8?B?cE1ScmtHTDhhNVVjNGZCclo5ZFU1M1N5ZytGdEpiZVdTNEdrTzAxN3ZDVnVX?=
 =?utf-8?B?VXFPMmNoUE5DNFVqRmxKcVlLMGZ5Ly95ckNoN2x3b1pwZTlROE9reE9HZERM?=
 =?utf-8?B?ZkZHdU55cEtkenp4U09OZllXN0ZIRnR0T2lJcDd3bjY2UnpMbTEvVGtmT21E?=
 =?utf-8?B?WlJmTE1ZY3pwbDBaS3JqSnFnYjJleWVieTRQeTBoR3N2a0pFdVcwWjBjM3pm?=
 =?utf-8?B?M2djMDBrdmF5NGtZQXhFbllBZDc0WGVRZVZ6VXpyQUd1QVhTNHZucTZUdCs5?=
 =?utf-8?B?Y1FXUldBKzRMWHFjYStMdzFwQkliT3V2TE9lekdwS1U4aHpydTE1enBwc1p1?=
 =?utf-8?B?YmxENXNuQWgvU0xDcDdsQlNWajFjQmtUT1E3bkp6eWFyTk9qWXR2WmozOENa?=
 =?utf-8?B?MGtkS1JIS1FKeGhCTlQ4clMzSEhNVWNQUUNUVGl2eC9qcnJZNjRCZkRORmhI?=
 =?utf-8?B?VlZDVFErQ05Ubno3RStpalZscGpCZjMxditodDBUT1hCKzNxYWZmYVZ3VGNT?=
 =?utf-8?B?WTFiaVkvblVBQ202ODB2bzlyMEtkcWhwU1NReE04MVVYQ2xqM2pqcUtiaUFk?=
 =?utf-8?B?SGk1SEtYNGcwU1ZMZ2ZQdjBzdHdOMWxPRjczTVg2WFUvbDBvUFgvdEhuR2Vh?=
 =?utf-8?B?azFYa3l0SHRUWGUyM0Nia284eUlFNkppZ2U3YlpKUFBLMGtlUDFjOUVEMXRM?=
 =?utf-8?B?eEhBSWRLanE1ejdjeWFOSUJmQnAzZ3RBcnZZQ1M2SE55UG1oZk9lQ1BRTXNm?=
 =?utf-8?B?UEx4OGVVYTNob1ZxNmQ1d3pMY0hmL0ZtRnE3RzFTaFd0bTY1UUpzaHU5U1Az?=
 =?utf-8?B?Tk4zWjltMFd4N25mWWc0L1N1alRrVktjVFJmTzZsN3c5a1dSSVdtSFNMdkpK?=
 =?utf-8?B?aTVGcWNhTEYwdzJKK0JOTjEwMVR1VjBwS2pFZ1M2eWZlMHdaNk9CYmRUVXR3?=
 =?utf-8?B?UTNTSWd6bEpTREVPS3BKSGxjZHRSQnN2c2U0TTliVjJuMWlCY09OcjJtcDky?=
 =?utf-8?B?cndVRmdJL25ZME0zWVVERWdqOVBxMW16OVBLOFJoSzV2eFZSSGlObjU2UXZS?=
 =?utf-8?B?NmpqLzJCeXdLVzNReVVMek14cUVjMGZDRjlSeCt5cFNjbmgwMkJWaC9LYkY3?=
 =?utf-8?B?U3dOY1lNeWhtZm1sWFNna1psWWt1NkgrNm1YZHB6YXRGQUcwSHUvZDNDWG96?=
 =?utf-8?B?WmhadStTcUhBMmJYQ3E2MlhiUUtIKzY4aTJhVXE1NFdTVksyckpmWnRYTkFt?=
 =?utf-8?B?RzBudkRRNFNqWGk2SjBGWGxCNk55SitnTUZzcU0yWTJrY3F6aEFPRytxei9w?=
 =?utf-8?B?THdMTUxDeG1ZMFp2ZEdYdk5QL2pHTW03anZXckdEOUtHL1BMYWRPZmovblJD?=
 =?utf-8?B?M01pcExKQTBERHlDN25TT2tqWlNwSXppeEJqc21BQ2JYYkluQ1lSRm5ISGkr?=
 =?utf-8?B?NW9McVU2T1hTYkxFRUJNaGFPc3JOWG5LV0g2QmRQZDNnU29lZDdjSVNTOGVU?=
 =?utf-8?B?clpweVhlaDJLK01XSFVQei80ZVgvd0NndGs0NGVCM2x0Kzd0T2tGRFF0aExG?=
 =?utf-8?B?ZjVpQlJHcTdLMGpTempmZndMMFhuVE5uSE8zdlY5U3FCWEdNdTJvZWZmekxt?=
 =?utf-8?B?b1hFdmp4L0VXMzhFRzlQS1lSQ1pWRnJuMUhXVXE4QmFPOHpjTlBDR21aTU5U?=
 =?utf-8?B?blF4ZWk5WVVlY0RjMWYvdUJVNk1Ld0prNHRtWEVybCs4REtBdE1aTTVtSU5s?=
 =?utf-8?B?dWVSeDFCdzBBdW53bmdWZkQrNXhiWDhLWnRWZjJnNUFxZDFhQU1aaVBPeWpj?=
 =?utf-8?B?ZEE9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896c188e-97aa-4327-3f95-08db708ec20c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 06:31:04.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrJodSCcS8n1PRaYkEU3cxqOPbym74Dsi51SIfmPc18Ey8oHbuX1sk/egEh7hJ596WB0C41lJfqC1VhykAGeTH+4d+PLb0gvB8GxFSWBLCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8835
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16.06.2023 23:55, Andrew Lunn wrote:
>> +#define VEND1_ALWAYS_ACCESSIBLE              0x801F
> 
> Odd name. Is there a VEND1_NEVER_ACCESSIBLE?
> VEND1_SOMETIMES_ACCESSIBLE?
> 
>          Andrew

This is the name of the register in the TJA1103 user manual. It is 
accessible when the PHY is in sleep or the VDD_CORE is missing. However, 
VDDIO and VDDAO must be present to access it.

-- 
Radu P.

