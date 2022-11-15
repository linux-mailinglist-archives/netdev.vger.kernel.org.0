Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345226298D3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiKOM10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKOM1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:27:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28428F;
        Tue, 15 Nov 2022 04:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668515242; x=1700051242;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yXfpxQt3i0cAei+nCqJiheNnTPlpy411VQAAbw62bko=;
  b=CkEPaTVeu5H+S0r4k7Gkv3nFw6hixRd5UASXdP8MKjAqJYb56TikKVQJ
   UIB5EFb2xF0FtvSmD0Y6frnKUR8ktuqUpbkIoZFXJ9P2f0/HSMuemsW3e
   ytVNvAfvkvDYtjTMeUIcpScwJKnJiX9+g/+f6ZVSx4qB6eiXuD0VX1kSv
   4haOkYG1xCbEABi5kDipUOSiaSlrDtWMm9jvrJ2aJtxOm04Ayfw3iZ8HO
   x48SzixxMppF39N8qOCzCp2RNPmFm6zclxeA1YAUHic1PfGCn+1og9uyY
   BbUXZUGvr1wo9i0epLYG75pJq8NovM8Ut40DwtQoPSSa6341XwBo2JgT5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292634905"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="292634905"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 04:27:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616736878"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="616736878"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 15 Nov 2022 04:27:21 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:27:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:27:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 04:27:20 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 04:27:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgpJvATl2PtYFgljeT/x298tORx0PaQaOvdaLQKxmtt3Zx1vbPl3pURmDbwBBHWmyY4ShGBrnkgCDushIstvdg/KopOgK5IBqRXHj6TAagoM23RswhXPyBYMmRRujmoyOLAZu/NQgA/mCp3jH7IMduax8TpY5fA5aFOssd6BA+DJCd6hxfVqMyW8KYGoRpDgtUAnLMbN7ZT95gaa2JRtDYWeSVHkpYvk00/qlllO8hgg8tGDDqa+2tlTO4TqrIeWhW0cl8NDe4JjIv3ort8t//m3U/FQqu5f/q/I+iPd50AXZa+zg4727Bjr7dM3tb1MvGRMg5PivdI+q765Y160IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHSVPMUoJNYek+9RdlQ1RoffIPblNhtabIDRkpp4mVY=;
 b=H6uxRNXsgaD5JFjRf/6skM9Lk6+F30exSx6fvK5XUutEkJct7eiC+/E6DqQke72dJ+AeB4tKnMGID4/XNDRSKAFfjDNfJCI+L0JZYsg8bUhhBoCmUmkMHeeMXUR6OVTNJpzbkRuR2ZoM/0wArWKrDC8QMFxgKtj/GR3WEE9yhd5RCKrjRMfabw5Perc9SVLN48Z8/njRimTwKgZ0OGQuDJaF17PsQ40UPNnm8JSUl0AvtqCiskJyPRhznlrFMjS+USWaivsPQhKU90XwuJqOgiqXPqT1ru1ORNH3hyJ3RX1Vkip12xgr6rX1nUlGC9lZGJpqbjzIpns14OA0TDBgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 12:27:18 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Tue, 15 Nov 2022
 12:27:18 +0000
Date:   Tue, 15 Nov 2022 13:27:06 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: Re: [PATCH net 2/2] i40e: fix xdp_redirect logs error message when
 testing with MTU=1500
Message-ID: <Y3OFmgLa56rwVQ4j@boxer>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221115000324.3040207-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221115000324.3040207-3-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN2PR11MB4696:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7c9843-a697-4bfc-46bf-08dac704bc8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FspoR6rXKkdOq3RwiAqgBdc+G5n0rst/ASzSRam7i33/F2P5GkGP1DvfKVjU/B8TlC/L7lDmvkttM4N+vsMzpa4pfJgIEW2lngQ1mkWNnWZxI6LyiBY/zMiB4SyKmNHBktzADfXcqu3knyfdtnr1Q7QbAifTdO5rH1yykgumDBfHQ+VyaOl49N5aOxzmmSK45uB7x2jOg3j8pk04E89tw1+sjICl5Haf6L9R4VtCIEzNHaf/iKrmPpMeISW/Aj7eVqe6CkEGIuw3OdtTgsvzwie0LDt+LFXs4/HIsEb2C/2O+ZevLwCpSHJDIBzWaUB7CpoSyzkzfLyCM6gI7ukvLTGotpgLi380Qx3qr9cSgneCtTpJ07T6bAbO/NGiWYeiMWUGWAht6C5nas/SCz5oPs70f5J6R3flVPLDQt9wQQQ0p7NY0SgsHAyWfCewZnNuJ+nm6u4RTSShoPB4ltrHaKskShoSceFYz2pTwxSF0ZsKPdGobPplHMT+v8mvStJ+/YV5YeIoHrjtYN+8x+8jTvkm1GVaPXPuufR0cDFOd+JWL0/9peFBTC8QiNwR4yLXEt9ZY3rTY05sVSifLzKCeqmH5SD4GbsWAxDHEpgJUwW1wN9ZI/eRyDo2jPAXw+nbzSqRHSaRn7zxNj43gVbYdmgn0uSPJUOxD4yUvHT7XTsLteDgayn7C0xQdChs4epv7KpWnwMnIJiq3algcBq/Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(82960400001)(44832011)(15650500001)(186003)(2906002)(6636002)(33716001)(5660300002)(38100700002)(86362001)(6486002)(83380400001)(26005)(6512007)(107886003)(9686003)(6666004)(478600001)(54906003)(7416002)(66946007)(4326008)(6506007)(66556008)(66476007)(41300700001)(8676002)(8936002)(6862004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Du144tNdGNteE1rFSSJ9GDpJlktkKCkrzILsvqIOwJ9cJxqrgA9TjdaF3nq9?=
 =?us-ascii?Q?Tl75AM6tlt/cbWQu3QlVBnyy9cmdwSKMsvGbN4Xv+7MPHsyYpAKJSDlCMt6+?=
 =?us-ascii?Q?NHgCA6Tkv+8BaZJ9pTsJBITMllITIMuUEwtvdzzMAhdBZ4RU+ZrlISNjolgL?=
 =?us-ascii?Q?kKwW6JEhdGqFmq8DoP5PY4XDRXPq6Q0orv6z+5mPAO2f+SeMJ/Nlc4T7svQB?=
 =?us-ascii?Q?gDACurRSeLt5Gv4NtY3Sel30AsGjVd+j6576XML6d+lsEs7vB8lifnayVhVX?=
 =?us-ascii?Q?DRJqc2vvM89inyth01yB/PvTAhHpI7k3yB1AZCzcC5ST+fpadfRbBeyCEYmk?=
 =?us-ascii?Q?ga6ABAC39IqBvdHbeIvnqNXRoWrATn+De4pqjs1wPDFV8XwBB46WtIzEAxlt?=
 =?us-ascii?Q?ZDrNZRW6wap9O949PHJSjDyFMrG0tVi7Bre5kYlJO9Yig3HffpjUKf7aXW1R?=
 =?us-ascii?Q?u9KkOknQgxykxnz8ngRy/h8SxhK2IQU8csaaw+VGZ0pua4ha0ZAHNZWfIZlN?=
 =?us-ascii?Q?eMC8SN/bDdlkHVNjB3SfN9WzB0gsLpLoIqABaqPyWdpEnlzoGdGojg53mmf1?=
 =?us-ascii?Q?3Xp7mICJ9P8UG2eL2Kxt5IEnQxWgHl7yaI8N3JyWTf6/4+J95hl4HwpOgUxc?=
 =?us-ascii?Q?tBn3It4Ir1HAqjO18Ocv3doB0IKDabo0bDwR1gOQNoobueAtoEHyHAu7KaZb?=
 =?us-ascii?Q?ra7Ek+WGdA3Tnz62Oh5Ky9naXEIRb+uxcQl+MjNbxraRLX0dTOMT6FG0yjDU?=
 =?us-ascii?Q?xfkQPR+8Cv3T7hxDiwHe3YsUf75edFR6r6cvRWTWlmQyPNwqCVfnFDAqbo5A?=
 =?us-ascii?Q?Wia1khWKHFG/HdoRcB/38xrmE48h7ulQWv8MJlCgENCGcDGlZIYwh5q5JaEJ?=
 =?us-ascii?Q?CZVznEkP1S1BwRYvr1P274cGgugKP69mF2Up20ghvFR/1A8zfKvWALpwSh7R?=
 =?us-ascii?Q?c1V4IFFpfKst3rFEn8k+PABwnUXVh1B+KcNd25m5VEzrsZtvAXthPqL6K0a7?=
 =?us-ascii?Q?GP+VN7EGj7bsMN6/AhgkOFprWzqfHe4DUabK3Oq7ZUaI0+xwPlwUpkexFhgm?=
 =?us-ascii?Q?uT4oVxwmW5fszAsKxNr3Oos2Mne42ooqotwrmjvjSysdhkTSWAEwLWA3kkJc?=
 =?us-ascii?Q?cWnp+DMB89iYLBqdKbH1nx6lVKiul5rX0zS3HG2yEIjb6q9fF2GEGAVCg9qA?=
 =?us-ascii?Q?BChqkvXpDqdHJIJVvAPJA+aMmDDHnRiD/N5vpjjinyaH+bmyKRRVniTH0Ptx?=
 =?us-ascii?Q?7tBPb1lq6lF1gcsIqQQ3h2ay5QRGDeyuT/tiTclMeANSjKmgrywMOqGr6Bh2?=
 =?us-ascii?Q?cb5gSbDqHNrf89nJr+B/EgmvwFJKRUguRZem/7N9J8x50ceRSzIXDwUAQJC+?=
 =?us-ascii?Q?LJPkAMXIL4jEvzmbXYMWbEnHTNLERahozzHM1CjqlqvQlIiV4IsGITyiB6gZ?=
 =?us-ascii?Q?b4JJMNDZtp1p/qWIAxzjkdxQnwqe5tQst0W7jaZfs7k36LYfDz4sBNA4A3Cz?=
 =?us-ascii?Q?0d2qGuozwnoaGyws21BquaA5RIDG21S7NJOV4WExh+d6pG8ikFuNK4UGSCaD?=
 =?us-ascii?Q?otjSHav2kdQNrBdDBVSdIHCw7IcGCaKSYSDOPErLrXzUnA/67JdhlTfp/sMV?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7c9843-a697-4bfc-46bf-08dac704bc8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 12:27:18.4324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDNAWLsAOEU9tPoE+Ufxm7+boXYpRVRt29nNT0EY5PIwQm3IWu6KNzKXOXb6LyGHOWdXE3l0giz4E6R26syom+bQfs05gLw0C46Fwn7WJIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:03:24PM -0800, Tony Nguyen wrote:
> From: Bartosz Staszewski <bartoszx.staszewski@intel.com>
> 
> The driver is currently logging an error message "MTU too large to enable XDP"
> when trying to enable XDP on totally normal MTU.

Could you rephrase this to "Fix the inability to attach XDP program on
downed interface" ?

> 
> This was caused by whenever the interface was down, function
> i40e_xdp was passing vsi->rx_buf_len field to i40e_xdp_setup()
> which was equal 0. i40e_open() then  calls i40e_vsi_configure_rx()
> which configures that field, but that only happens when interface is up.
> When it is down, i40e_open() is not being called, thus vsi->rx_buf_len
> which causes the bug is not set.

Where rx_buf_len is cleared though? Or is it only the case for a fresh
start?

> 
> Solution for this is calculate buffer length in newly created
> function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
> length. Buffer length is being calculated based on the same rules applied
> previously in i40e_vsi_configure_rx() function.
> 
> Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")

I think the problem dates back to 2017 and:
Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")

CC: Bjorn Topel <bjorn@kernel.org>

So i'm saying let's have two fixes tags here.

> Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 42 +++++++++++++++------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 41112f92f9ef..4b3b6e5b612d 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -3695,6 +3695,30 @@ static int i40e_vsi_configure_tx(struct i40e_vsi *vsi)
>  	return err;
>  }
>  
> +/**
> + * i40e_calculate_vsi_rx_buf_len - Calculates buffer length
> + *
> + * @vsi: VSI to calculate rx_buf_len from
> + */
> +static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
> +{
> +	u16 ret;
> +
> +	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
> +		ret = I40E_RXBUFFER_2048;
> +#if (PAGE_SIZE < 8192)
> +	} else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
> +		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
> +		ret = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
> +#endif
> +	} else {
> +		ret = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
> +					   I40E_RXBUFFER_2048;
> +	}
> +
> +	return ret;
> +}
> +
>  /**
>   * i40e_vsi_configure_rx - Configure the VSI for Rx
>   * @vsi: the VSI being configured
> @@ -3706,20 +3730,14 @@ static int i40e_vsi_configure_rx(struct i40e_vsi *vsi)
>  	int err = 0;
>  	u16 i;
>  
> -	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
> -		vsi->max_frame = I40E_MAX_RXBUFFER;
> -		vsi->rx_buf_len = I40E_RXBUFFER_2048;
> +	vsi->max_frame = I40E_MAX_RXBUFFER;
> +	vsi->rx_buf_len = i40e_calculate_vsi_rx_buf_len(vsi);
> +
>  #if (PAGE_SIZE < 8192)
> -	} else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
> -		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
> +	if (vsi->netdev && !I40E_2K_TOO_SMALL_WITH_PADDING &&
> +	    vsi->netdev->mtu <= ETH_DATA_LEN)
>  		vsi->max_frame = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
> -		vsi->rx_buf_len = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
>  #endif
> -	} else {
> -		vsi->max_frame = I40E_MAX_RXBUFFER;
> -		vsi->rx_buf_len = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
> -						       I40E_RXBUFFER_2048;
> -	}
>  
>  	/* set up individual rings */
>  	for (i = 0; i < vsi->num_queue_pairs && !err; i++)
> @@ -13267,7 +13285,7 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
>  	int i;
>  
>  	/* Don't allow frames that span over multiple buffers */
> -	if (frame_size > vsi->rx_buf_len) {
> +	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) {
>  		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
>  		return -EINVAL;
>  	}
> -- 
> 2.35.1
> 
