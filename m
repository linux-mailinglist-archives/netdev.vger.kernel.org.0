Return-Path: <netdev+bounces-5040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE68670F810
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61D5228138F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36FF182D9;
	Wed, 24 May 2023 13:53:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0F760841
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:53:00 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D6B3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:52:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mG/M1Pm+KD/ZqF97PqJg2O6R6peW5kWvIq8akSGZlohs10FSIaJWD2hHQVBvAbKkH0KsBkvS25ZUuRE7BY+91pwvwBrLGnnpWRiJyvrOCfkvy43nag2EwECyW97muPTAxudXE9kOtkwD+yNT1xH67fpYpP/505VnQ2jF2N0UjYYlkXf4QhubiTfIiUOpmwqX5cXzQX151CM1mh5mrqIXgn/HMgumu/77IfhDVgAr/rEzJT9uPaJFn2UoDy06eYAQnj6ygGp9ulUZjqOUCnVyC+zGBAr4pfmQgEDEMTv5u35Phgb9zti1YhMOcP0H8ijGh9vZmrJosAHDkElcbLOjKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpWmbM97CRfCsraw3oV2+ed2ghAKUll4WGt4JZqXips=;
 b=QGyga//GfHDWFRA9kt++7DqJX2JJRDxa149NJDJCe2WqJvaslBWiVR98MbAB8YIxGCZ2miaeEhXdZsixDl6bkva0Mb1S4ZmfCG6LMkB4yCg1rHGAs/BGSCcv+RTgZZ2MHuBHRgUSdD3irujg57DVWNKtGQS5qUVp/DOTBVDC8wgzfEGMz47dedNtv17YaYyh8AKMYFJkQO3ssPhnP653fHxFMiKMFfWqN8vbN9aPMpEVqdIbAij28qHAQy1FqqSQOgqZKUYYMrerXN0QyXgKXT/dRRygRYMFypHMslHLfpbJF42/bxks9v5rUmbcJdrPUfaLMQcuKPs/NT2QOEzZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpWmbM97CRfCsraw3oV2+ed2ghAKUll4WGt4JZqXips=;
 b=h3PIyDkd+4doAJVnSvf4zeAlKscVv3Av8/nLmIbf/qqySEv/u+wKx9UPGUsDFduvoNmAAMWpjEd9Rg+NgGthI71P/EaFpeNQtnWmrcwkuga69agGW9o8mTFaD1d4Lw7d3lsNCfB7yv/wK9J6zdhQnXqosUgN9FI9uLlpgKe4UEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.15; Wed, 24 May 2023 13:52:56 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838%4]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 13:52:55 +0000
Message-ID: <d4ea49b5-5515-4097-c879-afb60cc5c673@amd.com>
Date: Wed, 24 May 2023 14:52:48 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting
 the channels
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
 <ZG3idM6bQmF0Bu69@corigine.com>
Content-Language: en-US
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <ZG3idM6bQmF0Bu69@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0143.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::19) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|BL1PR12MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: cd484577-11e6-4bc6-8e67-08db5c5e2d01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x9gbT3H6lnL8Py1OpwvGULQCf6yi7MokpQma1hsiKFPbAYZtl3L6/0Hhu+I36q8DGmXduBp5QgRy1Di/JfdBSPXYEVEpzkTwN1ztRd521884Ga6d77fkbNo/xG9sloWW1zY/LG8zgJOHPcxwcRSupf45bm3aUV4X4IynJ8of89gEVhep8+KVaNzxY5fak/Y2Q05ruz5luw5alwYHNvZl3557sP57XkOjFGAIdCNw+rU9Gqs/OB9p9gxsKnGZFNq8sFlZyEynBGm9NXBAEY8C+vSZtpERC+E2xQDOMCNUqKVkdvgrwWO7Ciz7CNkSsfbbA86Rezakpsw4ypx3bL6Lh/hGHT9MtUvnHtxSc+up47R0+xtlRDGSpZN68iTbvW3Xvt0yZY1T6SP0hjRDdyJI3fLZ+pHNQiByG5p0VO1oA7Ow/BC1EMHWnCfp5QaLvGExMAcUgYzXcJ9SmJUSjlA7wA3p/UYlwVKN5UT/DsvvlVtAVnlBjj7FUQZ37zXuVbu4Y4STYk5PVp590dpHzi2tpmUjpLSnihFSqrwOGSTU8H9elLFLJf7NgWPjcca/+a4m3XzD1BV0YHMLnlo6xaxuPU6Pd8YAZDsW4mo0pq27XYhG3Dx55Z0glCe2RUKc/4S+liqLCQFMmMalEWgc9E/jvQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(83380400001)(6916009)(4326008)(38100700002)(66476007)(2906002)(66946007)(41300700001)(8936002)(8676002)(5660300002)(31696002)(316002)(86362001)(36756003)(66556008)(2616005)(6666004)(26005)(6486002)(31686004)(186003)(6512007)(6506007)(53546011)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WiszazVzMk5SRnhpRDNvNmZlYUtDR3BzakdtRlBUTFJFelNEMld3RzJ3TFJj?=
 =?utf-8?B?YUk4cSt5bmJuVlBBdTRaQkJOWDJEVVhBbHJRVHdlUFQ4ZEhNK2NSNXIrK0dU?=
 =?utf-8?B?aEZDZjFoeWw5WFpPQnhYclg5dVpKRW9vdklUSzJ1NkNJSmNqaTkzLy9PRVhG?=
 =?utf-8?B?bXlrTzQ1Wjl1aHlNWWhaRlBaQjB4Wkp5eks5TS82RzFSNDJ5eHBWUEhvUDl2?=
 =?utf-8?B?QUdteG9vbEk5a3BDNDJ1SXhVTTZreE83MEQrZ1NXR3dRZTJpUjlXcGVIWm5w?=
 =?utf-8?B?MjV4ZWorOGpYZXV6S0JMUVBXbTFleTBoNUhZT1F1MngrQWsrbXZTVkhwN3pX?=
 =?utf-8?B?b0tQTWdkbmtxOHh5dlhCdWszUkxBditYM3BqWFdJVXNPYm1zdjhldXliemxj?=
 =?utf-8?B?WVlUWTRocjhKTUdyVlFZaGtSYWFqZVRoTUdIREJiRTFBczBZUC9VVnpGN0Z6?=
 =?utf-8?B?OGhrZHVDSUN5UFRQb1NMYXB2Rll6enQyZFExL3BnUXNsQ0pkYVdJcU1BbzVw?=
 =?utf-8?B?Mm1CM2dHaVVhMDdvYzNqZHZuaFFlQTBld3ZoNGFYMnZlQXMvQmZtY3QvelZt?=
 =?utf-8?B?c20yT0lWOW9RSkRsOGQ1NnJIN01kR1BpRFFCbzUvZVdyMDBaOGF5V3VjVFUx?=
 =?utf-8?B?aG9WL1pUYUdvMTdqdExXdUsvSlYrZFBJYkNOWkN4ZER1VDRtUUdCYk14MUpV?=
 =?utf-8?B?eUxoT0hMb2tzRk00STN1Rkx3ZkZPaUdrZFY4aUJCeCt1M1h4c0dTWUdSdnk3?=
 =?utf-8?B?MElsbzNpQVUvVVdtZ1ViVllnQUhzTmp1WkZ5S2ZXUTN5NEhSQ2NHSHZUUWpP?=
 =?utf-8?B?UnNNcVdVRmlOSitRbCtYc0xNbWJmMUI5aXRPaDd4RGhRWFQ1UVljK0V6UmpF?=
 =?utf-8?B?SWNWaEdBN3pYazBoZ2JYeVJEdnl2bkdHNlBsSEN4MWN5Ymlad1RnTDJlaEpz?=
 =?utf-8?B?cWRWQmhQcFV5alNFVUpMbzRiZEthZHBtUHYrWGljZnVvQzR6QkdsWUp6bHFv?=
 =?utf-8?B?L2tQR2l0eC8xbDEzTjJoZ1dTRWRDK0MzQ3pzR0c0VUZwUzRjeThpMXN6WnFH?=
 =?utf-8?B?aytzKy80MTV3NUJNeGJTNU9iZzhrWGY5NEdUN2h5M2RtbUs3WjlLc2YwSENk?=
 =?utf-8?B?cDRjcStiOEhxVHVyNkVMdVM1SENhQWw0M0grekpQV1l3UTkrTDJvN25ZWExZ?=
 =?utf-8?B?NGt6UkNrd3BhdVhFM08vQlB0VkFMSy82eVhaQzBhYnJxYzFXOXJHQ3U1RGM1?=
 =?utf-8?B?OENrMWZ6WmJIQjRaYjNVbEJkeXFOeVQ5akNLNW5OdVl3UmFES1N6bERzVStJ?=
 =?utf-8?B?RGRrbjhLc0VYWjFOVldFdVpNeTdhaHRid1lGYjg3V1kxZXNqMGJEU1lrSDhO?=
 =?utf-8?B?OW1HSEowNG9nMGVSRWNYc3VzMGhRa09hNmZRMElJRVZJL3M0cHNCTllIdjdY?=
 =?utf-8?B?MXIvM2FQOVkwY2JZbGtGYWhTaE1KSGpGRUl6Tzh6SHN5MCthQnI0K0Z1VVQv?=
 =?utf-8?B?a3pTU3lWWXZmcmg1ODVEQWhHTmcrZUIrRHQ1SmVmRndTdDZjYllyZ3I1K0pM?=
 =?utf-8?B?enpTRzUzV0FKK2s4ejR4bk4rMTJZR3VHTVVVMWk1UUlvZEZLTk93WDdLYzUv?=
 =?utf-8?B?SWFGb25PMUNoUWkrQWN1Q2lhV3NHMTE4ZFdWUXdhWkhGTTVzcnVabElCdG1v?=
 =?utf-8?B?TUNTc0lza2NkOUJZQTN4T1JRd29ZS2lsT05OS25NWW00WWtKZmpSN0Nwbkxo?=
 =?utf-8?B?QmFDUll0Rjl4VXdJWmRxckljU3BJS0pmY2dSL3BBZTdJQnh6TlR0bE44N2VK?=
 =?utf-8?B?OVVXZVNtdlZ3bFFRRFFoQ011ZzJHZ0RrbUZobjVIajBlTkIyell5Wm5yRzdi?=
 =?utf-8?B?WDVZbXlqaDF0aVE5MnhSUjQ1WWVQUkwrRDRXZDQwbHRqYk4vL053RnlwNWtt?=
 =?utf-8?B?UDdtUy9DVlZydzlselRCVm85aGdUcU5ENkpIRmJabncxVUo1ZWQybzE3UHdx?=
 =?utf-8?B?cHZjM2s2NlVvSkg5TS9pMUtWQk5NUVBXQ3FNMGk0YmpxM2VYOXlHOW9EemZt?=
 =?utf-8?B?WmIxelhHaUJ6UXhaeDVUOUtRTVA3Zkc5Wm5od0pTc2NUYklEUm1FYUdQZzA1?=
 =?utf-8?Q?GUsuk3hL6p7/smh8nBiPwl2ZE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd484577-11e6-4bc6-8e67-08db5c5e2d01
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 13:52:55.9064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLLZGJxhMPNPS7SBrK/kCIsPp2DNjCKBxVa/Mb4RoxYyYo/jKSkvVRYz7PUDxGWn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 24/05/2023 11:09, Simon Horman wrote:
> On Wed, May 24, 2023 at 10:36:38AM +0100, Pieter Jansen van Vuuren wrote:
>> When fewer VIs are allocated than what is allowed we can readjust
>> the channels by calling efx_mcdi_alloc_vis() again.
>>
>> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
>> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> Hi Pieter,
> 
> this patch looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> But during the review I noticed that Smatch flags some
> problems in ef100_netdev.c that you may wish to address.
> Please see below.
> 
>> ---
>>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
>>  1 file changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>> index d916877b5a9a..c201e001f3b8 100644
>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> 
...
>> +		/* It should be very unlikely that we failed here again, but in
>> +		 * such a case we return ENOSPC.
>> +		 */
>> +		if (rc == -EAGAIN) {
>> +			rc = -ENOSPC;
>> +			goto fail;
>> +		}
>> +	}
>> +
>>  	rc = efx_probe_channels(efx);
>>  	if (rc)
>>  		return rc;
> 
> Not strictly related to this patch, but Smatch says that on error this should
> probably free some resources. So perhaps:
> 
> 		goto fail;
> 
> Also not strictly related this patch, but Smatch also noticed that
> in ef100_probe_netdev net_dev does not seem to be freed on the error path.

Thank you for the review Simon. Yes, I think this requires some attention, I think
this is one of a few that we need to look at. So it will likely become a separate
patch set addressing Smatch issues.

