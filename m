Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44731526B3
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgBEHLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:11:43 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:34118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbgBEHLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 02:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2YmdeYOFeyioi0acX5YPeYbofbRG3ytpIPBxvMPjBLohWMffxdNzNv1bWwvj0IiaUmOw+sdC7sqBfAcom1iVQSBnaLbdo+FHb2S2nDr+QjyQDR/BoMvPUC8zVbrLzoij9IysiHmNOgpbEXXU5dbc47R8FcnsgIRF0aBscSd1BinY2NPsB+uOj0TP/72tULx28nPWvkS8S7o6qzLtpLLjXiJDwUJOQLqR5s35/Vj4VxDhdYxkh+glJMvMHtUwgBVLh8GuqIPlypuAQKBUuvlb8FVpmclrKTwbzbLwhQfLSbcvFHHNYGIQfGsEyKED95NEEQ/lM9gOSrzs59fPGACjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLGrS9QStFVN7Qh5VIHW4t5KN9sy8ViNx0sI4tT9cjU=;
 b=nSy9uTesCMrh/gJdkV7gUTGt2tabiGKHhVPNeqqcVLCOZ4tambI62BrDmus0cKFEZDMOrnMLaF/5TjW2H3Jt4fwYBx9GCHy81mW5jC6XMA49orpUIQW6ATmSOoc6JTWgbLrQDXvKjk6XYE67ewohaWpiVDIx8K3UlFgxUOozjlvKpiaLTGZmYs88GIfKpfdGhy3XlyHBryk19fs7Kyasso6pQOMw3YlwPMXKKxcygWxpaIWTZbvyJSiFpzioEp0mTKiDF9bchatiob4JhRXqH8ViFdLvv6RX3e1x9UHef+NON0LLClDmknSQjMTUC9nev8j6HhZVhs3KeV/1D7iFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLGrS9QStFVN7Qh5VIHW4t5KN9sy8ViNx0sI4tT9cjU=;
 b=BnCjssApr4yVITZPRtaFTN3D3N4t5nAG1HQOevl07lRlA9unjT8QQ8yVDVZNRhuCgtLExigmHFZDaGIwvuU22ufc1q5f/7Y2/8J03LKMZnEaOuUriERHDQxAdnelfN4ftszQwzIkph1qmg8xOQ6qjYworQYhN6Of4cpHIkc5qLU=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB7060.eurprd04.prod.outlook.com (10.186.129.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.30; Wed, 5 Feb 2020 07:11:37 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.034; Wed, 5 Feb 2020
 07:11:37 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Thread-Topic: [EXT] Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Thread-Index: AQHV2EwP/pAQL9rldkeFtJ0S9YjbKagE9kYAgAcVUTA=
Date:   Wed, 5 Feb 2020 07:11:37 +0000
Message-ID: <AM0PR04MB5636F2F01AC234F2F613E5B293020@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
 <20200131162814.GB17185@lunn.ch>
In-Reply-To: <20200131162814.GB17185@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 043b98ef-6738-4662-0be3-08d7aa0aa3ed
x-ms-traffictypediagnostic: AM0PR04MB7060:|AM0PR04MB7060:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB7060F7F6D20BE19434AEDCC6D2020@AM0PR04MB7060.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(33656002)(66446008)(64756008)(66556008)(66946007)(76116006)(66476007)(186003)(7696005)(6916009)(55016002)(478600001)(5660300002)(71200400001)(966005)(2906002)(4326008)(8676002)(9686003)(26005)(54906003)(316002)(81166006)(81156014)(6506007)(7416002)(52536014)(86362001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB7060;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ikn9X1q2GyGWA+yERih8zkvdu7/kU/g0nQsjEFXCe5/AdRWCBvNqGfbyjBd0PNq5h27BUq/ytAsqUOElsH2ybI14kDn9iPWzf1pGLl7Wsix6+Hqv12qdyC+Wf6XvRbbYlX0o+yuOqUZdA7PxL2PYyBQxrDmgQAsuKQM+EUdgx/6zYELZ8eMr7Ni7suDcpKKQlNeAfv0CLvTGhGCLx8N57gLCZl4fdlVLViy+zlGnsC7hDcHHFV1dVWbe+9GsScRdfiSLDp01YYXFHTPpv+EkPPl/J+uQlc2HJJTJ0zdK01qAJUqkWny+lwX0VH0CYbpTPd0QlS2Zo1EcfLPsJhMkcLE8yPJHWDrMiIBK7IJT6w5AT2qm33pnNb5XT2vToveUsCCdj79Q7b4FY4oSjh9HLsKff59zEQuA1EHL2cyIJj30vXRH+GDVNwPdEwubuIVH9++YqAEDWAScqcGOvNQebFX47MUildfT6VD9JhH1ogCvVKIT13coiQy3p56Mc4HSX2om5YyKUASAG7bV+kwP3w==
x-ms-exchange-antispam-messagedata: HnPKpSxv4X4vz+L5FoBgiPK7TG4vF3OHAKJkqDMrHmvPH1RJBGC7mlPJ0gE3EaK//+qrQU4X8Wx2Ql7asmozBjWGZpr8gUdHNs2qZV+qLtj7loTqJ4LiXgjpgiV/PyK1B2FU2SJOMupEtUHniDEYTA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043b98ef-6738-4662-0be3-08d7aa0aa3ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 07:11:37.2101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhx7KObTDmQ8+BWfR+LR0J7CaKZ42q65J79LTSvInrsxZwQgMIjm3hJpKtll2P5VIhDvCn891jSqJEqXbeL6Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 31, 2020 9:58 PM

<snip>

> On Fri, Jan 31, 2020 at 09:04:34PM +0530, Calvin Johnson wrote:
> > From: Marcin Wojtas <mw@semihalf.com>
> >
> > This patch introduces fwnode helper for registering MDIO bus, as well
> > as one for finding the PHY, basing on its firmware node pointer.
> > Comparing to existing OF equivalent,
> > fwnode_mdiobus_register() does not support:
> >  * deprecated bindings (device whitelist, nor the PHY ID embedded
> >    in the compatible string)
> >  * MDIO bus auto scanning
> >
> > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>=20
> Hi Calvin
> no
> This appears to but a cut and paste, follow by an intelligent s/of/fwnode=
/g.

In this patchset, I tried to reuse Marcin's patch which was posted on 2017/=
12/18.
https://lkml.org/lkml/2017/12/18/211
With my patch([v1,2/7] mdio_bus: modify fwnode phy related functions), I've=
 made=20
modifications to this(v1,1/7) patch to adapt to the changes in the kernel.

> Did you make any attempt to consolidate the two implementations?  It
> seems like there should be some level of abstraction that hides away the
> difference between DT properties, and DT properties stuffed into ACPI
> tables?

Yes attempt is to consolidate DT and ACPI into fwnode. Sure, I'll revisit t=
he patch
and try to work on your recommendation.

Thanks
Calvin
