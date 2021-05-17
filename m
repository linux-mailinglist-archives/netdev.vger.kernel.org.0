Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CAE382B3C
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhEQLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:38:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236750AbhEQLib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 07:38:31 -0400
IronPort-SDR: UnktAeyR7h9K+Jn6zcMIh43KXgjiRql9nyaH9X/giiQerSCkCDUPbPvTrDsge9K9lytVWwIW/D
 OCC1tFNeeC3g==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="198491705"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="198491705"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 04:37:15 -0700
IronPort-SDR: KHT6XX4smt61aMVYjjhs2K7MvXwitqjL0aJ59auW/Lnu+EWgJevX51/etahFgEJ5WCWSZ3UfiA
 ZiAXHrqxfcbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="437725101"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 17 May 2021 04:37:15 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 17 May 2021 04:37:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 17 May 2021 04:37:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 17 May 2021 04:37:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpJ/56FubimFI+goXV3NDZB9wIojdY/KdTbERvQiGrFGBdKLHF+TVCBLcp6RWRm9+54on84wiFJ1PPcELDAlal/61QP80VY7H3wz4ufRClYAc5aIiWHm/8xGcfpb1pEJ0qrx/5zLFdsmZqkCiPyGO5LBBL4vNRuJARlRiYC4pAt0SiHll1mxx6QV/299YXqMx4YWlGi+5ZgOg8ysUEyGoqq8xTTQiw+1zV/8sgKYOoi8aZGt2jbcY51668tfYC8amGaB4LtE/QopJFEuMg7ZOsKp6hXMuY2NSeyWYAWvivLmwx3w5FnzCQUOddS4r9nPQ97XO21bI06VVHR6RzUijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Uqgc9MI2B0bikz+IStP0VQcm2e9rEisyL2fNGMMHTo=;
 b=WM3ct2eDg4Y2kST0QQEnNbip0sKjzzfb4gtkcaWeSjY2h1P9hNM61cjTqrqVyf1/4qHATtQbLmpl1WxLFdBgbCr1OL+yZMoXsjWr9dYeZYMREiA0Jwr6N6nky+oR69yeC8vNBMPliJUmZB79umagfjdBqesZa7r9PQJubH4VmDU53qGbJWXJqNCgF4OdGFc+dWacpb0JuabgSBO4Hfn3hKuq7Rhgr0+Xl3f4O/5FMsoqpLQAcz81aYfl6wpXesS3au7ZSs3SFeXkLMSG2CRfxi1RHnoxmduBXfi4s5Xnv6XczugHSNdwxc/UJlSN23Wzaf/T8r8+oMppQFEzCntJAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Uqgc9MI2B0bikz+IStP0VQcm2e9rEisyL2fNGMMHTo=;
 b=ZiDj2HSvkV5peFLz8o2TNza/qp9y+/Jf90bSRzSLOA6qzbYv9GAjZCYP4/U0aOJRIXjnQL8wmPgqb/HUA9OBQyMCFhDJIv4hqFLogYIljkB5GYgRca3yK0eTMATxvjNwjKWEJONFgrOTKkdrCNS/9u+7rR0bTF/1x2AKp6O3rYI=
Received: from CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5)
 by MWHPR1101MB2303.namprd11.prod.outlook.com (2603:10b6:301:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 11:37:12 +0000
Received: from CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded]) by CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded%3]) with mapi id 15.20.4129.026; Mon, 17 May 2021
 11:37:12 +0000
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
Thread-Index: AQHXSwHXH3A7a02UTEaLpjsECGhB/Krnf/sAgAAJ7wA=
Date:   Mon, 17 May 2021 11:37:12 +0000
Message-ID: <CO1PR11MB50447EDBEB4835C3EB5B3C7A9D2D9@CO1PR11MB5044.namprd11.prod.outlook.com>
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
 <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
 <20210517105424.GP12395@shell.armlinux.org.uk>
In-Reply-To: <20210517105424.GP12395@shell.armlinux.org.uk>
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
x-ms-office365-filtering-correlation-id: 24763109-613d-46cb-8ad7-08d919281ce6
x-ms-traffictypediagnostic: MWHPR1101MB2303:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2303A56EF97752811AFC4EBD9D2D9@MWHPR1101MB2303.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2glABWT6alksbbhngclqUIZmRmKNDYasyQ81T0BOmy4ABXnMiZ3cLl/GCMdCve7MTJUMElpEBSrMLpHqHHmetvGPW7qzSPnsmfxkgws/GjdCxdJEKBfWl9lDtargKnLH/cAPjfDsjiBPFtOtqKIDq9cRZWP8ynkFph6jw2POSpdrReb7WxcdbeiRSMA5eiRHZQHIRzO83jCsTfLPCR/W4cZhVmIZjan6UbxrbGlLYTHUJ9gu54DT/vfNhgIasBH3+zDMwS+Az0TqltXcDgKU/kVLHaJIuX6FXOQFZKvxPNd8HB+hDwJxAiwVf6I5igyufA7S98s7d2Hqa2DZk9juFSadP+OShKN1vsfIZ0h0UcHE88ITVV8UNiXa6g8KVDEuUnzt7apmrj/pHL654miiICJudKcLOURrbZAmK/8/biBaCJir1WVIUG4xjc9DBSt6DMmqleuc3AGH9tu3LXZ8+LzbZ27vWhTO+xiYDanu/rcxsvBFYXS2+iHT/ORCacACzgUTGGzCMDvhUEmKxL45Cgy9Kx+C/AkUvy7yytNmR+r+AwGpuu+pfvfOhT1wDy5yWQ5cPucKXtYOhxkNAmjjCRMFSI8DR2Sus1OeJrt+L+ZMRNGO4hSBz9Zb2SSNJH+1ivpcnng3bHHu6b6XLXNZz/zoVZjfhUC4GrE8bZBcFmvB87D3ATClRExqV03hoewQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(376002)(39860400002)(33656002)(186003)(66556008)(71200400001)(64756008)(66476007)(66446008)(478600001)(7416002)(5660300002)(9686003)(66946007)(26005)(52536014)(53546011)(316002)(6506007)(8676002)(55016002)(83380400001)(6916009)(54906003)(38100700002)(86362001)(122000001)(2906002)(8936002)(7696005)(4326008)(966005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fBUG4Z7ezVMs2yyydyg+8RXvVORjdtaI2AvgAn/ZqW5rqGvECCtLoINu6U8K?=
 =?us-ascii?Q?6Gmi7mY1QbvKMcenoYxCNU3NpEBm5xe+8/xiLeknOmF8T7h6ZVa0lV8ATT2S?=
 =?us-ascii?Q?vf3Q0BShJtBG2FJ9OGFFFqggxVLjq97KuHwOu7D9yWqDRBMUHg+gR1ZMzSAZ?=
 =?us-ascii?Q?vz6mIYEICR1imEzORzPCCcZ/HorPLrQ0aTHza14PKOnL7jvrA18IunB797U1?=
 =?us-ascii?Q?wegFLm2I2CZausb0hG6jXF/j1PH4BwLb7PWjwGcItjPtn6kFBbZ9bmw+rw2w?=
 =?us-ascii?Q?RpwnH0GWW0UdGyql3EpOggBV5F0Ev+pG19tTxrtEb3b0aEZGfIXCYnzPQpS9?=
 =?us-ascii?Q?9Jt8q7yVhcSAQsfdLu55qaYqzZjqjJoqE8jAip64CTmKYVAhheIcUMEYg4bK?=
 =?us-ascii?Q?EMPlAZb3yIwBF4BIYpJN2WMHaOgVOe2WKIbhvpKq2Zf1U5fxkj4LZu5eUEKX?=
 =?us-ascii?Q?MCMxb+eGxiySozmrEtjO+/UIgdqlbe8KSr16TpOvaSxZduKOe8A+SAVCYK9I?=
 =?us-ascii?Q?kWaFD1pcOJ7tlQqVWbdAe96twRXPMg8EpKV8KsO0pMjhb058/WazLTCWjCvq?=
 =?us-ascii?Q?agKatWWCKy1nODcwqs3cCdx1UrgKqfH22bUarUrxEjkIZMlpeBaW8MnTA7IS?=
 =?us-ascii?Q?CHSdqRSyYBtGnzFzokSTR2yeuDkAw+1A7bZTRqW9Ml+VixZCV4I03FLNDPk5?=
 =?us-ascii?Q?AljBvYwhMavypWnQHvOFhVc+rvlxvXL9YDzsj4J20G8iqHo3G5RREAdAc8J6?=
 =?us-ascii?Q?8zMR7upOZ0M1Qp27zEA1j/+97f3PbuDjdFogtL4oed2F0sPp/druyFooEXn3?=
 =?us-ascii?Q?9V5wTUfclUFcT7ih8COBiYRmyMM+eLcmOYWaZ0T9eAFd8Yg9v+SlF1n8YqX2?=
 =?us-ascii?Q?BGgRPZFPWa+AQ+wM26PS+xrJD2Qkq6In3fyuosvrgA1HHGa6e8qNTAuqT+hw?=
 =?us-ascii?Q?A3x4VpbtrsWpSiFMtLrLgsUNuZ/uaKTqsfV3nevnOgO2RL+f406DTO8yslTA?=
 =?us-ascii?Q?j/tfKOLEWVDpRaM2+qkNiB/m7G9/p7HeKVljtKeDzIPZHJ2K+ondiUBV042T?=
 =?us-ascii?Q?RxMqlsqfmYzkW6UOvI8NiQH7kHqnKzYcTlnRF8VR637PnEPpQrh+B7Pu8MWi?=
 =?us-ascii?Q?Wce1IiBmzuZStGWQLLc1DoZXCXR+hY9sgNQ6TbjmaEC7n7yxMDXFG/LIHpyu?=
 =?us-ascii?Q?kmbUYZv03NQtLTduB/Z1ZzlaDQH/c41vHd/rxNdgpka6EuKxluRSCGcgrcOV?=
 =?us-ascii?Q?/CDYSM7AJCBe8nCvJMzBc4PkAmP1gU3XDQ6j3EE/93XtjquLZAh+ZoiF6foi?=
 =?us-ascii?Q?Iykmdg7ahKtyzeAsYNFoP7sX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24763109-613d-46cb-8ad7-08d919281ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 11:37:12.2967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ezo92cigUxkYLhztuARwj3EpJhJe5VQU5IXJW5Pz5kpb30tOghHi3+JjNLodWvvHnAbAx3aihzFoFuCvsJDpmBtNmM9vbzCyQLNyNw/ahYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2303
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Monday, 17 May, 2021 6:54 PM
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
> On Mon, May 17, 2021 at 05:43:32PM +0800, Michael Sit Wei Hong
> wrote:
> > Link xpcs callback functions for MAC to configure the xpcs EEE
> feature.
> >
> > The clk_eee frequency is used to calculate the
> MULT_FACT_100NS. This
> > is to adjust the clock tic closer to 100ns.
> >
> > Signed-off-by: Michael Sit Wei Hong
> <michael.wei.hong.sit@intel.com>
>=20
> What is the initial state of the EEE configuration before the first
> call to stmmac_ethtool_op_set_eee()? Does it reflect the default
> EEE settings?

The register values before the first call are the default reset values in
the registers. The reset values assumes the clk_eee_i time period is 10ns,
Hence, the reset value is set to 9.
According to the register description,
This value should be programmed such that the
clk_eee_i_time_period * (MULT_FACT_100NS + 1) should be
within 80 ns to 120 ns.

Since we are using a fixed 19.2MHz clk_eee, which is 52ns,
we are setting the value to 1.
>=20
> --
> RMK's Patch system:
> https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at
> last!
