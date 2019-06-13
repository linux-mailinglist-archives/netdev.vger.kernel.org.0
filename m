Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB343BEF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732290AbfFMPck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:32:40 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:33445
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728457AbfFMKrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 06:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjH3i2bM4xIlckbh3GuF+zLNX/gGVupy/ZZaR+4JDoo=;
 b=ajoe3J5b7BTleGXKoo1ZQLTJqGCnh9wdLHepOE9L7JxBTEYbYVzomzkdRSZXYJUvM/kIzDZQCGMdVocxK8H9xaQDcfJLp7IfTDQce9DcxkGXAhXPxfG8dn9XqpZn0TFRQvghIOuVl6uzPWZTK/cdSZTqpcWajaaCtTgkxquVdKs=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2720.eurprd03.prod.outlook.com (10.171.104.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Thu, 13 Jun 2019 10:47:05 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 10:47:05 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Simon Horman <simon.horman@netronome.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVFXdSefBuJXwkfU6scW4BRrDrCKaYZxyAgAAMPYCAAOcTAIAACiGAgAAbLgA=
Date:   Thu, 13 Jun 2019 10:47:04 +0000
Message-ID: <0D11E179-7104-4774-8A73-2D10C785512E@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
 <20190613083329.dmkmpl3djd3lewww@netronome.com>
 <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
In-Reply-To: <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [62.214.5.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42ef2b90-a9af-4aa1-c06f-08d6efec79a3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB2720;
x-ms-traffictypediagnostic: VI1PR0302MB2720:
x-microsoft-antispam-prvs: <VI1PR0302MB2720233E019A2C3E5EA6A891C9EF0@VI1PR0302MB2720.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39830400003)(136003)(396003)(366004)(189003)(199004)(7736002)(66066001)(229853002)(73956011)(6506007)(14444005)(5660300002)(256004)(91956017)(305945005)(53936002)(486006)(71190400001)(66946007)(26005)(76176011)(53546011)(68736007)(36756003)(76116006)(102836004)(71200400001)(186003)(86362001)(25786009)(99286004)(64756008)(508600001)(14454004)(81166006)(8676002)(316002)(7416002)(6512007)(6486002)(66446008)(2616005)(33656002)(66476007)(66556008)(66616009)(8936002)(6246003)(74482002)(476003)(11346002)(54906003)(99936001)(6916009)(4326008)(3846002)(2906002)(6436002)(81156014)(6116002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2720;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 45FijjSVqJwvUcMbY4Y8ic0/LgvjeuvPhcWIvoQcRfw+PkT9RTK0KvLDIhca6vYXWVUKV0ArEspca8wkc3kcHxSI/HCBhWP6K7EbAih7WU4cNerWOVsrmDDRxQCap8A2ArmminCS7k10UgfRQlcsKzYcQH4QdXi747IdgU/rjmiJHEvZjXKPUIgwU7Q1uicJeM0G9oZ/SKlcpld3GjpuArCqpmCjDmxGpysYfTLMmHvnZhrkp+c3AcP0+5gZ8o4qIQ33AHtJCzmntB9Ty8zkjUton+b9mLHTM+57iQsPtWHmymwV+D+CzTCZEgf5oiPyLGO5fXl3cjXI+hCYX8+Wk+yAtYR9S6wqMlh74mAZ0X1R2Rwzev/eDOitSZ7eL/O7dE/+FqCnl1kxSremYjsR+k0FuAXBColYwumsAAbV0iA=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_F22BCB32-D153-4DE5-B0A1-DA84C09A7796";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ef2b90-a9af-4aa1-c06f-08d6efec79a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 10:47:04.9417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_F22BCB32-D153-4DE5-B0A1-DA84C09A7796
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 13 Jun 2019, at 11:09, Kevin 'ldir' Darbyshire-Bryant =
<ldir@darbyshire-bryant.me.uk> wrote:
>=20
>=20
<snip?
>=20
> Warning: Not even compile tested!  Am I heading in the right =
direction?
>=20

I think this is even better.  Does it help?  Clues before I send as =
proper patch :-)

Subject: [PATCH] sched: act_ctinfo: use extack error reporting

Use extack error reporting mechanism in addition to returning -EINVAL

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 net/sched/act_ctinfo.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index e78b60e47c0f..5fc1de4d7cf8 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -165,15 +165,20 @@ static int tcf_ctinfo_init(struct net *net, struct =
nlattr *nla,
 	u8 dscpmaskshift;
 	int ret =3D 0, err;

-	if (!nla)
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "ctinfo requires attributes =
to be passed");
 		return -EINVAL;
+	}

-	err =3D nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, =
NULL);
+	err =3D nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, =
extack);
 	if (err < 0)
 		return err;

-	if (!tb[TCA_CTINFO_ACT])
+	if (!tb[TCA_CTINFO_ACT]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing required TCA_CTINFO_ACT =
attribute");
 		return -EINVAL;
+	}
 	actparm =3D nla_data(tb[TCA_CTINFO_ACT]);

 	/* do some basic validation here before dynamically allocating =
things */
@@ -182,13 +187,21 @@ static int tcf_ctinfo_init(struct net *net, struct =
nlattr *nla,
 		dscpmask =3D =
nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_MASK]);
 		/* need contiguous 6 bit mask */
 		dscpmaskshift =3D dscpmask ? __ffs(dscpmask) : 0;
-		if ((~0 & (dscpmask >> dscpmaskshift)) !=3D 0x3f)
+		if ((~0 & (dscpmask >> dscpmaskshift)) !=3D 0x3f) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    =
tb[TCA_CTINFO_PARMS_DSCP_MASK],
+					    "dscp mask must be 6 =
contiguous bits");
 			return -EINVAL;
+		}
 		dscpstatemask =3D tb[TCA_CTINFO_PARMS_DSCP_STATEMASK] ?
 			nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) =
: 0;
 		/* mask & statemask must not overlap */
-		if (dscpmask & dscpstatemask)
+		if (dscpmask & dscpstatemask) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    =
tb[TCA_CTINFO_PARMS_STATEMASK],
+					    "dscp statemask must not =
overlap dscp mask");
 			return -EINVAL;
+		}
 	}

 	/* done the validation:now to the actual action allocation */
--
2.20.1 (Apple Git-117)


Your patience & help much appreciated.

Kevin

--Apple-Mail=_F22BCB32-D153-4DE5-B0A1-DA84C09A7796
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0CKaYACgkQs6I4m53i
M0oDSw//WiaOe1PHHxtZWRJ01TUsDy1l4yrZpM1kPKvlDAwY8aksHQRG5n1Zsrrn
aS5CNmAgQ+ceZh/+jPLzyn/E9udpcPY80i/c09i1gK6sLdsrlsRoymH5XOLW4mIK
0oAP5N2G5qOHmF7PoY+ynYc8doUJwW/al1ZSstb42p1kdECVONRV4gdWHv2TFy8z
Oe94Hu4vyzOksFqVWqmRDiuxxiuQfxJ87O//q8JVd+5ZhczNR2x2Dt/JaRNWoJxI
0cPtHKG2C8dLZFWWUZccHk2Z7wBob72Zqdeeexqi0b2YKa77Ff288XyyuLGR7jpX
4IqzHpaOLUfD27l2/4QrSkRGfxBW7fKFC6kcNoDQm8EBmyczLKGfVkIHcLBFrqT4
cqJnx01FKRNPgENkygVtdlsyH4vtJL0G9CFN2CAxJ7+SMcskTuP/w5j1WQGxCKRz
BDsU+sUFzjemspH5BrpHSOjr6VbkUcWa0/J1ep1nLSSrMeCxIIEGO4boMg2JCu2/
35TbANyiuli5fPSqQDNS8EPidva1uitAsAjeMJFAjofuNzFMle69BdHA8hgtbRSi
c/2CrTMQC4t3IIRDcB0Ie5gkOz1wPJ7JXRBv+baxo0MZMXmQOz33cYOQLYat4exd
YGcb12ISx46MvyHY33w0VkMGlklrkG4KYxR3hmzNZDseq1UjDOI=
=weit
-----END PGP SIGNATURE-----

--Apple-Mail=_F22BCB32-D153-4DE5-B0A1-DA84C09A7796--
