Return-Path: <netdev+bounces-9603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E2B72A00D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 446D128197F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93095200AB;
	Fri,  9 Jun 2023 16:20:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C719509
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:20:52 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DDB3C23
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686327640; x=1717863640;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RrJMWjrtAX68/11HdLy6z0JZ4GPD1XK7MGsA9wynBdQ=;
  b=UxckEw6Q72N3ufFPHf/l80DzPqq3UPqHCCspchNcQJs90a1j2ZUVF6Fc
   RX4Lk0jrJlHqvHicpbK/PdmP40609LG8ElhLKdQ5M2Dwm19Ak9BFORfub
   Foi8JMicY1U4unAy2/OAvnOCUMZ9P3AcFYWMTmHK7h5ilKx12njDvSSee
   MyGAAsDSCvfwOikZ3hXbKRZUCfzuB7LtP70S6ZvwzjDpOW8J1o9jYXZft
   AMb1te7QuAQ23oZVpjBCqkM3o7nsBGBlqeVL6lKKp2iy+4rrRYqtKqRYN
   Dn6gjvG+tFLcvBviRZjfru2YheHNMu52FR42FtzwhZctC3cLuixiNLwt+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356525255"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="356525255"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:20:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="743540693"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="743540693"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2023 09:20:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:20:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:20:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 09:20:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 09:20:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kh/t+rnASqFzSAydDqvQ4Y6iTpdq1Z3GcQJq1Qux6NXI82Ti07Lu2JfZPpY89hIhZF46VHKV6R8OMm+SMVT1UfBhG1kXz0kr3yWcp3QOKwrV3KTNtOKMZk52nwF/Qh2y8RbhcDKsEfw8IlXsVmLxcNLUUm2PTe3yzOBAmbqLd+l2mTLD79KlCQ0bnQFUSgg2Bkq4p6ZhcHtmOcaqo592JGAhTwnRjW2XfvNGmmqVFvBSFM2kgT1+YXXonfK1xmmYkKrEGroAHlRZ8rnDyIcOGiqZ79AQC1ZdzSiQhJZJ76RK9op9Uv4Fe3vQZhm+c9A00uWcBV0uUOImnaw1DfK/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcn0PLfci+AS0D3fLwDG9Piwb9/SSpw4as70nQ7mcxg=;
 b=GKFTKAmUSL8XBYCAOzNj9a1hAfDhoikVB0vJ8Rqcx6eKiNgnNBiJZR8rrJnios4x1nUiIeOExnVqkx1MQAFnj9DKi1lqqSA3NT2eqmDPrKk0TbiJajoDocMpcFSEiI1AkYNdXMVW47zF6JbBtIVRWTiNSmAstIspYz0uDil/rxWnE6MCKqpX68cxWgXKk1XZOITkTJeffamqfWuF0RNpBe+QcIzJINmmuY6rFRZZSKWDIZ2ML9OZy6CizeaUrDRR/ciiCeD8G66qNCc966Y69UZVvDSuMfQmDbbnv857xjM9C8mkrPO1ajHS66fCP+zZyPy/UWg15Y25M4/5l1D8aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN6PR11MB8244.namprd11.prod.outlook.com (2603:10b6:208:470::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Fri, 9 Jun
 2023 16:20:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Fri, 9 Jun 2023
 16:20:38 +0000
Date: Fri, 9 Jun 2023 18:20:29 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Muhammad Husaini Zulkifli
	<muhammad.husaini.zulkifli@intel.com>, <sasha.neftin@intel.com>, Naama Meir
	<naamax.meir@linux.intel.com>
Subject: Re: [PATCH net v2 1/3] igc: Clean the TX buffer and TX descriptor
 ring
Message-ID: <ZINRTWdWvRJgdTvt@boxer>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
 <20230609161058.3485225-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609161058.3485225-2-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: LO4P123CA0594.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::23) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN6PR11MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: f982dd3c-9200-428e-00ba-08db69057645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivCfPKaOunjN44zAuRubVpzgAPOFe9D7MuRV/1AM55/k2FT/zSlMn9dDVszb8qiRzk0iOMC+jYziqvgZ9zB1wZlkt2ttPlWwiq/hCEyUhKUq6FL6kLxx2cwlD9y/TK/Di366ztB7u6ElBGJyRVGtEygQu9CGVXhZdH+mHgY2SqNulUS8UGg4eH6ODLPTrpk7vQW9AXybBilNH3Y2l5GMEkfQzRw5OMXtDMGyq0GdA7g7XciREaE0lhqtl0OTIe/pMBLY2JZap7+3sf/qM31kYI22UPVhWimNitU6XIf2x7dlPHMkx/EZhgWuNRzAXrQElo6FTHuQloTyoTXeTvUdgA94pKqNHB+Ms6zjRpVTHRmDArNIe8s16b6PS8NYnP3BIYvbMJpQvqY1rlNmt3HvbQ2yter/D2PIdImEJSylTI28KqWuIZXXAIRfG7n1CwYKc6muNlm5nvZZoNrBkathKEuhbuStPx9s6ubNOwssoNfCRPEf0XtjEA02aQwcqKwdyDWf2Ul83iikSLaFqGMjmufXlNJzb6biFYB2yGotpMNkid25xjG/DUFTgYDKEuxV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199021)(33716001)(26005)(6506007)(41300700001)(5660300002)(186003)(6512007)(9686003)(8676002)(8936002)(478600001)(54906003)(66476007)(4326008)(66946007)(83380400001)(6862004)(66556008)(6666004)(6636002)(6486002)(82960400001)(38100700002)(2906002)(316002)(86362001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GUnQ7tQo6P3Oc9jRiusZwsVhi2NUMyNZHTaPyY8XqL08OyeQZOBZWJDXy4hd?=
 =?us-ascii?Q?u7DAOzBG6UMzIBy3qbPGmZhZZpLUUns0Bk6a/g5IFx1nV7tnJ/oRa/iSu8rk?=
 =?us-ascii?Q?eSxRc7czEmjK1QKUl8s5U6RVfbsaE5gkPnsngRg7gw1WaZuZIPANEMrZgcmF?=
 =?us-ascii?Q?8prNj+3YOeZn6Sxjs2/U2Us1lE8c6EM1oE96652Tw3mpfXWJvXYoC/jVF2p1?=
 =?us-ascii?Q?aXvHdyFnFiUntm7tEpLSKqk/K3g+1qZ45bp2rfEsPQeyh5hymuWqELvi1rV3?=
 =?us-ascii?Q?yv/Gv+sknAX91nwcStAPhjOORLRIPyEOiUry5S5L4oQcywU3vKQNhhlAe+5T?=
 =?us-ascii?Q?jaI6KIlpydOekfOB69UvfJIU9mj/Q7NsrWw/6FljSVwJ1pqLP6vi5UkCSFTK?=
 =?us-ascii?Q?ceYqNLe2W088W7DxrUo+7+El/YDjOKx2rB63GY90Z5t0AszSYN+qVGOp/RkR?=
 =?us-ascii?Q?rrbN7oM1uy09Uu67GH3jDCnpemj91GhtHcy+gBB4EmZXEbj09bak4lOvV8PU?=
 =?us-ascii?Q?40RBdNznuJSxA66bUyKdpTtI6tPdDm4hEcIeBvCuAY00FJyTb/Mp3e3uOuMp?=
 =?us-ascii?Q?WQYcEEwzEknAy6smUZO9ooeONoWuC/+/x81TyIb7IPDvVDAjbWJXkZLWAe/X?=
 =?us-ascii?Q?8jipE96nLBCkmm+riT80TjwodCEvrp7XMKFBpthy5sAy2MnPcqJ4pgCeDL8e?=
 =?us-ascii?Q?uIBGa6qURjw4PseEgYkJRmsLr7L0AcOM2SDfS4OxgdQzLvEM4vDtc8o+UYJ7?=
 =?us-ascii?Q?JJmNCEMfceWNppY/GsiG8n41z/OttrDvjRN3Z6ZQE8P1Q+9F/kpRXnI/O9VH?=
 =?us-ascii?Q?nsPk/oGHpbyM2HHQFlctoeLZpU/VdWRkx9CWHuhm1fJ3pE92i1Cx0VPW/qms?=
 =?us-ascii?Q?sLM6kdwV5dU82olBBlPFROI5TvGfcKrva1J9HcE/I+kjdhy8msN6ql9LZu6K?=
 =?us-ascii?Q?LGPVoN3vXNl5Lh7OThefr1oxM++OMS0gSHznD84Pk4S95diIOO6bz4h9T2iY?=
 =?us-ascii?Q?jQdJ7z9BTdC09zh0l2PfhMIcZL24HTHp7k5O9OvTsRvKCSr49WHceasQUJ+p?=
 =?us-ascii?Q?82sL8AvELAkr4ymjpiAwVyeyNYbDU/LY2A5GiEDpSR1UB9Bie2j79/8BzBII?=
 =?us-ascii?Q?+Kf1+d6JO94vPN5CLGXosgFWOnbM7xAxF8I4bCDa8lSE/ier6cmXAqOzNmmK?=
 =?us-ascii?Q?EhrFmiPdZ2xaQSAooCj40KG6Jy42N4SE2a95DKNXT3wZlnANZQR0oSEpE53A?=
 =?us-ascii?Q?r6GOp1iUw9c93YNGrolpA9iVeOOqV53O7f58jR4WL3FlppV53Z/0rmQg26Z4?=
 =?us-ascii?Q?AfvB8+K0bGO+wZ5Ls3+glnsmpfvob8+QDfQvdEvNho5dYAeLMuJRnG3Uvz+m?=
 =?us-ascii?Q?wxzB5kvMwHTn5sH5RmUnLL0RSWUcExKEMVxQbZPwJ2a8Bkw46EpP3IltXhWX?=
 =?us-ascii?Q?epZrydIVg3KJ7nk4j15x/5stOpAbqK6xJUANVA6/VsaDoWyfkqaMkCirwShk?=
 =?us-ascii?Q?FstNQ9g8jWzVBgrjhaXRBXWo4UH82vGeafXYhAuK1UmATqQvZvgE64ZYLGvt?=
 =?us-ascii?Q?d6U7jPVW5htIVkH/E5nRcwyYrc9S7JhIOOekOu4WohgxazOVbR6jRPwEQKaE?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f982dd3c-9200-428e-00ba-08db69057645
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 16:20:38.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2taUPuU6oiw1Zt4zxjKOpBZ5/7UMdE/N3wNNAR1tiHbVGUXycXpCs+sPQFPkEhPLeC+N0bUpJgWpW4Igk5FTcIOFms4gHbbyixXPgWBKhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 09:10:56AM -0700, Tony Nguyen wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> There could be a race condition during link down where interrupt
> being generated and igc_clean_tx_irq() been called to perform the
> TX completion. Properly clear the TX buffer/descriptor ring and
> disable the TX Queue ring in igc_free_tx_resources() to avoid that.
> 
> Kernel trace:
> [  108.237177] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.4204.A00.2105270302 05/27/2021
> [  108.237178] RIP: 0010:refcount_warn_saturate+0x55/0x110
> [  108.242143] RSP: 0018:ffff9e7980003db0 EFLAGS: 00010286
> [  108.245555] Code: 84 bc 00 00 00 c3 cc cc cc cc 85 f6 74 46 80 3d 20 8c 4d 01 00 75 ee 48 c7 c7 88 f4 03 ab c6 05 10 8c 4d 01 01 e8 0b 10 96 ff <0f> 0b c3 cc cc cc cc 80 3d fc 8b 4d 01 00 75 cb 48 c7 c7 b0 f4 03
> [  108.250434]
> [  108.250434] RSP: 0018:ffff9e798125f910 EFLAGS: 00010286
> [  108.254358] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  108.259325]
> [  108.259325] RAX: 0000000000000000 RBX: ffff8ddb935b8000 RCX: 0000000000000027
> [  108.261868] RDX: ffff8de250a28800 RSI: ffff8de250a1c580 RDI: ffff8de250a1c580
> [  108.265538] RDX: 0000000000000027 RSI: 0000000000000002 RDI: ffff8de250a9c588
> [  108.265539] RBP: ffff8ddb935b8000 R08: ffffffffab2655a0 R09: ffff9e798125f898
> [  108.267914] RBP: ffff8ddb8a5b8d80 R08: 0000005648eba354 R09: 0000000000000000
> [  108.270196] R10: 0000000000000001 R11: 000000002d2d2d2d R12: ffff9e798125f948
> [  108.270197] R13: ffff9e798125fa1c R14: ffff8ddb8a5b8d80 R15: 7fffffffffffffff
> [  108.273001] R10: 000000002d2d2d2d R11: 000000002d2d2d2d R12: ffff8ddb8a5b8ed4
> [  108.276410] FS:  00007f605851b740(0000) GS:ffff8de250a80000(0000) knlGS:0000000000000000
> [  108.280597] R13: 00000000000002ac R14: 00000000ffffff99 R15: ffff8ddb92561b80
> [  108.282966] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  108.282967] CR2: 00007f053c039248 CR3: 0000000185850003 CR4: 0000000000f70ee0
> [  108.286206] FS:  0000000000000000(0000) GS:ffff8de250a00000(0000) knlGS:0000000000000000
> [  108.289701] PKRU: 55555554
> [  108.289702] Call Trace:
> [  108.289704]  <TASK>
> [  108.293977] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  108.297562]  sock_alloc_send_pskb+0x20c/0x240
> [  108.301494] CR2: 00007f053c03a168 CR3: 0000000184394002 CR4: 0000000000f70ef0
> [  108.301495] PKRU: 55555554
> [  108.306464]  __ip_append_data.isra.0+0x96f/0x1040
> [  108.309441] Call Trace:
> [  108.309443]  ? __pfx_ip_generic_getfrag+0x10/0x10
> [  108.314927]  <IRQ>
> [  108.314928]  sock_wfree+0x1c7/0x1d0
> [  108.318078]  ? __pfx_ip_generic_getfrag+0x10/0x10
> [  108.320276]  skb_release_head_state+0x32/0x90
> [  108.324812]  ip_make_skb+0xf6/0x130
> [  108.327188]  skb_release_all+0x16/0x40
> [  108.330775]  ? udp_sendmsg+0x9f3/0xcb0
> [  108.332626]  napi_consume_skb+0x48/0xf0
> [  108.334134]  ? xfrm_lookup_route+0x23/0xb0
> [  108.344285]  igc_poll+0x787/0x1620 [igc]
> [  108.346659]  udp_sendmsg+0x9f3/0xcb0
> [  108.360010]  ? ttwu_do_activate+0x40/0x220
> [  108.365237]  ? __pfx_ip_generic_getfrag+0x10/0x10
> [  108.366744]  ? try_to_wake_up+0x289/0x5e0
> [  108.376987]  ? sock_sendmsg+0x81/0x90
> [  108.395698]  ? __pfx_process_timeout+0x10/0x10
> [  108.395701]  sock_sendmsg+0x81/0x90
> [  108.409052]  __napi_poll+0x29/0x1c0
> [  108.414279]  ____sys_sendmsg+0x284/0x310
> [  108.419507]  net_rx_action+0x257/0x2d0
> [  108.438216]  ___sys_sendmsg+0x7c/0xc0
> [  108.439723]  __do_softirq+0xc1/0x2a8
> [  108.444950]  ? finish_task_switch+0xb4/0x2f0
> [  108.452077]  irq_exit_rcu+0xa9/0xd0
> [  108.453584]  ? __schedule+0x372/0xd00
> [  108.460713]  common_interrupt+0x84/0xa0
> [  108.467840]  ? clockevents_program_event+0x95/0x100
> [  108.474968]  </IRQ>
> [  108.482096]  ? do_nanosleep+0x88/0x130
> [  108.489224]  <TASK>
> [  108.489225]  asm_common_interrupt+0x26/0x40
> [  108.496353]  ? __rseq_handle_notify_resume+0xa9/0x4f0
> [  108.503478] RIP: 0010:cpu_idle_poll+0x2c/0x100
> [  108.510607]  __sys_sendmsg+0x5d/0xb0
> [  108.518687] Code: 05 e1 d9 c8 00 65 8b 15 de 64 85 55 85 c0 7f 57 e8 b9 ef ff ff fb 65 48 8b 1c 25 00 cc 02 00 48 8b 03 a8 08 74 0b eb 1c f3 90 <48> 8b 03 a8 08 75 13 8b 05 77 63 cd 00 85 c0 75 ed e8 ce ec ff ff
> [  108.525817]  do_syscall_64+0x44/0xa0
> [  108.531563] RSP: 0018:ffffffffab203e70 EFLAGS: 00000202
> [  108.538693]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  108.546775]
> [  108.546777] RIP: 0033:0x7f605862b7f7
> [  108.549495] RAX: 0000000000000001 RBX: ffffffffab20c940 RCX: 000000000000003b
> [  108.551955] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [  108.554068] RDX: 4000000000000000 RSI: 000000002da97f6a RDI: 00000000002b8ff4
> [  108.559816] RSP: 002b:00007ffc99264058 EFLAGS: 00000246
> [  108.564178] RBP: 0000000000000000 R08: 00000000002b8ff4 R09: ffff8ddb01554c80
> [  108.571302]  ORIG_RAX: 000000000000002e
> [  108.571303] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f605862b7f7
> [  108.574023] R10: 000000000000015b R11: 000000000000000f R12: ffffffffab20c940
> [  108.574024] R13: 0000000000000000 R14: ffff8de26fbeef40 R15: ffffffffab20c940
> [  108.578727] RDX: 0000000000000000 RSI: 00007ffc992640a0 RDI: 0000000000000003
> [  108.578728] RBP: 00007ffc99264110 R08: 0000000000000000 R09: 175f48ad1c3a9c00
> [  108.581187]  do_idle+0x62/0x230
> [  108.585890] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc992642d8
> [  108.585891] R13: 00005577814ab2ba R14: 00005577814addf0 R15: 00007f605876d000
> [  108.587920]  cpu_startup_entry+0x1d/0x20
> [  108.591422]  </TASK>
> [  108.596127]  rest_init+0xc5/0xd0
> [  108.600490] ---[ end trace 0000000000000000 ]---
> 
> Test Setup:
> 
> DUT:
> - Change mac address on DUT Side. Ensure NIC not having same MAC Address
> - Running udp_tai on DUT side. Let udp_tai running throughout the test
> 
> Example:
> ./udp_tai -i enp170s0 -P 100000 -p 90 -c 1 -t 0 -u 30004
> 
> Host:
> - Perform link up/down every 5 second.
> 
> Result:
> Kernel panic will happen on DUT Side.
> 
> Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Hmm i thought i was giving my rev-by tag...anyways:

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 1c4676882082..f986e88be5c1 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -254,6 +254,13 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
>  	/* reset BQL for queue */
>  	netdev_tx_reset_queue(txring_txq(tx_ring));
>  
> +	/* Zero out the buffer ring */
> +	memset(tx_ring->tx_buffer_info, 0,
> +	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
> +
> +	/* Zero out the descriptor ring */
> +	memset(tx_ring->desc, 0, tx_ring->size);
> +
>  	/* reset next_to_use and next_to_clean */
>  	tx_ring->next_to_use = 0;
>  	tx_ring->next_to_clean = 0;
> @@ -267,7 +274,7 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
>   */
>  void igc_free_tx_resources(struct igc_ring *tx_ring)
>  {
> -	igc_clean_tx_ring(tx_ring);
> +	igc_disable_tx_ring(tx_ring);
>  
>  	vfree(tx_ring->tx_buffer_info);
>  	tx_ring->tx_buffer_info = NULL;
> -- 
> 2.38.1
> 

