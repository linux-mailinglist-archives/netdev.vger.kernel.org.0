Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0A39B985
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFDNJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:09:59 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:54496
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230090AbhFDNJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 09:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibPwQxn8SzwwT9pRd3oVLX5m/Yozd6LN4wDmc1CKkGc5VUhymTLEl3CUXNSp2LrjjP5I4H4VkQGVazQjNrZiCsHHtnmeBhchmIiqfc0ukyAIONwk5ZLMPaa85a37pw8TmOZ2eeArfPsSCz7wLmnrAb0jp6+8TnmxwXURwJu8+wYmnGp30W9XAfozLI37CBTP+yXifyWA5Gu85a3MWA1RmUbe9gUv/yy/Q61K7ff+kICpHMP/vUHegnX81iaOJMl9/KbocGfaL940lu32F8UFQm6y5Nfat012OhOY5f2oByx8aUqj4snDr8NWTdCejm7znUcsE5xy8kTla+Mfzkd/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjccUIjr1dYN9PpJ8KLJw/ugZxYFw6zdxEahKzPqw/o=;
 b=SNqmYhmX2W+InFmMlNP7K+imHrUMiDHCBm/uylidwsXbcT9k/0nPTnvbqBn3elhYBivnqetuYQpvn9cRGkmy4Am3vrHKFOeouoqfAE/OqVe9UTytJNiMUVzQ48Crv3vs0pBdj0zWtwsNkJ6xsa5/qvxTFhV1/ybSNSiWINsIAUUZty9CixDZkZ7L6Tm5wYfjUrStQ63zh9ndqIkskZqmoqx9D2YnFdTf1nZLb6khRwR2XUO0kvslT+uPlkeJ4wsAeDIv7TFALyXDx3+HcZJwNru1F4ZMC7dJ271K2i31sV94Eh6stqzJ1HaDFDH5QYBIa9R3TrwwqcwI4NP8ktDOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjccUIjr1dYN9PpJ8KLJw/ugZxYFw6zdxEahKzPqw/o=;
 b=kecJz3BKG6eugcKlf3r0X26KujvsC33dZVJ9GPki+IQVdD2PBgLMGQpfdw6o0BgePtBKlZp0VVl4Zwq6g3HsE+vanGl94mjsF4koJ70uCCWzuCEz3m1QAY53NxFdt6OVzruqmmg3NsLff8nXx2Q2ZfLLweThC2mndhW0Ur6MCjA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 4 Jun
 2021 13:08:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 13:08:10 +0000
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
Subject: Re: [RESEND PATCH net-next v5 1/3] net: stmmac: split xPCS setup from
 mdio register
Thread-Topic: [RESEND PATCH net-next v5 1/3] net: stmmac: split xPCS setup
 from mdio register
Thread-Index: AQHXWTENJC5Z8so33US6hBvpd1LPX6sDvaOAgAAVT4A=
Date:   Fri, 4 Jun 2021 13:08:10 +0000
Message-ID: <20210604130809.lbyf2m7hvwi7xugu@skbuf>
References: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
 <20210604105733.31092-2-michael.wei.hong.sit@intel.com>
 <20210604115153.pux7qbrybs4ckg4j@skbuf>
In-Reply-To: <20210604115153.pux7qbrybs4ckg4j@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e90cb992-22fc-4229-6873-08d92759cd77
x-ms-traffictypediagnostic: VI1PR04MB3966:
x-microsoft-antispam-prvs: <VI1PR04MB396663770AE05EAD4D587698E03B9@VI1PR04MB3966.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdLYztjZVBxSiSRbuAMl9mjghv7+Cp53qlGSTgGWGBmLrYQy4e3S3m+5Hq7EniepLMG2s9XvPhs8Bn9eQ3VRtSNAfJKwuSWYFR85YIsIERe/n1NraGDKLZBQOA0OASnRjFJrvYfJa0TnmoSCrkIlMfPg24A8BHhkIxAJ3CN9txpIju9nkmrO5WoVUYp5JfETdf1QMHx6eCsZVgIbIFtO3arZP1tt78tRwUJ9ajKFBbhbEqhgrI9i3GbRdUO9Nfv+xOuqJMhiz+H/up3nsuRfLwnTXoN7XuJktkfKlEEO6INakil0Dt8+wAhDaH+fsVaqe1oKvMLCQZmI72KR0JivB9K52FX9w8ulDENEm/sVTtyM+DuMJpglfpdexfpoksA1trvy6bVjpTiDlk0KCAo/7rVY2dnqpcpbnhRmIcU/9+x4Z1z7HcUSWqwLCJjbO71q9EqymC+AmYl2638qOjzbtrFVwPWkw3nEkyi46qMqeBf1AOqWZGtwtCJkfWnzxSZt3+IoPeOhnmpZ7UksbceRcd5LEMK+sQlE/wAqJxqZhjU1NDnOZlkxcZqF8ZyWIKqIBoYKxVlGE1znD55qum9wnwE/5egcIuASXx8l4TnRAoceTPlS9NCYeQKCnxQC7Hu7i1nRL9V9vvpZ07jMtHKawrQtw/rrpaITXL9+TBXLX0ugI4lGDEt8I5jbFA3LOvbM/8UnaQpLjy3i97FXRhwSKCj9kN6qXf5TJCUKSr+gEWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(136003)(396003)(376002)(366004)(38100700002)(122000001)(6916009)(6486002)(316002)(7416002)(66946007)(91956017)(83380400001)(44832011)(8936002)(478600001)(8676002)(6512007)(5660300002)(966005)(4326008)(71200400001)(33716001)(26005)(66556008)(6506007)(1076003)(2906002)(66476007)(86362001)(66446008)(186003)(9686003)(54906003)(76116006)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?J1A7anD/coemw+DjoNEia8Bqmm/szvrsGEVKMUbipPIRsXH9arlZ8VrHfn/r?=
 =?us-ascii?Q?Wj0TmpasMtcQIqiSrC39GabycdLwtOH2DkRw2gqrQ5bn83yXEdtd4y+gOAeJ?=
 =?us-ascii?Q?S5/LApVo7FRJ0bQN8mrqeNsW4eDVnd1pPYJ2QFzwwf42htMPD+bXof4ZKADx?=
 =?us-ascii?Q?n8Q9Cu7qSKdM2z3WcYYZirZxrBc8WlvPbuotVkpOFejfdSyn1brlH+zd14ti?=
 =?us-ascii?Q?8C0CeLwDWAAYCTP+Hbl68xk2u3ushlDHWDUGbQZNPYacjjWb9UTB325erp9X?=
 =?us-ascii?Q?OjhwJIIEjXxtO/uKXWX9Gs5PsCdMMvGhOmzv1yzk2W3goEoOj+ffYHoKqV77?=
 =?us-ascii?Q?74md+uY5ap1o6r6mW+usU6c88fwaHtYySTSWdX9cMrWwcTag9r4rpaftCy+0?=
 =?us-ascii?Q?Af+ia63AnUU2pdTXBa9Qf1loGBkdI6hbDRhmPz+ift9hW9EvLvjG4ZDyipyO?=
 =?us-ascii?Q?mytW10zYQQ2B8i5LUhUNdBu1lo54eh+iIwmmIJ+6cNr8lxoLlCqsHf+f+sxG?=
 =?us-ascii?Q?LwgUQwDjvk9QEbxHEN4H7IXOOhQ97Jfz5bglsgaSBvwo/gjK1lZp24TJ9EP2?=
 =?us-ascii?Q?HJEzrWgtDMSSS6za3zKY4CI7vp+BhVhtNFkEUIwT9X8ZU2UwgPXyflU10o6H?=
 =?us-ascii?Q?Pw7Yu8bFwGf9vFPv/04LGEqRct5f3S8iOVaUPtA8eZIIQz/dpeb8JSvRnege?=
 =?us-ascii?Q?qb0h0arkPwgXfZrHpieJ7VvcoiuyjbhmPPfLcveiY5/MFPmNZj0vLAKA8TOy?=
 =?us-ascii?Q?St0KGIc45V8azLti8E9Jc/pC4jOEEvHSiechE5KIgOkmQokm2nEgQr/uHzBz?=
 =?us-ascii?Q?4oEbP4efugQjW7/Y17DCcRHNaxmWJHP1g+PD91c5oLPXJPzKZmDS/owShoWW?=
 =?us-ascii?Q?5AXaiOVzayyvHpO5g07J/GNReMLD6W3iNxgM6sXIAuUvY5CbEjQPMQJ6uNp1?=
 =?us-ascii?Q?bcqfee1TyhUqjLpRtFDa5CtPYCDsgUt6gdh6nHBZQCBzJK8/PuzhO/Eq8oEH?=
 =?us-ascii?Q?+M9PnruMIIPZWIhytNSbIbqWldF+qwtNPjogmIhTdX+lBh1I3XHUkZBjTaz0?=
 =?us-ascii?Q?XgZ7OxfsuJ8tVUORbaLtwPkJId8oijcTJEL3O/LU6EQHia9/LKJ0IiUnglNe?=
 =?us-ascii?Q?NJdUS0clR5DyVdF/dN7SxTgcRW44H1j51UCZCUteox25JzzYfMhBoHy+Fgju?=
 =?us-ascii?Q?VwTLD+Y9VCBxNmmpqlBYeqefllqeqg+GHUPKVfDo90j8DpXMEMD0yn9gvAvR?=
 =?us-ascii?Q?7yryu0M12AB4QCP2raCQ+BFsUQu9mfPLV+cTQWqt3hRR6fD/zn6K27ySylCx?=
 =?us-ascii?Q?mCxyr5KU+qevaah6JkV8RFJ6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15C0343D73FB754FA564ECC956DDAB8B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90cb992-22fc-4229-6873-08d92759cd77
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 13:08:10.1483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WeLmt+2UdZ7/dlvn9ct01GEm4HdzPwp8h4Iwxc5734H5cnPlNF9B0MygMHk6Fe/D+uP3zplp0wxzY6p0VSZ9Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 02:51:53PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 04, 2021 at 06:57:31PM +0800, Michael Sit Wei Hong wrote:
> > From: Voon Weifeng <weifeng.voon@intel.com>
> >=20
> > This patch is a preparation patch for the enabling of Intel mGbE 2.5Gbp=
s
> > link speed. The Intel mGbR link speed configuration (1G/2.5G) is depend=
s on
> > a mdio ADHOC register which can be configured in the bios menu.
> > As PHY interface might be different for 1G and 2.5G, the mdio bus need =
be
> > ready to check the link speed and select the PHY interface before probi=
ng
> > the xPCS.
> >=20
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++
> >  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 64 ++++++++++---------
> >  3 files changed, 43 insertions(+), 29 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net=
/ethernet/stmicro/stmmac/stmmac.h
> > index b6cd43eda7ac..fd7212afc543 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > @@ -311,6 +311,7 @@ enum stmmac_state {
> >  int stmmac_mdio_unregister(struct net_device *ndev);
> >  int stmmac_mdio_register(struct net_device *ndev);
> >  int stmmac_mdio_reset(struct mii_bus *mii);
> > +int stmmac_xpcs_setup(struct mii_bus *mii);
> >  void stmmac_set_ethtool_ops(struct net_device *netdev);
> > =20
> >  void stmmac_ptp_register(struct stmmac_priv *priv);
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/driver=
s/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 6d41dd6f9f7a..c1331c07623d 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -6991,6 +6991,12 @@ int stmmac_dvr_probe(struct device *device,
> >  		}
> >  	}
> > =20
> > +	if (priv->plat->mdio_bus_data->has_xpcs) {
>=20
> stmmac_mdio_register has:
>=20
> 	if (!mdio_bus_data)
> 		return 0;
>=20
> which suggests that some platforms might not populate priv->plat->mdio_bu=
s_data.
>=20
> Are you sure it is safe to go straight to dereferencing mdio_bus_data->ha=
s_xpcs
> in the common driver probe function?

This patch seems to agree with me:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D593f555fbc6091bbaec8dd2a38b47ee643412e61=
