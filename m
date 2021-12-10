Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8040F470A5A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbhLJTbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:31:02 -0500
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:7138
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234441AbhLJTbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 14:31:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2efONt9Gl3pJyPAvt4PICPPfuo41T80E2EW1dZ5NrUioFUJF4qpolxfdA3TrVRsdgt7rguq4F+XKOFz3Or2BlhJjbA/kXljkYj/636TGkDIkDlySUrEJfNeHznRnsXFih69kAE7mteNhM6rBrXw8n4zH47rFL4nfa8/UdpSm8M6KaXLwH7xSWZu6wo56Z9/8QGYlgDTcleWIOJkCqNa2WXqeRZyy5dKjtBOqYaTI/oa/p7xaWsuM0XNtw1BncCXea8p1k05/0tY/SFrLNnwHUuK2KiviHl1kE0CMwidICV1iM5qjtO1pBHfwMSY5nYThJhquuaQ/3M2yvqfSW1ksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpIMFwZRyau4hxzM4wvb/skznjpa5VzBVzJypJnM8Rk=;
 b=BjbNURduKwlyRGcVUBgzsoB52Rkt1MsaZooRD3x4aQlTdzuaU+Mlf4MWJ1xwNxvLL0sl0fz/uBywerbDz7YXGCsBDpJWjg7vNFyo4d0XJmVt44ppNVmiC7w7IKj3GQ1bx3HPPY1WuHPpB586+cAfsInoOnHNy429APDDNyaS8JfAt/Jn/C1W1hZEy/NejxefqWea7sj857TqAZrNluEEYslmxgGJJv6mmCqPK5zEQzTetG0iC5lRWbvf4Hmmvrdt2YQ/DRtCTvOm45xRRJTqGj6bM5ozAqSj0FoHjmT8UMkyqz8Qx5FguGB/cBcJ5JaUDehkADy/Y9iLEGJec1A+oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpIMFwZRyau4hxzM4wvb/skznjpa5VzBVzJypJnM8Rk=;
 b=XOM8S0OcJTLdPgOUZXbcIbPxQu2qg3Cr25bYeyL9F5dqmVlw3e0Mn+F1TekFX/ORxxKYW7/Py9sZK+fBOvM9xW4WVbdjCTDbNcJsyMBlDbQusyCta+sbL4ZUcZAwAGzZju0zKtVI7gQKijrOLhDgWSIhFuobX8s4BqAUsi6Uu0w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5503.eurprd04.prod.outlook.com (2603:10a6:803:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 19:27:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 19:27:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Topic: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Index: AQHX7SPAys/vPXh1a06w39SkUSlBS6wrFFcAgADg3gCAAAJAgIAAAVQAgAAD6wCAAAnbAIAAElCAgAAEw4A=
Date:   Fri, 10 Dec 2021 19:27:24 +0000
Message-ID: <20211210192723.noa3hb2vso6t7zju@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
 <20211210171530.xh7lajqsvct7dd3r@skbuf>
 <61b38e7f.1c69fb81.96d1c.7933@mx.google.com>
 <61b396c3.1c69fb81.17062.836a@mx.google.com>
 <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
In-Reply-To: <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd809ddc-2301-4c36-0531-08d9bc13182f
x-ms-traffictypediagnostic: VI1PR04MB5503:EE_
x-microsoft-antispam-prvs: <VI1PR04MB550360411D9067EAD0C0B420E0719@VI1PR04MB5503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ECZwm/M4AZ5RmFmG2HhpaW1vrpBYVlafKlXl+/E80ix6D/nsEiU+JpYkYBgwRiyYgbuXQ0VyIT9DrwklAaRVtlcxdfqWdoacyJHRF5o4AFA7RfMo8LXgfT++0WEMzpmLO+ApSPGquUWX/EJ2xOaUhW8KKY0skfNNafDob5SSVhPuyEIVeeGd8AvtfEfNCo/Y0jbbTol0JlYV+E9F5dGyVw1G3TOPR9rp+m6KAcLz9zZA1Vf0vdXbXUu5g7hzGpc4GBb3TdJ1coQbI2nnGULU5qVr4IUKS0w2ZNUGteaJ59AyF/Ulepsv2wZ3qWoJ6me3JRZpfZjPY67ffrTpE5eTXHoEPyZSXJoVH3A3pjLxkMVEdHysDBX4rlQkLbVelplI/AMG4tf7lY3fmTDlPx+C8svLfpb/gxK8d86wbFv0yoOMvHQVpX9tOKcPucd1YQyTpkoELemMT2gFk6kWqBQgp7E1gnXjFhj4QuvrAHs++2jOkBpZ+NoTXZp3TBNn99EDW3M93R2Q20u8NXiBPKO5fgAWiT09SFfeLlN3zFNXzsHwtZzoNYx+sKfjQCPQ4o4vpjIWbXuDqyC28RfXbcPFfX92e1L5rR1vHMCqs8jiwCGsfjNQiDITAZHb4PoaP2wOL8zvgqLHlxn2ThrS7aSVttcYq2LHj6KRPtaQ4VJeNuaZbiyl02CT41QAQsLb70yT9foQsZFA0p+KNv+NtLCJtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66476007)(76116006)(316002)(66556008)(66946007)(91956017)(64756008)(38070700005)(6916009)(8936002)(6486002)(33716001)(2906002)(4326008)(66446008)(83380400001)(86362001)(508600001)(6512007)(71200400001)(8676002)(38100700002)(6506007)(122000001)(186003)(54906003)(26005)(44832011)(1076003)(5660300002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yqJejUsQ1n0QLdgOcsSsFJ1L1aIwifL5hrGI1DpaLHcmHUFeYdcuwJstD1Nl?=
 =?us-ascii?Q?TjoaLXVl4tf3BTuat/FDUUl5Glyi1Bs4rx8c3M0fnlDF1z32QhcFfXaxa2hK?=
 =?us-ascii?Q?1gyqLikx4ii/fEIQTJej7n0t7aLOLX3wKwSGQsgy8oHlCuMgVGSWqzxWa66e?=
 =?us-ascii?Q?N29AGqBLzxyfPn/OKTqpX+QXeZqI92xQ1fyIsTSb9lystjNIby4TOYrQQhK3?=
 =?us-ascii?Q?XdTm6o48aa3htVFUxO5ILGV5UuJ9ZDsgZTRJ2RXy02sS3utFKw8ZHHtRwpqT?=
 =?us-ascii?Q?W5F0jcV22jZT67qC6FiXzq3eCePt5YWRdjTvg5WNZnLYBgw/DOo4RW7OcBPl?=
 =?us-ascii?Q?XUcYSjLP1N5ufasBWooSeRVjXzTbyt30bWxU7cxn7BRf6+by9z7Wc07xLZ6o?=
 =?us-ascii?Q?YRbAb2e65WDRkUNynQPhTeazNqP2fRlg0iiau8zNdumL/N7aoc/TWbFApm6X?=
 =?us-ascii?Q?LfhvYrdkj+KIg5zteCKt2klsUEfX95VY27thNtZqAixqI2rk8k2+KeRoS0gF?=
 =?us-ascii?Q?4wN1klEhN65XyQ2RW6RX6Zcae/CzmnsYx7mXFRQMf+wxo3u1cZ7mj+Cpr3Dv?=
 =?us-ascii?Q?UX9Htz4ZqFzosO8Snu0gIS0GfRpNzyjQbhE/LCOxLNy5vhqj9XzsIvD588RH?=
 =?us-ascii?Q?9nlO36o+wumyxOoVWWyzP7bZwHreRek/5V3UdZomCLn2IyRyywbdL/EQ6Mid?=
 =?us-ascii?Q?QAd37lnwuFF3Ecun6ehYmCLEr8uQAP+0JaqcbUdA6zgnECuSjGFDcCV/6zcy?=
 =?us-ascii?Q?yajlEgKQjb3KhKpr/RRxWiZVdSs18rBdx0dqmS3na7IC/taX/xN0ZvPdH3QQ?=
 =?us-ascii?Q?HSdAhZExPWI0mhMJ1gahZmExn2ETLap8iYge3xqmFBjYORfRgI/G9r7Xv1E0?=
 =?us-ascii?Q?vIxW1pAA69C+hILV0YcmUC0Hr7qLBYSn5JUsTLhH9ZOlbXckRboaJpcSc8Mm?=
 =?us-ascii?Q?9WNNyTs2r44quDc33Ex2gk72MFSCcdJfwSbjpBcSuViSmuh860o84iddk/yG?=
 =?us-ascii?Q?HMB3YH4r6K/bhyh6D8W4JHdEkCZDbBZXf5Km8vJaPoDTFGwokHodKsVrU0v4?=
 =?us-ascii?Q?mp5/gyfcBz+gOGWnmfkZNR3hISBNqUgkSQqqA8Y+splN4qdpzB9tOf2jMlHH?=
 =?us-ascii?Q?PQa24eUBzkvV9PNavWmB9viXTwHCJjvaB/a3/qSPQ8+XDqhT6NAZPsyHuWbX?=
 =?us-ascii?Q?0vNwvN9CEXONQb4ldUxI9T2RijG7TocCM4m4+Ce4ZtWj2ZJJpPH19MpqqtdG?=
 =?us-ascii?Q?cdRxpFFo5TtA50gnjEkMG3vCqjaRSCaIFndgmcmcw0vU9hhJRYe9czzDEUNR?=
 =?us-ascii?Q?AjPWFHetqHHmEfIvHxl+Zwrz6M/o1YjXb6d7k4BwsIP+Aq/ZBA0PQQ2o/zSI?=
 =?us-ascii?Q?pY0WctGkPsAtmcFzAkdnXajGp824wBjuszBCvkCf7WboVaPbTMxkjUpU8Aev?=
 =?us-ascii?Q?eRPMAUw1qE0CqK3OrwsrR1NE7vw93TF7w9NWOOCyHEBlpc4mqVyxbpNMUU6V?=
 =?us-ascii?Q?j28VoptrTofUlk9rDWewDiwOt29KpX0k8H727RyXy0JxB2sfOM4SXo6olokN?=
 =?us-ascii?Q?jU2vFOnLiTuQ3Eou412R071j4PF9HhlyRlAX5aR4M5OyQyKo0zrA8NRrAqOs?=
 =?us-ascii?Q?vdIvrw8XXJRsyJWifC3xv9Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27577CC07B45894F905E748272083D88@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd809ddc-2301-4c36-0531-08d9bc13182f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 19:27:24.5146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TUHmk4lYRk4ogfnrPyeuKzqwhrePjT7SibsvqlRExLFtzxJZr4R53Xhk1ngWTVKT66Tn9/RwhV57cJUMuILMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 08:10:21PM +0100, Ansuel Smith wrote:
> > Ok I added more tracing and packet are received to the tagger right
> > after the log from ipv6 "link becomes ready". That log just check if th=
e
> > interface is up and if it does have a valid sched.
> > I notice after link becomes ready we have a CHANGE event for eth0. That
> > should be the correct way to understand when the cpu port is actually
> > usable.
> > (just to make it clear before the link becomes ready no packet is
> > received to the tagger and the completion timeouts)
> >=20
> > --=20
> > 	Ansuel
>=20
> Sorry for the triple message spam... I have a solution. It seems packet
> are processed as soon as dev_activate is called (so a qdisk is assigned)
> By adding another bool like master_oper_ready and
>=20
> void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
>                                       struct net_device *master,
>                                       bool up);
>=20
> static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
>                                         struct net_device *master)
> {
>        struct dsa_notifier_master_state_info info;
>        struct dsa_port *cpu_dp =3D master->dsa_ptr;
>=20
>        info.master =3D master;
>        info.operational =3D cpu_dp->master_admin_up && cpu_dp->master_ope=
r_up && cpu_dp->master_oper_ready;
>=20
>        dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
> }
>=20
> void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
>                                       struct net_device *master,
>                                       bool up)
> {
>        struct dsa_port *cpu_dp =3D master->dsa_ptr;
>        bool notify =3D false;
>=20
>        if ((cpu_dp->master_oper_ready && cpu_dp->master_oper_ready) !=3D
>            (cpu_dp->master_oper_ready && up))
>                notify =3D true;
>=20
>        cpu_dp->master_oper_ready =3D up;
>=20
>        if (notify)
>                dsa_tree_master_state_change(dst, master);
> }
>=20
> In slave.c at the NETDEV_CHANGE event the additional
> dsa_tree_master_oper_state_ready(dst, dev, dev_ingress_queue(dev));
> we have no timeout function. I just tested this and it works right away.
>=20
> Think we need this additional check to make sure the tagger can finally
> accept packet from the switch.
>=20
> With this added I think this is ready.

Why ingress_queue?
I was looking at dev_activate() too, especially since net/ipv6/addrconf.c u=
ses:

/* Check if link is ready: is it up and is a valid qdisc available */
static inline bool addrconf_link_ready(const struct net_device *dev)
{
	return netif_oper_up(dev) && !qdisc_tx_is_noop(dev);
}

and you can see that qdisc_tx_is_noop() checks for the qdisc on TX
queues, not ingress qdisc (which makes more sense anyway).

Anyway the reason why I didn't say anything about this is because I
don't yet understand how it is supposed to work. Specifically:

rtnl_lock

dev_open()
-> __dev_open()
   -> dev->flags |=3D IFF_UP;
   -> dev_activate()
      -> transition_one_qdisc()
-> call_netdevice_notifiers(NETDEV_UP, dev);

rtnl_unlock

so the qdisc should have already transitioned by the time NETDEV_UP is
emitted.

and since we already require a NETDEV_UP to have occurred, or dev->flags
to contain IFF_UP, I simply don't understand the following
(a) why would the qdisc be noop when we catch NETDEV_UP
(b) who calls netdev_state_change() (or __dev_notify_flags ?!) after the
    qdisc changes on a TX queue? If no one, then I'm not sure how we can
    reliably check for the state of the qdisc if we aren't notified
    about changes to it.=
