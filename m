Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642C0442461
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhKAX4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:56:12 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:10612
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231472AbhKAX4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 19:56:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBnjrxdOLPMq9ddKZnGB+bNsOe+vNIT5xgOSEfECB1odWG0qs4iMZsodQT8mssSOGMvGKcjORF8FIcw3ROdjQC+YVnFcbFK03HN4BN2AN7tkBrjoy4eNNCArArCtnnTttwCK/0s7kSBMvg8JsN30ZEVQgzveBXuH8rP40tp+Gq0qdqBQPb2yquBnz6FwAhPyx73KQcL2Dea/MVIDPorc8C8o5cbUidSSm34JwkhXsPAv6bSzqBouER1jRDXZLcl39ZWoMCyesB2zgh8L3mq7oXg0AWKcIYXgjZNrjNgfDgqN9nOED8luKHGoCo68sFd9UoDNUkVC8uAvym9/D0GxbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEjl2Z5leG8pIL6+oz3LrCY7ybUdoA+HU9Ir+UivNIg=;
 b=nQM7EG6OzpILXZH58TXSoogo10Otn+TIJ0LPa/L5082MkMIGNwgiPoe5uwGoo5malgB7Q8XxSIcWv1SEXrGH6W1WRqqfa2+Epf+ATYi+d2VUnUShYF6QB1SX8rUNQkRrlOEu7AYv0grKwiuCxN+j04U7PbmNAPcv5qr0mQrO5A532vu2TU5oThmNm+uWw+HKxN9kg5UfzLGGhFIJH3hsG4gV9kmW8nEMgTbmnUomuKZuuV00aurICbxqMTXsMU4AMHU/XtqbO8Ra1zg6TxAzeOcdiygndqGZvQBAfGPyo5Kz2lWxe1vLOSVc8fHtZ+OCocYKk/Pl1a6QHQnR6Cj9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEjl2Z5leG8pIL6+oz3LrCY7ybUdoA+HU9Ir+UivNIg=;
 b=gqbI1M8boaHw9er09c+f9mkvcBWKiuHHN+IqTbZSf4SfAO4n4Nu9pMLtGWV82xvQIsWBMvrnixvQDhyU29x0El39y587fmJYRTs5rYpVc5DK+A12e6RBo/6Zsw4EgxRT3Z2kd8gT/xRGrhDx/YKIc/+DerjHpFWlKsorLoYEAoc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Mon, 1 Nov
 2021 23:53:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 23:53:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc
 storm prevention support
Thread-Topic: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc
 storm prevention support
Thread-Index: AQHXz0ImQ0nq8SciiUuj95wNlQzg0KvvWM+A
Date:   Mon, 1 Nov 2021 23:53:28 +0000
Message-ID: <20211101235327.63ggtuhvplsgpmya@skbuf>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
In-Reply-To: <20211101170122.19160-1-grygorii.strashko@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ffdc04f-778e-4662-0773-08d99d92cd55
x-ms-traffictypediagnostic: VE1PR04MB7341:
x-microsoft-antispam-prvs: <VE1PR04MB734123F620D9DE3680C1F096E08A9@VE1PR04MB7341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4SkKIA+xdoxoMiF98La8puW0LxH2bBT3cg9X5by2SFvrffoXTwJlb/vD7YrpFzaJKb9Y1NUpVBlHhIZ8wiIG5cWjcSPXw6NeBQlWlcaMA8TuUlymLiA399FtTL2+Ldwwg8H9iiTLSaVZSV8kXeBTrK60CDuS5gqS0zT02YDKSmLqSLWoMKHAeUWBxDcziB5gUoaB4qQDlU/P+YnTVdI16pq9fgV6SyPB55Ve1nxYwXmqSBnXBb3dPqIdtExWgiqada/yj8O6eZAkkE45RoBtb457BBmvi9KMoDPEAz1VattjpAZjaiF1Ffgne3kIR22QT9ECtYFvcxOEYY4+bP/vi05CaoK012A7Wk+3cFBulw0BaV4elV7pShY4ZyZBiMUw2GnGBLWX5rt/oOq9gOaUpvCZPNaaDIxQyA80o6Ym1AG7K0YwrkjMKwxo6aNNl3L91CCvsTNvCUQUNBz4dJ2VfpW8pKw/4d/BTDtVmGAnIVeVMnmfkGfE6B63n/F/XHraEGzUPUaUIxQRAPpmPSavDvONFEH/zjgfC2Df9GvRGL7H9CIO0P7RvYVBQcYmaUKt/etam6kWnVLP/9DGwYNRu9CMxl+WaWsW0C/XPFODCfHJWPFkFo30atkks0VaxM50EE3ZG8Nd+H3cend7v81KgcHjQxdIWS73pmamS4E4AwiojMhoN1FwzWQM5wtlUt9503D0FEXwCoseeq74L+xqNXELcE94e8ovs7pq6bJRMW0VJxGYxkl+mlJHZiiEJDbEqz3Ko89u5ZlVulR9H2SMBDlXjVrtQWy5K9pRNROwyx2Mh/rbWCs/phiMKL5Fe/xr/raa+imTLLD50EcUThw4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(26005)(71200400001)(38070700005)(64756008)(6506007)(6916009)(83380400001)(86362001)(508600001)(8676002)(6512007)(9686003)(2906002)(66556008)(966005)(66446008)(91956017)(66476007)(38100700002)(76116006)(7416002)(54906003)(8936002)(122000001)(186003)(44832011)(6486002)(4326008)(5660300002)(1076003)(66946007)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?adERiyy5ueyM+uzp5yraJYbsvpeZTQpaVy6VCIA3bpuk6t9g/STLKK/QoA1u?=
 =?us-ascii?Q?lPsIvOFZXxsNHjHmcNrTrLpfewbDgTAGGjL0iJsCPvnmpMJnLQJDHf3L+XqS?=
 =?us-ascii?Q?421GvLvd6OCcBY1w7afQUtFlufZQDeq6+oFSFLxYXXUkjo7zCsm3bDifJFGa?=
 =?us-ascii?Q?Wm2AEabEzJfhNBvq+ZVAKF+magIiHg4t7eGL/CzqJ/TaWATbqAQaHf6Bq58n?=
 =?us-ascii?Q?5uvvHOly4dD+1fFdLLtbm+rCMcaJbmljrZG/uTtUPG2s0OS1dqUf7HV6SQbL?=
 =?us-ascii?Q?8d1JhKpXKQnM0skSinyzZf8tBhLvQcDx67PRyeNx4OlmFl9OBvNrH7+EtCp0?=
 =?us-ascii?Q?gGqP46AWHh8nL/eoXG9Udd1BsP4COTnA+fwXPLKqeQ7EyQTMU83p/K8ARllI?=
 =?us-ascii?Q?0JGhJux6+g7+XkOhHCryqtcYYNqKvebNCguf3RL/FjFzms/20GPlGS5xHDbZ?=
 =?us-ascii?Q?+MQPhxfDQBCPSAeaNN5K7DWP+0e1OBW1+9q81NuIQ0eH7WRMV8vlMf0CKpW8?=
 =?us-ascii?Q?N9EBdi7AZZqRZlweX5PieFaEyxndO0rF9Yatoof8E08SZPtLDttkoup7uS3k?=
 =?us-ascii?Q?p0l/fxWh5Z+dAIePR/c70r137j3gU3FQl3Ippxhuj3te67flgKBvAre7RsJc?=
 =?us-ascii?Q?HySZIQ/ISrI0NWMNPwgpAHwy80sW5lHal6dSVHnxj4cF7k8AKewIiRo7Fy2u?=
 =?us-ascii?Q?kWZkDB/Phn2tor2wCdnVmi2EmIXvtjuM63KxmNozw35RfYWVd/JdAE8yAOxo?=
 =?us-ascii?Q?0n7838hqiKQIrbDXRLr6XhPO0REMg9W5OmI/xIPKXgFDbvY/PCVMszWHecq0?=
 =?us-ascii?Q?foOBjAmcsLrc6ptvzCp2wz+azEBCQ2gLu1Xpg/vK+N4cI86qcgXYWqV0NGdg?=
 =?us-ascii?Q?1ZmWydqDKTGFtjNePZk4UysIqxS5HtFWNB7YeepW0AgbceGAQHjm60Q1lNsb?=
 =?us-ascii?Q?sGHjAz2pxynKQsgmyxfqJ80roG8gM+QHUANOzCnP+pMTUdcwHCKFTzBahYhw?=
 =?us-ascii?Q?ZkdQFAZmc5Ca0sYe3fOco6Fu8NBNOcgHSYiFqQzey1SRkpTQZZWMGY4SlRWh?=
 =?us-ascii?Q?YvALK2nJX2x7K1mCv/CCQ1uH4/+4fdOnH8URkc26SzVa9XWB7JGHy0svZujC?=
 =?us-ascii?Q?Pkt1dCEKWclYRE1rphFfV1Cor1k3wwvpD3YJOe12hANleL+3N0rOwaYdni4c?=
 =?us-ascii?Q?S4aFBg/Ug70UlrEBveIU/jb6p6eFV6XydWrwRXSt0/W/ouh+BLOKblm3a8jm?=
 =?us-ascii?Q?qNle/eDGBBct6dndLsVUErtOO95oFwG6VMSfbfo+KDun7ZbCftocF1Y4MLtR?=
 =?us-ascii?Q?1zZrJwqLiuvdP55VXeJZTPyCm9Ah1IfvH/0/hR7HAVN9neQEjpfa9IC70sU2?=
 =?us-ascii?Q?UfqjOw3OqMY4TA+CyYTqawV32zOhchRMlBxJmZUhi6ovNwDcPhQVwrqp3Tz+?=
 =?us-ascii?Q?8E+lOYIWmbceQ0Xnu8sHrrI2H38HE8RrT3VjavybwQXrLynYT0LNSu75t1G9?=
 =?us-ascii?Q?idWp/Rv/ltHRZtAiC2DuzZK8YKqwZzvIJQxXHfVcDMA0OYUk2h6X6+NJ5G3G?=
 =?us-ascii?Q?JG09aMi00bPcGLHAlXrucrBqF7CXHrXoyMc0CppHzNflzQdlxI6GKTw+VeK6?=
 =?us-ascii?Q?boYthK8e/Xwr0CtCKxIUTfU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B5612E001AFF2438C6FAD238FF6F981@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffdc04f-778e-4662-0773-08d99d92cd55
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 23:53:28.3594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RvDNRBpnrZpz2wEPYMVP9UszXlPMJAgyPL6bAJAeu9RWKgZR5QZtP+CNP702GXKYFxwsYWluzoe94Fy7kRlB1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 07:01:19PM +0200, Grygorii Strashko wrote:
> Hi
>=20
> This series first adds supports for the ALE feature to rate limit number =
ingress
> broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/MC s=
torm
> prevention.
>=20
> And then enables corresponding support for ingress broadcast(BC)/multicas=
t(MC)
> packets rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS dri=
vers by
> implementing HW offload for simple tc-flower with policer action with mat=
ches
> on dst_mac:
>  - ff:ff:ff:ff:ff:ff has to be used for BC packets rate limiting
>  - 01:00:00:00:00:00 fixed value has to be used for MC packets rate limit=
ing
>=20
> Examples:
> - BC rate limit to 1000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff=
 \
>   action police pkts_rate 1000 pkts_burst 1
>=20
> - MC rate limit to 20000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00=
 \
>   action police pkts_rate 10000 pkts_burst 1
>=20
>   pkts_burst - not used.
>=20
> The solution inspired patch from Vladimir Oltean [1].
>=20
> Changes in v2:
>  - switch to packet-per-second policing introduced by
>    commit 2ffe0395288a ("net/sched: act_police: add support for packet-pe=
r-second policing") [2]
>=20
> v1: https://patchwork.kernel.org/project/netdevbpf/cover/20201114035654.3=
2658-1-grygorii.strashko@ti.com/
>=20
> [1] https://lore.kernel.org/patchwork/patch/1217254/
> [2] https://patchwork.kernel.org/project/netdevbpf/cover/20210312140831.2=
3346-1-simon.horman@netronome.com/
>=20
> Grygorii Strashko (3):
>   drivers: net: cpsw: ale: add broadcast/multicast rate limit support
>   net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
>   net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support
>=20
>  drivers/net/ethernet/ti/am65-cpsw-qos.c | 145 ++++++++++++++++++++
>  drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
>  drivers/net/ethernet/ti/cpsw_ale.c      |  66 +++++++++
>  drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
>  drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
>  drivers/net/ethernet/ti/cpsw_priv.c     | 170 ++++++++++++++++++++++++
>  drivers/net/ethernet/ti/cpsw_priv.h     |   8 ++
>  7 files changed, 402 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.17.1
>

I don't think I've asked this for v1, but when you say multicast storm
control, does the hardware police just unknown multicast frames, or all
multicast frames?=
