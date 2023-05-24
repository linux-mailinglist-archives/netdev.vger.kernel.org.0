Return-Path: <netdev+bounces-4935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9E770F42E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 412D51C20C4D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797B2154A8;
	Wed, 24 May 2023 10:28:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B66FA0;
	Wed, 24 May 2023 10:28:43 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167ED8F;
	Wed, 24 May 2023 03:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684924122; x=1716460122;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QQ7K73NTgg/WkXNSjd9ZnlHu+vZ9qWtl5CmpJ4ewcmc=;
  b=CYJhf5DhnXShFD4Bj+n+e4qGtohZu4ITq7tfG/DqbPKLKLB/zrpYarI3
   uhW+BP2Ktkv6C+zH4+tj2DlXcNxFbITH2IG4zPLC8rUfvF3QEVOdF9Z30
   FZ1asWHJOW1cDk8Jz4CEH8QZf/hDmd+ngFOTxO4MvQUulQF8Ijox53Q0T
   YW6YNhrixsgKXwbBK3QmzlwlXlByKbJxjnualCLPwhH/UD+qrdjBQ+qyp
   Gz4AEN9t5I1FFfWVRXnERdaVBcmaHBR3cLYAOrXPzDnZez6HW2HmsMagb
   SqtGSkT3laJefe4k7PFJnn7BmKcQ0mbK4ezjbd1UE53zGP71N4O1WC9L5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="355882256"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="355882256"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 03:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="698481904"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="698481904"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2023 03:28:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 03:28:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 03:28:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 03:28:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+kTvyVxOqTDGseizB3okNUSmfGpXLQfgfRpChOpjrG18Sgixl0ac6HYgWtT6R2a7byC05jJkmcgC4DgCoHgdwSrD+B5ZkzNFE0uclGX8Rl3m8BrReX7Lp4TWayFqhgrwTljI8tU9eMy5CF+/JXVmrspSyEgEXdZPmii6T7WYCS2R1Fyuf4Ann0xsW71rYu+71/9KG6n5RMebU6HpRYx6A/xF6IgYhKP6QnaYBJmXshRAwTeQau3axUJlFvN8U9qSI82namFlvdnPJRDdoWoBAxMgtORt+rS6/R6qWmJea8LbBkjjLJv7grm+9AUpr6jbBdlJz1nDffJiWJ29290ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDBKjyYpS1KC5HieyiUFS8giTlaKtdQTh8gLeuoVIN0=;
 b=DS9dSq0kiomwmYiKbLzVCkZTWHc6lrtw+qy6h+cB7xnYuCC/tElNeY4rXNi4D/HWQo12Z59/VoG/ipqPtekQ8AzG4WzIBCdeAiDikaQ9hXip2IMbkpAUe8gXREiaLTaenmGaDeaoBPeu3Ofy5UF81t5hWqGmXSk2c9BkeaXWNYYX/M5Sao0j8cJqFDean1BlC6IV5TJitJz49Vof/cMXSIY66SVqd2dPN+c9Vpcqnk4FNAkK86MmCfEq5yU3W8atGXkf2w0SMbqvWlyOmgqsd3IXOkJpQgd4zvXmqDsZECf3+uaCzer5NzzyIry1Fl16zJ4Qh2lkp/SRvWBczoYQ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.15; Wed, 24 May 2023 10:28:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 10:28:38 +0000
Date: Wed, 24 May 2023 12:28:31 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
	<tirthendu.sarkar@intel.com>, <bjorn@kernel.org>
Subject: Re: [PATCH bpf-next 05/21] xsk: add support for AF_XDP multi-buffer
 on Rx path
Message-ID: <ZG3mz5+5BWtR8+lS@boxer>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-6-maciej.fijalkowski@intel.com>
 <ZGdEn1BLbdcLx/FU@corigine.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGdEn1BLbdcLx/FU@corigine.com>
X-ClientProxiedBy: LO2P265CA0374.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::26) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB5536:EE_
X-MS-Office365-Filtering-Correlation-Id: 6030ffbc-8d90-4eb5-9cc1-08db5c41a335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Xfu+YDJqprAQJf2juZJOebiMTVaFnqm04O8i29aSiBLV9PMgICMe0AwAvzcKSXYTNOiyjQ0BWpc3zOQX2G2JliCehkz1gvcdgFkkkfPfNfIi8FTjrxPsqbpaJ1too8nvc58Cq4vj9TeKo0CGh2PnyYaAZLaLu26WBi4jpXPvt88xvtFR2VY5G4sl+1yEWd+s0hvYJnnby8Yt9tDOIyIEZCuGxgjyKHeRQ53TtZOO2DDtW6egI9Ytv0caTeCucRH36GRO+VvGknpZARoQwh4UBNdOwNxzz3mlAI0iyrZXspXHaSI4aWazPyTDS5NCJ60KXrVqAa9L01S8GSnDrEo9BXjKB9UhHV7p+tUxO932lFL+L2NbO/zhtG1FoWSv6zJsBjEASsrAplcGDhtTZ/yKF5SgPpvwlQxYmEp5XKfoWqvdi9sBX3ISj9sBvkWXUddTpgrE03NzRxzrsUbQi2GyqPBc7LXq77t+gMug6HZJwA5Tq7OrQMyDythkdc/J6bJqqayKOa27QLhOCDpVIoTtrgKm55A/C4SjqTVYXNSTXl+y1Z8vXGTy4hO76mNf/DC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199021)(8676002)(8936002)(44832011)(5660300002)(83380400001)(186003)(9686003)(6512007)(6506007)(33716001)(26005)(86362001)(38100700002)(82960400001)(41300700001)(6666004)(6486002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcvEd6pEeA0dN/P0oM5vzdvh2i1TvV6jXvmYSoxmn0Fq1ntFSsqaZRfOY+oy?=
 =?us-ascii?Q?Ab9u7r4OM+XlH+hn9MrFbvqufvoDKnXjYSI8WT8Au7W4GgZ1zVU3jHgTTTtA?=
 =?us-ascii?Q?pa11bFfLG6NJ11o5YP1LP7mVktzFg8E1u1vL/LHnCx7y/xh60DiMm3rprgQD?=
 =?us-ascii?Q?5647cizWaI9ePf7kwj300m9hU1EJSnTI3EzmrK5uC3kAbqkDdaIGDL+O0ofx?=
 =?us-ascii?Q?2EIblqF95iUydN5iEs9XK0YOeLdbrBpSJ88CojInriL46RGcJTDwrZLjWwsk?=
 =?us-ascii?Q?ZQt0Tl93ioqbHNL76gGvFLbCFWqAfDWecO8JKRJtRYsLPpLlhbmpyN4V9SSR?=
 =?us-ascii?Q?KSiiq/c5STo/gfU3TEEIRALJMTJUL3qfeBvN2Wl/G9tOsj3jMXoOXvgwabFb?=
 =?us-ascii?Q?+DZskl0aAGQJVCztvsdfEhhPKXRc3gxKbvbgPO1TlE/vmlOlOLz/ksMzmI60?=
 =?us-ascii?Q?+xkbEqxyG3X5Ffo3SAKzOdElemQccKb5V6wE4JtDae5Q/DxrChJMj3Raj+mQ?=
 =?us-ascii?Q?GUyrPwxOXO3oZG1XOZPw9bIcQjCuH5ZEGpKTrjHDjg/USj3xYocJ5QXE0nug?=
 =?us-ascii?Q?4442rBTEa09jsFlco8zXvT7Du1uRvozv5O+zfRDLso0nIRdPPjtjNn7s0y3M?=
 =?us-ascii?Q?wTJt7NZjPyOYOwJRftXT/a8O+zElT+k/1YAG+EfsDzg01lpG+gE7goMIaqUl?=
 =?us-ascii?Q?tzDTKYPGMHIOrZAn2p9RYmZHR+dSHL0vqafBYmB+XDt+KYbuH6gt6t/UADag?=
 =?us-ascii?Q?vnXhuwVEkkG01cPyAURyGO53WFhmsUwcO7bftyCz85/PbI8wIyPtcSr4E7AE?=
 =?us-ascii?Q?vVM2Bht2j5I2H7C7tsNwpMJ4wswGgtLtCpxuMvD8Tz9GdOVIvtKbnoV7OqpI?=
 =?us-ascii?Q?JOp7ZZdF57uwNamQWu/6XJ0pL1/XgDSZoHehgXfA0C86QXuJym6lc5ejKnjW?=
 =?us-ascii?Q?ZcB/o74dP9VlynsH/GI7iog4G7psy3LedcQQyeweU0SxtcDGe9epRfPYszY0?=
 =?us-ascii?Q?zvLLcgCqCXrl9P8CTdNCJ4tETOCHegw30Z7JVLr+8ej10t8aYnnl2Wbobcy6?=
 =?us-ascii?Q?M2HNalArCqhCfCtu0yhJ1BNk1l7yzj3scYt8MzuS2J4YXP3Qoy6Oo5ZbAlPd?=
 =?us-ascii?Q?Aq8uwV9/bl5lNmNXvKfpzb2TglfVv2/cXJRVfSVbbtRwNKnFXk4ZcvNk+hRC?=
 =?us-ascii?Q?QjvWIU1o/ZiwMBm4VWUmfXmWBk2EzeRcsSszHJQ+UNJ1+pL+aimyEa0yISBB?=
 =?us-ascii?Q?vORm4vNRashhD3xjjFMGPZ8eZF5M6yny9HawgdVFSbvBZdrYUaIZJ0PYxleq?=
 =?us-ascii?Q?rs6gufXdoZAfRLikcY8c6omGP8w6mdVGnggDS32clo67bVAC/tpmzNj6D2QD?=
 =?us-ascii?Q?doKpLaKX0Zu/VLJINe/XWTELpEOqYdLznDSs4IN0VK8SAgLLuBthsKCruiwv?=
 =?us-ascii?Q?dmERcDlbXcT17OX/r8DLUstctfxZukKLUjPXk4mX5GSBkPtpo3zEj2x4YxMl?=
 =?us-ascii?Q?SSELH9KNMEC1CF7xNAEmFNZAVhm+M7xk7fSeRCn9u3bKum119EEjwFuxkbi7?=
 =?us-ascii?Q?/sTjhVeGjIwKiWf0HypDu7yWUEmZVN9tgsokeh6LsqSYbF/CBt2WhqsEz2TM?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6030ffbc-8d90-4eb5-9cc1-08db5c41a335
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 10:28:38.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yfg5WI/iuhLcDjum6d51T/gvRsubWDKnTuW7uqwzLYjdvQK59b4sMxjwoD+Wh24gHqzpxcAgtAMbJoKvLy3CNkwmKkf3omTcZXurR4TUNrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 11:42:55AM +0200, Simon Horman wrote:
> On Thu, May 18, 2023 at 08:05:29PM +0200, Maciej Fijalkowski wrote:
> > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > 
> > Add multi-buffer support for AF_XDP by extending the XDP multi-buffer
> > support to be reflected in user-space when a packet is redirected to
> > an AF_XDP socket.
> > 
> > In the XDP implementation, the NIC driver builds the xdp_buff from the
> > first frag of the packet and adds any subsequent frags in the skb_shinfo
> > area of the xdp_buff. In AF_XDP core, XDP buffers are allocated from
> > xdp_sock's pool and data is copied from the driver's xdp_buff and frags.
> > 
> > Once an allocated XDP buffer is full and there is still data to be
> > copied, the 'XDP_PKT_CONTD' flag in'options' field of the corresponding
> > xdp ring decriptor is set and passed to the application. When application
> 
> nit: checkpatch.pl --codespell says:
> 
> :291: WARNING: 'decriptor' may be misspelled - perhaps 'descriptor'?
> xdp ring decriptor is set and passed to the application. When application
>          ^^^^^^^^^

Thanks Simon we will run --codespell against the rest of the patches as
well:)

> 
> ...

