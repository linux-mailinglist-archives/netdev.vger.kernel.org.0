Return-Path: <netdev+bounces-11854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E222734E10
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 523B2280FF2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996E2A958;
	Mon, 19 Jun 2023 08:37:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA6A94D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:37:46 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720A32D72;
	Mon, 19 Jun 2023 01:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS10XGB/bBTAOCqt4S3K/rixmE1JpAVHAYdHpRFK51liEJnYA+RwB4trJaDfQISfRjqK+JmH/O6jBKsCMihCDT84sLZQPBohik2kdM+SOT/e5q65lGjhJ0HgsSMx69EUMlxmKvxcil6vv6YAodq2si4VU00SSPSdSysKsY2lb1oBFd3t6tKlSBiTWMhkkObV4zj1ejmGJkRLbdJMQcR37LxskeHgJ30vZS0XNRnTPdGj0nvX08yY4Yq+IKZLd9GUk3zxcde/20hI3MVZ07As+24NN/trc4l+xr5VkY8ZZgxQPf5QdyxZRpVkqCMZkB0Gc8Kpacva0aeYK+EaR6xUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEjL22VqaGpXYA4vmby2URuUX3N7YQSSYenPl/LAiqc=;
 b=JLVfLeYPUeNwlT850FdaX8hoPJSHVJCFs7CxwGlvrYvh5Hv8wpXblk+RbH99zafZUQjfkEzVbLFZ1nwZyx05NzC4XVXjOxMiHVCLfFCBoX4NfyCS/F/iexI1bus0m40/KPcqzHF5j6Y3+D1MpRBvtWMW6NBE4WiFrduFwWr9553RE3bdNxqXb9d//UzBaf+ridVGcOuajOcF8te5v/3jcv/FacKOeYOEBQMhO43bmW/o5uqkU7Trfj7D1LG2GGGRNJPGEjTjPiF74/Jgj2IMnI0IBO7H2yiM0RaBa7iKW8OGeti4PYHPdKlinhaMfw1VAVQNiFRUyXhQJ1F5SS3VSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEjL22VqaGpXYA4vmby2URuUX3N7YQSSYenPl/LAiqc=;
 b=KIW4tyBZM0/8VrwjoLuMrdE0lmOKTlPF8rPO3zeGoowJ4esT1h3cighCLKDsGU/BnonAVkALJf9ze9/cIg48En97Q84iOVJK6uMm4Y3J+dNbqHXomFbYAPLuiRdjW1RuWnzQWa6r3XVwrxurPlRjny6G9ynj/JwwNhJuTyCo0ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 08:36:24 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 08:36:26 +0000
Message-ID: <e42564ad-5352-4c00-bafb-e60b47a218d7@oss.nxp.com>
Date: Mon, 19 Jun 2023 11:36:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 08/14] net: phy: nxp-c45-tja11xx: enable LTC
 sampling on both ext_ts edges
Content-Language: en-GB
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-9-radu-nicolae.pirea@oss.nxp.com>
 <20230619081002.x6crxnx7c66z4hhe@soft-dev3-1>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230619081002.x6crxnx7c66z4hhe@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0008.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::6) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bb5984-83b2-48cf-ce9f-08db70a04518
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ooAst+f5iajFWVwJk1o+y3fFSUx9cfELh1OlwE91NQOpZD+Wl83xzE7LaTArJkvyRoQeuRW3GbI+VOw71ZHFnmNgrTIlaNcx0gEuiexcFGD+Wl9lblhXvIVBUuWRW5g7KokiojXdLhXLjzzEFxbIh4NkL4YlZhXupO9f//gdAvtjBl/+9vum7ZnYkYicvKI4uJrSKff8tkkl7C8RI/JRSGQ8Ij/Df44YgvI8LC+5yijuhlqtnG0R6dAKxipknfalEwQ4k/Ih3D6A2sToIdvo1P0iS09FN17Cc3CWes5B7+WkdYv7pFV3ltG3sGQgvUlwwnHKLgLaP6MDk3qWxf9JHQhTl+NBJJHfMjAWpuPBGnsLexwViWN55ZUcnSsGCi9Fm5Gg/+xPjCLhApZmOuFch8qOwBAczHSdD4e/KO5TmwA2t14QEM5amCoQtfZGs/twO/JKtThvyxgo6mxkE2eECYJj0x7o26krgIOqNLbXRwfV+NGQe1rq3EU9S9QWrDPbPcsaAhtABj5Y/8ZMgKpDpI4+ObNXA91fvupo6Rpl4HZqNq8TSeo7R4vVigH1JRqolYoCQ01+yL1yCi5Gm/IMHB+niuKHy4UnZ1vLPRZFjyWAAkbRQFGl8rNVlePby91dPTHj8mv0oSZm4kdkE5Sn3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199021)(41300700001)(5660300002)(7416002)(8936002)(8676002)(2906002)(86362001)(31696002)(26005)(6506007)(6512007)(53546011)(186003)(478600001)(6486002)(66946007)(66556008)(6916009)(66476007)(4326008)(38100700002)(316002)(31686004)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWVkMUNvVXZ0SVJRZk9LVnkxVUE2WVR0UGkreGlZSjdBdGRxZFpMd1NHeXhy?=
 =?utf-8?B?cDE3VFhZQXpqWlhlVlVBYXU2V0dTVnZpa3M2U2dWa1NjbEZzYnZSQXFtOWNG?=
 =?utf-8?B?VkVvTVhkVUNPQzE4b0NnMkx4VkMveHljM09VNzZ1YlNPWXc4Sm84UlJUZXIz?=
 =?utf-8?B?V1c0MHBBUjM2eGpwQUdjQzhzdjE0cjdrVGQxbGM3MlZsSmF1ZHhVclF4bTN6?=
 =?utf-8?B?VUdQVkljcDFYRG1rdERrckxmZXN3M0s2bGdscjJNTXV4SnpLTStxM2NvWllq?=
 =?utf-8?B?WWcwOTRGWi8yV3M1aXNsTy9ldlRUNE44ck1haTd2Q0w0a2phK25QVnJ0WGlB?=
 =?utf-8?B?TGdUWW0vb2I1SkpERmU5ZVVWQ1MwOEFaczJsSWJZWE9yZS81YUNxaHh0Z25h?=
 =?utf-8?B?SHRwWDJXVmpTU3NTL1NMOVE1ZkNhUGx1bndMMW9qVk1pQWRNYWY1K3FtVFI0?=
 =?utf-8?B?MUhIdS9pZEdQcEVLV0NHUnc3K1JVUGtGUXNwWGVHc0RDNTgrNlVjY2lwUHoz?=
 =?utf-8?B?c0NYLzNKWnNFcmJ6Vm0xSTJNTWJVRER0VjZ5ZDZodlEzbnZtUVBFK1VTWDNw?=
 =?utf-8?B?dmt1Q1BMRzVPN3N3cmwrT1NPMDlwRi9CcTN6b3FQZktqdmRVT2JmNnlUOWpK?=
 =?utf-8?B?bzVQTG1Nbkt1Tjh0QjBuNTNjMVlnbjhlSXI1R2dPaWtjMGdKMG83cXVKWjlZ?=
 =?utf-8?B?Q0o4Rko1SW9BYUR3cTV4Z0NuWXVzV2lOSDU2a2JueFhGRW5NQmY3M0lOKy9D?=
 =?utf-8?B?OENsMUpWTmhXak5nUU15M3lEYWtxbi9FR0c2Zlo4dldSV0ZZQ2JaRDgzbER5?=
 =?utf-8?B?ZnRXV2J5bmtHTzBUaUJGcGd1eXR4VXR0UVdhVHJkK0VGQnJ5V1F2S214UlIz?=
 =?utf-8?B?RDVOYnRCTm9kYkVoUmJNQXdWTnlmeG1uMmd2TkhCZVgyVmROalQ1L2VyRG9S?=
 =?utf-8?B?MDFET0tPN2F5OVVIdFV0UDFrbW5WWk4xRVVmOG5uVjExQzdRbWIrTllvVzMx?=
 =?utf-8?B?L21tUFRLd3IwaGVoUGFIQldNYzZuSkIxWHlrSmI4My81cXdZa0MzTmhkSXVp?=
 =?utf-8?B?bTJwSXduWC90eU81ejVxTkVXUndFYTN1dXR0dVNqa01zdmlTT0F2YjhKYWNM?=
 =?utf-8?B?OGxoMDFpYXZQbW5qU2tTcitoSXpIcjQxS3l3aDRoT2dtaHRQK0Y2RTRGUEZa?=
 =?utf-8?B?NWR2dE1QdnFIT2xxUndVRHNMUkRNb2QyVnc2U055R2o4UktWeUp6aXJ3THZj?=
 =?utf-8?B?RjhlTUR1YVVjSWk0UkJSdVRhemZCN29DdGxZQzNDNFRYeGdoQVNlc2FWZUl4?=
 =?utf-8?B?VzhITStGVzliUDlyNGlzNm5sbC9lTW50YkNNdC9HcnkrMGxMZHJ6QXBzNFBi?=
 =?utf-8?B?R0JRVmwxMjBFSE41Slp0c1BJTVdCR1RpRWFBa0Y4dmc0WGFhNTEyeFVGUVVW?=
 =?utf-8?B?TWJFeWNCUVFQY2EvQlF1NzhncWl0dm5ZYkVOMFZhU3JLNWQ1UmZmc3Ayekda?=
 =?utf-8?B?bm9yMjZYQ2YwZmNqNXlYRk9tQlhwTFhTZ3VESExxZUR3NFZKRGRES0hhczYw?=
 =?utf-8?B?enhqMG9GOWRUT3VlVHlsdWJLOEZxYTZJbGxMMzRTNHdVbURlYzJSTllRR0M3?=
 =?utf-8?B?bUFiVFhsTEVvckdNSUVBdWRUODZMS0YxTXRUaW9vemFWM2xKeHdNMVA2VGNI?=
 =?utf-8?B?dTZzVHZwTDlKYjJNbFJRdXJZbDUrRno4Y1F5alB4b3gzZ3RUWVErb0JTSkxT?=
 =?utf-8?B?d00zOFlCc0lYUmVET0tyRER4OTFNYitQRUV2Y3FKN0k3TG1YeE1DdjFoSXVv?=
 =?utf-8?B?OXJjKzBvQm52cEFjQzJMTnRHT0tXNXpUZWJmK2o1Mkt4V0hDc28yK01yZVl2?=
 =?utf-8?B?Sy8wamo0SUZuakpCcnVDRGNqSVRXaVNUZFBsanlqekpPdVovLzl4WXJRT05s?=
 =?utf-8?B?ek9lQ1FBMDRHeWoxczlmZVZNUXhDN3NoRThWZENMdEtvRTk3TVNIYUdOaVJR?=
 =?utf-8?B?UEsvbjR2dVNScTB0OGVpTk5kNU5pS2pzb0VodlRtVmJuVkQxWmRRaWJWMk5R?=
 =?utf-8?B?dEs1ZFJQTHhjQkJZc2JvNzZEdlBYZS93Vm5GcTUrZTFrR0xERU1DZ0NHc2RN?=
 =?utf-8?B?TUdPUTh1dWVVTDFBLzJWRFUyVEg2amJrT0o1UFFIQ09OUXNqYXhoR0d1aUZS?=
 =?utf-8?B?Vnc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bb5984-83b2-48cf-ce9f-08db70a04518
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 08:36:26.2882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q66cEbcJiJ1/7MwkSdDqHdraC2lF2fK3KQUaulizEs21leqbqtQvGdOfvlDaZW64pdvM4J4DQlglZ9SpOwlNyJoVAQ9nLJN2pMFGdcgZoWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19.06.2023 11:10, Horatiu Vultur wrote:
> The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:
>>
>> +static void nxp_c45_set_rising_or_falling(struct phy_device *phydev,
>> +                                         struct ptp_extts_request *extts)
>> +{
>> +       /* Some enable request has only the PTP_ENABLE_FEATURE flag set and in
>> +        * this case external ts should be enabled on rising edge.
>> +        */
>> +       if (extts->flags & PTP_RISING_EDGE ||
>> +           extts->flags == PTP_ENABLE_FEATURE)
>> +               phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
>> +                                  VEND1_PTP_CONFIG, EXT_TRG_EDGE);
> 
> With this patch, are you not changing the behaviour for TJA1103?

Yes. The behaviour is changed. If extts->flags == PTP_ENABLE_FEATURE, 
the ext ts will be enabled on falling edge.

> In the way, before there was not check for extts->flags ==
> PTP_ENABLE_FEATURE and now if that is set you configure to trigger on
> raising edge. If that is the case, shouldn't be this in a different
> patch?

You are right. I will split this patch in two. One that enables ext ts 
on rising edge when extts->flags == PTP_ENABLE_FEATURE and another one 
with TJA1120 changes.

> 
>> +
>> +       if (extts->flags & PTP_FALLING_EDGE)
>> +               phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>> +                                VEND1_PTP_CONFIG, EXT_TRG_EDGE);
>> +}
>> +
> 
> 
> --
> /Horatiu

-- 
Radu P.

