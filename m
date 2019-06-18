Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29649AAA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfFRHeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:34:02 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:60129
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbfFRHeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 03:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQCuQJoayhcXJwpR6zJ4pGL7X6EV+uZSxxMDGN1XHxA=;
 b=BWwJ5E3SfGg9f/GmB2Gsb21NdVFV0tt41ytRuk4PpjVIhUudvFDWgvgQmCAw/woWyRD+eYjzqY4yj3ESqlxB8ITUhkZwnVd8MQKSZZmJ+NYWfAoQTYUSQAiVsGMHWMgGEC80UNg8npF71tfwddYMiSc7EKJP0WAPTuy3MN9xo4o=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3408.eurprd03.prod.outlook.com (52.134.13.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 07:33:58 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 07:33:58 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: sched: act_ctinfo: fixes
Thread-Topic: [PATCH net-next 0/2] net: sched: act_ctinfo: fixes
Thread-Index: AQHVJPP3sIb+WG1BjkGZZ3y2QhtI1aagVacAgACw0YA=
Date:   Tue, 18 Jun 2019 07:33:58 +0000
Message-ID: <808B8876-3E99-4B3B-9E87-0B5E4BD5F57D@darbyshire-bryant.me.uk>
References: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
 <20190617.140106.2136391777805798865.davem@davemloft.net>
In-Reply-To: <20190617.140106.2136391777805798865.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c6d5ed3-548e-4ae3-ac87-08d6f3bf5359
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB3408;
x-ms-traffictypediagnostic: VI1PR0302MB3408:
x-microsoft-antispam-prvs: <VI1PR0302MB340874929D04418612C4421DC9EA0@VI1PR0302MB3408.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39830400003)(199004)(189003)(73956011)(508600001)(102836004)(76176011)(5660300002)(99286004)(316002)(6506007)(6116002)(53546011)(256004)(8936002)(68736007)(2906002)(6436002)(4744005)(6512007)(33656002)(14454004)(86362001)(81156014)(81166006)(7736002)(36756003)(8676002)(305945005)(74482002)(71190400001)(71200400001)(53936002)(6916009)(229853002)(46003)(11346002)(446003)(66556008)(25786009)(476003)(2616005)(99936001)(6246003)(486006)(4326008)(66946007)(6486002)(66616009)(66476007)(64756008)(66446008)(91956017)(76116006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3408;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6C38jw/eQ9ltz/QMq6XXZKIhyO7tqAeBYK2mOC4+TNsdxqdNJcniSp+S7OnfuFkVncyOL2HWReByUBOl5IEX+1EC3JDKc9tLtDKuCASrGTGT/UHJ1NPrP2l8t7tUAPRn6UlDRnwXp+BEwjhi51LWYA2hAeRWiHgL2Z0ffkVraffJtVcCjhmfYFkstrtufp/JQ8T+WWNrpstDFjTcy3cdVUqckXlG9tj7xrfP1tBRcbXFRA4ZpEsLnCukHkfsqPeaXhlvsnEEoerWJV0129VdBuPnIii2J93NFbnMXyuSEW3shOL5Dz5EGXhA3oGNG5lkXFhmCSpIWyagmgG+Uf+F5+m3N3Dte+zGsbsPzshxJjKJ8y1LdKwxJwmp7Kl/iI1QfFj4Cq7m2SFRi0c2MLTYB0PXWnYawyfnasv7X/f0Yqg=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_ED50FBDB-C397-4FA3-830D-88E0CC6CE47B";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6d5ed3-548e-4ae3-ac87-08d6f3bf5359
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 07:33:58.1292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_ED50FBDB-C397-4FA3-830D-88E0CC6CE47B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 17 Jun 2019, at 22:01, David Miller <davem@davemloft.net> wrote:
>=20
> From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> Date: Mon, 17 Jun 2019 11:03:25 +0100
>=20
>>=20
<snipped>
>> If I ever get to a developer conference please feel free to
>> tar/feather/apply cone of shame.
>=20
> :-)  In kernel networking development we prefer brown paper bags over
> cones of shame, just FYI :) :) :)

LOL - I=E2=80=99ll bear that in mind :-)  I thought fixing the code and =
admitting
my incompetence was the best policy=E2=80=A6I=E2=80=99d be found out at =
some point anyway :-)

>=20
> Series applied, thanks.

Excellent.  Hopefully that will be it.


Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_ED50FBDB-C397-4FA3-830D-88E0CC6CE47B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0Ik+UACgkQs6I4m53i
M0oG7RAAkqcEu2brwAxQScAvqhRgKPmxRVtHhYvNiyn0KXiTDrlqPv/STlGeqPu3
7LOXiEv7gXaBORwnWg4z/7gY9cN+bRv2rLNnSDefrP7zV3OCls6V1ftvJ5iMjVXo
vmA55yaZRbRrrzvSmRmAMrTHCwqk+rsXhCN4/GAnvJkeMdDwSXVxH+3lZXbmhMLq
UG6/qj+B6PMUqteU6RQOMSTuY1PAXfF4NGzQwnW+2nnqNmqolZpbT1whi6IwtRJz
bQRTV2gkVWYkn+fOrpuNz6YNelhX4mAuI92koJ1AyVI98cDJdKbq1lgSztcm1xDU
+kzmchFGVQ2ndHCGf8QXogyvo1xYsZ4v1m7+rUYq20LSkOuiCb9tpljNHz7DXQtb
j076dImGlbrBLWr7HtH0UGhuie2D0M05k3Wkjo921FelINZDkUSZsz55Jp1HN/Te
ybu3Yi5cx95wjqP8my75FZI1IETPTJO5UBFvIWuOOgTqODthTg9rD+V1rDWss2hf
C14Y18wrSxrDFuc6MJbk/JAUhTbdWyhqo2szOExBOcJU4pNxxuiyasS3XZC/sSv8
0pQnWm5pRGwjWzsUuXXj4xlkuKq5fpttcQe0UBmefEPiZ6QmPksGTyg6p8sq1WVx
DEFO9K4TZW63lidhIMxF5vglEVvuti0weT4k9oCJ2NTOnAx7TKo=
=7S7A
-----END PGP SIGNATURE-----

--Apple-Mail=_ED50FBDB-C397-4FA3-830D-88E0CC6CE47B--
