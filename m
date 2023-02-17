Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7822F69AE51
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBQOtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBQOtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:49:00 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6C86D27F;
        Fri, 17 Feb 2023 06:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676645336; x=1708181336;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6cZRYhkRyR6KP3iD3d4atn/SwbqWMmcrhxWwRd5FEaU=;
  b=BxzR1jBQDMQfGvOeVTStZjmrUfnq0kDFGhAjIg1J++6jN/SwaMWdpo0m
   6pUaRbFanwOtc6siZId37dJXEVexojXmTOryBzWobgz6BmyYICk7JasLT
   EJ0uHMpRsU+Pf2ICPjJMDiL3YM8pKpnm7SZ/8rHRmli1+A2xgaPKNcH7H
   HnpxFGUjOL5Bb13JgdYjHIfYR1aoolB92kqtlFofmDuNLzdYoG3WU/8xE
   MI/uHASU1jUGpe7hw1J+txoFnZARuXW/v9TGEYbTYay+3Gb4xCAXyEAbf
   etmcdd8jGiNSXpkNL07E0MDNOUhIMqmAphfhklHUYctGcUcpwCxfQkZTG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="332001508"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="332001508"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 06:48:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="670562350"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="670562350"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2023 06:48:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:48:54 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 06:48:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 06:48:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOO4lhsfcJISAn/V+GQfeKvaG7B5T6tJ0FQtic2Bchg1V17jGyttB9F4GLbC/SOze4UgNrRjbDJgndi5yVVV1/FDt3Aixdn6CWpmHdQLaNpTupPtMgooDJcYp1zZlb7UWAXfRkMjJ1sQXOlmrQsTko/2hxzW19xo1ZASD1JAvp7piA/YeXyVXpkg9RWquz7cBh7XaJ+ZI1UJv/C44E3wa+P2bahXcVz2r8LuC1rKfkISGRsCsMUvysP+gXB/zxELebISTKf5V3CGVZ47UhodsAoGDdGM0j+zIxq//5p+n42vGpdvJuB4AH27OHJAmclp/euckY8x+WIxi+EFUeKjZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9bSZ9afFENr4Ou5RX9czYa2VvActRINJ28sruyBXYc=;
 b=d8VUoQjNYokkM2zLeT/FptHxxB67XBPEaPnkadHdltLv+3Iy5aOZ8k6f0pIL/IYXr+vmWyFV+k1xTAoK81umq6lFTDRGMLqcrXgc8zsol/Xiiv61Rjhk2xAMZljCqB54u4oEB7lYRjirWfX6wZVu/EiPO+LLWwtTJ0FbeIkPLBQtTclFjAqjI1FdpASTsfMScLF/+Ok4QjJVkxW16Mwpe2oChdfA+4kI4UoYYc3bwbAB8MVcvk5Q4p2+T6n3MvAXzp765DEj30qJgkvWmI30FUGfvoWCGfWuDFqwJJd58LHgcbDhPCywxpzJspnrdrU/JoTOhyERAvt81fCfvram5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 14:48:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 14:48:52 +0000
Message-ID: <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
Date:   Fri, 17 Feb 2023 15:47:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Content-Language: en-US
To:     <alejandro.lucero-palau@amd.com>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cc0a67-8d1a-4227-4998-08db10f6161f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjingh6UfhhRXLUilKggd8GcdtoeBWWBprPf4ZjRvggvPrIaBDGN5kCFhXm7r+OxcUNFrSouzQWRsOIYAAd629in6JZbaSPVK4Fcz0bCbdNlnV5KZXJKdpLUKsPsvYlRFQYFuPKq8EYRmSAXuTrbD4i+vuKjNLUEZOfjcrkda99s2b6RcTsb19pE/2WpLDuI796qfa5ocjVLJw/UtFocHlowXJZxr6S1DBAYRypn8OCIXZKr/t3kJFYL+LuhfECUGC8gl9Lsv8g8hBMRez6SLU6oWfe7yLbZQRvZ9HLZ0UJW3zPj07CkjRi9oJpH9VLhyoTqUYBYuF9i4QC/Cfvao8CPGML1ECd7gi48tYHiQygZM35S/8N9GcmCclPSKmLbK8srd6znB+kVOjyMvfEdtMKi31HfHdLmLRrlp0wm5D04EWi446BsjYdhpp7ThbPdPn3rRUNCty2m7JpcbgrekUZJ0AOVvecyVwtHxRBfbmwA9LlYCe5hztfpn1CuijJDhx8f0G+K/cbAsdaGpfoFQxRBUodkZURY2glEUdE/MgZ4doW7JdBCTfh1OZ5PVqFgm7AvcxsDs1tilZQCplVq02+hOEzbrJTYLGIZp/rZtFuzCVJlBtnCuPK7wzIHnIJlOmGCf0iJZgxJfgn4zl/mHaugOqVCMmTGcQiGXlJsn8U57WUOQqOjRmFOraSTWqOMWv3HPjO9TTK5JZ+mVTGQi8O0f+lEM6z49L0LR64g9tQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199018)(8936002)(41300700001)(38100700002)(83380400001)(31696002)(6486002)(6506007)(26005)(478600001)(6512007)(2616005)(966005)(86362001)(6666004)(186003)(82960400001)(36756003)(66556008)(8676002)(66476007)(6916009)(316002)(4326008)(66946007)(2906002)(31686004)(5660300002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU1CeUxJV3hsbVcxcG9RWmNLMTFFV1ZZYWlLNFJGNW5FVGlmWTdWblh2V1Bx?=
 =?utf-8?B?b1Y0bUdZWnlvdGZKMmFDTWhIU3dQNkpEUkRURVZVeVNlalJXbXpqOHJ0Tk9P?=
 =?utf-8?B?M3UyWGdVd2dpT08vWlJvL0RoNFh0c3o5SlhkZHdoeHJ4Q3laZGhxVEJpQzF5?=
 =?utf-8?B?RjVzT1pMRE5FS1pCVGxXRCtGVlBiVkNMUmVVbWxLbmxrZHZuKzBUZU1MZ1dm?=
 =?utf-8?B?M1dGcjUrQTNMazZLQ2NJaXpJODRaa3ZqU1k1MmFoOWUvUlE5THdESXNOZHRJ?=
 =?utf-8?B?Ry9UNlJId1Vkc0NlVVc4SHZUWkJsY1N3UnZTSnNpRjdYTllvaXFNazNoaFBK?=
 =?utf-8?B?cER6OGh3VnNROG0xcDlpTU9ZV3Jta0ZncVNFTGc5a2dTd2o4ZXlNcWoxS2FD?=
 =?utf-8?B?dElMZ0prbDBoK2p0M3BKb3RCUmpFSjlzbEJGYk5sd3diTHZjUXpyL0pHM2hK?=
 =?utf-8?B?UFp6cVhaVGs2UkFkZldFaUsrMno0UVo1QzdtNHhjd0RMNDQyVEZNTWtoWUQ3?=
 =?utf-8?B?YmQwYzFyd3FDYlVTRU9OQk8rWCtHSWNxbEVwaEJ6Ri80blV3RzdvK1hXT0Jv?=
 =?utf-8?B?YVlGZ1I0Tm5TY0NHWE5LYUs2Q25sanVsWHdLZkVDSGx5K012R205bmxBQ25p?=
 =?utf-8?B?b0xPVEFqZmM3L0l2UlpjQWJGODBjUFdMUnFvYUJmNDBSeGhhVDJtTlBHNXVu?=
 =?utf-8?B?MEJjYk0wV3VFakVDZ0Jia1RGMG5LWFhyZ2Rnc2RvYzVxS0JZOXZqMitGbXVu?=
 =?utf-8?B?QW5wd054N2R1Z21jVlRNejhFa1hwSkJBeHlnREF0OTlDM2dzK202b21VVFdj?=
 =?utf-8?B?aGZnV21ZMkkzSTZjcngvZmdJT1dnU3k3am5ucmtmWFBjRXhvN0xJYWhKS1NN?=
 =?utf-8?B?SGNsZHpZQnp2UVloazhsaUt2QnpZdnJ5RGg4MFpuYnN0OEhsbHplUUp3MFRp?=
 =?utf-8?B?NWI0UiszRDk2SktEcWJJQTRqaE83cis5c0dmY0RFNW1OeXo4azg3aTNhUng0?=
 =?utf-8?B?ZUFUNmJKYjZZNUw4bGpoSk93aHVicHpxbFFLRHM2MktNTHd2a2JzbWRVd0Nz?=
 =?utf-8?B?Z1ZoV0RJZkt2dE5FaFJMenBXMGI0c2t2UG1oTStHbGxqRldHSzZIKyt5MTFa?=
 =?utf-8?B?ZVl0UzdzZnhCdW5MZjZYQ29lVWNieWsxcDdPN1UxOStLN3hXR3lsa0Q2R1kw?=
 =?utf-8?B?WGU2NTk3TC9NWnNmVG9OVURxRXQ1bDFFOFFiSm9leEN6RHZlV1JqdytnNXgw?=
 =?utf-8?B?NnBsNEM1M0c2dndza1RFL25RTUdYdi9KRjFEQlQwRFJ6Y2NKb0oxbVRjMXFj?=
 =?utf-8?B?dU9CS09WM0tTTjRBK0pTVWFTQkZNZnU0SGFNSThEVGhrV1ZTOVFBYjhzNkVN?=
 =?utf-8?B?NmJQTmdTeC96Z0JBL0RvWGV0bVd6Y1U2S3gvWEEzTENZM0FyelRBTjBMWkJE?=
 =?utf-8?B?ZEpDVlQ4UUd0aGMrRy9mbXc1SElkcWlsVS9BVlg2cS95R3ZxOHgwdzFxMFdQ?=
 =?utf-8?B?TGRxWXRiVDB4VzFaQ0Y1czU4aXFvMGRkbjdER0E4RHZ5U2V5d0REK0tUd1pX?=
 =?utf-8?B?TGxDendpandnZGluVWVRRmVISm04YVF6RTdNUFJ1K3A0Y1IyQjFuUjJKU0JY?=
 =?utf-8?B?Si8xR0FXNk0yU3NsMzFPOGJBYktaOE4xSlBhbWMwZDdrWEdaR1lXMUZJSVVQ?=
 =?utf-8?B?SDFxa3VGMlU5SUJBcmpjdGJCNXM1d1I1bXJIaCtwQ2wzTlhjbjBET25tdDBy?=
 =?utf-8?B?OVpyUGNDN0JxWDV6bEJJTkl6YlcxSFVra2dRZHRtSzYyY3krbVRJMVh0aDM1?=
 =?utf-8?B?RGNpSWdrSVBUR3FMbnczVFFtc0tLekhUNXVSNGIvUlpQSXFtR2dKR0h4SURE?=
 =?utf-8?B?U3ZyUm9aSWY2STJHcExjQ3FuMEJHMnY1UFJ4U2dnZVU2eFliYnpTdVZmb3du?=
 =?utf-8?B?V3o3QXp4NW14VFZKaDl4UGw1VGFKU3RQZUVqNDhuQVVTa3dqR2U3TXBKT2Fw?=
 =?utf-8?B?K0I0TlFUNXlPaUZGenBUb1lRNjhoYkJMVlVYYVpIZXlycVVZdHJxSTRzQ21W?=
 =?utf-8?B?Y1R0NHgyNGtCUU5paTQzUUw5empXb1VDU0IvaS91MHJMdDVtWExUN1MrM2tS?=
 =?utf-8?B?K2tvQXEvZDQ1TUZZcTc1OFYwc1I5R1RYQ0hSNnFTQTdNTUZsVHRCcDA5NVc4?=
 =?utf-8?Q?2LIdtLhVW2NJVnot1cSK+aU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cc0a67-8d1a-4227-4998-08db10f6161f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:48:52.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kLTEyISa2I7nSqaS7ZIAj5ad7K/jP8y7T3MeEq2AevhcXBDbeCOGFLiWoDoLUhq+n5bdEOU6ivecgYGcdXSsPazxJnR4Fgc0Xc8jsGHjxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
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

From: Lucero Palau, Alejandro <alejandro.lucero-palau@amd.com>
Date: Fri, 17 Feb 2023 10:22:36 +0000

> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Adding an embarrasing missing semicolon precluding kernel building

:D

'Embarrassing' tho, with two 's'. And I guess "embarrassingly missed",
since a semicolon itself can't be "embarrassing" I believe? :D

+ "add", not "adding"
+ "precluding"? You mean "breaking"?

> in ia64 configs.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
> Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index d2eb6712ba35..3eb355fd4282 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
>  				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>  		rtc_time64_to_tm(tstamp, &build_date);
>  #else
> -		memset(&build_date, 0, sizeof(build_date)
> +		memset(&build_date, 0, sizeof(build_date);
>  #endif
>  		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
>  

Thanks,
Olek
