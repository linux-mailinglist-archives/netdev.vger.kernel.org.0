Return-Path: <netdev+bounces-5372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB3B710F41
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F603280F53
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A96817FF2;
	Thu, 25 May 2023 15:14:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02837171D6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:14:11 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9170F197
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:14:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIRYdUB2PIXadd36kmyNwrJAomVVEXXXRU03p7CgrANVxZ/aDawy/9IAtVHVd6O0yiFJrVOl61qZf4SRA2dXs+a5dnn2EyV9td3F2iwd+jm9huXNoDd5FT/Y9LpTpLllcUZDpRbLEBmubuy8cgRDv9jHmYwaSDGos1w51eeTpbGlZP9hmye3NAv+0pVUjR3rHKdwZ6D/gteyAchTtaYIlmnmJwxp/b23q+3oadf3m5l3JdoCkQBV7YFZzKzqfQNzL9bKTw8V5Ij7gestU7qbNoj5BHu2hZr7j/S+VutOXrAhdGnATxwY4u0RV2mTCQVWXRRV21nLNl4TthHoz26xWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ek1xhIYGwZqHno9XmhPKbMjFalMpZtHdgYGzvAWiyPU=;
 b=Y96iKKg++km11Lqa0IlAeSgyjJSQzYiNi4nGIeGkuG0IiUYxlu3KV14xZLEz2Nit0werEIAMN/rGnFpiRAebapKNd7jq2hiR7I5oedrV22iKvorEWCXV6dh6nD8BTDsuviuaOx95gw/H/eDiXC88AXchajNsBS216yij+ttHiTUGxQxan4xriVfQXOnlDQFCVmraA36m1dMHl5goUvKvmkCoIyYBWUThYJIuEMrBsqwgst5dWT/AdHRGAJBCwRolb2EiSIMQHVEx+1XksI81CWcWUrotgX7sTLt64MMmzZNW6n6XmFLZNG6sSjBho9pmFJKf3q9bjgimxAESSoLRWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ek1xhIYGwZqHno9XmhPKbMjFalMpZtHdgYGzvAWiyPU=;
 b=jjvGQhppAQ4h2l9cUGKHanxOExenZKxXC7X6cMNPAiVXhZjiI79/6GAsqSmth6wsGJRKAlY45Ibt9S+d8ydupPKXLZE6ktCOmQpD1a0xSMfGXlcfk64kDJWeuNrX0rjwfAHAvSf2W3G1JWsoKDbcKqmUUGtwgT2A4WAK+uApIRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by IA0PR12MB8715.namprd12.prod.outlook.com (2603:10b6:208:487::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 15:14:05 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::e90e:337f:e012:aeb2]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::e90e:337f:e012:aeb2%7]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 15:14:04 +0000
Message-ID: <90e4c411-4159-2836-acbd-c1e7a9c7ce37@amd.com>
Date: Thu, 25 May 2023 16:13:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [patch net-next 08/15] sfc: register devlink port with ops
Content-Language: en-US
From: Alejandro Lucero Palau <alucerop@amd.com>
To: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc: kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-9-jiri@resnulli.us>
 <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
In-Reply-To: <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0278.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::13) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|IA0PR12MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: e3eaa514-01f8-4596-4d11-08db5d32ad7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZszhE+og7HcfxfHs7PmrQLznDt69CE/kMFkOm6HdcvHaU1nEnxgHCpFnmHfd1cnIumQB4h3zilozbL7kTVT2Xve19uXqK7IPW7tcDZKhyEHDhd7aePGU7gpLsatQepQ/h8f3EyEKi6REJT7/2A4KYW2nuQMNU8VqheU7JD58itEqpEGddk1r6QJsR/7CK0H1MaNt7fIjHBIZwo8bAbGU0X18oxqr0ZzXI9bgHAf5Ep0PyeZ9lCXSwduBeE+GFaRSg1GqGJVgX0oT9LDYtxReN0v8t0uhu/YMScFAbKERYCDXnuYtQ1tkBiX8BWLi/yXjDa/nLWw1g4PAaeOVmce3RhV3ZnmvTBORZ/G1ZEHzORmqR2Hvj7jiS+gW/kFGGCr4V4lNBbA8CuPOQI4Zjm2H44EIKPeh0ily33d6jLcj2CMF6DnkHXtwPuRKtuzRf/RwkRWD5GRCKQUUrU/oW0DVEsG16n5pice4Z0wxawH9vRH5myKgkX6RN9/FVCbcQwng2j5CmQu2RxOHi6SGzVn15OLo27Z4KqtPCoyY/lxrYk33CWyBnrI0miX0QHOuxJtI/nStgFEDqSJJ3iIP/byhX8S6CdRJyVcXpUbIsM1GpKZJP6hA87y+cfhqy0/S1B4H+QiSKHQsc3aHsr96AgEtVg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(31686004)(66476007)(66946007)(66556008)(478600001)(4326008)(316002)(31696002)(36756003)(83380400001)(2616005)(6506007)(26005)(6512007)(53546011)(186003)(5660300002)(41300700001)(8936002)(8676002)(7416002)(2906002)(6486002)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dC9NSFBnR2RvUkcwNzhXMDVBMjh2NmlnWmtVZklGYWdqVy85WDRnTEg2d01n?=
 =?utf-8?B?akM2MEs0TnlmbXZ4djlJcDBrUHVHYnU1VDdPdS9veTBzRm90NHZ1bTBEcWp5?=
 =?utf-8?B?eXl1MmN4cU9wUENIMGdRK2V4T2tyQ3JHaU1qL2YrOG8wenpZV09kbmlEd1V5?=
 =?utf-8?B?dWRYMnp0bWREL29jL3FHK2hnK1JRVHhXTmliMGJpb0JhUFBPVGRHZGJjYkdB?=
 =?utf-8?B?a2NsdEpDQjZWYUxaOEdjVzdjcUZ6V0s5cTVTMFBiYWYyem4wYVhjc1VBdFNF?=
 =?utf-8?B?NXZhMTRPdTVCK09RV0JJWlVQVERyY1pQcGxHYk9XVlo5M1QzVlNBU1diMDdh?=
 =?utf-8?B?VTBlMHAvVjJJM0k3KzdPMnRGckErZTZxbXlsV05peWFqdm9yWlA1RWZMbk8z?=
 =?utf-8?B?RVlXdUs4dXRCb1pkelp2UnovMUdienhIRURwSUZ6d1ozRjlQUHBBYU5TY3Fp?=
 =?utf-8?B?cU5rQXBrQnZDTWFhZDVnSDdBSWxvWUYwanQvVElHbXJKcEFzNnplUDNQNFdX?=
 =?utf-8?B?M0tZVG1lbnYzcDdJMUptd2FpR0prOGxNaGYxeTR1MTB1b1ZiaExZNEhRQk4w?=
 =?utf-8?B?M0Q0WjdubzFMYXdsSlBHMUdHNWN3T1p2VTNnWjE1Wm5ObitXbVNrbjlQYndU?=
 =?utf-8?B?cWl3VzcxRHlGa0JDNXVuTmU5dDF2blRUNW5Pc2R4SVpjTGhFR0dVWk4xd0VC?=
 =?utf-8?B?SmhZTndlaTBVMkhndHZ1UlZQVk5UaG9DVEhiZGN6TmZLaHd4Uy80bDhJMnFY?=
 =?utf-8?B?RE1raU93bno1eitRUEllSjA2NWFiMGl4T2NnZ0lWM1FWcTlkMFFXVWNYb1ZP?=
 =?utf-8?B?dk03RTVhb0J0Q2ZFR0ZJTDhsUmVYNERRcDV0WW5rMzRWS2lZYnRRQkhrNUVB?=
 =?utf-8?B?LzhZM0I5bFdBOC9kT25CenR1ditwNHlhWEhhbytrYVVEeW84WnBwNFpXaGdR?=
 =?utf-8?B?Z3VOZlZCV0VFbVBZTUFzNHdiQ2wrVFRleXU2NGl1QlBMSFpaaE5CdGswUTE4?=
 =?utf-8?B?YmFnMlZ6RENKcVBZazlsTWVqYkkxalF0cVpZdmwvL3BXK1hyQjZySlNoa2dD?=
 =?utf-8?B?U3kxYkFzS0g2aUlGNEp4SU5TMklTNldlYmpONzI3YUZhVTlxTDZIZ21CZW1o?=
 =?utf-8?B?YnpSWWRBdVhtMnRGRCt5R1hzc01OT1ZDNkw3a3JjZlZOK0VUWWxGdy96aGVz?=
 =?utf-8?B?QTNVcUdyYWNyUWxFbEdiRXJiVXJ6TldZc2kxQkxyTnJuSUE4OS93YlE0MVJw?=
 =?utf-8?B?Q2lzVXJ3ekdPTkxncVpDSWp1eHhRMHhOTXNycGJlRVVwTGs1VHpKNXhUdzRo?=
 =?utf-8?B?UFBFMS9JdXNGcmkvb0x3MHk0ZVhVUEduMy9WZldoNFdWazhaenlxSUFxS2sw?=
 =?utf-8?B?RUQ3a0huL3dyR2JlR3FQNDZDNFBkRmJMWlFmNWZxMGVUenlvTlhkbHg5SVFN?=
 =?utf-8?B?U01ybXNkTUJwQVRBVTJMeWMxSEl3Z1FxcTNueGRwVWV6U0srY2VwbkpkMG44?=
 =?utf-8?B?a1U1S0dLSEFac2pQcFNTT09QbXpvUUg4ZitkSytLdGtXZGNyd1kzbzZkODFJ?=
 =?utf-8?B?UndTUWZUUzZvWU5IcEZDWmJuY25FYkFqekhMN2doTFBjYTI3c1R2U2FFcHAx?=
 =?utf-8?B?Vjdrc0JaVlVFOSswOE9xbUhMMzE1bFJWbzIvbmk0Y1FwaytJVDZHMGRwY3ps?=
 =?utf-8?B?Y0dONzBGKzgvRW9XSXY1Y05QbkNxSlBMZnIyMGVRbWtTcGFpRkZodjJTQ1hF?=
 =?utf-8?B?dzhLRUVYZ3JSSXliOEtLczV1TDJ4Wkd6N05DR0RCRDRSYm5VZW9FOFhZK1Rt?=
 =?utf-8?B?QytwZFFVTWs4ajAvNDEzM3lYRHBxMTVwTWhxVW9aZW9LNHY2bEx0a1JyVmpr?=
 =?utf-8?B?d3pUTE44bUEvZzd2VzF6MWxwdjYyWVpIVUlQNHBEQXFmTmx2c2lpWTM1RUFJ?=
 =?utf-8?B?WHlmV1JDcVo4SUQrQXlib3FQR29rZmFodVNPdFBoZllzM0U0QUZlbnNpQWhp?=
 =?utf-8?B?UkJJTUZkSUFsVCszT2p6MlVOR2RhZ2hpbi9DZE9ZcGF6NVVOUjhJMUV4azJK?=
 =?utf-8?B?ejNpVW1laklxcXZkcW1LN1dKWTNDSFJpOFZWTUlabnBKSytLenE2MEZaaU9H?=
 =?utf-8?Q?Wb3ntkXg3KaVKm2w2InVDYijA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3eaa514-01f8-4596-4d11-08db5d32ad7b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:14:04.6177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nH0fJTokxCUwPbJyQv0VZ7g0GGtEp0QENz9IFpAqLGXDzn8eaI8r1wUZKG6o55aIEbTkhvmFmd/ZHz8/8GjA5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8715
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/24/23 18:57, Alejandro Lucero Palau wrote:
> Hi Jiri,
>
> On 5/24/23 13:18, Jiri Pirko wrote:
>>
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> Use newly introduce devlink port registration function variant and
>> register devlink port passing ops.
>>
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>   drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c 
>> b/drivers/net/ethernet/sfc/efx_devlink.c
>> index 381b805659d3..f93437757ba3 100644
>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>> @@ -25,6 +25,10 @@ struct efx_devlink {
>>   };
>>
>>   #ifdef CONFIG_SFC_SRIOV
>> +
>> +static const struct devlink_port_ops sfc_devlink_port_ops = {
>> +};
>> +
>
> We can have devlink port without SRIOV, so we need this outside the 
> previous ifdef.
>
> Apart from that, it looks OK. I'll test it and report back.
>
Apart from the change requested:

Reviewed-by: Alejandro Lucero<alucerop@amd.com>
Tested-by: Alejandro Lucero<alucerop@amd.com>

>>   static void efx_devlink_del_port(struct devlink_port *dl_port)
>>   {
>>          if (!dl_port)
>> @@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>>
>>          mport->dl_port.index = mport->mport_id;
>>
>> -       return devl_port_register(efx->devlink, &mport->dl_port, 
>> mport->mport_id);
>> +       return devl_port_register_with_ops(efx->devlink, 
>> &mport->dl_port,
>> +                                          mport->mport_id,
>> + &sfc_devlink_port_ops);
>>   }
>>
>>   static int efx_devlink_port_addr_get(struct devlink_port *port, u8 
>> *hw_addr,
>> -- 
>> 2.39.2
>>
>>
>

