Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197F6E0399
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfJVMIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:08:50 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:15622
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388392AbfJVMIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:08:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+S0BmaqxmsIjPbmShV12qKDOnTcmue2yD8WGI1ZzkJxkjJZO5Gta99DOfVZ319mbi3V2linrVmAQIuwM5nopNg1QDOGLFQcfrfFV7ZbDgYKhkp9c7cpOizOSSIkAwFpRCJEucKBWFpvg9kTFeKvmVwp8w1c/hjdT9kwRADyh8cIo5yT97fIsksT+PNPvt6m2asJsOmdaWv2NwHIkMml9o7D7J0Z9TvmqOuvHjjcTgTFZSUTXQygnJ4EWsMxuMoLGo9c05sqA/JFbASdI8LRzAmrRxugh8YyrcWAsNMvyJGBQOeVo6SWpiukof0xPTmoT/WLL1fDriRnsT+lrim4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Qp4sSwssIE8aaRtulPPTAWcF2ED4RDU3UtGOYBKAbY=;
 b=eMziBMDyUPEIb6q4IFSq3D7xsEaJH8wfUGZwi0V//1NCkgMjG43XMYxlJIbsZQ9xZX+LK3JkfjlZcN0KfNktCMDLCv2PRmwx2YUQCJW6C2qo50U5UH8JQQtwxlHLYtnesasAIPy4BBebm67hmAH8gjb9D0J4mKNUIHZHG3KfyFh4VkWWmgaUBUSPm0MTl7hR5ME6ZcrvMGC5FGwn9ndswgq8fC9D0ssi1yaz3zI0va4iBz9bo+ZrXH7W72cMwe6/XO649CedDOe5oPiQ607puOSZgbGJ1dqwdyNRqY5S7Xs2+UhjOn3YCF4g3qzXb4qEheWddcPtnvpz2lyowG5lnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Qp4sSwssIE8aaRtulPPTAWcF2ED4RDU3UtGOYBKAbY=;
 b=hHFAcpghoqszHt/fAs+X089AVoh/5DLAhjxEzGU0nDQZFOG8JpN/9Ub2ovlnjguGu9bIRuaSJAUiaxTNQJr2GeJo9+jaw7RK06VAa5JyNiGbVZDlKxUSg8lmsh0bdQdb8Lye0IP7SuIjgQn24EgYQh9mZZwefodtACnZmL5znq0=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3598.eurprd04.prod.outlook.com (52.134.5.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 12:08:44 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.022; Tue, 22 Oct
 2019 12:08:44 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rmk@armlinux.org.uk" <rmk@armlinux.org.uk>
Subject: RE: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Topic: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Index: AQHViGH4/x1MeFbNhEKBEYDO4/J2jadl2TKAgACzF0A=
Date:   Tue, 22 Oct 2019 12:08:44 +0000
Message-ID: <VI1PR0402MB2800B0719A49C80B4D78C8A5E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
 <20191022010649.GI16084@lunn.ch>
In-Reply-To: <20191022010649.GI16084@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 324cc9f6-1004-4244-b065-08d756e895f3
x-ms-traffictypediagnostic: VI1PR0402MB3598:|VI1PR0402MB3598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB35987A4A77737EC92A662FBAE0680@VI1PR0402MB3598.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(199004)(189003)(6116002)(305945005)(7736002)(74316002)(4326008)(3846002)(6246003)(76176011)(71190400001)(99286004)(54906003)(71200400001)(316002)(7696005)(229853002)(55016002)(9686003)(6436002)(2906002)(33656002)(81156014)(478600001)(6916009)(81166006)(8676002)(8936002)(14454004)(11346002)(446003)(476003)(86362001)(52536014)(5660300002)(6506007)(102836004)(26005)(14444005)(256004)(486006)(76116006)(66476007)(64756008)(66066001)(44832011)(66446008)(66946007)(25786009)(66556008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3598;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lF/5q+X5qOO+g3Z8hvy4h+DbkEvOKYlSDspytDX3SVhi/Ungu0r98/sd7q8Du19UMVO0Jur66NCKbRTG06O13g0PfODw6EA0n84HEQadCzzAz0Cv5A9yDSGT0Z8JkeNFN6dLbavTGVPMcGM4tYVHZoPncNG6JrjHGFdoqNU2lDaDZuL125OO9Z3mXa2kKJTBiAbddIrW7lm2biyha3S384vWNqEfJtQY8sOqB9jAKcZvS66Yrxsk2GcMvdFCA+Ij5ltreOSnDzncpPb4jbcmVNuKIh+pNbiTjD0PLKxXZLD+uoBFTfc3+s88OxDN/LFJCFKdtSP8Hy+xNwgXdeDdnzuz6APz8YpI38z6ecccUHhuWrwzQrtr1CkVifrcHlaw8oiJqfAarpZbSmZZNZw1Fwn4oRpRTvl6N1Xk0N2pn0U2Tjvx8sTBJ+HF2/2xINQI
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324cc9f6-1004-4244-b065-08d756e895f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 12:08:44.3192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ReTzBzKElQtMh549/BWdBA2fxR1mO6o7/uZTLIfzfynh11ziQREcT5YY2d6NEJjGaqdI8Y1JagJKSNXJbFukqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Ioana
>=20

Hi Andrew

> > +static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv) {
> > +	struct fsl_mc_device *dpni_dev, *dpmac_dev;
> > +	struct dpaa2_mac *mac;
> > +	int err;
> > +
> > +	dpni_dev =3D to_fsl_mc_device(priv->net_dev->dev.parent);
> > +	dpmac_dev =3D fsl_mc_get_endpoint(dpni_dev);
> > +	if (!dpmac_dev || dpmac_dev->dev.type !=3D
> &fsl_mc_bus_dpmac_type)
> > +		return 0;
> > +
> > +	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
> > +		return 0;
> > +
> > +	mac =3D kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
> > +	if (!mac)
> > +		return -ENOMEM;
> > +
> > +	mac->mc_dev =3D dpmac_dev;
> > +	mac->mc_io =3D priv->mc_io;
> > +	mac->net_dev =3D priv->net_dev;
> > +
> > +	err =3D dpaa2_mac_connect(mac);
> > +	if (err) {
> > +		netdev_err(priv->net_dev, "Error connecting to the MAC
> endpoint\n");
> > +		kfree(mac);
> > +		return err;
> > +	}
> > +	priv->mac =3D mac;
> > +
> > +	return 0;
> > +}
> > +
> > +static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv) {
> > +	if (!priv->mac)
> > +		return;
> > +
> > +	rtnl_lock();
> > +	dpaa2_mac_disconnect(priv->mac);
> > +	kfree(priv->mac);
> > +	priv->mac =3D NULL;
> > +	rtnl_unlock();
> > +}
>=20
> dpaa2_eth_connect_mac() does not take the rtnl lock.
> dpaa2_eth_disconnect_mac() does. This asymmetry makes me think
> something is wrong. But it could be correct....

It seems that phylink_of_phy_connect() does not do an ASSERT_RTNL() as phyl=
ink_disconnect_phy() does and that is why I didn't catch this.

Should I submit a patch adding the assert in phylink_of_phy_connect() and  =
phylink_of_phy_connect() ?
Also, I'll fix the asymmetry in the dpaa2-eth in v2.

>=20
> > +/* Caller must call of_node_put on the returned value */ static
> > +struct device_node *dpaa2_mac_get_node(u16 dpmac_id) {
> > +	struct device_node *dpmacs, *dpmac =3D NULL;
> > +	u32 id;
> > +	int err;
> > +
> > +	dpmacs =3D of_find_node_by_name(NULL, "dpmacs");
> > +	if (!dpmacs)
> > +		return NULL;
> > +
> > +	while ((dpmac =3D of_get_next_child(dpmacs, dpmac)) !=3D NULL) {
> > +		err =3D of_property_read_u32(dpmac, "reg", &id);
> > +		if (err)
> > +			continue;
> > +		if (id =3D=3D dpmac_id)
> > +			break;
> > +	}
>=20
> of_get_next_child() takes a reference on the child. So you need to releas=
e
> that reference. It is better to make use of something like
> for_each_child_of_node() or for_each_available_child_of_node() which
> release the reference at the end of each loop, so long as you don't
> break/return out of the loop.

It seems that of_get_next_child() also releases the reference took on the
previous node in each iteration of the loop. At the end of this function,
the only reference still held is the one to the node to be returned which
is ok because the caller should release it after usage.
( A function comment is added to specify this.)

Am I missing something here?

>=20
> > +
> > +static void dpaa2_mac_validate(struct phylink_config *config,
> > +			       unsigned long *supported,
> > +			       struct phylink_link_state *state) {
> > +	struct dpaa2_mac *mac =3D phylink_to_dpaa2_mac(config);
> > +	struct dpmac_link_state *dpmac_state =3D &mac->state;
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > +
> > +	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> > +	    dpaa2_mac_phy_mode_mismatch(mac, state->interface)) {
> > +		goto empty_set;
> > +	}
> > +
> > +	phylink_set_port_modes(mask);
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set(mask, Pause);
> > +	phylink_set(mask, Asym_Pause);
> > +
> > +	switch (state->interface) {
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		break;
> > +	default:
> > +		goto empty_set;
> > +	}
> > +
> > +	linkmode_and(supported, supported, mask);
> > +	linkmode_and(state->advertising, state->advertising, mask);
> > +
> > +	dpaa2_mac_linkmode2dpmac(supported, &dpmac_state-
> >supported);
> > +	dpaa2_mac_linkmode2dpmac(state->advertising,
> > +&dpmac_state->advertising);
>=20
> Humm. Not sure about these last two lines. Validate should be about if th=
e
> MAC can support something. I don't think you should be setting any state
> here. That should happen in mac_config, when the state really is configur=
ed.
>=20

I agree with the fact that .validate() is not the best place to setup these=
.=20
Those two lines are there more because the API requests a proper supported/=
advertised (which had a specific purpose in the previous solution with two =
separate drivers).
I'll check if we can just omit them.

Thanks,
Ioana

> > +
> > +	return;
> > +
> > +empty_set:
> > +	linkmode_zero(supported);
> > +}
> > +
>=20
>   Andrew
