Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67F864A97A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLLVX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLLVX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:23:58 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEA41741A;
        Mon, 12 Dec 2022 13:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670880237; x=1702416237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EAjr6nnAKHGzGgldksbTE1UKFiGzqAQT5I+MSv66hkU=;
  b=ZwZLf2Evgeka+c6EC2ORV5d7hgnwtjHsvOUdrjKY/5t8fjFe/cYvYYsA
   gksE6Q4KeW0ihBuU7exjEZ01utZiZDwexIc7uZ/dwOkRBUIPA8MhgiVCa
   WwH47cH+zd53EUfMoSMhbM6XuytFaFp0SEKUIltHURErm+BC1dKkvaRBg
   RebZ2stL1g2WGm+GTwmNOHxTMlqCOZB9UZjjDxVNrQXUcbqMa5ga6BtRm
   LCL3rw1FXvTLRQYJXa1/c7N3ZkTN4GXdGppBsAGyUP6jilcDSj+HdddtK
   q5BIk8tf+yCEuWIZO2Nhd+KvIkIdLbVW0DUPqz4bZ2twIlJpY+t4gdzDK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305610705"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="305610705"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 13:23:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="716954991"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="716954991"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 12 Dec 2022 13:23:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 13:23:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 13:23:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 13:23:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ex/dVaSg3zC780DDl5tkQrjv1HP++zj7m7jViiHplCBbAunYwyzKKZ+Wf6dng2Epf5y4W0B0gwx3p2xtzhcYnm1Scypvke6ewRyN8E6OjU51STpHmj06Z7q66agM1mjGckiP5PtS/X8N/JWsFHx9rB923IVhJLNW6v1tiOYxuSrJdDa19LKt2ddLdzgG+hN7vLKjqTsZHUx3YueKqG2fmhFzth0ZI/KtcVo8xZIOfXudZ8z9rzxQ4uc8itVxqqdiv7ZsDQLc+I6m5WYpDt+UFtDUooKQBbsNKKfL6Tm5HJFmUj2NbnFX76C/qnSwBfpQqqYMdMCH8yNe2bItsr9+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grMBHlYzQM+mHh94zH9WzJPo5UClDFHuw5JlABCM5l0=;
 b=NPhE0M+p5GBmL/Vt4/7Icwb9bFwVS/8RYsAapNEj+yFsyy7ee940wNLLp3+GJXRHbGEQR9bavpJG3e7yUSbWUK8bk+HUhZZ+z+kq/fZ5Nev7b4o6eZXkAqZAREYZ9Ye77av41v87GWrifUOwql1BdKL0gt2QosyAAOMTSIGhYDwyAe9vIqP3pNnv5LuSdnyAOGgLsWcKqRsGf6iOUatF9AapFpVR/KCJ9wSbpxRMwLOeZ0zyLi3m3U2u7sqvSI3vdAeCed5zo5Xqo/Kn+Oux6kJa22e+ArsWbkoTo42YIAcQpImQRf/REePl5V3RY78wmdh3Acv0R0aWQ4MqiMus5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH0PR11MB5411.namprd11.prod.outlook.com (2603:10b6:610:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 21:23:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 21:23:52 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] genetlink: Fix an error handling path in
 ctrl_dumppolicy_start()
Thread-Topic: [PATCH net] genetlink: Fix an error handling path in
 ctrl_dumppolicy_start()
Thread-Index: AQHZDm0xVyKKaih8LUWrRtPKDet/nq5qv3UAgAAC9zA=
Date:   Mon, 12 Dec 2022 21:23:52 +0000
Message-ID: <CO1PR11MB508966F5AC74C7C328122E11D6E29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <7186dae6d951495f6918c45f8250e6407d71e88f.1670878949.git.christophe.jaillet@wanadoo.fr>
 <20221212131026.120bdd71@kernel.org>
In-Reply-To: <20221212131026.120bdd71@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CH0PR11MB5411:EE_
x-ms-office365-filtering-correlation-id: a659df81-5d48-437b-39ab-08dadc872ad7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hl4f95a7laz+LqxC3YcBDYm8dmp1d3qdl6brm0PfE0u9sThW9DIR9zt5ZISlkf1Wr/Iv41BrXuuPJqqKB+CI43DVl2Y3umGmQDltlzf46Jd9ZUWO68nytLLVner/hMAAyhbmDg585wJPqAnhOv3GQiijr5oRHKnD4g/vdzCD3Rcp9nC56CHXwKnRSf1n6jf3tD44kcxD8YNxDa0YYhfrmaK++bVRB8BJiWPrQ9w+RXhvhcIlMol6k4j2ysBL1qfdvXIw2vSuzro+tIz8u29wL0QZpccNbsUI0Do49CmO0KHGaRVSO5j2rWZdU/ZbT0Gam10puczejp75qux9yyyvALJ+/2XVrUFoH4Xey9MJX94ORxdyF6Oj01Yk3cqjy4NOhNAPr611tbuwTc7j4vciC8kAMmxSGHNGPWAm0AmeXMwVLuWdXf2EC/hpdPlBkwWjUZKtHfH2R1PQ92D0sZxbzAkOrk73G8uKi8pErB/lsZ8cZkG0FD7mwxCcZC31uMHzRT0MrkGfo8CpM5v9LPsxwT+vplR0GWd1Tk1RhMkN1xAugjrbnj9vl5xMwu7D88OxTq0tC0hyk3+igTpKRX163lnlovGWVIVT5H1ztgP0ASeQ3mFHAUOv46ziNsPP02oKQESVtuiXE7KUD1BE/moJefUagFfruzoopexIv+sdPDL8mY2bPBrtItittQ4XwOssil9za2I08+smu1hHne4L+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(54906003)(316002)(110136005)(66446008)(52536014)(8936002)(4326008)(8676002)(66476007)(76116006)(26005)(64756008)(66946007)(41300700001)(38070700005)(5660300002)(9686003)(6506007)(86362001)(53546011)(66556008)(7696005)(83380400001)(186003)(33656002)(71200400001)(478600001)(2906002)(122000001)(38100700002)(55016003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GoNWqP9FDVkBVbG6cXiI9p1sXGkiv4Q/m8LxNVD2+NuWROHM7G7L7F3N7VOq?=
 =?us-ascii?Q?9QAgFnorOYtRL7o7KCSqI8xrs3tp2ioA2LVAnR4n+HXSvj6SC3duufb2gWKB?=
 =?us-ascii?Q?C/gvJiH84GRGn0SZsPu4y5wX5c91XYTAz/2/0Ttj2phaEPe9+K2K5qIIJKdc?=
 =?us-ascii?Q?N8XZ7fTAZlhlcweFlAyzNe9JoV52na8Ih5QH7Kpq543y3/DVncjPP1gv9KGT?=
 =?us-ascii?Q?0KZ0C5IxXURjCs0zC8tyUcOTTsQMcEgcAVpjYcNA286mBaFxv5Sq2BvrOEcC?=
 =?us-ascii?Q?bARb3qltLaB7n7ZQV47MPbqpr1vgV/EJc6R25xdNCeAOO5F1QPbCOw9Xon/O?=
 =?us-ascii?Q?6lirmDGqU/siVuXKmsNcjxRfQgAlwAtaHmkxYWBWIu1sruHNa7OQJdWcWsQW?=
 =?us-ascii?Q?o8ajMIxARQVs111AK96johm4UBvd33ETrKoYLBr2sHKZ/MJc8qNKUt5SRIcT?=
 =?us-ascii?Q?Gy674d48lM/Bt4jhW/9+mzBa9+1zo6ikCyVxoqr05kfXamDYPXD3BLDVQgni?=
 =?us-ascii?Q?kEO4eQhFs7HS1YRa1gHwiRilXtXmC4mx+8W7tYDEUMedkxZBQNZHG2R6k50Q?=
 =?us-ascii?Q?L1klDKJILvl/nabpvgzFj8sG/P7SqHjTTAEVH/BjmmzsbooQgGkCDSvA8MBf?=
 =?us-ascii?Q?U+REBVEt9/l0eHjkqt9u1TNOpsvhT7O2qu6ipZaHewlgCcKKQb1OGqQpJp3i?=
 =?us-ascii?Q?t4RxL7ah57MMoj0/z2E/wkDi5Z6feIE2+3HSPAyd6UuiVdcqlnzupQv/lYIY?=
 =?us-ascii?Q?RzZbpt/tbozu1QOR//LKElAXlQWhpt6QiOAY22G6jETt263sewLcZpieAuWu?=
 =?us-ascii?Q?yx9qHC1FKBL3uUNWP6f9YHS2w9gMp0exVmW55jcQp11ZeAu5t70aWV0/aodW?=
 =?us-ascii?Q?LEWhh6M/ZU+0hGzBixW7ftwgmFRaGYb8rOefu398xmdBYS19MTevGA07rfUU?=
 =?us-ascii?Q?lOrtlc0Jxu1+d2g3xMsKB5mqeIfma025d0vdBZC4ff6SlMgJNG/PwT5jSHH4?=
 =?us-ascii?Q?yFZIHYsrbDlKbmi7fwj5kAKaPRSIpv25H4odF9ehnIlTgx7GpuC9qm3GAwdz?=
 =?us-ascii?Q?czKAU2ny4cwA21DEDOZBg9fECd72ueWDQ+V8fky0NWClmxpUjIbKxJVWrg0w?=
 =?us-ascii?Q?ZbSs8ImzkMU3/txHUboIixGki6NzQVbZcYsxkX0uTniQcZ49loFjo/MafHzZ?=
 =?us-ascii?Q?Sll8Ey1zarKGCL50BNpML8XNE2KUpIOrTB21nOvTuSKELfq06E+mFPa0OPyD?=
 =?us-ascii?Q?ZD5U+hsCoAv4y7UjLVXkxJbKsUGbaOZeZK+byAcka6sohQDgmzRUHp1uRIGU?=
 =?us-ascii?Q?ZUX1peRBEFo8od+gTmSVIPtb5PGOyl0hOZv4e5i3HOqZCwDZXsn/AD1s3IzV?=
 =?us-ascii?Q?z4TobZlM7hEZkAWngWZiqPoMk1dTyh8sWe4dyvcOv797YsB67JFLsTRQMEhe?=
 =?us-ascii?Q?62eDauwOazKR/0TvP7A24ekPdAcEXZraOnfr2jXpQjpZCLB2xmfnA4WUqdHp?=
 =?us-ascii?Q?5V0GDx+H0eINtQmqBQnzvcTss2fNEv/E8ifUAYGmUFXq3+yNZcssmIH0Y5HM?=
 =?us-ascii?Q?DBi5Kw84EqsE1EM/aJ8/BQSXnMu11Di7fXBsZLnH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a659df81-5d48-437b-39ab-08dadc872ad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 21:23:52.3164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmNUpHegBVK1PH9yC0J2UYE3vYSmxKhO5AokJRB7bMVTiHl5BHQbl4oi/tw2gkcDFe7c+rWj56RYOiASx6wiG1z0rxEqHknDuUdkBnGuptA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5411
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, December 12, 2022 1:10 PM
> To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH net] genetlink: Fix an error handling path in
> ctrl_dumppolicy_start()
>=20
> On Mon, 12 Dec 2022 22:03:06 +0100 Christophe JAILLET wrote:
> > If this memory allocation fails, some resources need to be freed.
> > Add the missing goto to the error handling path.
> >
> > Fixes: b502b3185cd6 ("genetlink: use iterator in the op to policy map d=
umping")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> > This patch is speculative.
> >
> > This function is a callback and I don't know how the core works and han=
dles
> > such situation, so review with care!
>=20
> It's fine, the function has pretty much two completely separate paths.
> Dump all ops and dump a single op.
> Anything that allocs state before this point is on the single op path,
> while the iterator is only allocated for dump all.
> This should be evident from the return 0; at the end of the
>   if (tb[CTRL_ATTR_OP])
>=20
> > More-over, should this kmalloc() be a kzalloc()?
> > genl_op_iter_init() below does not initialize all fields, be they are m=
aybe
> > set correctly before uses.

I personally prefer using kzalloc even if we know its not necessary, except=
 in cases where performance of the allocation matters. It helps reduce the =
burden of review as one doesn't need to think "was this initialized?" at le=
ast for the problem of leaking kernel internals.

I know there are also some tools like UBSAN and others which might be able =
to detect access to uninitialized memory, but I am not sure if they're capa=
ble enough at present to handle memory returned by kmalloc or not. If they =
are, then there could be advantage in detecting cases where you did fully e=
xpect initialization to be done.

>=20
> It's fine, op_iters are put on the stack without initializing, iter
> init must (and currently does) work without depending on zeroed memory.

The above said, I think the analysis here is correct and that kmalloc is ok=
 here.

Thanks,
Jake
=20
