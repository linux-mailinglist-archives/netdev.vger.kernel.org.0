Return-Path: <netdev+bounces-2217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 957B0700BFD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F325281D6C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4301427A;
	Fri, 12 May 2023 15:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75AB2414A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:33:19 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D7340E4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905573; x=1715441573;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hRdPQAcVsdfmBv2H3VflffKTKlPKjHAq49TF9q9k5LI=;
  b=KV+RAHyAnc4Nod4eoCcJcIpXKgylg9/7CGldJFf3mf18/9iutMRTQDid
   8j+sETbr2h8FLiklvvQPuS2LryiXFo2vFl6xePzoKOFlJezVk+DUzMYz8
   70WdrJqPwzPzVE8sfQGAnovS79Aw8AABvzZp9BYpgYiJPAGsK6h+Gl6TW
   i+rnlTgBbvUux3PVEkxpP+mGIMOk1g9Xa1F0cmL8lUi7SOc/mLvk55fdM
   iG5zOkb8ALu51zPxIBs8QtTx3Rj1/XNeDC7hRBvHo2l69Vk9axYRj7F1O
   7XSf3gdFbDQksLgglndHqYqE8UPg7m92vN4eyafhHKzn41Pnz9UX941pa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="331176456"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="331176456"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:30:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="812120167"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="812120167"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 12 May 2023 08:30:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 08:30:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 08:30:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 08:30:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 08:30:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I73RkHx3CzpzUngkcT21TDTm+SxKultJBpIR+WbIic2AqXQA7wMCr4q6MY3i939J6Hjgi1BPaNU9MmsOK6u8Tcfdl232D35f0Xy8n6dAD8nsc8nKtZf5cCDbjW2hFpK2fMZC2gGZOBdoSnuFwljwE9X+Vjv47mx1U+7BOvGQ+6Ve1FY2wG0yu+B4v7rAliVPe27hVU1BrnT/XedJza3znuLVuUrLJ3dAvemyJZquyfn/1DPugQw2E44yzQIfRfwtUQrpbhasIcBeCjYhg9voW+zNMFnJB70VhwR8GsCJikY6dZ6u0PxxOGiqankJ4O7O4Yr3RBzKTUNmPladlVPbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kH/K/z8Zd4gYsOgSUcAjla5ICmb0tFvK2xoEla97lDw=;
 b=kSVf4bfKV85xamT+yqfs3gFhHLH0euhRIG2flSW3od7bgPlnl/EHYgNBbuYnVPPnESGaaPSHYg+clISyVP9w6lnwzvjtC1zHLL20oZb6zPcwuvLiUaJ36d56WgUBLAe2rLvCWqopJE+W2rTXvX5DPGBYzA37iAKQbo6wxpPoP3gxZStu07RVeRPTqgoSsiwr3Ii4W4dTif5DC8rnMvxvpvX0yhamqwbpnCTFG7Lz+QHxA4iwJOgkEaXunubnx7efwcJD++fFLBfMcw1IE6yxB6hl6oUQwaw7MM6XtCTMQysZ2B+xLqKSxgMX6/LnOm/lGq6Cj95o0szLKSczIIae/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM8PR11MB5608.namprd11.prod.outlook.com (2603:10b6:8:35::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.23; Fri, 12 May 2023 15:30:41 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 15:30:41 +0000
Date: Fri, 12 May 2023 17:30:26 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Neftin, Sasha" <sasha.neftin@intel.com>, Naama Meir
	<naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Message-ID: <ZF5bkhhs+Ue+DZfG@boxer>
References: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
 <20230509170935.2237051-2-anthony.l.nguyen@intel.com>
 <20230510191428.75efff66@kernel.org>
 <SJ1PR11MB6180BBD70342998B2C639472B8759@SJ1PR11MB6180.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6180BBD70342998B2C639472B8759@SJ1PR11MB6180.namprd11.prod.outlook.com>
X-ClientProxiedBy: FR0P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM8PR11MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: cb354726-7a6c-4b33-dfde-08db52fdd7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z58CrGGg1etkUmLh/EoidssZUvxIUcf6Z/JVjtMIcMH+g5fDlnW2iwU/V8ql1YOz1QHLkdgI/qYmZFTD4HGWzaleJaYxxE5nTeM3I8rIM6Zo0nYer+wEQsJvAfzzGkh5QmvhN9IlXcFU0JOcTarIKoC6d5L8v56G/JBHM2r2sbIr91A32WGbJYTxouLTivuYa9h9aqbzz1aHZJB+ARYvhD8E0ORXrbe0zIxHlf8yit7C1zhOwtnUUUYQrvr9YkApqnX3mXCy43J3MWXKFS+5EUvtJKRqmckFLpEMC3/4Y/K+FLj6deWufhm3eKuLsks0xt8AevUZ5Novm0O7gMLz0l83T4FFp9vB7rhl9c9w45ybI2BERQiMu8ilpZ45EdiGCRVD9wrCUQ7aZpc6WnFGOURxYqKRNi5Hrw9T28XWfu1l9Nko4MzvaQVYYTCJ0L3WXZtK6AbsptEnr2jIKRTLeoKJZFTelVwK3XD8hYWRfzue1vV1SLkQjJv8na1mxqyEASQ/xHRpGtEZRNGUN5gHzq+8QB2MRWJlwpHO5q2T8p0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(86362001)(6486002)(45080400002)(966005)(54906003)(316002)(66946007)(4326008)(66556008)(66476007)(6636002)(478600001)(41300700001)(33716001)(6862004)(8676002)(5660300002)(6666004)(2906002)(44832011)(8936002)(82960400001)(38100700002)(186003)(26005)(6506007)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dSjbSTrL5GU4QSrTUZqaI1tdBqb/iAJ83QLClDyACzeRboCHd4g0nmSid2rN?=
 =?us-ascii?Q?5ggYutd8DI9fdOFJYcd4DDFn2hjnh/uBUQ9+ueJhtidd2yOV5sgUKGpvKcOc?=
 =?us-ascii?Q?GjIpVU5g/QqcyiG+CieErEWGVFljim02vEX7CfInGJPCbRKclY03+G1Mkxal?=
 =?us-ascii?Q?NAmT++hdkwoGDMHFZwOzmjiu8YnjTQRoZYyUfX7sN1v5pY6Fm/eEiTtJi3oy?=
 =?us-ascii?Q?4M7g4RTR6DvolNX7JnWDi0fWS7PI5S+P1LCALqwPoMyRYTbMVobuFpHPbiIi?=
 =?us-ascii?Q?2S5tgznz23FRNmCvC/bcbnUJCWpUrKxNjLKWKnuaFnAfVk80kyoltiwmfovC?=
 =?us-ascii?Q?1ifJ2RgCdgyoHQwTKcvl37ZhgwpSsCPjD6jXY3/BCcF4rtRfTBUJ5eKNZWTV?=
 =?us-ascii?Q?6VkvlO9LKuU9ZRGYXKwygVmVAHnxn65QA5XNxw0CUD8AjNiOTiAYBI57je5f?=
 =?us-ascii?Q?pVIk+7jGqIe31ba4z1Cl6sGD5marttQG/I/VZFniJB6XCinVC/BkvgOUV1AH?=
 =?us-ascii?Q?eWJ9mN574NiIazaAhQSYt8YXpHSwgfXaFS0cPr5b/K+eDyyHJLhlBizbreeK?=
 =?us-ascii?Q?mm5P7xepCCy9cPr25Msms0KA7TWz/zmaIAUJISF01MSuRt2frgWTQfKmciUF?=
 =?us-ascii?Q?P0QJ83VnRVm7jjWOzeBdGryfOhhYKItyMVCAWiJMehEaPT2B465MySWTKWTs?=
 =?us-ascii?Q?qFWTGgvZWG98A2gixF/1Cpda51bsAgHAjcLIGTl9p+YcmoOeLy1qFgKq7g02?=
 =?us-ascii?Q?i7GXnlJQYM4VW4jmyfHmkC1qlkcPyQ2drpj10+9z4cVblApmvNaVaQgQmqjH?=
 =?us-ascii?Q?Uva9o8eYIGT9wL6LOO5eriVfxSYGd3niHJ9BdxuIpj4zsLRV3MKOgpDETPY7?=
 =?us-ascii?Q?XQiJwLEN2XXrEsj5z+NHOia0Ic9/HfzlHhz/wdE6UkJvtaGulEPE5zmljtLM?=
 =?us-ascii?Q?lZgrMVqnnwlkBirWax2d8tGt1+weHH58xCYZTmFM9Myl9fTR9l0MnYmF97C0?=
 =?us-ascii?Q?GvwdNGDhaOaKc/W55Ww5wMlua39FtHS5PNQg2Vmh1Xrnv3QmZKVCMDUhTnKQ?=
 =?us-ascii?Q?WDmKOCisobvcAy2pOy2x7VkLhl4IHqLBRfk8qS39aAkFcCk21XNOc11t3bGY?=
 =?us-ascii?Q?W5NWCxyZHlGF1EZJ/5cAoDCgy+m43wxCiqhPSZXAXeeWYAt5iRuYZOzeuS/C?=
 =?us-ascii?Q?zwBPMswpHlUj/ieF2JYmSonHgy/G4UyPied8iNPqDLEF2B3rsfN/YiNbcX7w?=
 =?us-ascii?Q?8e6F1AIbaiwmvXWBfLhQIoKAy8lQvOWAzIze5snisISi8hwUedd0K5OFJnf/?=
 =?us-ascii?Q?DYoGg/O+lf67h8hHcvn7792u0sfDA8upJ9oNgp5J75pLd9yemiyTzxlVh32B?=
 =?us-ascii?Q?m8U+z/am+bEHKdggReTQQTboFRdxg33UaYWGFVw48ZmAV0ORjA8H93rNVlAy?=
 =?us-ascii?Q?tp9qnmDH9DHdrG4uZfNKXYFvhV9zlks37ToFNGtmEEjisRtgCFstMTp2o8Gy?=
 =?us-ascii?Q?NYO5ypFQ1ODd3MbXlXtH8nZAoBPQAPwWkbQmRI6NFu6ZzbDdI0Pbmum7Cngi?=
 =?us-ascii?Q?ijU07SywL7wXfgnmAJ28A2UciTJJFiGbQA7nveVRWRp2OFiXfIRasfndmsuy?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb354726-7a6c-4b33-dfde-08db52fdd7f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:30:40.8667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mz1GdPU/kWplERle1OTAL1/+YCwR3cD0QkkMZfLhgMuaT/FaQsbEYdoHzPSKyTQbhbshJJdz3pW2ggIUpUgtH34X+Zah2/+HY875k7oU8OA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 08:51:23AM +0000, Zulkifli, Muhammad Husaini wrote:
> Hi Jakub,
> 
> > On Tue,  9 May 2023 10:09:33 -0700 Tony Nguyen wrote:
> > > There could be a race condition during link down where interrupt being
> > > generated and igc_clean_tx_irq() been called to perform the TX
> > > completion. Properly clear the TX buffer and TX descriptor ring to
> > > avoid those case.
> > 
> > > +	/* Zero out the buffer ring */
> > > +	memset(tx_ring->tx_buffer_info, 0,
> > > +	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
> > > +
> > > +	/* Zero out the descriptor ring */
> > > +	memset(tx_ring->desc, 0, tx_ring->size);
> > 
> > Just from the diff and the commit description this does not seem obviously
> > correct. Race condition means the two functions can run at the same time,
> > and memset() is not atomic.
> 
> While a link is going up or down and a lot of packets(UDP) are being sent transmitted, 
> we are observing some kernel panic issues. On my side, it was easily to reproduce.
> It's possible that igc_clean_tx_irq() was called to complete the TX during link up/down 
> based on how the call trace looks. With this fix, I not observed the issue anymore.

then include the splat you were getting in the commit msg as well as steps
to repro.

from a brief look it looks like ndo_stop() path does not disable Tx rings
before cleaning them? This is being done when configuring xsk_pool on a
given Tx ring, though.

> 
> Almost similar issue reported before in here:
> https://lore.kernel.org/all/SJ1PR11MB6180CDB866753CFBC2F9AF75B8959@SJ1PR11MB6180.namprd11.prod.outlook.com/
> 
> > --
> > pw-bot: cr
> 

