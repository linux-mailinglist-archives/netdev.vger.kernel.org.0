Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0E2CF3FF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgLDS0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:26:36 -0500
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:62341
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727729AbgLDS0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:26:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlZT0mFX2OCsIZ+8yBGUG4K9aLiDtPq7R8RnmVdoxNJjTnTMIHOBhVaQm2241Gm5UjZpWjQVVQEzhQuHXXJ6A4cGxYFyoe2EdykPqHZQeKX6lJannc7+kD5/yod33ezu6CFZyEpTNNPIeQE+MAnXbCghPMkBvwOtBRqc2/4QcVDwfR3HCscVHo4ou+BPD+k3kDXda4I2KM5oWxvhz3M76yPDWBPCzG3DxO+/zGjtGckfHn5h1n3grLWw02f76WtmNjVcm2LZOXR13DovDIcThVEcsqG08IQScqBa5TDxyG8vLAqIUCoPE7BcyEQY1wEEO/URcTVzP1d8Nz/hN+ka7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjJjWUP24+YqJyPGtA8RJqVpE+sqcZvYXWgQotyFiY=;
 b=Cl82pE5A24UWsUtgDpiGGG4YJfnUK86mDNFW0EmKMlR2TgZJHDEI0+itvHpCFFhag1t/lPvnFIiiJBldXIi2h1mL0tG4mb1/4ucImmDlZ0mnA5PfqGhW4ozHxhiZcb6WLI1wwq2kmYbRn8SoMIZfKWb0nC3NVvKZCL/1mlnPWhouU1ezc6jEENEJ8V2qJeLROEVO76OIHJAIAKK76DcKKZ7aJn0FmhUceN7G4NhWYTeh3KV3IV4ywWR0ptYyqGsFq+w7MQhp87lWTJvkF6ZqoM3AXC0UNR5tz83lXBHXEx8ilGO4A446qVaus1yiERPLXqRov0Cb2HIyd5lLoz+YNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjJjWUP24+YqJyPGtA8RJqVpE+sqcZvYXWgQotyFiY=;
 b=dZZrn+L7WuhmJ/BBzXsethhSdkmD0KtCIY1vr/tztj5n5S+oM7PbEdPe/xjzgqrPhxROi2vNjE4FSYAvPzjoeYZRHCNgmFTF/fbN/hDiMNl0Bfr1e9YjhyY8bR+tcrtcW/DIIr6DQTSYs1MCm28hwqCERFTckP3GaZvgAgeHdzI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 18:25:45 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 18:25:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Topic: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Index: AQHWymYcVtu/uzlPXESRU1bey3c5/qnnOd2AgAAHGAA=
Date:   Fri, 4 Dec 2020 18:25:45 +0000
Message-ID: <20201204182544.ddgoqvzp42s4rncp@skbuf>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
 <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 912c6a0c-9a97-4c14-ea12-08d898820401
x-ms-traffictypediagnostic: VI1PR04MB3965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB39654761A0B9ABAA0B788CFAE0F10@VI1PR04MB3965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VH9d/Xy5CbcVp4Ts6FSVj3tlfTUxzgk4GCIaLzwlGZk4G0qYIzBKmYa3tlgDB9O04d5RaCrq6izt3trbu9/H7F/TOPYAo4j/TLBGD2JPBYGWNiSWwTT83s8tGbJJTToi6ACxFnQkfrmjTZugLfL4Fo3uVgxtnjnjvkT3zUcBQadGIkTCnPXnH+znZY39Lghb6N92MRXrwqFqiIgOkAfvhSr3X44iDjCIwEybzqQyvel+wb4OJh62rav6krYagOymusdayqcG0WHxv2EldpEgU2M1XQh32dINfNmhgewmNgPVe3wfLEGn7gQQb64FXXkh4/YdrOTB5vIZi9bqOPnqxUriUeqnIGAXK9Yr4yLNJLI01sYw+ynUzUAgXCiJ3xi1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(66946007)(86362001)(478600001)(8936002)(6506007)(6916009)(1076003)(4744005)(44832011)(83380400001)(8676002)(64756008)(5660300002)(4326008)(66446008)(6486002)(2906002)(9686003)(6512007)(91956017)(186003)(33716001)(26005)(71200400001)(66476007)(316002)(76116006)(7416002)(54906003)(66556008)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cSoSmT3v3whFIOd/FyjfrjHer5DeRUsMEnozmPR/+GCA8+lzEm+YyWTmzyOn?=
 =?us-ascii?Q?B4uyWl97iRFW63mNbJJNABoXS+bsy1zL8CwcxiQVj+BgdlRgxHYct+HWMQqz?=
 =?us-ascii?Q?jbxRtI/CgkIU5iJtEOJUb75i795T9b0i2TTpX0vbD4Zv0NVNgIHQLO6js+Vv?=
 =?us-ascii?Q?5IZ3I0hlvcOEBQu5DvVGz2WQK8yopkQyq7Uhtw8pzhBUL5//wio90v+AojXh?=
 =?us-ascii?Q?zTVGWSlUphVqFnz6m0r2FtwpAhABUXjuHqOZZrfAstEww6Fv2fKS+ZB5EbPM?=
 =?us-ascii?Q?dAER4F2tiV3U1tv3BktBFARQliRTOS31W5rKo+CuVZXZsyHgb5NJgoX1Rjkh?=
 =?us-ascii?Q?TupI4+hibDyYocth0TUxumi4b5mmf8fUG1JDIbo6B/4lpXBASKwWpHHsGSJ6?=
 =?us-ascii?Q?SBBIfkfH2Fv7Lj5iJ+BJ/jv097k0ggqkeeWSU51DA25nP/TOfdGe2qb9fWv3?=
 =?us-ascii?Q?nyZ7akGb43mPaI0iD7IQjWD8IDzPWkxD5zFMXrCtoewXQhE2J/6gtdFfwSLS?=
 =?us-ascii?Q?ryGz3jj6PfIC9/X6yJTJ0oDLKmjzGqeIEKbql7WMBZk9lASZnJbBm8aS4Pdk?=
 =?us-ascii?Q?oawGlddRSpzgqvZ7eTd0RU6k78lyhlyID6rQ1WdoHRJf39xaefo8RvvVJxgP?=
 =?us-ascii?Q?R2DFf+KEWbVDMwBMAcI0h/KPs/+9C8pKGVj6IALwifkEZs1NhnCoZ5T5hrxm?=
 =?us-ascii?Q?IJWgofuROl2YVstwaaV8RQp9yPEPs3N+wHwNIGc46Kc0gI4Mo4Bg3hVuv1IW?=
 =?us-ascii?Q?tc4rM0mauXOi6Ymee5ExdFRpieROpG2WRk4MxcejgvNaTnokob8nOrc1Le8Z?=
 =?us-ascii?Q?5/XhbRGH73UY6iFJhyZE2tLnHZgfnd81vYdju8f6QoeswrXcmXB5FDsE/wGO?=
 =?us-ascii?Q?x4a416jkVSitSLjwbD+zPuSTLuz2NULqHnt4f2Pk1lm8jhdVi74VQjbPcskB?=
 =?us-ascii?Q?uRYCGDSKXZPVcrIg7OHhNxM+vPC+bECX2i+XqFLjrrMAv9ez20NrWYa8YXt7?=
 =?us-ascii?Q?6IQ5?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED70B52E3D572D4BBBE9247A3F5E2820@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912c6a0c-9a97-4c14-ea12-08d898820401
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 18:25:45.2880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7wzO4E0j6eVyfsRVCZakzmHfXTaOwYRkH06bf38qCUUhMzvfJ454E2h1r0mJHMou9NIyHarVRQvmbUJwuzU6CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:00:21AM -0800, Jakub Kicinski wrote:
> Does get_device really protect you from unbind? I thought it only
> protects you from .release being called, IOW freeing struct device
> memory..
>
> More usual way of handling this would be allocating your own workqueue
> and flushing that wq at the right point.
>
> >  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
> >  1 file changed, 80 insertions(+), 3 deletions(-)
>
> This is a little large for a rc7 fix :S

If you like v1 more, you can apply v1.=
