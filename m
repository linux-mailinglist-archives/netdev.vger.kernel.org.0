Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C010D0B4
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 05:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfK2D4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 22:56:05 -0500
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:8278
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbfK2D4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 22:56:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH8Opjij+f/muChRqGs91R928GIyiX04Xc7OKLvvsU1/6PjHrdONz7ECqfOsGrUCwxqdldD08dWzQHngR8yZQTPqP1mNkAlfbeIdIXu4GuZz5neywcJix4f2w6BbilrGfFQkCBAHd+pAgnNbXD8I+hHoyqKdM/pMd1MqVJh9V0xPuD+V+NjrxFJ8YE5m+UoXxer4OiLboIXrbCCQsV1UuPPUWyFx40Tf7UuWo9nU8NvB7QHanN77F0/uK3pKw6V+AcIejarPw2OBbvQ+hWxKuujUeuNdQucGH99YEsmzOF4GHYL8+ckJne3c5q0q46MdMDgqBwrcT0NIGUa7i0tB+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn16vpCyoy2Eq0e97zVtqyFGv3rmiP9HKU0yl6sd2Eo=;
 b=oYvKdbkXVldKocBcY/qYiX8awn16wZdAv69PQfO16ZNH1zE4Q4+eykeOXkBiA9tRLGdt6G4HrpNKpOSgo6HU6N2uSDjvJibLCu0/yK/9WsilhHzHD+ucZtPtmlUav73H4r9QQVDGke+9yajdU6rx0U9uDePwksrSp9MjFi9xwDNt/jwDYSX+AZCpJzyz0fum0Nwnaby4q0z2l05qLhJj/M55EJRD3cGPQJY2F612dIJkgmq3ikJJSXGVUhFWBOTvpv9Kq5xYunCcYAHP9zVn7PmemzceqY5mtfjDTMHl93Pk0WcDrXA5L4y7IbA0GgJS+IHSK3qbn/FlYYvWixpT0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn16vpCyoy2Eq0e97zVtqyFGv3rmiP9HKU0yl6sd2Eo=;
 b=ATmBPNvSBV281Pb8XdBMkQNHAbM/nMwQes/bIWgPbBl5UGU7Yk7qL3fKhgEq/3aU2cAbhDwzSENPwV9cljWSp1c7QkdkMqu2XHwtB8ES/uhZsRGx8Nye7Kd2gIPB2EVB9pm5RuGfePMRWHwQkTm2lVYLThkPeEPMThuVXw+Yi1c=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2462.eurprd04.prod.outlook.com (10.168.67.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 29 Nov 2019 03:55:59 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::391e:6024:cefd:6d51]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::391e:6024:cefd:6d51%4]) with mapi id 15.20.2495.014; Fri, 29 Nov 2019
 03:55:59 +0000
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: RE: [PATCH v2 net] net: mscc: ocelot: unregister the PTP clock on
 deinit
Thread-Topic: [PATCH v2 net] net: mscc: ocelot: unregister the PTP clock on
 deinit
Thread-Index: AQHVpd5QLfScsj5VUk+8+3llKwELWaehhbnA
Date:   Fri, 29 Nov 2019 03:55:59 +0000
Message-ID: <VI1PR0401MB22370E9635D4452E8C2BEE09F8460@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20191128112342.2547-1-olteanv@gmail.com>
In-Reply-To: <20191128112342.2547-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9068c0eb-cca7-42cb-28ac-08d774800ba9
x-ms-traffictypediagnostic: VI1PR0401MB2462:|VI1PR0401MB2462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2462B1BE0D2A847CEE99435AF8460@VI1PR0401MB2462.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(13464003)(199004)(189003)(33656002)(81156014)(71190400001)(71200400001)(99286004)(76116006)(81166006)(25786009)(9686003)(229853002)(55016002)(86362001)(2501003)(2906002)(6436002)(54906003)(6246003)(11346002)(446003)(7416002)(76176011)(2201001)(7736002)(5660300002)(14454004)(256004)(8676002)(3846002)(110136005)(66066001)(14444005)(8936002)(66476007)(6506007)(305945005)(6116002)(66574012)(52536014)(186003)(478600001)(7696005)(316002)(4326008)(102836004)(66556008)(66946007)(66446008)(26005)(53546011)(74316002)(45080400002)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2462;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bcH6L9ILd5MW43lUCTL7vM8UJCWHv3ttoREAqnElQqhvjpxXbdrM2DA4jIx6D4ghdc477bNXdEuaidIoMVcun3uB70ly2wcrlLRCfvUsm8pdHkpc8aTS3ABOZKyDQZdKIyESNf0F2lSKhJK8ANxEXLx1g3OsBiac/MEo4WwAu17K16B1k8c7NsfX4xwvb4mg7MUl5jdnK4ghKha+BZCQMjVsZteYcCzRvayl+6hqhH/dwxzs7PKtib2xud4THsjbrz5iOA3zj6bd7reeyQYMEmORK1Eo/lm14qrg/SJPTw0Q5EthA7r6onAfdKGBdtK6kFuEkqRjn42v/cH1StcSC7eJ9M8fXdhaL3tJkXEfklvnQuv1aDd3Is9a6/baQR+zBl/ure9lmGItHgvyQu3avu49Pra2bzRF2BydOPiiBd2GnDd+3gfm5O7jWlSFZQU3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9068c0eb-cca7-42cb-28ac-08d774800ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 03:55:59.5366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBof0YluuzTOhpS5SQhWZolH4Qu1IFaL/ctjNAez82BmqX6Z1Pxw5bDionoEzjfN850+e5HS1opAWN+u1BGJKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2462
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Thursday, November 28, 2019 7:24 PM
> To: davem@davemloft.net; richardcochran@gmail.com
> Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Alexandru Marginean
> <alexandru.marginean@nxp.com>; Xiaoliang Yang
> <xiaoliang.yang_1@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>;
> netdev@vger.kernel.org; alexandre.belloni@bootlin.com;
> UNGLinuxDriver@microchip.com; Vladimir Oltean
> <vladimir.oltean@nxp.com>; Antoine Tenart <antoine.tenart@bootlin.com>
> Subject: [PATCH v2 net] net: mscc: ocelot: unregister the PTP clock on de=
init

[Y.b. Lu]
Acked-by: Yangbo Lu <yangbo.lu@nxp.com>

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
>=20
> And now that ocelot->ptp_clock is checked at exit, prevent a potential er=
ror
> where ptp_clock_register returned a pointer-encoded error, which we are
> keeping in the ocelot private data structure. So now,
> ocelot->ptp_clock is now either NULL or a valid pointer.
>=20
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> - Dropped the redundant check on ocelot->ptp and changed the topic of
>   the if condition.
> - Populated ocelot->ptp_clock in ocelot_init_timestamp only on valid
>   return value from ptp_clock_register, so that the deinit check can
>   never mis-trigger.
>=20
>  drivers/net/ethernet/mscc/ocelot.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c
> b/drivers/net/ethernet/mscc/ocelot.c
> index 52a1b1f12af8..875eea702c58 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -2166,16 +2166,26 @@ static struct ptp_clock_info
> ocelot_ptp_clock_info =3D {
>  	.adjfine	=3D ocelot_ptp_adjfine,
>  };
>=20
> +static void ocelot_deinit_timestamp(struct ocelot *ocelot) {
> +	if (ocelot->ptp_clock)
> +		ptp_clock_unregister(ocelot->ptp_clock);
> +}
> +
>  static int ocelot_init_timestamp(struct ocelot *ocelot)  {
> +	struct ptp_clock *ptp_clock;
> +
>  	ocelot->ptp_info =3D ocelot_ptp_clock_info;
> -	ocelot->ptp_clock =3D ptp_clock_register(&ocelot->ptp_info, ocelot->dev=
);
> -	if (IS_ERR(ocelot->ptp_clock))
> -		return PTR_ERR(ocelot->ptp_clock);
> +	ptp_clock =3D ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
> +	if (IS_ERR(ptp_clock))
> +		return PTR_ERR(ptp_clock);
>  	/* Check if PHC support is missing at the configuration level */
> -	if (!ocelot->ptp_clock)
> +	if (!ptp_clock)
>  		return 0;
>=20
> +	ocelot->ptp_clock =3D ptp_clock;
> +
>  	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
>  	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
>  	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH); @@ -2508,6
> +2518,7 @@ void ocelot_deinit(struct ocelot *ocelot)
>  	destroy_workqueue(ocelot->stats_queue);
>  	mutex_destroy(&ocelot->stats_lock);
>  	ocelot_ace_deinit();
> +	ocelot_deinit_timestamp(ocelot);
>=20
>  	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
>  		port =3D ocelot->ports[i];
> --
> 2.17.1

