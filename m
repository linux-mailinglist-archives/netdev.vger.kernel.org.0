Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260796CD68B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjC2Jea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjC2JeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:34:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4F4205;
        Wed, 29 Mar 2023 02:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680082454; x=1711618454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pTHNjhGTjlvptSWVyEvxA8QgaHyi/kcQtUwG/guDHT0=;
  b=f6m+atgi2Xb45FfnZfOxW8lcskyKjK3lnjujy51FKbUTK1ero1gQcJjd
   23BPewgF8rsRQJCQEwvNt7jJKq3cvlnMFaQskU18d/NAQMcPo/xkV1tS/
   L/WjuVyR5MwTICzdvKPvFpuJrsXN/mmRYcB9slrWBy0v2naS2TkPsf6Ow
   RrK1LnjXM39JRlg0mu9KnciguCTTu11b8Vu+FW/PUFG+uT3eQD0GA0w2a
   H/783FYLxDUkbiTtszKydn3fdmrxJvgX29dPDb0hT7lujExVPQz7+UKDC
   UTskSq6r/YFt9Ba4P9WNF5ezrgWekvqXuVyEDuk9IsqLO8rHlcxcUttue
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="342422134"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="342422134"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 02:34:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="684194860"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="684194860"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 29 Mar 2023 02:34:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 02:34:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 02:34:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 02:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfDUPDSfjIyUEl7liWwOkrk/Mxoe0oBMZ0taTdQXM5O1bqxS8L9XXVO4lsfFu0be0lw+akdCCHIzbRod4Ro+iMzX7ZTeozaTHNDoGO7SeKp04VvPB+n3yY+Hg2wH9b4ZAMs98F111/YcCSdd1hsE+Ta4ckNuxh5cOl/M8YgNF8+d+F5mzztRfFsNkghQfwrejwltwOZccTe5raVcHwacL+ErMTjWrPVvp/STzk+TU3Td/Y5dSG7HJwBk4oFjlbrDMtqJ5K4BXjHr2FvoktDrc+zZ/MBtiZUziBo2apUOnbnwTxAHD7lORFUshrDdQj5y1EJg00OA6rIc5SGLyQD+xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJiDpCvzhi0LDCk1C3UTGyyuZ/EJwsDJqzcamPx9CvU=;
 b=IXNvbp7WTqqFlhW6D10F+qpjhKCNS85S5uNn43pgZ1mtK3y6ort2Vst6c/LGxP3ZCW1zUjo453TifuLvGSAldc3CxBKNvoEDM4xvGalo+4jJKiWN4XnUAmvkZWrpq4acWngIk2MddUSaieLvM1pg1DSeDkDPwle4ys/jRY+bpE455VyBB/qF6sPRLo+sxWgRpkYPq6y9ULJWbyC/agH/WF7ULPxl+A09NwtrMfbGR4BwtH402WdoHRk3xuE/yLKy55OC92rTlhSpfLIp3CkLC47cZa+o9QC2u9JVEsGgh732/j0q0yEMOAHLlUaehkII/K2TTIDD1W6UQY87nfjVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by PH7PR11MB6607.namprd11.prod.outlook.com (2603:10b6:510:1b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 09:34:06 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::7237:e32c:559e:55e2]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::7237:e32c:559e:55e2%4]) with mapi id 15.20.6222.030; Wed, 29 Mar 2023
 09:34:05 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy() method
Thread-Topic: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy()
 method
Thread-Index: AQHZYeHk+8hBmIiC+Em+ShKa+OFiu68RdlQAgAAGu5A=
Date:   Wed, 29 Mar 2023 09:34:05 +0000
Message-ID: <PH0PR11MB7587808A98658C9F075A0C309D899@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
 <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
 <20230328185720.6239e4a7@kernel.org> <ZCP+aIoUTw2laZ3/@shell.armlinux.org.uk>
In-Reply-To: <ZCP+aIoUTw2laZ3/@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|PH7PR11MB6607:EE_
x-ms-office365-filtering-correlation-id: 29dbc8ff-bd51-4c60-431c-08db3038bd2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X/D98TY6v168KWe5rctEZoAra2HhPBI/l1ZNEqxJcxpckqjhF+g1cqhmgnb6RGHYS0s4SqpJaOUnBgbraevLtZhqWEpTy7UouM9SWC4vaboqL5P6ao+iKQCqmKKNmjdyhv+96RPnHs1uBBHECNCHVu61GwQGQkg43VbYFguDfogyd9Wgwfwk6oBdIP7AtseZk8hnjrmzrThdDs6xQ0budcZO/vr4gdO71PD3+RRZYquEMtHNwiA75hSqiGfzJCzqmhC3ywcpSCUKlpKEJVRl25MoXx+5vkqR9TIpgsgbMiRxfL5HYG/YIXyXRzUjXERa1c25gtMYJUu92L1cPl3Uol/xLpga13cqAVBG9hZYAZ66nN8tKQ+z5Rmcjhk5ZegHx8DleaIYaVmLsROP5CQJLgi/b/mryPX8h2NUhL+5pOEzOvR1NiPyvFOkHqSOuaDKN3+rcavd2IY4OHj/rWucpP1Ji3q5Pzq+TaDeVuwX7dczzwX/9/teg0OfbD0dRFAOoLkXC3ARWMhNddyMflfZN4AYlcp0C0H5auMht2Vfm1UgTevVtbnqPOM3pYc/Gh/UgQjdPUlJScmJ2fl0QVjlQZkDG4YBlto7BDoWC1Aui9c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(53546011)(6506007)(26005)(41300700001)(9686003)(186003)(55016003)(107886003)(7696005)(966005)(71200400001)(83380400001)(478600001)(54906003)(110136005)(316002)(66946007)(66476007)(4326008)(7416002)(33656002)(8676002)(76116006)(2906002)(38100700002)(64756008)(66556008)(66446008)(82960400001)(5660300002)(52536014)(38070700005)(86362001)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JylQeRh4quPNteiq6T8lVtcv+L0aYjHT43tXZKEpFEra8wI7ObG/6suXJZ3P?=
 =?us-ascii?Q?S1iD6KmkU8Z6lalz+TKyXlQJHI/lYxSs9qOwos5CVC3jHxBboDsww9hm4zRd?=
 =?us-ascii?Q?AM3rq7UEn1J8Q0S/18k9I94oAlP3EG7Sw6szzI5/bipECHnBn8ZcxWVK8g2A?=
 =?us-ascii?Q?uwIOTj1ms7MKqD5ybklMIk1UH/2W1zyrvpy4caoAgcqu4sm+ifAJWhz+c8ci?=
 =?us-ascii?Q?eS0/+mzTT0+OV3iM1fYX902dqaVAQomgDMAg2m0UCvQyBifyayIxy4CKfxxN?=
 =?us-ascii?Q?Kyg85hwfWqna76kg5UtwfSGAnqLazQWNiYEs27yZ6xUfELpi7U/Pnzfk6a0A?=
 =?us-ascii?Q?esQD4dECAcIYRmkbkEtVznpjeVqC78AoPK4dEL1VkSgrOBzLtRbQrd/mCOsM?=
 =?us-ascii?Q?04slbkC97JWIphkUwvm4mpiaHRBy/0mRzia5jI6Tq2wcfTrMnw5O1k6H8BWT?=
 =?us-ascii?Q?8wtGtO6jNCWSlII0ZGITLc/68liRgv5hNuGOx//snmK2V86kXPrWTSN+Y/3l?=
 =?us-ascii?Q?Jwo/iismzSvAJOuzb+KkR8niqaxrkNup8RJKr05ygWoEVAzWA6OSvMlkYj3g?=
 =?us-ascii?Q?ceZDXJHOCBY9F07P/ifceM1LW/wNZR1ngAAMHkua0DWIH5lo+XQWuVU7SUF+?=
 =?us-ascii?Q?B9xLBMWgitHIijIZhD0E/pmtJyuqTq0MvAQAL4TS+mAOZxmYYf1DcEElGTBv?=
 =?us-ascii?Q?ZuKPiPpQgAR8YAPxTRTl992Jx3rIv/h+siKgECqijOqTSHqnCkMcRL6sXNsh?=
 =?us-ascii?Q?jGca1oRZZlMgUVWMWHrzD0BGh1Zma++hS7pFVLkee+zeMRfRc7Q7MbEU9RGJ?=
 =?us-ascii?Q?9ahj9C2qwsIDa+ZLtKzSjw6nTAFHK6CZMC4YZaT155OljTEUHG1GtsoqFOEt?=
 =?us-ascii?Q?rYqT4hNZPvgC+I36m3eUR8LRVOJiBfzATAEPiaK8gO4u/SzeH3tNGpd9JHgt?=
 =?us-ascii?Q?UUjycGrWb9N68X6U0v0WB4DWwh+kWR25h3KeZjDl/LKtzE6u2bHTnmdMeIzQ?=
 =?us-ascii?Q?S5r+cHSVLTGnR03EG72isTmrB1aI8ASXH0+AY2oMtSJRKEeNGXCLDx//6NhZ?=
 =?us-ascii?Q?+DsU57hxYgojLtmupArjAfDlkPc2K/g90vbIVWLacZX6h41VWo5C/NGjvkOV?=
 =?us-ascii?Q?UpXA0j9MjFj890bgti0EJOEPkkqG7jpCTUzJ2hO9Ee42WToYn0YRop6aagCu?=
 =?us-ascii?Q?QreMNVt4GvOjoJjQMYbOVM6FOccRRdFP1/7GovICCkLP8hzDc7iOFRlb4n8x?=
 =?us-ascii?Q?MsSTZb7X2ulR7j9t7oyJwfSLiode5oMQTYzMxD9fTqDw7Dmsl7ehS6MhNcn1?=
 =?us-ascii?Q?UER2VG8aoneBaEBo/HzIAV0/Z+BKJjk31S4ogzAP7ntuc+r4Elp6TJ8C9g8o?=
 =?us-ascii?Q?7TXFFndWm7M78B6/xrtrn+kqy8SGR+KHe3y5lBO1Z2LCoJrACbCr6V6Mv/EH?=
 =?us-ascii?Q?2GnhYWDzsb3Rj6mC4yoJwHbYJtfe96UPrPwSHnKCG/+O8BeSRNqz694XQvmx?=
 =?us-ascii?Q?zdoB+T1A6JKCurBqWzkWP1n4P/UvMEPIlNlnztYmgHAeAt+Vrzzl7TGRoNZi?=
 =?us-ascii?Q?jv4Wt1qiJuysKAno2hgdPVwl8Lq5VxgP07gA8Ne105Fxle2bYx25qVW1ZeFz?=
 =?us-ascii?Q?vQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29dbc8ff-bd51-4c60-431c-08db3038bd2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 09:34:05.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nuXKHg2irg1D1eYmatYY/x+MMZNzuyu84sWBbOSdzXM71CryetHLLscExV/AB2Mm1l2dYGAdZW8mVwdbvaaUYJRY8PyyqE8dgSz/oxBWyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6607
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Wednesday, March 29, 2023 5:01 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Paolo Abeni
> <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net v3 1/3] net: phylink: add
> phylink_expects_phy() method
>=20
> On Tue, Mar 28, 2023 at 06:57:20PM -0700, Jakub Kicinski wrote:
> > On Fri, 24 Mar 2023 16:16:54 +0800 Michael Sit Wei Hong wrote:
> > > Provide phylink_expects_phy() to allow MAC drivers to check if it
> is
> > > expecting a PHY to attach to. Since fixed-linked setups do not
> need
> > > to attach to a PHY.
> > >
> > > Provides a boolean value as to if the MAC should expect a PHY.
> > > returns true if a PHY is expected.
> > >
> > > Signed-off-by: Michael Sit Wei Hong
> <michael.wei.hong.sit@intel.com>
> >
> > Russell, looks good?
>=20
> Not really, given that phylink_attach_phy() will refuse to attach a
> PHY
> when:
>=20
>         if (WARN_ON(pl->cfg_link_an_mode =3D=3D MLO_AN_FIXED ||
>                     (pl->cfg_link_an_mode =3D=3D MLO_AN_INBAND &&
>                      phy_interface_mode_is_8023z(interface) && !pl-
> >sfp_bus)))
>                 return -EINVAL;
>=20
> So, if we introduce a helper named "phylink_expects_phy" that
> returns true when cfg_link_an_mode =3D=3D MLO_AN_INBAND and the
> interface mode is e.g. 1000base-X, but then someone tries to attach
> a PHY, the kernel spits out a warning, backtrace, and a return value
> of -EINVAL, things are going to look really rather stupid.
>=20
Should we check for these 3 conditions as well then?
(pl->cfg_link_an_mode =3D=3D MLO_AN_INBAND &&
phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)
to determine if phylink expects a phy.

> --
> RMK's Patch system:
> https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
