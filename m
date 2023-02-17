Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9469AA7E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjBQLfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjBQLfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:35:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B7328D31
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676633740; x=1708169740;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y5ZfWn22jjGkwbBLGTlN5SXJWn5XMItoFMDy1oVeg3k=;
  b=UEtnt79cP4A1TqK0Vn5PAuCC+zqnTvYbDQUGNmX7Ul1WuAvQP5NS9yIk
   8pm9xn6SXe4DgCQIQwegQSHBwFokm1AvjhjxpcBXX+zGWCic8mf8w/5nU
   Z7BiLa7UrKwBu7F1AAWutVpCJkKW4gauHeZkubm5Rfl94sNKRXwIbpPSA
   bsMLtLbdHZn6+CuITwMa3EluTgFkHzQPMja4kQ61Skp0rqAa9/jtWC2yR
   6YuojBuG5pG/6cNr5XthzlATHIOUswi2HP4R3V+t3np+Tz9+Yg+RnsTVA
   or11h7GcPxcbpuA0V0NEb9x3MRGpkFvIQGObYmAiLj63WyxNiumXzdJVM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331970021"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="331970021"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 03:35:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="648052860"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="648052860"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 17 Feb 2023 03:35:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 03:35:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 03:35:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 03:35:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 03:35:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMuJrkSJ6xlAl6cZHg/KqSrzlU545NiwQkm/8N72PcSfEUvOQQxYEX04MJm0B5el9PUSR0B94zNaDTKK9016pHuD9MoPOdm6cJlxILq12v8JAQ7FOFewa1C3HjGETTJx4QR0WCANE7YQQzF8MalE67dQNHeoTk94Cu/ibeOjzpvvK0HdqtqW7aLFDfbQ/FBkGMziEkn0GACNs5V+XXc94kLdBuHdLzVhXxEuOanySmODVZ48p5mTEmGb3HCVpLiD18DkQGY8xH6cDBzgTqSjN+3SNxbRAuSNrtQrGEwJimxRkTPZTuuRSyVX4tvbDfvH+taXyt7kXwBCQ+wxHDy7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPvQMp5dxHzViaeqCIn3d8xzZODsmYJ6VTqe0EGUK0A=;
 b=dBfXxran4aPc9t3rERL/+wOxsyN9xkrOabjzMadwKrCzZziGb8I+CvzBcjrT/ecyd6fKFTVA8TBZ+ZZ+vuSr9yjZkVaCmFhJF2raCsZmex1IGPZxUYQUCcUMFcXnnTT1CDyr4O7NPH+eV21ewNhiZiqaARR7tCwT6Dnf6fYKI4D0qGEmkojeSJpTMOh5tBMMGixnHXVb38zoHN+j3hTiGczXr3fZ4J86Mn8tnvrJ3F4F5jsbhsbRbYcwcNMv9nfYv9SrM029uSu45LHtTty1pmdZ84yNxCeM3XxOViy/BjcH6EXVQQj7ZCElLCrDMB1AN/98kc8bz6XWgAAdtxJUDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5614.namprd11.prod.outlook.com (2603:10b6:a03:300::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 11:35:18 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%8]) with mapi id 15.20.5986.019; Fri, 17 Feb 2023
 11:35:17 +0000
Date:   Fri, 17 Feb 2023 12:35:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vlad Buslov <vladbu@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [net-next 5/9] net/mlx5e: Implement CT entry update
Message-ID: <Y+9maDuUVcqPm5oM@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-6-saeed@kernel.org>
 <Y+5Q/aWKY+HO83A1@boxer>
 <87r0upwmkp.fsf@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87r0upwmkp.fsf@nvidia.com>
X-ClientProxiedBy: LO4P123CA0182.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9fa377-6cc0-4413-066f-08db10db0b3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKHmveQ14DikMVQoiGzbc+GV61uStHTUTlTJXxdYzZCjNZC8lD/NNT3r8OD+gxacLzSg1gPnn5NHnG+qQqw5VMD2Ok/D+ptmxF7fqj3rJ/osKJ6BSNQZ24VY3UCQGY9tetAq0FsW4Vo14RqnnkzJ1RYoD0qag7OFHp7MM/7j8HEqQIsdrKtkbBfcEwHttQNd9g6WEGuDxVBJA3J5KGj+/4DzI7BguZ1lc/10Hqp5VnrEx/0WSZlQrxUZCEK2q+zzOZs/CsVNaj/8uD0QSCa7CNqgPIMzEdKwdiMzixN5MSFyKI4mxOXpOskxP1IIf26seeGdGaU0m/zREVSUAi0nVXlXig+17SxAhjTzc9NrFDrTR+sECp/3Pv3poJoDdeaudSPxOvHAnmEEmeC2vtYRSjtfefqPXfNmfhVbvAwTZOLSwfIDAQg1X+GHyKFE6ezmXByERSSFbpm0FxyU1tegBrxB1NCo0AGVl/4HfreqzwnIx/uTjH4FW4fMmHHG7buAYvm/GMWceZFBSXJCGvAQm3/ENVRk6bu8xJhTdt3zohesLEcgtKwB7IIbJdNzIgU6XKATTPPF3jHXAYBN89E2CBnbM31oo9ujrXo1xv/XwM9VIocY/JaRpsLh4SLrug3tZ+y5PYd6+yuHYJGSYkC80U7LU+NNPez/OHbDqadKqttreWfKvga06FfnromrbRvb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(4326008)(66556008)(66946007)(8676002)(6916009)(66476007)(41300700001)(316002)(8936002)(54906003)(86362001)(7416002)(33716001)(66899018)(82960400001)(5660300002)(44832011)(38100700002)(2906002)(6512007)(6506007)(26005)(15650500001)(6486002)(478600001)(6666004)(83380400001)(186003)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CzIAqs2Ld3NZ4YzN6qLQyM3x9Llok46Der733IH20YSk3jg2csKszo0owteO?=
 =?us-ascii?Q?6Rf6oh9CEfVpqcPoX0WB0sEL65f5hInAcJWLL4JZ7jB2qQeARR/FURyakMCq?=
 =?us-ascii?Q?iTefN22Yq51aoXjwXDsWsSy6dDqx0hRmj5MTpciIltsi+LdtuT3O2/qMsttd?=
 =?us-ascii?Q?rQUm9BV+bDMfasHj8xhfRN+Kp8Yn9xxZsCPxMdAsrSM9hOOvajyegrjp1Yik?=
 =?us-ascii?Q?9m3ZOdzqldP3t0sBS/mrNyt/eLKkWGnoDLepeCXeWR33+d0fSE+bHAmXjJ5x?=
 =?us-ascii?Q?BGK0uTl65cHd2xBakWCwzalDrF3mWt5H5XV4aGCVNpSLFZO8Q55+qJMJ85nh?=
 =?us-ascii?Q?SCDayEyDggvldNn8nbM55f1hIAOljx0ubeutKSvEs8RqJArhdkvTAZ6OookI?=
 =?us-ascii?Q?qH3gwHgg4Aodcyc+fCa6F6YNDADK+KLiF1cW/WeUGtuubMIGtrcrmwTVtWDd?=
 =?us-ascii?Q?nHw5OAxvkK7WVlHJ/xNFRLuvRfHzAuH1yTsEj99U/OQgnAZD3iGoRiAK5I6q?=
 =?us-ascii?Q?pHgwvQMdjtAQSEvnqKRsk4HXSL9oFogmaZiiJnS6yZwF1qCBPepJPjGgws+v?=
 =?us-ascii?Q?FBpaG50hscuKj/Wi34lDoJbXOCnuST4VGmkD6jprVp+iAprPF03mfXWuPQfN?=
 =?us-ascii?Q?OIlbEPePbIpYzWBnqxPc4tsZhUBg7jf0QwCis8L1uynCQWciJzSdLzxTB8AG?=
 =?us-ascii?Q?sgCTbIRIS+eyGmed+enZ9qY/UNmEAKbkX5+5yGgTgGqHcxtPIEn6AGwjnO3t?=
 =?us-ascii?Q?VkYLCiz/lSMvhQKGAC+SEGb9179CGzixvgu1MFf0lO1H6zhv85eHklF8JP2H?=
 =?us-ascii?Q?haN93o4JS6CcEMBL4XrkOjEYEihjyZWpNxOZpUPDvb/SsUjehZ2eTAQwsB7N?=
 =?us-ascii?Q?Nj+cu9qhNvIAKsXYw7OzMZXI+aOygOtA8+vF0MxdtHZIFGPLJ8Sh3QZTWy8H?=
 =?us-ascii?Q?1ujotmAFJsiZ93sJdvnn+cwN4IGTVIJtXybfrN7FF8G05SHVJZxRPvFblDzG?=
 =?us-ascii?Q?g55z7NnUa8x8PJ/4KIWuVqYf4a+8n25W3Eit6RkKMnrVeHkdCBGU/KklMizl?=
 =?us-ascii?Q?JxgiWbZM2wWJfD2aiStdRywLj6L5VHBBMx00F2FJOYNdLiHDU5iFp6LSLxH1?=
 =?us-ascii?Q?SA+3+QH10MTv91Rf9R5kvvs2qqGt0Fntg6G2zbCAr434qsc83U8IQIG6vrvi?=
 =?us-ascii?Q?lDr+VAMFyM3/Cu++MCITeSFt45WAApUjiCLI0/pRv4WiYUqDemMAO4rdn1w+?=
 =?us-ascii?Q?wtvfpKuKJd8+e0rM9GbzZ/BW0GhfkTFTMCgoAATEXFmF+aQ8D8+DHVReyDYT?=
 =?us-ascii?Q?xm7l58Slay6cDDHczwb/IcR+HSAQca814DwAug8TP/IyN89s4bPBJFEPVFTv?=
 =?us-ascii?Q?7SjTCRqBYiYqYKJTKeOeU8CT3oZA5x7VPlS3N4Jgbaz/T91TiMHToNPJT1xk?=
 =?us-ascii?Q?YAn5e00IyclTz09nCLsEGbnuNJlM25e6ksr+c7dUOt/JDoNBFUNJy/9ZGdbq?=
 =?us-ascii?Q?9kEMLnyoD9R/yCmWUun6i9u1pOz/Rrp15wWhIJvgxhwKTr4T32HdAN+g3wuo?=
 =?us-ascii?Q?trowx95KnntR46t7lJzrvzwxdaZCQGdkVvhNufzDOd68jwymRE3wrdhEoQ65?=
 =?us-ascii?Q?pbpmPO8Rvpx0B+SsoZ16QRc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9fa377-6cc0-4413-066f-08db10db0b3a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 11:35:17.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scsK1kUsVAC5YeVNhADQmVA8nykBT5gFaQ3ra0dDoZ9SrQdnK1SYReu4WBwic5DZIqgtVokKvwXvi4HArv0IyCRiaGOrPmKis9pdEF8NhHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5614
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 07:15:13PM +0200, Vlad Buslov wrote:
> On Thu 16 Feb 2023 at 16:51, Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> > On Wed, Feb 15, 2023 at 04:09:14PM -0800, Saeed Mahameed wrote:
> >> From: Vlad Buslov <vladbu@nvidia.com>
> >> 
> >> With support for UDP NEW offload the flow_table may now send updates for
> >> existing flows. Support properly replacing existing entries by updating
> >> flow restore_cookie and replacing the rule with new one with the same match
> >> but new mod_hdr action that sets updated ctinfo.
> >> 
> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> >> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> >> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >> ---
> >>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 118 +++++++++++++++++-
> >>  1 file changed, 117 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> >> index 193562c14c44..76e86f83b6ac 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> >> @@ -871,6 +871,68 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
> >>  	return err;
> >>  }
> >>  
> >> +static int
> >> +mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
> >> +			      struct flow_rule *flow_rule,
> >> +			      struct mlx5_ct_entry *entry,
> >> +			      bool nat, u8 zone_restore_id)
> >> +{
> >> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> >> +	struct mlx5_flow_attr *attr = zone_rule->attr, *old_attr;
> >> +	struct mlx5e_mod_hdr_handle *mh;
> >> +	struct mlx5_ct_fs_rule *rule;
> >> +	struct mlx5_flow_spec *spec;
> >> +	int err;
> >> +
> >> +	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
> >> +	if (!spec)
> >> +		return -ENOMEM;
> >> +
> >> +	old_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
> >> +	if (!attr) {
> >
> > when can attr == NULL? maybe check it in the first place before allocing
> > spec above?
> 
> Should verify 'old_attr', not 'attr'. Thanks for catching this!
> 
> >
> >> +		err = -ENOMEM;
> >> +		goto err_attr;
> >> +	}
> >> +	*old_attr = *attr;
> >> +
> >> +	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, &mh, zone_restore_id,
> >> +					      nat, mlx5_tc_ct_entry_has_nat(entry));
> >> +	if (err) {
> >> +		ct_dbg("Failed to create ct entry mod hdr");
> >> +		goto err_mod_hdr;
> >> +	}
> >> +
> >> +	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
> >> +	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
> >> +
> >> +	rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr, flow_rule);
> >> +	if (IS_ERR(rule)) {
> >> +		err = PTR_ERR(rule);
> >> +		ct_dbg("Failed to add replacement ct entry rule, nat: %d", nat);
> >> +		goto err_rule;
> >> +	}
> >> +
> >> +	ct_priv->fs_ops->ct_rule_del(ct_priv->fs, zone_rule->rule);
> >> +	zone_rule->rule = rule;
> >> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, old_attr, zone_rule->mh);
> >> +	zone_rule->mh = mh;
> >> +
> >> +	kfree(old_attr);
> >> +	kvfree(spec);
> >
> > not a big deal but you could make a common goto below with a different
> > name
> 
> You mean jump from here to the middle of the error handling code below
> in order not to duplicate these two calls to *free()? Honestly, I would
> much rather prefer _not_ to do that since goto is necessary evil for
> error handling in C but I don't believe we should handle any common
> non-error code paths with it and it is not typically done in mlx5.

ok it's fine as-is

> 
> >
> >> +	ct_dbg("Replaced ct entry rule in zone %d", entry->tuple.zone);
> >> +
> >> +	return 0;
> >> +
> >> +err_rule:
> >> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, mh);
> >> +	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
> >> +err_mod_hdr:
> >> +	kfree(old_attr);
> >> +err_attr:
> >> +	kvfree(spec);
> >> +	return err;
> >> +}
> >> +
> >>  static bool
> >>  mlx5_tc_ct_entry_valid(struct mlx5_ct_entry *entry)
> >>  {
> >> @@ -1065,6 +1127,52 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
> >>  	return err;
> >>  }
> >>  
> >> +static int
> >> +mlx5_tc_ct_entry_replace_rules(struct mlx5_tc_ct_priv *ct_priv,
> >> +			       struct flow_rule *flow_rule,
> >> +			       struct mlx5_ct_entry *entry,
> >> +			       u8 zone_restore_id)
> >> +{
> >> +	int err;
> >> +
> >> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, false,
> >
> > would it make sense to replace the bool nat in here with some kind of
> > enum?
> 
> It is either nat rule or non-nat rule. Why would we invent an enum here?
> Moreover, boolean 'nat' is already used in multiple places in this file,
> so this patch just re-uses existing convention.

This was just a suggestion to improve readability on callsites and using
bool as an array index was a bit odd for me, but that's related to
personal taste probably.


	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry,
					    NAT_RULE, zone_restore_id);
	if (err)
		return err;
	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry,
					    NON_NAT_RULE, zone_restore_id);
	if (err)
		return err;

above sheds more light on what is going on instead of opaque true/false.

I didn't realize it's the pattern you're using throughout whole file, so
this change would be weird per-se, maybe consider such refactoring when
you would have some free cycles... or just ignore it:)

> >> +	if (err)
> >> +		return err;
> >> +
> >> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, true,
> >> +					    zone_restore_id);
> >> +	if (err)
> >> +		mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> >> +	return err;
> >> +}
> >> +
> >> +static int
> >> +mlx5_tc_ct_block_flow_offload_replace(struct mlx5_ct_ft *ft, struct flow_rule *flow_rule,
> >> +				      struct mlx5_ct_entry *entry, unsigned long cookie)
> >> +{
> >> +	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
> >> +	int err;
> >> +
> >> +	err = mlx5_tc_ct_entry_replace_rules(ct_priv, flow_rule, entry, ft->zone_restore_id);
> >> +	if (!err)
> >> +		return 0;
> >> +
> >> +	/* If failed to update the entry, then look it up again under ht_lock
> >> +	 * protection and properly delete it.
> >> +	 */
> >> +	spin_lock_bh(&ct_priv->ht_lock);
> >> +	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
> >> +	if (entry) {
> >> +		rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
> >> +		spin_unlock_bh(&ct_priv->ht_lock);
> >> +		mlx5_tc_ct_entry_put(entry);
> >> +	} else {
> >> +		spin_unlock_bh(&ct_priv->ht_lock);
> >> +	}
> >> +	return err;
> >> +}
> >> +
> >>  static int
> >>  mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
> >>  				  struct flow_cls_offload *flow)
> >> @@ -1087,9 +1195,17 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
> >>  	spin_lock_bh(&ct_priv->ht_lock);
> >>  	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
> >>  	if (entry && refcount_inc_not_zero(&entry->refcnt)) {
> >> +		if (entry->restore_cookie == meta_action->ct_metadata.cookie) {
> >> +			spin_unlock_bh(&ct_priv->ht_lock);
> >> +			mlx5_tc_ct_entry_put(entry);
> >> +			return -EEXIST;
> >> +		}
> >> +		entry->restore_cookie = meta_action->ct_metadata.cookie;
> >>  		spin_unlock_bh(&ct_priv->ht_lock);
> >> +
> >> +		err = mlx5_tc_ct_block_flow_offload_replace(ft, flow_rule, entry, cookie);
> >>  		mlx5_tc_ct_entry_put(entry);
> >
> > in case of err != 0, haven't you already put the entry inside
> > mlx5_tc_ct_block_flow_offload_replace() ?
> 
> No. Here we release the reference that was obtained 10 lines up and
> mlx5_tc_ct_block_flow_offload_replace() releases the reference held by
> ct_entries_ht table.

thanks for explanation

> 
> >
> >> -		return -EEXIST;
> >> +		return err;
> >>  	}
> >>  	spin_unlock_bh(&ct_priv->ht_lock);
> >>  
> >> -- 
> >> 2.39.1
> >> 
> 
