Return-Path: <netdev+bounces-1120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4EF06FC41E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E327281254
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939C5DDD8;
	Tue,  9 May 2023 10:41:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8152A7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:41:28 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8C510F5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683628885; x=1715164885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qU1P08/3uAZKxz7H6VaPOOtIAMqQ+wjm+Ib8PKQsp94=;
  b=LCL31Og9v/ede6XncM7Va4A+gdJhl17WRHhKeKILVn1EGtCfyCwMTOEg
   f3A86G/r9A5TOdcMhaP4mqvCIgFDEijSROu3EaMMpTw05lJkLIGOFwHEQ
   rR+zVELAH+0JXDE9SSA+tWFFxUrdwwF27b2phJjjewEEiDqeJp1VxNrHO
   uQb2bHzF7rsQHnfO59EZVkuuswGN9VYRHZOBA9XSqc692Gi/YoyCDtw25
   FpPA4iHsyoJxcs5hamyPH0SfHsfYwLQmSRwKaglKXT7eKvbkNmOd6KTKh
   IDi/3oQozeqjbye5M4Fs5fGdabP7O5L5SLgetz5X/gBDvF5dUXkE8RDOp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="415461088"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="415461088"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 03:41:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="843056406"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="843056406"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2023 03:41:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 03:41:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 03:41:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 03:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZjl4XuAn+sXIYK9ldbGO2bZ+Tklcrn3BTqurFseDt4AYKYa1ii+d88shNmqhlldTwMf4DuJlk4j8eNyzN66Aye7SidDz3GJQsWRB4wV+AfBDwuupefsMR6N5AO7n/pgODGY7NIIUE/GaTpWyCMme7YQaUFCrzhAAJn0j9jdIOGPhaCJTp+MblZTwR3gTGvW/yqKrObKEELEDGfZf2Nk2k40wkaYdnePgOrliKKpDyyS4HxiAhDVkj4AF8rfh8n5hcq/y2N8UYdAjUtUmMvsjCUQG/cwnqLBwOeFtmhFIYSrQ64WhCaMki/WlwUypE7niguPhTcQBlVbJtcViGk++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ricOaO2ws9/kEqKazV9qTGyaTqZ5/T34VfXzQDBBWoU=;
 b=Z05q3XvcGPYJgVhEw4qxsfHXSLGnWBRwNAqkfDXkjYN1HHlaeUQ5SR96tNIe2fr4vEhcj/itQwBOU1LWPw+62XZLJYhA8Z2ngjzR/45+mQhpN6rij35eFkuUAjyOTHfcPHKlEAJGLgw1IQVMzoedBmC+0VCurJHFd3CNCX3VoxjO8B50nULbQN/lQOE9F62I4uJSC4LG39HKU+0kmfrrBGitLyoUXyixhzgZHVBNzg6bxaLZci/c+9VMzoVPIAwejIsg4xn7bZ95EAxLt97DOT9rHyxNuGROYjCKxi8QYxognC5LtrS0yk0lBlpQplqXFM/34SU9p6X5PcTFNJiu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 10:41:22 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 10:41:22 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: Jakub Kicinski <kuba@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RMvuAgABRCkCAAB3xAIAADncAgAAC4oCAAA9GsA==
Date: Tue, 9 May 2023 10:41:22 +0000
Message-ID: <CH3PR11MB7345FF1A7B92C7FA967C2E4BFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190605.11346b2f@kernel.org>
 <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <ZFoHpoFDkoT77afk@corigine.com>
 <CH3PR11MB73458835C7F7E0316A6325FFFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <ZFoWM5YteJL2ZRxL@corigine.com>
In-Reply-To: <ZFoWM5YteJL2ZRxL@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH7PR11MB8035:EE_
x-ms-office365-filtering-correlation-id: 341517fb-c00e-4d0e-e943-08db5079ee3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ejej5lbfZXRqjF/n3xiqmfB4TU3T/O8NO2On5hUtBMfyJGuyvek1l4dWhty/yWuciEPio8igkf35Jahnx3XZUkFIEeneCjepg8VDyodicDLaXIrymfKX+e1z/H0dxB5hpyFZ9ibHoPb/L+s10m1TzonS+SWEKPZmZInvWeLm6C9kdTBbLkwqVT76NpnmY8HDUrsVo/oOB3ckWEgbmaOcUaEtMZQ24+caM3xdxMHTiDS5xLcFG0rZelpSR1AYbWvngrCTZ+PTMIFdBglArSz0+VTRIAugWlD+Vj2bxnUNyD38sSUjTMxCnMckh0UNVnj4LUELWU7ua9MlRkpEZ2riKxiGisdOXU84YKMmvs7dg7aRQl81TGfA9G9oj8Mi7IkTH9XslvJaO8Ccj3YUNhmKOhJ+BpTN5UC0ainSQ9zutoPkSAA1AA7E1bmfIVcP8GsGO8qtNDKoiUV1eQtyKnBuwUaNeccRHCNpqMsKMPePkb+idt07oEuJRvNhTy39nJnZgooEpjQGaPUcA1mHkvwyDOX9loKEuu6hZu09itVN5x33stXIUwHGBE7lejeNIglu+DieYXL8hDA8I0t6jeIsd318TYN9A29my5Ue+6QluD5LFBFCxbOVD1yTBf7h38zB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(83380400001)(9686003)(2906002)(53546011)(186003)(6506007)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(76116006)(316002)(54906003)(6916009)(41300700001)(478600001)(5660300002)(26005)(52536014)(7696005)(8936002)(8676002)(55016003)(38100700002)(38070700005)(82960400001)(122000001)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oO+zR8Dereih4YJwrQX4nCmXmAyLpRB/WIIXn6B9jf8TdVlzDrYhHcFSoXp+?=
 =?us-ascii?Q?gJWUVYtMXDsM8Nd/8K/qUCZhDksWAtp9hmzdCEbdZ/CRIyB6TL3qqriKcaAB?=
 =?us-ascii?Q?AAf1xPgjXdD7GG8EjEYTg0Ths3WTAxWIWvK1Ur3XBVjc5AYTzNlE8Q+ghEvl?=
 =?us-ascii?Q?XHtHEBd8GPQ6eOMaapcq2u5Yl1NFho54NThOEiAwz9+Y0f6VaQRB7pqhD/mw?=
 =?us-ascii?Q?WxTGFmD/ZYkU2lb87beFjjddkha+dW37qYl0EDW/F02x0Kbue80gn4uNl+CZ?=
 =?us-ascii?Q?sZ0Lh+l+mq52SPkFolXSmB6yhe9XfTNbdBjhEQr2CSD608nY6ntQPHfWD4M7?=
 =?us-ascii?Q?7s+JI+cs6l8m5GCwJvuzwW/+D8kVjPY6BqMcPzKJLn+KokSv7Fz+/I5IaaBG?=
 =?us-ascii?Q?BrpN1z4eYJZlnjtlIASiF75EM54NkrzlEO5TBTGTx/ushsD2ghigpkrSy2Lp?=
 =?us-ascii?Q?mpthnckjh7iCNBM2Y7Qis8gYK5+lEZEJEgjfr/uiiQQTGR5qc0rA3p8KwOP6?=
 =?us-ascii?Q?/JZ2YQqDN7Q9NzNc4H/UKCZ9q/ufye7bJ7i7mUSadI8vtCiSrOnDXPILbW54?=
 =?us-ascii?Q?dVDkihTpcrI0WOdSWks6YRY7GhI5aKgVsTOz/EZmBh82L2OaP470HWibsdAl?=
 =?us-ascii?Q?JihcxKHSIdVw9GAqkTyCA65heBnRwohfpHEyFVIpuTVNNASYcv8yO3SCNAYj?=
 =?us-ascii?Q?m3GzjcEMDlf4h6Bp83udzkDQajnoWdRcqTpZ07qnAGHDzm4Lp5yXqJxLFze/?=
 =?us-ascii?Q?GLoU/7zWJEwxZo427qtpOWV4pQzhOKerflNd7RFcMpKW4zLFsOujLMAF3tSe?=
 =?us-ascii?Q?WXHQTLaDdf7FmY87DjHgPMEmBiHdtTC1GAJmhsyfOXU39vAZ96FUKLBJ0PG0?=
 =?us-ascii?Q?W3HbC920b6Lkt+I0AMO5wf8++mFGnkwuiMNZHQc6TY85kyyv+XtcsL/kRJDG?=
 =?us-ascii?Q?YRW17UZXv26ToMcM/JKWKwZVIhBIMFh1s9abH1jMw+sskuH46inDxfTKl7Tf?=
 =?us-ascii?Q?twK4+ajyOOb7wXJhHt6F5Msb8XHjIQhRYHaZSNn1vf4gIgpCCeulMoOVCHzw?=
 =?us-ascii?Q?pQpq9QJFFncLSxe5HNUzKo80rMP7kCsO7JAZ0w3mxqEBqwr7rt1dpWMZSGpE?=
 =?us-ascii?Q?V7gi/yps8WqUPq+Sm5Z1XD8KMviD37461KWbRbUIxFnOiLkVRHXiaxqtGe1p?=
 =?us-ascii?Q?2Gfzcl/N311uBLLKoWb+sBgKx/FVg02IAbpgM2syILVM+8n6AnSPYPI+p5EG?=
 =?us-ascii?Q?6zDaa/qjSiWHQWjtlfF31kndx7LAu/maO2e50sDWSKx+vbupDmYSLta05vHS?=
 =?us-ascii?Q?u0ya4OaNWJAqyf3gxJb0IX30PQorYs9bE2TtV13dVvaLyqveQLq3gLyRHrnl?=
 =?us-ascii?Q?k6KbBbYappPt7EVWFL9MF5VmqTvs/ySs5uEhQ0PTn9xqfy9EqOA/iTrz/uhC?=
 =?us-ascii?Q?D4SgSw4whpcMN668DCy2dniPL+VaiKEkH/HMIPDlP6vgTHHoubY+aCFvTgJY?=
 =?us-ascii?Q?1LKpVsYCe8KG72zjWCCvQDyOQpLDaoFA0BQZ1ipYXYNq9OlbMEXSg6yDO3sj?=
 =?us-ascii?Q?XzoLLCYb8G01kkDbqn6qLolZKA5Qv4UaPzv5OueC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341517fb-c00e-4d0e-e943-08db5079ee3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 10:41:22.0969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UgRadpHCGtPUQ1uPjbVcYlZ3kVTHj74SBpfO/mODz1DLS5lePOptWfTNtWIxAqs/XEJVv14ulT/8hlhfr7IOUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Tuesday, May 9, 2023 5:45 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; edumazet@google.com;
> davem@davemloft.net; pabeni@redhat.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Tue, May 09, 2023 at 09:36:59AM +0000, Zhang, Cathy wrote:
> >
> >
> > > -----Original Message-----
> > > From: Simon Horman <simon.horman@corigine.com>
> > > Sent: Tuesday, May 9, 2023 4:43 PM
> > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>; edumazet@google.com;
> > > davem@davemloft.net; pabeni@redhat.com; Brandeburg, Jesse
> > > <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > a proper size
> > >
> > > On Tue, May 09, 2023 at 06:57:44AM +0000, Zhang, Cathy wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > > Sent: Tuesday, May 9, 2023 10:06 AM
> > > > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > > > Cc: edumazet@google.com; davem@davemloft.net;
> pabeni@redhat.com;
> > > > > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > > > netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc
> > > > > as a proper size
> > > > >
> > > > > On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > > > > > Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small
> > > > > > as
> > > > > > possible")
> > > > > >
> > > > >
> > > > > Ah, and for your future patches - no empty lines between
> > > > > trailers / tags, please.
> > > >
> > > > Sorry, I do not quite get your point here. Do you mean there
> > > > should be no
> > > blanks between 'Fixes' line and 'Signed-off-by' line?
> > >
> > > I'm not Jakub.
> >
> > My apologies :-)
>=20
> Sorry, what I meant here is: I think I know the answer. I could be wrong,
> because I am a different person. But I'll try and answer anyway.

Oh, I see. Thanks Simon for providing advice :-)

>=20
> > > But, yes, I'm pretty sure that is what he means here.
> >
> > Sure, I will pay attention to. For checkpatch.pl does not report
> > error, I submit as it.
>=20
> Yes, perhaps checkpatch.pl could be enhanced in this regard.

