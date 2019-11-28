Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8703C10C278
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 03:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfK1CmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 21:42:21 -0500
Received: from mail-eopbgr30089.outbound.protection.outlook.com ([40.107.3.89]:15428
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727344AbfK1CmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 21:42:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lolG81wTmqrUL0zq8KunYhAB3LJyB5VH9DWIY2Bzw9B4vGdVhIhI3E5T2R9zcNRqpqXT323UBjPgh+HoAiqIQou6PdYSBNf09aM0sTyjCmkjU2kPQGZUQEjMb0YHdzh1igWxbK3l7KIubNjI0kY8qfA/FKMvaIjefv+TYpJJ4xsYcXVaLSAkw3uABjdlXhsqh5zuzafsPl9rqRzbOW2fhYRY6CtZQGdZCHI0YKkFbWW+frkEFkKcn5Ph2ekokyzAfUWT2qM1ksnJLBCwaE812vcLrSGco4SC7ft791MZR8mCYaXU5p2RJTXJFhllZKANCpIro5FOanJ5sa2mKKzd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5m4aIfSWnpWoOKLmPyQkI0XhNjceY4ZcXuoLfrz+XY=;
 b=PQEi1pPRyOCPRLvinFlK8XJN2A0YcTbGSDokFnUURz+UfOKauPqAkg4cgZv1gshM0FKgfiVCU1myspbA0jEZb7CbskwWESz1DiQyJceo8F/O7ygsbavg5yewL+Bct9PmJ3rp13oto5giKjgCteOQR/nMDaEqFZOojthbVUJuzqy3aBx5nipuCxa0K3A5x6mWZD+HOTQjY7cOcN8kqt6WItTx7cWkY0aXU1TImWzDk5rQCul0ML2SWWc6R3J7Ky2EPa8BYztN1OjNYDKulqXusNzaEnLDazuiTiUVRQNGPweCrjWgbtCQ2hH5MdmydLe1BFoT4DirYAGGBf3FBlO3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5m4aIfSWnpWoOKLmPyQkI0XhNjceY4ZcXuoLfrz+XY=;
 b=cleJDOeUkgrNlmotczpEroG7ZzuteusCoVXUFDFkuUv2xaC5X72G6HhgH7LcyLXCew5klOTPKxlU00QxaIhH98HrgkiONM1byhaXXHiGtzqecT4Ucj3XMXjqcepoO082RUs9CeWDdSL7Z/lvYYfQR/ucOxFFX3W3JLgZSZ+w3sw=
Received: from AM4PR0401MB2226.eurprd04.prod.outlook.com (10.165.45.8) by
 AM4PR0401MB2292.eurprd04.prod.outlook.com (10.165.45.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Thu, 28 Nov 2019 02:42:18 +0000
Received: from AM4PR0401MB2226.eurprd04.prod.outlook.com
 ([fe80::b801:d1fd:15d9:6c85]) by AM4PR0401MB2226.eurprd04.prod.outlook.com
 ([fe80::b801:d1fd:15d9:6c85%11]) with mapi id 15.20.2474.023; Thu, 28 Nov
 2019 02:42:18 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net] net: mscc: ocelot: unregister the PTP clock on deinit
Thread-Topic: [PATCH net] net: mscc: ocelot: unregister the PTP clock on
 deinit
Thread-Index: AQHVpY8XA/ASYkpUUUyg0Zignj6cyKef3t2w
Date:   Thu, 28 Nov 2019 02:42:17 +0000
Message-ID: <AM4PR0401MB2226E08F0618025F3F43EA38F8470@AM4PR0401MB2226.eurprd04.prod.outlook.com>
References: <20191128015636.26961-1-olteanv@gmail.com>
In-Reply-To: <20191128015636.26961-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc0ffceb-21f4-4a80-6f2f-08d773ac95cf
x-ms-traffictypediagnostic: AM4PR0401MB2292:|AM4PR0401MB2292:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0401MB22929221BC7C84770926FB65F8470@AM4PR0401MB2292.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(199004)(189003)(13464003)(478600001)(110136005)(229853002)(99286004)(52536014)(25786009)(66066001)(446003)(66574012)(7736002)(186003)(26005)(102836004)(45080400002)(4326008)(64756008)(81156014)(66556008)(6436002)(66446008)(8676002)(66476007)(66946007)(55016002)(81166006)(53546011)(6506007)(8936002)(76116006)(11346002)(305945005)(74316002)(6246003)(9686003)(33656002)(71190400001)(71200400001)(316002)(76176011)(14454004)(86362001)(2906002)(5660300002)(7696005)(2501003)(54906003)(3846002)(14444005)(256004)(2201001)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0401MB2292;H:AM4PR0401MB2226.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i4+H53qdGNk8B8gClwdCdynkO5opswzdbpKb5BGfGR/NSZwKeiHHRsgs7nz7Ya9pts4HCxuYZCXW23KSPYBsCtchqx5NJB062ixQ/lLsSp7nHwzT/znCBApEnmD/kCAT+7pazNOCjowmaVs9Hqs9cGP7+mONLDU+JOI9KpAxR9N2gcTDAvaId+x3D1FaI+mK/Cm9SBAH9CEcKtxsWbnpEQ6WtC/ak16qAtvTSldyR9K4oUSgoCnuaUXO0h6ugHILtJMI2nK5xcjDwg/82aoqCyg1UerSoVNHMMvhPPWItuOjAkQ6Hyvs3IbPMEnCFmwcxF7btCx4ToaFAkP+NWQTKCKyDoKxZbdiTsrt6bBC0u/wm79WZXLNjBSeCJJSy3eB9InyYa7ljEykBFKb/wILpmmEpmAJxCUXQAz3uJb6K2YdC/FJ/BaGar8BQ0bGPTQl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0ffceb-21f4-4a80-6f2f-08d773ac95cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 02:42:17.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/rww2uerhYsZqj/wA6MBJej11irjKl/QbA0NJMuM9jFCYn9Nap0XNha1Xzm4N1bup4HRJX/LSwsJq1czM828A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2292
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Thursday, November 28, 2019 9:57 AM
> To: davem@davemloft.net; richardcochran@gmail.com
> Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Alexandru Marginean
> <alexandru.marginean@nxp.com>; Xiaoliang Yang
> <xiaoliang.yang_1@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>;
> netdev@vger.kernel.org; alexandre.belloni@bootlin.com;
> UNGLinuxDriver@microchip.com; Vladimir Oltean <vladimir.oltean@nxp.com>
> Subject: [PATCH net] net: mscc: ocelot: unregister the PTP clock on deini=
t
>=20
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Currently a switch driver deinit frees the regmaps, but the PTP clock is =
still out
> there, available to user space via /dev/ptpN. Any PTP operation is a tick=
ing
> time bomb, since it will attempt to use the freed regmaps and thus trigge=
r
> kernel panics:
>=20
> [    4.291746] fsl_enetc 0000:00:00.2 eth1: error -22 setting up slave ph=
y
> [    4.291871] mscc_felix 0000:00:00.5: Failed to register DSA switch: -2=
2
> [    4.308666] mscc_felix: probe of 0000:00:00.5 failed with error -22
> [    6.358270] Unable to handle kernel NULL pointer dereference at virtua=
l
> address 0000000000000088
> [    6.367090] Mem abort info:
> [    6.369888]   ESR =3D 0x96000046
> [    6.369891]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [    6.369892]   SET =3D 0, FnV =3D 0
> [    6.369894]   EA =3D 0, S1PTW =3D 0
> [    6.369895] Data abort info:
> [    6.369897]   ISV =3D 0, ISS =3D 0x00000046
> [    6.369899]   CM =3D 0, WnR =3D 1
> [    6.369902] user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000020d58c700=
0
> [    6.369904] [0000000000000088] pgd=3D00000020d5912003,
> pud=3D00000020d5915003, pmd=3D0000000000000000
> [    6.369914] Internal error: Oops: 96000046 [#1] PREEMPT SMP
> [    6.420443] Modules linked in:
> [    6.423506] CPU: 1 PID: 262 Comm: phc_ctl Not tainted
> 5.4.0-03625-gb7b2a5dadd7f #204
> [    6.431273] Hardware name: LS1028A RDB Board (DT)
> [    6.435989] pstate: 40000085 (nZcv daIf -PAN -UAO)
> [    6.440802] pc : css_release+0x24/0x58
> [    6.444561] lr : regmap_read+0x40/0x78
> [    6.448316] sp : ffff800010513cc0
> [    6.451636] x29: ffff800010513cc0 x28: ffff002055873040
> [    6.456963] x27: 0000000000000000 x26: 0000000000000000
> [    6.462289] x25: 0000000000000000 x24: 0000000000000000
> [    6.467617] x23: 0000000000000000 x22: 0000000000000080
> [    6.472944] x21: ffff800010513d44 x20: 0000000000000080
> [    6.478270] x19: 0000000000000000 x18: 0000000000000000
> [    6.483596] x17: 0000000000000000 x16: 0000000000000000
> [    6.488921] x15: 0000000000000000 x14: 0000000000000000
> [    6.494247] x13: 0000000000000000 x12: 0000000000000000
> [    6.499573] x11: 0000000000000000 x10: 0000000000000000
> [    6.504899] x9 : 0000000000000000 x8 : 0000000000000000
> [    6.510225] x7 : 0000000000000000 x6 : ffff800010513cf0
> [    6.515550] x5 : 0000000000000000 x4 : 0000000fffffffe0
> [    6.520876] x3 : 0000000000000088 x2 : ffff800010513d44
> [    6.526202] x1 : ffffcada668ea000 x0 : ffffcada64d8b0c0
> [    6.531528] Call trace:
> [    6.533977]  css_release+0x24/0x58
> [    6.537385]  regmap_read+0x40/0x78
> [    6.540795]  __ocelot_read_ix+0x6c/0xa0
> [    6.544641]  ocelot_ptp_gettime64+0x4c/0x110
> [    6.548921]  ptp_clock_gettime+0x4c/0x58
> [    6.552853]  pc_clock_gettime+0x5c/0xa8
> [    6.556699]  __arm64_sys_clock_gettime+0x68/0xc8
> [    6.561331]  el0_svc_common.constprop.2+0x7c/0x178
> [    6.566133]  el0_svc_handler+0x34/0xa0
> [    6.569891]  el0_sync_handler+0x114/0x1d0
> [    6.573908]  el0_sync+0x140/0x180
> [    6.577232] Code: d503201f b00119a1 91022263 b27b7be4 (f9004663)
> [    6.583349] ---[ end trace d196b9b14cdae2da ]---
> [    6.587977] Kernel panic - not syncing: Fatal exception
> [    6.593216] SMP: stopping secondary CPUs
> [    6.597151] Kernel Offset: 0x4ada54400000 from 0xffff800010000000
> [    6.603261] PHYS_OFFSET: 0xffffd0a7c0000000
> [    6.607454] CPU features: 0x10002,21806008
> [    6.611558] Memory Limit: none
> [    6.614620] Rebooting in 3 seconds..
>=20
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c
> b/drivers/net/ethernet/mscc/ocelot.c
> index 52a1b1f12af8..245298d9ba8c 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -2166,6 +2166,14 @@ static struct ptp_clock_info ocelot_ptp_clock_info
> =3D {
>  	.adjfine	=3D ocelot_ptp_adjfine,
>  };
>=20
> +static void ocelot_deinit_timestamp(struct ocelot *ocelot) {
> +	if (!ocelot->ptp || !ocelot->ptp_clock)
> +		return;
> +
> +	ptp_clock_unregister(ocelot->ptp_clock);

[Y.b. Lu] It makes sense. How about,

If (ocelot->ptp_clock)
	ptp_clock_unregister(ocelot->ptp_clock);

> +}
> +
>  static int ocelot_init_timestamp(struct ocelot *ocelot)  {
>  	ocelot->ptp_info =3D ocelot_ptp_clock_info; @@ -2508,6 +2516,7 @@ void
> ocelot_deinit(struct ocelot *ocelot)
>  	destroy_workqueue(ocelot->stats_queue);
>  	mutex_destroy(&ocelot->stats_lock);
>  	ocelot_ace_deinit();
> +	ocelot_deinit_timestamp(ocelot);
>=20
>  	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
>  		port =3D ocelot->ports[i];
> --
> 2.17.1

