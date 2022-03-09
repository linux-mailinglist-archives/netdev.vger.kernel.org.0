Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C984D3B24
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiCIUe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiCIUe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:34:57 -0500
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50083.outbound.protection.outlook.com [40.107.5.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D063B84C;
        Wed,  9 Mar 2022 12:33:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9MeIClDaPaH0jRXsdzhspQMdphUYcaqigDU8T+QX6YvfJjOd8W8PC452zJAQZ80I1XYt/unfJH0AvNw2grhFq9nwT6Cn5WiAid1Bdx2ixPbKpUxkTbnVVAHtBR3QJhdnA9mIsKTxyozz60E6U7KWFuYrtSZ02kR8dyx99nNIqL2Tu3923Ssna9H6GuJ6EqK/jsCo8c3pg5B5wSVjDOTXkuVX0nmP491/Zn9yujYuskJ6ifopqhfiWtrUGuix4IyTpXQdvPR1XyyMTGUY2hQJQJvqyN88tEAOmuEQ7ma1EhuLCXzoGlWcS1LaIZDzHK10iukULZUM30I3S407bG1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hdEcx5zYIgcuXV9rWaUZA4J4Je4KxG/et53Yk5XhPQ=;
 b=le070eJDSYzeMSfJB6gS+wuPUSYwhGFsTbbuzEbToAJUQsUS0zynvAum25uhQQ3m5PXpi1xgcSZFo5yhlvT2N27GNnHDUh10JFpSV95NEQBtUmBxECAYTzzgeVBl9uuBdbeGRfCZUcDepKUFNUVU4wU/IwKuFCw/i6b6hH92GQVh3KD1nKE5PaeoTGegNSIwm3bJdg3mjFRpJdaDh5bw5n4WhcnfLA4fxrCbAaSjlbXzgAV4NhphZofHHWgM180+RTf9FAmXbDM5rnga7xNArcCH2BFtvZrCOmdL45B7UURNh9mH+AciM+mlLpIcW5J5y2mfs4oTbYvRBX4QkTRWYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hdEcx5zYIgcuXV9rWaUZA4J4Je4KxG/et53Yk5XhPQ=;
 b=ejt81+IC74lJKQ5WCgpqzoqnThxoGPuNssv4GsUPZZARMQ3Xd4YXbl95E3LyjEwdMx5CyScDUgk/JlL1nL5u6vtSflmbe4MT75QouT2eA+6RpEbbRPSTcWevwsMiH/rqrngFZ9ZoKfwxfusWAqXCn3Puw5ePEuvdw0dq7XLZzQQ=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM0PR04MB5426.eurprd04.prod.outlook.com (2603:10a6:208:120::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 20:33:50 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 20:33:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Hongxing Zhu <hongxing.zhu@nxp.com>
Subject: Re: [PATCH net-next v2 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Thread-Topic: [PATCH net-next v2 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Thread-Index: AQHYM9sO7LQ5YQGFC0CDkYQNpN7Iy6y3ZEAAgAAeAQA=
Date:   Wed, 9 Mar 2022 20:33:50 +0000
Message-ID: <20220309203350.qzqgbu6hmb5hiamn@skbuf>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
 <20220309172748.3460862-8-ioana.ciornei@nxp.com>
 <Yij2AlJte0bG7eJr@shell.armlinux.org.uk>
In-Reply-To: <Yij2AlJte0bG7eJr@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26abdf11-861c-426f-c8a5-08da020c1ee9
x-ms-traffictypediagnostic: AM0PR04MB5426:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5426F0721F40BF12D04CDD81E00A9@AM0PR04MB5426.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cljqg4bkHCI6sUhBBIBB/lHu+2gVHJ5b8x7WnpOTgcFp3ttYAFdVYswu7z8fwlZfzB2Hx7DCsYLdt/QCs0hzhh17NpIfAK7y27/4ix6h6AXtiHZuSeOIMqRy4R68gObNMloCQGX1AhtF48Cg8R8vHyWbw5JpxHJswa6OD9fhXW0rp9TR0u4SvWwBm4qeXp8m00sKrZOZaxQQEDMKyVKcj8YH0MuuQJYJODBRlMfjRXWcxnyV/nLvTBMwH6P6V+9viuXS0No2bgPhrU9m5Z4G0TVtqqmS3htyApzCUaymY3Iur1PEanXCL3h95uMjjk5agfAEAlih7OADN22TDUYVGDkk4NjMJnbt3hNl87EBf5Z/Ht5UtTy13zmTm/hnp5Xr9DU8t2dDaPYPStSgi8al7vEhY/9m0yln7ZmI4+5giptASQtOUnrlvXcdKCn/Qc2clYhyaVfuPp/tspG3P+ntF8LVMJzruJ3B4MSU/fbhpLnPDwmYPDWfFCM27GcN11Y2R4QmseEsCDzcza+CtMQYuHCVu3qP0LCy/YTETuLwjsvMF7bRHcnTgX8pXooicYi9V9mh9jk7ui2j+tpafzdD8r+nQx73MX+oYxYln+CNcFJdU/ETGE57I5P6q4oL1HX/p23GbmXXRDA54Gqt+MTVQ0y+SfPfw1yzi9zhFLI0Z8KMbc/Z1zLNJuNietFsaKDG/ZENhJ8mbU3KGsdrmxkoDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(33716001)(1076003)(186003)(6486002)(6512007)(6506007)(54906003)(71200400001)(122000001)(38070700005)(9686003)(86362001)(38100700002)(498600001)(83380400001)(6916009)(2906002)(76116006)(66946007)(66446008)(66556008)(91956017)(8936002)(44832011)(7416002)(8676002)(4326008)(64756008)(66476007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hKh4GPJ1//x4dXqAbsuEtxAsmQsDGiMM7CKFHR5Z3MP6SXgV1q1HJ3UNH3cq?=
 =?us-ascii?Q?RlIrW27m6/BLtQhKGnYXyDo9fZXNFMsTHA8a8UOdn2MBrgGv9CUQAJn+Nwbq?=
 =?us-ascii?Q?AKiEAx6dQf66uUnx9GtssR6qEkt3I3a8Lyb5LoAkR7DLE2Wq7f1DrOxy5+nF?=
 =?us-ascii?Q?QbMAdf4eNfvZM4fTjC4qnVRDeLQchkvVTmK2SxyRsnDlmYyRydbOVP6DvZns?=
 =?us-ascii?Q?+wsN02fvmf6ltJO0Nd0zT8O4q8f0w+qqhFRMNEVk+4sFFJYwBwDX5nZTm9my?=
 =?us-ascii?Q?VolDS+9Ozq98re5bGgtvCsaFkUHghxscnizCiUUPjR8dU4PO7lC68txVr00D?=
 =?us-ascii?Q?1+LcCX/+WnFANu/k0Qrn9Si6d2e2Q2wBhe54LH11M1yFDnhNhwNPH/q+kFWC?=
 =?us-ascii?Q?jQjYATRFg2hrFZavB98Ssy289brm/+JkRua18JrUjZ4jSB+1S68ZiJ0Htv9p?=
 =?us-ascii?Q?1a/9gpCL3wuJw/TD56SqLF7qDSL1ZsanrFqKZkkhjl5DC/2DBEV/aCRWN8Dd?=
 =?us-ascii?Q?q7ndBi8DWPpcL/TM7tzTUbHvDPU+oKYr718rHOWLGrOoN4IMU4VojoqZv8S+?=
 =?us-ascii?Q?x+XsnDk42SaRAkz/7w9jHdmHiMCzTWuv9Y1lxHHI7EO2g4VQO89C8Ym3+HGD?=
 =?us-ascii?Q?hJd6qIs8A/VrKBsOkuBOi2fsazItdNq+99VcI9VVCxgYTY0VvtWLfYHDNhKI?=
 =?us-ascii?Q?eKIgAEibN9QItkySZUxJ7Q6xxQ5o1cKJmoeeyagAajzceOnYK13/e7B5p4fo?=
 =?us-ascii?Q?Wiy8ac3meIy/PuMLpuZcRJUmwc/i/kdq2nopveBzJlxEzxP2LqTzr3Ab5FWk?=
 =?us-ascii?Q?ft0WbAWjsA3re1bw7Fl2BYDbkyLBBSvniPt/lebTQGET5FrttMlw8Gj3i0gu?=
 =?us-ascii?Q?CTD4D1JaK3Jo2YDwq8vvPqm3JisQCL2m23ZF/c2ij998PzKj5kk1ffcCoRFp?=
 =?us-ascii?Q?1gdDyhRD+qHdx8knbjowkT9w9vwEAGHotJOH9xiPQo4i6sSCd66Kjp/OSozq?=
 =?us-ascii?Q?vQivM3pGt7A28nsbarDxk1pDlXXYpCiUdv2ybnm19kGOxVgGbsDfKr546Uzb?=
 =?us-ascii?Q?Mxu8KZwam/aouICXQ74RTapV60wVByB0DiK8+Ik2xQPcNVOM3UI+IeIyR7ZW?=
 =?us-ascii?Q?/musFN4XyzZ7goFXqKF+B5plUFQ/sR6TZZKKEbTgVPvK7Hz+I5INzRP22Gt2?=
 =?us-ascii?Q?GeGdwgx/w5E/wFKkBSKM8R71eJds+gH04wWNlTMsW3e99H2teWAZbGfFI6O/?=
 =?us-ascii?Q?FA+5+G+gMzRGN+wfxlqTpYjMwux7i9lBbcFfDs0lW9mYV3TXsVTi4JNHfMR5?=
 =?us-ascii?Q?hKQHz8hPG8EJt88/uW6F0BoJR2vbXBO8dRMWphg/6lwyyDt4lkwc1pab89xw?=
 =?us-ascii?Q?v0uH0cnHBZUNF1wh65FfQRIkL4mLYXYuqjaTNOw3TLAnR+Ntd68hpmw80pwN?=
 =?us-ascii?Q?gCS8eotk5kQ1gKFV4Z/3Kj7ihAkQgSRGSKCMnKq8TDs7RaHLyMiXAZVibOpi?=
 =?us-ascii?Q?6wgQkBUYrzxCRY5U6k1B5qboRawfhSX2TBtXEKokFEfkum9slHnXLDeas6Vp?=
 =?us-ascii?Q?+rbgZsBkk1dUUxk/rQJjmM494LKNBxKVu2/tA0Th1tH/TVSghpd4a0f2Am2S?=
 =?us-ascii?Q?lFK4jgnEtuCqZ42s71nRXJI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03773CB7A032044F9FFADFD2AAA28D7A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26abdf11-861c-426f-c8a5-08da020c1ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 20:33:50.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RwW2zbFz5iLHDTy4xLoZMtstXHwKxLGzQlQfBjPBapMVleWEoWO3uOBBOcl3CZIbC7xRHbponqa4qim2jw7BnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5426
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 06:46:26PM +0000, Russell King (Oracle) wrote:
> Hi Ioana,
>=20

Hi Russell,

> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -2077,8 +2077,10 @@ static int dpaa2_eth_open(struct net_device *net=
_dev)
> >  		goto enable_err;
> >  	}
> > =20
> > -	if (dpaa2_eth_is_type_phy(priv))
> > +	if (dpaa2_eth_is_type_phy(priv)) {
> >  		phylink_start(priv->mac->phylink);
> > +		dpaa2_mac_start(priv->mac);
>=20
> Is this safe? Shouldn't dpaa2_mac_start() come before phylink_start()
> in case phylink determines that the link is somehow already up? I'm
> a big fan of teardown being in the reverse order of setup so having
> the start and stop below in the same order just doesn't look right.

Agree that the teardown being done in the reverse order just looks
better. I can change it, of course.

I didn't really spot any actual problems with how are things now, but it
would be better to just bring up the SerDes lanes and then call
phylink_start().

> > +static enum dpmac_eth_if dpmac_eth_if_mode(phy_interface_t if_mode)
> > +{
> > +	switch (if_mode) {
> > +	case PHY_INTERFACE_MODE_RGMII:
>=20
> Shouldn't this also include the other RGMII modes (which, from the MAC
> point of view, are all synonymous?
>=20

Good point. Thanks for pointing it out.

> > +static int dpaa2_mac_prepare(struct phylink_config *config, unsigned i=
nt mode,
> > +			     phy_interface_t interface)
> > +{
> > +	dpaa2_mac_link_down(config, mode, interface);
>=20
> You should never see a reconfiguration while the link is up. However,
> if the link is in in-band mode, then obviously the link could come up
> at any moment, and in that case, forcing it down in mac_prepare() is
> a good idea - but that forcing needs to be removed in mac_finish()
> to allow in-band to work again. Not sure that your firmware allows
> that though, and I'm not convinced that calling the above function
> achieves any of those guarantees.
>=20

Ok, I didn't know that I this was a guarantee from phylink's part.
In this case, I can just remove the prepare step, sure.

> > +	/* In case we have access to the SerDes phy/lane, then ask the SerDes
> > +	 * driver what interfaces are supported based on the current PLL
> > +	 * configuration.
> > +	 */
> > +	for (intf =3D 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
>=20
> You probably want to avoid PHY_INTERFACE_MODE_NA here, even though your
> driver may reject it anyway.

Yes, I'll just start from PHY_INTERFACE_MODE_INTERNAL.

> > -	if (dpaa2_switch_port_is_type_phy(port_priv))
> > +	if (dpaa2_switch_port_is_type_phy(port_priv)) {
> >  		phylink_start(port_priv->mac->phylink);
> > +		dpaa2_mac_start(port_priv->mac);
>=20
> Same comments as for dpaa2-mac.

Sure. I'll change the order.

>=20
> Thanks!
>=20

Thanks!
Ioana=
