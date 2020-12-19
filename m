Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55E72DEEA2
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 13:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgLSMNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 07:13:30 -0500
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:55648
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbgLSMN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 07:13:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxQv+ET3Rv0VMcXjw7HaVr5lS7nGWck1GSPblRRM3/PgCgjdfWZFrKohtQtpS40lfo87TNSmQJ6rgOBGQyQwsFc7oLY3T2xzgJw/JFozPujSpjfzGFcg9yXsoKFiVwY2SUKB4qetbaTk1Z7zTJRV8+u71cXYoym/xo8M9O0zczKXOPd2NhtWi6cnMUpk9YWUtjSXD2UNDtwaMQuYHWBUyeTNxZlEMaqwokVipJSebHhkrVFArGnnfnhnoxaf6/YX9LgRCF3ziw9gfZhBt+oPdlGgYHF0m5h34RBgXFQTgEhgr93KBTyklKwF5if/S8Yz0aXMxulYpaOOJ0ylpQgTbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJNr31RphTH2yjlrrILLyO4Tpao5tPrqTcOEyyjepsw=;
 b=GZVC9IjHsVjKkJDZ0c20kam61dAhS2S3+mLhfcRC5IltRkmzJ4oF66/Rdv8Pd3QGicKJdsfBrzwLQeNvEIfOg9aSoLVvEdFxJ+hy5j8eU+LrtZfYWh8jt8ITXZnhwBiT/rKhgBjV/9v2NaS/bIU5s1F1o6xcrd+nNY7OxXJRrH8GdTxOvyaxK+qC8LE4bLwn7BddmSLQIPPXlJF0b0pM3s8w5TzKu0izZg5bm9CqBGM1+ck06Dk7tvz/hJmnsMMUCrbs0ofer14B62fTrUXK1hxXJ1iUMtS0rmuhq2hbEFEaYzTtx1atglidg10MxthdHnerkLLBvLVU+78WTliBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJNr31RphTH2yjlrrILLyO4Tpao5tPrqTcOEyyjepsw=;
 b=Ejgva+Oe94y6nJ1TGw+FiPdBkoXVZO8W/RmoY3/ZnLiZD18nsmE7bKglpnkCQhtH//z3fjd0nu+XvjncY9hgR/rMMlSbgIazK14r8Fm5CTN1uPI97/4gm78zKWQKRt7mdHFdUNZiihJN0kBt82rVEqJMCRe30y9huqSGOeretFQ=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3838.eurprd04.prod.outlook.com (2603:10a6:803:20::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Sat, 19 Dec
 2020 12:12:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.029; Sat, 19 Dec 2020
 12:12:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Topic: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Index: AQHW1Y6jUxjdnV3YQ0WXbdlAp0+0q6n9zjkAgACHJIA=
Date:   Sat, 19 Dec 2020 12:12:38 +0000
Message-ID: <20201219121237.tq3pxquyaq4q547t@skbuf>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
In-Reply-To: <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dae79bff-aa9e-413a-4e91-08d8a417606f
x-ms-traffictypediagnostic: VI1PR0402MB3838:
x-microsoft-antispam-prvs: <VI1PR0402MB383808170AB494BA740CF453E0C20@VI1PR0402MB3838.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sqc3OwEcILo7uCMTxvn1hLpKgT4pZgnBQjXV6zfJOj+iz6KB4v1KcMWoi/5BuMjdToZea3NeLFDZBx7DdbVk1qCYBNqacSkStw8o/5/XN+DBn6m9eYZBJaITP5nt9BwrgCj6iYPIKL5RaTdo06AfeuQu5QyvwQWaKL1SqX/y9zIVha4diOMsnHeYfcrDZ3oyttby00FDqhfz2nsgeVeoj2H/c/eluDXHIwFVO8tEbhSXw94CWkNfK4RC4FQy2Zevpl+V+vUiObqWMO9AEx2/6y+M5btzTbjMsKo6bDMsh4qzUAZh/x0Y+HnCiMxt8CWjvMtVjTUx7DOuIuJvRfwvxUPZlgX/RoM9BO5N+jnPdGjCG4XPaiKw8dtCGQrSk5iSqtcNGx6igz1olxXVZQnZFEFfSoc30EtDDdQ4vjNcJM8GDfC83We3RIGhaK4TR5L3ayB2LXzggvCvwkmKpb9smQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(39850400004)(396003)(136003)(366004)(64756008)(83380400001)(71200400001)(76116006)(66476007)(66556008)(66446008)(54906003)(2906002)(966005)(8936002)(26005)(86362001)(6506007)(44832011)(6512007)(66946007)(9686003)(6486002)(33716001)(6916009)(4326008)(53546011)(1076003)(186003)(478600001)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?n+77GsJF9viYRrCFDHZ+XI+EQKJA16OPTg5DWnkp8CUST9OCoWXoqsUGDhQI?=
 =?us-ascii?Q?sPwS8hQRzdagjM/x8/giIeOXPEpIwavzrnAV4vw2PUT5kRnUjW1r9XibxiXJ?=
 =?us-ascii?Q?9Kko70tA4aq2kcwdwF1pH2yALIwyL1lgdZ4wWeWBxOl/F9zWE7Jq/IoTwB26?=
 =?us-ascii?Q?hnhuVbaNNehMJ+cglESx727S4+tmoE1FUqE2e5LEolOi01BQsMp5JkGADySl?=
 =?us-ascii?Q?B7dDQrpNLv4ijrTBI/eCWkqx0lr1nFdUjPq1c+25j+YwNRmZWRc5zHn8915S?=
 =?us-ascii?Q?U0noE1PbyoFrNGVwXMdgW9vQT8ioGMdFvCLAe7Y7W7P3povi1ZWSXB4Jcf3N?=
 =?us-ascii?Q?X/7hZnPlWHQdng9OFhMk/8WuWV0EMd7Np1PjrMlWq4ZuPsGleYu1ymLpF6nk?=
 =?us-ascii?Q?X7jKudxwrix9U0UaNAOiVzSOOQu4XKwVDNSm0/guseAOG1DfMbdUzc8xgew/?=
 =?us-ascii?Q?7mc0psFte4/jLC3Twb41LtuLqBmRCv8KbcIl7RXPs6Kz7qJM5wtNtrMhGMY3?=
 =?us-ascii?Q?3EDIeoVK59rL4KgPKPmkduJL59wRprSSssl8bEpw03RDKkbxOZC4UG03sQID?=
 =?us-ascii?Q?m6Dp8nvi2p1gkoaWufi0urFnrpor3c0v01QIzwu/8wAkH533l5hDQO7jNyJa?=
 =?us-ascii?Q?3v7dudWxqgGSIz7RcLn8UbxsAfhbKvGFpfUUIJqmkKBYzvjD3N92bFGj1+zw?=
 =?us-ascii?Q?6foYxufeem7wvysGrCQMlsaBuXreYzV5PXGIPjstiwyLwVY9K9ZBduCt6qZC?=
 =?us-ascii?Q?YPgDMioLazLMTMz/IBUoTl18zjval28+Q4HCvHRc6zQGZDvBiz7OsYUbA7yz?=
 =?us-ascii?Q?H4kspLROOn2ncCaytFWb6sXCHf42ZT28Xk9hj4r6Jdld0y55vujE8OzEhqZK?=
 =?us-ascii?Q?D3+Zi8iZkQU9zQzcMRH5cLQc8DirtJH0MHF/KKvtO7OktfAEllepO4LTGJij?=
 =?us-ascii?Q?WUbjkz2APglyFOjobtbhFszn9SfoAoRdO9NsmPMKKqQYKLF8eAhCr88+Fx1M?=
 =?us-ascii?Q?n2KN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA5ED316EB6CCA46918B4F6F6CB9D7E8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae79bff-aa9e-413a-4e91-08d8a417606f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2020 12:12:38.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8dvOL0eRGrfRPoGYTYVaLDsevXNeCZg9Kx+pPyXSWo3zhfkTTy9p+jQw+/GArMutqrNY5MgGbn9mwk1ksDYcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 08:08:56PM -0800, Florian Fainelli wrote:
> On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> > The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switc=
h
> > port to a certain queue of the master Ethernet controller. For that it
> > currently uses a dedicated notifier infrastructure which was added in
> > commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers"=
).
> >
> > However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
> > DSA master to get rid of lockdep warnings"), DSA is actually an upper o=
f
> > the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
> > concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifi=
ers
> > are emitted. It looks like there is enough API exposed by DSA to the
> > outside world already to make the call_dsa_notifiers API redundant. So
> > let's convert its only user to plain netdev notifiers.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The CHANGEUPPER has a slightly different semantic than the current DSA
> notifier, and so events that would look like this during
> bcm_sysport_init_tx_ring() (good):
>
> [    6.781064] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D0
> [    6.789214] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D0
> [    6.797337] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D0
> [    6.805464] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D0
> [    6.813583] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D1
> [    6.821701] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D1
> [    6.829819] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D1
> [    6.837944] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D1
> [    6.846063] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D2
> [    6.854183] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D2
> [    6.862303] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D2
> [    6.870425] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D2
> [    6.878544] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D5
> [    6.886663] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D5
> [    6.894783] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D5
> [    6.902906] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D5
>
> now we are getting (bad):
>
> [    6.678157] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D0
> [    6.686302] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D0
> [    6.694434] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D0
> [    6.702554] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D0
> [    6.710679] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D0
> [    6.718797] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D0
> [    6.726914] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D0
> [    6.735033] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D0
> [    6.743156] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D1
> [    6.751275] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D1
> [    6.759395] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D1
> [    6.767514] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D1
> [    6.775636] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D0,port=3D1
> [    6.783754] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D1,port=3D1
> [    6.791874] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D2,port=3D1
> [    6.799992] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=3D25=
6, switch q=3D3,port=3D1
>
> Looking further in bcm_sysport_map_queues() we are getting the following:
>
>     6.223042] brcm-systemport 9300000.ethernet eth0: mapping q=3D0, p=3D0
> [    6.229369] brcm-systemport 9300000.ethernet eth0: mapping q=3D1, p=3D=
0
> [    6.235659] brcm-systemport 9300000.ethernet eth0: mapping q=3D2, p=3D=
0
> [    6.241945] brcm-systemport 9300000.ethernet eth0: mapping q=3D3, p=3D=
0
> [    6.248232] brcm-systemport 9300000.ethernet eth0: mapping q=3D4, p=3D=
0
> [    6.254519] brcm-systemport 9300000.ethernet eth0: mapping q=3D5, p=3D=
0
> [    6.260805] brcm-systemport 9300000.ethernet eth0: mapping q=3D6, p=3D=
0
> [    6.267092] brcm-systemport 9300000.ethernet eth0: mapping q=3D7, p=3D=
0
>
> which means that the call to netif_set_real_num_tx_queues() that is
> executed for the SYSTEMPORT Lite is not taking effect because it is
> after the register_netdevice(). Insead of using a CHANGEUPPER notifier,
> we can use a REGISTER notifier event and doing that works just fine with
> the same semantics as the DSA notifier being removed. This incremental
> patch on top of your patch works for me (tm):
>
> https://github.com/ffainelli/linux/commit/f5095ab5c1f31db133d62273928b224=
674626b75

This is odd, the netif_set_real_num_tx_queues() call should not fail or
be ignored even if the interface was registered. I had tested this already
on my enetc + felix combo on LS1028A.

static int enetc_dsa_join(struct net_device *dev,
			  struct net_device *slave_dev)
{
	int err;

	netdev_err(slave_dev, "Hello!\n");

	err =3D netif_set_real_num_tx_queues(slave_dev,
					   slave_dev->num_tx_queues / 2);
	if (err)
		return err;

	netdev_err(slave_dev, "New number of real TX queues: %d\n",
		   slave_dev->real_num_tx_queues);

	return 0;
}

prints:

[    7.002328] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:0=
0.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
[    7.021190] mscc_felix 0000:00:00.5 swp0: Hello!
[    7.028657] mscc_felix 0000:00:00.5 swp0: New number of real TX queues: =
4
[    7.035589] mscc_felix 0000:00:00.5 swp0: Hello!
[    7.040380] mscc_felix 0000:00:00.5 swp0: New number of real TX queues: =
4
[    7.290236] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:0=
0.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
[    7.314383] mscc_felix 0000:00:00.5 swp1: Hello!
[    7.321292] mscc_felix 0000:00:00.5 swp1: New number of real TX queues: =
4
[    7.328223] mscc_felix 0000:00:00.5 swp1: Hello!
[    7.332967] mscc_felix 0000:00:00.5 swp1: New number of real TX queues: =
4
[    7.574254] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:0=
0.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
[    7.598431] mscc_felix 0000:00:00.5 swp2: Hello!
[    7.605215] mscc_felix 0000:00:00.5 swp2: New number of real TX queues: =
4
[    7.612145] mscc_felix 0000:00:00.5 swp2: Hello!
[    7.616889] mscc_felix 0000:00:00.5 swp2: New number of real TX queues: =
4
[    7.858868] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:0=
0.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL)
[    7.884240] mscc_felix 0000:00:00.5 swp3: Hello!
[    7.891086] mscc_felix 0000:00:00.5 swp3: New number of real TX queues: =
4
[    7.898018] mscc_felix 0000:00:00.5 swp3: Hello!
[    7.902763] mscc_felix 0000:00:00.5 swp3: New number of real TX queues: =
4

(I am not sure why the notifier is called twice though)

You are saying that here:

	num_tx_queues =3D slave_dev->real_num_tx_queues;

num_tx_queues remains assigned to 8? Does this mean that netif_set_real_num=
_tx_queues
has returned an error code? Can you check why?=
