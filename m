Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79664623D52
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiKJIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiKJIUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:20:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D1326486;
        Thu, 10 Nov 2022 00:20:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDMz9Eq5LGgoEkgkycBGQu4n0phdNv4ORZvB9b8lFnOb6Xi7/FF104Ioi7RZPjESQyXVMJK2zrOt3jcrnfeqJIEBL0Greq35Tzz4zLJ8nMSYolgfPkyeE2scVnpXJkoMoo1iAhWXvSeVkKSZjQUVQz/Aqx0KMdZNOZWKUnZcdQMXriVDticNqWQgTFHrvp5GsTawb1GhmYQo31oI8mNHp16oaN7Tf7JKNCixIDNr2qh/A/ivrAS4IL+RXHdUuk5bMKnYy3k8neJ1HvcsmqzTZ8iDjB2e12SzKpzGh2E0I6e/n/Fr3voUSozwmLfnoiA1ihRmjA7A9I31zr0W5iFmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viMAYaW1uekkjDoB37zbHQOqJAA17lyA9XK9EjQXAFo=;
 b=ihhiFvDUFpQNeZQ6+v5JFB3hW/XMaMNRCqZBx4/eY1wU0c+UYLHE+U4fuZwVoJ3sy/rUQ7G16d7gxZ5/Wz5bSlOVSQZDzSDgUH/dOUh6xI6hTK3cY2W+K8pqZDNKYsS8f6gARpHLuIxzLqaL0bqzyX83LP+Pdt3b/LgnKDc+2uAynoOzsLXVutohZAV9JdzZcLuCaBWp1PcsVJIZyKxXBSQPM5DFaQ4Dco+i427PUd6N1qEmGvHK46Ex0PrSHCcWkBTtkpQT1nhW9izve/ff0EYM+q6KSVRioLfNqcg87WgiMUwsfwyORvt3isilAlfsYK2LuzOtkMcf6mdWM//4DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viMAYaW1uekkjDoB37zbHQOqJAA17lyA9XK9EjQXAFo=;
 b=X2h3KZgp3LV+4I4oPZ7njoMCXuz6hVc+ydlKAVO1evRUR05ruplBQ2PsXtmwXn/2EjoncaaV1fFmJDcSNvAQCDdP61T93denpEhVpNZzGOp2BKeuj12iQg9FCXwNPyJGPhg3S4SzwiKItmDMH2f50y9jXY6P6woW9zf2vpndvMX1qCNtxgbOpFA4EoNEhTUBT6iQcNp8uMJXIPPc4WNMcmcDhgP3kZReGvM7iiYFy9hKKLZyBuIZHI35yxoAAsdsgF7kdUW3aeJ0nb/3KHKG9s9mzgYiLaftsRYQ8/8HR4sqJC2lltqn+bjTphoIxUbhwo4oH9JibuHleFFcz6eGkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by MN0PR12MB5714.namprd12.prod.outlook.com (2603:10b6:208:371::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 08:20:17 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 08:20:17 +0000
Message-ID: <b464b0af-69a3-ffc9-41f6-3d93f9bc32ce@nvidia.com>
Date:   Thu, 10 Nov 2022 10:20:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH net] net/mlx5: DR, Fix uninitialized var warning
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kliteyn@nvidia.com,
        mbloch@nvidia.com, valex@nvidia.com, erezsh@mellanox.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221108015314.17928-1-yuehaibing@huawei.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20221108015314.17928-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0095.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::19) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|MN0PR12MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: f113872c-6e44-4805-fd45-08dac2f46685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LshWh0O3cYRDIS1VNBVnCFXeYTCThCdFeI5qV6HVfze7K3Ods7afIkhTW797pY1B5bRf5z3vnN1IiGCrnaCo2+rwmnDU1AcUnCqNRnj9VSD3HXIhrlsLgzo6i3qhRDwGfwYvHo7nawIqmJMf/ZmnIPXkodHuxBeovuMMkrV52zxVCCtDGsvgQLy/3ddB1sxqt1Ge+td4gqttB6PKDdbbOXAzVUkKusdGdOuxlC+fDOpwuetCYaEHI1Kpd2SyVYXKgEINlK1PurmMjYXlBEISI9a/swKdkN4WK3P0gW9E5KtcDseJ3Cylo1xgvgSttUZQezX1PZqUawodm7I1EjCJ3rdF55XWYVFe/qBsSvU8TJGmfAZJHxVPh07i5KHWD5MSb1thvs+xESQD/YUdTdFBH2oWJdfuSn2LpoVJnrW3Aomc0EBjxuE1jw2XDW9jIj4l0DlYIzrGUc9FmFwoPL/6+mlwXxInd2cPaEYwbvz8Vg0SP0F7vehUGQ80SuZGnsB+Ju4cKF1u0DoJl+IEklptplAYiACalGAjwAsxQisS+v1KqrhHUQ8IYFcLfOtnaKpx7UrpJ9/ElaofJdG0p5BfpitAt4hFrLoFz5629hJsWiHADhMFE/2hyZFA7yiZZrTFjI/U8m9LcGTW/5Jk6eA77sLQiRoQOt3tPBAMi0/BPFtB/Pk2zX99bRwBeL0yynVsq+q3vepLtIZXkSblrgGfhdYcDjc7EhPR0qOJnkKA2tSgZjbKQz8DNjujnfWc1ib/ZHkOwaM4eCgijv/TIywp8Gv0M2tWJLAPxvn2tHTz54n0OZWQ52cRoi887clapR6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(6512007)(4326008)(8676002)(478600001)(5660300002)(6486002)(66556008)(8936002)(83380400001)(6666004)(38100700002)(66946007)(86362001)(6506007)(2616005)(26005)(921005)(316002)(53546011)(31686004)(31696002)(186003)(41300700001)(66476007)(36756003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU9Wd3psRlNWN2hKUTJoTTlpdnFzakNEblBadmZiUjdZbHVmdFZtVFBDVGVo?=
 =?utf-8?B?NVcvMlFQdDRsV2tjUkczdFRjZFJ6RjNkWG9lTmlOV042TzJkNGhUN3hkRy9n?=
 =?utf-8?B?Q08wdWFrV2c3VDBSbmVzNzFndHgvS3NVN2JMdy9NdlR0RnFDZGlneUFsa0d3?=
 =?utf-8?B?OTc0alV3WEtHa0ExdU5YZnNaaysrSUZRYWVoak1PS0t1NUQ4SXFjV1B0ZjJN?=
 =?utf-8?B?dUFuTXBwTDFNUEtWWGxMVmJrRnpycEtIREdNUjNaWkE4T3JCelJJRTl6L28v?=
 =?utf-8?B?ZjY1S1Z3N0V2cy9zZUVKei96TjRCb2tBdUtmUWMyTkdnNDBZSUhGYkd4Ukk0?=
 =?utf-8?B?cForUUE5bkIvTkhJZ1dwZHM3QUpjbXhoNDdDbUc4NTZXcnQwQm4xSjJhSFlB?=
 =?utf-8?B?TEdqV1l3aEFONUxrM0pjUkJBS3lvSFcrVnBUaGFjaSthTHovWDhINFRIVlBC?=
 =?utf-8?B?L3ZZMC82OEpRRUpsOHc5N2VUVENyNkcxTk1EdEUwNjM0VmhiUTNVZVFFUEV0?=
 =?utf-8?B?SXAzb2xuRHRXd1lvcCtwaEZsK2xHV2Nzd3hPR1E1dG1yMTV3SzgyaUZqanBv?=
 =?utf-8?B?NXFnUTI3NmkyWHgvNldlTml0WEpsTDc4aW5zL2tWN2FsTDhtSlo0YjhBelMy?=
 =?utf-8?B?dWljZjBZcEY5blVJK2ljdEpUbTdtNFk0STlQTXRiQncvaE1zRGtQQks5NEho?=
 =?utf-8?B?YzJRbUh0QlBjUWlETVQ0T1BmU3k2S0RYNUtJekllem1PaG5qVnJLTHpabzZi?=
 =?utf-8?B?aWpZd2xFd3o5clI3RnpEVy9mcG04UFRLamtWclhTNll1Wk9jY1ZhczFCWmxV?=
 =?utf-8?B?OFFBR3BJWU9iQ1VYaFdPbjBuQ0M4alM4VS9DdFNKVkI4ZU8wYi9EVVVRZUZs?=
 =?utf-8?B?NklHbTZXT2dYdEhkUHpmVGFyOGJIY3VzWkxQNDE5MFRPZ1o3OTVDclBZZEdo?=
 =?utf-8?B?d2YyTFZzVk9RVGhtaHllRm00WFhoL1NVdWU1a2JHeWMzenFKeWJTYVRXdlQx?=
 =?utf-8?B?Z3BQRjhLMVZBVkgvVzF0aUptK0tkd1VVQlhYMDNvWlZXRWZYZThJclhiMXlr?=
 =?utf-8?B?eUFYaldITC9XMHNneldiNjB6cTdRcUhvVjFtZjF3NHA1T0t5UytKQ0JrdWVM?=
 =?utf-8?B?bVZoaWxtUWdHWHBXdDduZUxxeGdZc1R1LzFBMTg2Wnp3dTBkWDdtSUx5RENZ?=
 =?utf-8?B?aWdZS0NjdTFOUEFMZlRnbnF5Tml0ZWhlbTR6aDhPTmtvZkYyWHNYUHRXRUNJ?=
 =?utf-8?B?UDNJLzUwUzZDRGxaUzVNV0p0NndYQlNFKzNxZmY3MjFOdnh6NjhqcnZYNGxl?=
 =?utf-8?B?bHhPSWgwWWZGVVkxMmpTdWRvcmdibzlVcVV6UXBYbTd4SGV1cmR4cDdYMitX?=
 =?utf-8?B?aXBSY2ZUTGJJdUt2eVpmUDVzSnBZTmtMY2dXTW5pcjZmSC85Mkd6UUpNNWhs?=
 =?utf-8?B?NCtVNnpJYnVqRXI2QkxOQms3OHpIT2dCSExvK0FrbTdRUnVPRDMyVkZzdGpk?=
 =?utf-8?B?eGlybWZKVHBHTWdGVlZDaGRySFJYdU04c2h3SUJxcDhCbjltU1JTQTlaOWdi?=
 =?utf-8?B?b3JFZVJMWlNFbC9Sd3dOem92VjBQQy9USCtVYXFGVEEreTZZcVZldXl1SkRt?=
 =?utf-8?B?aHpCcFV1UXNDZFh2bDZ0T24vazhoUjhPbmNaK3lpRjY5SHdOaGROMUo2enNK?=
 =?utf-8?B?VkVQR05qcGpaMkpPZEhoT1pXRytuRVZiTXpTby9zY1hkZXVlMVZSNDM4VXVn?=
 =?utf-8?B?cGxwWGpoaXFCN2NXMS85RHN0aklPWHMzNy90bjV5MkovZlVyYytNK1JCd0lB?=
 =?utf-8?B?SkdnZUNJK1RqcjhveW5xcWxkRTdmaGEwdjFyQWdOSzZnTnFqNTZOM20xcWEy?=
 =?utf-8?B?VFVzdytMZ012TmI0SnlYTm13M1pBT3VlcVlWRnh2RjlITTRMbTZ1SmlvUk9u?=
 =?utf-8?B?dStxRzg1N3RXdkgrM2ZqUkUwa1IxbHB2eVlFb0ZIcVNtbjY3WExoZTZaMTdm?=
 =?utf-8?B?WSs0MG0vcHluWW83ZnBycTVidmNaZVRDMy9BU2VSSVc0aitRNVZBVGZsUkZR?=
 =?utf-8?B?T3AwelJoRXRsRHExVFRKT2RuenNrTEZIVHRNY1FudDUyU0ZIeUZSYVhleEdy?=
 =?utf-8?Q?RD9mnPlduFBuhS6dZ9D8r1wDj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f113872c-6e44-4805-fd45-08dac2f46685
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 08:20:17.6398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRdHeoXXHMNlzWSfVRnSHeo4l0yQhHlClDY0m49s/GUiJNnnp2hfK9y0XBY5oKsd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/11/2022 3:53, YueHaibing wrote:
> Smatch warns this:
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
>  mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.
> 
> Fix this by initializing ret with zero.
> 
> Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> index 31d443dd8386..44dea75dabde 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> @@ -46,7 +46,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
>  int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>  				 struct mlx5dr_action *action)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	if (action && action->action_type != DR_ACTION_TYP_FT)
>  		return -EOPNOTSUPP;


In this case the default should be an error
It will be better if ret init to -EOPNOTSUPP and if
a miss action was not set and replaces ret then goto out.

 int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
                                 struct mlx5dr_action *action)
 {
-       int ret;
+       int ret = -EOPNOTSUPP;
 
        if (action && action->action_type != DR_ACTION_TYP_FT)
                return -EOPNOTSUPP;
@@ -67,6 +67,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
                        goto out;
        }
 
+       if (ret)
+               goto out;
+

