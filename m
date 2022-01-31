Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98094A4DDD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245539AbiAaSPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:15:35 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:51296
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344376AbiAaSPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:15:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwC43AelPfViSiBfFU7O17DKmzmFWEP77rLM85im3N0ykNU3y4eHdXpO+Nl3+YC9nkdNxxs+HIs7G9spoA/9FnEy5qmfkupeRkUvn16yE149WQ+LHqx9Kpd58AqjvZrHCKIYM/Q+rPTNwD0CFVNicwueX5Z0WnHgsj7Vc93nNDCIseMQ5UISCGdsHDpUNGHN80WuBIeheb6eur30iJaKlEU264F0JKMJbcFg/O4Hm8pQGJt5qVA5i/PEvhl1I98wQJ1x+ilS4SxI4wyAFlyMv52dmR/fB4w6niGDsyGrJwi06q5J5ZQpnG7qYAdJtfBglDv2+aqcNrbmbT6F2DoyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPR/aUuv7WFDHXZQfeSv7RUbwJC3ho86aoXNp+s3hPE=;
 b=asrQohaoGJx9l1zN9xArT93SzPFfJo6QCktfPSeLnsb4UdBzZyN9e7yVtKTwHFOxumJdSlxWT89aeIoZjxwKWveRn+T/lINPTvts2Ovcfz19sly1YJZSmZ61aw3m11a6krma7hwUlGkitA3CsR0E+ay/dylYDH1uBnr4xd/V8q5g8kOcqF2hAqJouHnJewyrMTvpH+gZQxkx5wVrXv4VyDnfMs2pgymEIguoc3Vk48qtbgwm/h/K/0ACqFODUk8oAwmBwMMqonmcgspCI3Sv/+AOOAJ8MR8KrvgCEYFey3x/7LiI9NlhCuwQWXDLdOGVOCOz+BEQWCFzZUeeLzSKcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPR/aUuv7WFDHXZQfeSv7RUbwJC3ho86aoXNp+s3hPE=;
 b=aBwuEkQZoA6BsYvddrGZ4kbdmjxa7yQtWS0ciyerhOv4VSOdV6Nf+R0pA12M4hEv4o063bjx6vVffOQdwCkkmFJgMSYtuGHcdLLr1EMHW47eK+mBQBpF/GWn4JtoGJbHIquPcVZGnPcWL2tVUy+T4a8m9gWVI85OtH0/A75jFtc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6690.eurprd04.prod.outlook.com (2603:10a6:208:16a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 18:15:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 18:15:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 8/9] net: dsa: felix: add configurable device
 quirks
Thread-Topic: [RFC v6 net-next 8/9] net: dsa: felix: add configurable device
 quirks
Thread-Index: AQHYFVv1JbeGvfMOAkqmHy+3zuj7iKx9ck8A
Date:   Mon, 31 Jan 2022 18:15:25 +0000
Message-ID: <20220131181524.zgbsbrq4yzukw2ir@skbuf>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-9-colin.foster@in-advantage.com>
In-Reply-To: <20220129220221.2823127-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 705f6eeb-64ce-461e-cd78-08d9e4e5a787
x-ms-traffictypediagnostic: AM0PR04MB6690:EE_
x-microsoft-antispam-prvs: <AM0PR04MB66902CEC08DD6E4F1B2DB069E0259@AM0PR04MB6690.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FopGtAsYI9n0oGpmcePDEqRcQkxWbFHZFPmKUX/YeJRQAmqkk1XPZal3wohBXXN2CGt/F1rsDZYZv5RfZVlULChgLAkg7LZJF8CQeDmlHBV2wQJb8CAAy8D5VM9Jw9pqYfez5se5f+eH0Kw0aaQdU0tKAx02PeL/kv5wAG/5iio6BUAXfQbq4nXBrIBiPfWSB6nasiUBkrDA6HXl0kW3Neuoys0/1X8ymqTjI13r/wYa5j2ab7GVG8lyxt2EMR0XBODEmeEzpAVfaNF6tmD5kW4pULnFBycPNUijiAms1KMi19teR3OJwiNFY1JdnS9LXhr5ZjQrZRNdzC0EYn2Bg1KrvMMklBGybsOGVHhfMClo4OwwpMaZjCknXr13Sd9W9Qi4SPgtLGTSJyHU5EVhGkHIZ2Pu7gm+1IbxJ4lOKJHXqvaOvdvdWX5o4x8JIaoPxPJBPzhxSL7uvk5r+CwAOsH1p4288Bl3z4cWg3qwzN2frWcoD+E3BlYcmqXUONEugIZ7OC+h2ouPPDQjOlrxMx7TiYrUHbd+L4FmrwFHvIXCLX7R2cGmq8PyglIMjpZjvuerE6WW+3hhiTdBoJIVKHuMhI21Uh8qaYpdgQybEAm0ZMg5p71mtvvZqpW1DtfOvj8jvGfmFLLAwHx3w5w1WvImXYX+5+Tn9v1zwWAWYHQU4pNJr1eRLyJM2c3sF5rDiUfJeMDOTPa8b9CM/gp3tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(186003)(9686003)(44832011)(6512007)(4744005)(5660300002)(2906002)(7416002)(26005)(1076003)(33716001)(122000001)(86362001)(83380400001)(316002)(4326008)(38070700005)(71200400001)(76116006)(6916009)(91956017)(8676002)(8936002)(64756008)(66946007)(66476007)(6486002)(66556008)(54906003)(508600001)(66446008)(38100700002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GJTYjbMol978Fs1ySHaGYDJk9ETQk2PnBfk/cwFqnPgRsA+fjZGCnvKc0irZ?=
 =?us-ascii?Q?evO4eTi8qBIboN0yBTYStfN+Ekdm23COiO3pHh4EA6pNIFp+acvGW3nDJGUK?=
 =?us-ascii?Q?osOebKsSkqp+3mwGMqMRI0xj/NobZ+J13eJJ6gFxrS40q0rz78xynZNTHgCd?=
 =?us-ascii?Q?HE8QEauneNpOaiiBPPP8uSseg+w66QDsfYAHgLfIIXAd91b0+wdESyYsB+jh?=
 =?us-ascii?Q?SV8lpZ05G0FgFuobFu/6o3Gm52WIXSQTG1KqQ/8wIEZu46oA0oitXG5V8NaF?=
 =?us-ascii?Q?Yd1xLmknD8n7JQK2sDHd0Je90C/QsF7KauDOKeeGhkZpB44hABoxLLR79pO9?=
 =?us-ascii?Q?CBI2AVl7eSjSeON86yS5HilrVDlndKY+ffZ07Iq2Fx4r5ixTSo6/1xDL8IHG?=
 =?us-ascii?Q?xafeo/nRMSj26uca/FRkKVYpOuWz2bTiE5uG1iT/NQ+i8W6+yi6TYm3ORW2U?=
 =?us-ascii?Q?1OPcaWOMc84oOKTDtoUdEGJNkYORnYBWGNyNjw36x+uUFAuy/um8z5DT8xHx?=
 =?us-ascii?Q?QDNLBicqbq0NmLFFoeKBeofRq9Pc+jcunxKVfmfyw4ShCy8Kpo+trdJo3pnC?=
 =?us-ascii?Q?9EoReGVlSNR5nalqdG0YL2oEGmpv4l6QriTCaG6RCQHCHn681M1Z7o85nvpY?=
 =?us-ascii?Q?UCeZJ+F7xG5F770dE6n4CYMTqBis5Wiy61QRDegKOCcap/S6Ib1EXZ6nASwY?=
 =?us-ascii?Q?u5Kp0c46fyKBpORs1IF84b7wPKTcT+n6ccZsCZ2LlvpD9SjkqETo0sdPqFwV?=
 =?us-ascii?Q?iu8U5lq/jdkuSuyM8uHakgA5z9PKANMRa8NhtKZnXI3IuQUDz+lZh+yEIp1U?=
 =?us-ascii?Q?QsvLPpU5TePU99ziGed3TyZBPvLVy5ghTJevRR3q36qvDFSVSQFiD/ij+84Q?=
 =?us-ascii?Q?5JfjP0/WiAocPp0tCvI4BOGWmV+4Mu6JydETXRKDTYYN+NrlyyR9GKFN9sml?=
 =?us-ascii?Q?nvdp7N8QKCpkmzPT3nr9Qd3VMJ3U7r35EsZ26e6gfc6yltBNIayuMjd94bhU?=
 =?us-ascii?Q?hDpv+8q15fryl8xwknHH+JhyVMdZpM3FQ16k2gIUOno3u7t2xUKcLi3g1hDT?=
 =?us-ascii?Q?y5g3ynodsVSweIrwixxZX9jnnwUS9L5KF5kGlegBwxMV0IJpMAdCtnNtsx3A?=
 =?us-ascii?Q?EqSn1CqCJ+pqJKBWfShcsVNKLfzbVwtUyUzc36NtE2R7vKcIxHLy5FrVyZaR?=
 =?us-ascii?Q?3+6pl3k5VkLvGnMssl87pRUQK1peBo2UdVAWqTGvSNQ3ZzyT8c6Y+GrgeM+c?=
 =?us-ascii?Q?c5jTvP+2cZNyO+VHbsck+bfhz6kbvSitit/XB5rwJEq87kiENscQnQrwMaO+?=
 =?us-ascii?Q?Yz6U3Gf6y1wcD7HEXedD2AAllnUG2myoP2iZGLFKfOPnEQCwRHFoOCtJFBJD?=
 =?us-ascii?Q?WkIa7Yn88CFtWFLD5zvU0oNvzuqxpF3H1vvzQZzqIHI439M9leCbTV7NjDF3?=
 =?us-ascii?Q?GWT14MglAFnljbhEVGf7ylIbu2M1+LwmjIrMw97sO0WfXeflj1tjV0MDKLzG?=
 =?us-ascii?Q?m3p93w8vmWHK+vktcePtZeq/8oDBCTtD1qBTmlY+mYJa7DQMXxzEyhr7xQYZ?=
 =?us-ascii?Q?tPFB56meISU3znhadyJFO2H/Xoo1ePEQm2wvhUMYeC9nLI+gEKA/GUIdHbwj?=
 =?us-ascii?Q?vRRReVDRAcbjCQuIxitO4Rk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28EFC784406F7E43884737E4097A9D9C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705f6eeb-64ce-461e-cd78-08d9e4e5a787
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 18:15:25.7568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RkHOeSpOn3K7P0iDFnWF4Vbzn2XTAyzlqIPz+QGDYmpxYx6C07/LV0qDUmTl6NEm510ZtfyN7jcxGr7Hm0HB8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6690
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 02:02:20PM -0800, Colin Foster wrote:
> The define FELIX_MAC_QUIRKS was used directly in the felix.c shared drive=
r.
> Other devices (VSC7512 for example) don't require the same quirks, so the=
y
> need to be configured on a per-device basis.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Just one small comment.

> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index 9395ac119d33..f35894b06ce5 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -26,6 +26,7 @@ struct felix_info {
>  	u16				vcap_pol_base2;
>  	u16				vcap_pol_max2;
>  	const struct ptp_clock_info	*ptp_caps;
> +	u32				quirks;

It's an "unsigned long" when passed to ocelot_phylink_mac_link_{up,down},
so please keep it the same here.=
