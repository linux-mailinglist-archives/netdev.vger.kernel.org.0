Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7340DBDC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhIPN4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:56:16 -0400
Received: from mail-am6eur05on2052.outbound.protection.outlook.com ([40.107.22.52]:9057
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237755AbhIPN4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:56:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHlowiP9vLQ8V8Os14ANKi9/xNQA9Hc4kwlGzPPHYI+aIvgSBR6kngO11EF4xPKNRjeI2FXMMGtxDjh2IT7F9PWX7jR6LUGfuKWMLhXPoDGBPvxmpezWI/yZJQuce1yr1Oiydiv+kbTFC8QduRZWwJrT0e9hDWhExFDPviRigCxqyzodh/Sknlp8oYsBTyduoRyHMogosiXmammWpSqeMQPgzecu34VlD4g/J+xwwRDPIPSH9rWJh7iDhnDzDKfWRLKDu0U74lULAq7jbJgTcxbBREq/15dBy/duEZzLEEqTs0jLFfFWzK12H2xigkVBYGxGgI6yJ3j1j3jv6VFwmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wlP8+SkcIY6NggW/IxJNa2/2T4iMSLQn2nhyZF10wwg=;
 b=BsVPS0efzE0OEqjy5XdkZqI8mqfLyUQY2xCblLIuN8Znic1Jgb6qUa7y2KwpCAsWE0yRkJWImb2fp/1Xet+s6sbyS4ARieAp7a6sTIDQIkDlbQHbz/6qx/H9eqjVgoVUCWzYUQ+SOlHCtQIAtvgHYbDu+NOyY1xApS7PrD5TZh3ZqTACAmWZWFY3GUtIvBnJ0RgU35RbZ42eHiC6dMlpONOhQr4k0aHWlKTR+Djdgv/YPKe1izPGYCDrA0PySjReZcGe1Kout9slqjE13LTYtCKGke1wZE25U7vdh4v85t4c5nnEP/2i+PXLgxywNvj1k67SefbGXLVQSbtO20kxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlP8+SkcIY6NggW/IxJNa2/2T4iMSLQn2nhyZF10wwg=;
 b=q01d2cHhhXYOzh3BlMfTLFIUxTidukXoDHHvP8HbXIJC7vOgytohZFkYfOtr5CoOGsfrqUsFDyU6wHqhSGh+UDpsv/NlbRPZQznNQHn746ojdJRjuPQ/ICmm7ktUmSAj3EdEX5zauO0b4qYP1C0KkiUIIlShN3bD1QLjAMUd0lo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 16 Sep
 2021 13:54:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 13:54:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
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
Thread-Index: AQHXnbcfxLtpmnYEMEO8mC1+XCvPQauMXriAgAABt4CAGlwzAIAAC9QAgAAA64A=
Date:   Thu, 16 Sep 2021 13:54:46 +0000
Message-ID: <20210916135445.euovk2aelndgtvid@skbuf>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
 <20210830183015.GY22278@shell.armlinux.org.uk>
 <20210830183623.kxtbohzy4sfdbpsl@skbuf>
 <20210916130908.zubzqs6i6i7kbbol@skbuf>
 <f65348840296deb814f4a39f5146c29d@walle.cc>
In-Reply-To: <f65348840296deb814f4a39f5146c29d@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edb993ad-5392-45be-edca-08d979198b32
x-ms-traffictypediagnostic: VI1PR0402MB3709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3709E21193A58C66F4D0472CE0DC9@VI1PR0402MB3709.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hiYKaXu04BBCXpZmVeoj+Ztp7xOmXzawWbocTFO+HbPKBVDleclMHUQkUBEc4Bl7I88yQYJdZKHMqw24QOWZM8M20PDTFHZ1LlmWU9q82/TCdf3Yo6ndvySfNxCbclScrD0FEJ1JbXsk5qiZJV1cdSmyQx+sb5rFpdrkRiIbD/wE0lv8O/s9ub9amF2CeRVntVeQ/jybhotP11bl1O+AJ2G8pLnApiUZgBanbuAMomhq8tAdby1cb0XQ0AE2FpkHS61nyLOfQI9l2urMk5YGNXQnnCV0Y+NHxGdseuc71pyLVUbphf2xsbwbV5ku+yPZHAm8ClUS3thbPo+3RVjqAbcxx7dtjSGNZDHy6zDfxuIJe6cbOe7oscv3C8WPpiqHaYi7GkMYYGPhANYG4OkkSLbDqQ9Z1PauVhNNrV9tawetYxpSuV05TFe3STY3zjS2tYClPWR9/doW6mUD/7Ryu6YoXAW/wEJuEz2qgYGfdkjgFbT1YXGGEeYlXwKx7S/ncCPZ4ZZTWEW2n2QVWVkaU5glHegt/XvJmVrUpH59BbgHXOmrxSGfRQJiGn+BMvVfOnM2CfQ3kCnIonaAJfC0oMfyuwNxtwHLR6nh4L7LVQsAILKXHcNExU568j/UbMqunIFn7bhbP/RtHrIR9/LHpMLggS3X3Bkkd1XjaHwGjD/p5K4HlPPVNvC+FiTnh2NKo0SML7AR4eBjpE9BYw/TNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(186003)(91956017)(76116006)(38100700002)(9686003)(6512007)(26005)(122000001)(83380400001)(33716001)(38070700005)(54906003)(66946007)(66476007)(66556008)(66446008)(64756008)(316002)(2906002)(5660300002)(7416002)(44832011)(6916009)(508600001)(86362001)(4326008)(1076003)(71200400001)(8676002)(6486002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S612QhExVlM4RXABwLHdJer8lo4/OXr8287iiZpMnXFOAu8yr0qwfsrSHleI?=
 =?us-ascii?Q?wmi6EnXVTdVWr9a2pacrCiOD3T+qll8VikQUsZ6tT6wDqTXEpYBub96E9skT?=
 =?us-ascii?Q?uqf/AWwqEPVRQ6WLo3LRd2GagPR1x4f2HxsYvZYR94rNevNudoHK4xIL8Ecj?=
 =?us-ascii?Q?jV/uIG8Jd5qdWqsCd3EFKeuhJP0GzXhsrjaGZnL/RVNNHZtSdf/g1jmxEYdd?=
 =?us-ascii?Q?6LEvtix37o3qpYiPm9nAlT35kRs6wtUKMONGKlTAikjvZjPW7hAtR5yS0/Vy?=
 =?us-ascii?Q?XBNbJpuXESE87XwywqcotDA2YWjIt/AfM2nZwlU8KTrJBSMXQPrWFfTrJ7Ip?=
 =?us-ascii?Q?F1HfoAeFCL/2uMdO87az9RXs0t6XAooTsOVatbQr9PdeYo3brg+i1fK+Ifge?=
 =?us-ascii?Q?d6U1xSp8LNZDorPMZsjxd15JM2a57ZqlpX1vDaGKqTr514Ge8X3L13bYkDz5?=
 =?us-ascii?Q?A6iA5vAOt7gXNW3BOManP29LZ0D534FTb5u6s4jvBVRnS2WxFCLABbInVS8l?=
 =?us-ascii?Q?gJi7PsKNNWOGigVTb8rBRaN/rBav9dhfldf/Kop3hXbF+17Y7Hc5aofVjUbv?=
 =?us-ascii?Q?83o2snDyryteDbtpin1Gyu47P2HLrIJ08hyAKFaBYc5JGjfcNYe2WRNh3YiB?=
 =?us-ascii?Q?U+hT7dN4Ym0T//PPkUOuLGIWH0T48MWWBXACI+pSGqEYPVxiJ1V9FYG/a+al?=
 =?us-ascii?Q?M/mX5mRDD07hW0mA7C5GxnJ3M23v6yDrdvD+tnQ1WaKc3OO/KhL/PDQl4Qx3?=
 =?us-ascii?Q?dnGBA/nmNY+4K9Tiox/PaCFS8Jk+usfNyB6dx/7AzQXabAprOAL61tCxxvfS?=
 =?us-ascii?Q?xHWn90pdoapxV0//4rr142oDJa6ug7sTUWB6DjfLWKoRmCpfJEfkLTF7z5Px?=
 =?us-ascii?Q?WvAccSlv6vrGkdkR7YuqLNo1QwHLTiGJ/dmZXDVDbkd76g7X3wzKfoT6LaT5?=
 =?us-ascii?Q?PDXwLVvyG7gOcyatZHQWF4J0Pfjv8+vD+eC7CnKyimcNHkR1upd6JizjdOQ3?=
 =?us-ascii?Q?voCyMZvcYP4NmwJNXk16kTJRsXWM5PF6t6RBDnzSC6Ans6insZshHl8kkTIN?=
 =?us-ascii?Q?QR3Kc+Ay9myd9gOnl9gpiIOIjaBvZU1sfIVAJhaePMGWj/zuX3FvFojppKn4?=
 =?us-ascii?Q?aAAAC5jLkQ87APaBbI44tRRU+mZe9LuGaJFoaIaKFIXBgLse2ukpLliMIflm?=
 =?us-ascii?Q?31Nh39JrqIgCZP+rXTZfqZH75lrMWaFEcJD9ZHILswv3jyn/gYro3NNjAiyz?=
 =?us-ascii?Q?wRxv6okU/D9oL7NsRpcQ0U9J284FKhsYN5Xu61rH2ArAsQ9Bec2dIVEuOhip?=
 =?us-ascii?Q?ye21vWu/DBajxRpn9ab0R4ER?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BA333963CEEF641AED01937882F5BB0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb993ad-5392-45be-edca-08d979198b32
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 13:54:46.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QKEx8V0l+bRiVnBi61wzjuhkqPbG1eNTXbzlbnBEIr1NzoMkh82p+oUe1y+qRsFq/3MgjJ3KaqQJQ9+wHZhelA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 03:51:28PM +0200, Michael Walle wrote:
> Am 2021-09-16 15:09, schrieb Vladimir Oltean:
> > On Mon, Aug 30, 2021 at 09:36:23PM +0300, Vladimir Oltean wrote:
> > > On Mon, Aug 30, 2021 at 07:30:15PM +0100, Russell King (Oracle) wrote=
:
> > > > Can we postpone this after this merge window please, so I've got ti=
me
> > > > to properly review this. Thanks.
> > >=20
> > > Please review at your discretion, I've no intention to post a v3 righ=
t
> > > now, and to the best of my knowledge, RFC's are not even considered
> > > for
> > > direct inclusion in the git tree.
> >=20
> > Hello Russell, can you please review these patches if possible? I
> > would like to repost them soon.
>=20
> I planned to test this on my board with the AR8031 (and add support there=
),
> but it seems I won't find time before my vacation, unfortunately.

Oh, but there isn't any "support" to be added I though, your conclusion
last time seemed to be that it only supported in-band autoneg ON?
I was going to add a patch to implement .validate_inband_aneg for the
at803x driver to mark that fact too, I just didn't do it in the RFC.
That should also fix the ENETC ports on the LS1028A-RDB which were
migrated to phylink while they didn't have the 'managed =3D "in-band-status=
"'
OF property, and enable new kernels to still work with the old DT blob.
Or were you thinking of something else?=
