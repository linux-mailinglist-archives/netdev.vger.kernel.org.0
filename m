Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302D24FFFCA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbiDMULJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiDMULH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:11:07 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20040.outbound.protection.outlook.com [40.107.2.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F087E593;
        Wed, 13 Apr 2022 13:08:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxLcBGcZOS6NaOsruSCWfhMTsPrGd7jyJxlo3/DmWKeTfsHlxd7oSA5Ws0SJXQMppb6fthEFvs8Den/Ldwg8bR8BIXC8LuEe52f7MwZe2gc4KDXbLv0hkhrAR8Qd5TeN87glsag4Up+dVsSn7kt+EgD2jbodnNMp+pqo1/7ntJjWMNzg8dnNIYD7vRp5H0TFwR8FGISVoYvYSxsGMwNbXPY78J85jKFqoI407ZEP7p7o2BP2kN9R7GiHlGz5Z7XN1K/pQhzqbVKUNjb0XYJVxpOmQ4T8SrOAQIVC7PRdxd8R/6pi4nklRfRsbKvXjlEcwUz+/HWMaS1uwFSSRTpILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZMnN9NbrJPd3iDt+UGaH6/OJOTVLTPxe1ygROAqjZo=;
 b=eS3Oe268nGVI09S0EW1wliI1cyNwieO377uOOZ1F6BOijFqAXcOyBDsxAW6ZDkZG6IfWmRKSsNePF+ac2t6aVwcgib7zMi0QghLGhks9SkswfK8ReodlXetDiJPoByAa6aUWEBlWfn9yJ9DGxVpU/AggLOX88p8dTGXhSjWq1n4BVpEqHuaixGkD2XB8HmRN2zNhkYlaHnSE0o8Qzu/XbkJiIbPJw69fJiiAdqjLZggCHL19BEOVHG/z0XZQk6C+vTi3KkS2JhoASfZ9NU8tm99UT3mrrTa3VVmTG/khCaZrqfHFnxxGqh0bnNJ4LLPvExBsvUwXSeTfasn/bFL6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZMnN9NbrJPd3iDt+UGaH6/OJOTVLTPxe1ygROAqjZo=;
 b=R+iL2MC0uKFB87KEPGZcIGvihpN4lSt7o30dPDmfK7Abi0QW+/AqHTysRLC0c43+o8hJutYpJRBa0DywYZpjIJa5RrJQrrmgyDp79mCRg4he7Ia/TWMowaG1ZHscwD8MwPq3lwUgvFKAI5H8dcnlAFv/orw0zJ4PYCt0kbsIH/g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3391.eurprd04.prod.outlook.com (2603:10a6:803:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 20:08:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 20:08:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmA
Date:   Wed, 13 Apr 2022 20:08:41 +0000
Message-ID: <20220413200841.4nmnv2qgapqhfnx3@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
In-Reply-To: <20220411230305.28951-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad6faf1f-9eae-436d-b9cc-08da1d896812
x-ms-traffictypediagnostic: VI1PR0402MB3391:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB33918D62D2B02733056B3879E0EC9@VI1PR0402MB3391.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: obot/AdcaCUsJJsgO46RWJezW/DJrAqGtt4tEEUvUtmrUfOukeENvBSdzVkwVPb1cuNiDYooWyhVE40AOtfKEvkxxKCNFZ2fJTMWzWtqsNHwBIhAGq8Uoh7wmxXWYwbtpKKkf3MquHnq0UyfsmWUodlKYj591NMcy2dYUD5ilj4yUv8fOB1aL+/am4dQ/5wIYr1gbQdOdzuOAuDDnbg3CITHqYGQvSry4H1N+FJkKhFo/u/SYV+SK2gQLvxNRDMPGsfjgQkoXUdsko88ogRZoiJlA1NSJ3tYKE3r0DJoQ9EnzWDjRURZZ7qPIev+2PzO3MFUmBpG2otpxPZvkFEpGYVeVvzFekOjPp2UIo26p5mkR4zERSfvFoWRPp5aFmIDEFRZsd08FHevHrYIFW/slr0X4zD+IH46hLhZhNTHEkkSLaAb8G6MTidgc2QnheAB3Gq0Ug0mvVk9emHqP5ZnWWMoB81Venb2hcDQjE8wBFZTahVEv1TF2NZ/mW/suOH/F6P5p02ADBpKI6Dr4Yikd1yWlnogsOX9bYkcWYHNnq3EPL9wLi8MAqIxCEGC6di/BBK+5djGVW9mcTA8gEWJsfBQxlv7YBwDczNvhh7g9uA6OHHc7xKveNDCLpt/6lWpvcwSwIl5URMW0Hn9BDpfZfWSYYYoEpCfvT/tup2KywIGkP8tdEcXRsC5MD/5U248/Ct7n7upJpZyHF1fFiyKrUO4fbwCOQTnU4DMtCmONi8+QhuEUZagpbexVorgiQ/Sq2vBCUmPFuDl1SxVdkiVnQQvpVnAkWlc2TNTICkrUnM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(2906002)(508600001)(5660300002)(7416002)(1076003)(6486002)(966005)(66946007)(76116006)(4326008)(66556008)(71200400001)(6512007)(9686003)(66446008)(8676002)(64756008)(66476007)(86362001)(33716001)(38070700005)(110136005)(6506007)(8936002)(44832011)(316002)(54906003)(122000001)(38100700002)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jh81cqkp6/dk1HxnBLN5iX76xYhbfqJzqpFkDtYx1ZwwevKMq04vrwV4wrZU?=
 =?us-ascii?Q?/9MAzfJvGODIGGZsx1V9RQpJblzeDu4eUF+pG7yjzUL98/XxBPLjpPJm8Gx1?=
 =?us-ascii?Q?ehsogEQ9+n+4oymGbj/R3HwrYRZ1ygjTsKwIViX7WmiHMDHMo9R4/fUcawCh?=
 =?us-ascii?Q?SFupxAjqUCT3I3edDPFcI8AkSny4zIMAfJBQBjOgkvdm59AvkkyvZivn7bu9?=
 =?us-ascii?Q?sdxAwTm0TA6WZ17PU6xz7niiYys10IJEtZ5g9z/aRcJT/wUowT18oOhmGNVF?=
 =?us-ascii?Q?u8FLF0TcjthZ4VaKABLl7XJhN8FlDoZkLqsA6L9VwebRD16xrY2MGxn2uj9s?=
 =?us-ascii?Q?mpy70p2bHfCq8OJxMwOF6kOkwIEHFfGNfBg6JrA8AJKIFYVoYCqaFl3qw9Z0?=
 =?us-ascii?Q?vzRqmIv6JtU7qoHvt5RxMgUafY0BB6TpjW0Csy6ZTiDDFK+VAjGkEnvLmjty?=
 =?us-ascii?Q?xfaAGcfaNpAejShBTN6vLYSChTLUoDwCL1UWzc605jzfnCK1xFh6tlUfZ50H?=
 =?us-ascii?Q?l9HsOESphq1kJuF68rtzLIoWYqaj7lDKDZgURVDo1hH4xHYatoXcRKEvsGT6?=
 =?us-ascii?Q?CPHi+Uf3xDu0eQYdwLCAY/MiTVdzGWGnHz02KrPYplOw4mSgo0/jT0nTELiq?=
 =?us-ascii?Q?G6cRbYFldQJC8rb1u12jAysuxxyhAZnUqfLHLec+5kG73z2HAxuqo/9cBdyp?=
 =?us-ascii?Q?KaM3zn7rXqOz2fVg56g3OxSNKRjzuEErWzAWMSKLJ5jBO7GBQ1Fl6fQwmgtH?=
 =?us-ascii?Q?o+7LEuX3ihT2NbswGFidR5H5qD9sKvkowrxt1btu0z6knFY+tGGYc83sDs87?=
 =?us-ascii?Q?Y1QDESsLWsg9FKFEAMmQDIXk8xH2kBMltIuI/ALieaNpAl/lQgZ9Na5F6QoG?=
 =?us-ascii?Q?lxiHv/g63DrnD5+nsJUD87UBZi+yW6btYf2oycqPkAkA6/SKpF4xrmcy581O?=
 =?us-ascii?Q?NVfYj0zVuzCSNfT3fz0ZMaQR9Eijj9Zo5GfmVP0Gq71V4kiFIxg7dj06tKZ6?=
 =?us-ascii?Q?MusGpc7BtFf2/XkYzSw9NnJgtjSj5nlnsK4gcKSyGJFkGk1v96zAD6C7qFHs?=
 =?us-ascii?Q?kBoHMo/JUL3FsksqWwEAmaZKuU6PSZXuR/xhoOKvYLZBmEzquiqEDd83trZu?=
 =?us-ascii?Q?xGi+zyvrDAqQOX09TT1v1v2SEl+uzUUB1FQP9EWCDNut61RS3fSWYsgPer2t?=
 =?us-ascii?Q?vTCBW0oQf+OwOqYiItrYT/ZPiIzItCOQYKT6Y8pXLZ1LhPwlDEriHMLo+X2I?=
 =?us-ascii?Q?a8Gv7l1cYAezQWn1uL13gCNrcJP9m0qhqDXJ1chyvm3qRCteGTrBeN6569cp?=
 =?us-ascii?Q?UPkfjBjpO2FektMkLJLUh36hqLf/kb9/C2vDs/0wznSXGzrZWCEoeLWNXWWw?=
 =?us-ascii?Q?E3UUUhOHVI48rO9wbAkqHzbOaMw1f3YETipz/v6gIAyNpYK0EIbtREOFZ+sr?=
 =?us-ascii?Q?ABCRHHZ7lCSQJvFlwnv+07XAMM3JdRFNFPvRm4iYDzn+PezI05RQmoQWapP6?=
 =?us-ascii?Q?hwwomDtjbLrjdxUf8SlM0aFwiZi0O8fJK21CBiObAtQqPpt8yBlSQre3cMUN?=
 =?us-ascii?Q?j74JI/cW9VmwBnuZz+XgAyaQ9jBFjyYqPH6tgwqm5KHM46Q2nmCWy+Mt9e0l?=
 =?us-ascii?Q?TIu+UYzdmLinK1AEYEL3o8rHgI8vGDPWC+fUDzfp/Jgc59TtX4XBgA/5BFfd?=
 =?us-ascii?Q?byDnNQuRL7YMYaXmhXm7jrSdRcZjOkrLsKfwPdTbhtIDGE/BrCdizLuVHVDx?=
 =?us-ascii?Q?ipLng8/n/v2HQfoGgkxCare2dyvfdx4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9ADEBE699F29A941A7FF95271541347D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6faf1f-9eae-436d-b9cc-08da1d896812
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 20:08:41.9035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zV26IYOliJswZQaWPQdLIgk2O8fqpmRWBOulcEClkCJOD7cEcotAfMzMGaPUcZ/MejQjeqdjVJwFMdvaPcBdng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've copied a bunch of new people to this email.

TL;DR: Kurt/George/Andrew, on your systems with hellcreek/xrs700x/mv88e6060=
,
does the DSA master declare any of the following features as "on"?

ethtool -k eth0 | grep tx-checksum-ip

I would expect not. Otherwise, we've either found a bug, or discovered the =
Sasquatch.

On Mon, Apr 11, 2022 at 08:03:06PM -0300, Luiz Angelo Daros de Luca wrote:
> DSA tags before IP header (categories 1 and 2) or after the payload (3)
> might introduce offload checksum issues.
>=20
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  Documentation/networking/dsa/dsa.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/network=
ing/dsa/dsa.rst
> index ddc1dd039337..ed7fa76e7a40 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -193,6 +193,23 @@ protocol. If not all packets are of equal size, the =
tagger can implement the
>  default behavior by specifying the correct offset incurred by each indiv=
idual
>  RX packet. Tail taggers do not cause issues to the flow dissector.
> =20
> +Checksum offload should work with category 1 and 2 taggers when the DSA =
master
> +driver declares NETIF_F_HW_CSUM in vlan_features and looks at csum_start=
 and
> +csum_offset. For those cases, DSA will shift the checksum start and offs=
et by
> +the tag size. If the DSA master driver still uses the legacy NETIF_F_IP_=
CSUM
> +or NETIF_F_IPV6_CSUM in vlan_features, the offload might only work if th=
e
> +offload hardware already expects that specific tag (perhaps due to match=
ing
> +vendors). DSA slaves inherit those flags from the master port, and it is=
 up to
> +the driver to correctly fall back to software checksum when the IP heade=
r is not
> +where the hardware expects. If that check is ineffective, the packets mi=
ght go
> +to the network without a proper checksum (the checksum field will have t=
he
> +pseudo IP header sum). For category 3, when the offload hardware does no=
t
> +already expect the switch tag in use, the checksum must be calculated be=
fore any
> +tag is inserted (i.e. inside the tagger). Otherwise, the DSA master woul=
d
> +include the tail tag in the (software or hardware) checksum calculation.=
 Then,
> +when the tag gets stripped by the switch during transmission, it will le=
ave an
> +incorrect IP checksum in place.
> +

While what you're describing here is truthful to what is currently being
done, I'm re-reading this conversation:
https://lore.kernel.org/netdev/20210715114908.ripblpevmdujkf2m@skbuf/T/#m13=
a2e3a78d22b82f14bcdf85d988844053b1e8f9
and trying to remember why I didn't point out what now seems obvious.

It was said that inheriting master->vlan_features & NETIF_F_HW_CSUM is
counter-productive for tail taggers, since now we have to patch all of
them to do that "skb->ip_summed =3D=3D CHECKSUM_PARTIAL && skb_checksum_hel=
p(skb))"
dance. And that is most definitely true.

It was also said that some systems where the DSA master vendor coincides
with the DSA switch vendor rely on the switch inheriting NETIF_F_HW_CSUM
from master->vlan_features, for a boost in performance. That is also
most definitely true.

But none of the examples given was for a tail tagger, which is what the
discussion was about. With the exception of the obsolete tag_trailer.c
used by mv88e6060, Marvell use Ethertype headers, and Broadcom either
use an Ethertype header or a header prepended to the Ethernet header.

Of all tagging protocol drivers which declare a non-zero needed_tailroom:

- tag_ksz.c also calls skb_checksum_help() so I don't have doubts that
  there aren't masters which offload checksumming for it

- tag_trailer.c doesn't call skb_checksum_help(), but it's orphan and
  probably super broken anyway

- tag_hellcreek.c doesn't call skb_checksum_help() and is therefore
  probably broken with checksum offloading masters. But it was probably
  only tested on FPGA (or at least I assume "hirschmann,hellcreek-de1soc-r1=
"
  stands for "Altera DE1") and it happens to work there.

- tag_xrs700x.c doesn't call skb_checksum_help() either, so there are
  probably breakages waiting to happen

- tag_sja1105.c (actually only SJA1110) uses a tail tag only for
  link-local traffic, which is non-IP so there is no checksum offload
  breakage there

- tag_rtl8_4.c (the tail tagging version) has been added by yourself
  with a call to skb_checksum_help().

In any case, we give this advice to driver writers so off-hand that it's
comical (I'm not attacking you, Luiz, for merely writing it down):

| For category 3, when the offload hardware does not already expect the
| switch tag in use, the checksum must be calculated before any tag is
| inserted (i.e. inside the tagger).

As if the tagging protocol driver has any crystal ball to guess whether
the offload hardware of the DSA master in current use is going to expect
the tail tag or not. BS. A tail tagging protocol concerned with correctness
and portability is always going to call skb_checksum_help(), hence the
absurdity of allowing tail taggers to inherit NETIF_F_HW_CSUM |
NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM from the master in the first place.

>  Due to various reasons (most common being category 1 taggers being assoc=
iated
>  with DSA-unaware masters, mangling what the master perceives as MAC DA),=
 the
>  tagging protocol may require the DSA master to operate in promiscuous mo=
de, to
> --=20
> 2.35.1
>=
