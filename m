Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31546502EBB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346591AbiDOSeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 14:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbiDOSeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 14:34:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD48F5E75B;
        Fri, 15 Apr 2022 11:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650047515; x=1681583515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D+g2Ryy3dd3dlgx3j9HUHuZN3G33kMdFpfQKXLSvLeo=;
  b=Oc3SZbnxhEo5cqlZWJ2biK4HTvsaBOc9QBfDC+tL0/QXxwXmyM+5pXyw
   5RQE6MJT5NQcsAtQIcLU7GjGyZN/lIGevXn+jZmb8RC494Qls49U8cxU9
   Fk4hnVkgditON6CgWiNnjAKle8jlFN0NjuPuGfJJs8dxeg+nVWJ9kiPtL
   IOwnV56PEHGgD/eP8WUrcD+Cu+sgicfFlEQ4DO6jG/vYsrvLR4aizD1rr
   PSjUqxcq4mSfmtEZLIoiNy30tU+1GCczHgt7zgNxVpsPSdQKTThNMiOkd
   6weiS2MkHx7/3FNhiH/d8uvJQk48zD5weZDBtPv9VDbb46B2QvlE/AWkv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="288274068"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="288274068"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 11:31:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="591717555"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2022 11:31:55 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 11:31:54 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 11:31:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 11:31:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 11:31:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0VR0FbvI1aQ1jFzjYBt+778XmiARKhVJStzD3tTRedcCpLpIQFxVG3b5gfvJ+prxzf10B27J5st8CrOFnGzEIZqHGn4xiHAAN8i0/199wpyqSxWYxIfBaBRE+p/RB7H8CtylgTiJHnK0E3nxoiF+MZxp8UaqdowRs2vvHsKcxrA2y93ggo1i429K6OTrxSafxul3lI8eWqEhut0YFge/cduZsplzckKKOeYIitgLBqz7JfawKKPp3XzJdV+US4E4CxbWZQJLOeWEvM9wKBMNWu8vyJLjIbwGBQWDwzPgoefnTgIeQeIQKvi1KbPdGWOKXLY1alSRPq9Ifq6lV5KcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKgi64XzuFl89g6cKYzHL7jj+hrCO0VpTPkjfAZ5S5U=;
 b=eKAlZoLFROlrOJRT6/i4IPMxwvTvCRgboECAFBkeBIBbtFSyrqHJM55l1qgRAqEv0Y6BLFHcnGa0+mVs4bgdd32HbFTuSdESEHx5GmjJegZ8CuhLqLinWUM4DYcrHFtQ3MWXkb6hlDnAC7GvULr3iB29e3a5G1Ds4+mNxcP40NjDiboDNF2Ehp9sdmlE2hppoJLCQmawcjgXqQefkh5xARFapA43guq8kiio05uFmCu5sN6eRFGnwElk2odgs1Se+pOnnAOHxR7jsyCspgBzx+UK5NEuRductqP5GiPgyqI3aVliMwUCx2ZunQIBeZZ78w9zSppHfxz/5tsEF37s5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BY5PR11MB4353.namprd11.prod.outlook.com (2603:10b6:a03:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 18:31:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::815d:8ff7:538c:b10e]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::815d:8ff7:538c:b10e%9]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 18:31:52 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fei Liu <feliu@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        "Brett Creeley" <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Index: AQHYTwdgAUOf4mt7B0uReHLUHxZf1qzw4TgAgABPRYCAAB+EsA==
Date:   Fri, 15 Apr 2022 18:31:51 +0000
Message-ID: <CO1PR11MB5089695CB3733F4B1284E3CED6EE9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220413072259.3189386-1-ivecera@redhat.com>
        <YlldFriBVkKEgbBs@boxer> <20220415183845.51a326fe@ceranb>
In-Reply-To: <20220415183845.51a326fe@ceranb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a18d459-1fee-46ff-1a9e-08da1f0e35e9
x-ms-traffictypediagnostic: BY5PR11MB4353:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB4353EB8BFE080AB2D9DA8771D6EE9@BY5PR11MB4353.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWjADGMstrw4cmA0BRDtqGpkv3gHEORdgzxmifWP496Ot+ZvKhZ62/kEB6zueFlE8NaQW9iNM63crH3LFd7PT25dQPhzOCUilLIFmTAPSeH+mv0d+YREYo1ASQ0UOfyrAkdDVNc8O4ifSnb2I9XolGLmpSdJbY1VMwSy60QjqrRl5E2Xpsb+Q1EW75ObgivXXe5pNGmak2yaeSdkMGzjd2+goRN8oB4x0UT9xblf7JVut3kpKJco8Ps0WEMaT+R+zYqV6zz09VjXJSaHiywFkLy9M7FLQA6nm2WuzSq4fBnBs5qwEvdMMwITz5QwEv2quJPafh5ozU1wYOO/B/shTVPmglneS0XTX62q/hWcUeE9NdI+oULzvyUiRrLN94luM4t89bnswZ9Zb804YlZyEmyHf9fXGT0WQzTY9fFDfQsF99xTyScnINehq/YnnhvXbdfUPJ0S39IkCbdagb8V9G8dFiplcRgfEOgYcYNG29KvcXCJmsrrileNgwdXe2Y0VSYRL6Ht8kmeu1QFC20q8aVsuzVOIAKy6zgbi6udhb+IWmbSVKkw3U7tLdvpD2Az4WSYRqp9PWN++p2YMN2mGxlWQhN5HcIiue4cR3YEVUJHFeS6kzn+TLuu2QT8I5pTBQlJA+byNkRBHxa7NZ1RIFQllMSLvryhFCJe4AKQrf1KAMRLq4MixZK4k8tLS2GViM8Xacx7oFbI7XRRXkZiqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(33656002)(66556008)(52536014)(4326008)(83380400001)(53546011)(122000001)(6636002)(55016003)(110136005)(316002)(64756008)(54906003)(508600001)(38100700002)(76116006)(38070700005)(82960400001)(8936002)(8676002)(86362001)(66476007)(66446008)(2906002)(7696005)(66946007)(5660300002)(9686003)(6506007)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IOeci1LKuWqE+TYK0pt/30e7mo6pPez8ztmDs/pkJDWtys/OuDVhItJNZWHz?=
 =?us-ascii?Q?6QvkNfp3FHzr09HFwopg1o5fZ1elh2Lwk4WxKG/4ROb/mSkdyFdeaU5KMm8i?=
 =?us-ascii?Q?zQu8qUIFBmSj1iPk7klIHc05H3IttJjzJvuUyn+ptB5+h+eYkKFkJbEZETo2?=
 =?us-ascii?Q?E5hdvut9jI4roN0pqxj/893lHkGicy5Mm8+dDQmAVykBJObxdO2BstSeuIA9?=
 =?us-ascii?Q?Ed9Du8TAMBoHosuE+7fIttGQjaVyK6Q3EoZqEU8OwGqFVvsVl/5TqA9y5pmv?=
 =?us-ascii?Q?rFqcQiRVimPrFJLayqDni9TZkB6dUythwuR0zF9+dw1Hfa8qh4agHUhFn46N?=
 =?us-ascii?Q?2TH1qiINWvhUrS0HDTY2zf50GG9xTcBE2mwFLA8FHbexeadeZ8fCI4OFu4ZD?=
 =?us-ascii?Q?WukU5NVSiRi6GcCPNcg6FTrA1I6zpIhEDGa3FAJHnkZIdiAeGUpxeSp5HoiW?=
 =?us-ascii?Q?8gHxlfvK02fXkhMtfGmMy/MCIDZFCvgg8awNXoxT4wOYPw15krkTeqLtZ3KA?=
 =?us-ascii?Q?AT0SbVOWzfXmYJbKuxG+8ufBzyAJG329tgqzyyR6lPeQeGs4BUu4WPuiMesK?=
 =?us-ascii?Q?I2re1S/CNfZiV/hXkexVCQIH855/V8BC4tHs3GZxIPtnLpLC007SwZq04wor?=
 =?us-ascii?Q?sMtfj9L73gx5RFl11qroDT2A6h1bItPfiBKbSArfysY2SpncY4wWEMCLnlD4?=
 =?us-ascii?Q?Jk4w9vgdApdzBfTOR0WZzj2iGGGify2XEFwWzbllmfHCwhebAMAE7Pa5cvnr?=
 =?us-ascii?Q?7irhOKFzvISQNQDqQZ69VJG+ARL4kAyI63mpsZ0b4TGW2Bdqm7WaNK02zVAP?=
 =?us-ascii?Q?NUYlSnIn/AJzCfAUCRf2cZGu8aZdst51R+lyP3GFF02joj2nY0ew9HJHnjTr?=
 =?us-ascii?Q?hmYRFvGIIW77jzzknOIL4kvh4Bv3Z81IlYPe6UjSUt2Bvt0W9fDZsDOcJfiN?=
 =?us-ascii?Q?ntRfvyERAs381cdJDu196DzjgMgm01XqedCJpC5XTbtkSXMor4K/NHbuOnIG?=
 =?us-ascii?Q?trylvOQ9VvG3cAMf4YNf1Om4pgHrRAFalBzCHp889NXy0jDP5/ICqB5LzuQa?=
 =?us-ascii?Q?JERlp1EP+DjLfQZa5vXGeuITyw/FzTAArmDPBHWfjvUAY1dbr3Ne5GIO2faz?=
 =?us-ascii?Q?HH3Yn6yGManOSKvPTjPkOb7RjnMlLwrmEA53PocunUd7r433JL4G+f/5HjdI?=
 =?us-ascii?Q?m5dezVzl4yc+sVEbfzHvg+baNtKCE+dX9gfr8iu3OS5M92KB8ED/uQdGB8PV?=
 =?us-ascii?Q?o0BMnkYuR7dg6O7v9FcSghOVx5alLG9jzEyPXSI8EAQcDjf80YVGBmjOffMb?=
 =?us-ascii?Q?bOCHWFjtgbdYUOQ/0o9cg1VVwhmjjemq3TjUjc6qlzFj4qq01xs2tOMH50dK?=
 =?us-ascii?Q?74XmLRqkkz4/WMDCPNlkpEtVz1PTxtrpw8lWlzDikeivPguTzu38uuK4lLYN?=
 =?us-ascii?Q?5ZgNoyUAcBpZYE+zb+dCMlEB2k9XRhvgw0pnGiUl2joEdLGdGHIRntKvdYkV?=
 =?us-ascii?Q?FFFLJN7GKOvWY5IEcxFoJIFnhl52iBaexFh0ZDZ2GSRtWIE1IGjKbf3U5eJm?=
 =?us-ascii?Q?XT/yIVRShjj1VD3rjLSTDjqu3MuBH9grFXgCvlWBLReSPvifNks2PlHBaWWQ?=
 =?us-ascii?Q?9pdpL33FWoxJ0Zcu87z/xlhtCSY4Z4clw0fLAYBT5XZDTj9CarqAp0VH3evl?=
 =?us-ascii?Q?NouK4AgTTqaf8tNHzMGpgPS2SF/G2xvfqyi8ukPVDRw/4TgPaQjZ4Qg6K+mj?=
 =?us-ascii?Q?lliQUFZNGQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a18d459-1fee-46ff-1a9e-08da1f0e35e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 18:31:51.9880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNlGPy34sdr7VuXPXG99LYEnkxKumhVgYE/fbnQWTl6UpMnBb1FFJpjcBwL7fU5VrVFJGOKeGcdLfnliSfsfJCy0yLyI9osrPfWBmgNarAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4353
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Friday, April 15, 2022 9:39 AM
> To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; Fei Liu <feliu@redhat.com>; moderated list:IN=
TEL
> ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; mschmidt
> <mschmidt@redhat.com>; Brett Creeley <brett.creeley@intel.com>; open list
> <linux-kernel@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>; Paolo A=
beni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by=
 cfg_lock in
> ice_vc_process_vf_msg()
>=20
> On Fri, 15 Apr 2022 13:55:02 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
>=20
> > On Wed, Apr 13, 2022 at 09:22:59AM +0200, Ivan Vecera wrote:
> > > Previous patch labelled "ice: Fix incorrect locking in
> > > ice_vc_process_vf_msg()"  fixed an issue with ignored messages
> >
> > tiny tiny nit: double space after "
> > Also, has mentioned patch landed onto some tree so that we could provid=
e
> > SHA-1 of it? If not, then maybe squashing this one with the mentioned o=
ne
> > would make sense?
>=20
> Well, that commit were already tested and now it is present in Tony's que=
ue
> but not in upstream yet. It is not problem to squash together but the fir=
st
> was about ignored VF messages and this one is about race and I didn't wan=
t
> to make single patch with huge description that cover both issues.
> But as I said, no problem to squash if needed.
>=20
> Thx,
> Ivan

I'm fine with either squashing or keeping them as separate changes.
