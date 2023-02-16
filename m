Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2610699942
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBPPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBPPvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:51:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3E65355B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676562709; x=1708098709;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uT+cpevWC3cb397wTGXJYojfGISvq3kbYu2sSmHgKhs=;
  b=OeyDKuCiEv1mNCf2xEg7Cb4lnKZ9XMfaaVwPtrcE5TRbX5plLxs0Jffm
   TPmLlGOlIlQ+f981tnZPb6/TCzC525HTw0UZ8pBExppQm45EFR2uoiY7Y
   UkKpC75BINBWHQkXCq82q7vYmzVN+hulVWufShMmmrGG9h8fVKutHkq7k
   I3LB33H9GAaGyGpOxHkYrU54ofXEjk6r9atdl/Tb+fFHYx4uhuOgKh58c
   VmN5TbpA427QGShuZJMKcbpefKqpaIwDplF7Gl4JNvoJ00GvdGuy2u7NV
   8McWgyJXiYcN1OTWh5G2Ty/JrGMI/tu2Bgc39lUWd9eLGYONFrrlGnaxI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359180742"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359180742"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:51:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="844183313"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="844183313"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2023 07:51:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:51:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:51:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:51:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWB2zVRE9rPlTPx4u03EvkaCeyYr5C8nVQISU+sdkZperUtWJjzjFMzbVca6MrxOvwTwbmdVmSuEDDHzwTl22WtUcy/4mHmPNdhptx0dEfIKUB8jAS9syrK2phTSkMgaUUCWahpMfWmrxsduozIXOaT/GKA7wTYeSQ++8LVcRhBA+RTu0Ff7mS3Aq3cwTDyV6flMMY0FSo4YgYr6Hh/kTs60XQXnDc1eLcBN8ZYAK6x+isLbC8gIoERkSnVMX8CCTaTNwNt4d5o7c9CRDQj+Hqym9HNHy4Psy9m1yfrwPkWj3W427Ba6/AYsxgcOXbUD9aZ0KzH2l3LMx3se1tt35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dA4KxMu/lpcE+XBIDH0v003NIKCx5PvpD+OSw7NKrMs=;
 b=ajvuxX3OC1K8i52TJs8KDLzhB5gdOOPSkxa5naUluprS+iYeK9K+WQwb8LEgI9Kge9l+6Tl1TzjvWOaX2UJgopR70h0pffU6ZgLZALu+ws/WBLahkSJykj8+B7zU/ltSOiv0/7yTW/mzVEZXq8vgIHMKydn72txbHxtTbVPjoY9jWDsyeM1/OUF0qk0ahFZRYq4Y2+ye9F/HWyRpXtWREURVX9239AHBMxFNO5qqCBBhwEGIcPqj3nu1gT8VXNF60Pm2id5WQMhDZZxBmkCHm8Vyzi7AnMD7VuQWGlKlIqnz86kaF1BSX7NgwZNiV+DJbWJibOSuZXkLqs/DOH1TOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by BN9PR11MB5289.namprd11.prod.outlook.com (2603:10b6:408:136::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 15:51:40 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::16c0:1ae3:13ee:c40e]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::16c0:1ae3:13ee:c40e%8]) with mapi id 15.20.5986.018; Thu, 16 Feb 2023
 15:51:40 +0000
Date:   Thu, 16 Feb 2023 16:51:25 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [net-next 5/9] net/mlx5e: Implement CT entry update
Message-ID: <Y+5Q/aWKY+HO83A1@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-6-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-6-saeed@kernel.org>
X-ClientProxiedBy: FR3P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::16) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|BN9PR11MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: f71b078c-b279-416e-5a8b-08db1035b164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZbfreEkxdd/WiceVHvA5Q1Hfgl4lW5s/53Srlv9GkTKLG6XH47v/ca24kNZ2fbr1crX7mtx2sg0993gJi1aMLrMBZZf7m60QjPfnsHz2YKqPbvuYiFl5aTMV6ng26rfGifEAtQhw8BecjB/Lky6zdr4YZoFlFtm3mApKqij8ZKPi5v8nnCtpTpsu4vxOgalspntXGOo2hbrQqp0RkFU3/WyCdMpVENnoiXoJt/58ZnLw3K4VHaFv+X2xPmptOdpzdkq+15m04ss28uvq+oyzqWfjQaXtWtLxaLyXwiq5qtU+CoOVwWlaISe7fRUl31d2wr1wovD6Lleo18VQuCLp7iac5SY/2jiEIICq9TI16iWO+T5eE4M8NJEMGU1oR2K/8I3dP/1U63tMWhuxqwre08dqdw32tB7VKGW3KhayhThQLB1Cz0iMECC3+ertPM+WM0/vyZXNiaHWk2y+2ijUBTOIcVB/6yoImkUuU8q7X6PA7f7MzI64M30CFlMP9Ue2EreFB84WcPNBZuYeq9WD2Gab1AJt+aWMhHWVqz2gHH22pS6QHNmtHAQ4cUeVrXr7VhMp6DSfhyzOZeHiuaalTB6a+6Pf1NkbEFQDm4bTG1BildPexOCCcH64qN3HJj4YXikxwEt6aWqE5ta7nhYYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199018)(6486002)(83380400001)(86362001)(33716001)(9686003)(186003)(26005)(6666004)(6506007)(6512007)(478600001)(66899018)(38100700002)(316002)(8936002)(44832011)(7416002)(2906002)(82960400001)(54906003)(6916009)(41300700001)(8676002)(4326008)(15650500001)(5660300002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4KMLk35T8g1VyjBMGHkkwZNcbZ2E0kveVr1suvoz2WK4gfwSo8kncgkaFrI9?=
 =?us-ascii?Q?98lXrWqe8fC1wYbVkEEIb6BEJOmL9f2v8XSP9oihbP+44CL3SoO/zCNABG09?=
 =?us-ascii?Q?miB26ifvTzALLJ/WWkLVbEjo0IAELNz717NpoKSzNVXOT3zDLF/b84YLuk/S?=
 =?us-ascii?Q?D0gXKgAwDf4lSLhOJSg8jy/vfykYfCAvoPTah7c1ZkARIlSo/E9roli1oo9r?=
 =?us-ascii?Q?4HCo3Lb8zj0HZ3m4SCbXGT1tsJvW7Wq/25xFPu8vPWKgseLh19Dzy4k4iXLw?=
 =?us-ascii?Q?4qNR1q4Tv+55fx6JZ1MO+tDnHGpfUefO7wtCGVBtZPkuC9FoqjH71+syiAh+?=
 =?us-ascii?Q?0ARbqjnYbRkBr/bywVZLHPy1ZzJYRwn3lwUXrrz6NyDoGqRiwtTnlLS56j0S?=
 =?us-ascii?Q?KddFue0tUH/xcaC89RFR34bgKeFmwiFpqLc0ZDwBvphEyyOco5yI3Zw+9b76?=
 =?us-ascii?Q?Jx0w8i5cYtcl4S/ktWzdAX1lHB2v0KKsd9cmSDR88nyqJLAZbhmXQfMfII8t?=
 =?us-ascii?Q?rksSV18SOTdweD4WwhgHP1aRobSU5ofricCaCduIX58xDpn0n+zENIKGsm5d?=
 =?us-ascii?Q?Abo4nw/epSMXAZSk01ZGBIVEj81WkX8kPPoRRYJM6fH2ZFRDQBcCC9oRKPkD?=
 =?us-ascii?Q?khIM23/fhIdRr0a9pNpl0n9jBURq6gT/wBf6wC5hFzCoIYWwSpWo1Haq9z7y?=
 =?us-ascii?Q?ny7KaFJhzDXSEBPH3G0SdMhULO61XTxN4nynOKO5H82SPdeJy0HcANjenNBH?=
 =?us-ascii?Q?aG4lG3uN5wCMO5C7ST5yagtODw5flLe9a+e9Dt1d9ff5Uiiik62sk7wPY/3P?=
 =?us-ascii?Q?SBHJro9tzgfhC9zn4Awkb+SqTEPgfn7E9j9J21k04H+eukWbfMZw4eaujOtZ?=
 =?us-ascii?Q?xV+6dZ1gm7z0n/heiIhqiE4rTfRXt5oee704ZoGrA/4MckIujx4xZ5euz1pP?=
 =?us-ascii?Q?DtvOo1apn7F5JKIiL+p2o9Dd1OwcP82ieAjXiInCTKVEAhqoMt6bWRwiPq64?=
 =?us-ascii?Q?CnZsubdwTBtshk9I7nVDGXYN6q3ysYuGrG9n8jRmCLbeZnj/8gAaSynbYSpm?=
 =?us-ascii?Q?OGm8nAltQds62OyazcH4dBKprDGOysowHZwIoGA5JNrmZe7opdGzxFIx6DBh?=
 =?us-ascii?Q?M8TpE+H1tZhviec7mFCYi2C5VWxJvmZ+ZtlP6CrxZVQoQe+gShrY+WOi7w9P?=
 =?us-ascii?Q?utyLBGsogvUN0gfdTK/6Tunce0OfFioWP0GB7s0KQoAWH3BMYMZvoqHSwYfi?=
 =?us-ascii?Q?w4qAEQ0BwipE860YnIRYh4jRMLTFKhAMCvCCs79viAbzFwYdq+NA32e7k4AL?=
 =?us-ascii?Q?uPpW/U/glbyDgqxSCCU9u3nTOWvoqdXk/RgFKYZjRxOxKGoN0bqlf6fXRxYu?=
 =?us-ascii?Q?e9ncfp9nJ/Ikm1gGtVvHoSrzrV0S1nSXSVod0dKna6TyTb8OJYKZ95+xZKiL?=
 =?us-ascii?Q?K/6SYZL/KkOv36B4q+cDpSbj2a9nkhrcftxhrwY6shmHc9a4J9lQmsOVrgNL?=
 =?us-ascii?Q?VCpoMqLHbPw8+Fh/+lVusU6VK4qlPAawj1BeYkyPqzeOxSg3dT8nr7Oh7qfT?=
 =?us-ascii?Q?iLE1iNxK6uw66zKQZUah/7tKfrmOvriS+phcRgN6blZgGOOT6A/sPar/V8kv?=
 =?us-ascii?Q?mf2Cm8tJMwzRezvBIVXTv1M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f71b078c-b279-416e-5a8b-08db1035b164
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:51:40.1149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMtykfkpx+EpnFl7HZHYrZmLuNbd4c9waNWRmP6WeVpaqK3LyhG8MwdEFtJhJZm4NkGwLL6ayV6FGHH5o0Zmb3RIWFh3vPSfq9KJtKTRwek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5289
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:14PM -0800, Saeed Mahameed wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> With support for UDP NEW offload the flow_table may now send updates for
> existing flows. Support properly replacing existing entries by updating
> flow restore_cookie and replacing the rule with new one with the same match
> but new mod_hdr action that sets updated ctinfo.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 118 +++++++++++++++++-
>  1 file changed, 117 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 193562c14c44..76e86f83b6ac 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -871,6 +871,68 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
>  	return err;
>  }
>  
> +static int
> +mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
> +			      struct flow_rule *flow_rule,
> +			      struct mlx5_ct_entry *entry,
> +			      bool nat, u8 zone_restore_id)
> +{
> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> +	struct mlx5_flow_attr *attr = zone_rule->attr, *old_attr;
> +	struct mlx5e_mod_hdr_handle *mh;
> +	struct mlx5_ct_fs_rule *rule;
> +	struct mlx5_flow_spec *spec;
> +	int err;
> +
> +	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
> +	if (!spec)
> +		return -ENOMEM;
> +
> +	old_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
> +	if (!attr) {

when can attr == NULL? maybe check it in the first place before allocing
spec above?

> +		err = -ENOMEM;
> +		goto err_attr;
> +	}
> +	*old_attr = *attr;
> +
> +	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, &mh, zone_restore_id,
> +					      nat, mlx5_tc_ct_entry_has_nat(entry));
> +	if (err) {
> +		ct_dbg("Failed to create ct entry mod hdr");
> +		goto err_mod_hdr;
> +	}
> +
> +	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
> +	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
> +
> +	rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr, flow_rule);
> +	if (IS_ERR(rule)) {
> +		err = PTR_ERR(rule);
> +		ct_dbg("Failed to add replacement ct entry rule, nat: %d", nat);
> +		goto err_rule;
> +	}
> +
> +	ct_priv->fs_ops->ct_rule_del(ct_priv->fs, zone_rule->rule);
> +	zone_rule->rule = rule;
> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, old_attr, zone_rule->mh);
> +	zone_rule->mh = mh;
> +
> +	kfree(old_attr);
> +	kvfree(spec);

not a big deal but you could make a common goto below with a different
name

> +	ct_dbg("Replaced ct entry rule in zone %d", entry->tuple.zone);
> +
> +	return 0;
> +
> +err_rule:
> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, mh);
> +	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
> +err_mod_hdr:
> +	kfree(old_attr);
> +err_attr:
> +	kvfree(spec);
> +	return err;
> +}
> +
>  static bool
>  mlx5_tc_ct_entry_valid(struct mlx5_ct_entry *entry)
>  {
> @@ -1065,6 +1127,52 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
>  	return err;
>  }
>  
> +static int
> +mlx5_tc_ct_entry_replace_rules(struct mlx5_tc_ct_priv *ct_priv,
> +			       struct flow_rule *flow_rule,
> +			       struct mlx5_ct_entry *entry,
> +			       u8 zone_restore_id)
> +{
> +	int err;
> +
> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, false,

would it make sense to replace the bool nat in here with some kind of
enum?

> +					    zone_restore_id);
> +	if (err)
> +		return err;
> +
> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, true,
> +					    zone_restore_id);
> +	if (err)
> +		mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> +	return err;
> +}
> +
> +static int
> +mlx5_tc_ct_block_flow_offload_replace(struct mlx5_ct_ft *ft, struct flow_rule *flow_rule,
> +				      struct mlx5_ct_entry *entry, unsigned long cookie)
> +{
> +	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
> +	int err;
> +
> +	err = mlx5_tc_ct_entry_replace_rules(ct_priv, flow_rule, entry, ft->zone_restore_id);
> +	if (!err)
> +		return 0;
> +
> +	/* If failed to update the entry, then look it up again under ht_lock
> +	 * protection and properly delete it.
> +	 */
> +	spin_lock_bh(&ct_priv->ht_lock);
> +	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
> +	if (entry) {
> +		rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
> +		spin_unlock_bh(&ct_priv->ht_lock);
> +		mlx5_tc_ct_entry_put(entry);
> +	} else {
> +		spin_unlock_bh(&ct_priv->ht_lock);
> +	}
> +	return err;
> +}
> +
>  static int
>  mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>  				  struct flow_cls_offload *flow)
> @@ -1087,9 +1195,17 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>  	spin_lock_bh(&ct_priv->ht_lock);
>  	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
>  	if (entry && refcount_inc_not_zero(&entry->refcnt)) {
> +		if (entry->restore_cookie == meta_action->ct_metadata.cookie) {
> +			spin_unlock_bh(&ct_priv->ht_lock);
> +			mlx5_tc_ct_entry_put(entry);
> +			return -EEXIST;
> +		}
> +		entry->restore_cookie = meta_action->ct_metadata.cookie;
>  		spin_unlock_bh(&ct_priv->ht_lock);
> +
> +		err = mlx5_tc_ct_block_flow_offload_replace(ft, flow_rule, entry, cookie);
>  		mlx5_tc_ct_entry_put(entry);

in case of err != 0, haven't you already put the entry inside
mlx5_tc_ct_block_flow_offload_replace() ?

> -		return -EEXIST;
> +		return err;
>  	}
>  	spin_unlock_bh(&ct_priv->ht_lock);
>  
> -- 
> 2.39.1
> 
