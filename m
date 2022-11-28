Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6E63B607
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiK1Xi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiK1XiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:38:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C87817073
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678694; x=1701214694;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LH3ik7SuIgMTKbazyiUq8SD9RSrN+9ZEjZkxxO0tBos=;
  b=AjW/0KOTpM4h0jQf+hbvqlmNqPaJIAzOVqfm80ivVEtWJxu8XnUPUPZK
   N8McO6wTQ0csLkGtnh1VNOVVziMOL5FfppbZFs2Zp0X0TT+tKImNj8WNr
   409+YeQtbXHPFt4Jhe2hOoTR96goiRxx1stQaZ3bcVHS1WXgFAKeLU2uc
   NJvtwSF1JBbfswZzAfwy/bZfgwaLiSIGA00a9q7BQ0AB1sKUr4kjvRc3M
   W7VkhBMoLkG1xgM3hge2aW93uwFzxQZ0v8wUKfcubin2z3tAORRXBsA80
   iiDZp/3uQx1134Fi1l7SMXdqu14j+ftUVaXHlra6p+LNmQP9R531vGmlo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379235910"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379235910"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:38:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="712155787"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="712155787"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 28 Nov 2022 15:38:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:38:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:38:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:38:08 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:38:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FM47lCgC+u6+Au7ssYR/kcS64JKadKTQtYZxwX61MtB6cX22VLNzkrHG1Mweo1ZrsoU+gRIDojFikY9k+GHU/FkDbRMjlfg4fqyxI8cIGVHtBnznnmSxx5RPZbevSrJdLzAXCXqH8705WWbLbohA5jdBU1WGscMc3KIQwSgpHqpFgY+hr6fbcTnkJsxcSWzKIgs0d+20WaNXWI6yJA8YPLQKzloXzzNsAAl/imQL+10xOXhAFrCgXEdnkcb+ZybgmHCVvLYf14RRbIqxG2F4Hatw8OSGwOgTkMFny/nZHu5XeWpcykreJKSCdeIRgaNkC4rgaKaHCM+xlcJBfessRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qwarwvw5V6/N23+004tOQy70I8+fj44+MomY8hvF9HA=;
 b=A8D36L8hmvjtDRoZC9m6ynEUNDVk337fV0tPHBx+3L2QEMKSJeCn+enFEnyOPZiVjWRidj65cu1saR95ZNhZrMv4eB67oDsMp/zbcUN2JjwjBc4lzYAOUBDh23s9KMiu4vzbWZWwoknDxFVkolhFZP4x1sQD7pUMTj/SS+tNRbmmaAf4MI9VHFn7+y3UVTnyowkg4xmltXe3vrgi7oh2sxkS5sbdO5jLYE8ocopYnPo7joNZsZWWv13YdW7GLxelb1bdvWi4gExz0N5gAEqprusR+vrqhZjeJniRhPpj1ToPBrmtcB4SmdpZjPP8iglC83lAsoZXOMVflBJFJmQhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:38:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:38:01 +0000
Message-ID: <7697529c-b545-42b7-d793-fca51d2d666e@intel.com>
Date:   Mon, 28 Nov 2022 15:37:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 12/15] net/mlx5e: MACsec, fix add Rx security association
 (SA) rule memory leak
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-13-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-13-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a77bb89-cd9a-473a-2a73-08dad1999667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGOeNODXBO48Cn712GeocVs1nNi1helHgcdT0g+QJZUaxUI4HeyxlMeo/ijEOHdd6vZ7yc4Zz4fOX3N2rkyBCI7/2BkaqDFy+wUbve6wNxCVHM0RXAKEi/vMcg+MWDuHDeh0fiHeeyeq9xMwPbYZhPxauIoeD9J0rnZnAEoW014xoTM6ayUutvI2yDrspHgZ9V4HIAIqarZTVn30WcyQuRuA0FBAeD1Ga0CsKgwyQ+RkReGVg8UcNWygnZH5SrKa5U7Ch1G9Baqj1UwVYbtxNFpn7YLlpHF4CLGqU8GbTrvmHR7Tne1FGWGAbP4ERodrqu2nc9gj6GrNyGESIznkIjemXKOldINHoU5NkmUbOhtMw84RbZ4wwZtclK5228zmCurRbFp8JqP9KkGdE9fPKMSc5rvC02KcSUOqB+36FAcYs8ng0IxrmWRWoJkvvGt5fMyPbRsWun+gHg+S0W85TyUk0Hmh53k5jbfT0pFjqyEflCKbs/8rtxlYvJDW4qREiZ8k1YafrSRlK4GqV6awOuuiE7Ry7iG0zPKecTOuA9lx+o0z28uunUBas5GcBSpLdPTx7SUxGOAU8A2ZP+xUrK/khjuElbYJUxniF2W6nWJl+ewJ29a1s8AmODTQfdoNvKQXH0ShHHW8cum00QPXgdqDJs4p+NE68DiiCjhr9d77RVkaV6fbmxx2n8aQfIfl9c8q30OkF9//E5VeDkOZDHlndr7Pratzo2K4ABbk+Ww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(2616005)(82960400001)(38100700002)(26005)(6512007)(7416002)(36756003)(110136005)(54906003)(2906002)(5660300002)(186003)(31696002)(53546011)(478600001)(86362001)(6486002)(6506007)(66556008)(41300700001)(66476007)(66946007)(4326008)(8676002)(31686004)(8936002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amVWRHpTRllrbUdBazlnWTVBUkg1cXBPNFFVN3BuN09EUDI2SGhab3RpNk9j?=
 =?utf-8?B?SnhIUW5HS0xUZDA5RnM2VzdmZGVvaDlIQkYxTCs0L2RKT2RQRHJqQ2ZPZlhW?=
 =?utf-8?B?dzl4Mm1yQml2ekRTREhRems4ZzNxMGRVaDZldnNqWENCUzhna0JLWUpkVUJs?=
 =?utf-8?B?S3UzUmFxT1pvYlVyWkl6SUk4S09MQ1JtNndJZDFxb0YzRldCSTVuY09QU3Mz?=
 =?utf-8?B?TXJ3aS91VEQzdk04YmZQZ0duVG9PN0YrTHkvTHN5NDRXRFBKZ0dFelZqV0xJ?=
 =?utf-8?B?WVEyVVBNcUdRZ2oxVzZzRDZTVWMrYko5OTd6SDBjeVhCc0xNUGVmZjJibTVv?=
 =?utf-8?B?OW5XbFR1NDdNWi9xWjE4OHpQdVRnYlBCT2hmUVdvMmovQ2x0Mk5SVUVnSzBD?=
 =?utf-8?B?MjRjV0IrNkxvekJLdlhLQngvR0N5bHJMMFBvTERYVFpoNE8wQUxObnJLbXlL?=
 =?utf-8?B?TkN1NGdwankrOG9jSEhxc3ZVSy9iUXJQZi9nTHlsa2IxZHpEcWwrNTJWRGhR?=
 =?utf-8?B?TUVNNFd2ZTYzaFhUVkRFekpIWkVDQlpNWG9Pc1E3NzFzTXBDTjFSSVhzQVpx?=
 =?utf-8?B?WEFmT0tQcjB5RjBYNUw1cHZZREhXS2llZFIrdEVTMGRRbDR0dldqdFhtUVdU?=
 =?utf-8?B?WDRZeDFuWDNwdSt0YXMwQkdtK0tUYmRpN3dsMmhmK1ZwYS9ubGNCMmZvL2Ri?=
 =?utf-8?B?RDBhKzB0UUphN3FkeVgzTjFMSEMrUk5WKzFhWnVkV3YwZXJIR20waDRHUzZj?=
 =?utf-8?B?NUZVZlR6NDJLc3ZDRmpxalNlUlM3OWh2ZXV6blBaZ1dncFVpWG5WN1NncDU0?=
 =?utf-8?B?NWlqODBPWStMWjNwdlJpME82ZG11UGxqWmc4K0QwamltemhEYzRBTk56R1JP?=
 =?utf-8?B?Z2F3RWg1SnRObE5IT0xuclpPQjBsU3lUemxST1RXdGpFNHZKRUdVNk53RDZT?=
 =?utf-8?B?eE81VVhSUVJSL0E5SFVhcENpNlBaUzAwa3pyMHRDNjRDcURQKzBvUXZTa0VB?=
 =?utf-8?B?MXpUSHpTS2lhMkxQK20raFJzRms5QUQvZmF6RUpFUW8wY3ExdFRwdDBHcEdG?=
 =?utf-8?B?VDBZVWQ2S1p5SUt6eFQybGorV3h0S0ZJb2I4V2ZESy9HLzhoZFZLNnAyb3dW?=
 =?utf-8?B?RlVTYUVHNUM4bmFnTDNkOUxWK3dCenNmeHdSVCtPYkNiNGJTQ052MUxITU4x?=
 =?utf-8?B?TGoxTFVMaWtCTk5WTytyS1kybzRoRFZNZ25DQ21lYVJ6bmFONndXTUNIcm1v?=
 =?utf-8?B?a3hnTU82b3N4YzNsYnVyaitMWUVNUVhxQm1FZmNuWGdPVFJNNnNyd2tsVnBU?=
 =?utf-8?B?ZkhoNTNyak1vK3drVGhLNis2TjZOQ3RCbTJ4UnFNNnFBMEJaT0hkVU9OVzVr?=
 =?utf-8?B?ZW8vUjdVTS9PMjF0RXNwbUloK2VSZUxZS2VWMXR2cG1hQ2hhUlpDRTdDdkpB?=
 =?utf-8?B?MVBYM0xLTmcvZGEzZjhKTDI1Y01aTGhBRFFodXoybWd3bllORTF3d2hqbTdL?=
 =?utf-8?B?S0srMlBqNmVRK2c0ZVJFUEU5SG1SRDJqZk9xYUVjOFV6Wm91R1RTck4rQnRE?=
 =?utf-8?B?dGdrdGx4N2U4c2hQMmEyWVR4ZHJlNnNNUzZyeFdHUHI2ZXFDSWNZMG5ac0hz?=
 =?utf-8?B?RkkxVXA3Z25MMnFEcEExejQzSC9lMnlja2pxY0w4aStzSkFCRU1UMFR2eTd3?=
 =?utf-8?B?Tkx4dzJpWkNqb3FheklEM1cyWlZwZGNGZ0p5QmhkYmlDNks4dnNGc2pGeHRE?=
 =?utf-8?B?R3hRZGZ5RUpFT2FLRlNLQ04yTEdUcFdMOUR0Q3I2czBzcEZiNU1od1VsVUdo?=
 =?utf-8?B?aVZmaFVvRERiMUx4QVowWFZJY1dnVk1rZHZqNUlPVnYxZDY2QTlpbW94SXBH?=
 =?utf-8?B?eU91V0Y2eUMyU2ZxM0tXMHJsekkxcFI1U0dFeXVGQTZWNlhjcnlEWkNjRE1O?=
 =?utf-8?B?WTBOTTVZV0hXWlIxNjRXQ0RCa3FnY0h2ZHZPVlgzRlc1NmNtazdaLzMvSnpQ?=
 =?utf-8?B?WWJQMFNHSjdxTHlYYWM4ZDNIT1dBbjZGNXBQRk9Lb3RYQzVGL2E1UjZmWUpi?=
 =?utf-8?B?ei9CODJIaDRzbFBzRmo4b3JiQ1pkazQ4REdJWkZFc0p1V2JPR3htK2hGcWpW?=
 =?utf-8?B?TnV0VXRnbll6L2lOTGFoWmFwNFMrQW1UUzlYSWh4TkJGMnR3SDRpOGNIUDFL?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a77bb89-cd9a-473a-2a73-08dad1999667
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:38:01.1601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiLZ/7Jjgvut2LDNooFYlw8vvkztL/vwbQcKrOwlN5e/frUv0w6U9wE33nyFUzG1/Uz9fCnJWKlDbnLwgNGH58JUc4JrfiBu8oiRf+rNVnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
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
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently MACsec's add Rx SA flow steering (fs) rule routine
> uses a spec object which is dynamically allocated and do
> not free it upon leaving. The above led to a memory leak.
> 
> Fix by freeing dynamically allocated objects.
> 
> Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> index f87a1c4021bc..5b658a5588c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> @@ -1209,6 +1209,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
>   		rx_rule->rule[1] = rule;
>   	}
>   
> +	kvfree(spec);
>   	return macsec_rule;
>   
>   err:
