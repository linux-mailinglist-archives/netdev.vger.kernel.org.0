Return-Path: <netdev+bounces-6324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A49F0715BAB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D4DF28110F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CACE174E8;
	Tue, 30 May 2023 10:22:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5964F168A9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:22:31 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::61b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D799319B0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:21:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbvvg4JzB0EXXp/MaUZ3NdICTmizN/Tz+R7JoSbWgwuReK9ptpzVvKG0Hibg8XWR9RSKn6KXi/IkyvM6y8XgNiahKRjMCG/LtLss6DGXmtNtH/6wh4o6X/I2H83qbygDmoKtA14hBbLgtO6xl6M41qsM7YmHnWiCKQIW4XkIU6xLH09TCTai1kp2S3sbXOApL01ose9PXv3Mx2vcenicTpkavh/r6GbgGTHPKHR0xKXn2o590+qlhs0A6YdWb9qJh2YZnMyfsKOKpR9xpwu7KIshnOUzactXmy7MOqy8N4mXcSCDvZMm+aBp6QjcLiBaCWWqPIEZAkAEF1JNFNfEew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKusgFkUIlIQ3K/ooBcvk5APoY2v5iwTNbyD8vygKv8=;
 b=Pu1dkU/0ZTzOraQCfhnUwqYdXzzOqXWx07rAdH0n+NmoGWb97Lhl5SKcYYwITmy5aQLX+FUCMiLL/KI4igfZAqOdfzheH7r6j/dtT1oMoKu9bE7Vocyd+wUCa6ljKMxjSctVqjqSiVd+c6ukOg0sneJYsUviXLhB9RUne3oJTNs6dxL04VYEIoQSTbZuleQPEL+A14bYKrY51tPEUk58IoQvt/ZEOrx6QTmXKGZF7DYmuw1sYWDLmm+iUBK2axBeMR74Csftz8JnRcp1i9J0VOiBJOhM2iy3NF20rc+wP67WcwbZla5tTXMPZeipc0lHeh0PeMnKEqmFfG/+H2iweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKusgFkUIlIQ3K/ooBcvk5APoY2v5iwTNbyD8vygKv8=;
 b=tOAD4X4PImVBK2nmkqu6eX/qZurwSDkyNxIXAfGFHynscoQroHEkEy+SdJlxz/lPPcIm5NK5yI5F6WmIoDP7JVsLMrBInqL16b+04PojiPcsPQcXjesmH5HQpQ8J7rP2j93/PQvDAFN4K9E2mhbHwwPJJYHznvYxPaoK8cPZF10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 CH3PR12MB8401.namprd12.prod.outlook.com (2603:10b6:610:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 10:21:41 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 10:21:40 +0000
Message-ID: <058f2e61-159f-536c-7a1b-eb58f742a66d@amd.com>
Date: Tue, 30 May 2023 11:21:35 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting
 the channels
Content-Language: en-US
To: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 linux-net-drivers@amd.com
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, habetsm.xilinx@gmail.com
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
 <40d9d9b9-0500-2c68-c047-20b1a090c0bf@gmail.com>
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <40d9d9b9-0500-2c68-c047-20b1a090c0bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0067.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::18) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|CH3PR12MB8401:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3b6659-6c71-4ab6-a032-08db60f7a89d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JAUWKIBk1GNCQnxhMy6XITcLAey66K+2mq+zA1mMmCN4RrBS8AM9Tt8SQ75F3tRLRXRVWwsapVU4+atWAhZzrgvKyPMQd9VvVneBR3dCJhQN0lGUebnqvp1cj5/5SpCM3ajoMrtCFznQhmoq11xXZUB57tuNn7+Bg3LAMx+MuNtZhTkmf4v9wcwx7QcTM+/WiE/KfbPA5l5uKLNMqeHY18qVi+5W/nnMdMf6SZbeytYNhsWTgUWUaDkWWFcMxx+NVobNi1nH++Qm5GrWRL8mnpW91WioPf7X5zwj92Jekypt4lFVlRxHEZrR4PaOq3fnH9tFIKSSNhaZ++Ve18g0j7/GQPu6wIAm48ybQKhzdEEZrvddOoLQH70DWzf5g9lxjEBw4PQ7U/ukJ/oXQcbbkO5GQbc3oocqews0djTBb//oxF64u+P+Bs9rSCLoqng1pcZ3IB8UbW4E2D6Gtlg/HOmhAgXd5cx+AVZnevVunGOaMx8GdAiRxkg+ecrY0zDtZNacY8nKSdgjdxle2ukZGY6qJqrgwuSYdchKTeB2MdLXnIxwuXS51U/fAwXCJnKSz38CSpyOnrz9BOGZp3f58s+43tzO3eWKW1RrvWIoybaA3EQqA6JitAwiiCjfAETc1usq5ZEVcQ1aYj990hcReg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199021)(31696002)(6486002)(86362001)(41300700001)(4326008)(6636002)(6666004)(66946007)(316002)(66556008)(66476007)(36756003)(5660300002)(186003)(8676002)(2906002)(53546011)(31686004)(6512007)(6506007)(2616005)(83380400001)(38100700002)(8936002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkM4b1d6Q0U5U0VyVWFGeG02OGJzVTlvWVdGYnY4MEJDamxZaUE1bnJ1TE9P?=
 =?utf-8?B?c2p2MXBKSUpOMlB5aFUvaFFGZ1pET2N5QmNWeXFYWmIyVUtwWmdyNXBNK0dw?=
 =?utf-8?B?V1gwMjNQQytOZEdPZldWcjMxcnhFNkpSa2I1dVl1VnBnSFlpTkJWMlVjQTRX?=
 =?utf-8?B?QlBtVnJYTDF6eENpa09WVkNvQWpRWmdZWWdGLzk5enZnNEFaQnJTbDdwS2Zn?=
 =?utf-8?B?MWFRdzJPM0VNaTR3NmxrYUdlSkVBZDJua1hEaEhiRWxlWnVOd245WHNWODFI?=
 =?utf-8?B?OERXK1lKbUhRam1TcXE2cnNRL3ZuZExlbXdablpaVFY0WFVaVmppcHZqWXhB?=
 =?utf-8?B?Ukp6ZENtTTg5WkZTUVJxZW1PTGlGRFh4SzY2eDlRV1I3ZTl4UW5RQUw3cmR1?=
 =?utf-8?B?OXNHY1dzRlNVSDVVL2lXSWMvTzRIRWVZdHdocGdNUW8zMmRoaDJpR0MzY2tK?=
 =?utf-8?B?TXhzaWRrTXJ5QXVmRlNWc2J6MndwV1FDZHJCcHQrVm5BMVRDOXEwMFNXWnh6?=
 =?utf-8?B?ejlPZFRKNkZJUHhnTnhPOFA2eFFkWHBvS1ZhTmxYc2VCWllrcGhpeUpSVFZJ?=
 =?utf-8?B?SmlBaXJiSXRiYUNaQWRzNW9oMVBNYUdqanpzazMzUnZMaU1BUVBYWW5sN3hj?=
 =?utf-8?B?TXpNaSt4L1JSSG1ib2UxeEV2VDc3ekpMaUozL1dZUDV4NlZUY2JFTGE4Z1Z3?=
 =?utf-8?B?YUJJSE9TbGdlakZVTEFsZmM4N1o4T0RKRkJvVUF6L2VIWUpwWGRRNC9aNDVh?=
 =?utf-8?B?VkxnbCs4elpVWGhGcDZLcXZGUFRVNExzc0VMRjBsalpIL09ZdWJmMEpFOHJx?=
 =?utf-8?B?dGw4TWQzRHFGcGtuejNoV2JpVVZ0VEpLMjBwcUZwbDBLZHlKOFVUN0RrMUtS?=
 =?utf-8?B?S2hycW05eldiSGl0OVJNeStTNVJvU1hkUDF5RTNPM3Q4STdYeUpESks3Y2ZP?=
 =?utf-8?B?SmM2VFFXSHoySHdhWTdDNjhZTHp5MFRNdFgraEszU0hhR05hQ2s2Y1pYMlJv?=
 =?utf-8?B?eXFtNENMbHVSemZVZXFaYmlNaklMTDRiQnZuUlMrdmpaaTVPbnBCWFRDaFlY?=
 =?utf-8?B?R2lQajZLWis2QXgrQ2kxTGxBOFh0bzdWcEl4eGVXZ0ZzeTRTNFJDVnBPcDIw?=
 =?utf-8?B?U2ZQRG1LbHViSVNReEdDNjJsUkVrMEVpcHowOFhyNUZsamZJWExTeU9JcTRr?=
 =?utf-8?B?TXZJYU4xa051alJPUTIraE5UdjhKb081R1J2c3M5eDBPY0tmKzFGTHNCNHdD?=
 =?utf-8?B?MWNkRlJRUFMybzI2eVZoQnZIdjlpdWh4WU9DY2FSY1M4VFByT0d4S28xMENO?=
 =?utf-8?B?SFZMcFlVR0k1eEFkY1NhUm9MYUswRjZkeFo2Tlg4eVdTWEFkb096eGtTY2pB?=
 =?utf-8?B?ejhDN0UrdkYzdDV1aGV0K2c1dVQ4cVMvRy9OSEVsTEdUNnpFMGkrNVlvSkV2?=
 =?utf-8?B?NlRGSkpuZDlzOEZmSkZpdFpOemllenVPQnA2QTExRk1WQzZFbjJSSW9ENUZx?=
 =?utf-8?B?OEtHMHlLSEMzKzlRbVJuVFNpR0lSb3dPQXpUZHJNalpwaC9mKzE3ZEFxQnFt?=
 =?utf-8?B?NTNuVG5UZ2V3dm1jQjBISWlPSWdsRTVpUGhWbG13M3BHNXc2a3RpZFV1ckVU?=
 =?utf-8?B?Q3djS01rb0ZIZW84VkxEOU5EL0JQcUVYbUVkMkZNRm4rTm5qTmRDREdzNDJz?=
 =?utf-8?B?Mk5CbHhteXNabjFHRzd4RUI2ZmtCMmZaUkpUNFdlN0NrVkVSd0M3MHdBbVEy?=
 =?utf-8?B?LzFNZ3Zha1dFT0lKa29NL0ZNdFZPMko0NlNmaXZncUY1VE9ZY1B5UWtFNXFJ?=
 =?utf-8?B?NUhqbW5mUEx5NWpKZU41aXdDZjlEOVp3TzRETHdqQ3M3cEdiOXF3dG9walZw?=
 =?utf-8?B?bDBKMTNqbTg2RGczVkZQUm92QnhkRnM0QTU3Lys1MllnN041OU1oRGRJWkVI?=
 =?utf-8?B?TzZXRjQ0YmdzYXFLUWY1cGsvcWFlN3JXbHI2UkJGTkRWQjVLdEZ5d1hWMURE?=
 =?utf-8?B?Nk5oWnU3N3Y1eHhQdkg1QzlWdU0vSXFHLytkTEcrMWdQQVgvS2RvZU85SUQx?=
 =?utf-8?B?OWhGbVl4a2hOWnEvNzY5d2g2dVhCOGdJU2g3TlEwcU1YbjVwMEM0ZmJlY0Ez?=
 =?utf-8?B?S0RVQVU0cVZhUld6RGRYY3EzQUxYRWlGVXo2V3ZSNmFCdlFIVmFPbnhKRk9s?=
 =?utf-8?Q?31i8TtsBQ4E517hlIIrQ/vjp1C1jjO/vSp6t7Ls9JLLu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3b6659-6c71-4ab6-a032-08db60f7a89d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 10:21:40.8295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2eD/IcGL6I7MuaeRV8Niclb5+e0+gPjS3a0yQcB39kfzhQkgRttFyXmarJk4iYGk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8401
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 25/05/2023 15:51, Edward Cree wrote:
> On 24/05/2023 10:36, Pieter Jansen van Vuuren wrote:
>> When fewer VIs are allocated than what is allowed we can readjust
>> the channels by calling efx_mcdi_alloc_vis() again.
>>
>> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
>> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
> though see below for one nit (fix in a follow-up?)
> 
>> ---
>>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
>>  1 file changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>> index d916877b5a9a..c201e001f3b8 100644
>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>> @@ -40,19 +40,26 @@ static int ef100_alloc_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>  	unsigned int tx_vis = efx->n_tx_channels + efx->n_extra_tx_channels;
>>  	unsigned int rx_vis = efx->n_rx_channels;
>>  	unsigned int min_vis, max_vis;
>> +	int rc;
>>  
>>  	EFX_WARN_ON_PARANOID(efx->tx_queues_per_channel != 1);
>>  
>>  	tx_vis += efx->n_xdp_channels * efx->xdp_tx_per_channel;
>>  
>>  	max_vis = max(rx_vis, tx_vis);
>> -	/* Currently don't handle resource starvation and only accept
>> -	 * our maximum needs and no less.
>> +	/* We require at least a single complete TX channel worth of queues. */
>> +	min_vis = efx->tx_queues_per_channel;
>> +
>> +	rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
>> +				NULL, allocated_vis);
> 
> I'd like a check here like
>     if (rc == -EAGAIN)
>             rc = -ESOMETHINGELSE;
>  just to avoid confusion if the MC or MCDI machinery returns EAGAIN
>  for whatever reason.
> Or perhaps better still, don't overload EAGAIN like this and instead
>  have this function return 1 in the "we succeeded but didn't get
>  max_vis" case (would need a comment above the function, documenting
>  this), since that's not a value that can happen in-band.
> 
> -ed

Thank you Ed. Yes, I will work with you on the follow-up and then avoid
overloading EAGAIN.

