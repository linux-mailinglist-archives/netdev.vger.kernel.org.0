Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94B6D7DB0
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbjDEN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbjDEN0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:26:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01F5BA5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 06:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680701163; x=1712237163;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qbAlzQ3zenxicNAVl3SG13a7UVMm/287+SiZyc9B4Ho=;
  b=OPET+0vN1VGfEgfcDWS10CUSajFFjHScSxBUsmIxDkmr+ZMnQj6lQqNo
   af0Aj6UmmR6wGFFlL43eet4+LdJum+2dhy2TJ4q9IKFAtqjAKw+efBxEg
   JJbiFls13iiNd+MF3FkJ8PfJ/O3LRfBqC6uIKwMW0muZj4SKZHGJW/G1G
   56Jrub9kfgZW/7cqNvPsFhUPsxlePhBK/22GbebbF6kAeTcYyQ9la8VIQ
   66kNmJt5w7MaKiX7PBHTLitpDvwTsLCz5zOR62AiLxhRd1Z4eB5aQldQB
   3ISwhz2Z8QnpMeqwQZEWqtnzNoj0owPg5oopR/+yWLXbJvJFRVLDr41D4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="344168534"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="344168534"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 06:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="810638795"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="810638795"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 06:26:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:26:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:26:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 06:26:01 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 06:26:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I18dsnGy91LfpGiKe+9RH1p8Vo93iHeXjtSRiyBL+FKSk1rHc3Iw17nwz2Z+6zqdCQqMtfc5lJeiuQm9qNzFoQ/ZhnJxjkqjr9MNKQHraL6elitm53Ttv6IWpLxE8TdHEAxCa9GrE6Xr5YXqoMj9V6nKjC1ML/VkGw3fqDw59ITvS/T7trB1QGWRd0LWQ+sHQChQb1NiqY+eRfWGV0vHVOKp1QlvIy+Vi9Bn+pvMyhSpY93nCTVe+4Nql6lXEGlw/AXE4E33bm0hgMTL7vN5KnPNdhD07EqMn/sHvBXkJrcBZ2sDgojcsHMf0AgdXHSXE5nyq+mNFDjmdQYmc+ObQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0m2VK15LuWoji4ZXvNXs/hvHWVfnb+XlNYTgyhD99m8=;
 b=X3lSoMpOFITfVYNgc4zdWlmMJaM9WdB8RbG+0wZLgl8LciwVaaYJY7v4rg/Mh77vr12MmadgmzWma8OiIAGIbFhUHCzIkbl+zokqORJgBD7nMOB1fcuXUuTL6rsyHG8OI2gpZYsdQGe4C8IY6QBCKyUsM0ms87PYHbP9lBaX+HkdYQ9Mz3tPwMntE4BTsPqV6EfFCWLzKUq5XIJMY20rxErp1NUHOi61vMI/PQkm9pkAIGaTbLQe4+uZth3CCgrag2MSkxivVy/KW3XvjzCTEv2TwV+4kGNessW+yJt9Q55oLhwe88MVO5MD9vM4i8SITsstV25mV2uPgkVENab81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN2PR11MB4709.namprd11.prod.outlook.com (2603:10b6:208:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 13:25:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 13:25:59 +0000
Message-ID: <68714dbe-3a43-9e3a-2bb5-8f1659b4a979@intel.com>
Date:   Wed, 5 Apr 2023 15:25:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 4/5] ice: specify field names in ice_prot_ext
 init
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <wojciech.drewek@intel.com>, <piotr.raczynski@intel.com>,
        <pmenzel@molgen.mpg.de>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
 <20230405075113.455662-5-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230405075113.455662-5-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN2PR11MB4709:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b980585-2a5a-4d58-a68c-08db35d94afa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdtNYSe5ixNYU39Glr4YqkxzxWKrOgvRFFoIxR/37ud/+u4+h0OopzXU7qSmH2ZyXeOvF3g+cop2xd4w2SJz4Yx8t35pdX0GMXh6xUxsJi0/s7wiMw5yWN+EMYCASxGYfOIsYJ/ofDkxIr2oKBWayPbM4MAhcMotZLbBAByVNhoYRfxSNgvGmUeXcT5T01CDAdfTPIzsdIWdCaNVLW+J8mrK4XR37l4s3bicsn3MKl5xHuFw61NULQyMAhpZn90f4IPNIAXMCgLuP45mh/fhpFOwnWSq7jFiC6B+0+kjQzp5evUm6pp3VFvTTo05loMAN5W0vflUFXubf9IGlyKmbrHjaPmV1X+381mujaxu826lbJENBFdBq7PJuBcRaPea2EcNWiM2uLs4kghlafY9OrMChowzBF6W+4SPgjz8eUpV+UmzWEUmlsvFzPmLcY+7bPlicOVA/EHOs+BOoaLVY3HhTwjosUbKQHVUQ0GCf2Z/0V+94gJpf4y4xRay/vd1586c5Nvez/3dhoRwpTRsO5qWPSd8u2ckH+XZ3EL18KNHGp56/56BTcah7C2mUqt8h4jtDNA8KCJZY3Rx7RDaBGc0EGzbxg3kr1kKGtSC6p7GNcXDS0/Fr5EKyVDwc0heQSAlURts/lmDX/BzRe2LPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(4326008)(478600001)(66556008)(8676002)(66476007)(66946007)(5660300002)(316002)(6916009)(8936002)(82960400001)(38100700002)(41300700001)(186003)(83380400001)(2616005)(6486002)(6506007)(6666004)(26005)(6512007)(86362001)(31696002)(2906002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjRWYm9zS0s4b0V4QnVDMENCOUIzaWVrcXNQSmU1eTg3MVJLaVo5YU54ZXRp?=
 =?utf-8?B?WHU0dW5rSVQ3VS9SN0VLVGRXbGNZSndITGpmOWFoMU5sUFFubTdFb1IzeVh5?=
 =?utf-8?B?aG9tQ3hURkxlTjlGK0NIa29zQm1OUEMxWWlSWkFrcyt0ajZmNmZnNTJxZnNU?=
 =?utf-8?B?SkgxcVBZUndwamRwVjJZMlhnTGhCODBGVHpIT1ZRUm42ZzZWelhoczdRQVRl?=
 =?utf-8?B?TWZHd0M3VnlDeHJ3ZkhCcDBrQkVhdk1ZdVBucmNhakZ4dGdhVzYyWGtUQnUv?=
 =?utf-8?B?L1dUL2J1L3RDVXRJbWZSL2srWjRCUmNkcm5UYkF0ZzZ6d3c1alR5aHVNalUy?=
 =?utf-8?B?Q01NMnExOFNzclhnbDk0aktETzE1SmhSTGJ0RXB4NkxCenNGam5TditiK3Bp?=
 =?utf-8?B?NGFrT1UrY3J0U3NEL3AyanlUNzRQUktuR3l2VFZESWptUjJqemhyeDhNSDc5?=
 =?utf-8?B?OURnL0pzQ0s5aGd0SUdDSmNpZHYrWTRKcWdkTi8rdWJlNjJMMXV5eElTOHBl?=
 =?utf-8?B?ZjZ2UGVvZmdiTmdweXFtZndWV1NIMkJseHhjL0FPY1RPbHFlblJodEhVWkpK?=
 =?utf-8?B?cmNPRlhzZU51SGl5N0ZTZHc2L2lXeHBnZWNibDBmYXRtS3VTellnVkd5Tm9s?=
 =?utf-8?B?c1ZxS3p2Mi9TcUZvV054R25lODZleWxWUEoyRWh0QmNIWHBpRGR4MGFPVlFQ?=
 =?utf-8?B?SkZUb3lHc21MQ05vUURwRlpnYVVZYTZUWjdRYTBkS2l4OVF1c1U3VksrOGZB?=
 =?utf-8?B?d0czdnFuRGpPMjhEb050T0gzOUNGdDY0SFZqQWpadzVlV09CcS9pVU1lUVR0?=
 =?utf-8?B?Sis1K01sN0R6ZDJkZ2ZrYWFCaHZ6MjRWNWVYYlloOW9hNFpaaDVZTnl6RHEz?=
 =?utf-8?B?a2VCQk0rTEpvSXRYcVYwWXRBdnlyUXZoMFkrbFVQRFIvM3N1NmRBRzRBbGw3?=
 =?utf-8?B?eW84ck9YcXNRcFNnZ0dxdVNkMDM5amtrL2xmK2JBTGVpQjQwSXlrWWhQMG5y?=
 =?utf-8?B?c1FVYUMrVTErYWtkNlVIUFVObXpRY2lySi9GRW8ycVYyc3JSZWV2alJyMWNh?=
 =?utf-8?B?d1QvYzZGZWRUeUZHNDlWUEZORk4yS2Z4QVVMckNDNGlhYmlJLzl0Rkx2V0VW?=
 =?utf-8?B?YThVcmgwUWMxTldPLzBnS0l5WWRpbXR2cGpLcDA0UTdyNTlqdnpCY0RVZmZo?=
 =?utf-8?B?UjAyRmZtSzRvRWg1RVRQcDZHUmdpNGFvSW13UnZxTFNCK1NmMnEveHZ6MnBB?=
 =?utf-8?B?TDBQdERNMGxNMkVCc1JrT05XaXhFRm5oTWlDSmFuWlk5aTBnMytQQjhjSkRK?=
 =?utf-8?B?WHdsRUZEL2NNMmw2RTNZOEhiV2h5MUdPdjlGUWZjUFNHbnIxK3J1ck8venpu?=
 =?utf-8?B?RGJLSDc5Yk5GcjIzdklGTnpqa01wRk5jVDA5enhpRkxUekNhNDhFNVFvOTI2?=
 =?utf-8?B?QnI0Y1g3YzQzMElsckZxYUNqd2REUS9WczI5NWhEVURXaGo4T2lBTldMWWxu?=
 =?utf-8?B?UDUraTBJWmNYSnRFbDBObzNlQ09BNDRjQlNGTXk4MmhpTVU1b2Zhd2w4RU9O?=
 =?utf-8?B?bDZISmRsWTFoRUF2eUoxSit1ZEticzJBNjhPTEJ3MVM2OEZTRFlmWFl2ZDZv?=
 =?utf-8?B?c0MyRWU4Nkkwcm1EZjZScldlTng5Y0dIaEMyQ2hQelBzdHBsd1hndGpRZHJV?=
 =?utf-8?B?Zi9TTWJLTHJLaHBueWFST2xPT1B2blVGUFhNV2hyR0NhR2JzaWRpUW5zZERl?=
 =?utf-8?B?bERmN052NVlIbkJUOEQzSG5SMmlUYmN3Q2p4VVVBWU9xcUcrQnFoM0J1bzlF?=
 =?utf-8?B?OFN1TGFRTzVtSXBkNytLNElOL2Z5ME1PS1pKbUgzVjVTbUpqRFMvMldVS2ly?=
 =?utf-8?B?WHZtb0wvbDJ3TXZ5eXZKWkZHbHUxWi9ndjVEcG9Hc21SSW5DeUZ3TllYeXlk?=
 =?utf-8?B?WUVjT0VjY2R1UTFYWkxGNmk1OTZjbmdRaEhyZUxZUDJMV0xrM08zQ0FiSFRJ?=
 =?utf-8?B?bEtxcnBxMGJ6VkRTTTBKYy9wcmdzb3dTNEkvSXFpdEZnQ2VHRldOL0FGTlN5?=
 =?utf-8?B?ZysvOWh0em1iaHBvbHdMT2s5b0dzcVVVUDBtVWxTMStSTzNYMGgvejlsRDdZ?=
 =?utf-8?B?enkvRCtlUUJZdjZXN1ZGM3lWUHd0NVIxNXUvWUhwNXBRWnd6S0RzM1VTbnhs?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b980585-2a5a-4d58-a68c-08db35d94afa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 13:25:58.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3SVueWlY65EThqNdV/ZqIn6edW8r0X/C3rzbGazwpxh4bXoQ2vBAlVBbZ2y4HywDIBl8X3dkafg9C16/aeCO+Vsztepat440N54tsqZywo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4709
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Wed, 5 Apr 2023 09:51:12 +0200

> Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
> macro to rewrite anonymous initializers to named one. No functional
> changes here.
> 
> Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 68 +++++++++++----------
>  1 file changed, 36 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> index b55cdb9a009f..8872e26d1368 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -4540,6 +4540,11 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
>  	return status;
>  }
>  
> +#define ICE_PROTOCOL_ENTRY(id, ...) {	\
> +	.prot_type = id,		\
> +	.offs	   = {__VA_ARGS__},	\

Minor: please use one tab in between field name and `=` sign (you have
spaces there for now).

> +}
> +
>  /* This is mapping table entry that maps every word within a given protocol
>   * structure to the real byte offset as per the specification of that
>   * protocol header.
> @@ -4550,38 +4555,37 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
>   * structure is added to that union.
>   */
>  static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
> -	{ ICE_MAC_OFOS,		{ 0, 2, 4, 6, 8, 10, 12 } },
> -	{ ICE_MAC_IL,		{ 0, 2, 4, 6, 8, 10, 12 } },
> -	{ ICE_ETYPE_OL,		{ 0 } },
> -	{ ICE_ETYPE_IL,		{ 0 } },
> -	{ ICE_VLAN_OFOS,	{ 2, 0 } },
> -	{ ICE_IPV4_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
> -	{ ICE_IPV4_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
> -	{ ICE_IPV6_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
> -				 26, 28, 30, 32, 34, 36, 38 } },
> -	{ ICE_IPV6_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
> -				 26, 28, 30, 32, 34, 36, 38 } },
> -	{ ICE_TCP_IL,		{ 0, 2 } },
> -	{ ICE_UDP_OF,		{ 0, 2 } },
> -	{ ICE_UDP_ILOS,		{ 0, 2 } },
> -	{ ICE_VXLAN,		{ 8, 10, 12, 14 } },
> -	{ ICE_GENEVE,		{ 8, 10, 12, 14 } },
> -	{ ICE_NVGRE,		{ 0, 2, 4, 6 } },
> -	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
> -	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
> -	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
> -	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
> -	{ ICE_VLAN_EX,          { 2, 0 } },
> -	{ ICE_VLAN_IN,          { 2, 0 } },
> -	{ ICE_HW_METADATA,	{ ICE_SOURCE_PORT_MDID_OFFSET,
> -				  ICE_PTYPE_MDID_OFFSET,
> -				  ICE_PACKET_LENGTH_MDID_OFFSET,
> -				  ICE_SOURCE_VSI_MDID_OFFSET,
> -				  ICE_PKT_VLAN_MDID_OFFSET,
> -				  ICE_PKT_TUNNEL_MDID_OFFSET,
> -				  ICE_PKT_TCP_MDID_OFFSET,
> -				  ICE_PKT_ERROR_MDID_OFFSET,
> -				}},
> +	ICE_PROTOCOL_ENTRY(ICE_MAC_OFOS, 0, 2, 4, 6, 8, 10, 12),
> +	ICE_PROTOCOL_ENTRY(ICE_MAC_IL, 0, 2, 4, 6, 8, 10, 12),
> +	ICE_PROTOCOL_ENTRY(ICE_ETYPE_OL, 0),
> +	ICE_PROTOCOL_ENTRY(ICE_ETYPE_IL, 0),

BTW, as offset arguments go into the array declaration, you can even
omit such single-zero-element declarations. I.e., if I'm not mistaken,
these two equal to just:

	ICE_PROTOCOL_ENTRY(ICE_ETYPE_OL),
	ICE_PROTOCOL_ENTRY(ICE_ETYPE_IL),

But: 1) better to recheck; 2) up to you, maybe it's better to explicitly
mention zero offsets here.

> +	ICE_PROTOCOL_ENTRY(ICE_VLAN_OFOS, 2, 0),
> +	ICE_PROTOCOL_ENTRY(ICE_IPV4_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
> +	ICE_PROTOCOL_ENTRY(ICE_IPV4_IL,	0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
> +	ICE_PROTOCOL_ENTRY(ICE_IPV6_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
> +			   20, 22, 24, 26, 28, 30, 32, 34, 36, 38),
> +	ICE_PROTOCOL_ENTRY(ICE_IPV6_IL, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
> +			   22, 24, 26, 28, 30, 32, 34, 36, 38),
> +	ICE_PROTOCOL_ENTRY(ICE_TCP_IL, 0, 2),
> +	ICE_PROTOCOL_ENTRY(ICE_UDP_OF, 0, 2),
> +	ICE_PROTOCOL_ENTRY(ICE_UDP_ILOS, 0, 2),
> +	ICE_PROTOCOL_ENTRY(ICE_VXLAN, 8, 10, 12, 14),
> +	ICE_PROTOCOL_ENTRY(ICE_GENEVE, 8, 10, 12, 14),
> +	ICE_PROTOCOL_ENTRY(ICE_NVGRE, 0, 2, 4, 6),
> +	ICE_PROTOCOL_ENTRY(ICE_GTP, 8, 10, 12, 14, 16, 18, 20, 22),
> +	ICE_PROTOCOL_ENTRY(ICE_GTP_NO_PAY, 8, 10, 12, 14),
> +	ICE_PROTOCOL_ENTRY(ICE_PPPOE, 0, 2, 4, 6),
> +	ICE_PROTOCOL_ENTRY(ICE_L2TPV3, 0, 2, 4, 6, 8, 10),
> +	ICE_PROTOCOL_ENTRY(ICE_VLAN_EX, 2, 0),
> +	ICE_PROTOCOL_ENTRY(ICE_VLAN_IN, 2, 0),
> +	ICE_PROTOCOL_ENTRY(ICE_HW_METADATA, ICE_SOURCE_PORT_MDID_OFFSET,

Nit: I think here's the exceptional case when you can specify this
second argument on the next line, i.e. break the line even though it
fits into 80 chars. This looks a bit off to me :D

> +			   ICE_PTYPE_MDID_OFFSET,
> +			   ICE_PACKET_LENGTH_MDID_OFFSET,
> +			   ICE_SOURCE_VSI_MDID_OFFSET,
> +			   ICE_PKT_VLAN_MDID_OFFSET,
> +			   ICE_PKT_TUNNEL_MDID_OFFSET,
> +			   ICE_PKT_TCP_MDID_OFFSET,
> +			   ICE_PKT_ERROR_MDID_OFFSET),

Hmm, could this patch go as 3/5, i.e. before this last element is
introduced, so that there'll be 16 lines less in diffstat?

>  };
>  
>  static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {

Thanks,
Olek
