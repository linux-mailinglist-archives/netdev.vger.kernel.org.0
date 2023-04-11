Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205156DE0EC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDKQZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjDKQZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:25:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985544212;
        Tue, 11 Apr 2023 09:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681230308; x=1712766308;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=n/L0Jy4AhmVgEjZFX+juVF0IeJDhEVPTzsUKWBulBUk=;
  b=jYVahZmInnqfb+agSrm3g9WrIybVt/xPdn/8g8QRr2pP0fp2GCDR2yYO
   BTATgWCWve5qEIi3fOfYfczFAeHj8DvSovveOjZD9xuBBOMmYHHNn9eHm
   +jt5/G575lkB8FEXqBPWOn63TmAimkxwrD+76iMFUgYnevPGvcW/MKgW1
   cmrFTIUcknnjYTZHhecxtnoQ8pKTYx+fVLh6Z7ON7fDXlizoD7jlFoqhr
   kd93Im13qINyKWx0KFo59mCDcM1m7H2XX5tnMM/dj3LO8ycIeWai3vgD+
   JHVj+aGwL5OsDbSZ8qnp09CFz8fPDhQKL5fYAq2puTA3UE9tGFC4w+TSy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327769981"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327769981"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 09:25:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="721246767"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="721246767"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 11 Apr 2023 09:25:07 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 09:25:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 09:25:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 09:25:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEWfKL0J9yLFPr38jtx0O5VucOdFWyd8Cyq7BHupi1wEpybsaUqq2szIqiWXAHz87oOXMcknz3K1gVlhea+4VDXNASfjIYX1WY4hglDBKnEuCX6hqYSdrxqHr6fbzFkj8iAsUv0Qa4nLiv1D9THfIVgYrWFLnZLm4znE5ytwI9CCq0CHvfsiF7O+Zy2XzBXdZ39/gHGv3G6Sg1LTvb0SuK4uB+fgpaKs6znszCsFem9rEMPTX2ydp02TDfVztWIJmfDgDNsbsbdyQzEJj96rioDmH14sUag1jFVzHetA6SESLR3YYrM5W9SH/Ib7uBsOpUa3s+FUoP0/tJ0txltFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFDltTv99Sz3XFEdmzs9awb/g4ySnnJPqd0Cbqx+Sr8=;
 b=jKXeFIydX/mG6LekhA/F1yAhFWmhTPUR2stgetJ/URV0W6GOZsfH6VkNwmCbPH7234JyrOjk18fqBzVRhH//RMqk+UgK68FaOyQoGzHIVB6Haul3TKyRdO9mW1aLsenhp7W7twwYek1Ah1MAevKZLjc9z5rZiPE0QWHO+qJGx9PY9Npm43nQUgU5/T62ghtsRbmYu4jkWQC9DrsEPy2WFmEkVYV9GTo9MEAGE4Ppl5ZadP3utN37vUwSLI5WzdQAv/k6rNcAh7lKmglsjH2ptxm6T7VoakBmTU/D0bbEGgO6dQhVNry5auO2GnVLsscyqdsJloTxtcDoC8FktaYMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB7968.namprd11.prod.outlook.com (2603:10b6:510:25f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 16:25:03 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6277.031; Tue, 11 Apr 2023
 16:25:03 +0000
Date:   Tue, 11 Apr 2023 18:24:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        <magnus.karlsson@intel.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Andrii Staikov <andrii.staikov@intel.com>,
        "Kamil Maziarz" <kamil.maziarz@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net 1/1] i40e: Fix crash when rebuild fails in
 i40e_xdp_setup
Message-ID: <ZDWJ0QklJ+bwmY0/@boxer>
References: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR3P281CA0153.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB7968:EE_
X-MS-Office365-Filtering-Correlation-Id: f082c733-2204-4cdf-cf2a-08db3aa94db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0b2fCd6ym812CVmWtoM9kOGU6v6P/+r6WuTkLMVDIvngq5O9Yql0CzJyTqy1YIy+jR221DwgRC+0ZT7oMLM+sHGQKUFOBsOyvllPlZJKyrKmPGG5P3Hfk/Ml0PwcIoCHPnf7UqIlCfr7wZPakVRHF3coau1EmpvNosP134A3ax8nb3UMVplJd3SJiKGI5V/3niVg31rV+pd174+MclIY3ssm2NrG/A6Zp4Th8WZbztKOC5tXMkzWgI7xbeyeoGQ/Ptnw6Iol+To3ZaqQ0r0HtXAb3xn2erPMfyZ8fPkvUkUZHsH0Ij7HVUR45IQoHmKiCnQMWKvIoeuXC8Wf2jFkheGpL4FsRoY6EUgBQRMaTABAzJpmhUN+AoItbJAuHrIPJsW/M58hkcVS4aC2X9K+8RLdHSMTIpk4f0Iyg6d+rfLrHExfubyO1hFNAZpsjuIguW16OYdplso6IGu6fXBMtMnHMGhmXvtEMhie8l3ZRIIXV0JvkbIamtHMeun2CDV4m3/OFCdehkyItSAfSezN0kZoIWyMEog6i0aLyD1qrjW1tLqiktmRog2zsPvMYM2Dt0kUWuILv1QfcEWc11ANXtHT54OOu8RPVFIM1ZPc32TSUG3hEYYoUqhMfj1/A0pP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199021)(6486002)(66476007)(54906003)(8676002)(66556008)(4326008)(6636002)(478600001)(66946007)(41300700001)(316002)(86362001)(83380400001)(6506007)(26005)(6512007)(9686003)(107886003)(6666004)(8936002)(2906002)(6862004)(44832011)(30864003)(33716001)(5660300002)(7416002)(38100700002)(82960400001)(186003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?74EbXsDBcT66CqU2eSspNwl//XjW3+i0K2yAdqWh0jdlnzUUWh++Je4eaPRQ?=
 =?us-ascii?Q?xpHtCOuIatbmqEFATgGqFl2Y1nDWaJX19oOyhNHtyns37J3VC2RTsySR4AfL?=
 =?us-ascii?Q?zxwpaE4BCzCPQ3+/0KgzEZXMSPkFBzQcjSbR8rNIH2VPamt1Br1Zil1sMAZK?=
 =?us-ascii?Q?5cbqypaogw32Zuw9JkLQ+kfK+E+A/G3LAoLHjbd+ZuYxHDm9C4bDzeKPy1en?=
 =?us-ascii?Q?F3cn38tSNKUsVA581gjW/fsdj6rSNs8Fj71dDkUcuTEF+WBMZJAEvp24aFXZ?=
 =?us-ascii?Q?Zab7TlKJlpT1j68CEKQaA975AwPhah3qv/fJRDAO7DD02ME6jAHhhvqOypeB?=
 =?us-ascii?Q?nsO4OcmNgOu2leR1oIejV9fkpV5hIrOT5N/pAajuBfoXZplg2JjAgt76ySdS?=
 =?us-ascii?Q?EOmZ5+0i84XFYPJHojjHcvgCkvh1oBIJg+EJpdENat/Iupw4IYBNK6eiNcs/?=
 =?us-ascii?Q?CQ6G2ERDBcDu5ycQq7MoHILFPrENZIuQEnugs+9NoNU19Ptz9R9gb0EyMNvl?=
 =?us-ascii?Q?yVln0PcsqNJAvolruSxQdKxD0bedRiTPeDJSn+dOs9at6NOcDspYuvdDrv8L?=
 =?us-ascii?Q?GhX22nALgiMXdEBRqlzORgehfPZHxnm1OjyyOsbbWHVlZfvRH4XKL+AVcv5t?=
 =?us-ascii?Q?qLlyMHbCLj1qcqAFuhbQHo7yxAhfZLJQVW78uK/XshFdEQ2VdgJPnq563T36?=
 =?us-ascii?Q?O1a0dS4tLz1cJzNEl0yK4m/IFE4evP6VsEVTjGcJIF4pHwFPmFrJTVAs4UNU?=
 =?us-ascii?Q?cqjVnwMJSA0XQ4POgUWikIWVBlZKoGwBBh5hIZus+FiPMgBPxPDZgzrApgX9?=
 =?us-ascii?Q?1qbmGGkwib6Kau4GizfFCMGxt505KhDBTy4ND4nHT0OFhMVNmLDmML5aChos?=
 =?us-ascii?Q?1DgIztajHD0N+ZaO0zDoBjPE5CsRarx6uNyFMdG5CCLBmdSOf5OUYSIKIilc?=
 =?us-ascii?Q?ZZALa8UnfWN1xft3jTWHmwXr2exfur2CWeW9p/hPhx5sSVFtYotityAenWyw?=
 =?us-ascii?Q?u4TUfM01wI2226pzT4FQd5gowRmsrTiI5XvsApbqMqQHzlKJl5K/jS0gLlO3?=
 =?us-ascii?Q?7ov6VofA3ScAtYcnhMQg3C/VdXSmS21G5yZi3MDF8jXZ/ppZYfJWNWuYhaV3?=
 =?us-ascii?Q?QrTH/0OP785LJdmafCXSxPcSKcmYJHeuIkU1eNv214JbEtC/w6G7rX6ganAa?=
 =?us-ascii?Q?VeWCrsB6G0aUt38TmjGDe4rBtScT/BArk8igsXMiRwEl6dt5bA3xsx+0sdbe?=
 =?us-ascii?Q?NFhiTDF3KWFc3FhbMkWqa4Kc4S5P6rx8h00YRemXCPY0WUesHsvO49obYDxN?=
 =?us-ascii?Q?hItp8sFDFE5v94dTBW4qn6tCZPkHpB8T2IFkRqX5K01Gm9mgZblzEtESa8UW?=
 =?us-ascii?Q?73a+YTC1RsokN+6F5YqabvdNwLujeNT9zLEtZUlrRzyADGlvQbZkVI5NOqP2?=
 =?us-ascii?Q?c/R/6qBmod9gDmUVijSER0rGBjFQBKkC2EhT1T++XQzJwF84sRjy0KsnVe5c?=
 =?us-ascii?Q?JD8xy/4cwuW+Hn9P56nDe1PfI4DfunRnIwFUBvebl8dVk5YUQJWtJnPL+mdZ?=
 =?us-ascii?Q?bHIcMacL1m3I57wsonl3eYvuB9WfaBGC10/U5AnUZPWRmsOjG5un/rJz54Q3?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f082c733-2204-4cdf-cf2a-08db3aa94db1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:25:03.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBbVWcp+0+Omrop5u6UYQRcXQ8mKrYypPEzyl7LhgignuavHjflbXpkSgtvsHgmn9hrfawxhB44lcqT7vzH2pCXMr3PzDDrjfZw1Nsv/gjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:09:18PM -0700, Tony Nguyen wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> When attaching XDP program on i40e driver there was a reset and rebuild
> of the interface to reconfigure the queues for XDP operation.
> If one of the steps of rebuild failed then the interface was left
> in incorrect state that could lead to a crash. If rebuild failed while
> getting capabilities from HW such crash occurs:
> 
> capability discovery failed, err I40E_ERR_ADMIN_QUEUE_TIMEOUT aq_err OK
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> Call Trace:
> ? i40e_reconfig_rss_queues+0x120/0x120 [i40e]
>   dev_xdp_install+0x70/0x100
>   dev_xdp_attach+0x1d7/0x530
>   dev_change_xdp_fd+0x1f4/0x230
>   do_setlink+0x45f/0xf30
>   ? irq_work_interrupt+0xa/0x20
>   ? __nla_validate_parse+0x12d/0x1a0
>   rtnl_setlink+0xb5/0x120
>   rtnetlink_rcv_msg+0x2b1/0x360
>   ? sock_has_perm+0x80/0xa0
>   ? rtnl_calcit.isra.42+0x120/0x120
>   netlink_rcv_skb+0x4c/0x120
>   netlink_unicast+0x196/0x230
>   netlink_sendmsg+0x204/0x3d0
>   sock_sendmsg+0x4c/0x50
>   __sys_sendto+0xee/0x160
>   ? handle_mm_fault+0xc1/0x1e0
>   ? syscall_trace_enter+0x1fb/0x2c0
>   ? __sys_setsockopt+0xd6/0x1d0
>   __x64_sys_sendto+0x24/0x30
>   do_syscall_64+0x5b/0x1a0
>   entry_SYSCALL_64_after_hwframe+0x65/0xca
>   RIP: 0033:0x7f3535d99781
> 
> Fix this by removing reset and rebuild from i40e_xdp_setup and replace it
> by interface down, reconfigure queues and interface up. This way if any
> step fails the interface will remain in a correct state.
> 
> Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")

While I do agree with the overall concept of removing reset logic from XDP
control path here I feel that change is, as Jesse also wrote, rather too
big for a -net candidate. It also feels like real issue was not resolved
and removing reset path from XDP has a positive side effect of XDP not
being exposed to real issue.

What if I would do the rebuild via ethtool -L? There is a non-zero chance
that I would get the splat above again.

So I'd rather get this patch via -next and try harder to isolate the NULL
ptr deref and address that.

Note that I'm only sharing my thoughts here, other people can disagree and
proceed with this as is.

> Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
> Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>

George, can you tell us how was this tested?

> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
> Note: This will conflict when merging with net-next.
> 
> Resolution:
> static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
>                           struct netlink_ext_ack *extack)
>   {
>  -      int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
>  +      int frame_size = i40e_max_vsi_frame_size(vsi, prog);
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 159 +++++++++++++++-----
>  1 file changed, 118 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 228cd502bb48..5c424f6af834 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -50,6 +50,8 @@ static int i40e_veb_get_bw_info(struct i40e_veb *veb);
>  static int i40e_get_capabilities(struct i40e_pf *pf,
>  				 enum i40e_admin_queue_opc list_type);
>  static bool i40e_is_total_port_shutdown_enabled(struct i40e_pf *pf);
> +static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi,
> +					      bool is_xdp);
>  
>  /* i40e_pci_tbl - PCI Device ID Table
>   *
> @@ -3563,11 +3565,16 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
>  	/* clear the context structure first */
>  	memset(&rx_ctx, 0, sizeof(rx_ctx));
>  
> -	if (ring->vsi->type == I40E_VSI_MAIN)
> -		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
> +	if (ring->vsi->type == I40E_VSI_MAIN &&
> +	    !xdp_rxq_info_is_reg(&ring->xdp_rxq))
> +		xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
> +				 ring->queue_index,
> +				 ring->q_vector->napi.napi_id);
>  
>  	ring->xsk_pool = i40e_xsk_pool(ring);
>  	if (ring->xsk_pool) {
> +		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
> +
>  		ring->rx_buf_len =
>  		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
>  		/* For AF_XDP ZC, we disallow packets to span on
> @@ -13307,6 +13314,39 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
>  	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
>  }
>  
> +/**
> + * i40e_vsi_assign_bpf_prog - set or clear bpf prog pointer on VSI
> + * @vsi: VSI to changed
> + * @prog: XDP program
> + **/
> +static void i40e_vsi_assign_bpf_prog(struct i40e_vsi *vsi,
> +				     struct bpf_prog *prog)
> +{
> +	struct bpf_prog *old_prog;
> +	int i;
> +
> +	old_prog = xchg(&vsi->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	for (i = 0; i < vsi->num_queue_pairs; i++)
> +		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
> +}
> +
> +/**
> + * i40e_vsi_rx_napi_schedule - Schedule napi on RX queues from VSI
> + * @vsi: VSI to schedule napi on
> + */
> +static void i40e_vsi_rx_napi_schedule(struct i40e_vsi *vsi)
> +{
> +	int i;
> +
> +	for (i = 0; i < vsi->num_queue_pairs; i++)
> +		if (vsi->xdp_rings[i]->xsk_pool)
> +			(void)i40e_xsk_wakeup(vsi->netdev, i,
> +					      XDP_WAKEUP_RX);
> +}
> +
>  /**
>   * i40e_xdp_setup - add/remove an XDP program
>   * @vsi: VSI to changed
> @@ -13317,10 +13357,12 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
>  			  struct netlink_ext_ack *extack)
>  {
>  	int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> +	bool is_xdp_enabled = i40e_enabled_xdp_vsi(vsi);
> +	bool if_running = netif_running(vsi->netdev);
> +	bool need_reinit = is_xdp_enabled != !!prog;
>  	struct i40e_pf *pf = vsi->back;
>  	struct bpf_prog *old_prog;
> -	bool need_reset;
> -	int i;
> +	int ret = 0;
>  
>  	/* Don't allow frames that span over multiple buffers */
>  	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) {
> @@ -13328,53 +13370,84 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
>  		return -EINVAL;
>  	}
>  
> -	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
> -	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
> -
> -	if (need_reset)
> -		i40e_prep_for_reset(pf);
> -
>  	/* VSI shall be deleted in a moment, just return EINVAL */
>  	if (test_bit(__I40E_IN_REMOVE, pf->state))
>  		return -EINVAL;
>  
> -	old_prog = xchg(&vsi->xdp_prog, prog);
> +	if (!need_reinit)
> +		goto assign_prog;
>  
> -	if (need_reset) {
> -		if (!prog) {
> -			xdp_features_clear_redirect_target(vsi->netdev);
> -			/* Wait until ndo_xsk_wakeup completes. */
> -			synchronize_rcu();
> -		}
> -		i40e_reset_and_rebuild(pf, true, true);
> +	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
> +		i40e_down(vsi);
> +
> +	i40e_vsi_assign_bpf_prog(vsi, prog);
> +
> +	vsi = i40e_vsi_reinit_setup(vsi, true);
> +
> +	if (!vsi) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to reinitialize VSI during XDP setup");
> +		ret = -EIO;
> +		goto err_vsi_setup;
>  	}
>  
> -	if (!i40e_enabled_xdp_vsi(vsi) && prog) {
> -		if (i40e_realloc_rx_bi_zc(vsi, true))
> -			return -ENOMEM;
> -	} else if (i40e_enabled_xdp_vsi(vsi) && !prog) {
> -		if (i40e_realloc_rx_bi_zc(vsi, false))
> -			return -ENOMEM;
> +	/* allocate descriptors */
> +	ret = i40e_vsi_setup_tx_resources(vsi);
> +	if (ret) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to configure TX resources during XDP setup");
> +		goto err_vsi_setup;
> +	}
> +	ret = i40e_vsi_setup_rx_resources(vsi);
> +	if (ret) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to configure RX resources during XDP setup");
> +		goto err_setup_tx;
>  	}
>  
> -	for (i = 0; i < vsi->num_queue_pairs; i++)
> -		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
> +	if (!is_xdp_enabled && prog)
> +		ret = i40e_realloc_rx_bi_zc(vsi, true);
> +	else if (is_xdp_enabled && !prog)
> +		ret = i40e_realloc_rx_bi_zc(vsi, false);
>  
> -	if (old_prog)
> -		bpf_prog_put(old_prog);
> +	if (ret) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to reallocate RX resources during XDP setup");
> +		goto err_setup_rx;
> +	}
> +
> +	if (if_running) {
> +		ret = i40e_up(vsi);
> +
> +		if (ret) {
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to open VSI during XDP setup");
> +			goto err_setup_rx;
> +		}
> +	}
> +	return 0;
> +
> +assign_prog:
> +	i40e_vsi_assign_bpf_prog(vsi, prog);
> +
> +	if (need_reinit && !prog)
> +		xdp_features_clear_redirect_target(vsi->netdev);
>  
>  	/* Kick start the NAPI context if there is an AF_XDP socket open
>  	 * on that queue id. This so that receiving will start.
>  	 */
> -	if (need_reset && prog) {
> -		for (i = 0; i < vsi->num_queue_pairs; i++)
> -			if (vsi->xdp_rings[i]->xsk_pool)
> -				(void)i40e_xsk_wakeup(vsi->netdev, i,
> -						      XDP_WAKEUP_RX);
> +	if (need_reinit && prog) {
> +		i40e_vsi_rx_napi_schedule(vsi);
>  		xdp_features_set_redirect_target(vsi->netdev, true);
>  	}
>  
>  	return 0;
> +
> +err_setup_rx:
> +	i40e_vsi_free_rx_resources(vsi);
> +err_setup_tx:
> +	i40e_vsi_free_tx_resources(vsi);
> +err_vsi_setup:
> +	i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> +	old_prog = xchg(&vsi->xdp_prog, prog);
> +	i40e_vsi_assign_bpf_prog(vsi, old_prog);

wouldn't this be simpler to
	i40e_vsi_assign_bpf_prog(vsi, NULL);

and avoid xchg above? then old_prog can be removed altogether from this
func.

> +
> +	return ret;
>  }
>  
>  /**
> @@ -14320,13 +14393,14 @@ static int i40e_vsi_setup_vectors(struct i40e_vsi *vsi)
>  /**
>   * i40e_vsi_reinit_setup - return and reallocate resources for a VSI
>   * @vsi: pointer to the vsi.
> + * @is_xdp: flag indicating if this is reinit during XDP setup
>   *
>   * This re-allocates a vsi's queue resources.
>   *
>   * Returns pointer to the successfully allocated and configured VSI sw struct
>   * on success, otherwise returns NULL on failure.
>   **/
> -static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi)
> +static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi, bool is_xdp)
>  {
>  	u16 alloc_queue_pairs;
>  	struct i40e_pf *pf;
> @@ -14362,12 +14436,14 @@ static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi)
>  	/* Update the FW view of the VSI. Force a reset of TC and queue
>  	 * layout configurations.
>  	 */
> -	enabled_tc = pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
> -	pf->vsi[pf->lan_vsi]->tc_config.enabled_tc = 0;
> -	pf->vsi[pf->lan_vsi]->seid = pf->main_vsi_seid;
> -	i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
> -	if (vsi->type == I40E_VSI_MAIN)
> -		i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
> +	if (!is_xdp) {
> +		enabled_tc = pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
> +		pf->vsi[pf->lan_vsi]->tc_config.enabled_tc = 0;
> +		pf->vsi[pf->lan_vsi]->seid = pf->main_vsi_seid;
> +		i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
> +		if (vsi->type == I40E_VSI_MAIN)
> +			i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
> +	}
>  
>  	/* assign it some queues */
>  	ret = i40e_alloc_rings(vsi);
> @@ -15133,7 +15209,8 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acqui
>  		if (pf->lan_vsi == I40E_NO_VSI)
>  			vsi = i40e_vsi_setup(pf, I40E_VSI_MAIN, uplink_seid, 0);
>  		else if (reinit)
> -			vsi = i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi]);
> +			vsi = i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi],
> +						    false);
>  		if (!vsi) {
>  			dev_info(&pf->pdev->dev, "setup of MAIN VSI failed\n");
>  			i40e_cloud_filter_exit(pf);
> -- 
> 2.38.1
> 
