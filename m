Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBA4383E8
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 16:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJWOHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 10:07:43 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:58836
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229870AbhJWOHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 10:07:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZ9DGy/wgIVj6Ag+86XQbxecO5HgzZuFHrr+waTWSC/ocFdV8T3tBRW/iHisBk2zoybSGCYuj+JFKZ8802GDS1ZHnofPqRn+D9xr6nRm/olHeA/9/4UZ7Ya8lZDUoCzuu1G8e1402SZvPvp1L86A5oMziDNGlp3IRDDz0fcxIBYmhpG+bZ7kWx5sUfuw/LKlFWqfxOTLzni9ANy3kVui/l0V+crCRTr3hQR3aS7kvSuqD75dACT08ZJU2Zqp04Kwht46IOPiir42JBNWgSMSdN5lQWT//ekfY5AMqve8YzCAMOxUUOpxy2NSBbWl6yx42dvNpMtkSedrXjgr5fhqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/EV/WhpVvP2ocddwV4TjVu8I7WZmoQuoMnv1cKAVM4=;
 b=Oe/B7sBzVIeXH3xnZ9OlfjdX5VACOGorb8w1YVpm2zqU12keVij6RsuicXQd1xrTG8Gb/Z+9Syr/NXYjqC/s6UHFlnuVrzEt7HbnDzqGOX+41/r8NaPAqGQbJyZoAV/LCr/eiciODZp/+4dUout6AqGtiyypphWjRPWwLU1TbDlmBXOFilJJWk77sNY3egn5dPJVjBFO+K8M7TLdNMIekJEMU4X54GnsAEVPTd4RaKwUvf+O0/CVO1W8sN6EQrzFLulo2zsNFF9is/Fz1MKVadBbnaDajVKs1GfhqVH159LIgwEFKnldAK8H9fjja/sUvvQ4F/zEiyEdW6qglTKs8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/EV/WhpVvP2ocddwV4TjVu8I7WZmoQuoMnv1cKAVM4=;
 b=odA8jMQABImcC3a6c/xG2oXsWgmhQ4fDZ/oL5kCIwbjCZetFXHr8LgjFtn194Y7VHR4WXOsOYgty3LfHYeEftgWwOB54yry4C4miVA7OILZ4jtmVUp34Bu9EEamFycfaqzPjrVPYUUlrf0jGpji5YEir1Lo4VmEw3y/nfSojhFQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sat, 23 Oct
 2021 14:05:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sat, 23 Oct 2021
 14:05:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 0/9] Drop rtnl_lock from DSA
 .port_fdb_{add,del}
Thread-Topic: [PATCH v4 net-next 0/9] Drop rtnl_lock from DSA
 .port_fdb_{add,del}
Thread-Index: AQHXx3TT3/xD2USQEUucEQd75H9eCavgnxsA
Date:   Sat, 23 Oct 2021 14:05:19 +0000
Message-ID: <20211023140518.ecglnaw3quoi7bmr@skbuf>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d537e9c-0121-49f7-dd0e-08d9962e25b3
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-microsoft-antispam-prvs: <VI1PR0402MB36163450D5B736A47CD7AB7DE0819@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sYp/EgQFC1rzgfwj3nNvbTvRyt7o8cNxFDpvhqjSYRQtZYIbh9IhY2vNaTcSsRPS7lv6C6F48EH9Ok/VLuSjDy5Xp8zjz67W9+AKLG3fKtzm9qZvPUZDb9Ygp02tSw9FI1beuw531llAeA2+C/CwN8lOP1cuV3pNEtag3yCylg9U3Z+lgkeY44QV1ot3F3nmH6LQRrTVBdHGDAwZuV/p+j4OEcudnkamDAp/u0nv7ft4q2I7SXVS+3g56MMp9aAQXAhPOpx1d7ak3vlYUHZMS974/BN3i4RerNGzn8P12DCzLIxxKx9s/uUzb461VTwRmwujL3KvIqJl7Ru5ZlIS9n1dzhsHmzoPqX3/vd46lKQW3MhkD2V3Z8qA7xV7DwioTnfBS2uqDGH9W9b3UVyDAu/W55gehZtFSzwBpoL9wqkUVXGBwSSV7nmb9qBwS7jV9MwgQ56dQsUFO2ahnZfUs0uG3ukZN0ZRHL74M3tZLk6f/36gdPa+v9fW/KWz+W0/+zzdzwyyAhWJuJwRoCu0LkhQc5S38JeaDIN71q3RcBgs8lBoOwMM4jasze0sqRxeJ/JpxfAczmJ7MUsyYwaG5JXyy8HJYcjWgRHD8nlqAVEADQqnyPLkcTRxsWXA9UkvfDIMRafy3P5uPsgMA0jhgaZ2+zGRmRDCFxxwo0COb5OSKhmsklHWWWT+igoA8UA6N2pujw/fgUFaqw4qe75+fdofmFty1h+CZHJsZTCUjNK9qSllInq8jsXc86NXI1nBxHHuA3S0mC8MPbq0jxVozUV8y4MzEg3clYDgUmTsv4b9MuG0lOoTX5vfmXX59O5d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(4326008)(83380400001)(186003)(26005)(8936002)(966005)(316002)(8676002)(66476007)(6916009)(71200400001)(6506007)(38070700005)(9686003)(66946007)(7416002)(2906002)(33716001)(76116006)(6486002)(1076003)(5660300002)(44832011)(38100700002)(86362001)(122000001)(64756008)(54906003)(6512007)(66446008)(66556008)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?KarC6KTnMD9oWeHQHCtPEFCPFwSTnFidKIUH2zCK5Z9cz3PCe1rBnNPG?=
 =?Windows-1252?Q?f03/1daP+wT0TydwEMi1bGcI3PqyMCa9pBtVE3BJID+6dLvuy5fOuREL?=
 =?Windows-1252?Q?nn1vzJgqCg85lDXRTFkbY2IKRkkAdXVNt95+Qb9FZ8Kvf6BAPQWuHV5V?=
 =?Windows-1252?Q?KhHsGIK25Al1wLCklzNOkMidcpZIa3Qi0d/fpSIQyj6mVjdwjimnP0EA?=
 =?Windows-1252?Q?jQ2enKnVIoiSwKRNy9fH+MB8n3NpyhcCl4pAZ5BQtpZa3Ir+QtV+6XqI?=
 =?Windows-1252?Q?0zloW5/zdRYpcRY2jSSKemc1HWkPLvBDJHn9VjyKQxzXcqZ8RY8dsCDZ?=
 =?Windows-1252?Q?qyLZAKpTho9VQvR+lwwOTXpV9KMuPYC4AVL0eIwvYLcLRbj+YyjNv8sH?=
 =?Windows-1252?Q?cgoPN6UQTHdVHvaWsvjgThAr8sldq/5vZ1qpoKPJ7DP+dGEPTD6fSvjh?=
 =?Windows-1252?Q?stnsOrR++sPRKchinOyg67769ry+46MityC9SBu2YsMb32rKP+m35/pm?=
 =?Windows-1252?Q?s2WVqqHkDAPqnUli6z9QPEx8W6GZPPSWMfG8zcHOK/P2iecI+uVqoPP4?=
 =?Windows-1252?Q?PfYe+aPOW6wpIUlIGHvV+kPV1/gFMXRSWqb6JY+aaeOlsqJq0WTzZEA9?=
 =?Windows-1252?Q?rN7t7UIvkum8cS0WkWXRaIDJZ9rWQUPWbXZ4+1rBpPbnIRW70NfPXQZf?=
 =?Windows-1252?Q?34kW8UWnFNCNXHb5mZMeJNa2yxtmMcG5IOdr83bwM7OKoVjska+pXmuD?=
 =?Windows-1252?Q?N1YhwoTBXmPQ5ndy2mx2kU0Dkujh+0wAmp3I+ENySbQElnfgMckudLBS?=
 =?Windows-1252?Q?7V0Z82tT9uHIwe6q/ePrfztM6trN3gkYqwCIrm5VV80yIBWeDr9LtsP1?=
 =?Windows-1252?Q?4UDKvPCk9ZjoGGwZp6EHM3Jfiph1tCFTrFv1ks7YmC4UGIwunYbEHZh5?=
 =?Windows-1252?Q?smyd9z/rsOOtcZT+Yeb5KXTa5fVFawZ8MHq32p3h2zb2y57WS9fdNxwV?=
 =?Windows-1252?Q?EdWvrAgAescRLtrJsC3926JrfShUCU9kiJ3ga4MZo7bM1UePc32jdtOm?=
 =?Windows-1252?Q?YdAZw9AqN41Yt3ZMLKSad0Hya+Yon37nsamx74ijFvclyorf2otA8AgD?=
 =?Windows-1252?Q?cSKEgGuXPhGk43dpGsW+g1nEd+P9Dkv+K7CH0rfn4d2attRK/ecuAjMe?=
 =?Windows-1252?Q?pYKSaWArnIWsVhpVcXDM36i7WNe3KpqDmIvBXFx+CgJ19N2Mzk3Wfum5?=
 =?Windows-1252?Q?2+C0y4ladw9N3KI8Cu+3cDZr9P+7rPvXjsS7qNXHj22F5rLtA2ecB6Ot?=
 =?Windows-1252?Q?f0lMsmSXgPJj+CkCqWpHSflnG/bgvJjIbDFz7bRP4qZxffYqRW8mfwo4?=
 =?Windows-1252?Q?I1j/gkY6NHowa5eTEBkUa+RR8uS9vCvrqFywVp6hBv6CPjnwmtmgCq1G?=
 =?Windows-1252?Q?JBoPnh2EESL2sKNFVQVEV9/5ORn3A0mbNHkLlZjW+ddMpbwUqLIQ0bYm?=
 =?Windows-1252?Q?XcFeDVGF5Kyg52LqEB6/1MVM1tEvMmz7V2XNpzlpqvpHd+syXB2Sr2jQ?=
 =?Windows-1252?Q?MHDS2Eb0uW5PtFXP/BLueMh+5sarG0RwZlsgempoWdyjG4ImUkLPQUwM?=
 =?Windows-1252?Q?vXAKXKjS6s9t9J2uiCjbyI6sFr5LzJo7uDoZV+fcBc0xXOyHRRr46ODg?=
 =?Windows-1252?Q?/Dcjg1AEwsA6omy95iAV1oLT3MJsnpNaX2eqMaDErYpIpf8TOUJRQTUN?=
 =?Windows-1252?Q?/dy/xha6aDGEUG9D5T4=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <72F2B1588E51BC48BB49505442A484D1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d537e9c-0121-49f7-dd0e-08d9962e25b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2021 14:05:19.3663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLVs2EhwiZDVfx3eORYeKt5gaD+f4ofnWzZRL29HPJuPtTT40BCWIllOVWaS8fYbD8wgc8HaRzXkZh3fdUqDow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:43:03PM +0300, Vladimir Oltean wrote:
> As mentioned in the RFC posted 2 months ago:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210824114049.38146=
60-1-vladimir.oltean@nxp.com/
>=20
> DSA is transitioning to a driver API where the rtnl_lock is not held
> when calling ds->ops->port_fdb_add() and ds->ops->port_fdb_del().
> Drivers cannot take that lock privately from those callbacks either.
>=20
> This change is required so that DSA can wait for switchdev FDB work
> items to finish before leaving the bridge. That change will be made in a
> future patch series.
>=20
> A small selftest is provided with the patch set in the hope that
> concurrency issues uncovered by this series, but not spotted by me by
> code inspection, will be caught.
>=20
> A status of the existing drivers:
>=20
> - mv88e6xxx_port_fdb_add() and mv88e6xxx_port_fdb_del() take
>   mv88e6xxx_reg_lock() so they should be safe.
>=20
> - qca8k_fdb_add() and qca8k_fdb_del() take mutex_lock(&priv->reg_mutex)
>   so they should be safe.
>=20
> - hellcreek_fdb_add() and hellcreek_fdb_add() take mutex_lock(&hellcreek-=
>reg_lock)
>   so they should be safe.
>=20
> - ksz9477_port_fdb_add() and ksz9477_port_fdb_del() take mutex_lock(&dev-=
>alu_mutex)
>   so they should be safe.
>=20
> - b53_fdb_add() and b53_fdb_del() did not have locking, so I've added a
>   scheme based on my own judgement there (not tested).
>=20
> - felix_fdb_add() and felix_fdb_del() did not have locking, I've added
>   and tested a locking scheme there.
>=20
> - mt7530_port_fdb_add() and mt7530_port_fdb_del() take
>   mutex_lock(&priv->reg_mutex), so they should be safe.
>=20
> - gswip_port_fdb() did not have locking, so I've added a non-expert
>   locking scheme based on my own judgement (not tested).
>=20
> - lan9303_alr_add_port() and lan9303_alr_del_port() take
>   mutex_lock(&chip->alr_mutex) so they should be safe.
>=20
> - sja1105_fdb_add() and sja1105_fdb_del() did not have locking, I've
>   added and tested a locking scheme.
>=20
> Changes in v3:
> Unlock arl_mutex only once in b53_fdb_dump().
>=20
> Changes in v4:
> - Use __must_hold in ocelot and b53
> - Add missing mutex_init in lantiq_gswip
> - Clean up the selftest a bit.
>=20
> Vladimir Oltean (9):
>   net: dsa: sja1105: wait for dynamic config command completion on
>     writes too
>   net: dsa: sja1105: serialize access to the dynamic config interface
>   net: mscc: ocelot: serialize access to the MAC table
>   net: dsa: b53: serialize access to the ARL table
>   net: dsa: lantiq_gswip: serialize access to the PCE table
>   net: dsa: introduce locking for the address lists on CPU and DSA ports
>   net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
>   selftests: lib: forwarding: allow tests to not require mz and jq
>   selftests: net: dsa: add a stress test for unlocked FDB operations
>=20
>  MAINTAINERS                                   |  1 +
>  drivers/net/dsa/b53/b53_common.c              | 40 ++++++--
>  drivers/net/dsa/b53/b53_priv.h                |  1 +
>  drivers/net/dsa/lantiq_gswip.c                | 28 +++++-
>  drivers/net/dsa/sja1105/sja1105.h             |  2 +
>  .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
>  drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
>  drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
>  include/net/dsa.h                             |  1 +
>  include/soc/mscc/ocelot.h                     |  3 +
>  net/dsa/dsa2.c                                |  1 +
>  net/dsa/slave.c                               |  2 -
>  net/dsa/switch.c                              | 76 +++++++++++-----
>  .../drivers/net/dsa/test_bridge_fdb_stress.sh | 47 ++++++++++
>  tools/testing/selftests/net/forwarding/lib.sh | 10 +-
>  15 files changed, 283 insertions(+), 74 deletions(-)
>  create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_f=
db_stress.sh
>=20
> --=20
> 2.25.1
>=20

Please discard this series for now. I'd like to get rid of the useless
sparse __must_hold context attributes.=
