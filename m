Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5437569AB70
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBQM0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBQM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:26:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE20366058
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676636767; x=1708172767;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r2CluYQn902Z/EwlwsWtgFwZZbtFWHj+WZPOD14aCjs=;
  b=QvreTTy6BNII4KwPLnOW5F2X05X7lDh+LLurF4W825GQE2aMVda6lx83
   V5v8DjLpVqnKV3x93Tvvp/LdULy0ulZjv3bH5PWCq4VnYqVkcGwgVK/wh
   +3SyuCBiZgnEXO+9frG5UqRa52/1c7UNam/ateE7/m7otua+XJF8jQLFi
   X/N/VpDnjqfSL8yu6EirfQ38vKwn33LzPkg0DIxh2iKRetQPtZMBERjXS
   vl50X2jw/xCQwh3wFxJMPjW9zw8JJCvxt3v2EkSHNFsORIp/O6A2ug2v5
   NLI3+hsJsv37TfY0cF+YJy7fu9UI0HrvY6nhP4QwlG4KuaiYrvB/t/p1t
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331978048"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="331978048"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 04:26:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="759358166"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="759358166"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2023 04:26:07 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:26:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:26:06 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 04:26:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiiwOpvAV6OndVabcaR6w1sCxGt4SSSiVRUmxgiQvX+wRMtNHJYwiXpsCJt1g3HyoEDIcW0pjKG8OC7FrFrefnkMrWn0YHbsooFN0eg2+rebCqpn9AGCJAEs2lCKGvdqorlY6H87XJsuKJaSGFhzX5Ojt2uPKeVi6Ur/XSaz9bUSqGfXXXTE/QBa8XG6mUhfnnNJqzhWjMjsFb2WCwkUz9ixlTSIgODa0xgrFVRsyq2nnY7GATmg6aWDejl54brcyLcOimzk5Cv8/sw/dkhtuh9z0lXqx+3FGrTfDrCZd+HLDgEaN5l5x0bqhyR8GXUWLKx/sZBtS6+B6JyamlA7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PA9Fk1cV2WEKQ5q6HNa5cO/V3xDupliZAIwJd2SaVW4=;
 b=PIq59IZmARsCD57W7D4xEPWRVI9WrAx3L2Vp85BuEKVb+IwWM6ZnfEZX7XfwLfVtcknSFUEmDULn7oy+WbjgPJ3YD+fwfoZluDMtvTtdA04mJpCzL2/QMGpdeDzcNZ4cb4WJs2fNkpLDcPcRxe7vRmeM2tcIJ72+1odgeoGl8/1d+kPugCyrhc2fAhFzgWru+Zz6Q82I+N+iugWbwZnps7V6xokVKDQXrpW4rWLVOwj/UxdQNW88X3WYSM4dcLLOPpgIEPi2gNcW8Pqqd40OPxGC5ldG7J68kJvJ7Wx72T5CmAjaypNsrCJpAhkzJLtyvV6/WyM69dYGeAFH9hcLdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SN7PR11MB7440.namprd11.prod.outlook.com (2603:10b6:806:340::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 12:26:04 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 12:26:04 +0000
Date:   Fri, 17 Feb 2023 13:07:32 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jacob.e.keller@intel.com>,
        <michal.swiatkowski@linux.intel.com>, <liwei391@huawei.com>
Subject: Re: [PATCH net-next] ice: fix error return code in ice_vsi_cfg_def()
Message-ID: <Y+9uBAXtjvWBZVcG@lincoln>
References: <20230217093625.420984-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230217093625.420984-1-yangyingliang@huawei.com>
X-ClientProxiedBy: FR0P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::8) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SN7PR11MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: c15d9644-34f4-40af-7f76-08db10e22314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGyDpXqhZ+iorfbkcxD4Nb/SJL4/IfwDEjM4o15/qsDmF0DbrHUc0i+2jFptmPdbnBi2GRLc1PLy019A3sa67aFB6nKkPpmlML8K5eBkn7EiDm3J1nFGezSCqXIWB6hQ4P6SKw4rrCNNQSNe/GUt3jtn41qS0Ogs0fn/bYKKkfMhPil38S02KOZBtZReuKWF2uz9SEl2uE/ik4hSBmXlfrSxjsVDIFFelAAqwf3y++ToRe2a/wP1Z8SNX2LeA5N8PH/iiBPI/360rTMvzQ7z+FgEI/BBW7WBDyULebWo6L0Jh+/nY3THJ8IlbyN+fbHCPNUgUuKy/fFxuNn6GgYBci0iadBAtizmuYditrEJxeHBZxz5qhh4s1JRXmpXslHXDu6uuc2Fdo767BnxEzbfFZRpjJ1Hk6H5mU+P/YXcougv6yc/y0imZ8rAzfk1Ct6VWYTEQ/roOqqSXymji3luMOi7cfYqK6D6q7K5WVXGBQS5Tx9yPGg9wQwMZ9X7bBq4rQqlVIvMzaXzkuhK8hUTJ5us5DFdXyPaBIO1roFGTos+kpKgYP9hOfMzClPsCt8IWN0TThvv8+6GysYw7lHOcrIGJsY5CVHJ2+Sqcn9+fp8C2gY+FPbWTE2gCXxiwG7/xiEfDo84db3dBbQyWmMkTYjh9q2Q1IUF+f8j0UHp4K3qi7rdTr2+ld73i4E9msDl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199018)(4326008)(6916009)(66476007)(8676002)(2906002)(8936002)(66946007)(66556008)(44832011)(5660300002)(82960400001)(38100700002)(86362001)(6506007)(6666004)(478600001)(6486002)(316002)(41300700001)(33716001)(83380400001)(26005)(186003)(9686003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwc4ZbcX/48mCKD3zl83EBZ/wgiliZR85ZlQxXSHr9QachN+t0So3277FtpH?=
 =?us-ascii?Q?gYOcNrnCTUwjnl1LBmWGq2ayVWDBygUgt9dhwiyRiar3zyo39cW2uXwFwdMW?=
 =?us-ascii?Q?554LJiqwa+s+pCdJKhC4xH3Giv76dx91TPWF6TbWbKO+zSnRe+QWVNUbpquX?=
 =?us-ascii?Q?+eBAR5+Sll0uQpBeznpaXbYn3mnTp4svtcFD49+R5E1xg7p4RvZv5oodlIVq?=
 =?us-ascii?Q?oqgYhwlwpAJWijPTmvloVkMa6/TK5hkoc4WAGgXqzP7UIrbL3Um73W8N/bpU?=
 =?us-ascii?Q?6AJw/IhdGzCVYzBScUNAgQaWV6yl2/CDWA4GmWe8PioaCx5W/2WfovKlm9j6?=
 =?us-ascii?Q?6emdijCVi8i2Ip2X58aiAazg1vc+c226/CQyCc2MuUiFEhryQO9XPS9oPqxI?=
 =?us-ascii?Q?45qmhtSYMVvo98CCi8t+Ws9XxWJDaULd1TFuwFvJ1ioQslINsHT32hy9+24I?=
 =?us-ascii?Q?u3b9uoFQZ3OF3XVk/3ib1OYJsPGxEO//GWISzRgvfchv861uaSkrRNhpNukx?=
 =?us-ascii?Q?SNdoBpCzKM8s7kEVVwmZDbki11WudRS3pkULOkYv1KPiCikoDBncn2+5wDh0?=
 =?us-ascii?Q?pxn74W5DoBrAxrhGBtLkyd/zLvtHD+bjIcqyv5wqXM/wtlQCB/3gAV5Dyxs8?=
 =?us-ascii?Q?gQpVArjxGjiXJnAWJa4m2I0yo3HV7zgmlzovYhkX6QhCjJNv2rXQcrLk0NC8?=
 =?us-ascii?Q?KiCwJTX5VoHDmFIuiLJi61b31fW+pUdcPlj/VO3uzelUgRh7WOtej9fSVthx?=
 =?us-ascii?Q?4QTL+CeVgEIrN33gY/J6MlpukyIAOLebtdnilbjYy5GnsqSDB7WnP5S1DcQb?=
 =?us-ascii?Q?OuP2HmE7Gm+jSbmUZJx9MsLBjF2Iy3QZZMwPFBChsru0t+88RfGyWi+zTdAT?=
 =?us-ascii?Q?1YCmcK3gJCLkQbSm7u8hQuudGjYVEiQ/SRz5rSx5Eu9c76H6DdVArlpzefin?=
 =?us-ascii?Q?ftJtAHIkY7IjEo0WT8WJMcq5RFj54W0nBrusPvoERr4gqylQT4LXjULnqSuV?=
 =?us-ascii?Q?12eagKXesu1JUBKQVCLme4bvjktS9Cb6UQfAB43u5s/AIDCc7zd6XrtOLLbs?=
 =?us-ascii?Q?wQjhL4UEZmbn5lJ0uIFWjlxAKZg2AdOV/tFEYoAJ64aOEpBkKYGQ8nlNEY6H?=
 =?us-ascii?Q?S1druETH4TcjqLzdj6aRLEYooEDDxGAGaQxIAXTJrZRO4hjaaxzux3YxZggW?=
 =?us-ascii?Q?EXr1YXHmOh5WOY8GelmRnAdDVWuwP127LDfvBZsyJ7ZPrj6xaCOEA1nWteNE?=
 =?us-ascii?Q?fF2h+GdG03hQ9QnYVortOY1MN5rLDVID1hQfjz+Xn9tphZWjddt/DIrQXNOi?=
 =?us-ascii?Q?XsVyZHFE9mmF8Fn8xkno2P2Rae8PdpqJdBEUe5xPCn5rDDVNRzwRQzxgmmT/?=
 =?us-ascii?Q?vvoShIKMc7fNbLhOJRawTnqgGqAjVoims6CoaLs/7yQiA+h0LWJDXcQTG1Oj?=
 =?us-ascii?Q?66WzrZ1saIGNo8eprRQdysbYm+C5IG/9nl70mFADwjGdoX18zIeqvCvkayv1?=
 =?us-ascii?Q?6oFy4ipUnSQPUC5u766tQFOjdcbQP8MadDmlHP1wTSPtwFWbG3OYIapnPV+p?=
 =?us-ascii?Q?9C8KRCt61HAPV+bN+0+cYaqn0gMVroeohud4RjP7k4M5qWbKog/GaycN8/Zd?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c15d9644-34f4-40af-7f76-08db10e22314
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 12:26:04.1818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ps6C1b3C7zJNoHeSGkdv+zsDatsfGhbSRE/5zocGsPPxeZV+kvu0+NSokQQgiLCa3+ShCauuZyB9yXCv7eBHEevEuA0ml2xIIsJy1yBlbVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7440
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:36:25PM +0800, Yang Yingliang wrote:
> Set the error code when ice_vsi_alloc_stat_arrays()
> or ice_vsi_get_qs() fails in ice_vsi_cfg_def().
> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 37fe639712e6..766edff0d638 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -2692,12 +2692,14 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
>  		return ret;
>  
>  	/* allocate memory for Tx/Rx ring stat pointers */
> -	if (ice_vsi_alloc_stat_arrays(vsi))
> +	ret = ice_vsi_alloc_stat_arrays(vsi);
> +	if (ret)
>  		goto unroll_vsi_alloc;
>  
>  	ice_alloc_fd_res(vsi);
>  
> -	if (ice_vsi_get_qs(vsi)) {
> +	ret = ice_vsi_get_qs(vsi);
> +	if (ret) {
>  		dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
>  			vsi->idx);
>  		goto unroll_vsi_alloc_stat;
> -- 
> 2.25.1
> 
