Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A713884C1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhESC2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:28:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:15183 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhESC2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 22:28:38 -0400
IronPort-SDR: cWbROLAAY2Fe36BfQQYtIafWUy9/oOCKM62c2S4R96hidEG7VAQGgDclnrbo8FUDclL0y1CHAs
 PBBJ8LsLIotw==
X-IronPort-AV: E=McAfee;i="6200,9189,9988"; a="200565943"
X-IronPort-AV: E=Sophos;i="5.82,311,1613462400"; 
   d="scan'208";a="200565943"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 19:27:19 -0700
IronPort-SDR: rbL3kQZR1uynevmpi5klN6bFZqhRIj9jffrR0XEI/JhlUIhDrP2FiSGGnbt8aheo54aDFtYtXE
 4KzoShoIUk2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,311,1613462400"; 
   d="scan'208";a="405221785"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 18 May 2021 19:27:18 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 18 May 2021 19:27:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 18 May 2021 19:27:18 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 18 May 2021 19:27:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwFP/6MFl4OyYWJDt4prbjyawfs1WvYdNxX/mxd2Sx9vDB3EMsq5vyikhFGXJo+jpy1k67JlU65C9FYIoDhGWnLCMzkzEShgbQJ+DRVNy71bmxrHO93O762pixqBzVccTLbSSXSeVXNPFXUs7JrOmJqzowlcYXuu2ZOMS+c3uGTW53U2I081Lh55Ok5G/ZXaTpn/mNdaQaj2zMeudmCaz1SXHHy7EZ+XI+tpt3Eyn38JrlvoHK/jBpInP5qVhVa4yp4/2BHeOXVN2NSokx5W1Gru/GifILYiaw7vibNVI8saTwSMBMMqRtANKVnLGqlUtzUohykMed59KMhNNGlaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvQnukiStoPDfyfI3gtqtoZfUWBE3dtpmuc4R/Y4GFQ=;
 b=ND+gGRLmzA8s2hFbAr5k87yvEqAqM9DNR3h+BOzuB8ll2iZdtKpQkw4Q4gq8U3k52rDLfO9ak9eo8ovZydT/APVyp304h5ClsRLxq6HdfqDQYDsf8LSxgWHDxoEfr92L/kC9E4bTrlLdI/r9PmdFmNTYQbMMp9H+GHEXP4F4fMbyZoZN7xUr7T21WdMDSi7Z35VZ6ZwmjnMk8Z/gVJjFDFnyLRxaqbUsa9G5pHO+cNVw4neDT4lP2dY93fTg7y0nSNsgj0z3+ZUKLsh1Ag3DLbh13gQzgcRsDNb73ljAJ0QPHwjmeP+CyWsysDULJNcXXBGtcIug2ohgSPXvOEMzuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvQnukiStoPDfyfI3gtqtoZfUWBE3dtpmuc4R/Y4GFQ=;
 b=WgA2zs91FtLyfI1JBx2nDoZkEw0adnswONA6eDpUNzp3LvKZ2a23UrjppvGlM1vgcUZmeaseKtNht307Vbkw+OpnJIKVvDIRMcqWq5Tb7lszB5XLogluDXLt4qTMaQLmxSq0G2k57A8djbYmweNzy31W0jKIsNGuMp7t1sCLcuc=
Received: from CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5)
 by MWHPR11MB1709.namprd11.prod.outlook.com (2603:10b6:300:25::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 19 May
 2021 02:27:16 +0000
Received: from CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded]) by CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded%3]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 02:27:16 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: stmmac: Add callbacks for DWC xpcs
 Energy Efficient Ethernet
Thread-Topic: [PATCH net-next 2/2] net: stmmac: Add callbacks for DWC xpcs
 Energy Efficient Ethernet
Thread-Index: AQHXSwHXH3A7a02UTEaLpjsECGhB/Krnf/sAgAAJ7wCAAXsAgIABERPw
Date:   Wed, 19 May 2021 02:27:15 +0000
Message-ID: <CO1PR11MB5044577A1B810577AFB25D8E9D2B9@CO1PR11MB5044.namprd11.prod.outlook.com>
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
 <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
 <20210517105424.GP12395@shell.armlinux.org.uk>
 <CO1PR11MB50447EDBEB4835C3EB5B3C7A9D2D9@CO1PR11MB5044.namprd11.prod.outlook.com>
 <20210518100627.GT12395@shell.armlinux.org.uk>
In-Reply-To: <20210518100627.GT12395@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-originating-ip: [58.71.211.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8bdb11e-8845-4fb5-609b-08d91a6d9e79
x-ms-traffictypediagnostic: MWHPR11MB1709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB170947EB3BCE43AAA82BB0199D2B9@MWHPR11MB1709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Jn1BdGstg3oEtmOjx0qN2lPxtCbs/6NMeMVxDdlwXNT27Ef0zXYEOsqRLrkb9HqMLGlTZO/4+LbmRr7R3R+SZhr1xpAy16KD9cDcS14QS2JD8D/cC89UuWOv0DySIXzSOeFYqR8RcD5X6kbqv7XefLBAc3/dFlyiTqqo7isBQEtgx7RlVTUIVMKXPDzDSFMn3GtVG/VI6LDC2k6TkdBXXDPLWo+87+DMjxXZQWEBuoLVwOBRclUjAx3x3slLHh2ffdie/XrUebIc//WxCkAHbUajOZRxESDNqt9JDkopAgU/dQDRQ4j9vN9zjaraCxy2z4OV5CEiJ8LhKv3BzHLvmL/seLRzXxUxLStdY6qaUXilzij5pJ6P2Sq6uqCYTUmcd8knxQTDRU9mPlVC1pakdfj/WFtuVY5Ez6qYpunoH2RHTbWDl6o5qkLv0jhoTnIHYuDtKXc8DYMnEaSlpFGLWnP7CbiWiGligHb8o0UoKTX4bL2BrcL7VArIlwJx3AVYeaPaFX4t6u2VsyVoninDBF/TCppHFpF0Z1KkEqZxmEc51qt5kAGZeZ0BNfXuj6dVIjJ/TbFt1Zc1W7cYjRKwgWPQpZoxFJlxId18CqclMMZNAHuz+ko1OWV3Nv+yOwdsjYHnytbfwooTVfZo7dcUU3BWqDO06aW70T24vIUhNkYlAuE/SVuYH4DhvmKLd0z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(4326008)(7696005)(316002)(53546011)(6506007)(26005)(71200400001)(6916009)(7416002)(5660300002)(966005)(66556008)(66476007)(8936002)(38100700002)(66946007)(2906002)(52536014)(76116006)(64756008)(66446008)(478600001)(8676002)(83380400001)(86362001)(54906003)(33656002)(186003)(9686003)(55016002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IKlen469YmPKfY24dFLvc/CVFqrB85a6DKwNsTQ3tlcx8glKShq0bK4SFI1x?=
 =?us-ascii?Q?L+uYAy7gLeClVb0/LEInli72onIVD9oYHn191P2uGRnBdW4EC/AfSqNYuQep?=
 =?us-ascii?Q?7Uix4BN76tuqmF3Z2P6ULgaPb+rGVjoJO626jYpC7fE8TwWI0y6GYVCJtcO2?=
 =?us-ascii?Q?JWD3zDlXxqwT3FXzwhtEg6hYXRUzfw1f1kNqpk6xFPVip9/ZJkJI+Dsf4Fct?=
 =?us-ascii?Q?UIe8bxgPmi31cJcN1QpMT5d0iCKwpjL8O2EPZZ9R5amoL0DXrwkKJlbFpUMj?=
 =?us-ascii?Q?Oi5chEdC37qS9JBhwoHxA6eRHzr2KdmVbJqEzuhslPoh8+n0uvNzMtuforBX?=
 =?us-ascii?Q?yc0FSl3rpAQd2zmKt9Qd1pULALQhrkZIS1+QUiSfM46gLxgRfjtTnB2uwh0N?=
 =?us-ascii?Q?ktseDBu+Yhmu/J+kNB1FDIDuKmeio6J4pbF57b73clYttafp31XWcP09LGZ+?=
 =?us-ascii?Q?3UB/ZlOfYLqbMMpDCPQasY+mQi5eo2U/z9aMP6Bu/jBr1ez1XIbaeNocTJ10?=
 =?us-ascii?Q?AVX+qp8yoo6gUYvaC55yexXslS/UKWgd6M5TXeSZUrrRG70VfOyF3m5UZ9oH?=
 =?us-ascii?Q?c2i3lL9ay8wBkxP0EDntz7a05YL+2V9rDB0X1jljvVV5R6tzYFmNCfs+W1cL?=
 =?us-ascii?Q?/rUXU/3BLlqba3IL39/ml27nDC+Fzpwzxiaqp2j6MHAHUIRc7B338iRLYvrx?=
 =?us-ascii?Q?mzi39QA2UWRgYcPMf9ETg18tAilDHCYKJhsQK4ml20lnIKamBNtpE1CqZkz9?=
 =?us-ascii?Q?g1uBOj2G69vFT2JfgPZ5zov+H2nPd2hLVU/DIMlV5xFzrzx9hmdvIEmG9XBf?=
 =?us-ascii?Q?OhzuAeou1AFFU02oQRLnaKkk5gT344JGPQaqPapJysEVaYMS8fU5qFY2H/TG?=
 =?us-ascii?Q?MTnU5//MYEun9o2+cfM+gYt+DcnxMAG4xEgt5Xj622YD2Ujc6FwRIvVtj1rc?=
 =?us-ascii?Q?rts7yrYAHRPOlFLO0QkKygP1VxwLMoFi3m54PyFF6D9yO3UWNp3togkvd1JK?=
 =?us-ascii?Q?7RKC2BSnlqdqD9N4Abm9q1Ba43oddAEOdgVRhK+Rh7Lp8rXnWafYpVthV3qf?=
 =?us-ascii?Q?6OjLK7kogx5HIm/HqZbF0RpnR9PTMWZcx6rfphOY3FwOpxw6rbozHQUzRR2m?=
 =?us-ascii?Q?GCruR79rwAwWvCSKQ2VYuDy5tXIe16kbjvTt8aTcan95KezZ339BkfIPgl4c?=
 =?us-ascii?Q?V7ebzY8IdyLrZuPQAgY5/9LhFNNVGO5HjU0ToubP9qukgfAgMlNCWIO4uZfu?=
 =?us-ascii?Q?qq6HMz4VLKwG9us+3duDfqUWCTIWvfqU/dl1aE0zx8PzQXfZiOLiD94MVHTX?=
 =?us-ascii?Q?fUiHnortniVeUQEcoYU/b/cl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8bdb11e-8845-4fb5-609b-08d91a6d9e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 02:27:16.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DmNC21fHiu7LjJ9TM9Ip+Xn5VESGLkuglVLtJ19fhnHH5RcTevF1NmofWQ3bRuX4xj5umY4SN1o9OaInlOTrT9vcU8OcPw5iwvGFAkt3ND4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Tuesday, 18 May, 2021 6:06 PM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Jose.Abreu@synopsys.com; andrew@lunn.ch;
> hkallweit1@gmail.com; kuba@kernel.org;
> netdev@vger.kernel.org; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; davem@davemloft.net;
> mcoquelin.stm32@gmail.com; Voon, Weifeng
> <weifeng.voon@intel.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Tan, Tee Min
> <tee.min.tan@intel.com>; vee.khee.wong@linux.intel.com;
> Wong, Vee Khee <vee.khee.wong@intel.com>; linux-stm32@st-
> md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 2/2] net: stmmac: Add callbacks for
> DWC xpcs Energy Efficient Ethernet
>=20
> On Mon, May 17, 2021 at 11:37:12AM +0000, Sit, Michael Wei
> Hong wrote:
> > > From: Russell King <linux@armlinux.org.uk>
> > >
> > > On Mon, May 17, 2021 at 05:43:32PM +0800, Michael Sit Wei
> Hong
> > > wrote:
> > > > Link xpcs callback functions for MAC to configure the xpcs
> EEE
> > > feature.
> > > >
> > > > The clk_eee frequency is used to calculate the
> > > MULT_FACT_100NS. This
> > > > is to adjust the clock tic closer to 100ns.
> > > >
> > > > Signed-off-by: Michael Sit Wei Hong
> > > <michael.wei.hong.sit@intel.com>
> > >
> > > What is the initial state of the EEE configuration before the
> first
> > > call to stmmac_ethtool_op_set_eee()? Does it reflect the
> default EEE
> > > settings?
> >
> > The register values before the first call are the default reset
> values
> > in the registers. The reset values assumes the clk_eee_i time
> period
> > is 10ns, Hence, the reset value is set to 9.
> > According to the register description, This value should be
> programmed
> > such that the clk_eee_i_time_period * (MULT_FACT_100NS + 1)
> should be
> > within 80 ns to 120 ns.
> >
> > Since we are using a fixed 19.2MHz clk_eee, which is 52ns, we
> are
> > setting the value to 1.
>=20
> Does that hardware default configuration match what is returned
> by ethtool --show-eee ?

May I know what is the hardware default configuration that is expected
to be returned by ethtool --show-eee?
The MULT_FACT_100NS value is an internal register setting not meant
to be exposed to userspace, and only relevant when EEE is enabled.
>=20
> --
> RMK's Patch system:
> https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at
> last!
