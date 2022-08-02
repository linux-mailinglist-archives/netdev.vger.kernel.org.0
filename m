Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82945587CAE
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiHBMyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiHBMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:54:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70114DFC5
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659444869; x=1690980869;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E1wUPx8WdlNXyJrFJQ+ty062dAHRa3OnApCnkTPxdI0=;
  b=YrIwWBhoPq/N+TDVkqPAyC9H+mj+IYcELVXI0ra/rjUjEPx9nHzuLpf9
   d8exBoDVYsMP03p3Lexn/W5ZdB9qfHCO1u0rDa4N6GAiXH2ieSWUZ8ISl
   +zk3AaCOJ0LL4LY7Uv0MMCxpnEiSJULctS7V0L/sMqXSkf8ukHGBOnQts
   gN6HCY1iQJtAaqoOqaolEIai5K8EMiFbX2pouTfU+TALAzJFHebUqOpBK
   J9u3Dq7h1c8P+0nWcI9HEQcZFcV1dOoWa1wW2Hn18b02OYWpDRkoW8yik
   /RZk+E6GdCuxQ66PeY/BydulubukDGe3zMkCeBQUMNnWkAu/YBC4HRADs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="375700254"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="375700254"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 05:54:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="691836283"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2022 05:54:29 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 05:54:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 2 Aug 2022 05:54:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 2 Aug 2022 05:54:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7qqNmZKIz4py3phIl6I0hCgCKHU9S0oh4MXNPZnUzzYuK1UzraqmFlQ+W5byAg0cHGhdWqMRkUHK55rDddbBFYQbBWs2glpCecuItXpznDv5WHpx0A/6o8N+jd1YUBprRMAi7CDpdLHFvC2x9wskORidI8sso3omUcLYecfeYBQnWFoZHzerThJccwiXtaVgBZTey6MmLMJppcIyjolj2VIyfL7qySKfMenSjjrZJcdoQB3pC/vOZ9eQReHfYQmL/YDM2QuGWqKP3Q0ryY7yEbzrno/ZzPuttpbnoYtK4DpU2E5Et0H7IKtthstE55scDIgKwIdk49/eNPzNlaYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyEecCToIUekO8mDHEX0rDpz0pfN4W8bVcNf8toX5SI=;
 b=UqKyZDo21oKDO8qrPLxoqM1XqKooCc04wksFRHFyfySdVc9LT8jlVabUGC+HrOu4PWX/f02WKVmHvJAwWZB0yN+koni+gDrEDZUBjl0F9ZIY4qcc/B9hWlh7EIj1bKomQ4odqhK8jxfkdWgtCYCMOB6gpqEF8UoYn6lNPVHhEY3mtY050H7pcJAKFkSWKyAr1jNvpX9eB/Brwf1mElw0IcpplQt0J4cnMZSpsmqhCCgAZok3h+giDdBdIPQHj1x700YxaIB63Qch95CGz5Xv8c8mVF5W60QzuTL2dYFugcTpJha+4jfcQwtw3mVl8BZfb9mntrUiDqxCkOH4IrQsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5236.namprd11.prod.outlook.com (2603:10b6:610:e3::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.6; Tue, 2 Aug 2022 12:54:21 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669%7]) with mapi id 15.20.5482.015; Tue, 2 Aug 2022
 12:54:21 +0000
Date:   Tue, 2 Aug 2022 14:54:08 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Message-ID: <YukeZM+7rzmzdlD6@boxer>
References: <20220729121356.3990867-1-maximmi@nvidia.com>
 <YufYFQ6JN91lQbso@boxer>
 <e87bd57d938ff840b567a05ceb1417cfb9f623e1.camel@nvidia.com>
 <d57971bf4ff780782e68ccb1d9fd0c5bb1577ea9.camel@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d57971bf4ff780782e68ccb1d9fd0c5bb1577ea9.camel@redhat.com>
X-ClientProxiedBy: FR3P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c7bbf4a-7265-490e-1393-08da74861e95
X-MS-TrafficTypeDiagnostic: CH0PR11MB5236:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sMEBv97Ar8RkHwEwSuWimKKCX4AxQdO2vO5FN/1QH8hookuIm8oVBvD0bqkRtgYXd4npHU2A/vzS6hzzUY2rT9vXDUjMxj73bR5k1zv8daroZFGSoLkVPAiz8f6pFkKpCrqInHy2UGZ7Q8RsYfMO+46rqiHz0PzNCngF7D95TRb2NljmpJ9k7JXB3DoHXsnwEqV4GglvjykcQrhgKi9CDlNmnXPiQJG49z/wfTgLVXbtkLdBfatMt3kvkgAPQYUBlyIIYnEiMT2ho65cCtK/dIUDCqiZyEdJFf+g3ozmVQhLc30vaXnLqVfuYSXMm8f2FyXMXmZWW9JRQ1L7ltVrrlLIG8n4bJuBP+CNA0fwq5E9nLtCoDebKxRjlLJrN9a25Q4cdah3BUE6v7hDR34v3HilEJ3+nRHkc1dVB+uMeMboOWLSMg5neMaQUtMfKxxIOid28c1Yb8rQEapc3qDfoeRvs32pN/wP3ktfcGRmFF+HKJr5sWEPJ6vbx5vM4p4tuW61epNUb8ykY0B9rUrPJVc2UYAf5b+f3Ngk5tgBb3aKkUf/9TuM1rG3b8T19p9+r4M59z1hBMA5f2JePlbehQHstTFn6zJleYNHN5Lu+/qn82yR1Dx2PYebMOmiuvOaGZPyQI/idzgkCkywtGHgNLoYcmdq2xZcJ2rVIzVqdBjCX6hR5KBqqv6wKnPJMIgT7AwB2kbR38YT7ptWPfM8eOYsmuj6DopTcO3OI88CXdO1mQ65zSb3dLX73U+Hjq5CFBcdpGU1H754g274bs/XwGM5f4760YI0kdcwqBNCh4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39860400002)(376002)(346002)(366004)(136003)(44832011)(6486002)(186003)(478600001)(38100700002)(83380400001)(7416002)(5660300002)(66946007)(86362001)(66556008)(4326008)(8676002)(66476007)(6506007)(82960400001)(33716001)(41300700001)(6666004)(6916009)(54906003)(6512007)(316002)(9686003)(2906002)(26005)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZp7Tz22Kwq/+nTFkSHkXIxhzhGb40TECTfgbR3m9gD0TqA6KpJDGDYtffFt?=
 =?us-ascii?Q?2w34KEH0YNIBrevC0SB74cawjaFC+Ey/v4U55W6b8J0zYx+LdZOoPJVgBl8Y?=
 =?us-ascii?Q?Jm/Gikmxmfjog5ilWc1wTPcjmAq6QWPmPNtvmTjeGqLxJqDzyZ+VCCwFyG8b?=
 =?us-ascii?Q?wPAW+/LOlBV6GrXGOLqyjiSC/RsuOj6Y1agM+NbhA3ddy3LEEfxs43CLB0Fk?=
 =?us-ascii?Q?PEpcfKKo/VIx/z1v1AHRfvJ7GLrhClpSW9ypIXG5bKL2ZHXkLYGa8KUOSK8V?=
 =?us-ascii?Q?W8OlPPKNUrf4X8iEE01qmLyAQoD8nXIX3OJgpneKwWj/HvHYxaZw+BbIRqcj?=
 =?us-ascii?Q?SsGyEAvfxDr1l8jIPhqCDro8Nv7NqfLbQW1RL0PO7fdpLN9b07ErI2/zY5gS?=
 =?us-ascii?Q?oD25Xt800dB5oDySvDINbQjdCQRLtJSz5vYUtB7D04wqXoSIV2rrC6WHXqZP?=
 =?us-ascii?Q?f8/xcdsBITHE5bXWvZOMew6ua402vq/pxOZUKYaisbr+gHFzUlJnSZdvQaRc?=
 =?us-ascii?Q?TAtbjCdsHya92MtLBPOWzEm7RcUFYh/U1DKUT5k4RjXkxCkKnW7SCNF1ITge?=
 =?us-ascii?Q?ygPZ2tK7BEI742t7m1tjN2f7th8nmyiEdJyYlJD4C0ONp+WYlJV5fMm2sbZP?=
 =?us-ascii?Q?klig7W2xPac/1J4X0+BoYy4gwXhEsxwolVS032DDCSCQJ/WCN2eq7ikeO1mS?=
 =?us-ascii?Q?fN9kkH+nAaTiNYTXnpyG4TBKdYZP7mSdCqfpOqRbdnb+b15b/4SvNnbls92R?=
 =?us-ascii?Q?skXVErlN4f5oA6sKRkV1yNLQH+OjU1lj7cVqx0H5C51z7W2EVz8dkOxcBz6Y?=
 =?us-ascii?Q?w5jKhnQyZL9pMvlivcM96GrDRGnIYDFrZ70t8zCKSxLaSj6NH/ZPPXBmWrHp?=
 =?us-ascii?Q?gYYs7nV219iSaL3E7yRJcO3qGHKBeXRDQCGAes8cPmcWERtbwo1E9h7NodLh?=
 =?us-ascii?Q?Q2g7eqnQ1nJm8/DVq22BmgsCv0CkaKZT3jaAouRFKLk2HV5f+VbAD5kotPY8?=
 =?us-ascii?Q?1EZYb4Ge8aPLYoAevPzbWLpRO9nR7se/d8USgqd1iwGEeqdMasXyC5wcKOAN?=
 =?us-ascii?Q?LQh3tzPVVt+NmuEH8bRbAGziS6UA8kZIx7AmvvsB+60fHydwxGfWUJX/Gh68?=
 =?us-ascii?Q?TV9oCldaJFc849+JeEF8Y0pErkpcDhJ2hwIvgtxWhBc8QtI2MCr49B2DAPM9?=
 =?us-ascii?Q?93nYwWKckHfcZQOpTBhAvXQKJL7WddVKGhE3VYCLbnFg5UC9dfUZ/SmBNiFZ?=
 =?us-ascii?Q?c4eOFGvVj4Nvb7yu9iPamwz3mZwNQaT3kAFjxwxtIEBE1HOLCztxd++qyBiT?=
 =?us-ascii?Q?D3m4Gj022mJQKLVQgLJDhout8z93CGpurpl6xccU/t5B2Ie8vdwOXQq4cRvL?=
 =?us-ascii?Q?O7UN1g59ayVXzjvrgfu+ySpN7WOwFTyciwPXFMb8qDNowmlWfDXLDOoguN0y?=
 =?us-ascii?Q?G9kvu1an99qdwfii7H394Y4FLG92gWEy0e9oEbmISJg2zUSwcQPkmWDMpwkR?=
 =?us-ascii?Q?ElQm1GnM4RZKa1uel+XqgyH0N0ECV35U65hCYNJ79AVDbirKTDoFtTUWHV2k?=
 =?us-ascii?Q?HA83VTJhywZ5N04zDm+VdInHSPiR+YG4WtjXXZrriqvrGqwoXR/oc3kKR0Rh?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7bbf4a-7265-490e-1393-08da74861e95
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 12:54:21.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSc965M2AXVyhADJV6CcEDQXONWSOfy8meMpnwjfrmr671o7GiGNnqnh6RQi/54glCn+z94uZhdeuEKoUNU0b8FARs/hYBntQNVtWjOWyFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5236
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 12:54:15PM +0200, Paolo Abeni wrote:
> On Mon, 2022-08-01 at 15:49 +0000, Maxim Mikityanskiy wrote:
> > First of all, this patch is a temporary kludge. I found a bug in the
> > current implementation of the unaligned mode: frames not aligned at
> > least to 8 are misplaced. There is a proper fix in the driver, but it
> > will be pushed to net-next, because it's huge. In the meanwhile, this
> > workaround that drops packets not aligned to 8 will go to stable
> > kernels.
> > 
> > On Mon, 2022-08-01 at 15:41 +0200, Maciej Fijalkowski wrote:
> > > On Fri, Jul 29, 2022 at 03:13:56PM +0300, Maxim Mikityanskiy wrote:
> > > > Striding RQ uses MTT page mapping, where each page corresponds to an XSK
> > > > frame. MTT pages have alignment requirements, and XSK frames don't have
> > > > any alignment guarantees in the unaligned mode. Frames with improper
> > > > alignment must be discarded, otherwise the packet data will be written
> > > > at a wrong address.
> > > 
> > > Hey Maxim,
> > > can you explain what MTT stands for?
> > 
> > MTT is Memory Translation Table, it's a mechanism for virtual mapping
> > in the NIC. It's essentially a table of pages, where each virtual page
> > maps to a physical page.
> > 
> > > 
> > > > 
> > > > Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> > > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > > Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> > > > ---
> > > >  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    | 14 ++++++++++++++
> > > >  include/net/xdp_sock_drv.h                         | 11 +++++++++++
> > > >  2 files changed, 25 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > > index a8cfab4a393c..cc18d97d8ee0 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > > @@ -7,6 +7,8 @@
> > > >  #include "en.h"
> > > >  #include <net/xdp_sock_drv.h>
> > > >  
> > > > +#define MLX5E_MTT_PTAG_MASK 0xfffffffffffffff8ULL
> > > 
> > > What if PAGE_SIZE != 4096 ? Is aligned mode with 2k frame fine for MTT
> > > case?
> > 
> > PAGE_SIZE doesn't affect this value. Aligned mode doesn't suffer from
> > this bug, because 2k or bigger frames are all aligned to 8.
> > 
> > > 
> > > > +
> > > >  /* RX data path */
> > > >  
> > > >  struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
> > > > @@ -21,6 +23,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
> > > >  static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
> > > >  					    struct mlx5e_dma_info *dma_info)
> > > >  {
> > > > +retry:
> > > >  	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
> > > >  	if (!dma_info->xsk)
> > > >  		return -ENOMEM;
> > > > @@ -32,6 +35,17 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
> > > >  	 */
> > > >  	dma_info->addr = xsk_buff_xdp_get_frame_dma(dma_info->xsk);
> > > >  
> > > > +	/* MTT page mapping has alignment requirements. If they are not
> > > > +	 * satisfied, leak the descriptor so that it won't come again, and try
> > > > +	 * to allocate a new one.
> > > > +	 */
> > > > +	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
> > > > +		if (unlikely(dma_info->addr & ~MLX5E_MTT_PTAG_MASK)) {
> > > > +			xsk_buff_discard(dma_info->xsk);
> > > > +			goto retry;
> > > > +		}
> > > > +	}
> > > 
> > > I don't know your hardware much, but how would this work out performance
> > > wise? Are there any config combos (page size vs chunk size in unaligned
> > > mode) that you would forbid during pool attach to queue or would you
> > > better allow anything?
> > 
> > This issue isn't related to page or frame sizes, but rather to frame
> > locations. As far as I understand, frames can be located at any places
> > in the unaligned mode (even at odd addresses), regardless of their
> > size. Frames whose addr % 8 != 0 don't really work with MTT, but it's
> > not something that can be enforced on attach. Enforcing it in xp_alloc
> > won't be any faster either (well, only a tiny bit, because of one fewer
> > function call).
> > 
> > In any case, next kernels will get another page mapping mechanism,
> > which supports arbitrary addresses, and it's almost as fast as MTT, as
> > the preliminary testing shows. It will be used for the unaligned XSK,
> > this kludge will be removed altogether, and I also plan to remove
> > xsk_buff_discard.

Ok makes sense. I only misread the mask though, so maybe use
GENMASK_ULL(63, 3) ? Also, saying explicitly about MTT's requirement
issues (8) in the commit message probably wouldn't make me to misread it
:p

Besides:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> > 
> > > Also would be helpful if you would describe the use case you're fixing.
> > 
> > Sure - described in the beginning of the email.
> 
> @Maciej: are you satisfied by Maxim's answers?

Yep!

> 
> /P
> 
