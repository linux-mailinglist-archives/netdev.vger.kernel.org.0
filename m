Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B715462121E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiKHNQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiKHNQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:16:27 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9547727FC6;
        Tue,  8 Nov 2022 05:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHgXSBaVy5h37I8WDW93WTn7uDLlfKNg6lqAaeeqe5OOGaz7D8LixRf6/xjryPlbIEKj5JIoWPHJjkY5WMpx6ZTJvQJaTYVhp64NGnywz7tCu0WPYca2lPMYh9QlxYnlfYFJes5Dah0+Nq+ygaAyPboG+Y34r58QScFhtymqVB7ZKV43Mqq5rh1ETmTxTx9Bk24cJxntBw09AZqScrszQjeYGbyL3JgoFOt3Q7N7dxa4VPfEKJ2y7+DQkmNU3P6800QJwJu7JLIrICD/3f3celOedwoTYN8vRBiQDzaonuOQORjzMPtQczs5AOKASDSoNMzp924PJxRCxMwKYTX0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKda1SWUAayVyDBFmF/OAbDhGg+jA97yQIpvKdzDhps=;
 b=ip3edr+1yiPM4UnlbxKwEwWElKNNIWenLVlzk04+igiog29UrQVjrLUu92TAL4NiN++mBrLpBBAj/csHSjipy0XUOi4+g2wUl+eHoPbrBLFcrVIiPkwR3nsUXtVtPtWjvw+oFA0KO1Yqb7kMp+nSc54gQW5hrXwsWgVeaPQi8EfTYcjfDqCtxzNOOj1fGYpIlmUBQHx41h5JEmFjeUyGH2wE4BWeZhTpWIDgLFmc9Pwq9tPpV/plgY+gjo4gjqQv5cVuU2RnVbK9Kq1Y3kSo8rXjMO/+ebDuALJAYWKt6DUlwWmWV08VMvIynp35yuGC3g8VJkc4hfgzr97Uy9SUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKda1SWUAayVyDBFmF/OAbDhGg+jA97yQIpvKdzDhps=;
 b=Q6Syl5R+HwARVOiI2Thy5WG/nJDVcfVp6YuwFAJuVvc8Cq99FD0AOG9wUP+lPUida33YMblzcknOCI6KRqUjTVM1prPj0g0OmGYwH/8FKiVTmxUQm0hvqI5XptvqEBJbg2d9kgFkhMLrCbH9yZcWwT8iHTzcvPvnsqRVtQjEbV41MAEzaNZ7St9flQ0LD03a/8xQK1hTbsgT8GlQm2oFWSaj2KoW5GF/R5cHKdrcLkHgZiaqCdyowutfa1mcSdmamM6kli/tem7cmH9S01669nqY0YnbNd3cc/BzANoX+q+P3wt99ekJUl87vox2EeLq6H+q0uHc+Y96xkFZHxagwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1366.namprd12.prod.outlook.com (2603:10b6:903:40::13)
 by IA1PR12MB6412.namprd12.prod.outlook.com (2603:10b6:208:3af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 13:16:24 +0000
Received: from CY4PR12MB1366.namprd12.prod.outlook.com
 ([fe80::21b0:f057:a4f9:e1c9]) by CY4PR12MB1366.namprd12.prod.outlook.com
 ([fe80::21b0:f057:a4f9:e1c9%11]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 13:16:24 +0000
Message-ID: <937e019a-f911-8fcb-6f0f-d23188ced89c@nvidia.com>
Date:   Tue, 8 Nov 2022 21:16:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkayal@nvidia.com, tariqt@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221108130411.6932-1-yuehaibing@huawei.com>
From:   Mark Zhang <markzhang@nvidia.com>
In-Reply-To: <20221108130411.6932-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0108.apcprd02.prod.outlook.com
 (2603:1096:4:92::24) To CY4PR12MB1366.namprd12.prod.outlook.com
 (2603:10b6:903:40::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:EE_|IA1PR12MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: 70499f10-97ff-4d4b-80b3-08dac18b6f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZtfO4e+gbgU5Muce1MLxS8S61GD+jgFeJY3F45QZUbXumNV5GoUtZFfFlUM6m48P6xv53Un8y+i8GI1OhVRyOjw0cds1jifhGtgAN4Q8LPuHHJKODVndaqh/ALCguawDkzDNqj4iHRkA5opy0pZSqySp1pu7jkw++LQ4tttbyLq0XFhoce9sRkhXvaIh9vnECPn5VFdU6uu5FWQarlUCxOVwTiYhfUl3OCEJ+Y8aYMPDjPON2r8+AMASXosnIF6bvUnoZpNJWmS1fd4v8Ybpce6i8n79GQtJ2WRLrcQMGWJR/DCfeD7XMQeX8X3DqbOf1G6UGUeE8gFWjSMIp9c8rCYlMXU25QSJay2cTADT/MZJlira9goUrj+SezayugKRDISCuTLFtH/UtzGGOnPSU5tRuXO02iMUYjW6mE2kdbDvVVycXwE1/6+8PtW2f8nHSipa3vIGMjOpJtsV6KFpcwjxCJtahXDKdU5e0xiR3vFFemC4Hza4Wph7EgwzeKrOFUpvN2hKJncS2yCNow0x5YgCQFG5s7oki0YV8NWPnMBkbOmuwreVNk9FYe7lny+flyfyBPRfzjebSlUQbGHODyByKwZ7d8gEtg0LWskopB88aZXW5d044pTrd/6WhLyAgj7EuFQtsvyZ5pbBwe/4eYIdns3aeak+4qf2xU10kRR01tieMCogwjoHrctkcDtIh48TJ1lTDdXxHvOGMe9j3C27mhVon5ZNPDDLwxCHX7DFKlTq0zO81ppBEdlnWkCBZMycq7L8G8caFdex6E2PokfD9aHV/RZqc9RJmc7fFoPMmAhWEH+QZIMMz5n4Smz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1366.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199015)(921005)(31696002)(53546011)(66946007)(66556008)(66476007)(36756003)(38100700002)(86362001)(6506007)(4326008)(2906002)(8676002)(83380400001)(31686004)(6636002)(478600001)(5660300002)(2616005)(6666004)(6512007)(316002)(41300700001)(8936002)(186003)(26005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXRDbExsS0dmd3VCaGl0d0hZQS95NTRZT20zbVdzQk05YllJWVNMN1ZHMnE4?=
 =?utf-8?B?MFUxUkxPeWxsVStrb3ZSWmlyV0N4MEQ4ekltZWV1Vzg3MWtXS0tYS1FOVUdi?=
 =?utf-8?B?MU9JL3ZTZGhrczhKeDIxR0t6dmR1NXQ4cVlxdk44OTRmaEk1Q2kwSENJVUYx?=
 =?utf-8?B?L09tZnUzV2VSNFlzdzNiL2RMMTJNL094TW1UU3VmNjZhdzBMSUxNZkZDY1Nl?=
 =?utf-8?B?Y0xxaEU3Tnl2WXZPYWFpcWxJdjVxSytTNFMzRXF2ZGZCYVN0M0pRUEpmVVU5?=
 =?utf-8?B?azhYODk0eENSa21IbHgvQ1dVcjh2U1VEVi9XS2E1aWg4YUQ3YmxpOWlUK21I?=
 =?utf-8?B?b1FhWWd5elVNSWU2Ry9hbjQ5eHlVTy9DcnhmZ0xRaDZFRXpkSXF4cGdSWHB3?=
 =?utf-8?B?SmdhdUl4MFMvbWxMejg0OUp5Rlc0eVFzc0RZQWNpc0IwRnkvcFJ6bWl5QTFx?=
 =?utf-8?B?Yyt5MnBpNXdrblBHbXhqYWR5Sk1IMXo1NS92ZWo4NDFYOGZodERDWUtUNWV1?=
 =?utf-8?B?bW0ycEFZTzFPREJDMEpWMHBrQnQrZWZsN29kWkh4T0ZnYXNxSms1N0NOSFJt?=
 =?utf-8?B?WEZmRVBVRDgzNGkrVklRMXBaQWhZZ2JkWDJzbSs5WXYwd3Jxd3JhV3kwbW0x?=
 =?utf-8?B?d0h3dW5nUmpQUk1PK3pPeUFQL3J1YTUzNFQ2SmNSYVZjeCtycVF2SFFjNXJn?=
 =?utf-8?B?Nk02TWVZVXRkcWxodU9OeHI1QWZFbmg1SDBTZ1pJOTR3Q1VsbzcyeTI0NDdT?=
 =?utf-8?B?dHdiUHpGdmZhSVdYSlpuWSs1WVF0T2V5NW91cmhrTGw1WVdZZ1lrT1ZqSGsr?=
 =?utf-8?B?NHg4akErV1d2bThNZ00vSFBaL21tWG1qeXVEaTZDZmlFYWFxM044QlhBRk92?=
 =?utf-8?B?VU41RHhEV0NVU2pCU2FHeUNLYk9qd2E0OWVhNldwbEZXQXlOYmgvQzgxeWpK?=
 =?utf-8?B?dFZvUldFV2dVSDFVK3d2OUhIMStWRW1EUnRqT2JJZnU4a1pIRXA2SEJKTytP?=
 =?utf-8?B?MVVtaCtHK054SXVIQlFyWEtjKzBCZ3BrL1JhMW9oZzB4NndyYUpiK2c0T0do?=
 =?utf-8?B?a2tzZS90bVpQT200SnVUU3NPMXBrY0Q1aHFObkwxMmN0dDZYazZleGdpcmEz?=
 =?utf-8?B?K29KTGsyYTNibHI0UWFQT1VYZVpzY1Q5NnRyNXdUZ0Z6ZnZnRWxsMmU2NllW?=
 =?utf-8?B?WmFhM3R4NUFIamlKRWlQYUR1RUJXUmQ0MCtwMXA5UDdhZTZSWXgwbXZvT1lw?=
 =?utf-8?B?bC9Id3F4SEc1bU9HODRtTjBnSE1XRkp5eXdoVWs0eXRKZ2NmYVNaRHhuK21L?=
 =?utf-8?B?QytZL2JiYy84TGFGTkh0TjE5bWJkU3Y4WEpsdkZ6cjR2N1lpM3VVY3FwK05j?=
 =?utf-8?B?VFRScmNjMjRtQm9VdjZtT00yUzlGZ0o5OUdnKy93bEp2Wk9ENmphK3FCZVhD?=
 =?utf-8?B?VXBicWd6Z2RtQUsxSHAvZ1VNS2cxSG14M0pwUDVqZlpWcXhhMjZ1cWE3RkMv?=
 =?utf-8?B?WHduanZxWmJzamI1eEduWTdneDR2a3M1WVlybFVDNTRCemNJdVl5NTZYK3JJ?=
 =?utf-8?B?U09MaFBVUUZUM2FpTXpDVGx2enBKME9hc3NSY0FzTmVpRHlsV0tpUWFsbTFh?=
 =?utf-8?B?UXBaVGxPQTRiWk1mZlluWXErYi9uc0N6YTlzUmwrMGl6VCt1OXlIQWlhSGwr?=
 =?utf-8?B?YllsKzFObTArMGtobjZWYmVDd1dmNTJKSzE2TGtJbmJENkRFUUd2TnhKY3Q1?=
 =?utf-8?B?NVJFZjRWbHVFN3cxYmJrd2dveVdLbzlDU3VNNGw0MXdCc0tML096Z04wVGN3?=
 =?utf-8?B?eThORC9YV2g3QmtDNFBZNGpXc2hBUUZwYzNqUDBhZFJnNkhIdlROOThJOHhH?=
 =?utf-8?B?c2lRSGJGY0FmVVFXNVp1RjFtZ3grN3NvS0ZzeDJtTXRML0ZrNTNPcURJZjNo?=
 =?utf-8?B?cWQvNWdVbXhmYUgxc1pFdld2MWpPVnNKdHR3K1hOVzBGOFhpcWU5L0tqSDFu?=
 =?utf-8?B?MHllVkF6d00rbzErL1dpWHNEOVl2K1M4S3pSS3pHOGpzTStPZEx3RjYzaWNQ?=
 =?utf-8?B?TUF3TzNuc0xJQU9WMTh5bkIzemUzZ1hPeW9ma09KRSs1YzdYMTJFdnlmSlAx?=
 =?utf-8?Q?8l/4zmB1tFfVQVbTIzikGTi39?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70499f10-97ff-4d4b-80b3-08dac18b6f72
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1366.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 13:16:24.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4ZN8ZESOmK15s2cu5mxczXTC7TRzbL8OusO30fm4a7qiEU/vkmUMLCBlx2a5BUfgQU7k2ENrkqcegDFWH4HWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6412
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/2022 9:04 PM, YueHaibing wrote:
> 'accel_tcp' is allocated by kzalloc(), which should freed by kvfree().

'accel_tcp' is allocated by kvzalloc()

> 
> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> index 285d32d2fd08..7843c60d5b99 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>   err_destroy_tables:
>   	while (--i >= 0)
>   		accel_fs_tcp_destroy_table(fs, i);
> -	kfree(accel_tcp);
> +	kvfree(accel_tcp);
>   	mlx5e_fs_set_accel_tcp(fs, NULL);
>   	return err;
>   }

Need to fix mlx5e_accel_fs_tcp_destroy() as well?

