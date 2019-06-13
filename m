Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9616043EB0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbfFMPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:52:25 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:58688
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731640AbfFMJJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9dd/3cYYbQ1beqyD/Ki+zGQnJTgIFhgIyj4IJoBn8Q=;
 b=B07mIcPzyS2asc6z1Ce5e9HeJtvJKEqIGsXIOeaC3O6T5ASx0cAXhizZDu2cL36Ga5gdbsKKz7dTfTp/rdTiGcT8+cC986pIGu0lawCIfZmYCPrx2J4kUQVbo8OvyoOQc0NkpyBiAb5phckEf0f+l0bTTCniDnPvN0/+KSOY6zE=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3199.eurprd03.prod.outlook.com (52.134.11.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Thu, 13 Jun 2019 09:09:47 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 09:09:47 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Simon Horman <simon.horman@netronome.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVFXdSefBuJXwkfU6scW4BRrDrCKaYZxyAgAAMPYCAAOcTAIAACiGA
Date:   Thu, 13 Jun 2019 09:09:47 +0000
Message-ID: <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
 <20190613083329.dmkmpl3djd3lewww@netronome.com>
In-Reply-To: <20190613083329.dmkmpl3djd3lewww@netronome.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [62.214.5.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13c22459-a309-47ba-9961-08d6efdee225
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB3199;
x-ms-traffictypediagnostic: VI1PR0302MB3199:
x-microsoft-antispam-prvs: <VI1PR0302MB31996318F59B7BDB7F9AFE22C9EF0@VI1PR0302MB3199.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39830400003)(346002)(136003)(366004)(376002)(199004)(189003)(53754006)(25786009)(99936001)(102836004)(229853002)(316002)(68736007)(305945005)(54906003)(71190400001)(26005)(71200400001)(14454004)(4326008)(508600001)(6246003)(36756003)(86362001)(73956011)(476003)(11346002)(3846002)(53936002)(2906002)(66476007)(66616009)(76116006)(66946007)(7416002)(14444005)(6486002)(66066001)(74482002)(486006)(66446008)(2616005)(446003)(8936002)(6506007)(53546011)(76176011)(6116002)(91956017)(33656002)(7736002)(256004)(81156014)(64756008)(186003)(5660300002)(6436002)(6512007)(81166006)(99286004)(66556008)(6916009)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3199;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +/H0VUz9orLaZ/vBQpL3MOnoLV108HdOUUPdn7anAkSY538yXzIzJKJ+bbh4++nw4AYA7H31wrDP3PQXAz0foc05pv8ByhuNpoNpw6wOOl7INEXaHNr1jr0XyZpd4iAqbOeZn1XKCQKbXsN004xzN4HGfnlvqsqqP0Y62dbCpFeqQWgmOmqwgVZITvNUez8O/i/jL8+A2FamS6OOCA4y2gKmN0v5kwrFuFy5wv0IC4wJHXDaNJqbg5qIVfUCq1HdZjbg2bBYgEJ5qfsVO5atPq4Mdj/3nFarKdGwWfB+Aj7S0kixcm/ZOxCAmrFwX72uzLLvUo6R9GDZKo5e7sFMgepYZRuzJaTM+yrJJH3h6j7EJd/vtyQIGdT8dLvO4kBmT6ROrrbUEnba4THErp3SBICw1sXiE0FXeg+I6gM+84w=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_8034A46C-83ED-40BD-8EE8-62E1515346CD";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c22459-a309-47ba-9961-08d6efdee225
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 09:09:47.3425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_8034A46C-83ED-40BD-8EE8-62E1515346CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 13 Jun 2019, at 10:33, Simon Horman <simon.horman@netronome.com> =
wrote:
>=20
> On Wed, Jun 12, 2019 at 11:46:27AM -0700, Jakub Kicinski wrote:
>> On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
>>> On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' =
Darbyshire-Bryant wrote:
>>> ...
>>>> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>>>> +			   struct nlattr *est, struct tc_action **a,
>>>> +			   int ovr, int bind, bool rtnl_held,
>>>> +			   struct tcf_proto *tp,
>>>> +			   struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct tc_action_net *tn =3D net_generic(net, ctinfo_net_id);
>>>> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
>>>> +	struct tcf_ctinfo_params *cp_new;
>>>> +	struct tcf_chain *goto_ch =3D NULL;
>>>> +	u32 dscpmask =3D 0, dscpstatemask;
>>>> +	struct tc_ctinfo *actparm;
>>>> +	struct tcf_ctinfo *ci;
>>>> +	u8 dscpmaskshift;
>>>> +	int ret =3D 0, err;
>>>> +
>>>> +	if (!nla)
>>>> +		return -EINVAL;
>>>> +
>>>> +	err =3D nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, =
NULL);
>>>                                                                      =
 ^^^^
>>> Hi, two things here:
>>> Why not use the extack parameter here? Took me a while to notice
>>> that the EINVAL was actually hiding the issue below.
>>> And also on the other two EINVALs this function returns.
>>>=20
>>>=20
>>> Seems there was a race when this code went in and the stricter check
>>> added by
>>> b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
>>> 8cb081746c03 ("netlink: make validation more configurable for future
>>> strictness").
>>>=20
>>> I can't add these actions with current net-next and iproute-next:
>>> # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 =
0x01000000
>>> Error: NLA_F_NESTED is missing.
>>> We have an error talking to the kernel
>>>=20
>>> This also happens with the current post of act_ct and should also
>>> happen with the act_mpls post (thus why Cc'ing John as well).
>>>=20
>>> I'm not sure how we should fix this. In theory the kernel can't get
>>> stricter with userspace here, as that breaks user applications as
>>> above, so older actions can't use the more stricter parser. Should =
we
>>> have some actions behaving one way, and newer ones in a different =
way?
>>> That seems bad.
>>>=20
>>> Or maybe all actions should just use nla_parse_nested_deprecated()?
>>> I'm thinking this last. Yet, then the _deprecated suffix may not =
make
>>> much sense here. WDYT?
>>=20
>> Surely for new actions we can require strict validation, there is
>> no existing user space to speak of..  Perhaps act_ctinfo and act_ct
>> got slightly confused with the race you described, but in principle
>> there is nothing stopping new actions from implementing the user =
space
>> correctly, right?
>=20
> FWIW, that is my thinking too.


Hi everyone,

Apologies that somehow I seem to have caused a bit of trouble.  If need =
be
and because act_ctinfo hasn=E2=80=99t yet actually been released =
anything could happen
to it, reverted if need be.  I=E2=80=99d like it to be done right, not =
that I know
what right is, the perils of inexperience and copy/pasting existing =
boilerplate
code.

Looking at other code I think I should have done something like:

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index e78b60e47c0f..4695aa76c0dc 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -168,7 +168,7 @@ static int tcf_ctinfo_init(struct net *net, struct =
nlattr *nla,
        if (!nla)
                return -EINVAL;

-       err =3D nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, =
NULL);
+       err =3D nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, =
extack);
        if (err < 0)
                return err;

@@ -182,13 +182,19 @@ static int tcf_ctinfo_init(struct net *net, struct =
nlattr *nla,
                dscpmask =3D =
nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_MASK]);
                /* need contiguous 6 bit mask */
                dscpmaskshift =3D dscpmask ? __ffs(dscpmask) : 0;
-               if ((~0 & (dscpmask >> dscpmaskshift)) !=3D 0x3f)
+               if ((~0 & (dscpmask >> dscpmaskshift)) !=3D 0x3f) {
+                       NL_SET_ERR_MSG_ATTR(extack, =
tb[TCA_CTINFO_PARMS_DSCP_MASK],
+                                       "dscp mask must be 6 contiguous =
bits");
                        return -EINVAL;
+               }
                dscpstatemask =3D tb[TCA_CTINFO_PARMS_DSCP_STATEMASK] ?
                        nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) =
: 0;
                /* mask & statemask must not overlap */
-               if (dscpmask & dscpstatemask)
+               if (dscpmask & dscpstatemask) {
+                       NL_SET_ERR_MSG_ATTR(extack, =
tb[TCA_CTINFO_PARMS_STATEMASK],
+                                       "dscp statemask must not overlap =
dscp mask");
                        return -EINVAL;
+               }
        }

        /* done the validation:now to the actual action allocation */

Warning: Not even compile tested!  Am I heading in the right direction?


Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_8034A46C-83ED-40BD-8EE8-62E1515346CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0CEtkACgkQs6I4m53i
M0pCkQ/8Dwnwr6wbIY5cNPGGFRYj3722Cl9rhZVXIOFki/ZxMHHVb5ObWqbSwhX8
BeteQbhv762BuSCy05SqCgUkWGJs7Hjwh9MyWvbHlwuLc/WDdWJXEJLwyxPzSxZo
bdd/UkTrAN5ZllXaIb1eL2lEGMI4RYalc7huLCq9hNB5q15QiINo6mcSanysP+FT
DUtFUlMvr2l8umWHTqL9MheCBXutlY8B+af+B+4ew/D2kVSWGisbO5VNIGxA8NDm
gMK892AoGBEGv2kdUNhbRSCH4ovR4gOBBjZ9G4o6+tuGvhC4i/DEidOi0gAp4wZ+
VywJPcNPC/xAW5XfNotyXsJ+g+0Xg63JT6Sz10LQQk/BrnFrWgWiSgi6lYIlHMOm
WDfHkCrQfpOjLG+z/MLT8XOZK8QUtdfZqWQtOjPHGOc+RS+DDQjp6RCd6alCNYIE
9vip3RM6+UiwJa6b0lnBwDb53WHHZgVBPcLhcQzNTpWZ58LYXt/HZUx7Xx6443aK
MbbQ9TQXjjU2m4V8lKzYqV24aGXT9bxWBnjS+rlNlOPIQE5QzX5qNsAnC1WTLA0G
9H0GY8JA9JcHGt45bXZ3DBeonKrO0FMY6hSJDrNPZ5cZg7WJ7L5Dl/nubck2lBNu
7C74tk9hzAZJ3oZm+giGcipC1gSEETcuGZw+KplJTDNSZ+DOr5A=
=P+Yu
-----END PGP SIGNATURE-----

--Apple-Mail=_8034A46C-83ED-40BD-8EE8-62E1515346CD--
