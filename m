Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE16DDA01
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDKLro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjDKLrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:47:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F224696;
        Tue, 11 Apr 2023 04:47:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vor0B2ndxjKDlG1ghlBB7vY0wz7QX6R7x4ciJuJEfe2GWCmWhASc7tfOSJrdJWai22sLlvZ8XeROwCJ3v9OkdL37aONjPf8YlG00zLoV7C1yT5DrgVRGhGmEQjzgn/ZdA7iV/nPci1m8OZwVuL2Dq6BQy1q1rxZZA8FMfBMy2v0QNXgouiIgxgAjKVyLLNnhIotEyt5lwQeJUwHF1QU7E2zRnCm8Dbf/eST/oxubZ7AZbQIkvmmVUZouHkItgficBw+9M7ZL5w5UTVOFIbXvAsbrJ1Uu+aYQWlcxdG4BUszhJxOBN9H1myGLXnMMZNHRlmc/WgaLusfYiIiejG0bgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6/AUIa9MK4B1TMU6pKGpFZCpGN6hsEriC3OLRdAhCU=;
 b=FNw3ztdeUa2iCSRhEZNEeX6VNo0vbc+K1LjCH/TWfY3F0aclmrh3HYrH7587tmw/8g/hlsVzTxFqvc0P0rqgRWSEWZh5KDZHVLrtyYKkY8rPscIV8N6VLoB7837ME4NtENU3HVgAiF1gFZXpk2GCtol3fSg3XVU7YPLhOBYxXSZbXVIUA1wrT0LlIQyTt+3iFgjoOs6eWBCc3f8fkPjma23XKtYugsJiYvz6LiTIElooxcbH/Cz+iL0n634ZoaGBaZgi0P+PEtyRFOrdpc19/+QNt/Pchc/IM1DCqL7kn/sQawzaN+1qSmQ9xxoWBfDsPLRm48wccpQvgibCyfA1Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6/AUIa9MK4B1TMU6pKGpFZCpGN6hsEriC3OLRdAhCU=;
 b=r56J08vYxLtazrKv4CjXFhlqsPVar8UVpeHAqk/ilN3XwdFebClUgahTZFg1boXafI5K3NhfToMmzQJ1QqPVxr2DvBH+tAzl49lDwwzEd/DWzhbri4xj9G5zF0xFHmHPGHTVfGP3azxF6pw6LdmAJU4HbNFe1x18ylufKL9var1GPw7Sh6b5u3rT1toLB6RMuvLtHKKhGMzSvhstSbcPbxNbo8w+6ZOasPd7Mm9OYerpfrDvO8tD1PjnVeYwgOfFIjd7+zMGphQS1JzD7MgzNfhom5NuEW8ataK6g0oK4XFwkbJ0Xce+laPOrsGeQD5zd4bxr1BmKaNa+zoi4CcxiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 11:46:30 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::a6d5:a6a0:7485:1cfe]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::a6d5:a6a0:7485:1cfe%3]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 11:46:30 +0000
Message-ID: <7d7fa126-5c09-05d5-c7fb-fcb0875d61fe@nvidia.com>
Date:   Tue, 11 Apr 2023 14:46:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Fix flow counter query via DEVX
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
References: <e164033f175225a5eb966f769694abdee0200fe2.1681132336.git.leon@kernel.org>
Content-Language: en-US
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <e164033f175225a5eb966f769694abdee0200fe2.1681132336.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0502CA0003.eurprd05.prod.outlook.com
 (2603:10a6:803:1::16) To BN9PR12MB5258.namprd12.prod.outlook.com
 (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d195e38-dff2-45a6-f178-08db3a8263ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzRr3z/2eCiHtLlgnendKVOLNvooqxljrbXaM3V5C8wfi51kq80uLw9L2I0MMDnWPRnbEMAzsZBFgscnVYrv3J5m2RjwUayq4v/QhvDeTInta2IGNpF+y7vrmTSIC3LDsE6kefbadVmuwNo9Znun1kXtKiw6GeXxDNxbBHvzF5wfexJBH6rDMeRGohSuQ476vfqiDYslGYwFMaW+cLEFYFAAY5yPrbitSZGEpa3JJzuORhUqeW/SeO0vXuvUQukH9T4l/yRNF6+mHbRlep1Zt8L2UjSgkAdIVmFqiIIfn/1SNgdiHtteB+smGJupAHqrdIcB/ib4cvVSZ9nWhRw2iuutvvLd2Flg99+7SiwpLmStrNl0eL2O7Lx8jx0aFckVVxCaJX4ftedWZC5TQqimGdk9lkacU+tuTOpTzlb+65+NuIYdqk65BL27tNrNNCCdhkfIy5XSwRNEN9h4SpxlxtJ0xSKDFGmyt6Gvyg6/O/Sekm3lkpJyprgZYJdk5RWHtd6AB4oac0789xqeIptp2tnTCT0cBxGSvUd5bHBCGTEkBEj2lqYB5ucQVnCZOS8KYEPVJXdYNCO7kJomKE1z7OUTbN9T5liYyOD0fqSPOYGjkamjv8uO5TOu1Bg1l7hwAe6hlHUrB2V9Aa0Ic9eO4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199021)(31686004)(478600001)(86362001)(31696002)(36756003)(83380400001)(38100700002)(2616005)(6486002)(2906002)(6636002)(316002)(110136005)(6506007)(53546011)(54906003)(6512007)(26005)(186003)(66476007)(107886003)(8676002)(66556008)(8936002)(6666004)(5660300002)(41300700001)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajErcnJhOFJTMmtJOW8zYnhkck1nSGJUYS9lV2tCRi9vUlFsR09YWHg1Um9V?=
 =?utf-8?B?L2E4MWdPOExTaHhmbnl4OXpTeW5DcWdRR2N5VmdPY3l1bkZLSjdBS1k1Y3dG?=
 =?utf-8?B?TFZYQnM4YnlYcE5iNDRXQVpPZWdKOHp2bTBJYTd5RjE3dE43VVpZbytrYW53?=
 =?utf-8?B?Tkw5QmNGaXJGaHdZbTNDdEtNang4RFpaNVNYY3Ewb3B3TTBpTEZuZXBRYW1q?=
 =?utf-8?B?TlNkZ1Fpek9GTDJUR1BFdENHNEVDelNqQzNVNWZOWjA3bW1HSVAvY3JQdGMw?=
 =?utf-8?B?ZlJ2WGpCZlFFL0tYdzc3bENDQ29Nd3R4NTBzZjU4dzA4T0dIUjVhRG5ZNFM2?=
 =?utf-8?B?emFNVXRPQzc1Z3BmODNYV1piNVNDZUVPWDJsbnRCLzA5c3JQbjJiR0xDcFR4?=
 =?utf-8?B?MVRscU54NnQrVGlHd0Y4dnF4NHhSVXZLQUtTcUxUN1ZEYjBHUUkyZlBicjl6?=
 =?utf-8?B?VDVKaUJGNkp1QVkvR3JqRFFaYW02NWFiS0lhbERHOFNjZndubmhmbDhBSCtp?=
 =?utf-8?B?NXJvd1hGcjZtOW9YZWJSblVNc0FOLzhHeS9jaEhEc29VbTVraUs4MVZPOGRr?=
 =?utf-8?B?QjJsRUVxZkdNVHgvMFhCdHNnZkxOendsejR3dmpWYnhiNU1BTm5kMlFmQ05Q?=
 =?utf-8?B?dWR5blNwb24zNkVUelVGRWVZbWJQMS9Ec2dnZ1ZNZFkzSVpwdTg1ei90Q2kx?=
 =?utf-8?B?b3ZyMTFsWWQrUStMb1N0dUNITnJndEJma3BjOTJtZU1IdkdLeE4rM2xvS052?=
 =?utf-8?B?ZmE3WWpTZVM5b2lDeXlyV3NRQzg3ZldIUk93MUlGOXp4S21UT0RiZjEwQXN0?=
 =?utf-8?B?MUxrdlRBajZIR3JXOWZKMWQrQnpLNktRUmtIOURqVmVONzQyUUJQdExhVVhP?=
 =?utf-8?B?K0V5Q1lIRGcxbmp4b2pSakJvQkNPdjd3RDhkbVZFc0tpY3BkWmtrWkdiTDJV?=
 =?utf-8?B?Q0Ywb0NQRHpZQU1qZHJXbENEZ09oNTJJc2oyOVo5eW9GTTRFYlhXMTNhek1U?=
 =?utf-8?B?OGh2K0VWK01wTmlXUmQ0V0JZUCtJaXNURk9tRTExMXdVUHpFRXAvZStKY1hy?=
 =?utf-8?B?WUJySHd3RWN1RXVjcklqWTkvYWRnZWw3R3hXZWI5cERPV0xSYkNjUU5iTWFF?=
 =?utf-8?B?MUF3Y0lFeG95bk1IMzFoUEg4T1o4Sk90d2Z5WDBwMkcybEJoZnFYSnRRVzB5?=
 =?utf-8?B?MFZaaUMyWjBHSDVIWnZiS1R6UEo1NXpZK05XV1NJUUFKRy82djNIeE1FTitD?=
 =?utf-8?B?N2xwYzgrVEgzM2c1SFJNUTV0R2M0M0Ywb3liUnJncHVsWHlFdlkrMUFaTmxk?=
 =?utf-8?B?STY3SGowdmdpRFg1cFNqQWI1K1BqMkk2VlYxVTlQY0FHV0JORU5NY0hwZWo1?=
 =?utf-8?B?TTc3Z1B5WERuazBSdTJIWHlhQ2NweHRhclZ5STZlVEVnMTUweDNFVzBaVHov?=
 =?utf-8?B?bzd1MDBKNEZudS9HTTZ5bUxsWWJvUFAwMHNDb3RQdzl4OHRSSVIzUnhVa3gv?=
 =?utf-8?B?Z2RDb2YvdUJEaTlxZVJDOVM5QklNNmRGZExCMHdGd0tnUTFEeDN1c1Rla1NE?=
 =?utf-8?B?OWdXWTVZY2xMTnI2VkJnQ1NCSUhRRjdodzQ0TGxsSE5kVFhRTlp6TGdEL3VM?=
 =?utf-8?B?QlpXOWlXS0FrRkNQdzNVZ2RTa2phQitZeFpTRVJyd3ZiVDhFTW82ZlVxTDJ3?=
 =?utf-8?B?enBZN3NYUXZxWUZSMnFTVGpFa1pLQkphekd4WUltdm1HaHRLWkZiN2FobVhK?=
 =?utf-8?B?VTFmQUJHU3JJNVFHRWtkdngxemVOYVhKYUd2TnVOTlQvRUZRRmhxb2FyaUtU?=
 =?utf-8?B?RGpDTHM2aDVodW9UZCtzOGNteDlDOTR6a1Z2WGdxS2pDWDlXL3BkNXpLd0w3?=
 =?utf-8?B?d1hOMlhCWE4zRmdCTkY3aGVZUWlPYVRPdEtiL3JkNEpxRFUzdGx0MVlmdlpY?=
 =?utf-8?B?bkZhT24zWllLSnZ2RTFWWW9pVFIrNGFyQW1vbE9mc0djWjZvcXBnLzM4Snhk?=
 =?utf-8?B?UXNNU1lpd0pwQWduN0hZQkd0NTByMjEvczZhRW00ZFBjTE45TEIvRFZna3pW?=
 =?utf-8?B?eUFUVFpNV3Fidkcvb1RUS3dXczc0V0ZRdkwycm0rZDhKa0w1MVdOdjBTRTZh?=
 =?utf-8?Q?clMnaIaLb02Fr9Qnf8PYmPBrb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d195e38-dff2-45a6-f178-08db3a8263ce
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:46:30.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOwDNu782Ry5NSW08t7z9GNuEchNaMj9YFiUgZ/MFTuiA6twjsfAP+4JIQF+Vip9eo/xBYEhA/mbxhMxmOTfjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/04/2023 16:13, Leon Romanovsky wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Commit cited in "fixes" tag added bulk support for flow counters but it
> didn't account that's also possible to query a counter using a non-base id
> if the counter was allocated as bulk.
> 
> When a user performs a query, validate the flow counter id given in the
> mailbox is inside the valid range taking bulk value into account.
> 
> Fixes: 208d70f562e5 ("IB/mlx5: Support flow counters offset for bulk counters")
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 31 ++++++++++++++++++++++++++-----
>  include/linux/mlx5/mlx5_ifc.h     |  3 ++-
>  2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index 8b644df46fba..76384555b37e 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -666,7 +666,21 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
>  				      obj_id;
>  
>  	case MLX5_IB_OBJECT_DEVX_OBJ:
> -		return ((struct devx_obj *)uobj->object)->obj_id == obj_id;
> +	{
> +		u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
> +		struct devx_obj *devx_uobj = uobj->object;
> +
> +		if (opcode == MLX5_CMD_OP_QUERY_FLOW_COUNTER &&
> +		    devx_uobj->flow_counter_bulk_size) {
> +			u32 end;

end should be u64 here.

I'll ask Leon to send v2.

Mark

> +
> +			end = devx_uobj->obj_id +
> +				devx_uobj->flow_counter_bulk_size;
> +			return devx_uobj->obj_id <= obj_id && end > obj_id;
> +		}
> +
> +		return devx_uobj->obj_id == obj_id;
> +	}
>  
>  	default:
>  		return false;
> @@ -1517,10 +1531,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
>  		goto obj_free;
>  
>  	if (opcode == MLX5_CMD_OP_ALLOC_FLOW_COUNTER) {
> -		u8 bulk = MLX5_GET(alloc_flow_counter_in,
> -				   cmd_in,
> -				   flow_counter_bulk);
> -		obj->flow_counter_bulk_size = 128UL * bulk;
> +		u32 bulk = MLX5_GET(alloc_flow_counter_in,
> +				    cmd_in,
> +				    flow_counter_bulk_log_size);
> +
> +		if (bulk)
> +			bulk = 1 << bulk;
> +		else
> +			bulk = 128UL * MLX5_GET(alloc_flow_counter_in,
> +						cmd_in,
> +						flow_counter_bulk);
> +		obj->flow_counter_bulk_size = bulk;
>  	}
>  
>  	uobj->object = obj;
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index b54339a1b1c6..3976e6266bcc 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -9283,7 +9283,8 @@ struct mlx5_ifc_alloc_flow_counter_in_bits {
>  	u8         reserved_at_20[0x10];
>  	u8         op_mod[0x10];
>  
> -	u8         reserved_at_40[0x38];
> +	u8         reserved_at_40[0x33];
> +	u8         flow_counter_bulk_log_size[0x5];
>  	u8         flow_counter_bulk[0x8];
>  };
>  
