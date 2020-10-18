Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1D72917A9
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 15:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgJRNsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 09:48:50 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:45857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbgJRNst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 09:48:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gk0RFZAj4vtIXgCpbSwY9/7hnShjG+0WtQK9o8qBtBXW1sB9nwz+eyHWzSK4bFs7qNkfIVTJKiPbSzC5NlSzcxFHGEzntCD4qkWXM28J74k/6sWMuZKSzv8i+OAGV4jXm864EngIChH5WJNNNgjQwclaaVLWA93BS+v3hsxsphyk/tF8ZKZ9O6DVv4c+mUYJefymBP7Rpmenl6vPcthcg1kPho9qD6rlFq9oM960SPjovoWQN/w4bemCCwn4wGCcPrQaKzB/pOXQKYdNjP4j1kvKBDCELZ7lIDF9BnogVudmO40jRlz+IE5L50E6Hu2smgBww450UH1b9afqbahddg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qab87ksVFT+vBxckvpdrWrsmym1zQMn81GzZt3/WICs=;
 b=KbFMEv25ijPaiL6CyoRBZrevuYmrjrtnQF2/ulGakYBffHWp10wjJyml/l2t25UwtURfjkxB6IvCGOiIK77GUQBev3TpQi8wA6odhAt3wo0l7hBUOIpOybD+jcVk/ATIzLZE2Hdg2HlpbKxqs1OAdZXM6l/BgzjbLJvK6Q3SjqIK3GyMVUwReNElYSXbKvfcg6fKij4MR7eF0drAo4Hgousogjh1zLv9aogYNFAfLHlyIypehENiX8NNIlWutfFmKg7v3MDzrsOKPe+YR1NfNGSaOK7TwimwcIkpvwa2mxy187BNOeAY7WvlF9np69u/NHj6xQwmu5zcl+8/pNhadQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qab87ksVFT+vBxckvpdrWrsmym1zQMn81GzZt3/WICs=;
 b=meCfVzqsHtQZW3Ljg550hb20muauDH8HfCjj+HTJOp+qz9ETcyGewq/32JWGFUVjVGYHjNQkzF0wRRKiF2DDSSZeSdLdaJzFWag76h0t6yWUiDedMHXfG1+r94s2KHWoasPnTmS87IrXcFtl8nuvXcvZvvUAqQ5YPeih9YmMxqo=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4687.eurprd04.prod.outlook.com (2603:10a6:803:72::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Sun, 18 Oct
 2020 13:48:45 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 13:48:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Topic: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Index: AQHWpM2VvXEF3YqeV0mNLAH0H5Z1UKmdQ5MAgAAD4gCAAA7GAIAACvKA
Date:   Sun, 18 Oct 2020 13:48:44 +0000
Message-ID: <20201018134843.emustnvgyby32cm4@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
In-Reply-To: <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2157b44-dcdd-432d-566e-08d8736c886d
x-ms-traffictypediagnostic: VI1PR04MB4687:
x-microsoft-antispam-prvs: <VI1PR04MB4687AF6809F94BD19426A4A9E0010@VI1PR04MB4687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x/U3CF5r5aFQVvOpHwI08JYpqGJKTvxRNmnc4qoMxjNyY77vGp4mhKuLSK5ElSxRYf1KsTDtDvm5uH/G+CgImJK4/mNiLR/GANzxHAm81is2x70MaODGh3qHfiQenii0CNl1bU0aUIuEMnkMHVYUS9+D2gFROCv4YG+OcnE+2l9fok2x8yqiJ81hDCtfhM7RDlL3XFPwv2/zUJfmz1dRBe7GNMrAg9bteUMYt8jrbTIzOx3Bket92OFIbZ8BPmyqpjsc6C0VofFTIXdEIzQVWGgJKj6WoK/Lrr+pBDW3mEyCQzmCzmsuPOXoJe1vtUKj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(39850400004)(376002)(346002)(366004)(53546011)(6506007)(1076003)(8676002)(9686003)(2906002)(6486002)(54906003)(71200400001)(6512007)(478600001)(66556008)(86362001)(26005)(66946007)(66476007)(66446008)(4326008)(44832011)(186003)(64756008)(6916009)(33716001)(76116006)(91956017)(5660300002)(8936002)(83380400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QyJZA2k6Y/K8y4RU3awuyvkfr1CZK0Kd/TAT8iQYWQV8gw3bNQjxEeH3rHL+VjhZlWb7tVAZFyzeRwZhZRc3M3UtdGoh4TQyw/bhpnUPKOxSagwKrOakQKiIOOjm3CQW4icb7jVoC4wjDZ+N2LN/72aP3xwW2yVbh/AwR8lfbHHI09BvMXAf7B9KkBJsuwkb1RaAAQeL5pGCP4CLS1WDOPI6M8ADH4bJmte4xbOUJw+MG41fWVTQP6XrlOoe7SN0hcO1PGKgS5CUeHDDe/XKVv6wyXSQB6llNnG6WeICwG+bgNbMhEMFMSYisFNrsQx9hRqqEBnLF62Qjpw51L4JcC+Y9APHFBjWbsbRlaGxsSz9SXSWkOwVE0joTbIEYu/gJCEjQnRNpb3dD6e0UKHMECKOvB1Ls9tlqxZ8/V/UfpofHoCEiD2qVIp85aYQQT+x6rIP2TBcs8DL7OFgmAE3Qs9KBWL/52BZzjGtOLEhK7eXhduviVm6m3Y8x5Hl4ynL8apDNdgSfE919e0PZs6lvRsYaVbjoB4R/VsqQdLVjTZiZyniGsLFVmxjvyyeFDgxMmpN0NtggBuw+bVkaBefarIzFa7yKijKYD31fiosrP4q1r8gyB8sBvYbUN7JCVuenOjcpbNON84mwcn5L4BwSA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <461F5537458F7D4F83FD112F91A4F893@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2157b44-dcdd-432d-566e-08d8736c886d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 13:48:45.1196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XL3f2+f8EruOJRnKszdVwaqBxeaF4A14bKuYeZaxgzoYK6mcySqDpE22MBB1/XWlaUrMHSmfi9/dUGFpFkkmUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 03:09:32PM +0200, Heiner Kallweit wrote:
> On 18.10.2020 14:16, Vladimir Oltean wrote:
> > On Sun, Oct 18, 2020 at 02:02:46PM +0200, Heiner Kallweit wrote:
> >> Wouldn't a simple unsigned long (like in struct net_device_stats) be
> >> sufficient here? This would make handling the counter much simpler.
> >> And as far as I understand we talk about a packet counter that is
> >> touched in certain scenarios only.
> >=20
> > I don't understand, in what sense 'sufficient'? This counter is exporte=
d
> > to ethtool which works with u64 values, how would an unsigned long,
> > which is u32 on 32-bit systems, help?
> >=20
> Sufficient for me means that it's unlikely that a 32 bit counter will
> overflow. Many drivers use the 32 bit counters (on a 32bit system) in
> net_device_stats for infrequent events like rx/tx errors, and 64bit
> counters only for things like rx/tx bytes, which are more likely to
> overflow.

2^32 =3D 4,294,967,296 =3D 4 billion packets
Considering that every packet that needs TX timestamping must be
reallocated, protocols such as IEEE 802.1AS will trigger 5 reallocs per
second. So time synchronization alone (background traffic, by all
accounts) will make this counter overflow in 27 years.
Every packet flooded or multicast by the bridge will also trigger
reallocs. In this case it is not difficult to imagine that overflows
might occur sooner.

Even if the above wasn't true. What becomes easier when I make the
counter an unsigned long? I need to make arch-dependent casts between an
unsigned long an an u64 when I expose the counter to ethtool, and there
it ends up being u64 too, doesn't it?=
