Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F993542B7
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbhDEOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:23:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:25123 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237153AbhDEOX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 10:23:29 -0400
IronPort-SDR: u2IUUuM+CphAULRpAOg/EdbKMUsisSLlugHvzXbYX5a1IotdmhKCDLc3Lw+mJq7RaQnlfMtckE
 Z4u/rl1AStLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="172926665"
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="172926665"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 07:23:23 -0700
IronPort-SDR: a5FqRHz0RoIs9JzDzjjYHb0OmJvAbMAnT2064Kwc6o/QO/2eh434VXQorYT/eCgk6vf+LdodNQ
 imuULddV5D+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="395830288"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2021 07:23:22 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 5 Apr 2021 07:23:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 5 Apr 2021 07:23:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 5 Apr 2021 07:23:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7g8dGJaO0Yoeyu9fh0GwZaDVoIopWCHSKf2r3S/mQtKqSEecfwEZ9Vp7u8FSMvC2y9Wvs+lVAgxCah7/El/5x2Q6tRgYd7n4xo+Q9MIGWmRqWG/fsRDfQ+s/PZ/b5RLxufQKaigg21HvdbYFePM6Rla/zH+A5omM57VYV6ulqJd8g6UYSpagfIiI4DWOR8I1h7Zjw7iCP4NVNO4mDQigpgA+SOjUp6SzRqNBzBVQwT6E0yro2y0qmt7lugRyetlXvIQ7sC+VV+PR/nc73qbLFofX1uUXyW6Picla/utk/bbFHCw9ugAJWSkDKoR+5EQPoKKHOMSMfqF9nnE39nBZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDvXYIjppvy+jPqBfFxeKrZJtjImc4Z/1CzQUpO/HJE=;
 b=Dk8seGwN2sXiUP2cxM5taoXX73chOsXqZPST5RWSOCeKblFM7aurLR/Dwmc+HYU/1B0lzBxzt7x0KGi8Rsc8+ZhtRkMtJbY2dPuHU8Dpl6AOybzBT+P2i6ZVw01DzdWox36Cc1FeFOQxSKFvQsGYGCuX+3NgDaNwf/lNI62OV5UXvi0GHiVxOE6geCR+WJkB3jgx26TArV/O+Bv7uE/gsadpIQNX/+5YFxKFqkG+jjrndrQqu+601rnvARaN6Dm77TDUmnYGvqPPGH87nrwjluT98KK+uUW5XSDWMYlmbXyyPXnrVk1Ltr7oUZYWkir7qRyVIynOzPR1PzriSkWP4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDvXYIjppvy+jPqBfFxeKrZJtjImc4Z/1CzQUpO/HJE=;
 b=uHWqzj2m2ZWEMDvtc6l5OnJSv+a7fo0n+V6QOkdiQp4VnPtDFh0Lh57CivXJo7PyK09cN4fMYmTxNGattFYTFP/j4V29XqTHSifNieB7EZX8JlkswW7bwzIT/b3k6b/ILwRxLXVW6K5XfMIYKOKB4yAaklL4fcgNrjiPmqnEe48=
Received: from CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 14:23:21 +0000
Received: from CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::9504:98ae:641:4f57]) by CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::9504:98ae:641:4f57%6]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:23:21 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Thread-Topic: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Thread-Index: AQHXKh1iSqorLH9tdkSQSbVyiN9Uw6ql+JIA
Date:   Mon, 5 Apr 2021 14:23:20 +0000
Message-ID: <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
 <YGsMbBW9h4H1y/T8@lunn.ch>
In-Reply-To: <YGsMbBW9h4H1y/T8@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [58.71.211.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8327a9e1-79e9-43fd-5335-08d8f83e5d67
x-ms-traffictypediagnostic: MW3PR11MB4587:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4587012B5DE52A92659472549D779@MW3PR11MB4587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYrjA7lcH/ApIXvqAplAOpcqgMJ3I8ltfxfEcXas6zGaKnxWTHezapEj1Gw3YvyGY4lRHdOjFjg9aMBAk09upeeVyKl7QxPyjma25IT+K3WRZHD8bCngfH5rdBP8v7pNaMtusz7rZYIr0D+0Xub2GKHDmC2B2eCNOfNFdGZYjaKQHAERq3ZD8a/HJ9e8fDn4LZ6nSrKs5zxEVkfhJdIlQL94gd724TVNIP7WXt2z/PdonG47ZA2lFRgV0Nr232OZqFtYTFhNy1p97SG5KHGOI7X/3d1seTIJWhSdQd2uEe9SHwAmxENRi0d5LBn3wRFQKzsMvkSPOtkwQCgfrd8FdI3cwqdogPXzOBp0IhLA8HwA3UfnO9HleM4+lh69daBedk0LyazZwEP2nRgT0MSuwi4bXzIXJkLZnNyqciM05CtGoY+r9Ex4Nc5h6Gpe9MACnzZUb2RuDxOfEfuko2Z4CrwjKmv31oO9zLFU511KOg4ejcBSKya0AaizE4RFn4dXDRraufVAroj7f1nLEe2svn//XwVtM78pMCEqc7Kx8swWCJSroRimAtVgB2bNsrHEONpPdIncF93sJSxLLSTrCIeGBguWJ5sVGxn72zwypcm6q7rjOdCqcmMU1p5E14t+u8POw8JePwXu+ENDJ2dJ6Gn6aAHa26/OiUl89QP8fzM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(39860400002)(366004)(86362001)(9686003)(186003)(33656002)(26005)(5660300002)(71200400001)(52536014)(76116006)(8936002)(8676002)(4326008)(6506007)(53546011)(38100700001)(316002)(2906002)(83380400001)(6916009)(54906003)(64756008)(66556008)(66476007)(478600001)(66446008)(66946007)(55016002)(7696005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HPlCUJV0Br8KMeHBsKBOBPBkxFOP0sdpc3/rQ5WpF0fr9kxPe3AFcK9E7ufA?=
 =?us-ascii?Q?V1VwaHWPWIMlgQy5LK/19nhU7eINqt1DspCpfYHfz0C51xHAsRQC6Kbz1pdb?=
 =?us-ascii?Q?+b3VUrAnmfGTm94RqlTXe8IN3Fl+pSlPyVd2t3w7bEMK0Bl4kLH7MJV42lal?=
 =?us-ascii?Q?dGFIkGCggafgadFmoHDyCF0ND7IMAvpRr+pWwUE7MU6kqHvRmrHdshMPIto4?=
 =?us-ascii?Q?LKeBnqbcXpnBMuw6A9j7kww9mqbgg2aequ8vdXU5xg0IUJewYNfWB42Qxr7N?=
 =?us-ascii?Q?S0AygMv01v78cZiWP/Ir76Xg4a++7C3C4fg1Ci2FxVutLX4CKkajlzhbVCWW?=
 =?us-ascii?Q?B6RsWVu62QFtyVBV/FNH/pMCTSKYq4PC8hLImwZkvJ5jO6A5ZwuHLX0acGD2?=
 =?us-ascii?Q?fhb2RtdXvP3dvdJ3SeBR4fODXup1EHwEp5xBAYX4O7jaUbD+Yldp62P6cnYS?=
 =?us-ascii?Q?g6xLF4OQYA/afmYj7hoAcWUI0ZVRaOzp5rqnC6jtnVcuNniComj/nleTxIw0?=
 =?us-ascii?Q?U5m7ZHo/Ysf/yfd7wRXvv54+imedwJkADyaI/yHT495vNeBSpVI+Jsumxq/9?=
 =?us-ascii?Q?H6zu3tSQ/Bg4/TRLSUJ2tkOWcyCIolej/HIbuZx9xRspVjOIChY8KWc9E2eQ?=
 =?us-ascii?Q?+5rZgU2vxQNrQUi/OSUp9iVRY55xdun45M0XuqisHIlZOKj4vzv6D9fSHbMy?=
 =?us-ascii?Q?iN1aA3b3u0A2DuhT/a88zspcWHPJ7Ix76p+SV5rl+XVSB1R0UNE7Hn50oJsU?=
 =?us-ascii?Q?xWFdH9IwN6cbs5u4Vt32uyn2z4MTQpyvlW3jgpx9sKy0in3ICx1HvO3nYMqt?=
 =?us-ascii?Q?/onfEe+zLjEt+qWZWPrPdHtWNAnEeOPAZbFjPqPQk8TlJHDCUYVIDpTCIx8M?=
 =?us-ascii?Q?guAM4WPLbpBf1F8uEpfsnanoAejVC6Dr/eaoH3i21vUVXkG4lzOMIPSbunBZ?=
 =?us-ascii?Q?FQUrHz41xRrTtOSQPCBhDzvLHIaOp3ZeSuiSPELvxDPYGHyw7SMK4gzqWD6Y?=
 =?us-ascii?Q?EebH7/pB9UkJKTDfAwHUhIArZFFxtth4KMZQzsrzEbwFT13uISBqFnzfcexF?=
 =?us-ascii?Q?Y986COfFFJXg4xUrcQgEPn3EwmtspUJ3AYxHkbpEOuxLDF4jfy6LU1JMKyKr?=
 =?us-ascii?Q?RngWW+47txClkr/GnrwlW+kpGeMztzZUUMBz9KhBR1uwk1/PpzAk0PRgfrLC?=
 =?us-ascii?Q?OrlgbLh49KOs3bapBPyLyux3G6YWjkvWO8WiXpeNrEJaSfkXmBmr+NK5OvB5?=
 =?us-ascii?Q?99p5h3BHUQ0aUMpGY09dnIT56ztnEkL4UAmjI7ZnV/sf95BqBPxLdDNEF4Ot?=
 =?us-ascii?Q?kmjr8+dSKYnDRV6Zx/GkEFCr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8327a9e1-79e9-43fd-5335-08d8f83e5d67
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 14:23:21.0015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uwb6KqtFi5pneHlGMASR2slQJZ8LIZYGMwDdfSK8HqYM8cbB7F5qFDC+yr5cIkWLbjjKtlwrc8xk0qTLwyiRXZ6g5BiA1U8zCHIeu6764o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, 5 April, 2021 9:11 PM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: peppe.cavallaro@st.com; alexandre.torgue@st.com;
> joabreu@synopsys.com; davem@davemloft.net;
> kuba@kernel.org; mcoquelin.stm32@gmail.com;
> linux@armlinux.org.uk; Voon, Weifeng
> <weifeng.voon@intel.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; qiangqing.zhang@nxp.com; Wong,
> Vee Khee <vee.khee.wong@intel.com>; fugang.duan@nxp.com;
> Chuah, Kim Tatt <kim.tatt.chuah@intel.com>;
> netdev@vger.kernel.org; linux-stm32@st-md-
> mailman.stormreply.com; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; hkallweit1@gmail.com
> Subject: Re: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for
> stmmac
>=20
> On Mon, Apr 05, 2021 at 07:29:51PM +0800, Michael Sit Wei Hong
> wrote:
> > This patchset enables 2.5Gbps speed mode for stmmac.
> > Link speed mode is detected and configured at serdes power
> up sequence.
> > For 2.5G, we do not use SGMII in-band AN, we check the link
> speed mode
> > in the serdes and disable the in-band AN accordingly.
> >
> > Changes:
> > v1 -> v2
> >  patch 1/2
> >  -Remove MAC supported link speed masking
> >
> >  patch 2/2
> >  -Add supported link speed masking in the PCS
>=20
> So there still some confusion here.
>=20
> ------------            --------
> |MAC - PCS |---serdes---| PHY  |--- copper
> ------------            --------
>=20
>=20
> You have a MAC and an PCS in the stmmac IP block. That then has
> some
> sort of SERDES interface, running 1000BaseX, SGMII, SGMII
> overclocked
> at 2.5G or 25000BaseX. Connected to the SERDES you have a PHY
> which
> converts to copper, giving you 2500BaseT.
>=20
> You said earlier, that the PHY can only do 2500BaseT. So it should
> be
> the PHY driver which sets supported to 2500BaseT and no other
> speeds.
>=20
> You should think about when somebody uses this MAC with a
> different
> PHY, one that can do the full range of 10/half through to 2.5G
> full. What generally happens is that the PHY performs auto-neg to
> determine the link speed. For 10M-1G speeds the PHY will
> configure its
> SERDES interface to SGMII and phylink will ask the PCS to also be
> configured to SGMII. If the PHY negotiates 2500BaseT, it will
> configure its side of the SERDES to 2500BaseX or SGMII
> overclocked at
> 2.5G. Again, phylink will ask the PCS to match what the PHY is
> doing.
>=20
> So, where exactly is the limitation in your hardware? PCS or PHY?
The limitation in the hardware is at the PCS side where it is either runnin=
g
in SGMII 2.5G or SGMII 1G speeds.
When running on SGMII 2.5G speeds, we disable the in-band AN and use 2.5G s=
peed only
>=20
>      Andrew
