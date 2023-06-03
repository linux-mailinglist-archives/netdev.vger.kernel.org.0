Return-Path: <netdev+bounces-7611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C92E720DE1
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A58E1C210B6
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0830B1C3E;
	Sat,  3 Jun 2023 04:56:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF1810F2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:56:34 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD184E48;
	Fri,  2 Jun 2023 21:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkDS97pUkZ9VupVEXdSoRpyf1JgpPS5kretAIK75toAk4+1B8aO37goVC58AazXcaKUHyLjqtU1edknYkBW5Q8afv+FYW1Y+h7LerH/n4DIphUAlm5/6rj9EDDQ8fV09Iryofo3SLz5qrLWBmNZqnb86+gngVczEV2JHMvIgJfOxteFxUzzJzF9H3zwQXtg92h4i1XqvogUJ2NjOeOm0QCnU0c3T1pO4h5JN61r34Qcg9Hf2cIyvscavJOE80hs2ZyA5/dcux2555XlCgLD2+9XEmSPIgCOLuLO5ORIDAqJQS9ZZknHuK04BDKMYPXFBfKXgcLx8+MhwP/pX7d0BmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtEy6rdaGKx16yYT2f9hu6i9x5Q/el1Pu0MgIZ9uIuM=;
 b=SJGyxjSG0L7N6sWswMHmHK/ua8rguRO859rutKGOUEoKsarK9kTy00HrPcVhI7QIq8Qz5sBFPsE/ifULBSsiiO9Hw+YViFkSW2f6IYrKgjkt8WjATsBzV8tByARbJjyP1q7UanwcNZAG4gSxsDP+nPoH7SsOxhvtUYExszffQnOTQgdQfOBoDZHpN8UzFYTOrL/zA/SSWodhE5Bd/Df95bWU/jBtymr9M05TKmXZL5vnF741srNIxxbgXHCLlYiRxZZWNHHeTT4A8j5JjOMlAt/4mXWMfabH8/DQ67DD4AfjDJQJvWnKyhBdKgFHtB8lDX/UFyv67hhMU9/RauN09A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtEy6rdaGKx16yYT2f9hu6i9x5Q/el1Pu0MgIZ9uIuM=;
 b=PvG4Li24PvvMYUgPkzgmcHwzDUqVo2UHzgcgdTqcJKtnWCNv2gpNyN24QNggUiLn8AaIdZQvqYamcIQl/W5YsZME9CmVW9h/yYjayMVJrVTEKgxCByivOXU40SSk6ahW+9S84L1PLbpxUt26bvM7OeTlb3NvDt13oxcD4uMfdcQ=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by SJ0PR14MB4394.namprd14.prod.outlook.com (2603:10b6:a03:2c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Sat, 3 Jun
 2023 04:56:27 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 04:56:26 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Russell King <linux@armlinux.org.uk>, Ioana Ciornei
	<ioana.ciornei@nxp.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "kabel@kernel.org" <kabel@kernel.org>
Subject: RE: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZlOeZhHXye15LEk+eN0zupHuzTK93ULkAgAEuRqA=
Date: Sat, 3 Jun 2023 04:56:26 +0000
Message-ID:
 <BYAPR14MB291837DB503BF967249B1F15E34FA@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
In-Reply-To: <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|SJ0PR14MB4394:EE_
x-ms-office365-filtering-correlation-id: 90ec6790-30f3-4a8b-1e39-08db63eee31b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 GG2VraaJlZxN32+pKuZeiL0tgNZL5SrDVhVPLZy9fvpAE6RgTvRpmgoC6YgXFj0SeM5mvsWrukuxlIf2SuagTucGz9zAakorGwdtsozKcl/XmgjcilsoMH2+qQrsO4QABvmtT7G21w7mAXaORjs0LdNTEMCIwRNlfyqYktphuTzHBXEfKKhRNxfKQoWoCO5wPZ45yncIiKLK2CHJRWjWour/n5KvsNg5FDHfl6BImd1Kc+L4OInaE1v/gpGhZzU+JtJesRi8bQ69OC8aeQblbfo86B5rs6nrdFcKFXX9yHv5PjofkQ7qy2CLmtPxTBuDJBXKIzu81GyHya5zEmh8yx3wiy8Mqs8BX6X6pSjkI63w0g8hJ4jk8+11RmrdjCDewLpqPWegYTkvWyKQf5Q5oSs2OvtrnxLBZz4IFFMHuBxBQkriWLLPIZr/lYhZs3VWsfQtrpqgEOsYXOgJfbfOxGWdC5JGTnVr7UgbVg7musPiRRb4SWwrWrPDdIXsm+HcZHocVVTrfJBSCeE+e6v18om3j4A77gLqMTyGmw4BjfZM5RcJXnTD4qpITu3r8sXOipmNh45151M16VkVgvOuV8YoTiAQbF9O8MIKJAk3Ld3g8j5zZSYOoEBcFdny9+QX6d2MeS9o4o9ubMOndx60Zg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39850400004)(346002)(396003)(451199021)(66946007)(55016003)(83380400001)(4326008)(122000001)(41300700001)(38100700002)(316002)(38070700005)(53546011)(7696005)(966005)(6506007)(26005)(9686003)(71200400001)(33656002)(66476007)(66446008)(66556008)(76116006)(64756008)(8936002)(44832011)(8676002)(52536014)(2906002)(7416002)(5660300002)(54906003)(478600001)(110136005)(86362001)(186003)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?eXP6Y7IEpG5D8VzYoEuw6y1ZhPAyVWCRe+k2iuDruc8MLUgAjowBjVznO7Co?=
 =?us-ascii?Q?msJzl8Cv5qIGj0gQoxL7TqI3+cwVMFti1p6dKlgo+kTzW7moVzjLqLnVtSn8?=
 =?us-ascii?Q?uu+AE263yN+/9yOZgKMzeJQ/9883qqr+794w2wTtyWNh2NXT0dvhkXbS2h2Z?=
 =?us-ascii?Q?cIBDVmGLA0PxGRHN4urXbJyMaxkAgafgf0Sn2TCDgjUGzUNo4gRDv/pnlKW2?=
 =?us-ascii?Q?SibUWl2kC99U+MaK8oQeVTdQq6m5pyCnbcwlRjFn6h6aFawVprZSmzpeOXLJ?=
 =?us-ascii?Q?kTjSlG2wa1DfMHAC0SXWtVDBmI1IlbXwYZwqPg5Jfg7/HM1fuQD6PahlmgbG?=
 =?us-ascii?Q?WyGXNhDBG1YiREqzyGRND9bp/y8/PA97Cc3zOw1Y0V8Bz4q4S5TN4kQAdDzV?=
 =?us-ascii?Q?xFNV14qs28uQIqK9Xs15n3ZvYPxgpHBt6f3xI14D3Zlj78XMd1wFHS/Masam?=
 =?us-ascii?Q?EufLwPnOXZcr4isaUTWZYDZLvKn6DCb55xOSqllvBB9zkx0DLzne2LNOfajK?=
 =?us-ascii?Q?t+StlkYoJJ9UTBO+deJk+jACscX5eIWho/aNBJI+lWN+QqJW0OJQNHDjMemp?=
 =?us-ascii?Q?LE6Ow8hyNVyhkAecUbc3nI8JAwVYOSwCpcNkjdncbggWO0+cEwqWEC6aInZ9?=
 =?us-ascii?Q?Pf18a9RYgehtwWy/N82w8lldQoAz5nbgNz9ixm/Cv/MsbEKcKza+BKwcPXUN?=
 =?us-ascii?Q?VNaOBs/AF5CVj2jggQr9roZKBCyXwJQSfN5+aWwkYD6HAGd5Edpl+Anq6Afz?=
 =?us-ascii?Q?6OxsFQwTPe9vUuQbHy+sCI/nwgTgNFqPdh2x+pn0WdqcW/G0KwJqZYiNrGXt?=
 =?us-ascii?Q?eWZJhp3QR0vWhCpvK/CI+ZGcfQVUUhDwdz4mEaWkHEbwRxNKYAxJe9lLz2SS?=
 =?us-ascii?Q?XRJF1yLWKx3xdUghkAo+ncKoJh62RNn9pnK4LN4Sbgv97O42dUPgAoaN8Gzu?=
 =?us-ascii?Q?3nJMvp3aAvWeEKMYWVFPIAi5l91IqZFKqpskzqI2tJfEbxzuCKTEN1abE+u4?=
 =?us-ascii?Q?DQcqXag34ZKFzi8zO0tr60I6rskclyJd4phePcH9Ul3mmzvWbdTwBWovim8z?=
 =?us-ascii?Q?OXHdbdDRMgbq+tYlPxgClmxLQ6K4uPNgICrwlPulKRJ3mnoa5gslvRg2odJo?=
 =?us-ascii?Q?NfRpwpxfkg6fuUtrjTSJ0qCYHeUT9+FEL434QN6DpyzcI9EiyXDp35OPQ+23?=
 =?us-ascii?Q?jCHDWKW03Ggbh/WjGCtsIu9DWqJ/Jw5mEx2Ykoyg3J1Zy03xKF7rR2dZyXdV?=
 =?us-ascii?Q?d1qUrxl+6EZYO2pd/mVVSclbkma03Po5IP8gAlHkESMGte7ine3R0jSEv21G?=
 =?us-ascii?Q?RYWeyo5LWHB6ItRcBCFvgkasdXuCtpuydUgfrvyXwEIxzhf89GfNHA+zumXG?=
 =?us-ascii?Q?2YYh+f65X688QLCeLKGGOHsbrot1v6svxcWz3dCNxVGdjVH7vDOWCw3QRD5t?=
 =?us-ascii?Q?K68qQfBDJg/43EY7rIWdg9Jbbs6qkjthFC4NTG9L2EZ+6PkC/Cg0kfxYk8Un?=
 =?us-ascii?Q?uCZexG8RlNIwG+Z+iBo5afRwNuaFGr0pUqnPc9LcPyefnE18mqUwwboZc7OD?=
 =?us-ascii?Q?gXmce/jB0fDJUZtPSyFMHwGY8t49hfJtFMzobcMX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ec6790-30f3-4a8b-1e39-08db63eee31b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 04:56:26.6380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iOOYlyFppKsWgWpBDKXYc7ts2/xCq76m2sZc9iy/FRY5BHFji7hKDd6hYywsU3wnVnrqwCnNZfgRjLa+IFMRdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR14MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The two registers are not documented in Marvell spec for this switch and th=
at is why my original patch did not have link status code.  I have followed=
 suggestion by Andrew's and used other Marvell hardware that has USXGMII to=
 see some of the same registers and same address would be accessible this s=
witch (best effort attempt).=20
These two registers appear to be read-only and likely are (1) what the swit=
ch is advertising on USXMII link and (2) what the switch received (link par=
tner advertisement).
I am able to distinguish which is which because I can look at the other sid=
e's of USXGMII interfaces which has well defined USXGMII registers.

During the boot sequence these registers show the following:
1. On initial setup of the serdes link (inside the switch):
Status=3D0x00, lp_status=3D0xff
2. When irq link status triggers (mv88e6393x_serdes_irq_link_10g() ):
Status=3D0xd601, lp_status=3D0x9781
3. the driver then reports link
mv88e6085 0x0000000008b96000:02: Link is Up - 10Gbps/Full - flow control of=
f

Please note that Link Partner' MDIO_USXGMII_LINK bit is always 1 which make=
s it useless for catching when the link is achieved. That is why I use swit=
ch's side link bit to note the link is set. However, I can certainly add th=
is to the patch.

My board is based on LX2162a (a version of LX2160a). Specifically, USXMII i=
nterface is configured as follows:

LX2162a (DPMAC13 configured as USXGMII)  <---USXGMII --> 88E6191X (port10 c=
onfigured as USXGMII).

In fact, I am using pcs-lynx driver for LX2162a side of the interface.

Michal


-----Original Message-----
From: Russell King <linux@armlinux.org.uk>=20
Sent: Friday, June 2, 2023 3:31 AM
To: msmulski2@gmail.com; Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmail.com; davem@davemlof=
t.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger=
.kernel.org; linux-kernel@vger.kernel.org; simon.horman@corigine.com; kabel=
@kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> +/* USXGMII registers for Marvell switch 88e639x are undocumented and=20
> +this function is based
> + * on some educated guesses. It appears that there are no status bits=20
> +related to
> + * autonegotiation complete or flow control.
> + */
> +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip =
*chip,
> +                                               int port, int lane,
> +                                               struct=20
> +phylink_link_state *state) {
> +     u16 status, lp_status;
> +     int err;
> +
> +     err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +                                 MV88E6390_USXGMII_PHY_STATUS, &status);
> +     if (err) {
> +             dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %=
d\n", err);
> +             return err;
> +     }
> +     dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> +
> +     state->link =3D !!(status & MDIO_USXGMII_LINK);
> +
> +     if (state->link) {
> +             err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +                                         MV88E6390_USXGMII_LP_STATUS,=20
> + &lp_status);

What's the difference between these two registers? Specifically, what I'm a=
sking is why the USXGMII partner status seems to be split between two separ=
ate registers.

Note that I think phylink_decode_usxgmii_word() is probably missing a check=
 for MDIO_USXGMII_LINK, based on how Cisco SGMII works (and USXGMII is pret=
ty similar.)

MDIO_USXGMII_LINK indicates whether the attached PHY has link on the media =
side or not. It's entirely possible for the USXGMII link to be up (thus all=
owing us to receive the "LPA" from the PHY) but for the PHY to be reporting=
 to us that it has no media side link.

So, I think phylink_decode_usxgmii_word() at least needs at the beginning t=
his added:

        if (!(lpa & MDIO_USXGMII_LINK)) {
                state->link =3D false;
                return;
        }

The only user of this has been the Lynx PCS, so I'll add Ioana to this emai=
l as well to see whether there's any objection from Lynx PCS users to addin=
g it.

--
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

