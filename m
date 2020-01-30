Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBD14D853
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 10:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgA3Jka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 04:40:30 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:51166
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgA3Jka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 04:40:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGClusaOMS5m8BXCuwki6Ky9ICCokg5GxkWSr8N8z5HGlDz+axmhTkGwmP9Ok+6bhXAQ7jz4ZTXXiW22V4FF3v3gbG70gIKzAK/jie1hdeFGxK+a0ma0ZqE1AMe7juJ3JqYC8VHKbOs7vmAek5h2wtXFj+rghECeoWHOBkZFfe42r6EVZLo5uDuKYyoRNp3oPrr5iHuzWn+9ZccBdDeV3RsqaypdgY3FcI8YqGwgLrlcYRWnGyFOooBZ1ZsPFrf/RQNzBDevItoH/pBrgcyX9Km4guMzN6Ru8R9z6wvNQon/9rsEmfcDKsjaMzkWEaDTIlbLhSVdXjHkvQupU2DqsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hliT1ULRZAWOP8EHZkRiRa63bI9yP6LleDRQzojTzI=;
 b=IzaMyAKwvVb6pZnRn9vQsxfckWC2PUaYm96rd80Dh+I1gVlHDQtyWTNGOdrrzP0pzZmkKFi+EbxVf65hPryLHIIDmRxG5ynZsKC22jm/N4vjlF8ThXQ4xOCqj0DIJWOeDF8/rSGfOsGcF6i21ZfxxRZ9ZIq11ho2jSiS3zMgO5ac9CipIkoBWxT7fU3sITpbCEduneOaznEidFu4UvvZuJ3Xb3QenwXidBuU4vXWGxb6oDTI8ix/HzRi9PMF1mND4bM6LlgIEkyY9/B3Yu8O9qYfPWdnUCFPfoTOcdWg/chX8zaQqzyfplxlHOOl6nryMj4O0rRQkmoMZslUeVtXRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hliT1ULRZAWOP8EHZkRiRa63bI9yP6LleDRQzojTzI=;
 b=KrS/iINnvlhwk1rs+/M3KvuJDhoOh1gw2KX4M7cjHV26UxBQ7tG0UGb1qVWr9W+12GQHO861lcM0oyZ4qkMKiP9XSV5xF0gL3Iz/Ee7hZC3YQ+edKsamtZUFCKRLhfP2WNAei9yXHM3DoUGQN4/kYY+YfeJApxYfq3Kgt3C85S0=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6619.eurprd04.prod.outlook.com (20.179.249.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.25; Thu, 30 Jan 2020 09:40:22 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 09:40:22 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXCABvOdgIABdECAgAEnbfCAAAv8gIAABX6ggAA1CoCAAAayoIAAF8WAgAEt/PA=
Date:   Thu, 30 Jan 2020 09:40:22 +0000
Message-ID: <DB8PR04MB69851FA1B8C39481D5B64764EC040@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200129134447.GA25384@lunn.ch>
 <DB8PR04MB698588200EE839607F055B24EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200129153349.GB25384@lunn.ch>
In-Reply-To: <20200129153349.GB25384@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d803e8e-d4f8-4e20-db51-08d7a5686d2b
x-ms-traffictypediagnostic: DB8PR04MB6619:|DB8PR04MB6619:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6619A39D6411FB401E87E809AD040@DB8PR04MB6619.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(199004)(189003)(6506007)(53546011)(26005)(7696005)(478600001)(54906003)(316002)(110136005)(4326008)(186003)(33656002)(66556008)(64756008)(66446008)(66476007)(55016002)(66946007)(9686003)(76116006)(52536014)(86362001)(5660300002)(81156014)(81166006)(8676002)(8936002)(71200400001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6619;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJ0BcomWorACzcKwkZ01JL6GHbMl4ldOZpuqZMYOVRuOGZ/YqCYbK1+8xmBq97NClcd/k0V6e0gszC5yyemyJTr5t1Hmg1sMqjZNJz/Wjji+4QktrjxGCqK3vpt+l6PBlr6GD9aJD5rnj8jiCb8WkdczxyOl8XldrU/PCSU26myiT2CO2UO+BPquenNmYR0RRAOeHb/4rboCZdZ8HFQ0vijSQfBYAz2YC5HFncqEyT638W11sY8VuHgXFHXy9bFEVQWYVzGbCwCIB4JnqotncYJh8ZrntLe8/DHdp5DJxLf+0/L6ydkDffj+BhqvoSmtmq3Sk8aMGu09g6q42uKf6KReEsszT7RIrU8l/ifzjLAWk64tYYLWkezEtBsU0BaWX9V3JzV+tjE3vyykKpmD4FbQxm10FCc7+myGOvO964YNF2ILqLAoMHfB8hGmg1RE
x-ms-exchange-antispam-messagedata: gfqAF8DT4i4DaLjjMBpUo+4Tv6KkaZA6CH5Da1FWbUuWgVBEFSU8j7OaFSAsiNaBezMqbQjjpbGMp78jNBsJMpt9RWCiPWuRYV4AKCRe27i6XCbvCzAT7iHf2vI9dExoVJzegyWYBbxCF2Git/m3Gw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d803e8e-d4f8-4e20-db51-08d7a5686d2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 09:40:22.1423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2gOlqJ8VdKnLRBHXf8Jk1yLW/kJXaIkOFg/txztE+Mfdjn2CWxzSTxNej3LpQaCEi0Nu3oleY2rrn7QBQjWeFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, January 29, 2020 5:34 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; davem@davemloft.net; hkallweit1@gmail.com;
> netdev@vger.kernel.org; ykaukab@suse.de; Russell King - ARM Linux admin
> <linux@armlinux.org.uk>
> Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
> indication
>=20
> > Nor do I need to know, my approach here is "non nocere", if there is a
> > chance for the PHY to link with the partner at a different speed than
> the
> > one supported on the system interface, do not prevent it by deleting
> those
> > modes, as the dpaa_eth driver does now. Whether that link will be
> successful
> > or not depends upon many variables and only some are related to rate
> adaptation.
>=20
> We need to make it clear then that this bit being true just indicates
> that the device might perform rate adaptation, no guarantees, it might
> depend on firmware your board does not have, phase of the moon, etc.
>=20
> I don't like this. Your board not working is your problem, you know
> the risks. But when somebody else starts using this bit, and it does
> not work, that is not so nice.

Indeed, it's of little use if you do not control your environment, this
hint (it's not more than that) can only go that far.

> Either:
>=20
> We have documentary evidence that all Aquantia PHYs support this all
> the time.

There are reports that it can be disabled, so no.
=20
> We add code to read registers to determine if the feature is enabled.
>=20
> We add code to enable the feature.

I don't have a public document for this. If someone has it and can contribu=
te
I'll be happy to make use of the new phy_rate_adaptation_active() api.

> You limit the scope of this to just your MAC driver. It can try to
> detect if an Aquantia phy is being used, phdev->drv can be used to
> detect this, and then you enable the extra link modes. Or add a device
> tree property, etc.
>=20
> Thanks
> 	Andrew

Until someone gives me that API, I will run a check on the vendor bits in
phy_driver->phy_id and get over this.

Thanks,
Madalin

