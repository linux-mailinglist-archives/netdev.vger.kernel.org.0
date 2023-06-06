Return-Path: <netdev+bounces-8463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEA4724318
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C201C20F5E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C29737B8C;
	Tue,  6 Jun 2023 12:52:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5590137B84;
	Tue,  6 Jun 2023 12:52:25 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C4710F4;
	Tue,  6 Jun 2023 05:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686055909; x=1717591909;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Qy8z0XPHcDJNHE1TavM72fNx3cteiF1xIwlPj4aic6I=;
  b=fvkUStk0Fgy2TmFSNLe28artDHlO4WWPSwDWVvoNHguGe4Sh3p69xryk
   5Dnfc6EtOEl5kUzv8B8eJSpISM+YIh5t1VTfsWrCdUUT4F5TEJEt99jWe
   h4y9qp5ZPFNuQEPUW3zDd14hTIKO9z12zahCVZvWNQInrg8z4AxitAcHx
   fwq92uqlur837UnBI8Kj5ft6uNLjScJF0hyCXBGEZaSxDZn7GzkLgCuJt
   oyhgpx+hCirBvhomV7xz9k92/ytJ07ZnsUOfVeR1FfJtK6N2vKrMn+iY2
   O1MXRr1vFW+8aHUJWPU/dehwV6hJPMsTh2fnIMCJsSuy4zGc6AJBiMoPG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341298974"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="341298974"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="955740704"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="955740704"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2023 05:50:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:50:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:50:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 05:50:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 05:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRDFYu+rEt4xax1UdIUEIEbTHK1INp/pGXB+ApzaWeCkOAinLC8r+bSAc22NudEo5l/uAkLx+xWfNedx+CBP62fWdRKcVVYsUPSS2RYgkoelJEIoMTPm6Oc1b8PGPGqLYsurKmKzATQSDYH11+UpBwcARAEg9VD8YkLgZTY4F8nEJiMVncNj4w3iTI10goMwNf6VJRiALfRZW4W3clGcydEEBjVchOU9dqLy1BY6mz1rlZTxbzt93LR1ETPD5IAb5QJrHR9I0xSKF+lZN960VUZ41wU/wFp77E/LRnKfyTIBi8v5yGH7+Z9OylCo+F0+/64CSsj5665rkPguyZ8oaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaNys3HBQWYRDDh/woOPxlR+tZIKJryVmJDoqBZ4BUk=;
 b=JYPxILxd+Fb6UVZtHuLGfW/Fr+crp3ictNqv0AIx5YhEhTl/UZa8rERbxraHbLflpkznLUrDb4DfR9bbWwVK1TwCSZZ285ToxR3H1n9Sv3pT74ET3eR97pziqmi43tWQnxPnRKVZY3L4DoLcr8I71+V7ESuvfV4aMhHgqGcM5FCBf9fQNhFF7Zo8KZBo+cvs6MiEjL0wI+7ATehSGYSq0jiUt3FVyyyo8hwvkPr9hK4cp74PnJYzmYdLrsLZ4MFj7tEmcC4FhXlecOzwppm5JBluzJ9JjEfxu/1mQbPfriEpv8GsqQ+Who3QCliteM5aEQKjEpgljvgehxijTwkleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB6998.namprd11.prod.outlook.com (2603:10b6:510:222::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 12:50:54 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 12:50:53 +0000
Date: Tue, 6 Jun 2023 14:50:41 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
CC: <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
	<bjorn@kernel.org>, <tirthendu.sarkar@intel.com>, <simon.horman@corigine.com>
Subject: Re: [PATCH v3 bpf-next 00/22] xsk: multi-buffer support
Message-ID: <ZH8roRaXpova3Qwy@boxer>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
 <87edmp3ky6.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87edmp3ky6.fsf@toke.dk>
X-ClientProxiedBy: FR3P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: a473b31b-d0c6-49d4-728d-08db668caa00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BeBjecCDZsbO8E2H3vJu92laMZ40dLXPLpEoTgucnqSx8McXl3r43VExaGFfgQF4Fh1gWq+BDI5DfyWZbz0/1ExSc4/gnnq0Wm4SFJtYplGLCkExEpIgrUwlT3qly60r3guzdgGJsc1tNYRnj4u2J/HL132aawpSuI+u8+yRZL4v5ua0NpRRkkRWP5ut/RXsYn8nwtH23v9/neYG+rhKMwFyR3VNhRr6fRndggOD3lrc3CJS/joaUHF4XMvseImAev6/x/W5R1xJnCAL/Uizpc35Igl3cbZ28RrQdRNeAKbhckZ1M88GM/Oyjetd+8U2aw/kJtVqhR2WbYl3Pds99JV9vvZnffggyLHT5Xrac6lhw4KwJxLrosumZ9ECCdPvCvAYZF2vjC3EjfGK1h6EfbMM/SQdnd2C4mfR9qhk7miUTh5YDOHj2eF/dUyy57BEHlm58h22E6o9E+rZ2U7Wvoe9WFjdsNqH75J3cyIp/v6iEhnWwbvg/wFHU+GFKp8gv2slRdWxBBxmQYIj/5B6SfB9Nqn8Q615ASIUl+1lxa11LOzCDku7UmgCiQTtAcY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199021)(44832011)(6506007)(26005)(6512007)(9686003)(83380400001)(86362001)(33716001)(2906002)(186003)(5660300002)(82960400001)(316002)(41300700001)(8676002)(8936002)(38100700002)(6916009)(6666004)(66556008)(66946007)(66476007)(4326008)(66574015)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?MJn/0rPwy0GN82FDOdTHpzU+2q64OI3kRqcVyBLTwUrPrEDDPA7whu2srq?=
 =?iso-8859-1?Q?p87J8ZFkgDYbNkANvb+AUu8gxBI9FM916qUd6xdXC8MpZDMPqmi8F6INIR?=
 =?iso-8859-1?Q?n7sED7V11AsZDylco13fTe7jLkGiLhGbVFF0WkRey59QROaC5g4nM8ky0i?=
 =?iso-8859-1?Q?t9l8DvyAAITVkMpn2dr45JFx82f5rVVrcyuMnqLUV1vJPvwR+S13Jy5fCb?=
 =?iso-8859-1?Q?Re8tyogEUsaFXFHlVHkMcShcw1D19/jhnDOEL5A72SGRt3sW8OQbCGRWpG?=
 =?iso-8859-1?Q?o3BwALkR/+fDHVova+O0MZtw6fs0wSwZ7NBwPlzvuwqKVR1UFJs7SfiyAX?=
 =?iso-8859-1?Q?CyJegAkRO7fbdaIV46owQEj78ZuFfHMmCbAfeBi2+5jId5+lVhc0Oe1zTI?=
 =?iso-8859-1?Q?VdR1ECbdnliKPiV2XmPBJTpJ6PFqpXvGhdpWWXcb8mLnSpx93xF7WbSolD?=
 =?iso-8859-1?Q?zIQx6210NrUOLSgWkEUWe0YtoHuU6U0F4cSD4K9MB4/5QYElgonaKFqGtu?=
 =?iso-8859-1?Q?M5dg1GH9taP6LotuXheLlEoqLfdD6OrWI15WpXnkllfdv14aa3nKmiWTRf?=
 =?iso-8859-1?Q?gAbRYYJRnNxcRVWkcwA/K+ohUI0GP/iZ7c1cG6BkErg+PhX39J6U8p6VMH?=
 =?iso-8859-1?Q?ZCAKOzNMfK9bKszmKdryjmwHvZ8JPPxWFhFEAI8GUHVWGaaMFi86P53SVA?=
 =?iso-8859-1?Q?NnnlWObVE6PTuxgDphuJUi4o2NRcYaHrMBUtWxzivl1Ioin3HuK7xumdYF?=
 =?iso-8859-1?Q?NHJoDqZg2m8W0uOrOe4CC75n+TDeQsMTW7knLWILQ6JqL7TCBw/LL2HQZG?=
 =?iso-8859-1?Q?BtFA/pBzknMgUdoUjUMxUPjojhOO2+woar2R3mxZDZi0sp4U/eIHsiiIWX?=
 =?iso-8859-1?Q?fO4nmXFU2Pky6K6c0SHMvceh8mFmvi9KP6N0ufyx6OLzGGc3lI5zsk5/G9?=
 =?iso-8859-1?Q?dG4gb0kVUVN1ttK6loPIIjw2MePuBp33j5RH2CFvT75ubij0WkN9h+oRAN?=
 =?iso-8859-1?Q?ZxdhY5YG+sVp6n/ELoZwEFjRUaCMfd09FogBRqSZVngiM4fNKOIIxH+GtI?=
 =?iso-8859-1?Q?4ZeuxF+9i+6LyiutZrmonut834xPcIYWMHHlyVZe5uQcUMcROcCDgB3OyR?=
 =?iso-8859-1?Q?zINVR8Bf5xBwUxyiAemZxnYGSpyOSTs6q7r7gd2lPHYU2+k/Kp9cCGHine?=
 =?iso-8859-1?Q?rpy2dHoKTOXtx6jMFUXbQ6km6L0AWcXMAYInK21K9CPFkunR0hZdHPA8sf?=
 =?iso-8859-1?Q?9h447WQhgzQ/m3bgLkOOZxBvpeK3UVI0fiYSdKz4MUeBugqO0kNgZCo2ae?=
 =?iso-8859-1?Q?WjWD+Co0ZXbCaF/T5c7UYJdU/sq3tZIwKcQUtNdgnTFvWOhrZz1vOi1UYW?=
 =?iso-8859-1?Q?dftzaKsTt7opaDTFfGA03qqUBxbucg10KQaVnkmQfsYHPo5hWTRgqMc/r5?=
 =?iso-8859-1?Q?6AxDS/VisDIRgIakTCxGOTxyuv2o9pBY5/wOabYIuqlKv+ZGQLqtlw/Nw+?=
 =?iso-8859-1?Q?kbZR6caQT6S2259UtT7PcNTdpoJDstVvnFvFpTEGYufgTDxxqQn94TKGX7?=
 =?iso-8859-1?Q?y/0NZ3wIXW0eymwhGXifhUkxd4au6Xi1DNWwkyvoYOM/GJdGLmOucXqDn4?=
 =?iso-8859-1?Q?sCsv4XkCbe4UnA4qRl1BP1i8RUfWegLuJhG2JcBitMTbfXMm5CXWDMug?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a473b31b-d0c6-49d4-728d-08db668caa00
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 12:50:53.9111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFezHiqXU82ku99QVb3QuTjI5pYnxltaaPwtaCLZr7VhPt2dDN/YcajvZamUDHLFZGkp9aHZ43UiUcJEYg4nHARtdCuRAZtmAMiDrpobGvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 06:58:25PM +0200, Toke Høiland-Jørgensen wrote:
> Great to see this proceeding! Thought I'd weigh in on this part:

Hey Toke that is very nice to hear and thanks for chiming in:)

> 
> > Unfortunately, we had to introduce a new bind flag (XDP_USE_SG) on the
> > AF_XDP level to enable multi-buffer support. It would be great if you
> > have ideas on how to get rid of it. The reason we need to
> > differentiate between non multi-buffer and multi-buffer is the
> > behaviour when the kernel gets a packet that is larger than the frame
> > size. Without multi-buffer, this packet is dropped and marked in the
> > stats. With multi-buffer on, we want to split it up into multiple
> > frames instead.
> >
> > At the start, we thought that riding on the .frags section name of
> > the XDP program was a good idea. You do not have to introduce yet
> > another flag and all AF_XDP users must load an XDP program anyway
> > to get any traffic up to the socket, so why not just say that the XDP
> > program decides if the AF_XDP socket should get multi-buffer packets
> > or not? The problem is that we can create an AF_XDP socket that is Tx
> > only and that works without having to load an XDP program at
> > all. Another problem is that the XDP program might change during the
> > execution, so we would have to check this for every single packet.
> 
> I agree that it's better to tie the enabling of this to a socket flag
> instead of to the XDP program, for a couple of reasons:
> 
> - The XDP program can, as you say, be changed, but it can also be shared
>   between several sockets in a single XSK, so this really needs to be
>   tied to the socket.

exactly

> 
> - The XDP program is often installed implicitly by libxdp, in which case
>   the program can't really set the flag on the program itself.
> 
> There's a related question of whether the frags flag on the XDP program
> should be a prerequisite for enabling it at the socket? I think probably
> it should, right?

These are two separate events (loading XDP prog vs loading AF_XDP socket)
which are unordered, so you can load mbuf AF_XDP socket in the first place
and then non-mbuf XDP prog and it will still work at some circumstances -
i will quote here commit msg from patch 02:

<quote>
Such capability of the application needs to be independent of the
xdp_prog's frag support capability since there are cases where even a
single xdp_buffer may need to be split into multiple descriptors owing to
a smaller xsk frame size.

For e.g., with NIC rx_buffer size set to 4kB, a 3kB packet will
constitute of a single buffer and so will be sent as such to AF_XDP layer
irrespective of 'xdp.frags' capability of the XDP program. Now if the xsk
frame size is set to 2kB by the AF_XDP application, then the packet will
need to be split into 2 descriptors if AF_XDP application can handle
multi-buffer, else it needs to be dropped.
</quote>

> 
> Also, related to the first point above, how does the driver respond to
> two different sockets being attached to the same device with two
> different values of the flag? (As you can probably tell I didn't look at
> the details of the implementation...)

If we talk about zero-copy multi-buffer enabled driver then it will
combine all of the frags that belong to particular packet onto xdp_buff
which then will be redirected and AF_XDP core will check XDP_USE_SG flag
vs the length of xdp_buff - if len is bigger than a chunk size from XSK
pool (implies mbuf) and there is no XDP_USE_SG flag on socket - packet
will be dropped.

So driver is agnostic to that. AF_XDP core handles case you brought up
respectively.

Also what we actually attach down to driver is XSK pool not XSK socket
itself as you know. XSK pool does not carry any info regarding frags.

> 
> -Toke

