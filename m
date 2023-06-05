Return-Path: <netdev+bounces-7966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 177B87223C7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4073F281202
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9A21548E;
	Mon,  5 Jun 2023 10:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB34525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:47:14 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAA4DB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685962033; x=1717498033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LrmQaH9ebgO0jFzL3ZfWoEOoho9uIDpVMV/MFHxmJ4s=;
  b=HLA00bH16AEbiShVtko3B2L9lpOxP5iTaTpWFWe9tSgkuViU3J4SA5Sp
   LfpWwsMW7DURKgLmKSroPebFuiPp+hUL0PC89j/y+FlWYL9e2u13Uo5L+
   IbHSjDM+n2LXVLP3DFPPLwNnNUpAWk0w/AkSwUYi7YakA6G45zlMy/Fm7
   Da/L/b+T45eisGUxw7c6jRkvwyVjGmk4EsVPyBp6JbcuZxrFCQXBj5Ehj
   RjY8eXVWpnldwRtmZB3wDi2beLPBX5Gcl7D1M6Ai70S7rPjMlcyonEted
   iseXWkZ3B/bH1xE6QYqN+D6vG2CDnIdRqKfYPwMDRH6pU1a4ZLIBsFmRY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="419883769"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="419883769"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 03:47:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038734293"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038734293"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jun 2023 03:47:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 03:47:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 03:47:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 03:47:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 03:47:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm/c1DLYD7mR2MmeQ5uQb7UITsh/wnAaRpc/0FFaaoV4J3uQpeQRq024sedH1X6c+o9vic1KIkTVZKPTOr4ZXBuuchVIriBWYCznYhEReB8hRugl9jiMIvcqaUsskpm3EIkiPfOgGLNEv2bhhJdGQmci19Pnp64USm2eFe2XN1RWV/3uFbUYet7A9hySwGF6mSUc0huWTTpLaz+BwgTW4/4k89hOGgASbFLK97Muz7v36mqqI/ZUGS5aJozfuhpMyElgZ5vLYABY+mANwE4aaV3us8MTETKCPAY+c4dAu/KIaTEZSiuqjrleOUtl8G4thhvIBhOo3pJ2KeyieKxjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xo0RumzL5/XUcrd3TJyQOBGoRpRpcS/aoHiMIIqxUXc=;
 b=Wu6eozCgNgCsSi98PghhGMdN+iF1P1wk7I8zXfBs02fBZFl1VEzu/rZKbITtgGjj2jVU18yyfdxLkrLm6JrFWnveeK7+goOBGRjsZ+tBvuENbNIoneGqiu8NhLrtIDn7w2K4LG8wTcge+36HHiOdGeWFk7WQlfuM4032/UiboJ+ILQdQ5FYJNCeIY18QAEAdbMCZXBI7YfV7utoJtPA5u6v+vsRDXDewE/ZrSamSzE0WGJREEE++vQ43fkAYvvkqrcwLDsAhDIDa/pyPxL4mlBcfwutZHJNGPOyswNOkMEFjUTK+CoovRLiP9EcUiyYNIEBvwV8uLR8QL9xoivvAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN9PR11MB5289.namprd11.prod.outlook.com (2603:10b6:408:136::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 10:47:09 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:47:09 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
	"Chmielewski, Pawel" <pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "pmenzel@molgen.mpg.de"
	<pmenzel@molgen.mpg.de>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [PATCH iwl-next v4 06/13] ice: Implement basic eswitch bridge
 setup
Thread-Topic: [PATCH iwl-next v4 06/13] ice: Implement basic eswitch bridge
 setup
Thread-Index: AQHZluzW9WNnX6aw1UCn9KNPhDEEcq98Bx9Q
Date: Mon, 5 Jun 2023 10:47:09 +0000
Message-ID: <MW4PR11MB5776D4B4B3CB687ACCBF49E4FD4DA@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-7-wojciech.drewek@intel.com>
 <ZHyYwGf8locVmlCg@corigine.com>
In-Reply-To: <ZHyYwGf8locVmlCg@corigine.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BN9PR11MB5289:EE_
x-ms-office365-filtering-correlation-id: 2979d728-bf72-4eae-07bc-08db65b23680
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lPfFljopk4QXy3Z+PA0CXNp7wyzqvpc4SFa+L2dPzGE+VxIyuUWxv4Rb8m6hcCnLBwK6dlgY1f3dpR4Q3rRk8LqsLrSjt2+dsqobk1VUz0nZoI0d2QBcZnvar39rGjZhP6y+VZkuZlW1/nBXMRpq87cdpqIjTrdEzkQNSXLKbV1wvt3k68ViGA8Dlr/FdlBX3gduVQe4KwjGcdudxtITUdsgvJfftd7/XUVjDocFzVTuJFlq7XWIorVw9ydepsfrLGjnMmaR9M+3RePzFBsxO+sq3j8a8pu2dDikI0E6M6rLjtUPnPLsyK1CUbdtnll5L0InYiedypchBvXO+UhuCDczpZnuC6AlWdp/wFylNS/uYgsHtBXcizfE857r6FtKZLwzrUzpUCObFuxEnOBbZVV75Mk+8n10v8Scbl93Mo/ZHBYJEybX7TMGKDJZkYptHwpWXGICWteHgkidYsxcTeCBzMpkGSBZFPiGSgRmqscniBVuXrZPMCwjkIYq//YeOxLT8eGvZfwEn4tG09TfdGZ17FN5Wd2yIoP3x+aZFy4tQJV47ocD4kdcZkRFwabGCMBJSIrq8Y1PymOvop9hzGzNKJso4K1IuDzK005gEZLkBe9ivrs6cawE08USlQHJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39850400004)(136003)(346002)(376002)(451199021)(478600001)(2906002)(7696005)(33656002)(71200400001)(38070700005)(83380400001)(186003)(6506007)(26005)(53546011)(9686003)(86362001)(122000001)(82960400001)(38100700002)(55016003)(316002)(8676002)(8936002)(66946007)(76116006)(6916009)(4326008)(66556008)(66476007)(66446008)(64756008)(5660300002)(52536014)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mPbLHPkjfIiQIWNHBHEEIzqgqoM+UuAAPSdRUwr4nVTL7kh463N8k03gGxP/?=
 =?us-ascii?Q?1huMIlnm2v1DE5UJYjq8c9jAxZZ8qUiFMawmQoZ46TAoLZ45TthaQV8WWRd8?=
 =?us-ascii?Q?Xh++Dtfx1SFXar9/C26kjJqCSQA5vD8dcfwA1KQK5T3QtL7WpbNhu09goYwq?=
 =?us-ascii?Q?vywRHCfJ7F4YOewrncus5CpDX1jxoFEY0geXCRuJG70mZ00YXPkewUn1XEcA?=
 =?us-ascii?Q?mqhRvfytFqRuashwQrtTUdYc4lSkDO0sXTw/poF9Lj/rIGwGaIkIBXp6/Spc?=
 =?us-ascii?Q?sr4H8pIlduN7l++/45PiINOTz7+WfLouFikTCW/OTMd4xNtCpRhdpgd9kygp?=
 =?us-ascii?Q?oFmxemtOQ5/ZlLFnCkSRmDfEHwv6Lrx1DM0m7wg/Bl6aVgtllZgvvqarUoma?=
 =?us-ascii?Q?t6NpaL2RT07okrXCDxcZFel7oY0WtqMb1Dxn0yGmLt/saN/iBBZZ/qDIs2w0?=
 =?us-ascii?Q?lxUHQQ3+V7wd6Nv3QSoM1EeLR/w9dnRH4KxFAFS4/4HELXD/a0hfbW/SOHrs?=
 =?us-ascii?Q?p1UTFLBJAyEz1NjZKw5oUWCed6r94T+lZJj6pws7MO5UylzoONmDBKJsqv2U?=
 =?us-ascii?Q?ZbaCwq6MCGxQN0nleawHCqw7e1JU5U+DQsvkHYwNcf4WNU5MfxboHNa2xN+e?=
 =?us-ascii?Q?sROkcKh6eQuk2RXc133WArV3wdBFVUQSohIALvFBdvMbcJDNn/5M6xR3z284?=
 =?us-ascii?Q?o8RdmnESGOZuTZPUutQ1r5HBThs1XiOdyG2oa58w/7GMnFfOIg6PhdlVhNJN?=
 =?us-ascii?Q?ebN9fpKChp3jbxtQnBCLl5t/tyXNHYKY/e0t29dMTharbFz85nVuM56vT4h5?=
 =?us-ascii?Q?M9FD9ucE5mzrWrw3hUQSmboElFiMtESTKXoOaM0MXVMbCdxIHuAqHoDNHH9U?=
 =?us-ascii?Q?h/Y033ZCNO8l2w/IViW495nhTMoiTNLXXpUDuRUwbvgxziUkM2amJSeGZKq6?=
 =?us-ascii?Q?4bag5/fnbaPDmz7WvJBybQpy0bM5aM5cycQsFTuHBF60inHNARQpVpz89toV?=
 =?us-ascii?Q?9Xkxw2n92BeeHUyD0s+foqWVbWUzfR0FnSUQBwehvHGOEVMU71tTW0MiioXI?=
 =?us-ascii?Q?aQ8CGYZAaVVk4DYlzKKNKX76cz3U8B60jGEv9QMPui9UJM3+BO3adeE2tfEd?=
 =?us-ascii?Q?gbvD7HO8quDyssR2lkCVZrFCO/FiAof/Nr33QVaUZex3cnIpiawrOw4vdd7b?=
 =?us-ascii?Q?oc+p4MSPfDLkPdXgjGT3tL2mQC6L4Upsv4bIxt4IiSNMgc3a5F2Dsk/hAgNf?=
 =?us-ascii?Q?8+Y1w15zM+exj2HLSyDrT2LlE5QL9Z2UIuR/LxnS8/eFhuwR1tgvm3YffHaL?=
 =?us-ascii?Q?djUFMvzzOVckcyDdquD9NwYhXvm2cHpsveUiv2hq8AFPO25A0qQRVGtkweGz?=
 =?us-ascii?Q?BmefPA+nemwafdIgbUnC/3I8kvG3OhtxpYVHNZ+FoAaC2/KaRBOIahJIwZXt?=
 =?us-ascii?Q?UjrQRFxM0/OPCyICD4/jQLyhhrOdBOH/zbKKiZj46ezev2WiTkPioh2MNhQR?=
 =?us-ascii?Q?UUTueKBrTecpDWIcjMhBq8rNpvOcfXowQtRBTrV0irD5mVujKMy+6AZaGcHs?=
 =?us-ascii?Q?jTG/SSpMuYVUMpOpSKEmR+YqUw8BcIHBLy/vM9AV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2979d728-bf72-4eae-07bc-08db65b23680
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 10:47:09.5542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NfVri1FOweRvoX9LfPnm6b/l4V2eZTm8GVv6dPO5cgKS7tSaUwbpDjwmGZUGRALK6Zh46J9a40d3u2zN9xaSpOIU1tfUrVOU2mT8o3CNRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5289
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: niedziela, 4 czerwca 2023 15:59
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Al=
eksander <aleksander.lobakin@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.sz=
ycik@linux.intel.com; Chmielewski, Pawel
> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@inte=
l.com>; pmenzel@molgen.mpg.de;
> dan.carpenter@linaro.org
> Subject: Re: [PATCH iwl-next v4 06/13] ice: Implement basic eswitch bridg=
e setup
>=20
> On Wed, May 24, 2023 at 02:21:14PM +0200, Wojciech Drewek wrote:
> > With this patch, ice driver is able to track if the port
> > representors or uplink port were added to the linux bridge in
> > switchdev mode. Listen for NETDEV_CHANGEUPPER events in order to
> > detect this. ice_esw_br data structure reflects the linux bridge
> > and stores all the ports of the bridge (ice_esw_br_port) in
> > xarray, it's created when the first port is added to the bridge and
> > freed once the last port is removed. Note that only one bridge is
> > supported per eswitch.
> >
> > Bridge port (ice_esw_br_port) can be either a VF port representor
> > port or uplink port (ice_esw_br_port_type). In both cases bridge port
> > holds a reference to the VSI, VF's VSI in case of the PR and uplink
> > VSI in case of the uplink. VSI's index is used as an index to the
> > xarray in which ports are stored.
> >
> > Add a check which prevents configuring switchdev mode if uplink is
> > already added to any bridge. This is needed because we need to listen
> > for NETDEV_CHANGEUPPER events to record if the uplink was added to
> > the bridge. Netdevice notifier is registered after eswitch mode
> > is changed top switchdev.
>=20
> Hi Wojciech,
>=20
> Does the uplink here model both a physical port and the PF link between t=
he
> host and the NIC?  If so, then I think this is ok.
>=20
> I mention this because I am more familiar with a model where these are
> separated, in which case I think it would probably be an uplink represent=
or
> that is added to the bridge. And I want to make sure make sure that I
> understand the model used here correctly.

In our design we don't have separate uplink rpresentor. PF netdev serves as=
 uplink
repr once the eswitch mode is changed to switchdev.

