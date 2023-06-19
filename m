Return-Path: <netdev+bounces-11910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CDC735180
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BD3028108E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB170C8C2;
	Mon, 19 Jun 2023 10:07:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72D5BE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:07:43 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032B612F;
	Mon, 19 Jun 2023 03:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWh3ri3+SODExOT/ed+avSeHBKSEum92D/4k1H4dhYwjFYUB6aMqQ8KuiX11jJM3/kcY6M727Dy0Qjid5PHPjqPb0xGe1C3U3X1uI5hgaxGlZpdSH75qc0meEKRJ2GUc8rZqcmNjlq9bx6hYX45GU3ZIEDR/9Cuhjq3SLdxtxp3sbIeOUQhruCvcAD8UKXXwWr2bQZepNjh/gRHTUfnUQ3SYtiSw4KZHBbyUL5iBrG5xJPwAt0U6cv/NQOuW/x4Pdyyeh4V7qfUk+0Qq6HhBypjPli+tAe48oTch2yPzUJCeJ3jqU1x9ErbUGBFp8moqCL/X+B2LN3yafPskQRKVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ihlua4ATadq0dkl3dtZqTOigydX1ydUAY+OynLsqOk=;
 b=O/Jro943DSBY8HcktCnaVCgy6Oz83Zw+VE2buOmAtFIOIxMUQY3Ja7XM1bCxu3hcaU3euuwMM1xxbWipugPKDI0KNonQa8euocjTOQmvZwXvraXkIWww1cIuto3tIRE0RFZPPruxZpMq/y78aBXjq/J8wtT4T46d53Usw6OnRkLrfkLCzKaQQiGMzmybsI4GVaSyM+X8BTElM4DoGfE7iI20CXh1NbjyxxYYH83g46I4lOKzkCfsaLFh1GuKsFkWORbIxRAVz4IAaR1DkQWWC9bEqyXWN1WC1Y8Y2xmwgapHa04fz+cbE3JVuImutktcEnYH4JQmf0p1Ax8pfPwG0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ihlua4ATadq0dkl3dtZqTOigydX1ydUAY+OynLsqOk=;
 b=MnkOIB9KgbJwlG2bB9t2g9Bfg6ebmu25BixSQalvh43r8gt9/IrXPXUlWkdvqOgP9jHWdZ8qfvgsd6LKh+yhjQ48V73OFBs+xuWkY5Q9cRGYj/SW6zh7Hoeb0aXHMl2dnitj5KNXtoIXOcvZnlLe23FuK61XZJXRw9IycWYOmDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS4PR04MB9573.eurprd04.prod.outlook.com (2603:10a6:20b:4fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 10:07:34 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 10:07:34 +0000
Message-ID: <1052d020-6866-f1a2-2b59-bec88ff00271@oss.nxp.com>
Date: Mon, 19 Jun 2023 13:07:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 12/14] net: phy: nxp-c45-tja11xx: read ext
 trig ts TJA1120
Content-Language: en-US
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-13-radu-nicolae.pirea@oss.nxp.com>
 <20230619084941.q6c26zhf4ssnseiu@soft-dev3-1>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230619084941.q6c26zhf4ssnseiu@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P195CA0027.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::32) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS4PR04MB9573:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6380be-522a-463c-5270-08db70ad0098
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1TpY7shtiYwpJXddk3kPKGwRBvWh9ql+3+ZejJX9vTodw+YTk3zMxCFylOtCpTqKHTggXMQOsr3KFRnqGxss6xDpBvIr8H/MiZFZLhgJvUcrRxN0qly6ThO2Ub2sO8XUB6SmAunaK1cLV9uC8TI4PtB0t/smZBwMmxj2mspj9VJD1qfS5lye2HSGLWURK2mEaCN7ItB9tiR2fwFEplf+LIX684DGRE5rGYSAW4N9+yU/enxyc6uN0g8FHMN9QFsONQBUHQ/7muzE3wCguGZRmn7cv9iH3mBFomNlnjEodRZDzMVbUjq2i+hT1vvVnj/GhqqWs0+AWqKwVAo18sFihSeENo3xL8z+LIPGmRHIrrfHGvE8Zl62BCVPDdF2hqGrS0EXa4RzvO7uXMCEcxE2xT6vqWDEDUrpeHLeHSZAGm9wu4Ju2AuOC/YLvceS66jyKrtKnNFVMt5oh40cRAHLQNyubMFuFYVQWbnWzhRjb/VwEXU9ZqvLlcpoFyjh1NcMPBRK5V1/qxvvwjz5ydeyOhhabuD/+MLVcfHuY/WTaC9MclwFiubP2N/3wndF8R8lT2BoKT4iFSpP6k8CxluKzjNJh3wzN6qQzcLjLsyr7wGFLUElf25RfGRp5sNhdLGFcoW+szhvTu+trVaOlHy81g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(2906002)(41300700001)(7416002)(5660300002)(8676002)(8936002)(558084003)(86362001)(31696002)(53546011)(478600001)(26005)(6506007)(6512007)(186003)(6486002)(66946007)(66476007)(66556008)(6916009)(4326008)(316002)(38100700002)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWFmTCtGeUo4M1gxR1BGQnhvVlZ2MVJ0RzJ5SGlDY1ZFT3F4ZFlJYzdkMGxF?=
 =?utf-8?B?aGlOSS9zYmFuS0thK1dQaVRHOFE3Zk5yclhTZlc5cHNKbTFFZ3UxT3haVnp4?=
 =?utf-8?B?OFl0NjNqdWNKUmpPN2EvcHRhemt1cW5JaSs0RDMwaE5OcTgyeVY2UUdDalFn?=
 =?utf-8?B?VE5MK0o1UUdXUGErZjJKQXhMN2NidE1TNUxtNmowcmNSbFoyN0FUQmNxTkM2?=
 =?utf-8?B?cDQxL2YvRWZRL1lJcE1iWlpoVERzN2xPSTA1MFBlV055Q0lxcmlYeGJEbk9m?=
 =?utf-8?B?dEI2SDQwMWViRW02N1RBbEtxeTExQnpaa0s3RDFwWjBUTm9Xd1Nna243MjZw?=
 =?utf-8?B?VkhKaXU5ck1BdW14VFpkYndBNkhtVEhhemwwMXJuek5RQXdBRTFrOVQzc1BI?=
 =?utf-8?B?S005TWZjMTRSR2RQbGVxak9yS243ZGFzbUxpVXRsQm1OQ2VQYUZuUjFGUWhX?=
 =?utf-8?B?V1ROaUQyZ0MwSU1UK05COEI2V0FaNkhZSXB3c3JNNU5xVWRhaGMxSHFUWUEy?=
 =?utf-8?B?VUxBSVpaQmdYUFhNVGdIbjJLUTJDV3oveFlFR0h3SEpHcWNLclNpTllpT3dP?=
 =?utf-8?B?bjNDTml6VVIvcERrcnE3bjArM1RYUWhuWnlMclBoRTVRRGZ5eElFS0RzSWZp?=
 =?utf-8?B?TGNKUk9YK3QrVFlzQzdReHM4Y3F1N0EvV3ViNWEyTmdVWEplamlyc1BvcHZT?=
 =?utf-8?B?VkJPZGFjajR5QStXYno5MEx5ZHJ2d3JCSUxkdEh1bzlTWTZnWHFQclVnbXVI?=
 =?utf-8?B?N3FVeDRWTUJpOVRZYUNNR0ZHaHF3S0RNdk9TK2VpY01GdTB0RWpVcWpEUWc3?=
 =?utf-8?B?MUQ4MnNIdnlPSXJ1RHdqQXVCQ1BOWlBCMjI1eGVkWndCL0huajkwMk16OVJX?=
 =?utf-8?B?SmtMcEt5bVdncWNDVng2N2M4V3NwYlBsaTJRQ2dzYnB1aGVZeHlHZThIeSt6?=
 =?utf-8?B?UURCbndLRE9pZkpuM0t0NXFDdERkb2ZBKzJCV1k0TGVZVmFtU2g1Z1dYU0gw?=
 =?utf-8?B?QnJvY3BEcDFxajFTdG9yMUxISkRrT1VKQmN6SUxBNlkyMytqeGFmMnJ2Q3pK?=
 =?utf-8?B?dlhMbng3bzlqbEFnTzBab053KzVpWTJGS2tKNG5rSURqRkpCd1pza1RKYkZ0?=
 =?utf-8?B?c3Y1Q3YzZ0JFZzJwbll3U1hyblY1MmM4dzlmTXIxUURmZmY2UDBMUmdoOFp6?=
 =?utf-8?B?L2lMT3YrZFRjdWh4OWpyKzBwMWgvT0lDTCsrajk4VGVYb2pPZTVDZGhKQTlC?=
 =?utf-8?B?ejREV2RCUWZFaXNyZGp1U012Z1RNQ25ObDhkdGEvWGNvdDl1dm15ZXY5NEpi?=
 =?utf-8?B?WUoyODlEelB0dEFyck5ZeitlMzMxd2FuQTBmZDRsQzlIMjd6WldYS1dXSDUw?=
 =?utf-8?B?NDlDa051NnVmcnRsUGM2V0dTNEEwci9vVGI3VU55T3RDNHNkTzZlWHFWRTBQ?=
 =?utf-8?B?SVVDbTI3emNGNE8xUWVlcXpnZWIzdEJIZHRoeG5jTjI5OWZkbzY3VERyUEtj?=
 =?utf-8?B?T1BTTmtZNDRKYnI5b1NQcTE3dUhqSUd4MFRqNk0wTlpZK2dpMFQxQncva2oy?=
 =?utf-8?B?M3pMWXMwOHRraDBsSXRRdTVkUldRa0p1YTZPa3ZLNUJlTHQ2WHduaml6bm5E?=
 =?utf-8?B?RWRUNDZyeXI4QXJFMWk2OTBrbmJlYVk3R1FVby9VaUVOMThiV3JPQnkvcXN4?=
 =?utf-8?B?TG5BUG9pakg4SU9MdlRaNE1xVmhXWGkrZE40VUt6R25zL3hzQ1VNbDU4QzJ1?=
 =?utf-8?B?aGUrU1lNU1B5MHNWZHdQT2pkK0dqYzYzN1Z1KzY3VGllZ0htNklzeEhQalpL?=
 =?utf-8?B?QVEzaVlMQ3NCaDBPcDZoNjZVTVV0QUVERUlmTXZYUmhXbzN6U2JUdTMrelY4?=
 =?utf-8?B?WkNzdUxJTU9ZNnlLa0F5TUZJdFN5K3laSG5PT1F3RlBFM09hdCtZOEpUbVcz?=
 =?utf-8?B?KzBBaFFoc1l3cXdLMDhFaEpwUUJvcTBZbXlQVzFtckEwVnBhdGk5c1FIS28x?=
 =?utf-8?B?QmdZODZ4dWpkdXZkeS9nRGIwMFBlVXl5MlgzMHh3aEsydlBTRE9oU1J6ekFG?=
 =?utf-8?B?MFQ1M2FjNGFFOGRldXkvbnlxMitDSjh5a3dNTmhaVndGd2l3VUlVaXFLTWdx?=
 =?utf-8?B?VUQ3MjhQc1ZnaVZBMElReTM0SVJHckRqMG4vejVXNkZWbE1mRkZVamNCS1kx?=
 =?utf-8?B?Y0E9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6380be-522a-463c-5270-08db70ad0098
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 10:07:34.6670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTlXDv216YKEXZdcflDPwkPbZ+db73gdb4FuCFZOym+lz7zJqQS2zfgKQNn01JBLxAwn1vmAoN/9w9ue8Lm5GR7Zo0mfuPALX05R9qUsNu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9573
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19.06.2023 11:49, Horatiu Vultur wrote:
> The data->get_extts can't be null. So I don't think you need this check.

I kinda agree with this because _I wrote the driver and I know what it 
does_, but on the other hand don't want to fight with any static analyzer.

> 
> --
> /Horatiu

-- 
Radu P.

