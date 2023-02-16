Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01C699925
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjBPPnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjBPPng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:43:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5459E5;
        Thu, 16 Feb 2023 07:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676562215; x=1708098215;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lt1wPzg9yHTXroj12+o50tDGmWNFYILffOAFurUU12Y=;
  b=HUP2ZX8LWG+wtHj1apMPP6o1muX/rwCVZvfZTTD8blruymUVEyjZCPUB
   /DJfkdjKAgv+d9ZfAozx8Zg2/0D9M6jChhMqchBbnSVBR46oQKaCJbdPm
   GTIXBVgZ3y3O6GOoKpG6KJitDQEqm6SgvSoIkIcvcQt8cYJgc1gZnW4Z6
   7nmxRIX8NjCEy5nWQMly6tmeUVstbO740xq/l1GKOEyzj5zBfIwx5scir
   QWznf+fcbXvqsfHHL/BSVmnU4BLJcUcFAk8BTZFl8g4cySB7Ez3suU7r0
   L+03uoYofo8HyQg5EY3yylHpxEjAy8ZBgztmiLDgzxfEahVlqiO1oTaqY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="329465201"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="329465201"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:43:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="733913934"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733913934"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 07:43:23 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:43:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:43:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am/OzoTtyEs0UiWM+LdUD/vHgx4/dvdtWEIlr1cTCXRXLJ++vdqK63p8dkH3xx3sn/V2c2hPUI0eQxPO55e6Kz2EQrERsmmlf/lJsd2clju9Nb2xxaX0K+GdR/o8x2Xb1iFI0YfNYItPTojlBzt9xaem9TxIsKmzhn376OT0gmC0Mu498+bBBh58keUw9E+IMUacQvb/hy40eGLtuu5S0CbfkixMcC3jDamCExBA7w8IqMC6id7lUfUIczBlxWXUmKtKlemMPM3LOl9h3dJRkujE2IMzuGZhNFumeLo0RljjNqVnMQSfgrZYGpvYR1uS4gheSrtbeNcTFLhTNWFCFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTphLGY5JSQagXta8kbOwW6epCehdki8K4ToLT1oThI=;
 b=FcGGb/74vq9bd2XSPAR5j5nP3VH0LDS3LhtZodqSzEE8pGZWdzKWbmSyRdkn/KIlwOcz/JHTbxs0HEz1eRNKVW6bB7WyFvzDDAQOWyMrI+JIcsrmExBmAJLebbQJ2nV/StA9jBI7RkCp3oyxEBfIbiR0UlE+UAOyMOgJKBsWkRsaLtPQ0X1OiomQcPZDD/+QHGQ8DnhBG3ip69IMZRcjh6NoAwcAG3FMZyLQAzOQCRiakKL9RvEqGWKTi2ZET7mIjhRmgQPcvxWbsh6CeCeLkVPl59/+LjZoGBWqPsmvx27MkYZZ6fngoZoOstJS7SV86XU4uTvpfHvX4eHyA7vY8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 15:43:21 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 15:43:21 +0000
Date:   Thu, 16 Feb 2023 16:24:58 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Alok Tiwari <alok.a.tiwari@oracle.com>
CC:     <netdev@vger.kernel.org>, <darren.kenny@oracle.com>,
        <linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
        <simon.horman@corigine.com>, <keescook@chromium.org>
Subject: Re: [PATCH] net: sched: sch: null pointer dereference in
 htb_offload_move_qdisc()
Message-ID: <Y+5KyhntRjMzDM2G@lincoln>
References: <20230216104939.3553390-1-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216104939.3553390-1-alok.a.tiwari@oracle.com>
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|CY5PR11MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc422ca-d97a-44a6-a4d3-08db10348843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXiSZmG8Dxb4rD+iztHozk2KIfDTgDtD1hZSKX4MrqhPh5GVjuWULsbmH8xC5PiEKKVe10ItSPvqMK1wZvBaFUWew8bIprtb5CAZujCWclY2RNKcYBYi+tKoJ6itEfd2PO/eP8Lg2a3vuenVupJpn9L6Q5B59oQzLk9xHmdxJFvYfQaqGrbBV5DmpabIvNAuSLxEsB6dpRU5uggQ1BwWoiWLWdl3Vf9INAMfSaAuYR+VWJmMqK4K6qZDUXJsbTvRidTegub09xsqkwY6NJWSisRZHkADEUCmpOGjFONqKHHJvnm/4jvnc0WedOTALs51SJZV5+Hb5Kof390uYojovQvz/mYaJK6QRciO7qorNrG1FtRhonjlR+WdC8MC/y6ePOonbpba/cgCkKdTXImxf1BWilvAMXKL9KD5geCxZFYwhRpbfo3rO5VZbt85h/LsIfbbcRSXUpt6SnAdonZTS+2qtawNfJW+H9DvWSoSDfoDFpN9UqKe9OJa6mI1iSR4Q74KmeM5SqL6Gls3AdX4gFLH9iOS1JWzh2DtDTbniuQOqW4fBURwbl8i3K7Byjb8ON+jxYDNOg41Bmjp2GexxA9B8vQpiVQ69bP2lzb6l9zywIdo9LcriJrVNcwzcs/U1+DuVmISyzLBrgJlnzqHPmbeXL6zH7FtZ9BeokPGkEuTSKxSkE0+HKz1gVQlXEx2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199018)(2906002)(6916009)(4326008)(82960400001)(316002)(8676002)(66556008)(66946007)(66476007)(38100700002)(6486002)(478600001)(966005)(41300700001)(83380400001)(86362001)(7416002)(6666004)(8936002)(26005)(186003)(6512007)(9686003)(6506007)(33716001)(44832011)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHI5Tu9Zw3FR26HC/2oKja8ZbBrV+5nMz+xPIhenpHoicoFqT7FKokWoGxbk?=
 =?us-ascii?Q?G6proA6XXG9W3RKapeDREYTl0uM8AmTHo3FfUvf5Cx76d6lxmsXqGtCBvKvB?=
 =?us-ascii?Q?+XTWKtBQXmxKicNxUTOpr+MfuKTiSUeMeGgagAqw3rwq942EMkqISCdEzJx7?=
 =?us-ascii?Q?2Ej21glL7DGJool7bz1DOAiWVVbWvGquzJBPzvyrKZIXAH0AWwocGuy9B14F?=
 =?us-ascii?Q?6nJGpiQ02O4InMJz4D5U9KdohW0KXafgdkaGGDWUxXKMKByJuCH5iPgNwVFG?=
 =?us-ascii?Q?5t5DlR1m2or9nxNqsYYHsI039r9w0b9+dXGk8+VVSAGl0Wvra+yNLXhlaVdR?=
 =?us-ascii?Q?xYRUa4zKwvrHK4wBYShkH2USeAAQjC5zj+p3aSPMeaLQ7zvwSFFLOzqhQNr6?=
 =?us-ascii?Q?P64gvA3DR+2ISHCI7woH21L9zR01uCRA1pWKq+Kgmsv0HVbzAijCejrTBQoo?=
 =?us-ascii?Q?PDTmfdYDFyXYdDEs3lJEnYzl2HKa3xXvjWEbAy8KePF2r7gtOBswNPdoOBt3?=
 =?us-ascii?Q?rB+xibJOvjLXhsIbeUcHfANMdxaFbG6f56dIBBjzwuNnLcub2734f2tzUUMN?=
 =?us-ascii?Q?1Bl8MIYmQmQ935aXEWOq63gjoiksHJwl9pvtK+bDdwb88GRo63eEOVyNwFyA?=
 =?us-ascii?Q?y/Ybk9yqK2ElT1b4sHzHJ6FZASm7Jp9FhPlGfFRpCJ2/A7Pl6CO2NgtC4zUi?=
 =?us-ascii?Q?6Inm0YVBqR5+v2GzkFF+gXnVSmHfBbFX6/48wwP3+WMSXgTstRQ958KXvTkq?=
 =?us-ascii?Q?yMhjpBiGD6jW3A5EsraCn3uHOFP3f/7sQ/d38PMT1EEn0q6zkkpTTdJI0zq3?=
 =?us-ascii?Q?93IeDZmGUUKM7GjPLVLjGU9xmJ+08dh6jLhc89r6E/e1HJdJB5GB/YNNHn2O?=
 =?us-ascii?Q?suxr+tELW/1pDrCiyptLxSkcsHUf2ClrCqgzrmEoB1W6BuS2JZfECL7jhA7Z?=
 =?us-ascii?Q?fwkxsX3rGuL/nitjHOZ5055X24qDi+/vTKZjRbxloXzwu2d7PHRTkOoyy9F0?=
 =?us-ascii?Q?bHlTKUGro+w688ESXXWeeS4iT2Be6KWYTtNpdLjuPblWQZjNW+0ZCRUOVHh6?=
 =?us-ascii?Q?3sga9dfBqjQ/Wt24BwkVUZ9WzSlyhVOLHSXz4awi9W0RNHCmxULr+7edOe5f?=
 =?us-ascii?Q?BWIlqDp8JewWbeHW/1G0JeduW5G6lzz5trADrOREAvW3LCfkg/1eZ5Fk8a25?=
 =?us-ascii?Q?ZEqhe75Tk77fnokEj1v1MgiuJKZ06m9Kohrqd8JyYpYHa7oSY5jMMOwBQO4N?=
 =?us-ascii?Q?QGb8QT7LqZfxdCuKyfeBusV97ROj0ITNse5/Ozp8vYgJTuNK9Xx5Kb3Pbahw?=
 =?us-ascii?Q?A0P56UVMx4QDy64vH0ZQz3zotzPxKgBolswoJyYPDm+j48LcUx0Wc7lNxOE7?=
 =?us-ascii?Q?d7ObyAlqXQ0OrVwfP1y7LZ+CIK4camYPoSPv2AvTrAWCFfAc1sUcDmRGbDtg?=
 =?us-ascii?Q?qBDY55+wJOErl3GrCX+cfBhSDhYNKDGSyUjWBypiN0IR8d6W24jU+R0sik+D?=
 =?us-ascii?Q?+gWlnePk8iZGWCeGjLgLHjUMh9jzEtq9qvQCI2v59L9d89mQi+VwM7M+AZKd?=
 =?us-ascii?Q?ADtyd0CykmaNmo3X4DOJgNJnCXosdhBN7EQ0hw7gJtegTavpkZuzWdV5MDu6?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc422ca-d97a-44a6-a4d3-08db10348843
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:43:21.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsjX9MWmUZvrwJhJx2UTkYHNkICSPscfQlAtuf4AjwEB753U+5jauM+LmCWhgQ0bfrLroF1VlmG6Deyf4qOHQLW7zLdAhz5jPucFRVbj1HE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:49:40AM -0800, Alok Tiwari wrote:
> A possible case of null pointer dereference detected by static analyzer
> htb_destroy_class_offload() is calling htb_find() which can return NULL value
> for invalid class id, moved_cl=htb_find(classid, sch);
> in that case it should not pass 'moved_cl' to htb_offload_move_qdisc()
> if 'moved_cl' is NULL pointer return -EINVAL.
> 
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Conceptually, code looks fine, but it probably won't be accepted without:
- imperative verb in the title
- tree, to which patch must be applied [0]
- more nicely written and formatted commit message. If you are referring to a 
  static analyzer and not to common logic, maybe include, how the warning looks.
  Separate your text into sentences and paragraphs.

[0] https://www.kernel.org/doc/html/v5.3/networking/netdev-FAQ.html#q-how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

> ---
>  net/sched/sch_htb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 92f2975b6a82..5a96d9ea3221 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1601,6 +1601,8 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>  		u32 classid = TC_H_MAJ(sch->handle) |
>  			      TC_H_MIN(offload_opt.classid);
>  		struct htb_class *moved_cl = htb_find(classid, sch);
> +		if (WARN_ON_ONCE(!moved_cl))
> +			return -EINVAL;
>  
>  		htb_offload_move_qdisc(sch, moved_cl, cl, destroying);
>  	}
> -- 
> 2.39.1
> 
