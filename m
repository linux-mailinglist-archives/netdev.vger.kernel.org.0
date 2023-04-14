Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3986E2C86
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjDNWkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNWkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:40:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1094A49E1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681512051; x=1713048051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gs2GaGzYslQKCqXnwVxeiQA20yTgOF3D3GEhU2sSzEI=;
  b=j3ge99C0Z+3HweBOw8p3AVaGZDL5Dr3+ftFFKnx/P8Qotv5rHQ61dIhW
   qp3j2M1ghvkJ2iEpDPcJDaVNmceLYPfYoe7Ti3t3/n8/ARAQoroiwf++T
   JpJpIGB01Og0pSmLBITFJnX7bmjwK81QwdNUXdscp4YIhNuCWsMq9uTr3
   0N9QNqvV+FWsO88hC9NE59pk3lajvCKh3svU3kuPDeRl+uhdr+llKCNm9
   V7LCRA1MxEYsZcdM9gnzaAZ79D7dcR6eEYSfvt6JIRx4e0uInShrBJYRS
   z2oEfnHxvQg5vXFAA/Y4QjoEyLTVBTvK3XL9FBLhqmFaIzSmGjW2dMmyc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="342078556"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="342078556"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 15:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="689979753"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="689979753"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2023 15:40:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 15:40:49 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 15:40:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 15:40:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 15:40:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZAaEK0EujtAbtl5kY6wo2nikhlZlB2ntYPqW1V/RdwC0IYw476nGmf+ftcVPswolYKjgexs6AORdJMTchtNmKgTVouz/Z8nE1JlW0eTikh53E65leYtWExkB8GEYPo2hh9W/GpoosJ2OdxKr1Y1A4beYksDRGpUZmYrSKvhh1pwVO/UsxxVZCIHOX8nbbhv3xLk5hvYMfcN359E6RgrHzMxu1PeTDlK39zT225k9/AHprC7nkdJLwtjfnoNT5+sekz78VD7cJvx7ff+4O5dVqjkITsDh3JIVnz5v2k62FGCaQP2PgXf7ESOXll9o9b6b3KjTC2OyC5dnSMj6lu0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wgfXpBTIQMU8BJQDIoHEVezEDYLxPVIRSdQCooSq6Q=;
 b=YuTNsb/B9lT6fe5pMS5xywR4FA6uuEqPznYSF2Av/+x3kEYq6MCx7uapttmaWz7U/gmrwGkEkNRivyBbraZvgUe4CjaXC1b5IC8CZin36UbvJRzRDcNYvKGQVH92g7bng36oQ8eUXFDv3tvjzmxmjHc0ca9RzLd1zZwHhkc+L93WwQ7MqvPgYOZ8hz7OK9BWjrHI93OD9QZL3wLXgiW4/W9Tx+1gwdJrdSo6cLoKDdXmyvGQ26YgHdIByEHf+WyrPkZIsOE9TNmSD0d4N11Jm06iP5oDDB/VJD/0LzUdGz+XBf0aleGm9ybGy/lxSNMhZ2mKtE5gC8mi56WYgmkpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DM4PR11MB6019.namprd11.prod.outlook.com (2603:10b6:8:60::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Fri, 14 Apr 2023 22:40:44 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 22:40:44 +0000
Message-ID: <7815a749-f10a-ff5b-6050-6ca766a263b4@intel.com>
Date:   Fri, 14 Apr 2023 17:40:40 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v1 04/10] net/mlx5e: Prepare IPsec packet
 reformat code for tunnel mode
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0367.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::12) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DM4PR11MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: 98ecbbc2-051e-47ef-bf2e-08db3d394848
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCe1Jy4Y+HKUtq4VgjTX1il2k8ea50w13/74Ggkc+C3sH73jQlH2Yc3znP4f/IW1V/2ZAoHQsxolAimzVHOFDErW7Ch3ogEr4w/MWXN2DI/2R9Z3Pl+2bShd8MX8ePzMYiHaGpKqwpw1xkYtYQ7x/bdasDMAylKxnD7LgqMfNHyC1zbBHpY1lDTglEwb9mVBz5iGG6nGqxbCUNFa9SFEFT87WJEQF7qLzf9pMFycyF3kNB15NDGR/iyyynw692cQ9bnpvvGgMDMtcJlj6D6lrZsB5aAda4G2j2/xrmfj15XFhwV+OlOXht5Yos1D04xr9vRGPnD73IzrAMnzykcyJztnF197W9vS1jb6H82f1n48m6hK6TfJJjvGaKOwpsGFitcgRU4AyiB293XBayQKrQ99O9LSK9tyFsT2v8loNRuia0XOAbXIrHGCfpYKZxU3taK9ItAzx5lxHQxomi/PmH1dpqagO0A7xfBk69b510cEuyJLQYAnE35/Kh4SUKXUQnbR+WvLGSNOusscUSH5JYHuMiXSnZIwJWw0u7W5h3q/vXP6HLPRQM6+HDvIxXgn71B96NwCLI4p4f2Inrr/mmqALIDEKBTMPNb9yPNwpQFE2pj8jPbu4GDdPs7M9yll42YOiSrLHwFVZZgKc38zIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(31686004)(5660300002)(36756003)(7416002)(2906002)(38100700002)(316002)(8676002)(31696002)(86362001)(8936002)(41300700001)(66946007)(66556008)(82960400001)(66476007)(83380400001)(54906003)(2616005)(6506007)(110136005)(6512007)(26005)(478600001)(53546011)(186003)(6666004)(6486002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVBjMlhjZWZ5QUpzTkdXaHlqOHk0R1dlWElRYzcvZ3MzOXdtdkY2VDlpVjVU?=
 =?utf-8?B?NFRvTVAwZ2d6MjBqd1BaQy9HSzA2OXhHRkhqajNlY3I2emZIK2lZMWFreEN3?=
 =?utf-8?B?NSt2T0lWcmpZR0QySlAyZG1jVmdsSmZKU1BsQXY0ZFJKU2g3NHZpRzQ4ZC9N?=
 =?utf-8?B?NXovbVlteHNmNVhSL0Qrb0QybzRBYnh0R05yK05VcGlQMXlVU3dUQTI2SmFG?=
 =?utf-8?B?ZnFya0ZFamthRW41RENndGwvWC91aGtPeDYyWFdkdmthVmxLaHdKTUlPT2VC?=
 =?utf-8?B?OFpXdVJkdDZ2eGhIbk5aTC9uSFR1czN4Ty8vemZ0amFQblN1NU1zNkFvYlhL?=
 =?utf-8?B?MmNjeXpmSlMzanpGRFplZ05pbXE2dXpXQk1QTGxLWDlTenpyT3U5K3FGakdq?=
 =?utf-8?B?Y3FBTjRIaTR3c2JnVld5OGhNRkIvbjM5OXNSYjk5M01xdnJOK3Rxa0NPdXh5?=
 =?utf-8?B?WmhYdXhRLzNYS20yT3VuNC94MC83VFZENk5kUlk4dUNkSXNQcWdYcVVIY0Q1?=
 =?utf-8?B?VlNFRmhWRzk4ejhaTkVCUCsrRjlURFdISjFMdVRNSE9NNjcydHdoRTlxSlVo?=
 =?utf-8?B?ZjgxV0IyVkdRRGdkY3VLQjhpbEhZQWhSNzVBNVhJcG5LWm5lMkhHckRyaGhQ?=
 =?utf-8?B?SkZzaUJ0SmNQbFJyaHRGc083NnZRVEExUnRFM2hqYlhGeW5KQ0lMSHJ4MlBX?=
 =?utf-8?B?M2FnSGM2YnVFYzZmdjNNdUFYS01IUjVQSXpEbWZEY2xJdzV3VU5MMWJNT2o1?=
 =?utf-8?B?SGg1T1lKWFhpTmFGZFc5UisvZW5MbmZKckV5M2lPdUxmUjZldnBIWElQZGxw?=
 =?utf-8?B?ckhKN0owSHJrS3RiL0JpVTFPb1dIN25pcjBWUmozcWFPaDlBb2ZPOGRPK3E2?=
 =?utf-8?B?dWlFK0pyVkhzejBWUkZTZ3cvSUFaZFEvRklCV1grTkNiOTZHRXpLVzU5dlY1?=
 =?utf-8?B?UXo0N3RJRTREN2hveGZnUFJGeXQxdEJyZHBwRXFrVS9RSGZNSjFIdTRBVURz?=
 =?utf-8?B?MTVtYlNRTlNmbERjYnZZMkNJNXhFbm1mZC93R2ZBQ3ZxQ2h0a0I3bzF6eXM2?=
 =?utf-8?B?WmY5eE1QRVB1bHh6RTJuQXpBYUZyVTJFRmJBYkFJTUtXZ3NUcm4xQUFSRzda?=
 =?utf-8?B?UnRkNXlXVlEyUUJDOEgwa3p1d3hCNEpQME9yQnN3RTZzd3dJNjlxakMvdXQ1?=
 =?utf-8?B?dkNUdzFPOUlTY1JWWnRiL3hEWU1TR0NKZlMrQjFJdnRxcEZ6RWJjc2VSUFl5?=
 =?utf-8?B?Wit0bzdhQXZERnpXQzBaR01vNW50VmlmOTlFR0QzbWlaeTlSNElTb0V6TEZH?=
 =?utf-8?B?ZHBTSVl3R1l6dk5MTGJRRFN5aHBTUHN6dmNiNENWZFMvUVdiQ2MySEhBejBt?=
 =?utf-8?B?anc1Qlk2bXR3OXY4cmVIZEtpdVNjeFRIUTFvOVRqSFdBTUFDQjljSDBLb1lD?=
 =?utf-8?B?WlBZT1pZVnVYSzhDWFBpUFJvRUx4M0YzN0NodzlIT09EMW1qOGJ1UG9mUU41?=
 =?utf-8?B?NTVrZUVxTzFaenJYOVBQdkRDa2RoQTQ2TDNaN1ZiRHZDUC85SldyY2hGWUVC?=
 =?utf-8?B?ek9PazMvaHhvNE5nUlo4YnNFdDlYODZWeTUrQjdvbXRYWnpmbTh1Y3BlbGhh?=
 =?utf-8?B?MjVDV1B0b05CRllFYjFJNlArTDZON1lWS2NsaWplS1ZJeVdYVWl0WjRVejVK?=
 =?utf-8?B?T1IyS0wrd29YUGgwWjZ4SXdJS1JCaUoxWGFDbDZHZlplbUViODhrS3RNRDho?=
 =?utf-8?B?OW9wdnU0YkVaM2JzalVXTjYwRTF3QlBQVjFRcE90R0ZvNEVoRXpFUUUvc3RU?=
 =?utf-8?B?VTF0eUpXdDFUdDZHS1RsWDlrd3d0SWo0djFtbFIzNkxYWWxhc1ZaL0V0R3Nq?=
 =?utf-8?B?akJMS09VaThjTlhaMVdSdmo0YWlRamg1ME9rYU9KdkR0Nms2cElZQ21XV3R4?=
 =?utf-8?B?MFl0cG1VKzZHbkd5azZVWkpxNUNJWnVKTGpUYXBKK2lrc01TbUZGaVpSYncy?=
 =?utf-8?B?Sm1QR2ZuZ3dqM0ZtaDJXN2JSQVdwTEsycDE3NEhkK2N6VXp5UGttVkttM04v?=
 =?utf-8?B?a041RjR3WDVzV3F2TTVwNzIvbWVGSXVaMWJnOGtVMmRUNHR4eDNCalBTWXla?=
 =?utf-8?B?M2RCQ01mSnhIa3M3SnVzbE15bFJPY2lXamppKzhKT294TjVEcWlEKy8xV3FP?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ecbbc2-051e-47ef-bf2e-08db3d394848
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 22:40:44.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43F0V+9uNCL2ZvTxWFf+LtroWbQFyUU9WOmk13edPR+tUX0pYbWnjq7XrH4b/sq+iYKk/OhTklwbdD/BRi9JBt0gClx0E6izEsGIduxDvC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6019
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 7:29 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Refactor setup_pkt_reformat() function to accommodate future extension
> to support tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   .../mellanox/mlx5/core/en_accel/ipsec.c       |  1 +
>   .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
>   .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 81 ++++++++++++++-----
>   3 files changed, 63 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index def01bfde610..359da277c03a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -297,6 +297,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
>   	attrs->upspec.sport = ntohs(x->sel.sport);
>   	attrs->upspec.sport_mask = ntohs(x->sel.sport_mask);
>   	attrs->upspec.proto = x->sel.proto;
> +	attrs->mode = x->props.mode;
>   
>   	mlx5e_ipsec_init_limits(sa_entry, attrs);
>   }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> index bb89e18b17b4..ae525420a492 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> @@ -77,7 +77,7 @@ struct mlx5_replay_esn {
>   
>   struct mlx5_accel_esp_xfrm_attrs {
>   	u32   spi;
> -	u32   flags;
> +	u32   mode;
>   	struct aes_gcm_keymat aes_gcm;
>   
>   	union {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 060be020ca64..6a1ed4114054 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -10,6 +10,7 @@
>   #include "lib/fs_chains.h"
>   
>   #define NUM_IPSEC_FTE BIT(15)
> +#define MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE 16
>   
>   struct mlx5e_ipsec_fc {
>   	struct mlx5_fc *cnt;
> @@ -836,40 +837,80 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
>   	return 0;
>   }
>   
> +static int
> +setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
> +			     struct mlx5_pkt_reformat_params *reformat_params)
> +{
> +	u8 *reformatbf;
> +	__be32 spi;
> +
> +	switch (attrs->dir) {
> +	case XFRM_DEV_OFFLOAD_IN:
> +		reformat_params->type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
> +		break;
> +	case XFRM_DEV_OFFLOAD_OUT:
> +		if (attrs->family == AF_INET)
> +			reformat_params->type =
> +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> +		else
> +			reformat_params->type =
> +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;

Is it guaranteed that attrs->family will be either AF_INET or AF_INET6?
Later patches seem to indicate that this may not be true as they use
switch statement and includes default case


> +
> +		reformatbf = kzalloc(MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE,
> +				     GFP_KERNEL);
> +		if (!reformatbf)
> +			return -ENOMEM;
> +
> +		/* convert to network format */
> +		spi = htonl(attrs->spi);
> +		memcpy(reformatbf, &spi, sizeof(spi));
> +
> +		reformat_params->param_0 = attrs->authsize;
> +		reformat_params->size =
> +			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE;
> +		reformat_params->data = reformatbf;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>   static int setup_pkt_reformat(struct mlx5_core_dev *mdev,
>   			      struct mlx5_accel_esp_xfrm_attrs *attrs,
>   			      struct mlx5_flow_act *flow_act)
>   {
> -	enum mlx5_flow_namespace_type ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
>   	struct mlx5_pkt_reformat_params reformat_params = {};
>   	struct mlx5_pkt_reformat *pkt_reformat;
> -	u8 reformatbf[16] = {};
> -	__be32 spi;
> +	enum mlx5_flow_namespace_type ns_type;
> +	int ret;
>   
> -	if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
> -		reformat_params.type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
> +	switch (attrs->dir) {
> +	case XFRM_DEV_OFFLOAD_IN:
>   		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
> -		goto cmd;
> +		break;
> +	case XFRM_DEV_OFFLOAD_OUT:
> +		ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
> +		break;
> +	default:
> +		return -EINVAL;
>   	}
>   
> -	if (attrs->family == AF_INET)
> -		reformat_params.type =
> -			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> -	else
> -		reformat_params.type =
> -			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;

same here

> -
> -	/* convert to network format */
> -	spi = htonl(attrs->spi);
> -	memcpy(reformatbf, &spi, 4);
> +	switch (attrs->mode) {
> +	case XFRM_MODE_TRANSPORT:
> +		ret = setup_pkt_transport_reformat(attrs, &reformat_params);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
>   
> -	reformat_params.param_0 = attrs->authsize;
> -	reformat_params.size = sizeof(reformatbf);
> -	reformat_params.data = &reformatbf;
> +	if (ret)
> +		return ret;
>   
> -cmd:
>   	pkt_reformat =
>   		mlx5_packet_reformat_alloc(mdev, &reformat_params, ns_type);
> +	kfree(reformat_params.data);
>   	if (IS_ERR(pkt_reformat))
>   		return PTR_ERR(pkt_reformat);
>   
