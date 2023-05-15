Return-Path: <netdev+bounces-2656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 199E9702DD3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4D5628130B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B313C8EF;
	Mon, 15 May 2023 13:17:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F3C8DB;
	Mon, 15 May 2023 13:17:44 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978B210E7;
	Mon, 15 May 2023 06:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684156662; x=1715692662;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h93cU97TdYg95J1WzHL17BxMS2gNueMK3Y4nmbau6GA=;
  b=N2qO3jLLqsqqp6zoLbM1FwIajGl1uOPewepoc1sM+CeTGvBJI8lUnrYb
   FHNuo9w6DRo+BmTHsxBOur5Dl87OjWw5ql+B5EvmGZMB9E7UlXiNgSSp0
   CRJ/Y+umHfojv9M8IzkgxfCiYN6rsOjr7u4EkuZyOULQGa2ujz8YeLP1V
   iOxca3Gy9u9wzl6BrN94eCKzTze/LGIuWUZZVqy5vB7bGfjULMbQWuDrW
   iDqOMXoGiJqao5K+Umaz7DAAGG0CHX+ZHbU9RWb68RGcDS/7sM0qL/Vp9
   d+fPcaLCSO2EQWwvlhcQHaQ+z4QEOSlpNSIKxomnIX29MHVZy+NpTR0D7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="340548892"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="340548892"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:17:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="875175053"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="875175053"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 15 May 2023 06:17:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:17:41 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:17:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:17:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:17:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqUzmw9JJ7xjzwkOy2EiAKw8Q1SEgaePzdtDteAmnJo+PacXtKddbnVE8JVHa0qpciXHwZ9HNxdy63nNWNwO97wl08V5XHkNV7XCPOXKkjLRgGtNgLldgCRQyjfhbcgJAiyKL/NTYuK1PN3bNTdbkCseoXZgYFg5NjQCeObBwpcNZmAaa0hgQFtyBwWojEHmtIwYw+Pp0bP2aqqPWhuIeMBEpXfG0wEtyUrmrv6nJ5/iBg8zgE/QWMi/gYIHGjfh7jwGWl2xy2FmgUp49U/4oIBJ6+4+zfvm4sJKTRWn/+59SV7M/izgnmPSFdSMlrTVv+rDgD/IUWOV4alj1zgFhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJicu51eHMghXHvl4ww0KgGYrvvI8IMqbxETfympYXA=;
 b=X30/a0w9WVce097ffiyNb8bOMOsdZTOLvlo5ean3Q0nNEVX5RLR9eoREZdPntvrun1DoyfoxSfdO5C1AA95tMoJjQECO/1wloQbiEjAt63aIBhbgadijPTNU8z0fyNdaBD8qbRKWhEu8E6/8cHSUMr82V3GYhsJtTYJjfhNetN0EvMd6ZtG8zoohvqI82etqeIMiTGRee1Cw7rbNYwR2ZZUaGOq6eihcKddXkYXqW6705D8gwswEh5sKq0YePHzJgckOT5+KyxY67o7S506fGcevAebkgwutGVrlL1j6BSSlti9xbMtQcvuULWUqNIgDbw6aL5Vxxdp05tCR5OYiOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA0PR11MB4608.namprd11.prod.outlook.com (2603:10b6:806:94::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 13:17:39 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:17:39 +0000
Date: Mon, 15 May 2023 15:17:33 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<bpf@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<magnus.karlsson@intel.com>
Subject: Re: [PATCH iwl-net] ice: recycle/free all of the fragments from
 multi-buffer packet
Message-ID: <ZGIw7fN3Xz4rmzkA@boxer>
References: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
 <ZF5dQ/RHROwLxJQC@corigine.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF5dQ/RHROwLxJQC@corigine.com>
X-ClientProxiedBy: FR2P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA0PR11MB4608:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f60fb6f-43ea-4197-fb81-08db5546c1f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGCGX/8esHb3DESfcmJ5HT2Emd5EtFtl3AZGyQbV6E7wp2SXHss13slUMmUuvlRmscU3MHPxo+LeA3zZEF4RdDmzAjDZjdtxi8JtRB1zLtN7l2YadI9nuKq1TNJHD5RIh1VwZ6nWn9p59I+D3dsalCt1FXDk6cA/aC7fgZeb4FERxFyP55EVMIL8S204NG3Iw9exhlvamzRikMVxGFE1uhQUF1jv2vd+bx5+LX0VlRs1YB98Yl0M7qo/d2O5LeCWtEkfBhYVz4fQWOi1yE0B4Q27LOvpH0d0HKZuIYfIsW5eWrK1MVUNGtcSGcd+v08G/RdfBPJwSkpvpztH6sLgHGz3gzpBGx39gQlwj7DlUNUvnQ4XrxaohUX5+/awlWxH6AgsttFNV/UFuJMUIxW/rHg+rUL/RrBEjKDcHYW0jgq5yjbMSx6sMeWt+d23XDsg7KCrUddd/ejEysAvfnLnuRqsPD562Cye0keizotiVvjZ84yhhY8phUQLpB4/EuPgajaH9jIcjCAY0Fpi5gCgckHKedBzOjogyP7//mdAXZ2LfyBJ+IJELbEoZQ+9quWF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(66556008)(478600001)(6916009)(4326008)(66476007)(66946007)(6666004)(316002)(6486002)(8936002)(2906002)(33716001)(8676002)(44832011)(41300700001)(5660300002)(26005)(107886003)(82960400001)(86362001)(38100700002)(83380400001)(6512007)(186003)(9686003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jdlL5ykbHe9/ZCmh1pyRE6FszQQSSlf+LmxZcQ452w8VubRVddhn4XOZzrWm?=
 =?us-ascii?Q?XlS7o/icOSo5ZnbCmR0fMIDSb9Oii1whR0aaV7MvRykGPnTPU2zlpUlbmik/?=
 =?us-ascii?Q?xqe0U/nsiGHkppbSmqYAsbim3VCj4qSctjT4jw/8d7r2C++W1Wwn4bM6LXfk?=
 =?us-ascii?Q?Z765dEqRZPLVZiTVLLhM8+9/G8buDxdaHiaFYh5NbkrjMWnBWQ1PV0FAw/Cv?=
 =?us-ascii?Q?QFkz80KIAh2tYomrSAAja9ylCuxFTWGY9RldiQ/xHGk/ArhwCxIPysbNI1Nc?=
 =?us-ascii?Q?pAH/v2e2Yw7LlzOKQeC+X8YQOvqp6INzxFE7CFocL9tGC4pnEcem4jho1Fzz?=
 =?us-ascii?Q?Y5Du56CEOShDlbvjyJzTz5v0Z7LvVmIzotHXoBiIsLlm6F1FyTQ6ooB3ZyU5?=
 =?us-ascii?Q?8UEJVyfZ/hvVJrOckCma+c7+vyVnjBzDAJj0LvoEu+b8362Xq/+Y3hfOi6ll?=
 =?us-ascii?Q?CubySeR9EJ+YSFV+7juRuwicbjtyzV1XSSQaFFbpxNMzClVvPa1X1+KbV0KJ?=
 =?us-ascii?Q?jtB2C+Db48PujG66APirrbwq2BG7A77rOdgng1O4+HDL/n3vE9SU109YhlMn?=
 =?us-ascii?Q?RtVeKaesIh9yaKqroMquTaamKIxCpgcVG0xzwUSWolM+qTN4m96UaOq2Qjea?=
 =?us-ascii?Q?rG7C+ttjiKVGqaTNTaD4oFDgyUq1CYzuQRjx3XQhD+1INNL3rWy0K9S95X1M?=
 =?us-ascii?Q?42bx3AhjXsl5ydY+/Qzo+4cYoiVNDoLxz0vxhCiEru68RmF3hvZQsra4aPGe?=
 =?us-ascii?Q?roLb+O+vnTEdBXLJN/dNNKojE55NZapopGWO90FJzZZPLuuJsBGgslXjLFXJ?=
 =?us-ascii?Q?n7Ye62tFjzl30NNMqe60MBsv6H03/P0XkC0Bp6D/CIF3JuRlb4zIK33YoFjJ?=
 =?us-ascii?Q?X9a8tOA4lhIOCm234/0m4cktNRzVIMJWcpZijCL6FCJsLPidjGgJw7kDLLoy?=
 =?us-ascii?Q?BEevmcj04ITemE4KP+vqdTa9GRdxZKWy0hWw7440VVPDSdGdyordH6//OxCA?=
 =?us-ascii?Q?WNQo7zXGlchB/utDjutksacajfsV9uLG4CA78fpIZDyeTD0PJgcucLs73LIC?=
 =?us-ascii?Q?TJEzfKIlmuD3FGMxSRwnqGPSvo+V8tPmiJNZe7rXO5i/iMCt1fq90lyJu/wA?=
 =?us-ascii?Q?XRHNiU1J90y2/6L6s54W37anAgjdvmw+A+5Rgqt5qSEuR/QbErf4mDpoBnkq?=
 =?us-ascii?Q?cYl0GogH+LDEKQxpSH6Rk9bUDE7lmtGMUlrQX20iPyB4OpIzkGPxuYYLkf2o?=
 =?us-ascii?Q?7KUtcRVyRbwVhl4hGQwgI1WbCE6csffO/uD7YYdJsS0wtUBb3wd7V5eaxQe0?=
 =?us-ascii?Q?m0HYuG4+/pwuBb6SDz7EqDEG/45vlJB13pjugtuy/g/BppJt94JWgPjaN1o6?=
 =?us-ascii?Q?zlBWLe+5uVqEI9nSFsmhZPRoVZ0Rl3Io/nCecAkjZk0vkV5Um50SzaMCqTkX?=
 =?us-ascii?Q?fGLv6nnSYk4y8cAKLyqZ2Dgy7B9/RIyDktc5B5E/VahZBijXULLYWAqWejZ4?=
 =?us-ascii?Q?+NoaxYwKAbVZdk31tQB8u2RZzynwXLhAfcnENtsBXnhIjKzvhgqgVmLjvWfl?=
 =?us-ascii?Q?sM15PV34lu7ZWZcEqUfXTvFKNLTjbpPb9sJ+aaaDslnU1QcBYdx4trzaAyDA?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f60fb6f-43ea-4197-fb81-08db5546c1f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:17:39.5888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2pnv0OUtlmaE8VQ9YlGYqTKLQMli/c+JyGLf7PsW36bo8zyJgTz2X+PDDQolaUpV81q+IiyAyVDgLBfoxQayDBiHE5hBONXDix59/4IWMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 05:37:39PM +0200, Simon Horman wrote:
> On Fri, May 12, 2023 at 03:23:30PM +0200, Maciej Fijalkowski wrote:
> > The ice driver caches next_to_clean value at the beginning of
> > ice_clean_rx_irq() in order to remember the first buffer that has to be
> > freed/recycled after main Rx processing loop. The end is indicated by
> > first descriptor of packet that the Rx processing loop has ended. Note
> > that if mentioned loop ended in the middle of gathering a multi-buffer
> > packet, next_to_clean would be pointing to the descriptor in the middle
> > of the packet BUT freeing/recycling stage will stop at the first
> > descriptor. This means that next iteration of ice_clean_rx_irq() will
> > miss the (first_desc, next_to_clean - 1) entries.
> > 
> >  When running various 9K MTU workloads, such splats were observed,
> > mostly related to rx_buf->page being NULL as behavior described in the
> > paragraph above breaks ICE_RX_DESC_UNUSED() macro which is used when
> > refilling Rx buffers:
> > 
> > [  540.780716] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > [  540.787787] #PF: supervisor read access in kernel mode
> > [  540.793002] #PF: error_code(0x0000) - not-present page
> > [  540.798218] PGD 0 P4D 0
> > [  540.800801] Oops: 0000 [#1] PREEMPT SMP NOPTI
> > [  540.805231] CPU: 18 PID: 3984 Comm: xskxceiver Tainted: G        W          6.3.0-rc7+ #96
> > [  540.813619] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> > [  540.824209] RIP: 0010:ice_clean_rx_irq+0x2b6/0xf00 [ice]
> > [  540.829678] Code: 74 24 10 e9 aa 00 00 00 8b 55 78 41 31 57 10 41 09 c4 4d 85 ff 0f 84 83 00 00 00 49 8b 57 08 41 8b 4f 1c 65 8b 35 1a fa 4b 3f <48> 8b 02 48 c1 e8 3a 39 c6 0f 85 a2 00 00 00 f6 42 08 02 0f 85 98
> > [  540.848717] RSP: 0018:ffffc9000f42fc50 EFLAGS: 00010282
> > [  540.854029] RAX: 0000000000000004 RBX: 0000000000000002 RCX: 000000000000fffe
> > [  540.861272] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
> > [  540.868519] RBP: ffff88984a05ac00 R08: 0000000000000000 R09: dead000000000100
> > [  540.875760] R10: ffff88983fffcd00 R11: 000000000010f2b8 R12: 0000000000000004
> > [  540.883008] R13: 0000000000000003 R14: 0000000000000800 R15: ffff889847a10040
> > [  540.890253] FS:  00007f6ddf7fe640(0000) GS:ffff88afdf800000(0000) knlGS:0000000000000000
> > [  540.898465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  540.904299] CR2: 0000000000000000 CR3: 000000010d3da001 CR4: 00000000007706e0
> > [  540.911542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  540.918789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  540.926032] PKRU: 55555554
> > [  540.928790] Call Trace:
> > [  540.931276]  <TASK>
> > [  540.933418]  ice_napi_poll+0x4ca/0x6d0 [ice]
> > [  540.937804]  ? __pfx_ice_napi_poll+0x10/0x10 [ice]
> > [  540.942716]  napi_busy_loop+0xd7/0x320
> > [  540.946537]  xsk_recvmsg+0x143/0x170
> > [  540.950178]  sock_recvmsg+0x99/0xa0
> > [  540.953729]  __sys_recvfrom+0xa8/0x120
> > [  540.957543]  ? do_futex+0xbd/0x1d0
> > [  540.961008]  ? __x64_sys_futex+0x73/0x1d0
> > [  540.965083]  __x64_sys_recvfrom+0x20/0x30
> > [  540.969155]  do_syscall_64+0x38/0x90
> > [  540.972796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [  540.977934] RIP: 0033:0x7f6de5f27934
> > 
> > To fix this, compare next_to_clean with first_desc at the beginning of
> > ice_clean_rx_irq(). In the case they are not the same, set cached_ntc to
> > first_desc so that at the end, when freeing/recycling buffers,
> > descriptors from first to ntc are not missed.
> > 
> > Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > index 4fcf2d07eb85..4d1fc047767f 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -1162,6 +1162,9 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
> >  	bool failure;
> >  	u32 first;
> >  
> > +	if (ntc != rx_ring->first_desc)
> > +		cached_ntc = rx_ring->first_desc;
> > +
> 
> Above ntc is initialised as rx_ring->next_to_clean.
> And cached_ntc is initialised as ntc, i.e. rx_ring->next_to_clean.
> 
> 	u32 ntc = rx_ring->next_to_clean;
>         ...
>         u32 cached_ntc = ntc;
> 
> So in effect we have:
> 
> 	if (rx_ring->next_to_clean != rx_ring->first_desc)
> 		cached_ntc = rx_ring->first_desc;
> 	else
> 		cached_ntc = rx_ring->next_to_clean;
> 
> I wonder if we can simplify this by simply initialising cached_ntc as:
> 
> 	cached_ntc = rx_ring->first_desc;

Thanks for taking a fresh look over this, indeed this can be simplified as
you pointed out :) being stuck on some problem makes us sometimes unable
to see such obvious things ;)

Will send a v2.


