Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E39632BBF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiKUSLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKUSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:10:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC98B54E0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669054257; x=1700590257;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=M1cMw1OTlgTxkifn7JI+qfV6i8Gwgg+AyiJcEd50nFw=;
  b=RyqXJFlMwVfn+4zdPFHHG2+de1yn1WKQqYBbKAHFIHdaI5EiC1HAp8EC
   SPTmCzhh8+oc8BSfJBf6uu82Y3v4AuNuG/gfw4poIYPFMHqN90FF/eQsE
   B7Y3xVagZmHODzgReNoUQrMuphweeUJ8O2kcBgJ6ADkjmBkNVncbS5RvB
   VxATNetijcx23lcXyPqYXqIIlUgc9X37PuEAV1fKljz73X1HW4hML+mzY
   HzoEle+smR/ScBYg8I/50ZgjjF4kakfgOo7UrbiMXyhv0ENphQkZ/R9zK
   oYC5AGK/ukpgq3k0MuTeEPO0d2Bca1rdxEbiQnY2wB3Z9lzsHqzTXepvb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="312328550"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="312328550"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:10:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730100525"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="730100525"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Nov 2022 10:10:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 10:10:05 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 10:10:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 10:10:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 10:10:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnpfhAMu1iKtj9/RXob1YiDkH7kMgS8+C5f4N1QyhswmOJ3O6w4v4uiOKE7pB6q7PKMtl5esHX5R2Kxr0M7/aZuRiID7BAWdwy+8I0KGJRGxcNK/8sOvS8td+uzKkFk14gjsmoB8Hdk4KSkaKdxvqWdZzuks6ykV6sgwrjyMIdj1Jw6pr7YyVj28WP1xLj23XED+KN4pDCr2/KiZh6uGhotwLFHJcCHl86aI+pj2Mmnrcl7VXK+aXlqyhd+h8cUcmWECp/ewgWgk4J3Fvx6b6x3dqqBo+Uvru5//UIr1I/mPmyQ5yi3p6lBwsVTWjkRw8edoJSh78YNmp3T7voLCGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aqt8JFh/0Y0azLu68BvYlMDG+Inu5zVnoux29WHjYyc=;
 b=XRLn+ypTz6qtp6fOSai+YkFhXiSC8YtcGcfaSYhmQpAwE/L44Q3faGa1vM81GBIO4tPmKEyR9SyadpApU6cFlGuBn9MyC8i2UWQTQFcrdp4y0taW5L1D9VJT5Btq7lq5O6X38HL9fuVukFaCVyqHvZhMEMjw3s+xxcD4+v9rwbOMnakIIJyIZu4VeNy2WPIkOwufTgVI2Cgl8PaAXcCgltPyymnH323t3fsle1u6lR2UQPFPkf0wZmER45XkZR4aYt+733IxKySaiFVn3U/M0euv+mc1j8UFqZfyQlU4nrXqGbKs4/1Lzpi1D0c7gmZT0Wcc5/J/KjI4/oJiqPWeMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Mon, 21 Nov 2022 18:10:03 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 18:10:03 +0000
Date:   Mon, 21 Nov 2022 19:09:55 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Yuan Can <yuancan@huawei.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "error27@gmail.com" <error27@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>,
        "josright123@gmail.com" <josright123@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dm9051: Fix missing dev_kfree_skb() in
 dm9051_loop_rx()
Message-ID: <Y3u+84hDCgoehzj1@boxer>
References: <20221121033226.91461-1-yuancan@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221121033226.91461-1-yuancan@huawei.com>
X-ClientProxiedBy: FR3P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: eabdec49-278a-453f-d984-08dacbeb9c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hlDDvYctsNqaqmR1Wum9kNntoEaeYb40C5S0hLP3Tb4gpOxyL5UQzUDsgp/EZLNn/uuGQk29l2OjgU2ikiRpe8gS8vX7tbgWc4lr8rgUHbjuGjPjuEl11W28XxYqANNNKho5MnufelJ9ymF/MIwsZSDwFcvvsWHiOnmdO5v1ERCbsvG+BoXLInnV3yA4O9kq05K+/GdvWMYTdpQ96HnyroF46jQ4Zn9TY9JZ+CezAaPVdUR3EKocaoZnUK8u+UJ2RccpgTfNSjwJGXj+P2LAUVwINP5+zG2y7w9jiG0BSsFis7SAe4cHKPvEyIhxCbfShakC+vrSaiJrT556n10RPTycrDIkDzbZfhJRSuL4K6o5pUWM6q06YBRmL45C2dK8ESBzwFhrSMyzHCk3fiuU/XzB2QmPsaPiy5LFsnRoC2TAB36Zqq8PyaSzEC2Z96jsFPh8v5yunsIZ6/+D8MSWK0TV0kCg9Ckg7o8rjowiAwCoM5fsaIc2kVctXd2k+qQ0sdlnWCLDDzfteWcpIFQ42dOi7CZeji2R2sidnFGMa/0alQLmthlklBBBlqqwfmMdD9sqYj2nKTvLvuX966Z5KqOeKaUm9UsXAmB/fPmNGVRa787oA5QniOKt9gBFsnsh/tQ9f05jXYZrcbR6jYHax6o/P+jWtF9dX4gs3FpuICUp60ugTgNXnQZoxOl5rsA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(86362001)(8936002)(4744005)(7416002)(26005)(2906002)(6666004)(9686003)(6506007)(44832011)(6512007)(316002)(41300700001)(6916009)(6486002)(54906003)(5660300002)(478600001)(8676002)(4326008)(66946007)(66476007)(66556008)(82960400001)(33716001)(38100700002)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxFJ7HLqw/ZGh6johxdUwAkDQHfUhKHISpzbf2OK35MTd2f9j81kbGBmU1oH?=
 =?us-ascii?Q?93RkeecUaSlwRpfzwiDI+g+6f0yxkSwrUQvTE9i4OLgwv7HjiIAePojdxplc?=
 =?us-ascii?Q?Vu58kFJJ7V+KUCQkOS9+gL6FWgMDWTkCemJ0znyRf8QvdIMf90xDvL3ymm6R?=
 =?us-ascii?Q?YTbWoSwMvTQ8cihtrDcKwSaOvnV9nXgbp+Es0XitKPwfom1qm9OUEc6ypNG3?=
 =?us-ascii?Q?S5wEFCVngPxIwWjKC7mP5GRyixha+DRMrIGKttTjDjVD7W2awG1hcfDggWAJ?=
 =?us-ascii?Q?uzPeNxM39uUYTfV7zXTsniHhyTFIKCrfX2gJXxRttj7lX3Uq0Aiy5V6/zhZm?=
 =?us-ascii?Q?kGulkiJ9ERH4iD/l53E9DUaGlJHGMUglUw5q6yx3aMLPVVf9IchD2E2v/t5b?=
 =?us-ascii?Q?4ltVh3vNQPwTGPOfdgFB2eYbx3DjUcVfBX4zeleEasA8v9p5Byg+K72oK/TC?=
 =?us-ascii?Q?M6yfkcUwdOVzT6Uy+M9DiqfSBvxUo+x1brOUekVxY3x1W6sdDsb+ZNebdVju?=
 =?us-ascii?Q?ILBozKL5u8AGZ/R/SmTyFvdlWQ1eGPUVOjwOHzrzBClq5kifYUGzADtvWLem?=
 =?us-ascii?Q?SvY1HZd77qSKd3EpxPv5qScYbTACjW4qGnb0ak/4fGtLWCEznASDLoLRz9Bo?=
 =?us-ascii?Q?a9DmHap+a2yvd4jNLD4tXnFQ+qY8JOhsFxCJ0jLPdMaVjbsn0WNxzyiBPwOB?=
 =?us-ascii?Q?NQnYhjnBY5UaCYrWYtEwqPIJ6aQUCcxGuMONGUSyHtUgJFOn+kjaODv+vssY?=
 =?us-ascii?Q?cxk6bu0blSFqDEOkrTSdSHQ3uZSu47DlLZChfyryiRY9DatQJDBPyP5XqwDe?=
 =?us-ascii?Q?qmNUG0BlNEHj2aUS/Nf6PBYRIuPhZ1zgrREvsXuIxPHG0MrDm9h44iGbQpj4?=
 =?us-ascii?Q?5bjxYaf9J715QBHRqBhrux87oK7XNMW6FmErUxaVykLq7lcilUKPtlsL6Ktv?=
 =?us-ascii?Q?BkvRpGmVqVyif/AcdIISa9eRzz4eKG1r22IIgCbqikcroSGy+DhuifHML5Uc?=
 =?us-ascii?Q?uFzDLo65N+GocbZkWfDhK6KAMyhw79HJpQGnrpkmCt/SLyXaTHHgt6Xk9Y+a?=
 =?us-ascii?Q?O+IjHrReT0WYMHp0jDXBaPQzlJVb5qqkd0JImHaUGP6ghSsaWcQuRpjIwSIi?=
 =?us-ascii?Q?MlXkvB8fh1qeCKbOcO4V6NPdl1Oqisw/srIiey8JUjM/WhxiUllMEaUAZgqu?=
 =?us-ascii?Q?+GMvHgYM3GkZlwZHYck36ID+KvH17krRiw27R9THCdGgS0ZBYxvnWFcgeH1I?=
 =?us-ascii?Q?JkJ7V8HPScMCmyC6JDtL7dMSiuYlzWNgmPsZgyDrM5di9lCkFrmP6C1QSi0G?=
 =?us-ascii?Q?Oqx882jHNAf279cpXPs/+fqkjYctxSjnk5xDe22b93TLsxu64h9Q2pUZGsP5?=
 =?us-ascii?Q?k3O6yMWy7Cma7GdnFswznpZt+jwY0+v0SWiBS4fOMjrdQunyF/EYvquogVfQ?=
 =?us-ascii?Q?/gcazE3gAXAn64C7yfHKyEnmbtyXrVZIqpVGIhKcTPoHc043mTYBlu+3z4mX?=
 =?us-ascii?Q?hyw7d0FNf8j+OJDdk4IbjMG1SvwDtIeEACTIFlGBjqWtrVfMsDc1x03FiuGT?=
 =?us-ascii?Q?gdbclLC1AFVa0tphTGB8V//dZexPphpU+RMS705NxxBOiWZHfSPiNCURUN1h?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eabdec49-278a-453f-d984-08dacbeb9c92
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 18:10:03.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2rqY7KQ06DdER2ZIfdBceYJA1hPWuAxsQc5YuE6t9ykXyOOiJuSqHh6iDZGjOYDhuoVdHpNrgAHNTH1NCE0KK+iCwCWXQ9pNymNFsGilws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:32:26AM +0100, Yuan Can wrote:
> The dm9051_loop_rx() returns without release skb when dm9051_stop_mrcmd()
> returns error, free the skb to avoid this leak.
> 
> Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/davicom/dm9051.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
> index a523ddda7609..de7105a84747 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -798,8 +798,10 @@ static int dm9051_loop_rx(struct board_info *db)
>  		}
>  
>  		ret = dm9051_stop_mrcmd(db);
> -		if (ret)
> +		if (ret) {
> +			dev_kfree_skb(skb);
>  			return ret;
> +		}
>  
>  		skb->protocol = eth_type_trans(skb, db->ndev);
>  		if (db->ndev->features & NETIF_F_RXCSUM)
> -- 
> 2.17.1
> 
