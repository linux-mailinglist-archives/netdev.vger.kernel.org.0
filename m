Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359F46E61E5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjDRM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDRM2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:28:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDB4AD06;
        Tue, 18 Apr 2023 05:28:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgMU+mpBosHFMAcHOn/hcPtz50GDWdjTbjBfCqIAAL7TXhSzV8TohKz51+auG5WSJcAv/2DTZ4cCFO/vyAAVK7unG0GH43nbr7PZUgByV70D1yNcMFZmbaT1TUeJd8JVHbN6EKmQB6h/AirRbcoBxfRnkrLPXwVp9dPbEq8nCbPYkfw20E23ZfZYeLFMjrLKO3DXK6vSpUR3pPz+IfajqZ/I9pt9wsguNLJdBqWLGJEJSa9egyjTbmgNqiLzvrC/3LrAt9TbOm/NA+3IF0U3HvggKgFmrgpewPytRZxvEqyTvegPsOUstWZWol0HzHgMoIQa2/+D3O/Fm6dNGtBtEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kAdX8MOVXyTnY7iI1CPZUFgxZYQMTDRUv13K5IWezk=;
 b=fFMuaCAQKdAw3KjVRKKAjzg7aJsuVSPJJ6GCrQzxiRTYNuHOtsQebQ0RylQ+h6EGW7bDvoZcl6SD0J6+HUQRO04gT+2X4eEKoBBKW8f4DRuHuAOOQrwBNZEDtE5Gp8sznpL82TClCfd2NSSkKhCVuezERpCv/c8+W8X6ufwXnew9yIjvw/BNCPiFEnpVTBVBToLPr/h6h94Y7cUidkiBzRB5Ffps0Dqhc5aDb2vg42g+XxXvKoZ20e0INIC88xgMSL1oyMULccIQcTqRGwq53tfy+98w6sR6P+3r5HoW/imEhlH6Nq1ZahENhtKqswx6DZr9RSsdhPf0hYHaB0VvXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kAdX8MOVXyTnY7iI1CPZUFgxZYQMTDRUv13K5IWezk=;
 b=BtsO+dhuwJzeYRB31Dr2twE2qMoAmPApJcmcRjfW7KYAqyt3r8npM3crgMEgV7tJzL4S2O2sSAKOoeVpSfs661xLVklG7NaC3s7nPhL8XtG6rsb+rhSNMKEZWlNTk6zl+ZX3WniUPDKLrfELfrMT+ivLpV7hOvsAjTyXSwJAF2QBBXZ60mqCdhYeEr61iBTcq7IRwMkjxITLH7yePOGnb8gKy+b+YvxZuFb4vqH2wYgUu0NHNF8Az2iFxRAW/o8bFidtEdZcm7mRTcFj3cjtZ+Vezv/+IPKRXic8luIthLuN7Ku+j230ALNbu9/HYGh+qMSgs5YLY89kz+zlNRKR2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25)
 by CY5PR12MB6598.namprd12.prod.outlook.com (2603:10b6:930:42::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:26:16 +0000
Received: from MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::16be:6d6a:a823:643f]) by MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::16be:6d6a:a823:643f%2]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:26:16 +0000
Message-ID: <86a8848d-0ebf-2d0d-4a4a-444560a8651a@nvidia.com>
Date:   Tue, 18 Apr 2023 15:26:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/2] net/mlx4: fix build error from usercopy size check
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230418114730.3674657-1-arnd@kernel.org>
From:   Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20230418114730.3674657-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0148.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::6) To MW2PR12MB2489.namprd12.prod.outlook.com
 (2603:10b6:907:d::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2489:EE_|CY5PR12MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c0f536-8f6a-4494-53c6-08db40081abb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EgnBWRXiYUGWiQNAL2THlg1ZCUU8pm7jrVmoAjv9gpo+TWJnYSYiEGTkeHsFPcsZY4x18RUe4dgqYn12dCeTSdTmxHQXdyK8jlsa5v5wT9YO970J/QMrxMQtSizysIrrwCHpzeVr0kBGs5dZzJFJTqCQPb7LuqBqn1vOUty77DbUAveOOHf7nlxfwX0MKeAzJAx+vR4ARaWsfY0ErQV3DuWSQcn4psuwp2unSB26cVgD8ww5i+buocnaSuLReFSZNUR3eNgmLspgudutFfBg2yqwAQxiZNVXo8a5vNUhI9XxjzfnwpgEqf4TEBRT408tpa0bGkND8NrcAmiZ2UY0IvewIYxfNqgfL4oWwM9SFj4a4eo+wGL4Ie5ORMPVdkiVdciyJ0dsWKAuzENZqdQ7OSaInreLT3umzD/if6ZYArK2GN6vGOODy9Vlw+tP5mMPogFhyjTwu50YsYqZKCnvwePDsdNEoJHcJIiipDT9hEpmIHgUnwfW8k1miyVhpkq/qmsvmDYVI0eaZWby76jQRaw4l81ko32/yucwN4yIL2IaRx8IRENnZh5DrG0zjHC76FkIIXzcHybSTOQpMJ48HP5vf3VdZqKiJZDkYGyqMzoauSUHgCxXSOP9IrRwEDFj7Enm19jf3gCdiQtuBJefA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(6486002)(6666004)(110136005)(54906003)(2906002)(38100700002)(478600001)(83380400001)(186003)(2616005)(6506007)(26005)(6512007)(53546011)(36756003)(4326008)(5660300002)(316002)(7416002)(66556008)(66476007)(66946007)(86362001)(31686004)(41300700001)(31696002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmNtTnpZWFJLdUxXS2c4L2JXY3FzRi9tbEZZQ1JnMEI0ajd2bEdNMml0VDY0?=
 =?utf-8?B?Zk9VK2hsdXhHUVdpcEUwbFJWamdxWGM2QWxpbTZYWWZjWTBiUjdOcnJRek9Y?=
 =?utf-8?B?akhONUl6Q3IrREkwYTAwWklLRThnMHRmQ1Z1TFMxck9MMU83UkJVWFNTRitE?=
 =?utf-8?B?ekI0ZCtPOTN2QjRIVEl5M3VFMEJpWmRxYjVLWUlCekV4eVVDQ3hzK3VYZVB0?=
 =?utf-8?B?OHROY3RIL1lBckZJTGFiYm1yZ2l2d3pLUnNJbnNyZ1lqRThVSk1QNW16REFY?=
 =?utf-8?B?VC9FV21Yc2RTZTZ2VTRrZXhseXBFcnFKN01EdE50QzJmRHZQWG9VVGlRUFpp?=
 =?utf-8?B?dDhUZDFnU2JBNm5WWURVUjNYMFVxaWtlN2pEczhodFpPUFhKNjF1anpWTzdL?=
 =?utf-8?B?SUZnOTR5QzMyNlNuQ09jS2dEd0JuYUozb01wODh0S1E5bFhyakQ0aXJNYkVx?=
 =?utf-8?B?Ym5hRmU3QVNxZ1EwbHFiS1BmSG5ZRFNJMzVtYk5iV3lrVEMzeTVUSjJlMWNY?=
 =?utf-8?B?bDRDa3piYkZxbmc4YzZwY2pncmRQRUFKSTdWYnYvd1FlekJLVE56Q0x1bzdG?=
 =?utf-8?B?ZE5kRXBxQWM4eTM3VDNQYXZZd0djNWdRcnJuRkN6cGU5akN2dWEyNFRNNFk5?=
 =?utf-8?B?V1drK1hJTCtzSXNrQ3VrV091YWE3bytIZFI0cjN3ZEpjY3lRMFZ0SStIZ1pK?=
 =?utf-8?B?SGR1c0ZsRWRkSXlYNEtuVXdZMUVCVmFYdEo2eSt5M244MHlMNjFYLzBGb3R5?=
 =?utf-8?B?dTVyYVUzVkxLN2J1b3BHNVBScVVjWlBDQWp0V3dJSDhpMklhY2MyRVRoWExO?=
 =?utf-8?B?dzUrSDVIWHowMXdBUExKOFF1QjR1RTZ5Qno3K0NlL1JuY3NSU2JLaWFGSlgw?=
 =?utf-8?B?Z3dHMEZadmxEc1NDaGR0NCtsbmVDMnhvN1FobE9NS0c0RDVHYkErWENCa1p6?=
 =?utf-8?B?czNuOGVLejVjR0lvNXdCWGdUVnhEY3pFR000NFpXVVhpQ1JSbFpabXdwemhH?=
 =?utf-8?B?S2ZYR2RoeUtWV3V4OTRUMDI0Rjk3ckdkVFJjUU5FM21OMlI4Zys5ZlhQY3Fm?=
 =?utf-8?B?QnVvdTRvSk1rWDBJOXdnTFF0SS9qNjU1US9sRDVFa0FUWlFZTksvWnZhY1VD?=
 =?utf-8?B?VS9RMzd0bXF3T1g0VmVWNGNjb1NnR1dmdWtnZnNOZG83bHlheXh4MHlzMHI0?=
 =?utf-8?B?SldTZEFtQlZVMVRrMXBWUzF0czQxMzhoaU5QWjdsTGRNMkZoNFBEeUpLck1E?=
 =?utf-8?B?bGp6YmtjOWpvQmlUWjY3d0hPNHE4R25uNC9ucGVvb2M2MmxLbFovMlVzblBn?=
 =?utf-8?B?RzcwaktqSjlkZnEzTEJRbGxaaU81ZEJZNFpqKzN2dHNIQU4zckVSZUNyVXJQ?=
 =?utf-8?B?UUJldlBrdGNFZHo0UGRSVWlNUHhCYkcyM0tJQkNiWFo0Qnc5SUxtYTYva3NO?=
 =?utf-8?B?VU05M0xoK29vcUc1UVJEUUMrNDcxRDlUY0NIYUNDaWtCdUFpY1dOUWJSbEN2?=
 =?utf-8?B?MW5SL2FKTVA4UTc1eVRIbjczZXZRakdJOFZyZjN1WlV4S3VnbW1hUnNDZms4?=
 =?utf-8?B?Mi83ODZWM1Mra1lGZm9iRFphYllZRnZocVBPRWk5TXFUbUtnNW5xT29BVGMv?=
 =?utf-8?B?Qjk2ajVXcjRpbGlUR0FjdldnVlpLb1l1MEk3NjRMRWhJbWQwQ1FVNHg2OHBo?=
 =?utf-8?B?Qzlxd3pyOWdjR1pYenNvQW9JUE04ZWdFQjNqNWhsR0FyUXk4a25IaSsyZDJz?=
 =?utf-8?B?N1VtYnJyZjYyNUE4SWo0VFprVmZhZjlDN1lIUGtFMFdQaWVEREtXOXVaajk0?=
 =?utf-8?B?dmpRRHBuQitsNWtDSWNqTTl3UE5hTnRJQlV5c2FOaXZwc3BVSFA1VFNSV0Uv?=
 =?utf-8?B?a1pYamUxYjN6cDBDbDN6S3pWa3hvY1g0WU5sMC91US90cFUwcDdOOXh2WCtH?=
 =?utf-8?B?Tmt1bStQczJybVFxenFOVHpDcXVxZlpxTTllem5FdVRMOGx2OHRvK2RKZ2RR?=
 =?utf-8?B?Q0Ivd0JybGN6Z0h2bTllL0QyWTlYZjNrNWFXcGNnN3ZvTytGOGlCWlN0YjYv?=
 =?utf-8?B?Sit6Kzl1anJkTjBGNU9XOE5VTWtYUG04YS9lUk15KzhZbDJlRzRiNEJTR2Z0?=
 =?utf-8?Q?kbyzInOixSjahWEW/EIiII+Xh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c0f536-8f6a-4494-53c6-08db40081abb
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:26:16.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1nq6nCLfmmIRVyBL8Uh2KJ+CEAjb/jDCOaqwDcb2LiKPVD1PiI+ekan0AiZ6ybMOb+2IVC/zWLkJO++xf9ipQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6598
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/04/2023 14:47, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The array_size() helper is used here to prevent accidental overflow in
> mlx4_init_user_cqes(), but as this returns SIZE_MAX in case an overflow
> would happen, the logic in copy_to_user() now detects that as overflowing
> the source:
> 
> In file included from arch/x86/include/asm/preempt.h:9,
>                   from include/linux/preempt.h:78,
>                   from include/linux/percpu.h:6,
>                   from include/linux/context_tracking_state.h:5,
>                   from include/linux/hardirq.h:5,
>                   from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
> In function 'check_copy_size',
>      inlined from 'copy_to_user' at include/linux/uaccess.h:190:6,
>      inlined from 'mlx4_init_user_cqes' at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
>      inlined from 'mlx4_cq_alloc' at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
> include/linux/thread_info.h:244:4: error: call to '__bad_copy_from' declared with attribute error: copy source size is too small
>    244 |    __bad_copy_from();
>        |    ^~~~~~~~~~~~~~~~~
> 
> Move the size logic out, and instead use the same size value for the
> comparison and the copy.
> 
> Fixes: f69bf5dee7ef ("net/mlx4: Use array_size() helper in copy_to_user()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cq.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index 4d4f9cf9facb..020cb8e2883f 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -290,6 +290,7 @@ static void mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn)
>   static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   {
>   	int entries_per_copy = PAGE_SIZE / cqe_size;
> +	size_t copy_size = array_size(entries, cqe_size);
>   	void *init_ents;
>   	int err = 0;
>   	int i;
> @@ -304,7 +305,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   	 */
>   	memset(init_ents, 0xcc, PAGE_SIZE);
>   
> -	if (entries_per_copy < entries) {
> +	if (copy_size > PAGE_SIZE) {
>   		for (i = 0; i < entries / entries_per_copy; i++) {
>   			err = copy_to_user((void __user *)buf, init_ents, PAGE_SIZE) ?
>   				-EFAULT : 0;
> @@ -315,7 +316,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   		}
>   	} else {
>   		err = copy_to_user((void __user *)buf, init_ents,
> -				   array_size(entries, cqe_size)) ?
> +				   copy_size) ?
>   			-EFAULT : 0;
>   	}
>   

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks for your patch.
