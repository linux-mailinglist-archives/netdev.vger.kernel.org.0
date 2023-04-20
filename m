Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135D76E9CF2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjDTUTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDTUTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:19:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9ECE47;
        Thu, 20 Apr 2023 13:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682021961; x=1713557961;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xdlL3ApTwCMPivO/pz9klFuMyMkszLrpOqIfbIsErpA=;
  b=Ais+lk8vDN4c7+u317M+XX7iErtedYSR7TxTA/BjH8hV5/9krEVHrspA
   mhp0vXPbBs98oZygIzd+COzwkznJi3ql4jkSbXJUV4uzmf40dkjmzaRFL
   NH/5mWLyR8X3uab8J7cQIE0Tnv5iLqj4QNbcHbCC+MNu/BcAmxNmHhZuw
   lZAf9s2Z+VYQrp+Rh2S6K+xzLR9DqKK4qx5OL1pcOS6VxskDHuz6TKUYQ
   6JOCUzdzCufcB/s1N0LsRaL9++JlPJS4oNOzATdVHvHLtoZMKywWntCsR
   3CZmFHRKO9jkUqKLTPDPt3OaNpyCLV1yQ02Z0AhOCsAP7gvRqikLelKF/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408777395"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="408777395"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="669473502"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="669473502"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2023 13:19:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:19:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:19:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGa425z0OGjP4k45b/ZdgTiFNATfS3ulYfpMaOogfGjXPr+DFrzZy/QUSXL9j2D4SXr7Rljk8Eatz5Y9Omko+FKBTVNVqhE5Oq2THjFQu6/yPsU3CZJmVFhdLb5xWq7ijbCJw8lKLXE7ZlyU9WMIduq06OpUGXuBdiAOllSBOhZKAbDutTYDGsc6z/+5hEjtiisPiwIppXtP5lTcjwS0ubDDEyPTN9EigLNMBeUp4zZWhEyfi5ubWGpuHSe2lByxZ7LYDZDnjzklQ1o4UoTxC3ILQxID9PtditoH6BQQU4baXjr/JtoR4ljZPqQok/w5WSuGxWRAss/EP95+Yp/daA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/L+tw0g78vbPAdG5lnmwBTdUbml3psKODZ5p1HLQQac=;
 b=LVy/hCdR3+zBWIRIO20jWHLMfTC8Sj9p9vXnuGiEmURIsjIv4oagZwqTDHkyP9nVGnxlbLlK6VfPPES7gbodTA3/S100Y8CPBJa4WQ7HnmOPzZ9dExJKWlh+uCoyIuN1C+XH3H78YWO3MV1aBNvN0AT5CGrO8yh4131qlvFqNUWOE83GQjkQW7NSgGZLpIqw7PcV1tgENKEd4g0LhSYgBBcuhhFwpdWI2WHGnR+cLtNg6PhgkceYb8ghWJtXBKAvNnt9NREnNOFzEOnUx0D9XTmxeP0Bmvek23EVnFTNizn+XUeoLHqmpXW+hCZkB5bY1EZCKDkSMVxj5U48Jr93pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO6PR11MB5636.namprd11.prod.outlook.com (2603:10b6:5:357::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20; Thu, 20 Apr 2023 20:19:08 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 20:19:08 +0000
Date:   Thu, 20 Apr 2023 22:19:01 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 0/6] tsnep: XDP socket zero-copy support
Message-ID: <ZEGeNYHh+NatBDq+@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230418190459.19326-1-gerhard@engleder-embedded.com>
X-ClientProxiedBy: LO4P123CA0150.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO6PR11MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c1f6b0-54db-471c-0659-08db41dc7ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cU8cPVbEyx9udVjHHWo7WyXMiNmbaWRdM6LfrG2F5n00pOkMBujRezadea//7qKE1wYSRz20KcQNqiCI7gsRhoCa75uwpBdpWSydxTdmq3MZrAdIjrjl+pW2PzpmKeyanayQ/YcO/aM11ye0KhrdluBB4PugQwlShw0NyN3WhRuma63GuiXcZ9kJzlYK6ljRlCtpRtkX/CushqQqdDxBu4f7/1AHig1f6ghKqKG8RMRTAWoIkMgFS4CslAnic92CBW5OooThFIxcV/vKdbWXT+B357n5lKj4SUbXWlpgWlZ6Z8SoLe3hElWSC6Z8MgB78T2YOawHE+EyIijUDq2rkWjgj8O/B92XC7XnxD6DR65lbrzWs8O2TgkM62R4FceSTMRVyyPYTiYRZ6W4zoAMA1HvLF4Pxk8rxdP/EA/Ii84ASUMpxKP5mFRXWYnbdkwYuokmfUevyFi7g64/09vGLUBkhfXzKEnfhttTclSN3dTJtxEKxaciakazFinTslizNAXdGhBXrkdODfj5yy2duSVE4GygSE7gCbweN6T2613uQ7ooNfJa+i03/ruCfEv5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(6486002)(6666004)(478600001)(86362001)(83380400001)(9686003)(82960400001)(26005)(38100700002)(6512007)(186003)(6506007)(316002)(33716001)(66476007)(66556008)(66946007)(2906002)(6916009)(44832011)(8936002)(8676002)(5660300002)(41300700001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+z+1PXsRDylprAx0Jav7ytEmtO32Rstb9YAw/MWrEyYnm2PN0KPBgFqjCOPX?=
 =?us-ascii?Q?yoxjx1fgdh2xzZfVF46NI+hGt5kWXHDcrBHmxHZ+e5kqErkMjHv3bKTg/2Cn?=
 =?us-ascii?Q?sfycttD8IUO4LHjXbVPTCJp4VLW7RwrJzp0Jovd3Gb0PnCPUiFy4dJgrmBnm?=
 =?us-ascii?Q?4rTYrYgH3mV1ilEED4znfmR/RdPxb/AQON5pjjTerQ6QqE2kX2Lx9eHyZ39T?=
 =?us-ascii?Q?y16msjCmb51rbQrd0MgPszxuzhM3a925bynIvRjk5scm38vdJzP1OwVbGAch?=
 =?us-ascii?Q?oKTvpqolPqSCI7YX7i0vw1AxIYDvSN0vCxfFL8N9UVSJ+5zk/JtcLW6LouuL?=
 =?us-ascii?Q?V+2gVvMpHOXZgg8BVF9CHE9t/BGaKHHIr+zPJjGTk9QVRBQR7OHU5A1vlgMb?=
 =?us-ascii?Q?kR9G19kfXMafAZPnE0raYkmVHSNS2V/lqOqEcHkCc8QBl+MIP+ZX1kJ2qLuq?=
 =?us-ascii?Q?i9k419+spHilOtBs5XPKvYIGpx3GXfVZ1ZnPx9Rxxz+7Ljnp393zLpBXj08i?=
 =?us-ascii?Q?dvoKWdon1dZwwhe2Gp0IXJ5HoDNZNMWy8plKJvSrx3QzdST3ilEqHdAPBm34?=
 =?us-ascii?Q?BnUkahm1OFSoEvZxdDO5glYkLUBxMX6+UG2nE1b3jkODjyKgehRFo2YUnNjR?=
 =?us-ascii?Q?GUNC+d+AygFlxOAEiMtSYM7SeCbiPFdOLlr/Z2cNBEfjTwDh+7wx7w7Slpit?=
 =?us-ascii?Q?TES7YSA7NZYWJD7E7EZx7Zs0cGq8cIXDyOxf2IWMJqTuX/yupZcMJSOv6N4g?=
 =?us-ascii?Q?1lbOhn0tu2iy3QVyX9AKUHnwqzBNjRdnzR5DUiyfgTA6z1tgoMlGUazbWFSv?=
 =?us-ascii?Q?xzgFT0dui+AijN2cZ308lNn17u8+Go7hTLG2sZXLGwtnu0++81qpdSICvsJE?=
 =?us-ascii?Q?AHK7XRNWJFWuN2Ej9+/JB0nEqA5DDNVGUa5iV+YAUiuUGDFNTz9650V/7TC3?=
 =?us-ascii?Q?QZj69L8P29tOzrXIN3gAj8ygSeSmYV9t4vYJ/zLhdNCJ9tR7rsgvJ5HrGBrs?=
 =?us-ascii?Q?NfL+e/tRcAQ+GS8Era+p0BDlumF95+il6kE+gAZbRFK0W0jP6xyN8eWbsnGv?=
 =?us-ascii?Q?Mg2xrSCLAPVcHkaFsxzJ/jPqTa+WcdYZkn3TV7tzUs2T+WoHag+WezqFynU3?=
 =?us-ascii?Q?21kP3k7mAJbQ9nCCNU14Lw9ZHNw48EktU2spHCvt/H5YZ2Zx8/VNytatAk9i?=
 =?us-ascii?Q?AAEHdL6OLJUF+xXDU7j41DDSA3U8WYHMVZB7glvfjQeVj8HQAtiD/dLAW2Xh?=
 =?us-ascii?Q?U/+gld62DxLZH/A5BM3A4wio0IciOQhPxgxViA+sTv+aGavbREpUoX/uvwQ/?=
 =?us-ascii?Q?/WR7kmmp0nAesBCVIuXbqkF3j7x3kLfd+uTEzST3rWI+Nd8zgeTXrGAbNir+?=
 =?us-ascii?Q?709BYLNwfs7tSrix6lyoNgmcActSdbzmh/aMGXVyzsFOm7kq7iz50jpDsfWl?=
 =?us-ascii?Q?xr85uJgoNOeyjXsqULf6FdAbxVfSshi2wAE+EI6cNbCwq1hZ0QSeObwBnFpc?=
 =?us-ascii?Q?txvZ76MDL9Z02IjuCdwAYL2g/c77dCcahQztcPdOHDxtXHKIdcWkszK/jXMq?=
 =?us-ascii?Q?2z87BWbqK2bqgBQpcbQX1rG0d4FGfFdxMq0A59+vs6Nu1D4MI37+xci+fX0q?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c1f6b0-54db-471c-0659-08db41dc7ec7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 20:19:08.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xM10Ztkhp9WTgMrn5wDMtl3eF+/SeQ+4lDvCN9JximoKDyhLibhaArydtlJW2XTWNEqEFf3Crp2lDsysjJSkr7DZlB0TJXtvqlZKAcBU5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5636
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:04:53PM +0200, Gerhard Engleder wrote:
> Implement XDP socket zero-copy support for tsnep driver. I tried to
> follow existing drivers like igc as far as possible. But one main
> difference is that tsnep does not need any reconfiguration for XDP BPF
> program setup. So I decided to keep this behavior no matter if a XSK
> pool is used or not. As a result, tsnep starts using the XSK pool even
> if no XDP BPF program is available.
> 
> Another difference is that I tried to prevent potentially failing
> allocations during XSK pool setup. E.g. both memory models for page pool
> and XSK pool are registered all the time. Thus, XSK pool setup cannot
> end up with not working queues.
> 
> Some prework is done to reduce the last two XSK commits to actual XSK
> changes.

I had minor comments on two last patches, besides:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> v3:
> - use __netif_tx_lock_bh() (Paolo Abeni)
> - comment that rx->page_buffer is always zero terminated (Paolo Abeni)
> 
> v2:
> - eliminate modulo op in TX/RX path (Maciej Fijalkowski)
> - eliminate retval variable in tsnep_rx_alloc_zc() (Maciej Fijalkowski)
> - scope variable entry within loop (Maciej Fijalkowski)
> - use DMA_ATTR_SKIP_CPU_SYNC directly (Maciej Fijalkowski)
> - union for page/xdp in tsnep_rx_entry (Maciej Fijalkowski)
> - provide performance numbers (Maciej Fijalkowski)
> - use xsk_buff_alloc_batch() (Maciej Fijalkowski)
> - use xsk_tx_peek_release_desc_batch() (Maciej Fijalkowski)
> - don't call tsnep_rx_reopen() if netdev is down
> - init adapter pointer of queue only once
> 
> Gerhard Engleder (6):
>   tsnep: Replace modulo operation with mask
>   tsnep: Rework TX/RX queue initialization
>   tsnep: Add functions for queue enable/disable
>   tsnep: Move skb receive action to separate function
>   tsnep: Add XDP socket zero-copy RX support
>   tsnep: Add XDP socket zero-copy TX support
> 
>  drivers/net/ethernet/engleder/tsnep.h      |  16 +-
>  drivers/net/ethernet/engleder/tsnep_main.c | 863 ++++++++++++++++++---
>  drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 ++
>  3 files changed, 822 insertions(+), 123 deletions(-)
> 
> -- 
> 2.30.2
> 
