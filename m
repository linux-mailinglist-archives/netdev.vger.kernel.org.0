Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2896664242B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiLEIKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiLEIKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:10:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF9F140D7;
        Mon,  5 Dec 2022 00:10:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m30LPT6Yy1dX01xqzzMg3RhVkJsRvy5mfaBUp8HrqmO74T1AeKIPuMsggMhpDiM+bkLimhxOxCdn39VSH0HczqtqwXZmXdZH1g7gV/+pNSxS5A/Qax6vfpNia1VSfWV8feXl341g6caEJgqMZmVrLOEpx5xbilevD5lw9ZUzuwRQHVw825WPFsMDjTf6Z+PBriK6H7WBS3PNxaV/KjoiWE19GzwIw6O45J91t5PvIxyrQSqRkB5hqrZgxyXzrViVDhwfa/mgUs6dqHBS5yvi+qOmwATqjego1Iw37zGzkEFJcTGt6O0VD/rnbwMJRz9RT/TTlAsH27aXUYZ6PKUcXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIFUljxvBzkin46wh4JHtdZ3YdiMz0PRIsnIFRIpim0=;
 b=JyGKmNQo1c+H5alMWbvQEzXXmhSyO+YIzE6IZ8Qj+M+R3/f2xT9h06CzrIEkOi00MgWujjmI4i3nYgvXdlCV0hnxGhTTPuyTmlZwSbpgsx2I9a6FDZsh78jOgAVVLY0tmAo/ymiXl096A/C1am/mW+iUBi0eYThiR1TvLgF5G1ysvQe0f3kd6c9694prUQ0n3sfb5JTu2qel5N2O30958mLqlu0z9bnoViPA4Xhti+W7TyKhG4yU3iDB+9W8ccO3aTHS/wiM6AIvUO6UsAt+Uq92plsQX4bXRBnkqvTJDY9WnMAkxvfEfX8M7d1pPdN33UvzcLii83kKcOzRusUkmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIFUljxvBzkin46wh4JHtdZ3YdiMz0PRIsnIFRIpim0=;
 b=uXZDDbzlqij31eVeC2Norkjk2extSSCD0w5qSTjSwXjNzNCmp8d73zqbe12Nn0Sthyq/1WgFNVRVK6X2zmocfZoKpmKqgvZJ5uzqoqmlQaf1hVBGIU6QtI46ju/w5RrUC14XRz9erb/jzJePpv7KyBxFCpJ7Iv9P8SkeQHpoNproOow/GEHXNOD0VzCm4A/ANI6BbubiQERB9b19Ztyv9A94pinVWUbt/ZOld74qkMeK9AdsqrfYWQ69ziNa51T2EMrD5HATvvy+FmALioICxNJnzAafdtrAfxJSz47Kaypc1VY7bBYzcOu9xY1yFd3Fjv5Q1bITk673k2i7DSeF3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 08:10:36 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::3ac6:16d8:a679:e262]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::3ac6:16d8:a679:e262%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:10:36 +0000
Message-ID: <7eea41f2-ef05-ab5d-0191-d155ccdfb5e0@nvidia.com>
Date:   Mon, 5 Dec 2022 10:10:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH net-next] net/mlx5: remove redundant ret variable
Content-Language: en-US
To:     zhang.songyi@zte.com.cn, leon@kernel.org
Cc:     saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kliteyn@nvidia.com,
        shunh@nvidia.com, rongweil@nvidia.com, valex@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202212051424013653827@zte.com.cn>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <202212051424013653827@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::19)
 To CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: eb9d2a12-694b-4abf-c68c-08dad6982ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnmcYBwPzrMw1ji2oEcAwUgJGowJ+PuFZ7gAmetv/IavEBYOeq0JPYNhkeXJwMMCHi+fWajD5VumBe3Il6xOe+iKFXbymDZlkzth48BzdAetVc6VbPJigHfeghc35NZMg8XT69MV44koim/hBQ381uzTz+4O+7GXQIKYDLCvlRf0EWnm310TDLnIpqng5SetOIe+42eE1OIpI9ZNYAlthEAbQZ+1YPUNFZKvlkSx0WesjRU+deJM84o75TJUFPiPdyTCTH/TtJaDDT2rdmP3pftJ4p5pk2hDcava9p49JqiLlAVYPe+1DYsJJLpzytxULDJlHUsXr5dNV2WO/ATF9kpYzAvcUxMZ/OrVKrjONrrHgEoNTmS7sHRulee7TFlfQ+H64ZvCS0NRvW4Xb2f9g+hiiw23f2QB6PZCNemRi/2NWahn4iyUV/1eKzN5yA3haUA4ZkEnLr1DpaZ19xBg8Cs4O2K4pBbcZjLm8NtkqcwLRjp4NYjLFICxdy8yDTwIMxI87KaUxJXtwWroqgGTcVe94WdbI6TNKt2S+qyiw0NWCUn8aGQ6L+U6tRvpXPjdgRdLQ4CJ6C7iDEhio2UrVobXG9UFSuaJze4l7/JK9OyNERPVMSvDVMAB3GjSmk7kkrizV4DNQLrIac1ZS34ea/46qUdIVM3oFEFQMQ58ezcFRV1wOrm3iptC5/ilSY6W48BQKAzQ9JfXYvRj+ksaP24RzcdOPyr1rA2RMfXGo10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199015)(2906002)(86362001)(31696002)(83380400001)(316002)(6506007)(6486002)(53546011)(26005)(6512007)(186003)(6666004)(478600001)(2616005)(5660300002)(8936002)(41300700001)(4326008)(38100700002)(31686004)(66556008)(66946007)(8676002)(66476007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEJYd1dXUjFLaTRDOHNoVkQ5WSt3SnpiNjZKZlNmd0dSeFY0YmRNVTdZWTRZ?=
 =?utf-8?B?M3hBa2VhSFU1Um9qaW01NnVlMit1UTMxWVZOdmNFcDF5dDl2aEU0NjZlb2hB?=
 =?utf-8?B?VUdzbm9Sc2lwK09oaytRRVo5YzZrN3piMlc2MFBPanl1eDJVUzdpOHkxeGEy?=
 =?utf-8?B?TVhocmpKNnh6amlhTkNubTh1Si9uZkh4QVJwWkZUTnZreDhYc2RSOVhHa2x2?=
 =?utf-8?B?MmpjMTgrQ0s4NkxIOWJxUDA2eDRqK2NzeHYzMzBPRVFPQ3hKWE0zRTVxbm9K?=
 =?utf-8?B?SnVXMVpxWFpZQ1ViVGdQUHVKa0trRGxhR1oyS0VHemFPVU8ya0RWbmx2SENT?=
 =?utf-8?B?SnZmSXFwdXY0dlBjUVBRbERlaUJqY3NMVUVwQzEwV2ZrKyt3QnZnY1ZXYy9D?=
 =?utf-8?B?Qm1kYXdqa29pSkZIbkd6djZpbkNqaktsV2F0Z3hVZ1RONkNMK1llZ3ZhVm1w?=
 =?utf-8?B?ajFKaU01T3Z4M3EvY1IyVFZBYnhkc0JtSldYdFNJbW9jeEEvNTlMeEw1WjVw?=
 =?utf-8?B?a29xTHRndFdIbmppR2ZEKzhmcXRER0dLMTZlVDExVEdPYk9kR3NwcGozQito?=
 =?utf-8?B?M2x0RlNYa2pFcTd6RmQ5T1RVZ0JMSDMyTXhrYitGWXBldWVOUTgyVGptaVAz?=
 =?utf-8?B?VWwvMmlKZWxWclY1bEJ3YlFDMUdvQTBCd3ZkUElRNEFXbHhBUHpmQUl2alVx?=
 =?utf-8?B?d1FCMG9HKzVjOXZKSTAwNkd5NlBVQU1vMURSNGdrN1VmS1JJaDNrenBWdXVM?=
 =?utf-8?B?dWpzcm1uYndDNnVaZHE3aHc5cmtHSnhPbGNzcFhoN05MOGRRTHFKNXllVmd1?=
 =?utf-8?B?NldEdHFWT0NDZ21VTExLei9IUkRHMnhIVjlNNEhlazJ6bldMRDB0NWhSVzh1?=
 =?utf-8?B?L2FhR0FjaElqeHh6SElUeHJyaTB5ay9GbjFXWUxpSWEzeTV1MG1EMEk3bTlT?=
 =?utf-8?B?bHlNUmdzajI1enpyNGxLRU5yYmR2K3VhalVZOGdWNlNJWXJFVEFacEUzNlhR?=
 =?utf-8?B?Z0dzVGhoTDRZSVYwMS9qUE9LeHp6NWxINEpqY0dKUURZRk9XQ0RTbXlvYWFT?=
 =?utf-8?B?NktIcTFkdWlrMjVEWHExSWQ4dWNXaXRBVnZEeS8xMzAzek1nejRxbVRBazdw?=
 =?utf-8?B?clJpZlhZblVxL21zU2gwS2d2bGZWZ0xldHlRUENDT1Nna1UyWEw3ck5kL2FC?=
 =?utf-8?B?ZjF4U1JvQUVYSGxFMTVPV2NiR0ZLRHNuMlM4RTdodTRydmFQWWcyTndaRGNo?=
 =?utf-8?B?d1NROURWRm5xWlkxQmZ5QkRYMzVXS2RIZ1I0SjVVQk43ZHFvTTRNNnlBZ1lv?=
 =?utf-8?B?N0RxV2FoTEFXZHQ2d2FMNW9wZmhOdnpITGprZTlzcFo2ZzdaVnJBeVMyZEdZ?=
 =?utf-8?B?SVR1MkFFMzUrSHZYWUw4Y1ArQXF5cDFiajllWTBuTHpuRzd2QkZ5ZGRXamhK?=
 =?utf-8?B?VSs0OVNKY0NlWWJicmZLNmtSWDM1RWQyVGEvNUJnSGZQVTNXejcyakNZaE1h?=
 =?utf-8?B?TW1yL2FtS0hQelI2U3lsdDErQWNHWmN1NFB2WVk4djZPTWIvWFUzejlHQkUz?=
 =?utf-8?B?L0pWREFUTnVKVzFENVpLc3N5NElBejlrRXhTWXJTZ0pPZXdFNGVzeEtwZm92?=
 =?utf-8?B?UFZSWTVIQnRjOG1ncGtpVFdNRjJWV05FRklNSUN2TjRKT2NQQ3g1RUFKTGtU?=
 =?utf-8?B?WDBrdTY4S25vcFZPSmE2VlBhbjlRbUxqWDU0YnlwekdwUVRqOEZsTHRNRlM3?=
 =?utf-8?B?cVp3QXhqL0xQTWxRZ1pVODJuaWdWWVFvc0o2Uzg0L2N0cnJrR29HVEJxUDBz?=
 =?utf-8?B?MTdnSVIzUzloYVpFNENPNVd0V3U1ZVV2ekQzcXFHL2FSRlU4dThvUC9JK2M3?=
 =?utf-8?B?WTlqdEwzcnFvS2l4Z1BuL0JIb0Z5UWY0Ri9vaHZ6aS9NNjBkNEtXVFd1eDQ4?=
 =?utf-8?B?UFJkL2oxaGRTSW5lcWhaVGM3R3V6NHZ6Qmh3SW5rWmk1MUw0VXRVUmlmcUJ2?=
 =?utf-8?B?bjEzeDBZRVdvMUFvUDI5VWFsQndRKzdyWUJldUw5OWwxZExZYmRJbTRLdHhi?=
 =?utf-8?B?bEVHd3dPWGVMRUhMSnMxNkVqdVBWQ3BLK1Y4ejRCQU1LQzFrUTE0a0hDYTNo?=
 =?utf-8?Q?9acca8nsuebptJEel59owVL+t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9d2a12-694b-4abf-c68c-08dad6982ff2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:10:36.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dp3FAfXC5W4jBNPAYKdcX1iAOzOaFoahwfjtsf/4FUdrBX8RZ9OE+1LC3RClNAPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/12/2022 8:24, zhang.songyi@zte.com.cn wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> Return value from mlx5dr_send_postsend_action() directly instead of taking
> this in another redundant variable.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> index a4476cb4c3b3..fd2d31cdbcf9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> @@ -724,7 +724,6 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
>  				struct mlx5dr_action *action)
>  {
>  	struct postsend_info send_info = {};
> -	int ret;
> 
>  	send_info.write.addr = (uintptr_t)action->rewrite->data;
>  	send_info.write.length = action->rewrite->num_of_actions *
> @@ -734,9 +733,7 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
>  		mlx5dr_icm_pool_get_chunk_mr_addr(action->rewrite->chunk);
>  	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(action->rewrite->chunk);
> 
> -	ret = dr_postsend_icm_data(dmn, &send_info);
> -
> -	return ret;
> +	return dr_postsend_icm_data(dmn, &send_info);
>  }
> 
>  static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,


Reviewed-by: Roi Dayan <roid@nvidia.com>
