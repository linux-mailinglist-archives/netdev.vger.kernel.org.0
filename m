Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442FD14C92C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgA2K7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:59:52 -0500
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:3937
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgA2K7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 05:59:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBPudj8s+myavckyHeMQWUdNYmcfCpFKnuPK2/Yiho/mwcKyTtPv/k0p9CBywq/EBJJPl3tg83VUSVjreqb+hJBHIJfRi+YDCAMTYXg1vcA1fdio8FHxm+PxId9/uHm1jhiqsqc+Np2JhUq4ikWhzQSVoCW9B5QUfRp0HFcpiBSik4i84QpH+kOtv69PWXIJvP7OpOwbGjS3Xhxdo1HiovWOQ3jpt+/Rq3UEYtmHcdAdqy63Kzm5gT69CzuXDa9AiG224+Nm1JKOm06LqplRWQ3zbu2xYHgvmGumFFXAKXnwyAGuoE6mhhCRBvhynxN2EQohYOW2OHTqrpJIJ4xC+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mE/O4hic+CSKmk+NXiYfHmKEkZDOtOgUNa5Kfv/eE4Y=;
 b=djKM3CFgv55BveV1EIzTQC8Z6es1eQNkdiiDisLtEfBn4R+Cp8vchAZ77B3DOAnM8Y8bS0i74yBGNoTDjHAybMGAc+AUbE8QFbESo4Cxx9sDGrBOOAbsk2AQbCzrFTgVWtJDvazqAU3/lRhnMPkswzp3y4448F+r0isWwOoIF4KlmEAdmuYAue/IgMUgh4ZXX+Nz0p/0xgsMqjFHMl0QeCPC+Ih4iU67KlFaoWBgSv3ppWDrIn/VeS1HEX/K2rsHC6L+YSjTv0q0UeftAoy914/FqyontVVBQxDUbhXoR37OEwa+4/veKfvb0r2g+QVsHOBcykm7g79VsJT49AcoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mE/O4hic+CSKmk+NXiYfHmKEkZDOtOgUNa5Kfv/eE4Y=;
 b=KUJDovHaWOoa1N7D3kzFBLHUZM8im8/1zgGNg8RhqKYeR39sawOpe7YQKpp5eWVPUlPHMuG6v/7pofxYk/glqZ/S+YGrtISIh0sVj9v02jH62fkP0yjREJ5p8gn80hqxRFPXvfs/i8ld1hmq6mOVfqoeSt4mqsyv9KjNwSC1/cs=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB7083.eurprd04.prod.outlook.com (52.135.60.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Wed, 29 Jan 2020 10:59:46 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 10:59:46 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXCABvOdgIABdECAgAEnbfCAAAv8gIAABX6ggAAGKgCAAABwsA==
Date:   Wed, 29 Jan 2020 10:59:45 +0000
Message-ID: <DB8PR04MB69850140BB3EDED3EF3446E0EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200129105700.GF25745@shell.armlinux.org.uk>
In-Reply-To: <20200129105700.GF25745@shell.armlinux.org.uk>
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
x-ms-office365-filtering-correlation-id: 0921a496-708f-41da-97df-08d7a4aa5a27
x-ms-traffictypediagnostic: DB8PR04MB7083:|DB8PR04MB7083:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7083B939E5ADC3D3BD6393FEAD050@DB8PR04MB7083.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(189003)(199004)(478600001)(4326008)(26005)(966005)(86362001)(5660300002)(9686003)(71200400001)(55016002)(33656002)(2906002)(7696005)(6506007)(81156014)(81166006)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(53546011)(54906003)(8676002)(110136005)(8936002)(316002)(186003)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB7083;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xYwsfYrVeel72xdpKgRaAt3UAXyVT/EpzaZyFfW4wtUJPW+6k7MkdMiL+N7bDVigc+zVFi3BQI6GqxuYVwvAgZxOwdNHFQcpFoO9sfAGe+yrDX9FYbXZfULmPCnP82hIX7JV/p14CggyIzK0dz1yZSperwLL7V5fud7s2W/SVnWNOnUUr3nEKJUzOqlrkJxwQljPCy3r0aSauj66AZkQa9Tw/m0hne5/gPpq6WFiV59xztL+2uePPnvglZI18Zs+WKsh5MVsH8DdfevP8deu7cT4OEvbdsVNqlUDGg3u/xcAqFB+/LkVWEH8LU0md1WsOrWY8R6HQhB/T6LkZMfdvKteFQHtqMGVuILaXh++VNola9PH2XKltIletEYJ37FuxIDFhQQwPy80BhB++rwlnMd4vrVFqxp8621n3A6vniGlSrXK5g/Mhju8zEGyy+9m3XHDGjgXUtxxTW8oGldsrIKdddjMcwZZhyAwM4Vh30rb6DkBELe3vPRvlpCX5RDRUIsJkGix6aUmFLPYc2jIoQ==
x-ms-exchange-antispam-messagedata: QGzNGqpKM2qoXpQPJKsa1Qgzsp1PjUb+IVpgUtsVLeLQxnIxxsCY3YzIt2oD+2LQkRdAIBt53x17Y6+VSnWZyr7yBKcOvK24G1BjX0AsphbVQwj8R3+EMqJlafRX6oE2EKyvh7CNfbxVqR5a1GnxoA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0921a496-708f-41da-97df-08d7a4aa5a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 10:59:45.8830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gQO+jBLAlm2wePJlFejAw4jkDdytR//xuSlbQ7/fy3/BcJnU9qO6ONhXd3S8yLw9Uugv5zuko2px66n1lSkfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Wednesday, January 29, 2020 12:57 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; davem@davemloft.net; andrew@lunn.ch;
> hkallweit1@gmail.com; netdev@vger.kernel.org; ykaukab@suse.de
> Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
> indication
>=20
> On Wed, Jan 29, 2020 at 10:53:03AM +0000, Madalin Bucur (OSS) wrote:
> > Meanwhile, a real issue is that in the current design, the
> > ethernet driver needs to remove modes that are invalid from the PHY
> > advertising, but needs to refrain from doing that when coupled with
> > a PHY that does rate adaptation. This bit provides just an indication
> > of that ability.
>=20
> That should be phylink's job, not the ethernet driver.

I'm not using phylink. This pattern is present in most drivers that use PHY=
lib.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
