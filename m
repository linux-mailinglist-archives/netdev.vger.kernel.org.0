Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5CB624676
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiKJQAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiKJQAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:00:13 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20076.outbound.protection.outlook.com [40.107.2.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA5BD2EE;
        Thu, 10 Nov 2022 08:00:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQwWhfr1tcZSMQQG1UxEEIquwBNO0K96keBsI42kqgGB2xM7fVCFOnsjJ5VUL/l0fKFmKAeneTWaRQ5D6uDcNFCQtLKXs82mfYCCFegUUu/rylzSj2x4sHTECM8OsTOMZCo2HF8w+1wMtUd7HnLzfI7rJR5q4HrrnlvYEOvfF2eb0GJXwantqT2ji84a68CShl/7YA8kztlXjPtQ7dqAiMDM9YNkPMqnue465qxmAK6eJwZ08+RQiYnJovDFVnsu/7NAmOZPH//3k8SwFR6mBSLTcIuWBSPsSMrS0uR65YU8QFfznVfwIMyfWnHRysPLmJH8dEMAQRz3ztqafiECKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gasJDCaEmI1oIjU3VT1WMA+VCQU0ufpuFEutlKz7z5I=;
 b=iqBIxtww8CYx4YdoenjAfvnNLi3Nb4azVFaTDhKI9lMS1YOl5TtJ2hLloyNDAZIOZ+tf3ocEXHuebUbYyD6+Agk9rtvwh5rWyGV7XeVLKwk0YolzyMecaUdkewIfVyxttsJOslmmhWzFXxFnBhU7Z2fjJdiykSYqPc1kJ8w0/X1obxN28oca6WoDESGjpiR/4tmBAxfoY0l7Q4IikqDv+rIAKM2/65eMIC56G1x50vxAYrrV1sxhZNw6b6xWxyCsS/m1EqHdzw/WVfopNgJ4fzp/0PmLTpDVMj7A7pa+K7Pr2cBKWBIh5XEQyJlZPPhzsRN/NIVXBYOY2qvnbBm2tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gasJDCaEmI1oIjU3VT1WMA+VCQU0ufpuFEutlKz7z5I=;
 b=pH3Je+njvhap4yciURi9/aMTyqgDgIFM7nFzlt+HTj/B63GBoc2KBY/nDeHYH/AKVNmmcDz83DpwruSa/HHEkCnD6w1qV3LTKSAc4neeH7kHRAnP/9H2FDKq2DXwDy4RqRawwtB6jEuIM4LWlexSoE5Pf33nQVdFFtYw/84f8p4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7514.eurprd04.prod.outlook.com (2603:10a6:10:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 16:00:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:00:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Thread-Topic: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Thread-Index: AQHY78g7xxgXmFEQmk+41hVlaLM4fK43OSkAgAEQPACAAAl4gIAAAtEAgAAFxAA=
Date:   Thu, 10 Nov 2022 16:00:09 +0000
Message-ID: <20221110160008.6t53ouoxqeu7w7qr@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
 <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
In-Reply-To: <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7514:EE_
x-ms-office365-filtering-correlation-id: 7eb54d3b-d6c4-40ff-3f9b-08dac334a477
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lRHoXhIyNZoe3UPDAO2kZVIH3P/afn0ErxNuox5h2U4rpnPi80nyrNgj6ljUc5WEQuA2VWFaOBeriIKGJIn4ffhVW+Eop+kl61dTbRWFUc2Tdm79wp0u287BnAZ1coR1yK2Ub7lBohJZI+CEF40eanPHHsODWbi4lr3Op9Zf9Q2AYggim8taGCraghyo7VRziyvbGF8b1w65i6Qv3/DUZGacGW0UfQG41DJY2gksFi17S8FCjlSIvbACGZGs4e4BfPbF4LDYrWYZQGKU8xzaCLT31tdW7yP2emntv6ivsOYkhD5OWFrQaK2GhvvQ53KjVWJt+EbjgI0cnIHMGr/zsXdZQwLO/vaTb3aZisoXCLc1p9TI4WTIAVJQG6oQEFiZyLFhh/vshtFq+KHokVv+l41hTWA47FlCRC8o7Bvrbucqq+IjSy7L2hW2YPBYM1FwGm5Wv/T+a3z53vv0rlWZynIHiDyJV2HMUF0qEa91PoWZ01Vt/obj7xX+On7wakJzfAVQk+UmzP6C02dOk4KzK7VSarwuNhce3JuUHQ4O7vQl36l9Va5TpjzRk5wZ1cKb54i7NmT+szqOfAFVeDqf+/iFX5pQY4pkudyrnhP5mxyG8exuk7jXWtISMdIUKUTusnd/bxclGAdgZ88MGPanguSkUr0Rmjy3M2+ZLX4Ef/KuQAV/YXWsd0cNt94IcAf5So/Ix2WLPLHV45DkEJaEaT9qbZMvQeKCTe76RTYGJz4NM6jRrgeXT/WPe8n2N5n0TXKRcPuJM7rDW36iXajRhX26jSTLW0SdMiin+szFqw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(38070700005)(86362001)(122000001)(6506007)(66556008)(2906002)(44832011)(7416002)(5660300002)(1076003)(186003)(9686003)(53546011)(6512007)(26005)(83380400001)(38100700002)(8676002)(66446008)(64756008)(76116006)(66476007)(316002)(66946007)(33716001)(6486002)(966005)(71200400001)(54906003)(41300700001)(6916009)(8936002)(4326008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vYk6V3IKk+oelo5SIHzCbd84MT5H7o3a43K7l+W8Lc7EoOclD66Ln5JrXQzj?=
 =?us-ascii?Q?DUrQ6ngolSCkoqhr6573m1BNjAUEfygx6JRKRl3x2iEU41WEcWuSzu54yxEx?=
 =?us-ascii?Q?O10+xfjIxrjxtjzAQhgoHxtxNQ/LWxApCbYwW8aXyl88SxZtydv8GfxEb0Zb?=
 =?us-ascii?Q?4nljUSzuuNYCUe7/PZthQP2nF7vn506no3ZvS/iakmPmEzn69dgFlaaxFRBp?=
 =?us-ascii?Q?1uv1EFZuWNdpVo5IN9KSwWdirs49ELjuNKt85vDuGG5MWb9VsARClSwbSia5?=
 =?us-ascii?Q?S8xO6OPH+iPPC4jaLsce8oMQReBGbX1ofCOjBFbg3lailabFlq+FpnVDUOpo?=
 =?us-ascii?Q?0kLRw8tHBanYqQxZZFlCiWww4fzlWRh6koJI0I4eefZRGRmO+qwL+U6uUQTC?=
 =?us-ascii?Q?t7jKqzOUBgHPpNXk209Sus+eIqfyzISJSZYDhL5Jnj0rO9DSVTmAuUfVHtMv?=
 =?us-ascii?Q?8eVsq8jaBeHHekcaXiuFes2pTZkJSEGzIumK7+pglVTWwK9zZe+PRgbg1nE+?=
 =?us-ascii?Q?IBZYfrBG2eA9Ls2c4PYxUYgpWl99EDedq3+gjKo5a2QZGvF8ojhSa46QlMcl?=
 =?us-ascii?Q?jSjM+w9MOQFtebKSylW2RxQqxoJWz6mzxvMrQ/wsyCk7rxVFzd9moqgbDae7?=
 =?us-ascii?Q?zXtsUGZ51PPk0KgjNVIBofcjOAKq0QoYitDvY/o6uWf4PH/1J/ivLUvEcmNy?=
 =?us-ascii?Q?+WLl7SB13eL0Fxwaqb+BBh/rLHrlugahT+waeNsBwe2fQgpH5aneWM/eQChg?=
 =?us-ascii?Q?GgvojZm1pNe1uI2OLC2cu4qSYkhJtHLL2nbrFmlFc3Sfsqqw+Sw/i4j3auSS?=
 =?us-ascii?Q?S6zVNZg6OqH7Eva3n7QmhzBXMYhlHIeFp/YPLgNc5VQmdxV1Mh/DH+PY/Q3F?=
 =?us-ascii?Q?hJ5BcigP2c8Nz9e+CtwbsqJEIGNXLVqbDuI98taW8lkAccgrYIQGBRmbu4dm?=
 =?us-ascii?Q?EdPTzhuNHpphX4C8XvWGgSH6L/LrmLaEcymB7kIJiSj4mI7oZlWvqrAFyBzK?=
 =?us-ascii?Q?9j7CyRLzln0EHwJjzTDkgzwK4+/XqVxlXmxMN+D/cTg283+6flkuWgAxph2o?=
 =?us-ascii?Q?dnN7M7OvVioRyRYBDWPgmvP6PKbkh+ivwP399/FM1NIiH0D48CbpU+TjpE4w?=
 =?us-ascii?Q?l6BV//j6B6eAaouIiVnn8pVilw9eFGNAevBgbf6eGU7tQQr77yQ5K6fD+vjC?=
 =?us-ascii?Q?eJTAqx7keY6+J87vlz1jQYLrko7+Wy5c6RIzxIWCDuUsUZmxj/JlCiyDxkEM?=
 =?us-ascii?Q?XXo6Vs3xjLAXqkIvnzL4x7FG+NiIpWpjJNOOCNUNILoyNw2R/ulEhFKVo7jh?=
 =?us-ascii?Q?QD1LYMn3J+qzNNuVJfHetjlt7pP5myp1eYkGcZNvkQ0x2hpBO0/NgFJ3qSZj?=
 =?us-ascii?Q?ZvVXDcMn3Bz573tlbMFNj7peGIlLPw3/5Y9Sjl51zN3bKcqBZx8U4Zez1+ly?=
 =?us-ascii?Q?j9UaYBjnPaY8pPClaAnXiyhPGlfHib1iqNslBQDPrVZLqpY0IwKZdByHbPEB?=
 =?us-ascii?Q?sgxdzgIZAEK4Zf/NYg+a1ri6FcRnHDCdUL7eHg+1+eRqxC071/OZNZyIRL5S?=
 =?us-ascii?Q?TBEj7G+VQaaI1ujq2RNFireeBbDFCbUEokYtZgTbEOH88eLqUf+uVKzXsYwE?=
 =?us-ascii?Q?Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A639331C37B3140B239604CC2634931@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb54d3b-d6c4-40ff-3f9b-08dac334a477
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 16:00:09.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fleffBfyDA3BozBVYsZdfQzS68fBt9Tqupr+ClcbbKYsnRyg1pbNZk9Y9WlHn4MDrxQxVMQ1dWOYsYv1QHaYWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7514
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 10:39:30AM -0500, Sean Anderson wrote:
> On 11/10/22 10:29, Vladimir Oltean wrote:
> > On Thu, Nov 10, 2022 at 09:55:32AM -0500, Sean Anderson wrote:
> >> On 11/9/22 17:41, Vladimir Oltean wrote:
> >> > On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
> >> >> Several (later) patches in this series cannot be applied until a st=
able
> >> >> release has occured containing the dts updates.
> >> >=20
> >> > New kernels must remain compatible with old device trees.
> >>=20
> >> Well, this binding is not present in older device trees, so it needs t=
o
> >> be added before these patches can be applied. It also could be possibl=
e
> >> to manually bind the driver using e.g. a helper function (like what is
> >> done with lynx_pcs_create_on_bus). Of course this would be tricky,
> >> because we would need to unbind any generic phy driver attached, but
> >> avoid unbinding an existing Lynx PCS driver.
> >=20
> > If you know the value of the MII_PHYSID1 and MII_PHYSID2 registers for
> > these PCS devices, would it be possible to probe them in a generic way
> > as MDIO devices, if they lack a compatible string?
>=20
> PCS devices are not PHYs, and they do not necessarily conform to the
> standard PHY registers. Some PCS devices aren't even on MDIO busses (and
> are instead memory-mapped). To implement this, I think we would need to b=
e
> very careful. There's also the issue where PCS devices might not be
> accessable before their mode is selected by the MAC or SerDes.

I don't get where you're going with this. Does any of these arguments
apply to the Lynx PCS? If not, then what is the problem to using their
PHY ID register as a mechanism to auto-bind their PCS driver in lack of
a compatible string?

You already accept a compromise by having lynx_pcs_create_on_bus() be a
platform-specific way of instantiating a PCS. However, the only thing
that's platform-specific in the lynx_pcs_create_on_bus() implementation
is the modalias string:

struct phylink_pcs *lynx_pcs_create_on_bus(struct device *dev,
					   struct mii_bus *bus, int addr)
{
	struct mdio_device *mdio;
	struct phylink_pcs *pcs;
	int err;

	mdio =3D mdio_device_create(bus, addr);
	if (IS_ERR(mdio))
		return ERR_CAST(mdio);

	mdio->bus_match =3D mdio_device_bus_match;
	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias)); // <----- thi=
s
	err =3D mdio_device_register(mdio);
	if (err) {
		mdio_device_free(mdio);
		return ERR_PTR(err);
	}

	pcs =3D pcs_get_by_dev(dev, &mdio->dev);
	mdio_device_free(mdio);
	return pcs;
}
EXPORT_SYMBOL(lynx_pcs_create_on_bus);

Otherwise it could have been named just as well "pcs_create_on_bus()".

And this is what I'm saying. What if instead of probing based on
modalias, this function is made to bind the driver to the device based
on the PHY ID?

The point about this functionality being generic or not is totally moot,
since it's the driver who *decides* to call it (and wouldn't do so, if
it wasn't an MDIO device; see, there's an "mii_bus *bus" argument).

It could work both with LS1028A (enetc, felix, where there is no
pcs-handle), and it could also work with DPAA1/DPAA2, where there is a
pcs-handle but there is no compatible string for the PCS.

> >> As I understand it, kernels must be compatible with device trees from =
a
> >> few kernels before and after. There is not a permanent guarantee of
> >> backwards compatibility (like userspace has) because otherwise we woul=
d
> >> never be able to make internal changes (such as what is done in this
> >> series). I have suggested deferring these patches until after an LTS
> >> release as suggested by Rob last time [1].
> >>=20
> >> --Sean
> >>=20
> >> [1] https://lore.kernel.org/netdev/20220718194444.GA3377770-robh@kerne=
l.org/
> >=20
> > Internal changes limit themselves to what doesn't break compatibility
> > with device trees in circulation. DT bindings are ABI. Compared to the
> > lifetime of DPAA2 SoCs (and especially DPAA1), 1 LTS release is nothing=
,
> > sorry. The kernel has to continue probing them as Lynx PCS devices even
> > in lack of a compatible string.
>=20
> I believe the idea here is to allow some leeway when updating so that
> the kernel and device tree don't have to always be in sync. However, we
> don't have to support a situation where the kernel is constantly updated
> but the device tree is never updated. As long as a reasonable effort is
> made to update (or *not* update) both the kernel and device tree, there
> is no problem.

I don't think you'd have this opinion if device trees were not
maintained in the same git tree as the kernel itself. You have to
consider the case where the device tree blob is provided by a firmware
(say U-Boot) which you don't update in lockstep with the kernel.
Has nothing to do with "reasonable" or not.=
