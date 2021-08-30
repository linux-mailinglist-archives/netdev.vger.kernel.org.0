Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B433FBC8B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhH3ShV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:37:21 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:34681
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229817AbhH3ShU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:37:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RK+hfYJ85592ezUJttcynjDQ02JY0FN+UHoZySJwL/mRQEkNYQ3f6WysoiiRUWTyFvOZfnItdi3poycuQgr+IkRCge4mQn9pmrXK/EkLABaI0OtHNBkCELDItB1SfK84yZe7XCqbvOAPSatmU9DojRjBl7P9ezfJ571kp2vpqG+xERevMPapeguzP1DJSmme5mHKLXtuoRM10bMzO3MTnCyrfMKClF+mP5Ak/NVP4x0VEoqzzv89asXE5uWiNFD7Nzs+j9lCL30vn+he721MBVex+aiZMjq+BVa1QJ+d5gxDhLmYFYpzt+unjAAsjh6ZtqbUep6nFLhbh9pcCHn8Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOI25+3pmeOcBwetQFYPtbX+NITfZbqovqAdwDq1yqE=;
 b=IM60msQNb8DO23mImUku9rsgEEGFeSMXILA69SLD/P68rO3BSmd7hYpw3+VTs+Tll7PGWyOqY8bBSp2HgZEXkwwMFnocfd41uQWwmZZ6vGUxTdmvmv0QR3fYkGhTQ0hw6FtLg3yv7AcgZjKH4xUVYjZbaclTe0YJ7yd4pRHSHQ0bkQgtDCzDRvkWC/Cbnfvtdg1pKY1yeLu1dLPuo918UBlXdIHzHRQQlKitFrT8wto/MgeeJQeiT5Ahm+HG2krQXXpHUu2IjvyZWkMFHxE/0YvJgVP4NWAPvsRxm8j7CHoABUS9rbe0SBF+RK7otgE7iO7ERfy0IXSrjJmhoTpCXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOI25+3pmeOcBwetQFYPtbX+NITfZbqovqAdwDq1yqE=;
 b=IF+Vy4aXA+rlQYnonOV6NhxvzD/F6O9LOXXQ1XaT2i4mbJUpANyHy2MEXSVl7JNHeabJI2OX3bwCtKNDXd8g+x69UtVB/OF3Sqof42Ei0Wh+jOOx6iR36xNpw83kuSsh9i6mweMw4c32119eIMFMp5dches1eTpb4II0FD7jla0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Mon, 30 Aug
 2021 18:36:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 18:36:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for the
 PHY
Thread-Topic: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for
 the PHY
Thread-Index: AQHXnbcfxLtpmnYEMEO8mC1+XCvPQauMXriAgAABt4A=
Date:   Mon, 30 Aug 2021 18:36:24 +0000
Message-ID: <20210830183623.kxtbohzy4sfdbpsl@skbuf>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
 <20210830183015.GY22278@shell.armlinux.org.uk>
In-Reply-To: <20210830183015.GY22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f5e1046-a28f-4780-5e51-08d96be511fb
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3616D26ED225A4CA86B5C508E0CB9@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PKHWr6XAOnvWB945NjrD6Npnar2CS4b+DDaSvrbJ96ECA/lONFEFhwlSlNxM99oC3Uq6Cc3kglYmBGLlig0daFlJ3xPEj8QfUiPgtile9nHJfOPl6/BH62a7yukt73H3uBMJClziBDU5Qo9QSHCBHiaGcep/Szx2BZUKBTYUMDKzLfzt0Aiac1CWfga6neCs6H6RZQbxLpir/qbYUUYAkbN/z0iXdGweDglWGCiaefvzviHGXqcmbO5XE9c6SlDLYeGJDsBLCuoXqEd9HNFVBuIjWsUWd2ed91kl2WekDQDMTdI6qVKhZVDWuglTcdlbFqATuvu599LrFvkcbITavwbWytaY0cPMF3nhu3kfEg5HoawTR619G60XT7Nj/nFdmDYABoIoQvmZFWafkJv9d8c3QheQ5+FlszCk0J8DecdJvRsqnp3R2/F0aZoC9xOsm2fqR9GmASK40Lp1gjppShQQ0VrkcXbA7/AafS9R7tqIH+iJMzHnKfX6h2X2kZ3Z8N1hocidK2DKDIOvb1w6KGqx9Fm1ZIVApQ9/9Yvnc3TUse/JqkoFLKjrUz3126ieCdsSmuSYUd1UdRGKQSPTe7E/cttC6FMnpKVzRbfFPAhKDUBaStJNgxA7pa3LRxpH1TKqtSiMovHTJ/d7wmBBIGdkoiiABkcst6O0PUV7GWcF4UfLMGPCaSe6qRJHvKDqJjmGItQ+nqmkZFTnJRBwXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(376002)(396003)(136003)(366004)(71200400001)(66946007)(8936002)(2906002)(66476007)(91956017)(86362001)(4326008)(54906003)(186003)(76116006)(8676002)(66556008)(64756008)(66446008)(316002)(38100700002)(5660300002)(4744005)(6506007)(44832011)(1076003)(122000001)(6512007)(7416002)(6486002)(33716001)(6916009)(38070700005)(478600001)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kkza9M5VNPhl7s7F0tL1d/GVrtrp27fHfK0oWe+HGvUqe7biNZiVnDt5gZoO?=
 =?us-ascii?Q?H+PF1x2dDkTY2UqWJk+ZKx9CQloElDDLCvlidgveKZuSbJcPuQ1WD2B45Z2j?=
 =?us-ascii?Q?BOYgKHpthrRw84jbCFUQcyTbNnstfOSxfGU3NnAyewNqz4nB6H7z0JYTfNwh?=
 =?us-ascii?Q?NYQX1pz58vruFO6FQ7mHygOOlI4n4nCc7dNr4qacxlMjLZ22MnlcaK1jQdzu?=
 =?us-ascii?Q?BwOzHr4MRKZ1PHYoaqFkQb958iRg2FHmTmGiQkwrT3WzE9uv0vv8QL4OWmzU?=
 =?us-ascii?Q?HSnD8pfEKRmPIYRje+KEzdRo4u2tfBbE9n6zk4UegOPHbouVtEKl2IW5R1tM?=
 =?us-ascii?Q?f4m/6qcxvoN4WsDxZw754uXfheyDF2WNmMJ9eEm9mB622ZwOqJ6JK0vbZ++J?=
 =?us-ascii?Q?8eKKYiNJiLKuJyFBNSm+NlQPcYIBpjU0gCmoHlRcaBFdDuF+c4FIvHK3Zy+M?=
 =?us-ascii?Q?VHMgBEkaToE7ALaSqL9XsT6dVcOXIeD+oKRJmXANf0hJ1O4gE5H3a3Y+3X73?=
 =?us-ascii?Q?xTgPluR2w8cRYYbSHfAm0Ay6ZaW/EPyTmIcGRhKKsDj8hg6FLq9OSnwXX7dX?=
 =?us-ascii?Q?BuCulrgTzwBV/jvsXloGGb+FBOzkRMqZMS9olGa1qdofgmvYJgyyk9qptITO?=
 =?us-ascii?Q?nHDYUZF8CP60H1KTdR9wCb0YFAnl/EhBbbqHSq9QRQ1VepL7/KgFnjoDM6cI?=
 =?us-ascii?Q?LHaOkvp1wrM+c54K5gxgqlzS6bVS1DyiTDxd0D911UeuDcvD7wMiqEdGf7My?=
 =?us-ascii?Q?qvqVyATQwmCxLYONafUudAKBSiPbfplE4DWLsFwFFfDe+eKeX83muBn/VvDe?=
 =?us-ascii?Q?68HAlLrqc3+oSpV8gmQNE9ilCqH+yg2umQWuhUvGxRtjIw2SjA2xvjLoM4FP?=
 =?us-ascii?Q?Dk0lDLNDP1aOrA7ghoY54/l2uypBtC8j6t46dQokBpDcXoj34pg3Bp1EyiS8?=
 =?us-ascii?Q?TgsXvKX/0cMctobaOZIRcRnj/h31pHrOv6ZJVt3e3rIY8QHiypWqvWc0L1hj?=
 =?us-ascii?Q?+IrRRU6D/41FA7KXYfheKUl25VaKlRZ4+oHAWRyibHHcq6LZCScaN74xpBn4?=
 =?us-ascii?Q?wH1t+IrLd8u4YsDtoP3VtD/GzpbXgjcxOwzL3DhHwU/XHw/CJjJBjG1O77Pn?=
 =?us-ascii?Q?Oq6sJKoMD+CtFyPB9A3yI1JPE7FndBD6dOYSKP+mL8k41R+y2/8/qKSdBhDm?=
 =?us-ascii?Q?pFyCfC4cTsfGSul/CeuviGi4tQMQwTVKsR3D8aL4rGlI9rXPvBfYeipY9U5I?=
 =?us-ascii?Q?yigqpsYRLKwcBC0/hy5WCWhzLspsTL2y8p2ZJnSmzGKTeVk8VZhLCR8t0xK4?=
 =?us-ascii?Q?PDWnrqHk+ZJpvhlX17Mtfh5z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB1D6325DF184E4BB593199098A5793A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5e1046-a28f-4780-5e51-08d96be511fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 18:36:24.1535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JaPlk3AG04WlEx5kUXNEr50rZk4PmRCQEBmMCW0ywIigFMCgPhMAmDXdENEcKZfvY5t0Ftt08CyBUc12526pEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 07:30:15PM +0100, Russell King (Oracle) wrote:
> Can we postpone this after this merge window please, so I've got time
> to properly review this. Thanks.

Please review at your discretion, I've no intention to post a v3 right
now, and to the best of my knowledge, RFC's are not even considered for
direct inclusion in the git tree.=
