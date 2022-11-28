Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E663B5D2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiK1X0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbiK1X0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:26:12 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE70DFBD
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669677971; x=1701213971;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AvTQ0ax5yZWZL/Fsr0mVzKxDKLAjQlseTWJ8LKTsMRg=;
  b=LqRGxuESbxNnvPhs0PjBpoxSGWNdfNJsqEy75+Q7tg1jjdNy31uwVx7s
   VLMk6pEvEb7Wj+kqZKmgezPlAlBmcNBggHixM2pH7wrbWzHPevxBcixig
   UgpiUJKKU6RpeagM5KFWLbAM7j0PtAcgiu5vLyL4sgoRPYqaXUK43Vnlj
   WsBLEsPjKxe+Qv6dHcupNeptE6NrZW+pYzGEgZkpDkkn+BrOZ9Njos/zn
   oCOTlTlt5Z6jYEsw+56VWj2eAUwd0d3pNONvgnR9iLGn7h0wSbSLkblHx
   n0I9pqpz9KAQE2S56+WzhuN9VbaGmfd9meKP2VFscXCA72Da4lY0Mpixl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377118540"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="377118540"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:26:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785822129"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785822129"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 15:26:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:26:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:26:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:26:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:26:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/hyH2X61C0DkqA4ml1pIGPYJZYpwaZ6ovP3Bqgxg4ELHKphp2oFC+QdRqc0i4UschWIQmVhM7pa2wUlMvIyUsXN2xO/vx9dTh3rkqT6/MAKDlNG1a2j87MbwfL2gqgAc6PxikXxES6COGJsfpBydUG+eNwy8SC2c0wVf4jwegMlyZjL8soA9504/2DV1NUOJFslPeJZI6ymmGuqdGJvgRzBcCKfbr5OzR7RBpAUhJXOD14qCuZdYtTcLenuCKyx0CO0wcX50G4/IzqHxvkZk4QwwQ0ljlujMCF72N7xyWo+IxhmwEmVCSo+TiFgj91YUQXRlNUTvMJtJT/e2a42Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fXruusGKaC4ucvBTxCUTB6qFAs7OxrGgpt3G6hqwjw=;
 b=Os8NTXPVwgDYaFZQFPHlgqs9rN7y9FqymBUZdYkyObVqxBgCxhyIhifHm/Qh1UCjtkPdtdBZ/2TxlPWUPNAUb+//DHnEazV43WpOY39xME5FkMNtqCeZ1EOINjZbXOXT7qOzk8mozfZoslKlQiBftUCbn17NZXKaYGsnBz61o/Oyq/jPNoimanBjknC+Ypp9lnSAkSrBujA5LDWOIYsinihwcFEDrcjYeNvhNUODrb8ihs0FbnDOXk02UxcuMwbLzLZjo9MxE3qnt7QZGmeJOFSfUj17txZlCKpjmSnMSDsb/d6BxXmud2jBi6WMRP9a/zPav3pXE1J3bN3t5ggNvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB6789.namprd11.prod.outlook.com (2603:10b6:a03:47f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:26:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:26:07 +0000
Message-ID: <2c518cf8-0c32-0052-ffc0-6b5d78b143e0@intel.com>
Date:   Mon, 28 Nov 2022 15:26:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 05/15] net/mlx5e: Fix use-after-free when reverting
 termination table
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-6-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-6-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9fcc60-2333-4be2-cc6d-08dad197ed20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCbtDK/0M8UYdkyak74T2QcO2u14gMPGDsEkH20UVlKr7AkL0LK3Z3ZtcIBrxXuLrxoEXddeBiClT26tLI+V6m3ela6rE9tYrb5FYPLbaD1MDJ0hnbKgwbmfyw8GC0UxEfnZx+NgNCjh3pn/u+8y2gy72kVej6FOJyfFZHzzaggr77wq18957MKo21qRMkjytZUM6B8XqxazjxeXKF4yCCy00QyGWXEy5V7Ml4Xarf9y6G4/2LkUjLSy/GaUYcdbeIuDZSUNRCMvHCIKZiCitSV+Y9dfZZe9DPI2ZP3f4BWQvhgmJe9nMnK85ede7wEqdM0kMraNUx+ZUhzi879I36DS3wH+lDcHhjc58hm1LUn1RvdIb3sgB5NgAaZN+aaoK0QerrfxwV8GHxnZl2T5aAZiUChcRrIctUSG1F766ApLWG6qRbgyodBhi4/WSm8a+OZpSFEC0BRJgX9BCTrViJZP9xlb6kxx+NKRqGYXSr6VTI73Rf/2HPBHF7hyEzd1Rtii8kSNiFxl0Ivl74VR0AtSDaXSYFS1peNHEYmxQl7hMWeSVpO8I1K+3NDPJQuJ/hllP645ICm1XOWETfo0rImEggak5o2vYiDYrMWNriku3GZxfY9H9X1M6QnBCuQIHdLYBpZ+0QlKu3h3VBoMxJqANdrJlrxtJrfV0yCYswBih/edtOjoBtF6nlxdXB8YuTRYvBIfWIzWWtMGcK5sJ2OK6IpJa50YpB4mZV30eMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(2616005)(31686004)(2906002)(6512007)(6506007)(38100700002)(41300700001)(8676002)(66946007)(66476007)(478600001)(6486002)(53546011)(36756003)(82960400001)(26005)(66556008)(186003)(5660300002)(8936002)(4326008)(86362001)(31696002)(316002)(110136005)(54906003)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1cxSVpSbHVUNTlEYitISnZ1Y1dKbUx0aXNTZ1lOcjJBdjVhdlIzakVUYVFj?=
 =?utf-8?B?MC9QUzJHNDhRYkhtQVBzdTlSVDZWYnl6MTZkbGxNZEt4QldkREdoS1dZakQ0?=
 =?utf-8?B?MUZMajN2bDFIOEtYMkFwQVVGZUViK2RMb2tpcmRqYTl1cHI2L3ZFcm9qb1dI?=
 =?utf-8?B?VHFqRmhyZE5PV2hjUjVxUWxYVERGNmRxbDZlYmpVdFRTVS9SZW5odFZsU2xD?=
 =?utf-8?B?Z2YvZitGSlJqSnJxZjhVRnNRRloyOXp1WG1NQnpQZy9sd2tWaVA0dUFTUUhW?=
 =?utf-8?B?Y3d6bUdoVVJOYmxZdEV3ZStnMmlPNklldEpXLzBHblZFSlJkaXRRYWU5eHNR?=
 =?utf-8?B?YjNWbDIvVm1RUWVBc2xMTXdyMXpqNDNYeWNlUW5QVHl6ZGZUTGwxblBSMXBS?=
 =?utf-8?B?dGxESmtaMXVCVFU0cmtnaHFmMGIrc2ZtdUZNekkvejdqSURWZkNob0wvWVdZ?=
 =?utf-8?B?ZW41em5OdHljZVQ1eitnQXZGSGYrR0YrQTRUZGhKYUZsN05XaGhSK2hSNXhr?=
 =?utf-8?B?K2JOeDZ3LzBxYzJQZ3ZQcHhUZTJpYjR1dmNJQVlTREhxRXZ3RGd2TDh1RUsv?=
 =?utf-8?B?M3BOL0RwenRIRDVRU2xTd0N6aWNHbGpaZGd4TlRjbitkR0RpelRUSTB6NzhO?=
 =?utf-8?B?STdLMnFVbTF1OUFkTGpYekVBcUFkY3F4anFaOGQzVjRsU09WTkZTaTdjQUNk?=
 =?utf-8?B?UEJ0SXppOTJsOGtJV2dXVldtaThUdTlNekpZOGNBTXFQSSs4OUlOUnFWa3BX?=
 =?utf-8?B?MXFFdzBJVWdxNUluNUczeDhEdzY2YXA3T2JYbEpFZVVCbXhmbVhkRGIvUUZJ?=
 =?utf-8?B?TW5kUjlhVHZBdFN1bzFDSlFtYkZsTytMQXNucnJZNnJjYU5TRVo2L1BKQVh3?=
 =?utf-8?B?eWZJZHo2V0hKZ1pDMi9ZRU5IY2NBRnJVbmoyekxDTkdRT0hxQVgrZ2tCdFJt?=
 =?utf-8?B?emVxYXE4ZjJ3ZmhrcDM4eGlOb2RscFFyV1VnYlU1cmNJVGNnYy93ZHZ0K3FR?=
 =?utf-8?B?SnFZK0w0a2cyQkpTMTRKWkVXTFNxdGJFUmI4OEVNTFpSb1p6LytBbUNVSlNm?=
 =?utf-8?B?SHNQLzJvZTZNQ3pyMjBpYndtT0MyWEx0OW5aSzhGTUZKeksrSFBlY1lwQVVr?=
 =?utf-8?B?MG95Mmdrb1NYSUlseE1KS0hDaWRHenoweGlYYXZvQ2JRbGduSlIvV3dNbSti?=
 =?utf-8?B?SjFHcGdhOU1ub2RFQzFSYUFnRUhZOG1pR1Z1VGdUOUlwYTYrdE9ZK1ZXRUdF?=
 =?utf-8?B?ZWNDR3Q4Mi9SbS9SQjFGbzRhTExqN2QyY21wZEUxQms4YmtZN0R5MlZnc0Z1?=
 =?utf-8?B?TGo1L29WYWcvcGdJRnc2V052ZVBHVmVVc2NaU2IvYWJLUktVTTIrNEtjV0xt?=
 =?utf-8?B?S0xydGdTcW4vMEpRT0lCRGN1cWdTUUVJb1RXSlNJdTFRT29OMzgxSzJXNDJ6?=
 =?utf-8?B?bjNHcm81TkVWZ3FjYmlaNXV4eWl0MkU1eXN6ZUlPaFBBUjFOa1JMWXgzR25U?=
 =?utf-8?B?Zk42dXRmVUY4WUNoK1c1Z3BrWHNGaWNaMjBKZEExV3dRSjFPQ0s5S0EwNlhL?=
 =?utf-8?B?QjJldmpWNFJ1eld2UllHa0VGY0cxek5wcjFUeis5d2NPZzJvVHdET0tWT2xE?=
 =?utf-8?B?eENqRzhhNlZkNExVdjl4OThDS0hvWHAwM05FdkdnQlg5MWJVZ2ZydTdrLzZ2?=
 =?utf-8?B?RGJGSk1TNjlkdDROSFVqcFg0SzB6UnZSZnMxK1hDOGVORDdDQzJINVk5empy?=
 =?utf-8?B?VUk1L0pXVVlUY0ZDK1NCWFdIWURvK1BFbW5CYU5EbkQwQ0FCZjNVeTZEb3JB?=
 =?utf-8?B?blJhOWY4a0JpU05MM2F0TDN0Vmp2VGtxMzd0V0VZZENQTlpyKy9zUU1uSGE5?=
 =?utf-8?B?WCs5QjdZOHlBRGF2Qlp0aDAwNkI3aXo0NlR2bm1oWFNCQlNoS1FzWHVQN2ky?=
 =?utf-8?B?cEdiQnY3QjEwVnBCSlJNRXNrTFdpVTZBSlo2NUxTMWFWaUdnQzFGUS9SNGtt?=
 =?utf-8?B?ejc5R1YyRlF0eTJHRys3dXpBWnpST2YwNVI3Y1hETHhUdWU3S1kwZ2F3cDVQ?=
 =?utf-8?B?cWNKMFJDT2pJMUxvN05rb2RqS2V3L2tuT2Q0YnhzMUxWYmhnYUduTG04MGlm?=
 =?utf-8?B?OGR0VUFIRkVTNW9XVG1zeGErV2pjOXIyVWZpNzlKbDIwTWU2UzE1UlAyMENR?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9fcc60-2333-4be2-cc6d-08dad197ed20
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:26:07.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRM9PVKXnN6V4SjdRrtA+KJU0Ub1oS+zWcv95fG16Ga9V32QiF6FirHvA1f82n7/IuQUt8cRl2DSbGFdp/Mv4HWQBA71uQ9F8w0xEuBJlH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6789
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> When having multiple dests with termination tables and second one
> or afterwards fails the driver reverts usage of term tables but
> doesn't reset the assignment in attr->dests[num_vport_dests].termtbl
> which case a use-after-free when releasing the rule.
> Fix by resetting the assignment of termtbl to null.
> 

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> index 108a3503f413..edd910258314 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> @@ -312,6 +312,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
>   	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
>   		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
>   
> +		attr->dests[curr_dest].termtbl = NULL;
> +
>   		/* search for the destination associated with the
>   		 * current term table
>   		 */
