Return-Path: <netdev+bounces-8612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1344724D43
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BF1228105F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF8C23C86;
	Tue,  6 Jun 2023 19:42:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AC1125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:42:18 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1503B10F2;
	Tue,  6 Jun 2023 12:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686080536; x=1717616536;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rTfcnLX6qFJYvlxnvR8lA09JO/nPrSlsu5B0AItwRiY=;
  b=Ztx4bHhprrjD/Dh3kPsTl3OZUN9M0ZxO9nv2IbTecxXNHtOwkMraLuHR
   AVuW3Ye2+vTZeZzxH6fFPNzLUqCOBd3h/eFUOmGd/bThsOSwoJvXnoMf4
   3T7CcJoDiR16w4Wg8GWM4HGRmrDVrgnzHFzwROfkDvPNdHQUG/rZwfst1
   OZ3LcypBtoVf3SBq89bWBn27yXUHprDDbTiC11m7XXFakaDzSs2En/SbO
   942/zRU0CZZCchxAPmbcgucPjI4RqunvjUWkbGq7Op+hV848U4w6GhuaF
   Yj6K+mg2MeN4oGTK3kCjHm1NU/9Cw524tDgoo/HkBNY+AXHezGw21hb7c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420330766"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="420330766"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 12:42:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="1039309526"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="1039309526"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jun 2023 12:42:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 12:42:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 12:42:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 12:42:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 12:42:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az29imoZFkX8O3Z2z1zhAP2F3ITSoZVkYsQfG7pCOF5rdbnO04tJI8qbeplGFV/K0TAWD7LWJuPL97YSlMKMvuZ4dpgnp6CM8OP11HJNoXqzqUMTkT29UwrkaOs68nour9phTpH3Vaxf6EUnGrxw4oFGSwgLKpMhCGfO92vTB3BW8OPs5t2knaDyXfwcNuEilM5Oc0BBQMjSvKi6LFFH4/BGOJ1vGfv0JKhT3vDKEe5vM0sw6qgs36zdwIAzIfA0wnpDWDMcO8Hk34ZMyawV8IIDtSeNRvV9J14Psssjw93hYg9Fwbl3kkgwEud41jE02cJ9A0ehqIMBVJdED3vS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAHneaml1k2F0biuGMSYsV7NeTZ/4WoAijkimNEa0VY=;
 b=n+AtVQ36GRM1J+xfUH/1VzDgTZE3gQt3RUamWsojVwFmGMFjce17TG0ooZ3uerpxf6Fe/iSK59UnzhJtzcG/6A/BSop93HT3lmaO/cO6OPxBJ625+/n9oJWfYcrYDV+C4hMTPAnjEAJkllHeAgIFEE1YC6+lqfPSm42vfMEHJMuqv3cp2NuHbxt2qtH3tN1YKd7C69cbqTExLNl4ExnibdkLVoItsv+mNMj2O8kLvVpM5Yd7+h70sTyyiLoDuQz1BkpzzqnoVYPKibZ2ky2yskVppj88utM6WQ/wFYOGjwpapNasPy7MbXqT7AwJkfatHJ+LHGkt2zKO5npR/o1NSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB8574.namprd11.prod.outlook.com (2603:10b6:806:3b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 19:42:12 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 19:42:11 +0000
Date: Tue, 6 Jun 2023 21:41:57 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: <wei.fang@nxp.com>
CC: <claudiu.manoil@nxp.com>, <vladimir.oltean@nxp.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
Message-ID: <ZH+MBdlRAybwqFo8@boxer>
References: <20230606084618.1126471-1-wei.fang@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230606084618.1126471-1-wei.fang@nxp.com>
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 708726ff-5abb-4423-b67e-08db66c61f17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: basAjrkYjWlW3W191LvhAFUCSV636Zs7xxfEINqq480j2ePJOIkGR9kNwhkS0OakXQp01AxCM9C07P+Eo3qLe16WBpt3fYvwrUIryAE8xFud9HL41ivQpb1kMGHks/mbqRnFYxCa1CjoOJBlqs/WT+alifZzesPxTKny9i85QPC7ujVAhsaqTfT1gVwwFzjuRFeWOgZtP1XbA0fHKjbJKRIhK/iajeewwtQTUkjoqFVRVH/woiJtY7HEH7TTKzBg92SHzTsZnuFYWVuzpDMlds2OpLt4RwYuW/WcFnSIvt7eycoNUL61j/ydwwQzfjuSluBkHIMoe+oj1GHEvdteNAYR6znDGNfLCDJaSvzqs9ErUxIwHPd9n8jYLTWOgBSg1tM/hFI6KvOBm+aLXqvdopWmVVzwK/NU7EsujG8wUixkIq+gEsqKaVwuU7iYsM8ADxaT2QRJzFh1/XykhhCivhDF0SX1Xj1y9SO4BIMBvyJYvHk0YD6GJ0L7BzM/Go16LjJIMGKGIabh/EmB9xYJP+zrXX/5lGxh8cY0PzYVPfSPHLqgq2UJBlg4SE9jSkZLRqr9quddjZYWznM7qpDxaECgy6okdoFJaxn8XbGRjdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(33716001)(6506007)(9686003)(26005)(186003)(6512007)(83380400001)(6666004)(6486002)(2906002)(8676002)(8936002)(44832011)(82960400001)(478600001)(6916009)(5660300002)(41300700001)(86362001)(38100700002)(66946007)(316002)(66556008)(66476007)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CFrs1Ls/jbGlp2182UPwCEDHV498T8/0DQcQ4/XK/AGkR7zKdgpDC+mLUSLb?=
 =?us-ascii?Q?+ipffilSniDvreU7H4TiDPpun9z1AVC1Oe7Rk3KsZdVuhAYWmJozTaokEDxZ?=
 =?us-ascii?Q?Et7cvvzx/FQdywzSd15Gh2PdS71BxE9n8LdN7YO5UN8XGe6vuHz8LARF5wvx?=
 =?us-ascii?Q?FqqFeCtpDtyOFUi05QcSlAoHIRo1TG5TWhUb074B6a2Hjjk641J1v3I3kQAo?=
 =?us-ascii?Q?JsUion/02zyagwTjb3jP8vigReQ0KTUPceyum5apNIQiR9Bm0mj8PfMXAxB6?=
 =?us-ascii?Q?c4ZyNp/35dvBb4RnD0RtFvlY049PyKzJ2BxJLwRLCYkt0T4mZ7OzFpXMYrx9?=
 =?us-ascii?Q?Kw8QGhkIMQ6QEMjf0a8YP4IE4LEG/o4KxsugwAMz1jk2MVKSW/OOL0pCDPlV?=
 =?us-ascii?Q?UtWSJaLZ7jH7As8ph5g1swDwUkxbhiBivw8n38hPMBvdDadG8faapsE9AaX8?=
 =?us-ascii?Q?EACRyBLWJ6aiAGAcZurVb5rIAKDV4GkkwdcZ2gLcC9+VmCDCRqQ/YXVDbzSB?=
 =?us-ascii?Q?y4/apActsl4ceEQArklMgw6g37znPL3vinQR1nD9UbXzE4Qf4PTkPeR+A+iG?=
 =?us-ascii?Q?7CJJ4E791eE4E/gUT21EcOQrbxa4tSm8lUyx2jItm7GFryG0erxV/sJ3ZpFw?=
 =?us-ascii?Q?KrDCJJULM8FfaNc/C5HC8fz8y63xRFaBeX7oD8GuPlZusp31K5eh7ydtASul?=
 =?us-ascii?Q?yXTUkTDa9K736fi2di9LzEYA2QNUYn38UwcYYgz64O7PQPLZCiLmjXGHnmXo?=
 =?us-ascii?Q?qjZ3mepi+sjKPm9qrWUDNJfyFxzKhYPi2GeWst5WvIbZIvyeqAdiba0sTzSL?=
 =?us-ascii?Q?aJLsjnpIvTf+JZXPTGqbvECXCrXXazNQpKXH8Tua1pUgrImVsSxEmz26SZmR?=
 =?us-ascii?Q?8weSzGLNvmCkZec79eaYb8Zr6WnM57kYA1p1ZRlfWi7G9iibbtnlE5y1y3y6?=
 =?us-ascii?Q?HJ2JKydA58X6ROBC1A9LV/GTulbm/TFdfF9UpuECnTz2KkGnZebWB5c4VgtU?=
 =?us-ascii?Q?vgyVZ0qLj1qnNfxSJEHUa/wA7Y0N220yGgz6tRuagv139SWYk6BMeARLdkY+?=
 =?us-ascii?Q?yCuzKDy3ZEJZsKIGtpgxa0VXquIi+BLyivUn4fcArtICJA1GsE6CpgyxWP5W?=
 =?us-ascii?Q?3eataacs9Svz0OVyWUuzUkeO9CeFcKZZ4s9wpIJ9clPEqw73P1aN003k3V5t?=
 =?us-ascii?Q?X49gEIWdhunF0gYe2WqmmK2kfPU7PebbKHMfPVorkIlZ1LQMiAg/yLEiasXO?=
 =?us-ascii?Q?yIHYVCd8EPFs6ijJhPRBhfH58ItANs89rSFvsdgvmCR+DuuPW/HlZ/JNEqdt?=
 =?us-ascii?Q?V4oyJLmHqqyv652cyGhoJTNmj7D1180g3uTEU0ziaDNdoA1SJVLc9fuFrlH2?=
 =?us-ascii?Q?vWIwehNYJSf2Vposfz6j7MMU7I0433AQy6Jp+2JO82NAw36IHUUTrPZf2jeu?=
 =?us-ascii?Q?ItCS3mBFZIIH2M0TGCU0BCU17z79olkRJiV14q3v3sVf2g6QcxwjM6xzObOi?=
 =?us-ascii?Q?n79m7pWXEW0dD6A0QJz4gR9PocuMZgfuNBZgWdVnlJ+WMup9+fA8+iphTcDq?=
 =?us-ascii?Q?n85CypjAtSZUP64qdlif/HA1E429fu9dJpiJcndbq4kcBfGmHOYROOBRcuY/?=
 =?us-ascii?Q?NvoCC712Q5m5qqGcQ0sh/R0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 708726ff-5abb-4423-b67e-08db66c61f17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 19:42:11.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXvl3P5CdU7b5ZT+5uY6m6K5ngakgOJV8HiJWkh3XlJ994FVnNGv0GQyELipr4you9qrMDNqXfI7zNShk9OkE0+q9+6YpbS8gQp1WaqzBi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 04:46:18PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>

if you are a sender then you could skip line above.

> 
> For ENETC hardware, the TCs are numbered from 0 to N-1, where N
> is the number of TCs. Numerically higher TC has higher priority.
> It's obvious that the highest priority TC index should be N-1 and
> the 2nd highest priority TC index should be N-2.
> However, the previous logic uses netdev_get_prio_tc_map() to get
> the indexes of highest priority and 2nd highest priority TCs, it
> does not make sense and is incorrect. It may get wrong indexes of
> the two TCs and make the CBS unconfigurable. e.g.
> $ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
> 	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
> $ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
> 	sendslope -900000 hicredit 12 locredit -113 offload 1
> $ Error: Specified device failed to setup cbs hardware offload.
>   ^^^^^

newlines between commit message and example output would improve
readability. tc commands are awful to read by themselves :P

Please describe in the commit message what is the actual fix.

> 
> Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 83c27bbbc6ed..126007ab70f6 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -181,8 +181,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
>  	int bw_sum = 0;
>  	u8 bw;
>  
> -	prio_top = netdev_get_prio_tc_map(ndev, tc_nums - 1);
> -	prio_next = netdev_get_prio_tc_map(ndev, tc_nums - 2);
> +	prio_top = tc_nums - 1;
> +	prio_next = tc_nums - 2;
>  
>  	/* Support highest prio and second prio tc in cbs mode */
>  	if (tc != prio_top && tc != prio_next)
> -- 
> 2.25.1
> 
> 

