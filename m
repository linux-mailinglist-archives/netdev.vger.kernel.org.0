Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1D652052
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiLTMVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiLTMVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:21:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3BA1DE;
        Tue, 20 Dec 2022 04:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671538889; x=1703074889;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EIO56PP2QweKn19Jz8XbV7nYk848QXzvWwwvz+AiDKM=;
  b=dn7heyENZU+uLeCKzz6+LL4cdltTHE/dzpKOHvLzK4mvQVWPwWbrDTiB
   lK1xP26k1p1fmpdPgsH4qaKJFKfslWzUNGedyAq6MGeIea/D2fcQD7wRw
   K0uq4+QCMlwrFmi/87s8I5DxBcAOx7t33qfNHqtjdKuR8WJVGQXwTquSw
   fDU/gZdLoZhZH65CjTEy+Eq/L2lfoJChg2y02a1HoU9FaZktoVtCESgDb
   REjqAu/PwZ+zjQkUuoqHhMaamj287CE6JZ82iXkEvkOiohmgBRPZb2jJZ
   O448rwlcFxoeRhSI5dwvkThMJVFe8YXOKfVZRR8jAfwJIbAoORkB6W4pC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="405847628"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="405847628"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 04:21:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="628702511"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="628702511"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2022 04:21:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 04:21:28 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 04:21:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 04:21:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 04:21:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWwjDGe2xlMlbDjpkdfoGlnkHbueuO9HaeXFTaNhJ3tjxh1NQWjiCQahpUHQaGJpiBIKGFw9mpab0oTCRBMrgTCf+SrUM7xt+vZHycU6LWNssyXH8yoLpeBTq1M5xnIq45OjAcAyI4V2esgC/i4O7H8STknw9gKwKZ0+fkCg0w0DCh+9C9vRbsL0PMzcI+alEHUZGMabnAfkL3ljGQhPVHjDWLFUWuBiPleNwyKDUlyOfsoAOkhnyOQzjtUhI1rsqdi4ISdxtmvvyxVJAbT5TN7dpJ+SLenBcXnNcl8RvPjSJ20EOlLYKCgmhPg5jmFASCAM4vov8Fs7mIWpxNNz5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gucy0gn3+wlEpkDqOxKfreOMoN8L2E3IHxT2GokJltI=;
 b=ZKiMxA8sxTDlCDMh/VdZvGFRas4xrP2FbYB2yhYtDbJYFw9ICkZMoGqzGlcSgcS0C13evDuqB6+Ov3y5g6TaGumb4XdqI0UWSoyAWlb8daKnRkh9bAKIO4UpYQGZYnbvH4zDCkFqD+vO10Bohn75owNE8LBJiF+LkZffrFUrkIk1951Z1glXKJtDM61sYnJtlPAiR676jYqh83gvV+enhh9d+eFwLg6rkVDQ1zaRSkeLrzxGy+2pAYzX4LMMutkF29KqLDwmMAex+DsB5SehTkuj233hiIW301e+tPWEiq5Swp1ftyDviNz36zlyNZdZ2cP1ksxoWUgk47CHhcnmnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by DM4PR11MB5437.namprd11.prod.outlook.com
 (2603:10b6:5:398::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 12:21:26 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e%7]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 12:21:26 +0000
Date:   Tue, 20 Dec 2022 13:21:08 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1 1/2] net: marvell: prestera: Add router ipv6
 ABI
Message-ID: <Y6GotOCyKgxr1Xtg@praczyns-desk3>
References: <Y5+RSF0Had10xizI@yorlov.ow.s>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y5+RSF0Had10xizI@yorlov.ow.s>
X-ClientProxiedBy: LNXP265CA0091.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::31) To BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|DM4PR11MB5437:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b6a0c6-6d4e-44ef-3646-08dae284b71b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOXnOr5Wr+H1mMRPAx7xvzGCs2gdecvSfa77fXO0R+gZ3I2lx199J2ksgeNBFOGNSdxvBeH1owulu9zcWkq3JCezmICkpOZTWoSGWRU0WC2pz0E+U8/T91/aUCtk2HLT14grKhdrzw0RGna/MAo17SRNgh3tQFMyxUwwDP/VcW0+cd2yPpMmpGmMeRMlXAuEPDdlWcBLKxVZNTxWnlJ7STPhdzlwsqjAu5Jeoeah8ANLnGU9m1zyIceiX3w0lX+xgPr1Ft6yMwNV5erlFmov1/RMrTpCSFHGszOm+9WLnYW5ZXcOzKzHnx9IsCTW6sBHFWPZa1QkS7HV+BUzrFmUkwNrZhjOA30go9ThvLFpCT739zeBZ9RMet1gq248xn6XtdS9R04Iej6l7V0T7002qQWMFQg3Tlpamuw21my3PJwm86lT0JuppZJPlTUyjvmV5Jcvsnb+LdaZA2iydPoeM/Oe2lbUnk8uf1jfkfN/lCMCHNQQmANqbnEj72jGlffP5tp+n0AFeXy12syuC8Qw/vE9qDyjM/SjZA69LKP6Fe2MPkYkLxrZuV3a/T26kG8s7HQdffR879FU5WYwPvaeZmvp4C2FnTEvUljvCVxVgh0ZnJmdq9NrzA+gSueLopMUX+NQxCP1pS1adHI9UMdoTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199015)(6506007)(478600001)(6486002)(6512007)(9686003)(2906002)(186003)(44832011)(26005)(6916009)(8676002)(66476007)(4326008)(66946007)(66556008)(41300700001)(7416002)(33716001)(5660300002)(66574015)(83380400001)(54906003)(8936002)(316002)(38100700002)(82960400001)(86362001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rbCgDa3bbcr8nwFc/PrYBzbMY+q41HiUWyjkMhv6qNz2mECVDgPn4EjNngrn?=
 =?us-ascii?Q?Z6BjbrOWAqXwN3j7DnJjj6ODNKWC2zmAgbPdM8/+HRi5rSOaAXVHwhqUGx3H?=
 =?us-ascii?Q?hNv/q2RnkjPqz93KE53qeXXXtp3abslymSEYgdAnk48JHsq3W9anxRUTOmCr?=
 =?us-ascii?Q?50ea3XIGLTEgheXf0NZ9+SA5mJi4lXohNq/BAoQUsfpnRLH1PJ8OBHlRPbX2?=
 =?us-ascii?Q?+Thk0Gvch2XgxylqB2ETzYCWHzDkTfjjrbTqsbn94pHLunDWvyH0oYHj9P4r?=
 =?us-ascii?Q?WtXVTdFp7fjeCOENjBFP2yAEU+B+Qd1YrhEhq0Jt8x5lQOrS6tVLoAn3v3IX?=
 =?us-ascii?Q?b3kupmqTY9eJ4vKtwNbl5Ii6kB4NFnsPcydLbre7lq4PpLkXmJdSVEeBXXpW?=
 =?us-ascii?Q?tXeq7sN9cm/cOsGVHp1naTlJUSOgD3VlOwpHBXvyU09B7IehwVJ0qK42fyh6?=
 =?us-ascii?Q?uQqZNPu5zJx7+Djj0eZm25YDVtbcNgvgNAT6+8zBzIO9/r53VMc003BPAEBT?=
 =?us-ascii?Q?0bdcJqyQDPByeyYbnh4g+iToM1oycf+8a5OgqeZSpLAw/ZNjSdFZf48E+3TX?=
 =?us-ascii?Q?mgZsy4uwiG/IEo9RUZZ4RpS1wjcUC5eXY2vX8a2TlXQl78+v6wU5sOF3M4Ez?=
 =?us-ascii?Q?2XKNfOfxS53UdMwV/mYCXtNo5Iz2qwj1CI5M0HlfZxhDmSX2dU+2v3xN8gY5?=
 =?us-ascii?Q?uFO+NUNf103uINd76Gp4bdBLePfKn8V1hyRuzBXQUuPf8V1ssDfv6WTkpxBX?=
 =?us-ascii?Q?crZJ0dQxZQ7xqj6ONtsmoEyApPHfz3MBdGgTnXnmVXipo8HvThvubzBOIBTw?=
 =?us-ascii?Q?IjSOxktl3K0yrdIuUybPpR28g6YmB5Ey47v9XK7PPzOJxLuRfZfH4MfOrtvf?=
 =?us-ascii?Q?QwaMB4rcBE3XczELbIHQLwGW8xOSdLU38cCbI8gU9VuM2mvg7SfAE/vZ9Csh?=
 =?us-ascii?Q?yp43BJyf6VjNCQQ8GSolAAiRljnD+xRWdJMIs/wfoUPZR5R5NslcV5/GaAaQ?=
 =?us-ascii?Q?c+6p3HgYyvyS2R0rpVw2LPsL2YyMKG3+9I5ds9i4zHu2osb2LObUELPCCSHe?=
 =?us-ascii?Q?CB0zvmm2Pp2GgE2l7IBkQKAfSXGcbZqLItv/lb8IPzSPTowr6PY3J4fDEYuc?=
 =?us-ascii?Q?Jr6WyKdgF79hPox18NU0CIdYSr/JqTzpHOe9qoWiQlhz68uXnN21UXZMBYDG?=
 =?us-ascii?Q?m/kS3MAndbC8EWWpjqSH4n816+fsFI0hcw1BBGqEiuu1XABSdwD6JNKcvMiX?=
 =?us-ascii?Q?RxZJ7cpDf482qs7PeSiKrDq18SQKVGR65xb+Cv7MJyPX/CNnFcuvPAYe4JMm?=
 =?us-ascii?Q?rUR2e6d7yVJx+Q/5PPG1iuEq6XKOhKEJOVbk1z1uhjPvs2O3nSbSoSyH8+Wk?=
 =?us-ascii?Q?jjpm0vkATBkgwSEQAHZUpGNPVQQtEQTjgbpTIxggyy6RpdW0sO9Nx/wBRGNv?=
 =?us-ascii?Q?QON8Cib8GBwK5b5M0wkFUzAELfRkNVrWVp/R48Tjsf5ihAe53aGTwElamq+b?=
 =?us-ascii?Q?arWKH/ojSTItha0qlRqLuEhBK2XllnPdhJiQJMHDr3s5CKT4aer/sSJhGgus?=
 =?us-ascii?Q?kqPzsJ7EnXapt+ZHCYejaxuIJEjqhnOSQsjDUW+Z268vZf/j55c2x9IZTP7K?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b6a0c6-6d4e-44ef-3646-08dae284b71b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 12:21:26.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTk1i9D9/cZQ/rP3xHmk/RBuJSSc2VgC1qsWf0kywWkMtUiiEVCI6rZxQqtQaE3z8vXoa9cnGbRVGJT//oE0xwl8Z7WFeh8kTreyssuy7gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5437
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 11:16:40PM +0100, Yevhen Orlov wrote:
> There are only lpm add/del for ipv6 needed.
> Nexthops indexes shared with ipv4.
> 
> Limitations:
> - Only "local" and "main" tables supported
> - Only generic interfaces supported for router (no bridges or vlans)
> 
Yevhen, currently net-next is closed.

Please repost when net-next reopens after Jan 2nd.

> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Co-developed-by: Elad Nachman <enachman@marvell.com>
> Signed-off-by: Elad Nachman <enachman@marvell.com>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
>  .../ethernet/marvell/prestera/prestera_hw.c   | 34 +++++++++++++++++++
>  .../ethernet/marvell/prestera/prestera_hw.h   |  4 +++
>  .../marvell/prestera/prestera_router_hw.c     | 33 ++++++++++++++----
>  3 files changed, 65 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index fc6f7d2746e8..13341056599a 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -540,6 +540,11 @@ struct prestera_msg_iface {
>  	u8 __pad[3];
>  };
>  
> +enum prestera_msg_ip_addr_v {
> +	PRESTERA_MSG_IPV4 = 0,
> +	PRESTERA_MSG_IPV6
> +};
> +
>  struct prestera_msg_ip_addr {
>  	union {
>  		__be32 ipv4;
> @@ -2088,6 +2093,35 @@ int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
>  			    sizeof(req));
>  }
>  
> +int prestera_hw_lpm6_add(struct prestera_switch *sw, u16 vr_id,
> +			 __u8 *dst, u32 dst_len, u32 grp_id)
> +{
> +	struct prestera_msg_lpm_req req;
> +
> +	req.dst.v = PRESTERA_MSG_IPV6;
> +	memcpy(&req.dst.u.ipv6, dst, 16);
> +	req.dst_len = __cpu_to_le32(dst_len);
> +	req.vr_id = __cpu_to_le16(vr_id);
> +	req.grp_id = __cpu_to_le32(grp_id);
> +
> +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_ADD, &req.cmd,
> +			    sizeof(req));
> +}
> +
> +int prestera_hw_lpm6_del(struct prestera_switch *sw, u16 vr_id,
> +			 __u8 *dst, u32 dst_len)
> +{
> +	struct prestera_msg_lpm_req req;
> +
> +	req.dst.v = PRESTERA_MSG_IPV6;
> +	memcpy(&req.dst.u.ipv6, dst, 16);
> +	req.dst_len = __cpu_to_le32(dst_len);
> +	req.vr_id = __cpu_to_le16(vr_id);
> +
> +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_DELETE, &req.cmd,
> +			    sizeof(req));
> +}
> +
>  int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
>  			       struct prestera_neigh_info *nhs, u32 grp_id)
>  {
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> index 0a929279e1ce..8769be6752bc 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> @@ -266,6 +266,10 @@ int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
>  			__be32 dst, u32 dst_len, u32 grp_id);
>  int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
>  			__be32 dst, u32 dst_len);
> +int prestera_hw_lpm6_add(struct prestera_switch *sw, u16 vr_id,
> +			 __u8 *dst, u32 dst_len, u32 grp_id);
> +int prestera_hw_lpm6_del(struct prestera_switch *sw, u16 vr_id,
> +			 __u8 *dst, u32 dst_len);
>  
>  /* NH API */
>  int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> index 02faaea2aefa..1c6d0cdbdfdf 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> @@ -581,8 +581,16 @@ static void __prestera_fib_node_destruct(struct prestera_switch *sw,
>  	struct prestera_vr *vr;
>  
>  	vr = fib_node->info.vr;
> -	prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
> -			    fib_node->key.prefix_len);
> +	if (fib_node->key.addr.v == PRESTERA_IPV4)
> +		prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
> +				    fib_node->key.prefix_len);
> +	else if (fib_node->key.addr.v == PRESTERA_IPV6)
> +		prestera_hw_lpm6_del(sw, vr->hw_vr_id,
> +				     (u8 *)&fib_node->key.addr.u.ipv6.s6_addr,
> +				     fib_node->key.prefix_len);
> +	else
> +		WARN(1, "Invalid address version. Memory corrupted?");
> +
>  	switch (fib_node->info.type) {
>  	case PRESTERA_FIB_TYPE_UC_NH:
>  		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
> @@ -661,8 +669,16 @@ prestera_fib_node_create(struct prestera_switch *sw,
>  		goto err_nh_grp_get;
>  	}
>  
> -	err = prestera_hw_lpm_add(sw, vr->hw_vr_id, key->addr.u.ipv4,
> -				  key->prefix_len, grp_id);
> +	if (key->addr.v == PRESTERA_IPV4)
> +		err = prestera_hw_lpm_add(sw, vr->hw_vr_id, key->addr.u.ipv4,
> +					  key->prefix_len, grp_id);
> +	else if (key->addr.v == PRESTERA_IPV6)
> +		err = prestera_hw_lpm6_add(sw, vr->hw_vr_id,
> +					   (u8 *)&key->addr.u.ipv6.s6_addr,
> +					   key->prefix_len, grp_id);
> +	else
> +		WARN(1, "Invalid address version. Memory corrupted?");
> +
>  	if (err)
>  		goto err_lpm_add;
>  
> @@ -674,8 +690,13 @@ prestera_fib_node_create(struct prestera_switch *sw,
>  	return fib_node;
>  
>  err_ht_insert:
> -	prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
> -			    key->prefix_len);
> +	if (key->addr.v == PRESTERA_IPV4)
> +		prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
> +				    key->prefix_len);
> +	else if (key->addr.v == PRESTERA_IPV6)
> +		prestera_hw_lpm6_del(sw, vr->hw_vr_id,
> +				     (u8 *)&key->addr.u.ipv6.s6_addr,
> +				     key->prefix_len);
>  err_lpm_add:
>  	if (fib_type == PRESTERA_FIB_TYPE_UC_NH)
>  		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
> -- 
> 2.17.1
> 
