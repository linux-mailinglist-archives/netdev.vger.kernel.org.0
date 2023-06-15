Return-Path: <netdev+bounces-11133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED4731A82
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C139E281835
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD89168C7;
	Thu, 15 Jun 2023 13:52:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE715AE9;
	Thu, 15 Jun 2023 13:52:41 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B472117;
	Thu, 15 Jun 2023 06:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686837148; x=1718373148;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bHd+b6MAG3+ep5uussS5dlV9akmUuyE6SqasrTHAn8M=;
  b=fBQHgsKBW9ZXCiLNlg2MjodrIblfkrtvODOBb5iW3b7IkrtWDcCxsxMW
   8OEbijXIb4fgUQG/KrWwnKvzkneMbjGgTpoYyIFomns4gjitIx7vEuBII
   6n2loKrB/gPVeJdZl81KmdQy6NdTEU739M6/XRf7TwCqlWvP7m1WjCo0x
   I7HJk252npzqhTBN4HI3h8vVIbO9r506Ao8CBU2MWvct3W5xl/ak0bA5Z
   g/LXAzb6btSnSfY/cqMh+Lk9ZBkFI+Y9oSn5Mx7gDBrVLZBChW3KV1wxS
   bxJcWwkaX0SG3p3olPPHcpXYRCOk37hHzMpKA6FJAzsuRsA4x+jqZPauh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="338542042"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="338542042"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 06:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825288135"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="825288135"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 06:52:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:52:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:52:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 06:52:01 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 06:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwAgto9EDA32xiit1WDXGsK9x/i/5D9N2QtyRU+c9rH5oMSqca+97nYXqtventDZ1hDZ2Li3YVC6/QrrPVmkSoiWk2nGuOo+xSmiZ+Y5601Tse1pKS+ywIszo72zdvBpDffq0kybP1flG4ijTo+SaEJm/PhZQPztJZWz+TrO2oua9bXpqWiwwWee8+MLPcyV77n4doFZSr921aHtVUqDUWtRyob9hAB5pQURcFseZRxGcXUrjhdHSS0f/nuUG01Ppzuj5xxLMCdBM6f9F5Gj1ojxHupwm9yk+w7g984v/XgI68TAP55NamaTs4bp1sj3Oy7vKPry+vssywwq0KROnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=db7edsj+rHADB8ng6bnhkZg3mAq+bbWWlm6GfGI2rp4=;
 b=iPaSvwAv0XSFqiEoSaqfiJk98dEucHZVxWjTHyRRgKvPx07+cPGMOhkQD3iJDjsX9ngvXwthjgxID0f44Oz9UDAn7amUtLi6JJv/ELj/ESnzwboVruNBted4SX1LRbSmRXLlSSFoQmC0T+gSsJrgxrwTpjnfKxc6WZniI1CQmKiPjRkLPICBmVVy0ee1/f5BPlc8TqUxs/zwZBgxJqp05veNs0eVwdWlve+wWykYc9EW5acWPGZqh5m9xXrMTev22pottY/uiv+ShPjBtbEx2WmxABd0bqGmDYxeswoaMhTmSJ8iBM9oVvreSUtD41NtRaaJ+z7osLotTaDAWAVTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6450.namprd11.prod.outlook.com (2603:10b6:510:1f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 13:51:57 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 13:51:57 +0000
Date: Thu, 15 Jun 2023 15:51:49 +0200
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
Message-ID: <ZIsXdcawAWc/9Izo@boxer>
References: <20230615124612.37772-1-yuehaibing@huawei.com>
 <ZIsW47S1Pdzqxkxt@boxer>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIsW47S1Pdzqxkxt@boxer>
X-ClientProxiedBy: FR2P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: d492321e-ed39-4a3d-9413-08db6da7af15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmUWShlThwSswNsXB6ApxQE+YLGFpQ2YCgxKoY9JXXlwkZQOhIpp0BHl8FxhaYHDp/X0ncy77hK+azdfKKZLfcVfH2iZ3oTpl/oQ0AAVDdgWaklk+7zXbkqMPjclQMBJU7XEUOBWaq8O5I5g8sJX7b0g4is5u6ZfELwVa1MYDsSy6WVY+V9lkAsYSl6ZStfYIGD7S7rFiucnQtVZ1UC+2XnJmvv/bPL8XZiiRhnder3ubYDRwxp/ipuuWvgDrEHB8SKPR5DIJz/YrB5NWW3oA6353YkJedPnY8yzg7R/4o+TLmDRhTMR2aSCbjg7iWZv2vv33vyhfydUkNDjH81jMQ2Nmr2/QV8Ztm+wdC7OllDPTFOlYL9diZV3k7zJ+SrbostXtsQ39Bq1kSH+GAKlrPo5H0w55i0navMZp7sAreRbecTz8cCHDZc67jHak6sm2k9i5hU/igt6s04YBHQNo6Zhv0m7FwsUFdyY5yn5rFClL6ysqTVfRt3iYMlRbTMV8Kdd85I5zzZWrvfcc9MeY4rheNCEE5oIIjYgyog224VGxx66/aC0LM0LG5us1Har
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199021)(8676002)(41300700001)(86362001)(6666004)(8936002)(33716001)(6486002)(66556008)(6916009)(66946007)(66476007)(316002)(4326008)(9686003)(478600001)(6512007)(26005)(44832011)(7416002)(5660300002)(83380400001)(6506007)(186003)(2906002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?teUph3uAtWyu1cjMhRrSvDfZMLJQNZvM9Ibk65mOdT9WKKr97LTPOExb2s0g?=
 =?us-ascii?Q?NRh0YfcNsu8FJ9Q+sxQ2GlUwZx1guolnHlCPCJjTKh/8toCFCwEvdb8Ge7Fh?=
 =?us-ascii?Q?tr1D577kebPcMLaf7q+1bBdSHjKpBs8PveR98VQROfl3v4B/s2uapWqdxtHs?=
 =?us-ascii?Q?247jPsZsmtmQXHzriVU79+p2b95pu2176c98XoZYHs+rCVJlFvz34+550mIq?=
 =?us-ascii?Q?2dwLwXjEx7jydUt1RIMxKkrcuqcUHS1RX6ESZ9BIYGlotBvYx3exALu2r18T?=
 =?us-ascii?Q?E6eESuF4ycio96kzcgJQ6SdxP9QiUy16FvIC0Fgl3uiMpY6LyMfSzh24uTZb?=
 =?us-ascii?Q?hM1lKLcl80h8KwRizPZjaaJWsrabREpJNESsvw2drxePecxW9m+UckQ1MucN?=
 =?us-ascii?Q?gc1TTVBWsZzHeii0nWb41qeGLSsB8o3pQukFDkfF91nWiuMhCoznEEx1Aq6s?=
 =?us-ascii?Q?RytCAUiyoRHKMLy3ile7Th3bjKiU1v70k26cST+VxeyGgsku0WY4VsTYFVjH?=
 =?us-ascii?Q?eOEluh9zzECSIdOGCjnd3afH6oruy0yYWT3/3EN13n9rvztrybBH+3SgBPpr?=
 =?us-ascii?Q?32HdUak0kq/dVX8KeuEmpLvzAm/kdx9b2mkkAgrEFQOqDV6ndcpuJGaOZvQP?=
 =?us-ascii?Q?vv490/eijNXnrnrHeo5LxNoXoJuYyq2A9j8R891lMjmIqMOUFkSuPKZ49Kmk?=
 =?us-ascii?Q?SdTHwu2sOe7Jahzu1HxMzWyLLrHCkYBk5CTSD85ORXNT8dfDyDjOoi+qYc7j?=
 =?us-ascii?Q?z6ZTgMSMNjBgQjuAR7uOcKInYKJ7VM7+0Lgr0+uOgWyb6mzQ+E62SfkaVIkZ?=
 =?us-ascii?Q?BCjnhjyhYAUgjVUDtCUwcOi3+4aaB/Cas3HEBajrm8m9fkSRWczasdEmaIVZ?=
 =?us-ascii?Q?Y0/sQl9p0hejCWEHnra2zoBz2xxvEYYVEDpe14r6Nnh6hMcgTm4kDUNG4vJH?=
 =?us-ascii?Q?S4qJ/XLYgb2Xc6QTcaT7EnOvroKqi+EcM7/FdZCe/HVi+EslBtCPA9fTTDhx?=
 =?us-ascii?Q?tByEJidDpujhbF2w0FjO+Yqp9/zPyriCx/pH7o0nCucsr0tLGVpTRJw7VQu3?=
 =?us-ascii?Q?LDWCCO+BiJ59PKraoEA0vpPQiLZrgKJAiGdrEsV5X+IDTPJvi/3AKXi7DpYw?=
 =?us-ascii?Q?DKb3WEcGi7Y79HJPajf/lqzzfSNFuPFT0iX3n7lEijkgsq6EoHW0v/iALTtk?=
 =?us-ascii?Q?TJmLC99Zdolq4uvqH2zFJrmdELkZ8w5WksxmL+e3EVPP8LFVtebjNnnMhMMC?=
 =?us-ascii?Q?kkj6JYSWNy0LdNztzAFYi2dnGHwF9mi/4I7yrsH3RZ1OTt2coLr47BHK/b1R?=
 =?us-ascii?Q?ePP3bJUgUaprxJ7BYfS5MAKEWCX1Lhxhp7wHS0Ebo11+qMq7ERtvZuktH3Qs?=
 =?us-ascii?Q?22Gm7QYevE+x40ElfyRgA9LP3QsakbHDMl5H0yk62ARScuwfxpqB0nl0yuEP?=
 =?us-ascii?Q?PfLZIo7fjLj2cjz40lAAMo6BKLqI6N908qW2Lh+G61OpjthFGvbE+Rr5nh01?=
 =?us-ascii?Q?7UGyeTtZA57q87ddBdDf0ao6Ls8chdnMR7gTu1yiW/fUp/wkbysLtp+TVDnL?=
 =?us-ascii?Q?RMPfeXd9Q2iDHTE0KRKNVZa6iMBfX4ZqMz7Ub8whS/DV2F8ftXlGdnwbRPwB?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d492321e-ed39-4a3d-9413-08db6da7af15
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 13:51:56.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVd2dEQeI9230FhD+oJDevHIusuL7Pe7NvtcEthhsLQ8DNKGyQaZVYN7r9laUIM+ngx8ei0qvN/FaFQKtNzpy503YznALCPrz9NJiLI0m/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6450
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 03:49:23PM +0200, Maciej Fijalkowski wrote:
> On Thu, Jun 15, 2023 at 08:46:12PM +0800, YueHaibing wrote:
> > commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
> > left behind this, remove it.
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Yeah this is a stub for !CONFIG_XDP_SOCKETS...

Wait, I am not sure if this should go to bpf tree and have fixes tag
pointing to the cited commit?

Functionally this commit does not fix anything but it feels that
f2f167583601 was incomplete.

> 
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> > ---
> >  include/net/xdp_sock_drv.h | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> > index 9c0d860609ba..c243f906ebed 100644
> > --- a/include/net/xdp_sock_drv.h
> > +++ b/include/net/xdp_sock_drv.h
> > @@ -255,10 +255,6 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
> >  {
> >  }
> >  
> > -static inline void xsk_buff_discard(struct xdp_buff *xdp)
> > -{
> > -}
> > -
> >  static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
> >  {
> >  }
> > -- 
> > 2.34.1
> > 
> > 

