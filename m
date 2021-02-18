Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBEB31EAA7
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 15:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhBRN6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhBRNTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 08:19:02 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0628.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48358C061786;
        Thu, 18 Feb 2021 05:18:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsDPtIe2L63beG+SUs6jcQb2a2a9qLl/ed0gKSVGt5kLz/wFrpuFxJrnEFRWNUH/9EAqQepqHvLFeG3OexCFfcCMIHwdKe2Viv+fmPAzKKWX7Zk4Y+G2/bz03qkmPWkyQXkSl8zYMV05F9TUABMyIkUJoTWfsSjSLLQMviP0PrTThHyL9ZoukZarLNUc36xtgPLCoC/gP1rNWhsRHpscc55oI3+Qg3wPEN5E17vdrIEwlFmKpxBGGIs4/3Bl1g9H2iduUt0qzM0+pH4nBmWpOK1/3nlt9wku3lbc8nTnjvCf9gIQ4vH//BLDH3wbwcthfW8I4fyuR5KqX765cTj5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bldgEFtFLSWdSZ9fRL3QBKyM1/wFAEFAHSyJBN+ffnQ=;
 b=T5MlTGCDXwxkCcJwkU0/cvqPMrJRLmyiPry3bVMSTGibNUpWn/RNzLu6tAf4jgZoOFW91pyf/W0uEr3GmGEDgZm7rZjUJ2qb3VjIqKn8p0B2UhslUFnxVtMwwZ+lJeuWjIQPZ6whhfQ079AuGi1sfESSO9c8zLuiFxcI0yPlVfOGFrktsL6fg3dFw/FyWdB2exIHE0c17ksOX7zm/k0G+A6S9+vISz9zpX6A8S48VPG9gw0Z7h0om/sghuXCCcbJ0XK7XYmkkoup/pzEEdEjoPzFpLmRepkAkSzqIlHvCyrxirDIsAxdyn016aWcUQ7Fdy24w+zy+DeEGy048+Xb8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bldgEFtFLSWdSZ9fRL3QBKyM1/wFAEFAHSyJBN+ffnQ=;
 b=dtNKe8rWWmCS3qaiIcGV9ZuEnxFICkCF0kM+caiHrAeiiVst6TxXoJrvzEWCJDwoKWqE9510gy7k0A05uiqVZrr9kNuJu3vaZdiWnIEq/9V1zpaVQ6H3paFU7EB+Kf9LN0K5lNFK2GotN5et3v6yj7j1xZtTRYAcwLISfLfYi3c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 13:17:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3868.028; Thu, 18 Feb 2021
 13:17:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mscc: Fix MRP switchdev driver
Thread-Topic: [PATCH net-next] net: mscc: Fix MRP switchdev driver
Thread-Index: AQHXBevybXvIOkbZDk6j40ceQJbz2Kpd5RsA
Date:   Thu, 18 Feb 2021 13:17:59 +0000
Message-ID: <20210218131758.g4vsvmowggxdklfj@skbuf>
References: <20210218114726.648927-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210218114726.648927-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a7952e2-93d0-45c3-4eb8-08d8d40f9d05
x-ms-traffictypediagnostic: VI1PR0402MB2799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2799C438C8F2B9264529F1F2E0859@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WgD96N8FniBf2Zor/mNGlNNUVv6X1FhCE5/dQOC4DgNhaXIZItbj0DE8l1in9CC0hQ+BpgwRRZF3plfpqsrijEU37b3vhMBOUziB8j3b0FW42/bwcFyGIJxphpRL+7ARpbWKInxMzHOxcCEGIxENoWWvIP/h5+0XTX5iZTmp6a0qShFdV02pqYc6pmTardGjhR5lA76PSQ0T+Q3SAHNrger7wiSxDxDF3CvJy23JiF+Qaio2kD17gcMFuwT3VybFl43nTcZ956TOcjdV5MXJpVn9oQvJBrkZwZj8KdMiGZFgklLKjA7rGRiXTt88BEmTjE54FFGkFk/zg9yxhsAV5uLyBrv5VGbIrmmkXwqTUzcCGiXUHTCR3khA+WmENEt2/PxNr7UMGZZuKCMYUYSSV7USpCEKwpUF3sUlIBzl6m1VFSsDLZwBDj6PLt7K8WkmPoY04rHbKlT5Pl9iZH8PXl9UmhdGEXuQVuUPSg9zHURxM0smj9faK9VL/XIZiQFWBUBbMIEWy/PaiBFQTF5dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(136003)(396003)(39860400002)(376002)(366004)(8936002)(7416002)(71200400001)(91956017)(6486002)(33716001)(64756008)(86362001)(66556008)(26005)(66446008)(66476007)(76116006)(54906003)(5660300002)(66946007)(6916009)(6506007)(186003)(8676002)(44832011)(83380400001)(2906002)(316002)(1076003)(4326008)(6512007)(9686003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?l432vuWsZBEc6/vbgsqO+4i9kGNv8H7upHJhn+QWu9120hua+GCKLbjiyD02?=
 =?us-ascii?Q?K1oNmr7uyzmfTWgGtOZc5GnxKv1ZZotvvP7osyIGIvxEcSufuWg3VSIu7V6g?=
 =?us-ascii?Q?PAhnFPwt9roUuNrel/T70g36zW478CpnuCF9svPZaZM/BKMSieoPfRoli7rU?=
 =?us-ascii?Q?ngt0Q08Br3kl28EsC1YCogNwNDC5EhdYxxWFe8rt4/xi+zQPly/x3sVwjsL4?=
 =?us-ascii?Q?LxR6/HIfYNJ2I2lWgGr9VSse9c/jCkIs7usNmeqYMc+7qX6MBuxNYzCayg4v?=
 =?us-ascii?Q?Ga7igpop5W2kB2pePIUHgT6kNGMm+PzCGSuE8lGKaBtOqNLAZoLCKtziOsm4?=
 =?us-ascii?Q?eapCV0ER6NwypEfiEiOEG6FW1CRDllCkVSFJBJ4m////mAQW+pvEn9xU7KRU?=
 =?us-ascii?Q?JbJwikb/KVQRhsoor3/VS6pg7KoIt4m8KrRFl+6ys0BvvyZH0WlOFdUb9hzt?=
 =?us-ascii?Q?ZfcPR809E7vVQDbemoCoaaMMwIF3HZvATaCRr0KHFv4le/yXtEYmDuL/ylYT?=
 =?us-ascii?Q?2NxMmAZBqED/otU0gl7uzMQivaE26Sl2S9uBnRfVbtm2gYPd8IpLw7eMe3n2?=
 =?us-ascii?Q?yG2KNUKAnsTsebh2kxfv0Uio38uZ22wlKWINAbCLVymvxbAv2tbtuU0IojQN?=
 =?us-ascii?Q?kyT9ToWt6wjkzvHGwn/l6aWBcOyl9gooeNSqoTEqus71kBOU6wcDPK+w5PAV?=
 =?us-ascii?Q?Yci25FQPNwBeZhAz8QDPjXsgy8Vh64UXJjiKozSDk2edLHr+yZww8MdwoNMm?=
 =?us-ascii?Q?mxGCovtuVh2bEP8HXkb79a9mHGb9yLBsOMSHVDGp/L5k7ADX0Qe0J/00Gi26?=
 =?us-ascii?Q?Ls6JwP/Ke/IMjFIoplvgxD/idt3aGl6edvJgVEbibFyvAqcgjW5szW7804Xr?=
 =?us-ascii?Q?Km0A0NtdrF4a7YAsMbHsZvBoicYa0LthN/LjhcxzSG7TPv7GMqbuSJsWPd35?=
 =?us-ascii?Q?1+RbQksFdxtk2enzppw1f243cp48J+XrsJMOKge8C1BVGeaqb+3sLThWes2l?=
 =?us-ascii?Q?ryqpZ8fiokB418ldQ1AK/j7iqmHchKixKNCa9d56nP6RpppyXRyUPiU7QMPb?=
 =?us-ascii?Q?DUfdoc4RCCMKmEm8Sp/8H/XRwNWrKLBEz1ZYBjfn+OT5nYUDtq4oox4Wp+0b?=
 =?us-ascii?Q?fm9Sf7q05/8j9Ck3sguRN38PRmbvnyqjlTJu/aLcqvNgfsNlT5JxDJ4sigtb?=
 =?us-ascii?Q?FFYRQaaZbCzN7w60dqf6Pco2+yCH0iD3AgU/VXLg8DH8eNcQsTzq7SB+u7vf?=
 =?us-ascii?Q?BGmYW0UplKXQPWxw147XSwBJHD2r+e/5KGm0mYy+i9vLMWe4SQ5Y61DRByGN?=
 =?us-ascii?Q?ceUCgwWDZjXnQPHFQunSEEW+?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D29566EF4E813C4B9A3AF704A3E5607B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7952e2-93d0-45c3-4eb8-08d8d40f9d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 13:17:59.5964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zoxQD1bTIbztpIaEK0TvzzWnfKbbscXlYpBfpT7Yw+drGYSQKK/Ygvpntomn40GsfhuWBGnEJc6+rHg6Z2DZ4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Thu, Feb 18, 2021 at 12:47:26PM +0100, Horatiu Vultur wrote:
> This patch fixes the ocelot MRP switchdev driver such that also DSA
> driver can use these functions. Before the driver presumed that the
> net_device uses a 'struct ocelot_port_private' as priv which was wrong.
>=20
> The only reason for using ocelot_port_private was to access the
> net_device, but this can be passed as an argument because we already
> have this information. Therefore update the functions to have also the
> net_device parameter.
>=20
> Fixes: a026c50b599fa ("net: dsa: felix: Add support for MRP")
> Fixes: d8ea7ff3995ea ("net: mscc: ocelot: Add support for MRP")
> Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>=20
> ---

Do you mind if we drop this patch for now (the net-next pull request was
already sent) and I will ensure that the MRP assist for Felix DSA works
properly when I find the time to compile your mrp/cfp user space
packages and give them a try?

There are more issues to be fixed than your patch addresses. For
example, MRP will only work with the NPI-based tagging protocol,
somebody needs to reject MRP objects when ocelot-8021q is in use.
I think it's better for someone who has access to a DSA setup to ensure
that the driver is in a reasonable state.

Sorry for not reviewing the MRP patches in time.=
