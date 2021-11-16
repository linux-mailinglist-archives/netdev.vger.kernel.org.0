Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA7452EF0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhKPKZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:25:00 -0500
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:7457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234029AbhKPKYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 05:24:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQD1a9RQNsxMTAZB3rhCoD8wEzgeD2NflvwAy38YoVCsPaUTvG6Ur6gEjjli27bEac4vE3LBoIAR/Bb3GF72FwIpoheqFJNM26bO3minFfEC6eDVhNTWI1+2SeBZyBIbQzar9Wq4ufhS2astVMMb4LSSi9me0hADUIBcyI1GB7DCKMCdTuwOAJdKNPt78VOCyZs1TN+EoFXg3WgxaGIxlkCliYtdOmxCEalTUjGb93mm3AJWI1dm0NZxiSCd4y18qLaKhQKXUvxW++SNGiQ+AQ0QYbs1xIf0NNWevzxFiL9XMvDmLkA5Kt3NPqdprwQZsN0pgyySMyXzgGY0IWnrdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0IUKmHTdJTD6tF74F4ZaLQhVJlM0wzuFjSzEBs8JlE=;
 b=Il7WOOQf6WNWYZdZq124ICib1gH8/2rGb/IwYdBalKgCf1P4lxDxtBSzpy2KJ8Ju6ckLXUtuAuLf1yWqn7Zoe20yTtpdRkQ8xIvYTvLQfE/D510bziqNL4PnrqLD1Rjvr3LtvIlpocbulAu12qPZQc73zvB9sbnlC7/dTqNtMH4neyP/Lj9G2GvSie4Fx1ZhHV8yVIR5fCQTNus7+vD3y2BUB65ZS5X1dWgSpv341lsImQ4dtyuv2Tfp02uq1C6k+dd/H0J/bc60vQQmm0o+J298oBjdC0i+MvOiB09lGrbCmBM57BBirMHfKOCmS7NE2T83g8xlu8bdHgQ8NdmTeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0IUKmHTdJTD6tF74F4ZaLQhVJlM0wzuFjSzEBs8JlE=;
 b=hDsMiV5PY9dXuHL9fM5HOrfQweVzv+jGI3xdCFJAh1k1p7mLljMTtfIrrWm3IeE8/TsOmoJDurzpXJ8aQioRi81zk5IcqGglKz958mX7W1wX6N+Zaqr3uWtVR8FczeuidOHvP+6zFmNEKzosCGNDpbrgQ8UO+NX0bHNzXoylR9U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 10:21:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Tue, 16 Nov 2021
 10:21:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: RFC: PTP Boundary Clock over UDPv4/UDPv6 on Linux bridge
Thread-Topic: RFC: PTP Boundary Clock over UDPv4/UDPv6 on Linux bridge
Thread-Index: AQHX2tNw+Z5uIMjbDkOEjvQaRj+Q1KwF8dMA
Date:   Tue, 16 Nov 2021 10:21:39 +0000
Message-ID: <20211116102138.26vkpeh23el6akya@skbuf>
References: <871r3gbdxv.fsf@kurt>
In-Reply-To: <871r3gbdxv.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc3b998d-1656-4b51-3ea7-08d9a8eae0c4
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB481696F632E71241DC6E7CEEE0999@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ydhzM8mlUhvDou5U7/BHngpS44hIkDKKhJ2zqOdAgm4nRWZ5GDpAMtw016YnETL+gdmbjHJOYQeyTxlqpInrDfvRcRfjqTW6ynce+uhTg4Xl8zx0NAi+Q7LDhgkZNxz1oiRwVN7SJZ0dsVJqvsI1CgfcoM2c37DxIbQHyRDxA1qICXSnrUF1e55CZld4zOHv2GIl+tEgyVwJSio77B1hR4HusZH/FGL1120N8h2qIyMEoy+pz0Ew+Jfb55C+QCDpb1JuLm+xPOr504s3xkpLJYjw5pqKui+i0mebOlQd7FU4mBUYMVE1EkjpNs/7I9iPV6BEcPhrEx40Znt6wddSAEC0WYnzVFmNVH44Bwbf7NwA19x9WQ3QeWWnrZjiGF94PGAiGgOTBLP2lWzstnduN6G6e1NOPfn0Kj8Ek4TRModDa7K1Yly2wO5TcGWh1DG5yZZ2NUzjcof/OWQ7EcCQMomYserQiqtx8+9qMgNfsPJgQQZNWcODDJOyOcBXFrzFDaxlW9CumDhK9dS5Mg+SM3iA2vFOkGMHeLUp/nmipIUbtbPlRPi66UJXNkg2PNrncTBIFSjPzGhuX340R3qGr0YR6BNJ1htd0qySedLEERqIxPmnlYWuwl9l4ePdiFLctLuEv7gRO1qop1/gGWNa6VsFTX4fnDnpDa/2BgB/TxrE8+kjhhw9EPhnKRw849P3UDhtsy8RjbIcqE1YMpFmHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4326008)(44832011)(6916009)(6506007)(186003)(38070700005)(86362001)(71200400001)(26005)(122000001)(1076003)(6486002)(66946007)(83380400001)(33716001)(54906003)(38100700002)(6512007)(9686003)(5660300002)(316002)(76116006)(2906002)(8676002)(508600001)(66556008)(64756008)(91956017)(66446008)(66476007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l0fhP1hgr4BHepQbwkmKIJ1Fi6g46ZYtJUpehA1qnL9twFXX9Xp0Qd7zbX1m?=
 =?us-ascii?Q?2yeSpu5cr9btr5Cfc5zgOgZkeg5WYcAaWm/hifslQcA2ju6ilSU2Yf5qnz2J?=
 =?us-ascii?Q?NW9jGuN2lFA879J0kXumja59BXJ2ocQnhtnBLhhJ4aDmpNo7Bo3tUSa+8KTq?=
 =?us-ascii?Q?e7/GaEpbGoXo4DNGmO5WeqMoHvJmNcL4+zX/5bAJZFsV9361zNa063fnTdbr?=
 =?us-ascii?Q?DJqXy7Jo6hTKjosmnCtjrCdtwEaWdmbVhqWatmkzjl3qFPIBBpBst10LDRX8?=
 =?us-ascii?Q?tpbTpeaJcMhHGMIku5meZOcYsx+UPlbgo/uDlb/qx9kYLxqWJ1xKW3KlrEB1?=
 =?us-ascii?Q?8VHhsCmQF5hlwdlSJGA2JP6GoF7TKEIM7arLeZ72PQj/qOgofqwTVPUvPrJR?=
 =?us-ascii?Q?DS40nS0JrhJ3Juf02CN5dqjvhFmW+DQgk5D24opVHjGI4XbdiHv1AWy+cnbc?=
 =?us-ascii?Q?nosWom3bsIqXSNbco5i2gJN6U/CwyQs5g3cecH/U0h116h5tbW4I6nh8Y8Zr?=
 =?us-ascii?Q?G2AZ6kQ4HvuLi9sAxWKpUy+FcAt/3I85Bxr0ntaCPYuSG4wq3vHEC2LB81YX?=
 =?us-ascii?Q?6CHfKpsKYjBJCMqKFNwmMddjQxONRWfuR4MNpcb98oi80JrF5tCpa+xggZEQ?=
 =?us-ascii?Q?lbR/zYHotGUr7eXne39qoPSfp9Ipb4CkZF0oEsRFOumrW9bzznf3OUtmT3tC?=
 =?us-ascii?Q?jYBga70C+tnTeVwbsFY42SueYHhF1KaFwlesyrZSWrJGjEvJUC0yxaaYlAkF?=
 =?us-ascii?Q?mncLTwS088QRD+0HTb5ge4qHzAJWU2+vkYHDJBQgyJYuooFTar1Z5hxBc5jS?=
 =?us-ascii?Q?Hu8bwDNxHJClMKfnFYwYfHeI7JjgZ93SSDe8IZC/RkrAr7WZjUWF6gVv0n/j?=
 =?us-ascii?Q?SNNqC9y1GjVs3d7/6JMbU+I57EKW7RFvvtGTsVoqdWO6w7vMJbZ4CB0NTNI/?=
 =?us-ascii?Q?bAm6SJh8PzBKimXtJp8p20tr2z5szu4f6amANq3+EZ0j2UgV1vKsaC01V3bo?=
 =?us-ascii?Q?aLBF3qhmvCzgAlUYAlDHnI3t3CzLqK6WdcSY9qzX6Re3+uVIedELfrIv8UEz?=
 =?us-ascii?Q?2K+pvCzDAS6/DzAf4+qTEfLO1870GNVLNR6n/cBqRKuglpWKGyrYPlg3axEO?=
 =?us-ascii?Q?bZcTaDCMqnF8B4V5fBBN+jmj7DDDpck6c27MxQPU9P4XpOwwRwz64nOqgulo?=
 =?us-ascii?Q?Q6k72a0uBtTWtrXqCj4UVmoKcp/aeSSG4+qEFR3PTlbUFXtcsFqs9Z7oa3mL?=
 =?us-ascii?Q?kLihVk5RpG8AHLnbuhGt7nh6sINaLdgADkvxtEq3SkSEuarULeDZBYRvz9pb?=
 =?us-ascii?Q?gXnPbRJWFM15v+EgSjKR1r6M1nYK2W3vlE8G3FswQdTj6LXiGE/Sn2hDM6aP?=
 =?us-ascii?Q?8O89T3eQ3a5pf+c/sHgYjbouXIGOGQOqEIxyR3S/X3CKXwq8IXVs/UZYw7Zs?=
 =?us-ascii?Q?OYKjlIAzLSY8F73apwOc2apvwbAf3KKzllgFBm1Pd030UhUrVF7EgYSTsDIc?=
 =?us-ascii?Q?xvczDqE4w4MfzvQ2uXRYo4CNE6ijD0NISFNGZihRun3TWU9PYPs6Tg5ejatj?=
 =?us-ascii?Q?Z1prYRf52J+9UiC0dhc+ELTFribiaNpPjPYU7Yp+Z5avqGkIFXgmk0HatAfP?=
 =?us-ascii?Q?6a6ipTbp/Hr7Bqkw3gjnAfQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03C64940AC7E854299C37FF37FDD6646@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3b998d-1656-4b51-3ea7-08d9a8eae0c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 10:21:39.4757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abvDm6GF2PqXt99kg7bh35T1RoS7IGMnKWkDe23AtRHU5O9+3Dfa70FY8sK432gPc3eJyp3M0DhJKdPAP6UO8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 11:19:24AM +0100, Kurt Kanzenbach wrote:
> Hi all,
>=20
> I'm currently trying to setup a PTP Boundary Clock over UDPv4 or UDPv6
> on top of a switch using a Linux bridge. It works fine using PTP Layer 2
> transport, but not for UDP. I'm wondering whether this is supported
> using Linux or if I'm doing something wrong.
>=20
> My setup looks like this:
>=20
> Bridge (DSA):
>=20
> |$ ip link set eth0 up
> |$ ip link set lan0 up
> |$ ip link set lan1 up
> |$ ip link add name br0 type bridge
> |$ ip link set dev lan0 master br0
> |$ ip link set dev lan1 master br0
> |$ ip link set br0 up
> |$ dhclient br0
>=20
> PTP:
>=20
> |$ ptp4l -4 -i lan0 -i lan1 --tx_timestamp_timeout=3D40 -m
>=20
> It seems like ptp4l cannot receive any PTP messages. Tx works fine.
>=20
> The following hack solves the problem for me. However, I'm not sure
> whether that's the correct approach or not. Any opinions, ideas,
> comments?
>=20
> Thanks,
> Kurt
>=20
> |From 2e8b429b3ebabda8e81693b9704dbe5e5205ab09 Mon Sep 17 00:00:00 2001
> |From: Kurt Kanzenbach <kurt@linutronix.de>
> |Date: Wed, 4 Aug 2021 09:33:12 +0200
> |Subject: [PATCH] net: bridge: input: Handle PTP over UDPv4 and UDPv6
> |
> |PTP is considered management traffic. A time aware switch should interce=
pt all
> |PTP messages and handle them accordingly. The corresponding Linux setup =
is like
> |this:
> |
> |         +-- br0 --+
> |        / /   |     \
> |       / /    |      \
> |      /  |    |     / \
> |     /   |    |    /   \
> |   swp0 swp1 swp2 swp3 swp4
> |
> |ptp4l runs on all individual switch ports and needs full control over se=
nding
> |and receiving messages on these ports.
> |
> |However, the bridge code treats PTP messages over UDP transport as regul=
ar IP
> |messages and forwards them to br0. This way, the running ptp4l instances=
 cannot
> |receive these frames on the individual switch port interfaces.
> |
> |Fix it by intercepting PTP UDP traffic in the bridge code and pass them =
to the
> |regular network processing.
> |
> |Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> |---
> | net/bridge/br_input.c | 13 +++++++++++++
> | 1 file changed, 13 insertions(+)
> |
> |diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> |index b50382f957c1..4e12be70a003 100644
> |--- a/net/bridge/br_input.c
> |+++ b/net/bridge/br_input.c
> |@@ -271,6 +271,13 @@ static int br_process_frame_type(struct net_bridge_=
port *p,
> | 	return 0;
> | }
> |=20
> |+static const unsigned char ptp_ip_destinations[][ETH_ALEN] =3D {
> |+	{ 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 }, /* IPv4 PTP */
> |+	{ 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b }, /* IPv4 P2P */
> |+	{ 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 }, /* IPv6 PTP */
> |+	{ 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b }, /* IPv6 P2P */
> |+};
> |+
> | /*
> |  * Return NULL if skb is handled
> |  * note: already called with rcu_read_lock
> |@@ -280,6 +287,7 @@ static rx_handler_result_t br_handle_frame(struct sk=
_buff **pskb)
> | 	struct net_bridge_port *p;
> | 	struct sk_buff *skb =3D *pskb;
> | 	const unsigned char *dest =3D eth_hdr(skb)->h_dest;
> |+	int i;
> |=20
> | 	if (unlikely(skb->pkt_type =3D=3D PACKET_LOOPBACK))
> | 		return RX_HANDLER_PASS;
> |@@ -360,6 +368,11 @@ static rx_handler_result_t br_handle_frame(struct s=
k_buff **pskb)
> | 	if (unlikely(br_process_frame_type(p, skb)))
> | 		return RX_HANDLER_PASS;
> |=20
> |+	/* Check for PTP over UDPv4 or UDPv6. */
> |+	for (i =3D 0; i < ARRAY_SIZE(ptp_ip_destinations); ++i)
> |+		if (ether_addr_equal(ptp_ip_destinations[i], dest))
> |+			return RX_HANDLER_PASS;
> |+
> | forward:
> | 	switch (p->state) {
> | 	case BR_STATE_FORWARDING:
> |--=20
> |2.30.2
>

This should do the trick as well?

/sbin/ebtables --table broute --append BROUTING --protocol 0x88F7 --jump DR=
OP

/sbin/ebtables --table broute --append BROUTING --protocol 0x0800 --ip-prot=
ocol udp --ip-destination-port 320 --jump DROP
/sbin/ebtables --table broute --append BROUTING --protocol 0x0800 --ip-prot=
ocol udp --ip-destination-port 319 --jump DROP

/sbin/ebtables --table broute --append BROUTING --protocol 0x86DD --ip6-pro=
tocol udp --ip6-destination-port 320 --jump DROP
/sbin/ebtables --table broute --append BROUTING --protocol 0x86DD --ip6-pro=
tocol udp --ip6-destination-port 319 --jump DROP=
