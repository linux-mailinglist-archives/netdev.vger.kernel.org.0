Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98343B136
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhJZL2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:28:02 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:12673
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234827AbhJZL1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 07:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3RUBLiyuXdPFc0v/ipkSBD7RsX2sJz2BUVcBtHMTCDE079AFh477ncmoUzJvWiHJXjAbqvz7DdG/QPZPkzFZwP22MJtYot/OZL4enXjmBR6Dhw/6r0tWcNJFJIrYEVTitrPTaV6SGBzcSau6fDqnnQ3/wq3KJw+bYODjgI+ugDKoDb6lKJMsi/TyBK2j0GL7/65Uwx5Rcx7SD9IHCpepvON4J9796hpd1P4923fzWCkEy3KEziDGkfDPgpc45aTG0mHTK1M7axYswtHXcuZ3TVcG6BfhL+Spb7XZ0Pua06jIWA5ktS4Wn7UwHeBGT1CyMxKPh2uz5nCG0/30eTZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwUW/OLzOFbMXOAT5xgmqVmp1HrDNzwd6RPUoRLJYjU=;
 b=c+WTO8rZrdgFt1U9964FQ2STlLiOBQdaTWm312SwHRO6IsHuXjOvi+SJbjFLO4N58F++rfXEmwzZ5Fm2kVj+yYhgkxwan6pjgWU7LShfCCajKmPhHDs21HNjx5vPtIDBktYc/z/yw1BUdkFPwgTSt8kYaa+VIt+8+VsPL5qp0Kjp4DxAGJCiCNy/J2XNf4vMjOTU4W+6SiZ/ezQgP6Aow2mIQw/9poX1JnQ3cu6RpmgJQkkIk2v3DBW/ZGdOzkFngTGU+5Tj7dwL/neQnq7IcL4+SIRwUaFOJmfiCd0S/E3Bhg+m17CluBrV/S6gDyjAw7uf6QkBZ5JiKosm0InHqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwUW/OLzOFbMXOAT5xgmqVmp1HrDNzwd6RPUoRLJYjU=;
 b=bwTdhwzk3oZkqia4lxyw/3LiuBnfhAZXJ551//TDTWPQDU0V/Wo1Tc4GitckRxSga3bmhw4VSOXc1dl+3+EqChhKCpnuBuq3FVjMZeHCZ1j9eft2pROOjy5oYRFyqG2jBmGEFfO2qqN4qUeTEsBva5qGw4M442tGUHNTRRNPJhk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 11:25:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 11:25:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Topic: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Index: AQHXye8TuHIQFfcKx02oYjeM7kf+xavlF9qAgAAMn4A=
Date:   Tue, 26 Oct 2021 11:25:25 +0000
Message-ID: <20211026112525.glv7n2fk27sjqubj@skbuf>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
In-Reply-To: <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a822e40-6693-40b8-d86b-08d998734ec6
x-ms-traffictypediagnostic: VE1PR04MB6510:
x-microsoft-antispam-prvs: <VE1PR04MB65103A985C1DED78AB92C3BDE0849@VE1PR04MB6510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JgWllwaTAYwtCYKjYkHpgiVXB2Lx/n0eyStdZJc0OHh2lQxHis7wnNas4HB7nKN+QEtpy3sxpSxzPBMaRMKXuoQ7JSwakrbgZek3zjia+dUDCiDB+5qEHikSta1l4bcZjJxhLRxuNts5AzFic5TF1oFrx9lcfAloBNYkH0/sm2FDhKQFNkmA7OzFymnPVRqZC0vWC9FZMuFVcuctV0yEWCz2Jrv2uhZ62IpJg3Ha7pZlFnqxkY6jnSFPQXuEi26wbqlYXy+8xeMM+75weGyTd7IdD1cHZRkQYX8Il7f8ygx9hbjmUuJ/MOBu9ueTPGEiD0Tuaz5C1DssDjnkiOZaAqn6tTHYhAXRqbHAMSizB71ReVAsW+APFgB6Y8zozJVM69vWo8XZjsO2ys72KLirTee8xc6tD9epOZfAtI4Sf+obyQLMI+xSfwt0VnSciLxEA55FaP8kwN4bWOT/43qfF206H/xJ3tAEAV0wRxOt/yyLdONRTdoqa8PE23ttBZnQflyD/TvrabIng1ycAXATtAW+3E5bGhJ4R6tzWuXAwfDzuWsv6JtNHPcrNroQroT/IUzdgEhr0lwFsVtPpOL8ZC+bs24TeTrShlkANrpwiLvXbu/u3ScQkxoIXALhuuu/FW1+y3cq8qDy/ghOGDv8fnpo9+yMBgUUIEw+WhizHR575GE431c1VpYzfq+aj8BfpPA2losfjMd5NlBMAGP7Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(1076003)(6916009)(186003)(5660300002)(26005)(91956017)(7416002)(6512007)(8676002)(122000001)(71200400001)(508600001)(86362001)(6486002)(76116006)(9686003)(44832011)(66446008)(64756008)(66946007)(66556008)(66476007)(316002)(8936002)(83380400001)(2906002)(33716001)(38070700005)(54906003)(38100700002)(6506007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F6t+uALPIoPtb5xKlkSa5MyN5B20wJprHsP2w5vQTnRmDz7m+j8nASEzQxzz?=
 =?us-ascii?Q?VDHq5DGXSXXwyW/BPaq4aDxeVeWgNuivZNz/fM3qtsQ6j125tgtAHhKJARH7?=
 =?us-ascii?Q?hGsJ8GS5EgEx4HJm4uzWM83Ksn+Bw6oWq/qbb73Zj7MChmi03CKyFhhAJbRA?=
 =?us-ascii?Q?qw/eiIBLptcCLu1X4yuy1oaEjwbkecQFzWYcXQeuygKKUHWY/KEPg+P6aXat?=
 =?us-ascii?Q?65NOhSA//7BR1oTV3KZ+VXluYxXe+gKb/vVno+3qz3QfZQGGZb8NCAQ/rs9U?=
 =?us-ascii?Q?Xe+SRKd1CfvJSIwyiu7e7/hK5iWmi+EYpodXyv0zP811PoTmjXAizGICrG88?=
 =?us-ascii?Q?JiznCSLfY+oIHDFH/fBCs77mI5UbAfrqbs6bw2ftX5dfDmKVCf8AFJwrw5Uy?=
 =?us-ascii?Q?JjvRUD2sDlGOTDihyVkJXRcGuV3zPFOkgSVfLOHwyX6jk61yPtMpRx5agNXs?=
 =?us-ascii?Q?bTNALeIs5HwZEImTl21Pdg0EB7F/Un1o7Gu/qahOP+qJbiY1l1cEdUXPVfCX?=
 =?us-ascii?Q?kcnNnvWsTJeKhgAjreybGdNa1HY1MVScWrZHDOHyhfL1GiWtLfwKZRig+94s?=
 =?us-ascii?Q?fJLs7v/OhNx6iI0T0LKdzxWKYv+5ogpnH1Mkq8gPW2MuIWOY8DthhS6lcW7+?=
 =?us-ascii?Q?lQ+RaDoSEeZ9R45gmaSEnbD2cSfy8g67Rfj2VzvN8MYFB2PtBIkiqOkUMPOo?=
 =?us-ascii?Q?9Isgde1tnGzwE9hBuCatjUXPt8vAq2YNRtQp9lG6XRCJ8zf2Kqs1gUeaq5C4?=
 =?us-ascii?Q?X8y/HKKl43DzxLafobOyX/nEtKZnb88JKPRVdm57vjhLNONoLhW92WbnYg48?=
 =?us-ascii?Q?nnJxtVwfr1z/0yphavmIRINAiCFHn12O88KhrvTUKGl3YYnwjxOb96jidoM3?=
 =?us-ascii?Q?VhDxv7wzcenVtck7WKNuz863UKa9Mjsm+E1CTwoeh8APgDF8wf8JFen0czbu?=
 =?us-ascii?Q?siIYnXeSAX2rRdnbPQYMQzQ9IQZfn2gSr1QlPnCboLoczTtjFmkb+KqFrV6e?=
 =?us-ascii?Q?iykKBt2O99+7W4xHNhibZ4FWvRTcB76tVlvR/wkDZ9nJyzLNzUsVKrT3/iX1?=
 =?us-ascii?Q?wSDVM9WQ+wt7fJZAEBcW8j59sLddvFa6ZxPunUh4piegb6OExIOhVuI9Hu9U?=
 =?us-ascii?Q?Y8tkNndGWrFAM9W3bdapkdd4TePIq6/wTI7V1xhsTCHKI0CBY+c+VzRWyO7p?=
 =?us-ascii?Q?/VOIBhtKUREcCaDu7pgxnFLQgSgqPqgy5mnw7k/vXuBC8D4sVUJbFK+96A8g?=
 =?us-ascii?Q?IBhohanI1/tXXRi/XXnWx8Y0rnCZNCXu5rK6qKyKVX3fkAbv15Qz+WWEcajX?=
 =?us-ascii?Q?XD+lBv4Ju0S2m9OxvPR5sT3r0CD9pf60fZgW/7mj2QujkKfsCtGr/JdraG4Z?=
 =?us-ascii?Q?hwpoQPMT7nWKI/dUwoeCo+U/QmixNq+wp0pAydTfLfW0kg65mrzLIZK929l+?=
 =?us-ascii?Q?UdH2ZsNraaa/mOyIk2LXXu2dBqhd0Nyg2q5f7K+WC8nixDIEm5EKS29IAGIK?=
 =?us-ascii?Q?xlrv1LzpA/RbIXt6r4wYbjnQPxCsTFkVg2NghdxBerPaTyjvfhgpIAIQdqLQ?=
 =?us-ascii?Q?GGJsISEvwg4LdChPGHn+xGKnHpO8XvKljCHhvWFLpvc+FheYWCqN/LFfwKSn?=
 =?us-ascii?Q?OMTmFi+tKSl6SeAUF9DHr5o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D0E6B6E70A34F46BF5A1B5A1F847EDC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a822e40-6693-40b8-d86b-08d998734ec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 11:25:25.8572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0JXH6Fm2tE9AFOC+CNTp4NsJfQzImNaGI3LzAa+hTKCXTFg8seLQ76ZjxsTuIJdOkBR9ZTRdnfEs5HYvuj1isg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
> Hi,
> Interesting way to work around the asynchronous notifiers. :) I went over
> the patch-set and given that we'll have to support and maintain this frag=
ile
> solution (e.g. playing with locking, possible races with fdb changes etc)=
 I'm
> inclined to go with Ido's previous proposition to convert the hash_lock i=
nto a mutex
> with delayed learning from the fast-path to get a sleepable context where=
 we can
> use synchronous switchdev calls and get feedback immediately.

Delayed learning means that we'll receive a sequence of packets like this:

            br0--------\
          /    \        \
         /      \        \
        /        \        \
     swp0         swp1    swp2
      |            |        |
   station A   station B  station C

station A sends request to B, station B sends reply to A.
Since the learning of station A's MAC SA races with the reply sent by
station B, it now becomes theoretically possible for the reply packet to
be flooded to station C as well, right? And that was not possible before
(at least assuming an ageing time longer than the round-trip time of these =
packets).

And that will happen regardless of whether switchdev is used or not.
I don't want to outright dismiss this (maybe I don't fully understand
this either), but it seems like a pretty heavy-handed change.

> That would be the
> cleanest and most straight-forward solution, it'd be less error-prone and=
 easier
> to maintain long term. I plan to convert the bridge hash_lock to a mutex =
and then
> you can do the synchronous switchdev change if you don't mind and agree o=
f course.

I agree that there are races and implications I haven't fully thought of,
with this temporary dropping of the br->hash_lock. It doesn't appear ideal.

For example,

/* Delete an FDB entry and notify switchdev. */
static int __br_fdb_delete(struct net_bridge *br,
			   const struct net_bridge_port *p,
			   const u8 *addr, u16 vlan,
			   struct netlink_ext_ack *extack)
{
	struct br_switchdev_fdb_wait_ctx wait_ctx;
	struct net_bridge_fdb_entry *fdb;
	int err;

	br_switchdev_fdb_wait_ctx_init(&wait_ctx);

	spin_lock_bh(&br->hash_lock);

	fdb =3D br_fdb_find(br, addr, vlan);
	if (!fdb || READ_ONCE(fdb->dst) !=3D p) {
		spin_unlock_bh(&br->hash_lock);
		return -ENOENT;
	}

	br_fdb_notify_async(br, fdb, RTM_DELNEIGH, extack, &wait_ctx);

	spin_unlock_bh(&br->hash_lock);

	err =3D br_switchdev_fdb_wait(&wait_ctx); <- at this stage (more comments =
below)
	if (err)
		return err;

	/* We've notified rtnl and switchdev once, don't do it again,
	 * just delete.
	 */
	return fdb_delete_by_addr_and_port(br, p, addr, vlan, false);
}

the software FDB still contains the entry, while the hardware doesn't.
And we are no longer holding the lock, so somebody can either add or
delete that entry.

If somebody else tries to concurrently add that entry, it should not
notify switchdev again because it will see that the FDB entry exists,
and we should finally end up deleting it and result in a consistent
state.

If somebody else tries to concurrently delete that entry, it will
probably be from a code path that ignores errors (because the code paths
that don't are serialized by the rtnl_mutex). Switchdev will say "hey,
but I don't have this FDB entry, you've just deleted it", but that will
again be fine.

There seems to be a problem if somebody concurrently deletes that entry,
_and_then_ it gets added back again, all that before we call
fdb_delete_by_addr_and_port(). Because we don't notify switchdev the
second time around, we'll end up with an address in hardware but no
software counterpart.

I don't really know how to cleanly deal with that.

> By the way patches 1-6 can stand on their own, feel free to send them sep=
arately.=20

Thanks, I will.=
