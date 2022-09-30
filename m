Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59F55F0770
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiI3JUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiI3JUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:20:50 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A4AC45B8;
        Fri, 30 Sep 2022 02:20:46 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKjU8Q029821;
        Fri, 30 Sep 2022 02:20:09 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jw1rt66f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 02:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3LRIe3ESAnEmeGeUcUikzZ81+YhCNV5h5wYsSWebbHSKWCB8tNsdTTf3qLXKkXBSo7J+w8LyQT6t8UTvKoMFdslzUacyEoNO0jz7JEe2xggRGnl1mBYLNSSy/zp8D2pTxhxpfSJaD+GClfb0cLo/G6vW3rg838Jz2sYvESRFbDJ7HGZD9rSMQ4CaHs/GInEshmJbmzeUDgw+KJtq00gfOmEzkZ6ScRk6ZBO6Utj+PbVvbfHj1WuDStrD3RMS94wjevnENEYIAK7p0vV9ElnFkJu35J14tnxzDPtwKKXaMTwzCK5tkPdNWGpiHTqhbSl4+k7z9CusKazIK1TmdiRNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RtiKKyal3vlyRz91CAFZgMD3G4zaxjFwmRfQGMUmQo=;
 b=cJ9BMMkIx8nVa2ZM8sioPpWTb6TLLWeJv45+v3qlblKqo9emxNtk3hermhYV9wj5C1exIxJuvVijZwW2x0SBBwPFR7b46hKT7GhyhiiKF5YlP94SAfFiFZ1x6djJBPGrYIW4voQsEPIlzrEIluI/XGXeKmrpV4J8SCWUUGDOK7FYkvPsBR1yzzy6RYPeMSsYTSf3q7jkN51j4/m5v1jteNwAuPh/ConiGo+oxeFMZOfPdFDGoJgjWUv1D/1I63gPoDGJFOEnqTX27eqS38E791nhegp5s295IuQ/FEy5SXXu7JENJAPiaM3VkBanqzBFqoD7VkSc86aan5RhyS80pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RtiKKyal3vlyRz91CAFZgMD3G4zaxjFwmRfQGMUmQo=;
 b=iq3+NWAgAbztgondqYyrmCmz4oEFcFvxx49Ejh4WlI5BcmXZSFCcDaoAOm1xmZ8pnUvC/77K7d5y8J0tw2IIs1XdX3HG3KJ5Zu7b64sXfuw3Is9bE/PcfVLgfwJf8IKwv2A7liA3UeWcLQkhKRpVG2dOfynpKvCIK4Af3TTq7ZY=
Received: from CO6PR18MB4083.namprd18.prod.outlook.com (2603:10b6:5:348::9) by
 CH0PR18MB4307.namprd18.prod.outlook.com (2603:10b6:610:d2::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Fri, 30 Sep 2022 09:20:07 +0000
Received: from CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::4382:f7e5:c6aa:521c]) by CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::4382:f7e5:c6aa:521c%5]) with mapi id 15.20.5676.022; Fri, 30 Sep 2022
 09:20:07 +0000
Message-ID: <ac5b9485-c9cb-9458-1101-6a219ee1faa5@marvell.com>
Date:   Fri, 30 Sep 2022 12:20:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, vmytnyk@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220930044843.32647-1-jiasheng@iscas.ac.cn>
From:   Taras Chornyi <tchornyi@marvell.com>
In-Reply-To: <20220930044843.32647-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0134.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::18) To CO6PR18MB4083.namprd18.prod.outlook.com
 (2603:10b6:5:348::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR18MB4083:EE_|CH0PR18MB4307:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d37027-8809-4fea-b820-08daa2c4f6e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWM+9Y8Gt26JsVQ9OWGDSfjGkaEzhh11tt1Hy9qHF0r8hvhS5RUiftWgok5pKtBMQmpGLiTcg/YY71+FkmNNaDfROqnYT5mgcKMNdp1gM14ledWrzMxP0wIYbHnxK/uy7d1GaJM40PkF/4y2aLS62o6yTzbawr1oee8hq3xPh/RZ1jbSbd8BgDX70oRBVcWnxjwJEisY3By724dxoCOx5u+8PgkTy4xh/EeksjocgPAN3O4hyf8pqXOnhg+1kApjRl1P9raNt7k2fbtTjj9PaX1vlBXcG55TFMbpnyJjoN0NwdKTL8I5aXHSUuunS4y7FJ1lPNCXgQU/eroOBjsbEAiMz5DjfHWQEUOaxiQC7/U87dS5aoeMl1tfDj58FEXRVsSvwBm0Ss0a75rFI7SuA40t1d4yGSeNQghxtnowCGfGjNvAlCqLDGGMI1y0/Lr3ka5ig+gaCIGplQQDHz8UZIpbXO0yqJVWKD/Gaq5s9X72eDqS5bF1A2x5+UTBsbnroL1es0k5hwhh7RoKQZc44RGabLmivBKDNnqeOZ/NKmScO2dq6U2Lpbw77RiSHVxgQ+NO2/eoeKSqWRVpT3GyQddXz6MNdWFc8/qZzDWqeLURuOtqldUy5XZ93OMmi0xn6F4MEHpl06Zz9lVESKHSXAYZzvI2MC8nTu/zVlt8HZMSarEPX2p53SwlgnZ6F+HO7u1RmpxjdUk7EgTGGa1WpZd5LBnDceojLYPqVeOjk+pyb8AiFPnUll10c8TmuE/CMmmbv93UXGRPELiCtvibVr/1l+m5TUoKV5ShbL2o2+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4083.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(31686004)(2906002)(38100700002)(6512007)(5660300002)(186003)(86362001)(83380400001)(8936002)(6506007)(2616005)(31696002)(26005)(41300700001)(66556008)(8676002)(66946007)(6666004)(66476007)(4326008)(36756003)(316002)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjI3MGR1Y2tJZ1g3NDJJTHNpdi9DUkpoMjZSbWpqUmZrWTBTS1NIZWxjbDRC?=
 =?utf-8?B?S0E0NU9QaDErbS9CZDNZOUVmSlZCd1kwMGxkZDZ2dHZUQnhacElUWlhCb2dV?=
 =?utf-8?B?SVhlWmUrdHBVQnpLd3RRZ1FackxPSVBHb2F3eldmUUcwMDFocS9vR2oyWGZY?=
 =?utf-8?B?andwVmlHRHUyRjNtSDRwdWp2Z1cyY0NUR1lYWUdHN1VPM0xXOWwzaDBsT0E3?=
 =?utf-8?B?ZkIvREdhallsK3QvNFhmWHRkNE1xMmkrTHNHYzU1THU1dkV0VGJtV01RNnUy?=
 =?utf-8?B?cll6TG5ndmJ5Y2ZDa0pmbWN0eGl4TmpKTkc3Tmhvc3dnNUNEVEhsWkRjQy8r?=
 =?utf-8?B?OWgxaVRDNG1GTXk0TFJVaG84QjVPeFFsYnRPUUpuZ0R5NHBFU0YvMVF2VVc0?=
 =?utf-8?B?YjVaSjFHZVpxZ0huVDJOUEhSN0Q5b3krSGZxOEk2WVNqMEpTRjFkczRVNWY2?=
 =?utf-8?B?b0RBU3MrVDRyZXFoQm5ub0IyWVlEcU9aMDZZTHRadWd5T0xtZjhiSElRZUt5?=
 =?utf-8?B?TVJyMWVJZG96OWFpZGxJdW9VZXhwM3FMVmMrRmZwS3NQMkgvK3VScGRNYnFn?=
 =?utf-8?B?RVRSdW5aUk52Z1RFeXB0V0JuZnF5dlBBcnFWd1lZenhmNWZtOFQrYjZXbEM3?=
 =?utf-8?B?YXBhamxONUFuN1kxMmdrRkFEUjR6YmVNVXdOMjBMcWVlUWFKd3V3SytnR3F2?=
 =?utf-8?B?eXRoZTN1K2R6WURYeE8vZ0ljZTZLRjB0RDJ0dVJ2U1RxNStXSWdVdHBobUx0?=
 =?utf-8?B?WmR1Nkp5ZjRoSXVDUlkxb09Wb0JCbGYzTDc3ZzVNaTBYY2dCbWE4ZHJXdFpi?=
 =?utf-8?B?Rkk5eHBXeTJaMlBoVmcvVjk5UzhHZnB6N0RkUWx5V3g3MGJaN3NpRFRWMTEr?=
 =?utf-8?B?cjRhVzhXdlJPTjR6OWIwOFpqL1JCOW9lTkxlbkxyazdsUWxkN1ZKVk1zQmZQ?=
 =?utf-8?B?WkdJSXRaQTNSTGpTdjVROFVmYVBsVlVqMWdlNnZuK09DNXA0ZVY1cGNGY2dK?=
 =?utf-8?B?VUJaV3pISWhNRGtCcGxpSkpZcnUzTmhNc3lVZjQwdU9ENU16WGpGcXM2dU5m?=
 =?utf-8?B?aWFVdmN2WHN6TWRXZ0o5RUNweStodUgrbVFRbkd1WlJKZVZDVmJtQU9FYWlr?=
 =?utf-8?B?MTNDK1YyY1kwb25qdE1Qdnc4TEZFTmFtTU9pczl3OC9qc05TaTNPVXJ6OVhJ?=
 =?utf-8?B?cWVEelhjV1RBNUcybzFzNDIyNnU0QkFvV0xDOTZYT1FkMU9CYzhCd0pCNzdU?=
 =?utf-8?B?VkVPUWxOYk5WU1ZRYVVLdENUeStLZS9kSlFkTlhlZHdWSGFLV1B6YjBTVmh6?=
 =?utf-8?B?M3FPNTE5TVhJcXp1MkR5Ui9ZZy9ZdW1hSE5sdzNpVFRsZHByZUsyNVlWL25t?=
 =?utf-8?B?WjBEWUgrZEJjWmd2WWNhWDNGenFpWGhpL1huY2M3NmZGODJKcWVIZmxlUHRY?=
 =?utf-8?B?bkJlaGwrY3VOMmptL29OU2plQWlmcHdDaE40U1pRSlQ4OEs4a1p6eTVlOHV0?=
 =?utf-8?B?djlZOFcxeXdFMFBFQUU5Uk1TNVFQakpCajZ4NDRxd0U3Z1kveXh5ZmRQSHk4?=
 =?utf-8?B?MVBNVVN2TUtaUGx6UFVVSnVRMGprNlZOYTVlSnA0bUtqVEVxV2xad3NTc1dF?=
 =?utf-8?B?aVpGdmQ3N25xeE04czkyQWZBczRDNHI1OE5VaHRHdjkweUgyOHpCeWVseWVy?=
 =?utf-8?B?WWswckQ4Wm0rZWkrWjkrR21sVGZqQWx3OW1yamtQcDBSaUpoZE52c0UwN2Fz?=
 =?utf-8?B?TUZoOU40K1lsTi9PaEU5UVc4RCs2VXprdEx2UGYwa1grcS80djB5bXpZd05w?=
 =?utf-8?B?c1UwQkt2RWtmV2pyK2NGRG01Y0gvQTNNeUxzQXM1eC9HbHBHVlV0NlBQQ1RV?=
 =?utf-8?B?UTVUZXpYdVpDZk5qR2hCYXczZ1hRRmg0ZnFaa0x1eDg2NGVFUURLMWFpVzBX?=
 =?utf-8?B?enZmTUZMRDhqRTZ3b3hyYTlLOC9oODhtU2x4ald4Mjl6STlYMTc0cUhNMWcx?=
 =?utf-8?B?dEp0NDRHbDN6ZDgrbHlzLytVNVNjREJJVXo0RDF5ZTBjQVFJOXhvSExqVUZa?=
 =?utf-8?B?ZWlvUTVzeTdZa2RNck93eThCcHBjOXMyckpsWHFXWGJrK0xUQjJxQ0lkWG9x?=
 =?utf-8?Q?6ReqlH/cREAMdSyHswQSu8tKe?=
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d37027-8809-4fea-b820-08daa2c4f6e2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4083.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 09:20:06.8982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH4Ejf56UFlQfPsBuqKHLb9qSTUte8y4QsAoEYuT10Rq9/aktEwe7qxR/GaDY8MdQ8/EgTYK7rtsIlYbEdbEOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB4307
X-Proofpoint-GUID: Cs_1H8WYYWPwW87CqtF8RlhM5PlnlE8w
X-Proofpoint-ORIG-GUID: Cs_1H8WYYWPwW87CqtF8RlhM5PlnlE8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> ----------------------------------------------------------------------
> As the kemdup could return NULL, it should be better to check the return
> value and return error if fails.
> Moreover, the return value of prestera_acl_ruleset_keymask_set() should
> be checked by cascade.
>
> Fixes: 604ba230902d ("net: prestera: flower template support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>   drivers/net/ethernet/marvell/prestera/prestera_acl.c    | 8 ++++++--
>   drivers/net/ethernet/marvell/prestera/prestera_acl.h    | 4 ++--
>   drivers/net/ethernet/marvell/prestera/prestera_flower.c | 6 +++++-
>   3 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> index 3d4b85f2d541..f6b2933859d0 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> @@ -178,10 +178,14 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
>   	return ERR_PTR(err);
>   }
>   
> -void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
> -				      void *keymask)
> +int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
> +				     void *keymask)
>   {
>   	ruleset->keymask = kmemdup(keymask, ACL_KEYMASK_SIZE, GFP_KERNEL);
> +	if (!ruleset->keymask)
> +		return -ENOMEM;
> +
> +	return 0;
>   }
>   
>   int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> index 03fc5b9dc925..131bfbc87cd7 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> @@ -185,8 +185,8 @@ struct prestera_acl_ruleset *
>   prestera_acl_ruleset_lookup(struct prestera_acl *acl,
>   			    struct prestera_flow_block *block,
>   			    u32 chain_index);
> -void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
> -				      void *keymask);
> +int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
> +				     void *keymask);
>   bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
>   int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset);
>   void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> index 19d3b55c578e..cf551a8379ac 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> @@ -452,7 +452,9 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
>   	}
>   
>   	/* preserve keymask/template to this ruleset */
> -	prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
> +	err = prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
> +	if (err)
> +		goto err_ruleset_keymask_set;
>   
>   	/* skip error, as it is not possible to reject template operation,
>   	 * so, keep the reference to the ruleset for rules to be added
> @@ -468,6 +470,8 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
>   	list_add_rcu(&template->list, &block->template_list);
>   	return 0;
>   
> +err_ruleset_keymask_set:
> +	prestera_acl_ruleset_put(ruleset);
>   err_ruleset_get:
>   	kfree(template);
>   err_malloc:

Reviewed-by: Taras Chornyi<tchornyi@marvell.com>

