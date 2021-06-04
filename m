Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4411639B8A5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFDMEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:04:37 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:14050
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229740AbhFDMEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 08:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cekhmQhppZhUBYc+DrgQBIUi7bnEFZVBdkUOfrhu4vRTU70NV96HTr7W1bYGU3Gk6Lq3lY9tsQfI3Rt405UyarorR6zZqK/giVxbfed62EjEY2ZcFfOxzhO9g0jvxUNvDzMUi/mY1Y0L7adkwPz7ivr4GYrF9SQLlpHfmtgnRidc7eY8q5R8AgdLJu5269ulgVXuYxVYoUNE9493o05ON0lHw1DweSsceKXoXb8PwhygFibhoeekUboRs0UpUilepwwqsZ1by4EMS8Mueeq4avJAeMeIq6zODkAOLJwmetzXfP8KUCoHNOA4bELvo3gBa2LqZZ/kbh+FHAJHEZYxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56bSY7gv/NBz2FASGI2CQurUt1zWkZJwGBKLzdyMyoM=;
 b=mE8IsEwxSx00HIU98rcTmYWMdrdboHXm2l1e3Zdis0Mij0oJw7eLDcvxKuUadh55yz8/UJ3dSyUnJAbt0y36vJmGQt8tLtxO5Fr1FrH30Sgpt9CxUsjTrjAyd3clvSzEma7UczAieY5g6ATfpKiLSYTM/T0DJVQdEybxooRQL2a7DPliV+aXUGIjL2JRYXS61NJ9YtJm96Fea3R7M6Lg0jL3yh1h1tY4Rmb6Kp1hx+7nroS6f4l46hTDLrmlAw3R6E+A0y52FDJkgICeLPkQrADIwwOs6mr3SJjSigCCimzlxk0LWMPjKuIjCH6G+6sw/Oqq6ldB6lyRFNlN5Yn6Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56bSY7gv/NBz2FASGI2CQurUt1zWkZJwGBKLzdyMyoM=;
 b=kj5Oq0Ngjd8VmeCwSRczblP6d4DlPpg7ijn3EXY15gVrwYPWrOX6pIgm3tGqUiTVSzSwsCimj3fq4XmZNb1XyPacHIc7vb1Hf71JJhKYFwNrmU9UkoNeN3c3jBxdfFQY0ZBgftYfLX+Zn6ELIZhX5LQUGeSd/ymq0JR7DdyxxhY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 4 Jun
 2021 12:02:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:02:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "tee.min.tan@intel.com" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "vee.khee.wong@intel.com" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH net-next v5 3/3] net: stmmac: enable Intel mGbE
 2.5Gbps link speed
Thread-Topic: [RESEND PATCH net-next v5 3/3] net: stmmac: enable Intel mGbE
 2.5Gbps link speed
Thread-Index: AQHXWTET3T5a2O/zYUCUCpJQSG2BQasDwK6A
Date:   Fri, 4 Jun 2021 12:02:48 +0000
Message-ID: <20210604120247.gzrjocyw5ivtdhrd@skbuf>
References: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
 <20210604105733.31092-4-michael.wei.hong.sit@intel.com>
In-Reply-To: <20210604105733.31092-4-michael.wei.hong.sit@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce02f6d4-4597-48e6-cc81-08d92750ac01
x-ms-traffictypediagnostic: VI1PR04MB5295:
x-microsoft-antispam-prvs: <VI1PR04MB52956DE58791837CBA5C4F58E03B9@VI1PR04MB5295.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3xu/Y5q6mc8SCISXPed7bEY29kH1wXpP0wx7moAP5Xpd4mMTqwJIyvvphgrdKc4CHyaPZo+zaSYr8Avz5iI4oaIF2Z/JpY7P94otnD37RN2GqGNw2RK1MbJlY9ly/vDqAuRSpTvAlAFB6YmWzDq74PVM1GS+fWUwZFUMDDcfTJNw4jwqyIJkTgBB7BBUWcQ2LNQUag/ifqdeidZrQXXflHIAoNHDaN7EobQeWbN9LgZdZzC1mCbPHYOjz6MTvio/p+ic1Mh02ad36Maa0U9PFdfcucYvQL7MiUXnk2TSbNNwWX/xh3bY+KMuJOhulW7EXfdRJnYBKkRjfckM1R29uRYfCq5Lu5UeOFJWc44Qp4inM2NrjFpm9tyjoFinNX0Is1vSDFmjNzQeASx3jSWqxoVNBHByVNqx3uxfje9y6ttJHNxM7tSPNUtGN3ztfKG+VL/0LwgYkIvlQUY3aq/+Y7Wl4ySxyOje9aOkzoAFq0rJ1CXe/7VVtTMBKGgh6YLNmxrFBRztN7nqqFSpesZjA+BteOVqptB9dTor/bOk15EaRGagXK4psa+LKZq6kb9Hqu3DIZZyhaU+K4s6dwjYVyVTLqrWXYEwEdMH7cDPCho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(7916004)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(38100700002)(6916009)(26005)(4326008)(2906002)(186003)(66556008)(71200400001)(8676002)(33716001)(7416002)(66446008)(8936002)(66476007)(66946007)(86362001)(478600001)(316002)(5660300002)(122000001)(76116006)(6512007)(9686003)(54906003)(44832011)(83380400001)(1076003)(64756008)(6486002)(91956017)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IpjlP/zzX4q7pbKW5WgpudJX6wMe/GuVytIGMBAEiz6jVjDzRpq40a+c2dwz?=
 =?us-ascii?Q?28qKihivU1M4++l9pQHRB1NM1zwH7Vt+xUeOaLs2oUpUyf1g6rXOIdlYInjN?=
 =?us-ascii?Q?7GJaTIEDNY8whtzXSyzX92oTavKIcOOZhuZEKPTwDsWvivkR5HX2RV9gC3Cs?=
 =?us-ascii?Q?+/MEkOHIN0yPFTKmvnr62FnlMGtUs4uctZTFkrM2AkBlXAe1VZpqx3/tyzoA?=
 =?us-ascii?Q?Wtp673vaJglpN7W5rnW5LT2KBjJ9foubdPrj592vvAb3UGGdja1QK7YUWWus?=
 =?us-ascii?Q?mvpmSDv/oFq5KQzLj1ih9sgxgtBFCCdELbQdyhGLKw5ooAW6Z/b09jhahxNj?=
 =?us-ascii?Q?/q1/uOk8rTv88GiXjxmFpGDfZDLqXelN2oCTCXpAGAV1pAsb+DBuUYuiQARt?=
 =?us-ascii?Q?kYemPqXlFKKN1qzoOXnF+jwUU/gcJb6rwnARR38ev72mwwhd59cvsn2sxLVF?=
 =?us-ascii?Q?h5gnN462DIheBqOAS9/HiLybTPCNT4pD8MDrCkqnrPpNydkODI/UjZ78Xyat?=
 =?us-ascii?Q?HFsNqpPTlJgDf+Z6gFE1tMbaHxE8PdsxSF38wYpT9DjTSgswM1Gfos6mpAas?=
 =?us-ascii?Q?hVrCGQuBWJKGcdDlfp2Y5CCEllR6NdxS0eGTMsNyTMVW+VqBFLpBiVqXn50Y?=
 =?us-ascii?Q?M6nQJif7sMYCSEPXdSJYuE8VQdqAvuWlSquwX58jIIQyaA7rbdqqRvk3JHhY?=
 =?us-ascii?Q?ymOUNNo9LHf40Ya4Upv7JSi80DgjQwAjjoBdqIS9OtH6RcRDsaz9/xowR8uE?=
 =?us-ascii?Q?Q06d1F8xpPCHyedS8ecQLYckus56Cjk6VrZ5qSLCvaRvghE2EnLKoV0/sFNS?=
 =?us-ascii?Q?52W1EvLlRg3RYUek2/jyNaHTY86Gz5yPHblefw/CFuawYJEOWcJiKkW6frMv?=
 =?us-ascii?Q?KjuUtt4/riI2KWu0u9gvTquUbVqiOaJ2ihMR3ZN2QrRpqgTVcOewF/fUGt27?=
 =?us-ascii?Q?tPcjN03VWHvmGjrQvatFwYJ7Yn2D4MNGcPp81J12xFeClcB7Ba3ww4nT3ncl?=
 =?us-ascii?Q?Oa9gqtuAkLtXSDJ3Bcl1cLbEOb13m9G8/d8ECL28gVDBb+nOqS6VAwqh0bzr?=
 =?us-ascii?Q?9vGPwXi/ZTS7k1hVUfQ6qAa/qIX2SzfgJxvUOJKUqRPy4mPBoLZRL5tfdbZq?=
 =?us-ascii?Q?DjnQvzWJ3ERLzthwBdRcKxIoUoNGZqCzKL1mjMRPrcA8jW6OXUROr0I1taKl?=
 =?us-ascii?Q?rrMu9SD1s1RB5lfaeA3CRSVkvsyNDQ0fG3GwV40biPY1K/TjEYzuqAeuIOHu?=
 =?us-ascii?Q?VGFRlMRSHU1E8uzTVT/7f3weIAtfPoqzoSWMqN9F+rTayBsMXmwbdZn6JzOm?=
 =?us-ascii?Q?xGoeX6A8ODvQUd6wcZril8E/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6178CAFED11714AA26A12D81417D74D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce02f6d4-4597-48e6-cc81-08d92750ac01
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:02:48.5022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++WLaasBLebhXCie7P4hv2ZgxZfAIz63Ei14fHfPMK4KA59GK3UOEHyG2NwgN+MVxQRdFqVzh5va7Tv9QF6ypQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 06:57:33PM +0800, Michael Sit Wei Hong wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
>=20
> The Intel mGbE supports 2.5Gbps link speed by increasing the clock rate b=
y
> 2.5 times of the original rate. In this mode, the serdes/PHY operates at =
a
> serial baud rate of 3.125 Gbps and the PCS data path and GMII interface o=
f
> the MAC operate at 312.5 MHz instead of 125 MHz.
>=20
> For Intel mGbE, the overclocking of 2.5 times clock rate to support 2.5G =
is
> only able to be configured in the BIOS during boot time. Kernel driver ha=
s
> no access to modify the clock rate for 1Gbps/2.5G mode. The way to
> determined the current 1G/2.5G mode is by reading a dedicated adhoc
> register through mdio bus. In short, after the system boot up, it is eith=
er
> in 1G mode or 2.5G mode which not able to be changed on the fly.
>=20
> Compared to 1G mode, the 2.5G mode selects the 2500BASEX as PHY interface=
 and
> disables the xpcs_an_inband. This is to cater for some PHYs that only
> supports 2500BASEX PHY interface with no autonegotiation.
>=20
> v2: remove MAC supported link speed masking
> v3: Restructure  to introduce intel_speed_mode_2500() to read serdes regi=
sters
>     for max speed supported and select the appropritate configuration.
>     Use max_speed to determine the supported link speed mask.
>=20
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
