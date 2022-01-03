Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9E4833B3
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 15:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiACOn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 09:43:26 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:48478
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234253AbiACOnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 09:43:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzCeNox8MZsiKA7bHEh06XCbSev/aq+nbLyDFskxw3S0l4rrL+MM9Jw7RaTN1vvrB+GZFbGt/GXb52YPfxV2wDYh98fwRyhYdfB+BJuNFpe2KZT2qKq1LCn9p80csY0mbIdcL/pIoK095UtF8OVPf6351J15UjTB9z8yFgXMu77JiHD100HRX9rAOpYlVo4z4g6pnHqwiKdxf8D5gz1ssGUAy8qTkpVysll1QmMh2vIOYm186exYF1qlC3VEGcLfZie/fIb/PPLBoT71Uu0BsoELCSdD62IDiU8R60+87bmvPJGMw/Ije/o/NcX/stCr2qwiq1cDa/Z4u4P5ZT3XrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukqgMONB05odJ6cu8jwfl3x7jLBBmqBzws317BOJRME=;
 b=nurqg4Wts7SuK6dGTSjfSJToY3v03sbQq7YLjVhONXEbyCVVBxztKHg5+6PnblAydiET+SbwuI+pd5Zsr8zwZBKvl8fWXJXUaDwfS7pqArHayQTD9NklRIHQULZ11NPmZgjEJyn2ZA/qcct0msDjuShhONWYUtpW0Ncw39q801Cu937aOf/QNA9qCu6f8ypDnkwgJNwKVogZIBtmALUFcG42qqFueUNPUL7W7pDFKISYTJPZezc7DzY5tqVVLylD4dYvazpB/fkeiGY363ikfSzY9h9U0Tz3P6mT+onNBICbyxyIdLfiZgqsizc9M1ko+8ymnkXFLdNn+8OIEL2DwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukqgMONB05odJ6cu8jwfl3x7jLBBmqBzws317BOJRME=;
 b=P714MyD3dhYuyr2XmvDWlGwfcx09pmVj07ZQ39iYZpRxfjV0PCJsrjsBPQuFBFXnetPIttjObKIIapTNmzom3fi2DhyOUhMOcwLs1IrjPQbJCVgE035lMIl7m5GA44vyyWiXKDgsdtXRnLUdvnhlstqSLfy+iFuhPpG1KZLPqts=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 14:43:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 14:43:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Topic: [PATCH net-next 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Index: AQHYAKMIHZYff/CKbEOFLJOI5RqZu6xRXzmA
Date:   Mon, 3 Jan 2022 14:43:20 +0000
Message-ID: <20220103144319.w65nc3c4ru24zzh7@skbuf>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
 <20220103131039.3473876-4-horatiu.vultur@microchip.com>
In-Reply-To: <20220103131039.3473876-4-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd4d3772-090e-4650-6a27-08d9cec76338
x-ms-traffictypediagnostic: VI1PR0402MB2799:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB279913C91438CD080D4FDB0DE0499@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Li/yhjnxJUxR9NA0gMmlY9QRvz/OAo2Pn2iZqPn5ITpJm1JfOXyD/Q3Zgd73AVbfywZ4F6tI544lfyHAmWUNOPns+QGB+qU8Ho1IWeeYSQq3JArwlOAsAz3wZ20YG6V98kXn0MdDSvX+O05dP4iJ6Mbj/j9d0jMYxzwh48QW65zgEq4u55eQVN6YZiRg5zAT/6CCYs1QG4/xzRG/GC6H9QYxMQ10Rtm7lmBOnTtVqgqfljXvWG4R2ZZrESerf+KWc9a2wPhaNnEjz1QjryUI7r3FPSH89GSHsyj/cU3vKzexYeViGNFftO2YqeBHnKPlJylaLRv44dSJiUs3kJHeZLtRtT9gEoJ1uUSz6QF/uqIoJlngj6kFpS3d4/bsFVpCsMWc/dsAEQdtJJfke8h5GHdw9D3mZYgROvmvUhs5+IH1ViRrXlYd4DL/7LRRatnw2PW+hHEnQFGEuNOPxSfBTXub4Npfu9EPOUvJgngoP90eapnoupa4nYrmSEyLZNNMF9muy5w1vl7LXaktd+0r/pFg0cQ7uEg6fnVltGWXZ9Y6RAsVcuhOZ7YMiP3n2y8CqoXM+6ehu3QEEShp/eu/MIqQceqTauh1FlG6TmpOJEnZuMbBHDpiJYQWsx/0Ug4e8BDEIdebLFJXec1qzJD/Lciwfo5RR0Hep63poqMl4G/NAiasPEKqiJZUZTPWDm5EcpQ8N2vrxuZVyEjIcwNfkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(2906002)(66556008)(76116006)(66946007)(91956017)(66476007)(66446008)(8676002)(6916009)(71200400001)(64756008)(5660300002)(6512007)(8936002)(30864003)(54906003)(1076003)(83380400001)(33716001)(4326008)(316002)(38100700002)(86362001)(122000001)(6506007)(38070700005)(508600001)(186003)(9686003)(6486002)(26005)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ngml1veS+5QSAC7uCkmbC05pNTfb/8xDHazRkF3OP4gcOUuISfV9qCluMEIX?=
 =?us-ascii?Q?8hRb4oM5fDv0jTU2a6sYGvak+k40LSSjjqgsPIKuuCihkQ5QaWdnOw6EhFqC?=
 =?us-ascii?Q?VVqJM08jXKUHak66cmimKRys9pM0yPLe72g4eDkcH2p3P+OfbLFHIe4lIgEM?=
 =?us-ascii?Q?PBqaafac4VVtqJMRxH2qAaJtW093QuR8Bw4Z/ApeVqOb1O5FMSaxFIXhniEV?=
 =?us-ascii?Q?634R6q0xxgGySW/FuQDnxw9tKm1SkeInOWW6LA3gf2us8SKUnjqXJWn0Abwg?=
 =?us-ascii?Q?k5Nos/Tt4qBucb6Q5MjRvj40tW9sS/U6QYgnZusZvEKhKisJbzKvvjhAyFRA?=
 =?us-ascii?Q?UPSc33g6Kq3R3g2cQwu2jj5BcpDw0WMC0gp4gJbMxjbXzbcIqd9/Yd2WWT99?=
 =?us-ascii?Q?2YcT9pa6PQtsq/m0iuGNVyKOA929R7l5SDzlHbYQ9vecg5W2n+b5kJGzMyxH?=
 =?us-ascii?Q?wq4/E9cZhtdGfWmHU2liGvwHl5XsucPvtcAvvTSNrXHypzXPadbxbfWYLbnA?=
 =?us-ascii?Q?HSE1irb3qms1pZwnX+8nWGX96EmceMPiDROKgLrINpASSxIODZ1OBi7oTXYA?=
 =?us-ascii?Q?yZaY6hzUl3B/yEvqSxAyMI+Vz/9r+Xht9FUa8Zj95QkTQIKPWwU6qkEp00A5?=
 =?us-ascii?Q?eU8LpC0d29lgFa6bAHgCf7fJWPfgr7KEcS+rRA/MjS3DesRM8shhNQuRpSIA?=
 =?us-ascii?Q?lDN5HUCINYVv9/kViK+ARxaMwuotDFw1U6W1INe9DI1s/JNUfEtKe/7H9vuS?=
 =?us-ascii?Q?2EKmvcpyHg9zQ8tV6phbF6irN2Fq/os1+B7AcMsu+iTYEcvWiKvHY7iVjJQ5?=
 =?us-ascii?Q?shnSGZHEtnANIfTQPP/zqzlr8coXA9X+Q3b2QL8EMpgc5Bo9dtUR8iz7Rbqv?=
 =?us-ascii?Q?X3nEvcOvvrjfwWHcy3dl3IDu67MVmmR154iREbXdONeyRoWqZN5ZC0ZfR55B?=
 =?us-ascii?Q?gin4x5dmKC9TlMjMR6ZBk33M/XfHjn1MgJ6KiCfikY3mHf8tgOzCMJKJesjT?=
 =?us-ascii?Q?BP9LczL4UU4XdvU2SQmzsMWi8UtpQhbF9VeWNTrmfci0sU2Lu1aidATvFE+j?=
 =?us-ascii?Q?Gr1SdtFsQEPgU15WBbHqcqoSLXTPJ7XuQbPqrRFx19rSVqdjiL2/6BdgZwSy?=
 =?us-ascii?Q?Og1EJLIVYdgaHP+JsLsXlb8Kgee8R9VMKNG8BpLfw+4rPVtha+7Cx9BOte2i?=
 =?us-ascii?Q?fBxj8L1DB4cfbUuQ8sIP5F2hFPmnhdL3NJsI9Br4cVM3o9D2WOBqWICQV2Hp?=
 =?us-ascii?Q?b98gfimYkTf7fLZRHLr7Ae2mnRRK9KnILCBIFYYUklzplfJE/VsJJMmI2EBB?=
 =?us-ascii?Q?WQEvQjaH8Cxlho66GdK5SmDF4ka3rRJcC8GokIQTUjipyM1GNfhcbnUyBdSd?=
 =?us-ascii?Q?InzqpM/zYqvIgAPBc4SYuOQ598an4GFpqCeY2JB+dw41jBm81xX658vScK7O?=
 =?us-ascii?Q?VOD525MnuPp3uL/T25rlhCkT934Fgfle4sojJqKcGrIkiYQt0cXdMhHy4dwA?=
 =?us-ascii?Q?LOMv1hKvkMv5nW62pR9nAxGmPpo0GYCClAEuZ7L77fjzxOcbk2JqTEOxfafi?=
 =?us-ascii?Q?q2XBqNzXeRET4y8uMVsu4WZlTe+9xPEJEKlWpE+V2j+E/Fs2l6AwSURxRtXH?=
 =?us-ascii?Q?Mew5kg5yybXfY0xiwI4uN58=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72572F50714D7548941B029F8ADC049A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4d3772-090e-4650-6a27-08d9cec76338
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 14:43:20.7153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XaSV7xFGfQQHJd7JPUUO1IBDhEJ82ij6vA7TFhE16u0vT9A4qGN44I7aE6uT598SHeHyiJb4Cf6iMs0fhQVpdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 02:10:39PM +0100, Horatiu Vultur wrote:
> Extend lan966x driver with mdb support by implementing the switchdev
> calls: SWITCHDEV_OBJ_ID_PORT_MDB and SWITCHDEV_OBJ_ID_HOST_MDB.
> It is allowed to add both ipv4/ipv6 entries and l2 entries. To add
> ipv4/ipv6 entries is not required to use the PGID table while for l2
> entries it is required. The PGID table is much smaller than MAC table
> so only fewer l2 entries can be added.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
>  .../ethernet/microchip/lan966x/lan966x_main.h |  13 +
>  .../ethernet/microchip/lan966x/lan966x_mdb.c  | 500 ++++++++++++++++++
>  .../microchip/lan966x/lan966x_switchdev.c     |   8 +
>  .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
>  6 files changed, 530 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/ne=
t/ethernet/microchip/lan966x/Makefile
> index ec1a1fa8b0d5..040cfff9f577 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_LAN966X_SWITCH) +=3D lan966x-switch.o
> =20
>  lan966x-switch-objs  :=3D lan966x_main.o lan966x_phylink.o lan966x_port.=
o \
>  			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> -			lan966x_vlan.o lan966x_fdb.o
> +			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 2c6bf7b0afdf..2cb70da63db3 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -926,6 +926,7 @@ static int lan966x_probe(struct platform_device *pdev=
)
>  		lan966x_port_init(lan966x->ports[p]);
>  	}
> =20
> +	lan966x_mdb_init(lan966x);
>  	err =3D lan966x_fdb_init(lan966x);
>  	if (err)
>  		goto cleanup_ports;
> @@ -955,6 +956,7 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  	mutex_destroy(&lan966x->stats_lock);
> =20
>  	lan966x_mac_purge_entries(lan966x);
> +	lan966x_mdb_deinit(lan966x);
>  	lan966x_fdb_deinit(lan966x);
> =20
>  	return 0;
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 49ce6a04ca40..76f0b5446b2e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -107,6 +107,10 @@ struct lan966x {
>  	/* worqueue for fdb */
>  	struct workqueue_struct *fdb_work;
>  	struct list_head fdb_entries;
> +
> +	/* mdb */
> +	struct list_head mdb_entries;
> +	struct list_head pgid_entries;
>  };
> =20
>  struct lan966x_port_config {
> @@ -213,6 +217,15 @@ int lan966x_handle_fdb(struct net_device *dev,
>  		       unsigned long event, const void *ctx,
>  		       const struct switchdev_notifier_fdb_info *fdb_info);
> =20
> +void lan966x_mdb_init(struct lan966x *lan966x);
> +void lan966x_mdb_deinit(struct lan966x *lan966x);
> +int lan966x_handle_port_mdb_add(struct lan966x_port *port,
> +				const struct switchdev_obj *obj);
> +int lan966x_handle_port_mdb_del(struct lan966x_port *port,
> +				const struct switchdev_obj *obj);
> +void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid);
> +void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid);
> +
>  static inline void __iomem *lan_addr(void __iomem *base[],
>  				     int id, int tinst, int tcnt,
>  				     int gbase, int ginst,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c b/drive=
rs/net/ethernet/microchip/lan966x/lan966x_mdb.c
> new file mode 100644
> index 000000000000..4fd8b06a56c1
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
> @@ -0,0 +1,500 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <net/switchdev.h>
> +
> +#include "lan966x_main.h"
> +
> +struct lan966x_pgid_entry {
> +	struct list_head list;
> +	int index;
> +	refcount_t refcount;
> +	u16 ports;
> +};
> +
> +struct lan966x_mdb_entry {
> +	struct list_head list;
> +	unsigned char mac[ETH_ALEN];
> +	u16 vid;
> +	u16 ports;
> +	struct lan966x_pgid_entry *pgid;
> +	bool cpu_copy;
> +};
> +
> +void lan966x_mdb_init(struct lan966x *lan966x)
> +{
> +	INIT_LIST_HEAD(&lan966x->mdb_entries);
> +	INIT_LIST_HEAD(&lan966x->pgid_entries);
> +}
> +
> +static void lan966x_mdb_purge_mdb_entries(struct lan966x *lan966x)
> +{
> +	struct lan966x_mdb_entry *mdb_entry, *tmp;
> +
> +	list_for_each_entry_safe(mdb_entry, tmp, &lan966x->mdb_entries, list) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +	}
> +}
> +
> +static void lan966x_mdb_purge_pgid_entries(struct lan966x *lan966x)
> +{
> +	struct lan966x_pgid_entry *pgid_entry, *tmp;
> +
> +	list_for_each_entry_safe(pgid_entry, tmp, &lan966x->pgid_entries, list)=
 {
> +		list_del(&pgid_entry->list);
> +		kfree(pgid_entry);
> +	}
> +}
> +
> +void lan966x_mdb_deinit(struct lan966x *lan966x)
> +{
> +	lan966x_mdb_purge_mdb_entries(lan966x);
> +	lan966x_mdb_purge_pgid_entries(lan966x);
> +}
> +
> +static struct lan966x_mdb_entry *
> +lan966x_mdb_entry_get(struct lan966x *lan966x,
> +		      const unsigned char *mac,
> +		      u16 vid)
> +{
> +	struct lan966x_mdb_entry *mdb_entry;
> +
> +	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
> +		if (ether_addr_equal(mdb_entry->mac, mac) &&
> +		    mdb_entry->vid =3D=3D vid)
> +			return mdb_entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct lan966x_mdb_entry *
> +lan966x_mdb_entry_add(struct lan966x *lan966x,
> +		      const struct switchdev_obj_port_mdb *mdb)
> +{
> +	struct lan966x_mdb_entry *mdb_entry;
> +
> +	mdb_entry =3D kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
> +	if (!mdb_entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ether_addr_copy(mdb_entry->mac, mdb->addr);
> +	mdb_entry->vid =3D mdb->vid;
> +
> +	list_add_tail(&mdb_entry->list, &lan966x->mdb_entries);
> +
> +	return mdb_entry;
> +}
> +
> +static void lan966x_mdb_encode_mac(unsigned char *mac,
> +				   struct lan966x_mdb_entry *mdb_entry,
> +				   enum macaccess_entry_type type)
> +{
> +	ether_addr_copy(mac, mdb_entry->mac);
> +
> +	if (type =3D=3D ENTRYTYPE_MACV4) {
> +		mac[0] =3D 0;
> +		mac[1] =3D mdb_entry->ports >> 8;
> +		mac[2] =3D mdb_entry->ports & 0xff;
> +	} else if (type =3D=3D ENTRYTYPE_MACV6) {
> +		mac[0] =3D mdb_entry->ports >> 8;
> +		mac[1] =3D mdb_entry->ports & 0xff;
> +	}
> +}
> +
> +static int lan966x_mdb_ip_add(struct lan966x_port *port,
> +			      const struct switchdev_obj_port_mdb *mdb,
> +			      enum macaccess_entry_type type)
> +{
> +	bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_mdb_entry *mdb_entry;
> +	unsigned char mac[ETH_ALEN];
> +	bool cpu_copy =3D false;
> +
> +	mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> +	if (!mdb_entry) {
> +		mdb_entry =3D lan966x_mdb_entry_add(lan966x, mdb);
> +		if (IS_ERR(mdb_entry))
> +			return PTR_ERR(mdb_entry);
> +	} else {
> +		lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +		lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +	}
> +
> +	if (cpu_port)
> +		mdb_entry->cpu_copy =3D true;
> +	else
> +		mdb_entry->ports |=3D BIT(port->chip_port);
> +
> +	/* Copy the frame to CPU only if the CPU is the vlan */

s/is the vlan/is in the VLAN/

> +	if (mdb_entry->cpu_copy) {
> +		if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
> +							  mdb_entry->vid))
> +			cpu_copy =3D true;
> +	}

I find it slightly simpler to squash the two if blocks into a single one.

	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, mdb_entry->vid) &&
	    mdb_entry->cpu_copy)
		cpu_copy =3D true;

> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	return lan966x_mac_cpu_copy(lan966x, 0, cpu_copy,
> +				    mac, mdb_entry->vid, type);
> +}
> +
> +static int lan966x_mdb_ip_del(struct lan966x_port *port,
> +			      const struct switchdev_obj_port_mdb *mdb,
> +			      enum macaccess_entry_type type)
> +{
> +	bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_mdb_entry *mdb_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> +	if (!mdb_entry) {
> +		/* If the CPU originted this and the entry was not found, it is

s/originted/originated/

> +		 * because already another port has removed the entry
> +		 */
> +		if (cpu_port)
> +			return 0;

Could you explain again why this is normal? If another port has removed
the entry, how is the address copied to the CPU any longer?

> +		return -ENOENT;
> +	}
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +
> +	if (cpu_port)
> +		mdb_entry->cpu_copy =3D false;
> +	else
> +		mdb_entry->ports &=3D ~BIT(port->chip_port);
> +	if (!mdb_entry->ports && !mdb_entry->cpu_copy) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +		return 0;
> +	}
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	return lan966x_mac_cpu_copy(lan966x, 0, mdb_entry->cpu_copy,
> +				    mac, mdb_entry->vid, type);
> +}
> +
> +static struct lan966x_pgid_entry *
> +lan966x_pgid_entry_add(struct lan966x *lan966x, int index, u16 ports)
> +{
> +	struct lan966x_pgid_entry *pgid_entry;
> +
> +	pgid_entry =3D kzalloc(sizeof(*pgid_entry), GFP_KERNEL);
> +	if (!pgid_entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pgid_entry->ports =3D ports;
> +	pgid_entry->index =3D index;
> +	refcount_set(&pgid_entry->refcount, 1);
> +
> +	list_add_tail(&pgid_entry->list, &lan966x->pgid_entries);
> +
> +	return pgid_entry;
> +}
> +
> +static struct lan966x_pgid_entry *
> +lan966x_pgid_entry_get(struct lan966x *lan966x,
> +		       struct lan966x_mdb_entry *mdb_entry)
> +{
> +	struct lan966x_pgid_entry *pgid_entry;
> +	int index;
> +
> +	/* Try to find an existing pgid that uses the same ports as the
> +	 * mdb_entry
> +	 */
> +	list_for_each_entry(pgid_entry, &lan966x->pgid_entries, list) {
> +		if (pgid_entry->ports =3D=3D mdb_entry->ports) {
> +			refcount_inc(&pgid_entry->refcount);
> +			return pgid_entry;
> +		}
> +	}
> +
> +	/* Try to find an empty pgid entry and allocate one in case it finds it=
,
> +	 * otherwise it means that there are no more resources
> +	 */
> +	for (index =3D PGID_FIRST; index < PGID_LAST; index++) {
> +		bool used =3D false;
> +
> +		list_for_each_entry(pgid_entry, &lan966x->pgid_entries, list) {
> +			if (pgid_entry->index =3D=3D index) {
> +				used =3D true;
> +				break;
> +			}
> +		}
> +
> +		if (!used)
> +			return lan966x_pgid_entry_add(lan966x, index,
> +						      mdb_entry->ports);
> +	}
> +
> +	return ERR_PTR(-ENOSPC);
> +}
> +
> +static void lan966x_pgid_entry_del(struct lan966x *lan966x,
> +				   struct lan966x_pgid_entry *pgid_entry)
> +{
> +	if (!refcount_dec_and_test(&pgid_entry->refcount))
> +		return;
> +
> +	list_del(&pgid_entry->list);
> +	kfree(pgid_entry);
> +}
> +
> +static int lan966x_mdb_l2_add(struct lan966x_port *port,
> +			      const struct switchdev_obj_port_mdb *mdb,
> +			      enum macaccess_entry_type type)
> +{
> +	bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_pgid_entry *pgid_entry;
> +	struct lan966x_mdb_entry *mdb_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> +	if (!mdb_entry) {
> +		mdb_entry =3D lan966x_mdb_entry_add(lan966x, mdb);
> +		if (IS_ERR(mdb_entry))
> +			return PTR_ERR(mdb_entry);
> +	} else {
> +		lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
> +		lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +		lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +	}
> +
> +	if (cpu_port) {
> +		mdb_entry->ports |=3D BIT(CPU_PORT);
> +		mdb_entry->cpu_copy =3D true;
> +	} else {
> +		mdb_entry->ports |=3D BIT(port->chip_port);
> +	}
> +
> +	pgid_entry =3D lan966x_pgid_entry_get(lan966x, mdb_entry);
> +	if (IS_ERR(pgid_entry)) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +		return PTR_ERR(pgid_entry);
> +	}
> +	mdb_entry->pgid =3D pgid_entry;
> +
> +	/* Copy the frame to CPU only if the CPU is the vlan */
> +	if (mdb_entry->cpu_copy) {
> +		if (!lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
> +							   mdb_entry->vid))
> +			mdb_entry->ports &=3D BIT(CPU_PORT);
> +	}
> +
> +	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
> +		ANA_PGID_PGID,
> +		lan966x, ANA_PGID(pgid_entry->index));
> +
> +	return lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
> +				 mdb_entry->vid, type);
> +}
> +
> +static int lan966x_mdb_l2_del(struct lan966x_port *port,
> +			      const struct switchdev_obj_port_mdb *mdb,
> +			      enum macaccess_entry_type type)
> +{
> +	bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_pgid_entry *pgid_entry;
> +	struct lan966x_mdb_entry *mdb_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> +	if (!mdb_entry)
> +		return -ENOENT;
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
> +
> +	if (cpu_port)
> +		mdb_entry->ports &=3D ~BIT(CPU_PORT);
> +	else
> +		mdb_entry->ports &=3D ~BIT(port->chip_port);
> +	if (!mdb_entry->ports) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +		return 0;
> +	}
> +
> +	pgid_entry =3D lan966x_pgid_entry_get(lan966x, mdb_entry);
> +	if (IS_ERR(pgid_entry)) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +		return PTR_ERR(pgid_entry);
> +	}
> +	mdb_entry->pgid =3D pgid_entry;
> +
> +	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
> +		ANA_PGID_PGID,
> +		lan966x, ANA_PGID(pgid_entry->index));
> +
> +	return lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
> +				 mdb_entry->vid, type);
> +}
> +
> +static enum macaccess_entry_type
> +lan966x_mdb_classify(const unsigned char *mac)
> +{
> +	if (mac[0] =3D=3D 0x01 && mac[1] =3D=3D 0x00 && mac[2] =3D=3D 0x5e)
> +		return ENTRYTYPE_MACV4;
> +	if (mac[0] =3D=3D 0x33 && mac[1] =3D=3D 0x33)
> +		return ENTRYTYPE_MACV6;
> +	return ENTRYTYPE_LOCKED;
> +}
> +
> +int lan966x_handle_port_mdb_add(struct lan966x_port *port,
> +				const struct switchdev_obj *obj)
> +{
> +	const struct switchdev_obj_port_mdb *mdb =3D SWITCHDEV_OBJ_PORT_MDB(obj=
);
> +	enum macaccess_entry_type type;
> +
> +	/* Split the way the entries are added for ipv4/ipv6 and for l2. The
> +	 * reason is that for ipv4/ipv6 it doesn't require to use any pgid
> +	 * entry, while for l2 is required to use pgid entries
> +	 */
> +	type =3D lan966x_mdb_classify(mdb->addr);
> +	if (type =3D=3D ENTRYTYPE_MACV4 ||
> +	    type =3D=3D ENTRYTYPE_MACV6)
> +		return lan966x_mdb_ip_add(port, mdb, type);
> +	else
> +		return lan966x_mdb_l2_add(port, mdb, type);
> +
> +	return 0;
> +}
> +
> +int lan966x_handle_port_mdb_del(struct lan966x_port *port,
> +				const struct switchdev_obj *obj)
> +{
> +	const struct switchdev_obj_port_mdb *mdb =3D SWITCHDEV_OBJ_PORT_MDB(obj=
);
> +	enum macaccess_entry_type type;
> +
> +	/* Split the way the entries are removed for ipv4/ipv6 and for l2. The
> +	 * reason is that for ipv4/ipv6 it doesn't require to use any pgid
> +	 * entry, while for l2 is required to use pgid entries
> +	 */
> +	type =3D lan966x_mdb_classify(mdb->addr);
> +	if (type =3D=3D ENTRYTYPE_MACV4 ||
> +	    type =3D=3D ENTRYTYPE_MACV6)
> +		return lan966x_mdb_ip_del(port, mdb, type);
> +	else
> +		return lan966x_mdb_l2_del(port, mdb, type);
> +
> +	return 0;

The "return 0" is dead code. I would expect:

	if (type =3D=3D ENTRYTYPE_MACV4 || type =3D=3D ENTRYTYPE_MACV6)
		return lan966x_mdb_ip_del(port, mdb, type);

	return lan966x_mdb_l2_del(port, mdb, type);

> +}
> +
> +static void lan966x_mdb_ip_cpu_copy(struct lan966x *lan966x,
> +				    struct lan966x_mdb_entry *mdb_entry,
> +				    enum macaccess_entry_type type)
> +{
> +	unsigned char mac[ETH_ALEN];
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +	lan966x_mac_cpu_copy(lan966x, 0, true, mac, mdb_entry->vid, type);
> +}
> +
> +static void lan966x_mdb_l2_cpu_copy(struct lan966x *lan966x,
> +				    struct lan966x_mdb_entry *mdb_entry,
> +				    enum macaccess_entry_type type)
> +{
> +	struct lan966x_pgid_entry *pgid_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +
> +	mdb_entry->ports |=3D BIT(CPU_PORT);
> +
> +	pgid_entry =3D lan966x_pgid_entry_get(lan966x, mdb_entry);
> +	if (IS_ERR(pgid_entry))
> +		return;
> +
> +	mdb_entry->pgid =3D pgid_entry;
> +
> +	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
> +		ANA_PGID_PGID,
> +		lan966x, ANA_PGID(pgid_entry->index));
> +
> +	lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
> +			  mdb_entry->vid, type);
> +}
> +
> +void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid)
> +{
> +	struct lan966x_mdb_entry *mdb_entry;
> +	enum macaccess_entry_type type;
> +
> +	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
> +		if (mdb_entry->vid !=3D vid || !mdb_entry->cpu_copy)
> +			continue;
> +
> +		type =3D lan966x_mdb_classify(mdb_entry->mac);
> +		if (type =3D=3D ENTRYTYPE_MACV4 ||
> +		    type =3D=3D ENTRYTYPE_MACV6)
> +			lan966x_mdb_ip_cpu_copy(lan966x, mdb_entry, type);
> +		else
> +			lan966x_mdb_l2_cpu_copy(lan966x, mdb_entry, type);
> +	}
> +}
> +
> +static void lan966x_mdb_ip_cpu_remove(struct lan966x *lan966x,
> +				      struct lan966x_mdb_entry *mdb_entry,
> +				      enum macaccess_entry_type type)
> +{
> +	unsigned char mac[ETH_ALEN];
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +	lan966x_mac_cpu_copy(lan966x, 0, false, mac, mdb_entry->vid, type);
> +}
> +
> +static void lan966x_mdb_l2_cpu_remove(struct lan966x *lan966x,
> +				      struct lan966x_mdb_entry *mdb_entry,
> +				      enum macaccess_entry_type type)
> +{
> +	struct lan966x_pgid_entry *pgid_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	lan966x_pgid_entry_del(lan966x, mdb_entry->pgid);
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +
> +	mdb_entry->ports &=3D ~BIT(CPU_PORT);
> +
> +	pgid_entry =3D lan966x_pgid_entry_get(lan966x, mdb_entry);
> +	if (IS_ERR(pgid_entry))
> +		return;
> +
> +	mdb_entry->pgid =3D pgid_entry;
> +
> +	lan_rmw(ANA_PGID_PGID_SET(mdb_entry->ports),
> +		ANA_PGID_PGID,
> +		lan966x, ANA_PGID(pgid_entry->index));
> +
> +	lan966x_mac_learn(lan966x, pgid_entry->index, mdb_entry->mac,
> +			  mdb_entry->vid, type);
> +}
> +
> +void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid)
> +{
> +	struct lan966x_mdb_entry *mdb_entry;
> +	enum macaccess_entry_type type;
> +
> +	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
> +		if (mdb_entry->vid !=3D vid || !mdb_entry->cpu_copy)
> +			continue;
> +
> +		type =3D lan966x_mdb_classify(mdb_entry->mac);
> +		if (type =3D=3D ENTRYTYPE_MACV4 ||
> +		    type =3D=3D ENTRYTYPE_MACV6)
> +			lan966x_mdb_ip_cpu_remove(lan966x, mdb_entry, type);
> +		else
> +			lan966x_mdb_l2_cpu_remove(lan966x, mdb_entry, type);
> +	}
> +}
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index deb3dd5be67a..7de55f6a4da8 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -438,6 +438,10 @@ static int lan966x_handle_port_obj_add(struct net_de=
vice *dev, const void *ctx,
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		err =3D lan966x_handle_port_vlan_add(port, obj);
>  		break;
> +	case SWITCHDEV_OBJ_ID_PORT_MDB:
> +	case SWITCHDEV_OBJ_ID_HOST_MDB:
> +		err =3D lan966x_handle_port_mdb_add(port, obj);
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> @@ -473,6 +477,10 @@ static int lan966x_handle_port_obj_del(struct net_de=
vice *dev, const void *ctx,
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		err =3D lan966x_handle_port_vlan_del(port, obj);
>  		break;
> +	case SWITCHDEV_OBJ_ID_PORT_MDB:
> +	case SWITCHDEV_OBJ_ID_HOST_MDB:

The HOST_MDB switchdev events are replicated per the number of ports in
the bridge. So I would expect that you keep refcounts on them, otherwise
the first deletion of such an element would trigger the removal of the
entry from hardware even though it's still in use.

> +		err =3D lan966x_handle_port_mdb_del(port, obj);
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> index 057f48ddf22c..8d7260cd7da9 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> @@ -219,6 +219,7 @@ void lan966x_vlan_port_add_vlan(struct lan966x_port *=
port,
>  	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
>  		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
>  		lan966x_fdb_write_entries(lan966x, vid);
> +		lan966x_mdb_write_entries(lan966x, vid);
>  	}
> =20
>  	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
> @@ -241,6 +242,7 @@ void lan966x_vlan_port_del_vlan(struct lan966x_port *=
port, u16 vid)
>  	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
>  		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
>  		lan966x_fdb_erase_entries(lan966x, vid);
> +		lan966x_mdb_erase_entries(lan966x, vid);
>  	}
>  }
> =20
> @@ -254,8 +256,10 @@ void lan966x_vlan_cpu_add_vlan(struct lan966x *lan96=
6x, u16 vid)
>  	 * information so when a front port is added then it would add also the
>  	 * CPU port.
>  	 */
> -	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid))
> +	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
>  		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> +		lan966x_mdb_write_entries(lan966x, vid);
> +	}
> =20
>  	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
>  	lan966x_fdb_write_entries(lan966x, vid);
> @@ -267,6 +271,7 @@ void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966=
x, u16 vid)
>  	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
>  	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
>  	lan966x_fdb_erase_entries(lan966x, vid);
> +	lan966x_mdb_erase_entries(lan966x, vid);
>  }
> =20
>  void lan966x_vlan_init(struct lan966x *lan966x)
> --=20
> 2.33.0
>=
