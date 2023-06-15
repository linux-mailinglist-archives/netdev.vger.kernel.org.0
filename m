Return-Path: <netdev+bounces-11145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEE5731B82
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD7A21C20F0B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4241BA4D;
	Thu, 15 Jun 2023 14:39:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807C88BEE;
	Thu, 15 Jun 2023 14:39:01 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B27194;
	Thu, 15 Jun 2023 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686839940; x=1718375940;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3szpj7JGU3NnIawR3go2d2Zx7MeAt7I54+kmg8XfYaU=;
  b=X4/cIhyl2iG1PM7cCmxmrhwvbDcLb6sxI0suZPL1/iGaBbpCI53Lsu93
   YE+m0YEbZm4AC47TTuq6nBw253kyyqBhTPL3Ellaj6XAbZt7tzjOI+tYJ
   Xh2DNfjMd8EPj+QADgNSci+4CNLmwaOYXkdEH8KzV+RbmS9lnahWYc3nD
   0ETbg4PH2t0otX539iEdNht95C0X7CoXFauhCw/HXZxkUbYcNcfMIwDpR
   PwxOth6PVkU6kug7bx0qIznyTVYhtqBm14ii0tByGVPp4DB1aR6rvOxdj
   X8q1j7prpTBUD0cHKz6uhof6YY9xonDonPazaPtvbapHls/1I3+mcaM0L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424834305"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="424834305"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 06:49:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="802364525"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="802364525"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2023 06:49:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:49:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 06:49:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 06:49:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6h5xUeYB3oOi/qhsi77tMXOTTi8od3wz/0EEaX3MsHtwx3OI4PQPJVsNQeDCfTj01tAqQ7WcQClVv6MM25nAIFZGzxFChJjd4GZplbDH9M/DO0dTxBah9F1bBKAE2BUiYR4qpCXDk6q3SyPyQ04tPF7itOzy59w/K10SRrPfuNvsXkqhgwksnuVuT7LuTFHuk8vLIHdZ5mTrQHILJsWzCywRahDkliIoW+pmuykoZaJuYlP+psq3zAcS8uD5EI5WdNv4qbEC4xTQv17AS/Ps8awH5GOIos2q5jtWR6/DfaJVgjGhzrLStokZMf0NtXn9GbeokzkBVOck1TsNSV6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xhWC2PSwz4j+W5EqqK6JN3X01dBDwktoMPElovQeAM=;
 b=NYrrPC2GmnjMESH/Z2s/IPBh9+zagWljmgLG5ddMPfQN31HHrZ5CTxpiRJLBn8GB1y2L1jCucUD0NYEUru+bQIcomiFusRwaoQ8HPOF6dyBTlm7B31Rv9H2Mdm4wJ8YOuJYq5yedr5BA83iG3qw+t2hOn8O/aE63w3GriS1LqK828B+sWHXS/AjU+afsigLwuGp13gb4w7+FfOoLzhQInmOwIyL0p1dfq2rF7GoQEcLWYK/7XjmFHKIyCfpC3ITprWxzriwkKBX6/JYUfF9n96eZk2NMITJs0rxkr1Sa3NucwzDah7SEAjl3lCbP3ExEAgGxTBLaqWMUcr8dtZTfHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6450.namprd11.prod.outlook.com (2603:10b6:510:1f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 13:49:32 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 13:49:31 +0000
Date: Thu, 15 Jun 2023 15:49:23 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: YueHaibing <yuehaibing@huawei.com>
CC: <bjorn@kernel.org>, <magnus.karlsson@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <maxtram95@gmail.com>
Subject: Re: [PATCH net-next] xsk: Remove unused inline function
 xsk_buff_discard()
Message-ID: <ZIsW47S1Pdzqxkxt@boxer>
References: <20230615124612.37772-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230615124612.37772-1-yuehaibing@huawei.com>
X-ClientProxiedBy: FR0P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fa059e-c67f-4533-5251-08db6da75848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJhVtOHWPNOTfIv01POamYgrwOFmd5YNK0cauno+LZXzzvUjo4zWGJFI1wTgSI3WdJA91QI3i8UGQ9rEveK9ewRQ8kuIUrI7PK/tB26Sb+WtsST2sf4cBCcxLOaae13veERuVwE5YkoXvxvozwbGii0raCeYdPp+0ZMt0Rgr1AwQkOM7yOLoJPUhmADaVc8BFCHDlUatMwE+pqQlf2G35wla+uac7oofbX0/iRqQdzRTN4lk4KPt+LALEDb0Ee5lAq4RAR5cFtGaWHl3JeeYeT/ZxgJozeZdjht5J8miWfG6rBtGDnEg8b3yT50+9yqmWFwBCQpAnbeSA93vGqk/LgCnHlLrkZAm0cv/PRx+dbOzSvOiCW5Rsbl2fbMJzZ0Nf1pl8Voe3nDjWLNPOr+ReQh4zgEGQVKnH9gIe2SWJtSaXsWrB13YUZZADaAD9VhFLTQdrogu5y3uKnZnByPjLEQm8VSw4rPSDLyoEuA5crt1jU0YV/27pXeVefczOlFZmW4YSXbLygNylXnJJ2v6scp6bccL5FkGEp5Lgp1b2hee1HxSX7sDuQ6EP9UxQkTW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199021)(8676002)(41300700001)(86362001)(6666004)(8936002)(33716001)(6486002)(66556008)(6916009)(66946007)(66476007)(316002)(4326008)(9686003)(478600001)(6512007)(26005)(44832011)(7416002)(5660300002)(83380400001)(6506007)(186003)(2906002)(4744005)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9dEdqS3WdSXnGLUE8VtnkNOBBWbOFqoS+Mcry/8SzAK3Dr5FhZ0LziZen66D?=
 =?us-ascii?Q?18y6iy/UGfC98ZNSjHLYp7xk1VrhWgVb91UPSoY1DhQlWSfwlkCO/odoiELm?=
 =?us-ascii?Q?pL/nJHJe0DSQ5S7MInIkbZZHLVzroLAFgDvCGke37rAGT6awEH7sBfcd23zi?=
 =?us-ascii?Q?uK5fTQgDfnLADtPE9yFaCKzzGCEkLtyHdInHFjV/CLfHpFSl+us+SEZkln13?=
 =?us-ascii?Q?iyQbUiTmd6LpGKPcP+KixaS6q5tzkCYpLZauoEDIiyPGLtvR7icZm2W71XcU?=
 =?us-ascii?Q?CSo8kzvYhMfLSEsNijFw/vDrfm3UmCpOk0i7XZT1ZK7VRjTs2ZPkhl/+UU97?=
 =?us-ascii?Q?J9F9M8yV51c6DSlSN/pwBeC39qIOEw+6AKEq1l6fov05vQE93GbuCkCqncKj?=
 =?us-ascii?Q?R4oiuDuaH/YJKhiJb6VVyBYlRZmI5vHiEKpfAn3FIRS/bVeFXtHVdQ2e0Exn?=
 =?us-ascii?Q?LXxPBf7buSCYG4PCaEXN2oTHHUlklKwGWilx0trk3AABPsQI6XzIaC36CqRj?=
 =?us-ascii?Q?zsCMRtt9DH9nUnTAdAX2inM+ExQgvQKIgKF8aaKDWLILtEggfIfjbJumx8u9?=
 =?us-ascii?Q?tMUFyK1Al6q69as+aeWY5GWdKZsh5+/eEEg5ZriAyQBHKhUYBIf1UJn+v6RA?=
 =?us-ascii?Q?wEgIzZNI9KjLe0iOsPM38huslhTZNu8pEoeT/ol9LgBSqtIE5iBtMfudXhuB?=
 =?us-ascii?Q?Vb6iXhJctL3s5z84IDmZbPFAAnWo79t5fKAPy+F5Eoht3xDxR3yx5sRmTl17?=
 =?us-ascii?Q?QoLLFJ18gbgDTqHAWZYDb7axHjSEnufIfG8xXRX5EItJjDVDDzg0xTp8udpz?=
 =?us-ascii?Q?NPiTt9JI+8nG3itGBihZcTWmLjvhhhmkerXS/kQBhn/lgij2o3LC2uEsbRL/?=
 =?us-ascii?Q?VbiljiR3L692+7Cg9ppOxWo4Qzn1Pu6ZrOe+noLm+9LPbrFhgcAlLfPNDG0m?=
 =?us-ascii?Q?I2K78O5pGDxexs1Ed2ycpTo41K441KWI7ghv6hEcFl0LasijRBkvgG+BXRFk?=
 =?us-ascii?Q?HIYZt84eVqTIPYLmlQIRepd79Kpiisl1CmubuLD65y/+kQjN517yyZY9Gb1T?=
 =?us-ascii?Q?i09nlme11xyPxklE8wANSzrNfkKteJsPpmGUAC6qNYuKVq/QfNGqJEg/NILz?=
 =?us-ascii?Q?ok75u/uzUUNXyBmy5EoKrvqcYlTXm4Nf70uBxuUpiJ+sydneqHTNZCVuIgGh?=
 =?us-ascii?Q?OpVXY0KVcBot6/BKAu9jNtFwsI1Ntikvalc7FXig5pJbTbn7TUGt6ZnKIllz?=
 =?us-ascii?Q?5ovTOgEpBcoDQq1POlOiYenHGGqR1XDzPd5Ly9S20Ml3FF5ZMy1J4usU024w?=
 =?us-ascii?Q?SYyHaFin4jfrd2txszG35P9WWu9dvDIq7Ef5BgiqE5e5rmquFOI5csVEdkIB?=
 =?us-ascii?Q?8Ynr0YZcLEMVWJHHnV9EVKt8hS4W2PRqUgagBQ9dq7IuGOs70h8PchVjpObo?=
 =?us-ascii?Q?iuPFOY99UdItdh/XnQbx/6ggW2sFqw+G+XgBeZpBKa5FRy6dInmn8J9JTzSD?=
 =?us-ascii?Q?V3ADIHE86zfIFTCb0fMumrt49DpZf3aBOCflTHvsbpHP8GvM3I6gXqp1nLnG?=
 =?us-ascii?Q?tpwAlMM0PqqKlWef5eI4uXQoQty5LDThZyLuwcbT8RUjmHywhTrRSghQny5j?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fa059e-c67f-4533-5251-08db6da75848
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 13:49:31.3211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9r0Sp2Ed0nzrV6S+2M7Qu8hMk9inbNmr/MtmwDMq7ffwAn1oi7xhynYQwchLikbq1oqzMUpqqY9CBBN+8iQKxu8kbY/9NN7GUN4331m50Vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6450
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 08:46:12PM +0800, YueHaibing wrote:
> commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Yeah this is a stub for !CONFIG_XDP_SOCKETS...

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  include/net/xdp_sock_drv.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 9c0d860609ba..c243f906ebed 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -255,10 +255,6 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
>  {
>  }
>  
> -static inline void xsk_buff_discard(struct xdp_buff *xdp)
> -{
> -}
> -
>  static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
>  {
>  }
> -- 
> 2.34.1
> 
> 

