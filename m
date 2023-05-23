Return-Path: <netdev+bounces-4782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AD570E2CF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C179E1C20DA3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF5C21082;
	Tue, 23 May 2023 17:38:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E9206A8;
	Tue, 23 May 2023 17:38:27 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD8618B;
	Tue, 23 May 2023 10:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684863501; x=1716399501;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hHJw7qfZ4KS26hbGB+/7Xob+Ru/eyqwELYTpD+ruXvA=;
  b=KezOxqvUVMW0sOrQJ3SKvJNAuBerzK2cf+qwolDQIC6tMjs2CL1svFNE
   AUaEVJL8YOk8TkyG4b6nAQZSO3k4ugcy99pPNkwxRP23+O0/eweD8M9ud
   F4xXllg+1qcrqqHWAVh7Lr1IdMIGYrOz6y8rTon8tesneUFCKdFBOoKHI
   Dzgsbwie7+WalpF4hdWwa9kb0xCnQF4QowVjiEOgCpjy1R+oBBMjzGqiE
   X5C99/idZ8IHi0oKBTep5SJqVEJqtE+FnMQmY2KNNik1Juijw0G+XYzk4
   PoBxNmvGWqZbx17Q5errnQE5wfc/gdFrLf1xGYLapQQ4eXaXQiR9QYBf1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="353337502"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="353337502"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 10:38:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878299915"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="878299915"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 23 May 2023 10:38:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 10:38:19 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 10:38:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 10:38:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 10:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7phpScE39V4Uu4EC6u1aEjeiO0Nr2fwYrXgcid4nQZ1DL6hM2U3qEq/x1NWvSS6fOkVaHOWsl/fP5c3dHs7fgEe9Pp7OEQaUguBMpNS6oKn/1ZbBd3bVWz/oLKlsJDqi+N/5LhpIKJ2NrDOtPjEskX1xZAyDUru9MW+85f3HHNlG0WI6ALedMrP9e5dVDkLcVBl98DLre1niXzv3eE/+C89DoROoTZOv/yTwbG610XxUpmDgsT1szk7ZkmXXKcGXviGLwOF0+w5TqoC7UXKq+cXuRpdj2j+3k17JL5iGbIbs6rPiGm6BZEB/5jd+LrjTNFV1EWKwbeM9rKtvrD+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYgP6VO6oV2Sb0NALIiRvnV/tiZjRCmiXKt4OQ/dfUE=;
 b=i5PN3M9INpR7qKPyOxSIv3MvYTB3quu26rm057nc1zk+oAJcQa05o0vqJhM9cUst4ZQw2dYsiNx6MOmZXvB1VfCmJHPIgh2htGS1nr9ipkst+/S2mXg+iZ2SgN08Eu9ZGvkUYhnUV2nOEGlONI35vp+BRDqIlZeT3Ft2rVjOLJOjR59Q9eyKmJ2Y4PxH395ouedflEZZL9hlzZUlWW6weCs/xdDRf52E7yyZgM5pFw1AxBkhh0tLaJ5MsSPQukYKYxal6uRdbEE2mix1iSa0vdw1fSdWsgk7LlLKf0fr/r4/zGPQlcNPgj3om0XmTK4zarmNvcItVgxlWngeX0vvuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by IA0PR11MB7305.namprd11.prod.outlook.com (2603:10b6:208:439::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 17:38:15 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 17:38:15 +0000
Date: Tue, 23 May 2023 19:35:17 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
CC: <brouer@redhat.com>, <bpf@vger.kernel.org>, Stanislav Fomichev
	<sdf@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu
	<song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan
	<mtahhan@redhat.com>, <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next 09/15] xdp: Add VLAN tag hint
Message-ID: <ZGz5VWan/nROHxhc@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-10-larysa.zaremba@intel.com>
 <b0694577-e2b3-f6de-cf85-aed99fdf2496@redhat.com>
 <ZGJZU89AK/3mFZXW@lincoln>
 <094f3178-2797-e297-64f8-aa0f7ef16b5f@redhat.com>
 <ZGuO6Hk+NcdL9iwi@lincoln>
 <1693e3e3-c486-80c8-aec0-cca0c9080c34@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1693e3e3-c486-80c8-aec0-cca0c9080c34@redhat.com>
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|IA0PR11MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: cc306d37-779c-4edf-9e18-08db5bb47cab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLYfc+RC3bKEVHE0Bea9hHmbkM425jXlpGUm++SK0mSN7x9wo3W07IB1jv+myrLwWF5wEbPaXkpXDUE3RKyTxscwE0YfcZArfNiVzOoYwiAsYdN/JcY4XjzwO2pTyYowLIu+OS7sdS4WK0BPm58QyQbtEZz7tTkkoRGRUvcallKNyTJpFGAKDuPm59QiZggB9Idi4nBNgPTdYm2vUYJyHilRPKzsOF/DZZ+499lx+ZzIy/ncM4sUWX6zz1iMxHc+F8P6qoEpW6ncqXny2ejAQUpBMxHUw1ZEjo7oBg1tUAK/4aGDoVoeUBz51eh/kEdGvO0ZWJ8Uyuv2aacLokTKcCHsmnF4nHUiNWbGw/pP2gFeD8QAp0ZzGefdE1hW3lenCW0NjPtOBBWC9GZoPEnmpxrWTbmyobiT3WDK6s8Q+qwqDqQk2Umi1H57465k/8+t0e8zXpPtYmgklbLXlqis5+s90hm2BRZ0kBkP7MKu7wHVsknGjOzKwU+gc7NKAka6TWUB771UjxbDyfQhZZ11zu29n/jz4qe923FcXXJsDWI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(54906003)(966005)(6486002)(41300700001)(478600001)(316002)(66556008)(4326008)(6916009)(66476007)(66946007)(8936002)(5660300002)(33716001)(86362001)(66899021)(8676002)(7416002)(44832011)(38100700002)(82960400001)(26005)(6512007)(6506007)(9686003)(83380400001)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmyZx02on3J3+3JOwCEPrKRLURCoil6C5fOmaxTvKSX5YNRkskXri7SVumQI?=
 =?us-ascii?Q?1JxK8JEqjL0jQHiV0zgDZys5UiTnmXFfJLu6ZgBsCeNPZ3u8GeYdGNmSD7B5?=
 =?us-ascii?Q?f2VvxkTDDXuXaVN/Xt3FP3NHn+R/Gh+DWgEStrg8wxCWsBcNbA3+DOE3Xdon?=
 =?us-ascii?Q?vYE/6t5oskrxcMKsG48Bszij7aon6HbVkyPUaRJzeHNDGMEVKW4AB5RsP3Oi?=
 =?us-ascii?Q?vPY3aBj1nBIPVPKsZ6EYW0HKRtKEOwAVteP29fs5l3Av3Yj9KnmlkdPNpcLx?=
 =?us-ascii?Q?Zyrrg9TlT3W8bukZW6idGeZmpP4cMLTtTGEkSJXIaheZKIx7t4ZqJ9AePM1I?=
 =?us-ascii?Q?HFlerVfDy7WBV9S8HAZGDSRXzf4M9JtzD9uD5EF6NXbQ/gUgve6ZloRjlpHM?=
 =?us-ascii?Q?NLvfbOLfkaxcvkTSBusr0WvBPAP9HH/AY0dp6+2WSh5jyzgm/N8KVKp8QB6H?=
 =?us-ascii?Q?lTDYzHLa3kuMVbGuiecKQGdUMBNVMvFAWWDPC8d6xoKEDTZMtPejPjcqD3H4?=
 =?us-ascii?Q?Jg12UtZm7SXNPcGW6kX5Hb22BJ9bnD6eAZHrkGUBMuBviIYA9wf2kFO2QHcw?=
 =?us-ascii?Q?kxtVKE/0KkVnCBTc85bvHKt3ITaf+FqvUaAhxFrDNQf1WaRGqZpMWdRhgJLC?=
 =?us-ascii?Q?P6cPYj+bf1hBkutEojnkegKbjaggQ/fzdawRtE0pqBdV8ucTvRt8omY3C5pq?=
 =?us-ascii?Q?V9/dfjqSzsXv9E9URdh8JQnweLjbL+sk8vndWZOuFSTaAQD4Vpb9BCmFiUBD?=
 =?us-ascii?Q?BbQr5psnhA7MdNb5oSLWp/eKijPFCc8U2Ds4gRUo7H0bFx3fA4VDzwAZiB+W?=
 =?us-ascii?Q?WBr2HJdFaGuU4kBDmyogu7QOQv2OyF2y8TcsRXAw1tCWvmEx1wYR8bR0Sjdj?=
 =?us-ascii?Q?2SfIVW4UYCLOWOWhC4XgyioBEjMENmS/pEts9V1um4jOgqvRbmNTgY2Olnfu?=
 =?us-ascii?Q?wlLDxPONX1ZQoEq66TyJpZwK3o6mrTHh+V0JCJeg7v4xR0hb2MLEb8eozkd+?=
 =?us-ascii?Q?fw4VfLoDYOpGshR/RZriB6LxdTMli7RxLIBSsi0ETMnilXEBWqN9NZvIlIvK?=
 =?us-ascii?Q?JvqyYYFD7tYINFqQVxCEfernvNtZf/ihy2wLXDtSDrD4OQcgZ4qSALeTNzmM?=
 =?us-ascii?Q?eMVFsrjC3koaTiLG8P8WPaI2l7TMgqkqMMjhU29CumT2AAGcUCvh9zeidBJq?=
 =?us-ascii?Q?KFFAgOmi64hj7PTSiHh4Tbe1UKWwZXnVmMbdI54y7Ebjl7yK090xC28UhbV6?=
 =?us-ascii?Q?DfS4iHsJN3XpuXFDY9rFC4FRebMhv1go4KffnvNr4/6t72bH1QT9FE9sK+Rz?=
 =?us-ascii?Q?JlFC5VKwjMN+Y92hBmb06RJBT4b6BYqP9AuE4qYJG+bGKWv5QVOgGdkdzVgV?=
 =?us-ascii?Q?5kqd7V624ymocGWHgmu2A/ajZsKjtDOVNnPUXb7cqqY+TAn/Y39PD84EP51w?=
 =?us-ascii?Q?NdH38OPLJb0J/VWZ073D9QbKAC92j7j0HoqGVPCPNbdNM+SYjIk8InpSr4OY?=
 =?us-ascii?Q?+1TMMOk4qhQyPDraZXVRNB3t4xniHNeA7YpfjKxbBkUDfB5Oxg4vm9FKnDQJ?=
 =?us-ascii?Q?hMSozILED5iFjx13T84kxRewvIkEMkv+kWEnoEO7BMo/3+16BJCStMJlepYD?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc306d37-779c-4edf-9e18-08db5bb47cab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 17:38:14.9697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pq+9rRs7LuVMzkHYoQrKz58GGMTek0G5qwHfS7M5y0ME2R7WC5vvOaHiYlVK8QluGRKScrjONQ76N3EX2quT6Fheyckn1ge6NN4nluMf31U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7305
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 12:16:46PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 22/05/2023 17.48, Larysa Zaremba wrote:
> > On Mon, May 22, 2023 at 10:37:33AM +0200, Jesper Dangaard Brouer wrote:
> > > 
> > > 
> > > On 15/05/2023 18.09, Larysa Zaremba wrote:
> > > > On Mon, May 15, 2023 at 05:36:12PM +0200, Jesper Dangaard Brouer wrote:
> > > > > 
> > > > > 
> > > > > On 12/05/2023 17.26, Larysa Zaremba wrote:
> > > > > > Implement functionality that enables drivers to expose VLAN tag
> > > > > > to XDP code.
> > > > > > 
> > > > > > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > > > > > ---
> > > > > [...]
> > > > > 
> > > > > > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > > > > > index 41e5ca8643ec..eff21501609f 100644
> > > > > > --- a/net/core/xdp.c
> > > > > > +++ b/net/core/xdp.c
> > > > > > @@ -738,6 +738,30 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
> > > > > >     	return -EOPNOTSUPP;
> > > > > >     }
> > > > > 
> > > > > Remember below becomes part of main documentation on HW metadata hints:
> > > > >    - https://kernel.org/doc/html/latest/networking/xdp-rx-metadata.html
> > > > > 
> > > > > Hint compiling locally I use:
> > > > >    make SPHINXDIRS="networking" htmldocs
> > > > > 
> > > > > > +/**
> > > > > > + * bpf_xdp_metadata_rx_ctag - Read XDP packet inner vlan tag.
> > > > > 
> > > > > Is bpf_xdp_metadata_rx_ctag a good function name for the inner vlan tag?
> > > > > Like wise below "stag".
> > > > > 
> > > > > I cannot remember if the C-tag or S-tag is the inner or outer vlan tag.
> > > > > 
> > > > > When reading BPF code that use these function names, then I would have
> > > > > to ask Google for help, or find-and-read this doc.
> > > > > 
> > > > > Can we come-up with a more intuitive name, that e.g. helps when reading
> > > > > the BPF-prog code?
> > > > 
> > > > Well, my reasoning for such naming is that if someone can configure s-tag
> > > > stripping in ethtool with 'rx-vlan-stag-hw-parse', they shouldn't have any
> > > > problem with understanding those function names.
> > > > 
> > > 
> > > Naming is hard.  My perspective is conveying the meaning without having
> > > to be knowledgeable about ethtool VLAN commands.  My perspective is a
> > > casual BPF-programmer that reads "bpf_xdp_metadata_rx_stag()".
> > > Hopefully we can choose a name that says "vlan" somewhere, such that the
> > > person reading this doesn't have to lookup and find the documentation to
> > > deduct this code is related to VLANs.
> > > 
> > > > One possible improvement that comes to mind is maybe (similarly ethtool) calling
> > > > c-tag just 'tag' and letting s-tag stay 'stag'. Because c-tag is this default
> > > > 802.1q tag, which is supported by various hardware, while s-tag is significantly
> > > > less widespread.
> > > > 
> > > > But there are many options, really.
> > > > 
> > > > What are your suggestions?
> > > > 
> > > 
> > > One suggestion is (the symmetrical):
> > >   * bpf_xdp_metadata_rx_vlan_inner_tag
> > >   * bpf_xdp_metadata_rx_vlan_outer_tag
> > > 
> > > As you say above the first "inner" VLAN tag is just the regular 802.1Q
> > > VLAN tag.  The concept of C-tag and S-tag is from 802.1ad that
> > > introduced the concept of double tagging.
> > > 
> > > Thus one could argue for shorter names like:
> > >   * bpf_xdp_metadata_rx_vlan_tag
> > >   * bpf_xdp_metadata_rx_vlan_outer_tag
> > > 
> > 
> > AFAIK, outer tag is a broader term, it's pretty often used for stacked 802.1Q
> > headers. I can't find what exactly is an expected behavior for rxvlan and
> > rx-vlan-stag-hw-parse in ethtool, but iavf documentation states that rxvlan
> > "enables outer or single 802.1Q VLAN stripping" and rx-vlan-stag-hw-parse
> > "enables outer or single 802.1ad VLAN stripping". This is in consistent with how
> > ice hardware behaves. More credible sources would be welcome.
> > 
> 
> It would be good to figure out how other hardware behaves.
> 
> The iavf doc sounds like very similar behavior from both functions, just
> 802.1Q vs 802.1ad.
> Sounds like both will just pop/strip the outer vlan tag.
> I have seen Ethertype 802.1Q being used (in practice) for double tagged
> packets, even-though 802.1ad should have been used to comply with the
> standard.
> 
> > What about:
> >    * bpf_xdp_metadata_rx_vlan_tag
> >    * bpf_xdp_metadata_rx_vlan_qinq_tag
> > 
> 
> This sounds good to me.
> 
> I do wonder if we really need two functions for this?
> Would one function be enough?
> 
> Given the (iavf) description, the functions basically does the same.
> Looking at your ice driver implementation, they could be merged into one
> function, as it is the same location in the descriptor.
>

This design was very debatable in the first place.
I looked at different in-tree driver implementations of NETIF_F_HW_VLAN_STAG_RX
feature once more. Among those I could comprehend, seems like none has c-tag and 
s-tag stored separately. Actually, there are 2 situations:

1. (ex. mlx4) HW always strips outer or single VLAN tag, without distinction 
between 802.1Q and 802.1ad. TPID in such case is deduced from descriptor. 
NETIF_F_HW_VLAN_STAG_RX and NETIF_F_HW_VLAN_CTAG_RX must be enabled together.

2. (ex. ice) HW strips outer or single VLAN tag with a configured TPID. In such 
case descriptor doesn't carry info about TPID, because it's the same for all 
stripped tags. C-tag and s-tag stripping are mutually exclusive.
Example:
 - 802.1Q double VLAN, with s-tag stripping enabled, packet arrives 
   untouched, with c-tag stripping outermost tag gets stripped.
 - 802.1ad+802.1Q, with s-tag stripping enabled, 802.1ad header gets stripped,
   with c-tag stripping, packet arrives untouched.

Obviously, I can be sure only about our hardware.

Long story short, probably re-inventing the wheel wasn't a good idea on my part. 
Now I am much more inclined to just copy the logic from skb, so function would 
look like this:

  bpf_xdp_metadata_rx_vlan_tag(const struct xdp_md *ctx, __u16 *vlan_tag,
			       __u16 *tpid);

Maybe some applications would make use of just:

  bpf_xdp_metadata_rx_vlan_tag(const struct xdp_md *ctx, __u16 *vlan_tag);

Both of the above functions would return information about outermost tag, if was 
stripped. Would have to think about the naming.

Comments are welcome!

> > > 
> > > > > 
> > > > > > + * @ctx: XDP context pointer.
> > > > > > + * @vlan_tag: Return value pointer.
> > > > > > + *
> > > > > 
> > > > > IMHO right here, there should be a description.
> > > > > 
> > > > > E.g. for what a VLAN "tag" means.  I assume a "tag" isn't the VLAN id,
> > > > > but the raw VLAN tag that also contains the prio numbers etc.
> > > > > 
> > > > > It this VLAN tag expected to be in network-byte-order ?
> > > > > IMHO this doc should define what is expected (and driver devel must
> > > > > follow this).
> > > > 
> > > > Will specify that.
> > > > 
> > > > > 
> > > > > > + * Returns 0 on success or ``-errno`` on error.
> > > > > > + */
> > > > > > +__bpf_kfunc int bpf_xdp_metadata_rx_ctag(const struct xdp_md *ctx, u16 *vlan_tag)
> > > > > > +{
> > > > > > +	return -EOPNOTSUPP;
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * bpf_xdp_metadata_rx_stag - Read XDP packet outer vlan tag.
> > > > > > + * @ctx: XDP context pointer.
> > > > > > + * @vlan_tag: Return value pointer.
> > > > > > + *
> > > 
> > > (p.s. Googling I find multiple definitions of what the "S" in S-tag
> > > means. The most reliable or statistically consistent seems to be
> > > "Service tag", or "Service provider tag".)
> > > 
> > > The description for the renamed "bpf_xdp_metadata_rx_vlan_outer_tag"
> > > should IMHO explain that the outer VLAN tag is often refered to as the S-tag
> > > (or Service-tag) in Q-in-Q (802.1ad) terminology.  Perhaps we can even spell
> > > out that some hardware support (and must be configured via ethtool) to
> > > extract this stag.
> > > 
> > > A dump of the tool rx-vlan related commands:
> > > 
> > >    $ ethtool -k i40e2 | grep rx-vlan
> > >    rx-vlan-offload: on
> > >    rx-vlan-filter: on [fixed]
> > >    rx-vlan-stag-hw-parse: off [fixed]
> > >    rx-vlan-stag-filter: off [fixed]
> > > 
> [...]
> 

