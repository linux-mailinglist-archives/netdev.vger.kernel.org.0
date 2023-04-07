Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654236DAE2A
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbjDGNon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241036AbjDGNoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:44:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF5C16A;
        Fri,  7 Apr 2023 06:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680874946; x=1712410946;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1r9qcjwJ6MvBh50RMq30Gt4PzWWz1swP6Yc516tbsyE=;
  b=c2mqKO1wsQLz7DuBN1JSmqWpGlI3omkghOl1FAzCqUC7jRvyMxVCiwr8
   KitGP4kBKnNwFhAbvRvBhfboXp0rGB6YOf5fn+lg9G8Y0RMVStxdBtsqR
   +5T7WUPOBm1ctDDiQalkb2njXRoiDHp2SGdzIX0ZnqUx9HAi/blvMKLiY
   QprcQlHp1XROeIQHDroWBYnqzpkRBYORI1guezLrPIr3b9DR1lBLDmevN
   klX8dmHVfLKIdHIX3y2UM/5pR+6OZ/QS4jpir4LqQmejEFnrVRzrTbUCF
   JnF2HN9oF5JeBkpMMoylc9cTCkOSdZn8qCasAh9tilwxqSZ7ukrzzcrUb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="322627725"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="322627725"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 06:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="776837038"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="776837038"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2023 06:41:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 06:41:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 06:41:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 06:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVkW3ASE1aD+CBUX9eoVa/oBAXZymmnGmQqPvzzQ5xEUuoVGpRgriDJ8rCV5XdYYp6IaNUNIaznbM3qMD2q8v49IELD5Bysus4r/jdWMzGS2DR88OGJyp/XMIuUa0YBAeBZyN9akbKsC5REjg/SPuXRQtyLP0XvSV85Kx4f6L5I5d3HR1vWeiAJPsmrx4y+x3gFXjVxg+AdwI4wJZRTVFHVZ/qeybuka1PfHSEqju2JuG8HMnqfIo/OnhDXSxPqtB0/pNh4bFN8Q8JFqqA+6oDZv9vNdvrWc6DNPuirctPkIdjFIRqkTLbn95/qOBkA01WJNgcBH10hUmxLjrsuZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dtnxPirT5GjrdouKb3re4rcaUeiLx3Zf9rjofNHuEQ=;
 b=fiqFvRxUUdG3AS6n9V/Zn9O/2IjI/anA2feowCrZ5QVNI8qjbT6b3+eH61RwC/bg5NT0jVAW5SDsEpCdv9wHAnYeasY4kDN7fLOrqWazEy1SSKKJ/UI5BY/tGjqQjejHpHqyFK5Aia/p7achEMxGXV83rWtETXvxNSTsr4nPh0smLuWx2BlWBTCB+bmgFgaONupCkPifGL4Ac0ULsNOVSPvqikg0ExnMioHdU+O7EBSCr7lz9NbSs8D7ZSCCbPTpxcsGTjn6KrBcln6Bjn3oQuI5L8ETI+4jOMj7ppOmQKkqXrCJIFs5HhGjr2WwseWKaiGMm99H/n6JNuThU26kwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB4793.namprd11.prod.outlook.com (2603:10b6:806:fa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.31; Fri, 7 Apr 2023 13:41:22 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 13:41:22 +0000
Date:   Fri, 7 Apr 2023 15:41:08 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 4/5] tsnep: Add XDP socket zero-copy RX support
Message-ID: <ZDAddB+bF7W2OhY1@boxer>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-5-gerhard@engleder-embedded.com>
 <ZCsKkygVjB3J+XrO@boxer>
 <ZCsMNKCK0xQECDJh@boxer>
 <72bb23b0-50cc-7333-56e7-a887223ac6e1@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <72bb23b0-50cc-7333-56e7-a887223ac6e1@engleder-embedded.com>
X-ClientProxiedBy: FR2P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: a1fe5d84-28f7-457f-cc74-08db376dc695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/RGNKihJvojp3xueQVvYb3pTpkqmSRfsq6guBJfgmu05JkiYepLITRyHod/dfQMDyuaNcgfhVUrIJFxwq6HeFzVEeerf3uaKJPzmCr5on9pIps8AUdnox0RzDLpIKURwoEBHGjmc0XscNbZYf1lKJULzZ9nzycutQE+lW6aOkoLhcO9Za0oL+2cgezm+MFwgVnJNQhgEgCDqbh/CxmVrl9PcsE1WaVqgofOe1hiMW7Jtc6qRoj3nRPQpzEN94gVmRAk4CRvZ1TUpOsrSqj+yKoR+Mi29Z7eXh6LvzCy5P33HOkUmFWB+plVVoWdwR1mXpybW9TiFOG5VSiNf6oFwXSJoVMtg65JKMmN+yCBMZu1CwoIHQdasdCEUbPfBdxbsso0/94JvfJtBCUyivfjXYOiPhLxge6+/7LIE4nttnWhgIbkSLF+OekYY6unT3H59W2AR/QnTnRNvpFviDKmjxOhM3Q9OgIEThy8iEMyvzSUz8YpM3rH2sVytprGYjqYJfgdLqO5SrN8NNYPwcnXjoCKu4DGVGzEb+KSya04t6JWCK49dT4O9RQkPGJrOpCqUR5Mg7cZcFqb9a4gFAEevXlr/Fgu04ar4PpWLANcaJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199021)(82960400001)(83380400001)(6486002)(478600001)(316002)(6506007)(53546011)(26005)(6512007)(186003)(6666004)(9686003)(33716001)(44832011)(2906002)(4326008)(38100700002)(41300700001)(6916009)(66556008)(86362001)(8676002)(66476007)(66946007)(8936002)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0Z/1toh7ZDtel1jPw8BseQcWd2V4JQwEJZppbKS7oorId6StrltmniJM2dI?=
 =?us-ascii?Q?tiQRzrdWEbXy/2bticxQvd85Frrlch0bUdVa5k03ZL0QeWUeJVr6h58EbfjP?=
 =?us-ascii?Q?P67WIyVVmBXaMgraEiCZLiBirGMSUiyZAifQ/668NAScCBjYbl3MuTcBCtvp?=
 =?us-ascii?Q?xCcYXaPV+NqMeHh5sEtKEMigkqkRlNsys+l4uFfWc+fIMLjCg2O6L6n/zEYV?=
 =?us-ascii?Q?gLCYcMtzUblXP9JK8JJJihXt6+/DVQ3aidNfo6Wp9xlY8YSuKbCSOxScaa+O?=
 =?us-ascii?Q?BxRaEtd8ye9Grf0mEhVOvePLXVO8+8+LFFpclIiNaMDOP5TGj40dv41h7nOf?=
 =?us-ascii?Q?LN92UqViKkqx2Kv6+n4qiC45WEBNJzDoTBmd6n1+2pYGOdaf+JqraSHyZB4f?=
 =?us-ascii?Q?HLCuOALJ9mUstCijBir3ElEeA22QeC5DkuAwZhaLFTduKoZ4XSFnSUk07IPD?=
 =?us-ascii?Q?G1FL3SCaMbl6rBCFIFGJ9TnmhwsVDqO08ms9ivK9+s7bknJvx4OKxZ2DPyZw?=
 =?us-ascii?Q?24bT4nZ+elax5yu6iIv8IsJ0yd6AEbofFW9dD7l1ER9xTszSSAEskH7nB9lk?=
 =?us-ascii?Q?Y1YL7e3/JFuRycd9fI7B+iJ2nC4oqAFNir8p4PHiXboW3j0DGqEwUeMz66t9?=
 =?us-ascii?Q?e60dWG6szly4wtDYNBLACqfAb3N3EGqs8ukg1zYS+bwtaW//erVT9I+TWzyx?=
 =?us-ascii?Q?wf8onX5H+AkpciCywj/AStPdDs2Xw41GhMXuNDxOPgwpZunnzJVnYGUXv3M9?=
 =?us-ascii?Q?fH3872D8vzu00lM1XvNGfSwG6KKA7Rug4eG+jQl26x9DX4U694dqx0CRI/zf?=
 =?us-ascii?Q?Fyyp70j3Is16W4t+SaSAmWof35zUPe9G70P5d2/uNK75zWqz+PpEVTt9GAFz?=
 =?us-ascii?Q?5DBsnOzceum11CiXAd5J+kte85EW8PSS5M6HSobM9LczU21GiO1jXUW5UFEw?=
 =?us-ascii?Q?ucsQ94WfhseVn+DbZ3rHHLQj4GkBIG4nHUcbq6WmaNoMpb0Ob4qDl9JLUsRj?=
 =?us-ascii?Q?5JIXsTimCrh2zixThrQkKdoSA+FE5p8RAfx4rBaqsJu6+tp0HjWv6277ByDi?=
 =?us-ascii?Q?QNBP7dOvNVo/oE2RqAou0+nZY6k/cWg2iSsYCLpVyzGItmf78bOHQOs/SY7M?=
 =?us-ascii?Q?/L0vtmLqjz3nVxVhs+zll2hqCH4TeFPGvYzJl5RPtXbuowQWxhk42WRlMRFo?=
 =?us-ascii?Q?UsVUZV+k9VxGWebG2ZUATB9tQHpeOsC27ayPlUvTYz9b/KlJhauZlPIG3mqr?=
 =?us-ascii?Q?2OfOPfc2A0c09G1EhH5ZK3LN8f8MFwr8Lb1IFfkX9QU+CFhXN1KXiNcjRE4g?=
 =?us-ascii?Q?VcJZufv6IcM1I+Z9sAOZ4tsyQzhlTox3rT/n8IULX51OCWsJNY7RlLRcVfDZ?=
 =?us-ascii?Q?4ltBcBc4msuw7Y4RRcW4CvskytkP5/StsY7pazwr9xwVGBi057NpepGVEeaV?=
 =?us-ascii?Q?VI0kHZ1QclG2zQr70Rt0hPZX60OwgTbzUfv90yZ4wa8YgAZ/gF1SsrkStNTD?=
 =?us-ascii?Q?+fhkSOBNNrcT4vkp2XUuxJSlYD669nfgzX9DnjdNh8PeOLJtDg2/O9N/43F4?=
 =?us-ascii?Q?0WpmUW/89S80mtnkKSx3csrGTtzSFicsjYLxAI1bs9nnE+GqlTg67/QZ3S7G?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fe5d84-28f7-457f-cc74-08db376dc695
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 13:41:22.7276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yclqZZzfkxW6imSzUGEfsBZsr1PmmnOJBC5PxZRfeWgFdiQS5U3xmJDbC2iarSKRlLvgIuVndosjx0rh0I62EEvK8Ak+JTSi+qTxaDxKzqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 09:13:58PM +0200, Gerhard Engleder wrote:
> On 03.04.23 19:26, Maciej Fijalkowski wrote:
> > On Mon, Apr 03, 2023 at 07:19:15PM +0200, Maciej Fijalkowski wrote:
> > > On Sun, Apr 02, 2023 at 09:38:37PM +0200, Gerhard Engleder wrote:
> > > 
> > > Hey Gerhard,
> > > 
> > > > Add support for XSK zero-copy to RX path. The setup of the XSK pool can
> > > > be done at runtime. If the netdev is running, then the queue must be
> > > > disabled and enabled during reconfiguration. This can be done easily
> > > > with functions introduced in previous commits.
> > > > 
> > > > A more important property is that, if the netdev is running, then the
> > > > setup of the XSK pool shall not stop the netdev in case of errors. A
> > > > broken netdev after a failed XSK pool setup is bad behavior. Therefore,
> > > > the allocation and setup of resources during XSK pool setup is done only
> > > > before any queue is disabled. Additionally, freeing and later allocation
> > > > of resources is eliminated in some cases. Page pool entries are kept for
> > > > later use. Two memory models are registered in parallel. As a result,
> > > > the XSK pool setup cannot fail during queue reconfiguration.
> > > > 
> > > > In contrast to other drivers, XSK pool setup and XDP BPF program setup
> > > > are separate actions. XSK pool setup can be done without any XDP BPF
> > > > program. The XDP BPF program can be added, removed or changed without
> > > > any reconfiguration of the XSK pool.
> > > 
> > > I won't argue about your design, but I'd be glad if you would present any
> > > perf numbers (ZC vs copy mode) just to give us some overview how your
> > > implementation works out. Also, please consider using batching APIs and
> > > see if this gives you any boost (my assumption is that it would).
> > > 
> > > > 
> > > > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > > > ---
> > > >   drivers/net/ethernet/engleder/tsnep.h      |   7 +
> > > >   drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
> > > >   drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
> > > >   3 files changed, 488 insertions(+), 18 deletions(-)
> > 
> > (...)
> > 
> > > > +
> > > >   static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> > > >   			       struct xdp_buff *xdp, int *status,
> > > > -			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> > > > +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
> > > > +			       bool zc)
> > > >   {
> > > >   	unsigned int length;
> > > > -	unsigned int sync;
> > > >   	u32 act;
> > > >   	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> > > >   	act = bpf_prog_run_xdp(prog, xdp);
> > > > -
> > > > -	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> > > > -	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> > > > -	sync = max(sync, length);
> > > > -
> > > >   	switch (act) {
> > > >   	case XDP_PASS:
> > > >   		return false;
> > > > @@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> > > >   		trace_xdp_exception(rx->adapter->netdev, prog, act);
> > > >   		fallthrough;
> > > >   	case XDP_DROP:
> > > > -		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> > > > -				   sync, true);
> > > > +		if (zc) {
> > > > +			xsk_buff_free(xdp);
> > > > +		} else {
> > > > +			unsigned int sync;
> > > > +
> > > > +			/* Due xdp_adjust_tail: DMA sync for_device cover max
> > > > +			 * len CPU touch
> > > > +			 */
> > > > +			sync = xdp->data_end - xdp->data_hard_start -
> > > > +			       XDP_PACKET_HEADROOM;
> > > > +			sync = max(sync, length);
> > > > +			page_pool_put_page(rx->page_pool,
> > > > +					   virt_to_head_page(xdp->data), sync,
> > > > +					   true);
> > > > +		}
> > > >   		return true;
> > > >   	}
> > > >   }
> > > > @@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
> > > >   					 length, false);
> > > >   			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
> > > > -						     &xdp_status, tx_nq, tx);
> > > > +						     &xdp_status, tx_nq, tx,
> > > > +						     false);
> > > >   			if (consume) {
> > > >   				rx->packets++;
> > > >   				rx->bytes += length;
> > > > @@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
> > > >   	return done;
> > > >   }
> > > > +static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
> > > > +			    int budget)
> > > > +{
> > > > +	struct tsnep_rx_entry *entry;
> > > > +	struct netdev_queue *tx_nq;
> > > > +	struct bpf_prog *prog;
> > > > +	struct tsnep_tx *tx;
> > > > +	int desc_available;
> > > > +	int xdp_status = 0;
> > > > +	struct page *page;
> > > > +	int done = 0;
> > > > +	int length;
> > > > +
> > > > +	desc_available = tsnep_rx_desc_available(rx);
> > > > +	prog = READ_ONCE(rx->adapter->xdp_prog);
> > > > +	if (prog) {
> > > > +		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
> > > > +					    rx->tx_queue_index);
> > > > +		tx = &rx->adapter->tx[rx->tx_queue_index];
> > > > +	}
> > > > +
> > > > +	while (likely(done < budget) && (rx->read != rx->write)) {
> > > > +		entry = &rx->entry[rx->read];
> > > > +		if ((__le32_to_cpu(entry->desc_wb->properties) &
> > > > +		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
> > > > +		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
> > > > +			break;
> > > > +		done++;
> > > > +
> > > > +		if (desc_available >= TSNEP_RING_RX_REFILL) {
> > > > +			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
> > > > +
> > > > +			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
> > > > +							     reuse);
> > > > +			if (!entry->xdp) {
> > > > +				/* buffer has been reused for refill to prevent
> > > > +				 * empty RX ring, thus buffer cannot be used for
> > > > +				 * RX processing
> > > > +				 */
> > > > +				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> > > > +				desc_available++;
> > > > +
> > > > +				rx->dropped++;
> > > > +
> > > > +				continue;
> > > > +			}
> > > > +		}
> > > > +
> > > > +		/* descriptor properties shall be read first, because valid data
> > > > +		 * is signaled there
> > > > +		 */
> > > > +		dma_rmb();
> > > > +
> > > > +		prefetch(entry->xdp->data);
> > > > +		length = __le32_to_cpu(entry->desc_wb->properties) &
> > > > +			 TSNEP_DESC_LENGTH_MASK;
> > > > +		entry->xdp->data_end = entry->xdp->data + length;
> > > > +		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
> > > > +
> > > > +		/* RX metadata with timestamps is in front of actual data,
> > > > +		 * subtract metadata size to get length of actual data and
> > > > +		 * consider metadata size as offset of actual data during RX
> > > > +		 * processing
> > > > +		 */
> > > > +		length -= TSNEP_RX_INLINE_METADATA_SIZE;
> > > > +
> > > > +		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> > > > +		desc_available++;
> > > > +
> > > > +		if (prog) {
> > > > +			bool consume;
> > > > +
> > > > +			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
> > > > +			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
> > > > +
> > > > +			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
> > > > +						     &xdp_status, tx_nq, tx,
> > > > +						     true);
> > > 
> > > reason for separate xdp run prog routine for ZC was usually "likely-fying"
> > > XDP_REDIRECT action as this is the main action for AF_XDP which was giving
> > > us perf improvement. Please try this out on your side to see if this
> > > yields any positive value.
> > 
> > One more thing - you have to handle XDP_TX action in a ZC specific way.
> > Your current code will break if you enable xsk_pool and return XDP_TX from
> > XDP prog.
> 
> I took again a look to igc, but I didn't found any specifics for XDP_TX
> ZC. Only some buffer flipping, which I assume is needed for shared
> pages.
> For ice I see a call to xdp_convert_buff_to_frame() in ZC path, which
> has some XSK logic within. Is this the ZC specific way? igc calls
> xdp_convert_buff_to_frame() in both cases, so I'm not sure. But I will
> try the XDP_TX action. I did test only with xdpsock.

I think I will back off a bit with a statement that your XDP_TX is clearly
broken, here's why.

igc when converting xdp_buff to xdp_frame and xdp_buff's memory being
backed by xsk_buff_pool will grab the new page from kernel, copy the
contents of xdp_buff to it, recycle xdp_buff back to xsk_buff_pool and
return new page back to driver (i have just described what
xdp_convert_zc_to_xdp_frame() is doing). Thing is that it is expensive and
hurts perf and we stepped away from this on ice, this is a matter of
storing the xdp_buff onto adequate Tx buffer struct that you can access
while cleaning Tx descriptors so that you'll be able to xsk_buff_free()
it.

So saying 'your current code will break' might have been too much from my
side. Just make sure that your XDP_TX action on ZC works. In order to do
that, i was loading xdpsock with XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD flag
on a queue receiving frames and then running xdp_rxq_info with XDP_TX
action.

