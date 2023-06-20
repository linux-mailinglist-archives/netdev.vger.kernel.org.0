Return-Path: <netdev+bounces-12264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FD5736EB0
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31201280D8A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847FF101D1;
	Tue, 20 Jun 2023 14:31:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ADC171D1
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:31:22 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623F3E60;
	Tue, 20 Jun 2023 07:31:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb9ZHmJTCedZjEtknjQjEV5JCTd2eyFmA6aL5KZK3XPWqyP9rCxhskDyMZt2EPSZztJnE0YqeFtMNC3U/cFyWu+yiIuDdQb2XuoHf4Pf7Xt/ecAcTjJU/QV8YhBdISXTyCtQs+AmMw/dRNdIUl/NNdTiYAO1LNtZc9pRqFBaTrxKk7+OrBXx8CLYMqURquJmHzBqk5W4+pcGsZZVUbBzn8zH2Z6BdmezL5uR92QZXP/EVsXo+OCSmwOMp5HGoAALhCWfSIu1UjDZFBbiTDEzYExeV5cSNdB3/bxnFLBLXUukUcGVbGm43RKnIAyrBOx2DWAA6e651C3bhIRk/zdq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixp560HHwJZjVmiBb7xpiCt0CR1klZGMu62tDA6jDTU=;
 b=LUf3GUVFwSzJMweyb0Lw7cNg7jAQvTIjC9fmaeIdy0IZoVE+Pk2ygJvNThWRM0BDCd75VDIYn4h6sgoxh2ivTaMYMBd2WLWQr6LavT7qe0pbLha/Dy+thjSxXORZGx0rEg+Dkne3OkFMA5WFK9Vp+62l0XajnMVNnxWBgFSeFIHXztMHEqwTJtb6g8+RPE4URCQMgv225Ei09qFwMpenPBrLwqEUtH8htyLkUr0gDZF/bqb5bU2Pg9Xih/XKHAOmyrStok+lezS+tMf3QNNJvDUJ5mxD+Ul+fGti27BoOuW0bwuaZW0ZguTYphBazQIu+Hcz+6OTtEeiBKYTVx5YTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixp560HHwJZjVmiBb7xpiCt0CR1klZGMu62tDA6jDTU=;
 b=SzcNELvYFA3UCaf/gW9YuuyfmTuGw/CdMRQFLc7VpiLC4oRjLVTHc5czem6hAFsM6p3TxIHY2z3TVcJzxOkdi/JvQt3ChAEMQqnjonf14VZZ3C2UMi+AZZuMLPCLle7La1lBJ1iVawDEqVIeBN84jIoIhjlQFGibS0kaMBMByqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS8PR04MB8676.eurprd04.prod.outlook.com (2603:10a6:20b:42b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 14:31:17 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 14:31:17 +0000
Message-ID: <b8415da3-80a5-5206-01bc-53dc8950c545@oss.nxp.com>
Date: Tue, 20 Jun 2023 17:31:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 12/14] net: phy: nxp-c45-tja11xx: read ext
 trig ts TJA1120
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-13-radu-nicolae.pirea@oss.nxp.com>
 <20230619084941.q6c26zhf4ssnseiu@soft-dev3-1>
 <1052d020-6866-f1a2-2b59-bec88ff00271@oss.nxp.com>
 <20230619104813.tiodielj7faw557s@soft-dev3-1>
Content-Language: en-US
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230619104813.tiodielj7faw557s@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P190CA0032.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::45) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS8PR04MB8676:EE_
X-MS-Office365-Filtering-Correlation-Id: 6161aa3d-40ad-4c09-e026-08db719b01f3
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dEJChRvHC71N+FcY3//G341XO+iwf+KDIf82Mmq6cNYWes3sExY3qiTna7ggSRDo5qlgV6VvamjQ0FesxaCFAkNm6zl3iKye9+isKqvEDDwPU357hruOJ5l+T2YAxMla8JepgW4ZV17Pd+gIHiZsH49asRxfjuqdRHrf7z4w0whlbpot2hrpHPF4P12xJCmYh/d8322MFpqM+sXiJE9t0uaPSgtXfTiJdSXh7lGiiLQq5Qjih0HDoxvHDbXiH/cAVhRhd0L+JwyzVsgkRJeVJ2dKYeaaDaOkLN9sAsefIMu2I+7ZTOG8rJhCVFprAtq901kNrlDGN7giCw2usxAKwIqWEoqzrpYhj7dh/ZTxmFdDNDZqNhEe4Q9hS0tT2qjwUNBj4Em12mquinEgqJHU8EwuOAJKyXCcoIfTcAFCs4BOZzjro5wAvTCBeYmuuk63u4mNm1J6xtUmLtNxPjdN/T91qzp3GDK3CnOaZXVpU+LvDblHaSZt8Q3GEZeRBe6cYJcsjQKP6e3FkswpEA7TUmAmkCun6MI0sYrY+rByFHWk8qVzJOawDK88IN0bmMRrjF0r0lMRzqczd2vcHQ4f02zHJgRWZn3g43JIksw8w3ek7FpMc61L1DUkOSFyp5PjokBbvxpAsYc5wfuvm/TGkA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(8936002)(41300700001)(8676002)(478600001)(38100700002)(6506007)(83380400001)(2616005)(6666004)(6512007)(26005)(53546011)(186003)(6486002)(86362001)(31696002)(316002)(4326008)(66946007)(6916009)(66476007)(66556008)(31686004)(5660300002)(4744005)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzI5dnhNNHJQK1lwUGNRdlZMS0NrNURmaGVJYnZUTndjRG9YMlZuQk0xeEhi?=
 =?utf-8?B?RGNLb0xKMGVwcUtsWm9LZzFpZ2pMSWhkSXZVSkNiWmNRNkFQK0tjOWVsNlJD?=
 =?utf-8?B?c2NIWVZEZi9ua0ZVSWhOa3pEWTk2bzRoZTVEVjc1VnN3SVJuY3JLWGN2TDBI?=
 =?utf-8?B?dzRpWWJhblVTQk9vM3RWWkFIZld2ZW1UdVpuUHgveFlJTmd6ZHloY0JIb3VK?=
 =?utf-8?B?V29kTlZEYStVRU9lNXRjbWQ5ZEsyaGVjTU8vaTd1Y0JPRXozUm5KM1VrVFYv?=
 =?utf-8?B?a0JQVHFMc0lubzNuTFNUWWpOUnkxckdWYlY3WElpb2R2SXlDbFlPNERmd2VY?=
 =?utf-8?B?ZDV1UklaVDdaRG1nK3Z5ODdIMk9GSHB0Q20rNVRUa29RZHQwVS9wL2hETTBE?=
 =?utf-8?B?SEFac3gxbVpSNE1acVNDSUtkMDdYVXlqTzFMUGJESHA4dDloZ1Z0NzNyaGFw?=
 =?utf-8?B?N1A5cGNYYSttRnhYM1N2R3lmNFhmMGx6MVpuRThYRVIwWjB2MHQxQ25zWjJC?=
 =?utf-8?B?VGt3Z2ZHbnRVeDg2ZDVWUExEZ2k3bVhpZE8yb242d09BcVlyQVdvN1RGM0tj?=
 =?utf-8?B?RzJQZlozZUp2OExYK2l5R3RkaGk0ZVFoa2p6RmNjVk44T0dsMm0rSEt5WDdI?=
 =?utf-8?B?Tkxrd0RibUNTYTc4WlAwTDNFNTF5VXFFbVZQSlJJVlp5N0VKM2JmM3B5b1Y4?=
 =?utf-8?B?c0tMSnM4LzJYU0RkYjR4Qjk3OW9zL2tiaHZnVWVpdk90MWxCeHJ5Lzc2R2sy?=
 =?utf-8?B?b2phamlZVEhUZDBYMU9nYjZWTHRZWFVubmpMdXNuTGFDV0Rabk5nSmNIVTNO?=
 =?utf-8?B?ODlwZU5WaS82MFhaYkFmTEtmNzNOZ3JPV3FyaGtmTHFkNHFhMzZ2c0R1Y250?=
 =?utf-8?B?VTFOdkxuTnBTSlNwOU16Z1lGclpXaVFDRzdqVmtDU3dTNmdCbi9lRldSbWdU?=
 =?utf-8?B?ekF4ZVZ1cVYrNUlQSG5wMmJEQXFSRkJKYXhGb1YvV0tvMWcwbUpURVE2YjQz?=
 =?utf-8?B?eE5mVm8zSkRNTm1BMUU0K0Z0RVFVZ3M5RmRNamFOYWN5NDZVZnJsUk56MTln?=
 =?utf-8?B?RUxad3h0cWc3QjNXeEl3WUtuQTNEWXpiVTV5OXdTNW5xbElTdlFVWEl4NWVm?=
 =?utf-8?B?SWVTNVJwSVRzZzdLSWtUOVhDRmNJcDFBL0JaZVdnYzZlaHVTN3FNZXNmYkRX?=
 =?utf-8?B?cVF2NWE1YkdBRC9kbEJ2aTRZVUl6Q0RaNVZ0cTAya2JLWkhPWXlzQWkrRWhy?=
 =?utf-8?B?T0pCZGE1V2JrcVY0eG9ld2U2NlJ0UmM5dm94UXVFaGtSRkdFdS9vNWZaTXI4?=
 =?utf-8?B?TVRnYzI4bGhVdjZjcjBYUGE1eDBzVjl3aldpUDY2OXlubXRDZFlBa0tGelB5?=
 =?utf-8?B?ZVhUZUhtNmc1bzdUN2dSU2tncFgyRVU0bUEwTHNIYjdiR0NBaW8rUUZWaGly?=
 =?utf-8?B?VDFnOG9ZZ0RoYzdqbHgyN1FTMXZ6a3RXSmcxa0lxNGxpUitBVEh3U3pDY0E4?=
 =?utf-8?B?VlFpK0ZhUzlRcHhrYkkvZnp2dUcvRE9mcEJFaXdIWmkySityZnJhc1dFQjlX?=
 =?utf-8?B?MFc1aTROVFR4SitidXdEZG9wY2tFVk9pM0FkUGxMQmZuSkFQdHNBMXoxcWtm?=
 =?utf-8?B?TmtYc281UjV3ZXozaWhqVjZFMlZ4bk1HWlhjVGUwdnFwK29hN2FwQXRNUm56?=
 =?utf-8?B?NGkvTTNrOU9uNFlZaVZQalR1d0NMb01YNFNnb2pBcWNiNlhvVDNOdFppRDU1?=
 =?utf-8?B?WlRHN1YrVCtBditGQXhhVG9RZFJ5eFh6WGk5QjQ0VFRsdHB2WXNRN1VjSFp3?=
 =?utf-8?B?ZWZDWHNXVnRlWnNYenh1SS9TdnA1M3hJSzFyNG5vZEdMK1RUdG1yOU0yaWpX?=
 =?utf-8?B?L2FhcjJvUjl5SWRYci9EODN3RzFTdkN1YVNxOGcraGZGL3JyUEVxT1BlbHlL?=
 =?utf-8?B?bERiMTdMa1h2WHRJd2J2eXhlOW9VZ21MQVZ5TG5iTXZadVQ3WTk5Z1M2Z05a?=
 =?utf-8?B?aDdzYjBmY1hmZi9zMjFvTlFoQWNEQkcrbTlQZUdqS2V0VXpuRnVBWERuY0dj?=
 =?utf-8?B?d1drYkNKNlhEMTY1N1BOZHNCY0FxeWFUTVRhdjhoMUc1bFlpQ2lmM1hXMnIr?=
 =?utf-8?B?M2Rody9CeUJ0NnhQT2hWNE02dWx1eWVVc1ZVVHpEL2ZJcnZ6RUhKM2E5MkQv?=
 =?utf-8?B?NlE9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6161aa3d-40ad-4c09-e026-08db719b01f3
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 14:31:17.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pobuvgqihgELNAIdKNXElFOoYnKapXoZrN+hO7T6GlSCCR5Ed0R7JfZHZa5dODqI4U1fYIdfhqo/d1IkV9Nww28x6TyY3CO1Wk7qjOwFMA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8676
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 19.06.2023 13:48, Horatiu Vultur wrote:
> Caution: This is an external email. Please take care when clicking links or opening attachments. When in doubt, report the message using the 'Report this email' button
> 
> 
> The 06/19/2023 13:07, Radu Pirea (OSS) wrote:
>>
>> On 19.06.2023 11:49, Horatiu Vultur wrote:
>>> The data->get_extts can't be null. So I don't think you need this check.
>>
>> I kinda agree with this because _I wrote the driver and I know what it
>> does_, but on the other hand don't want to fight with any static analyzer.
> 
> Yes, but then wouldn't be an issue with the static analyzer tools that
> can't detect this kind of code?

You are right. I will remove the checks. They are useless in the end. A 
check of private data will be introduced only if a future PHY needs it.

Thank you.

> 
>>
>>>
>>> --
>>> /Horatiu
>>
>> --
>> Radu P.
> 
> --
> /Horatiu

-- 
Radu P.

