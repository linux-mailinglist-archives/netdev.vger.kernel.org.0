Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1A46E7C0
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhLILvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:51:24 -0500
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:61889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232177AbhLILvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 06:51:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFyCk/j+eO8QnA3ytc1jgjSY4PwWNH1gGyUXEZp9s8hmy9OSZeehkEFTJUAF6rwG4WzLmRgffHV4IQ+Dq3aMzk0ltP7tyiwH0hyhxMmO0rKuuRSveJG8wFCtWUDpMXReQ+1fYTEWOGCPpZ+mU4vrWgkOtPGZckLBH7nwy9Veq8g7HL521LL5IYT9VHivDoGZmQ43kJirxPFOtf7fmEDYA2/5D/Kc4SteNmj6S5xIezapqn8y/h6jOEyWG+t6n4tPuhNq3xU3oKd4N0AxXdTofuq0d6eJ99Loc+u7L/Ja9nt+GO+MUEN2PyiR0abQPsUGHX2PjgJ7Qc0bVcrk9FxITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5I5C6sOSAlnV5Vsz8LdCDzapTthkbdEdH/PxauKU1WY=;
 b=j1fdKuD6+mjMzwnxeXXDyE5wR+nG6bQZnhes6aqSX+y9oLUo7ya4v7yE01WZVQaNBpOCGnPDLxkC6U8bQHcfvWOArl+WmtEHDMLzpdSOLq99+15khC7ZbDNSR856+foOwsMTwY+XCtXk1Tcw9JMLpRy8CzESUySxaklC6FA9ldZOoouglRp6+6LZ7Qhw+znmWky9JsCIg9eZ3DhsDMzD1BCKriJlDlPlx0RLi0CthJZ1WVYCu5o9iOcViCTR0TMFQ9rL9X28W/6T+5+ER9deUwza7Jr+ixaPujarC0FC+9KrUDnDHT3MzpkFDwqzUAtFx0dSDgkvF8uHL7n+O7kGWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5I5C6sOSAlnV5Vsz8LdCDzapTthkbdEdH/PxauKU1WY=;
 b=gAGqNEiQTSQSxV6StvyDwn5qPcZbL4USfT5IrPRRA2qZ8Kj6XeYtXJtosS8nhtyU83q+IIuBAHp22m7858sNS2S4k/Ck0Xf5G/mHGvYKvgYyL85dRdYZqc0UmTqUaEbtsc8nn+aMFU5l5eVZ6a0yDPVDnHP6zhy4ivTrwGlbUKQ=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6468.eurprd04.prod.outlook.com (2603:10a6:208:174::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 9 Dec
 2021 11:47:47 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 11:47:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add support for interrupts
 from analyzer
Thread-Topic: [PATCH net-next v3 3/6] net: lan966x: add support for interrupts
 from analyzer
Thread-Index: AQHX7OGjn7mceSvFAUGNIex6lyKrZqwqC2iA
Date:   Thu, 9 Dec 2021 11:47:47 +0000
Message-ID: <20211209114747.pg73qojm2gexlo33@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-4-horatiu.vultur@microchip.com>
In-Reply-To: <20211209094615.329379-4-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccdc2450-7c56-4129-bf99-08d9bb09b8cb
x-ms-traffictypediagnostic: AM0PR04MB6468:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6468B2E25001F8AB36D72805E0709@AM0PR04MB6468.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RdjZocfrKplfFpi+shABcm7/GOuWI+nhwpQJqpkkXeVU9yZnU1lLWwb0PJUmrcn66hxminhOI0Y6Kgw8C2K2EkTzIN4puPzPW+3xkhMfbYF0IJLZaTdHXrBtXVR6DVZcjLVzqdLbCgwBLAUXXH/MpnYVqfYfnP+f5msnRWwjTFNvJpgu9QFBgpJiDmsgNELfB3hZYk3+iCXOZssKN5iShWTXs1V9U8FIuCSaRiwkuqgWBzt6T31e1Lun+/gCcJ3lio9oOwDpAX/ZOXg+xYhNXd7pfqLILEcm5SRgncJuH+pb/n4P/Ieuigb1hzHeq2p1Fbu4leYJ/DqkS+baHs7NhjoXWMg/6fFJyOhtQA1OpGRNcXPW4uwAZvYbp6CroZETgpbx1BnuZjTAyFTpFUkk8Im81lsW7dzmOsoyKx+lh+a6/3EI7gLF1CqKRXmOZ7Zd/UNf2nUxz9XyXGW9eQ80SqP8uvG0TBGp9orhG3BezyKqSMoEOwWyJMeXImm/BmsfB9pVdwf1eeltbWIyz7qWM8+cNhxA19o5LkEoQEMzuhEihM+Ue/Yj05CgeMJoqtgDvWNLxi4FQKgN3JSsL+KNCkFGfM6F3amkbVnOGWBTm+gZQLyJ/dq+Jh8xPgq/rElj9lk//u+DOBtTVi02bV+3V4wPeusvwWi/SO3BsZ4CCsy/d2DGofR/+0tMstXETvjPhwA+HHLjh3m1rX8T+L2oHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(33716001)(71200400001)(2906002)(122000001)(5660300002)(91956017)(76116006)(66946007)(186003)(8936002)(316002)(66476007)(6916009)(54906003)(66556008)(64756008)(26005)(66446008)(6486002)(38070700005)(86362001)(7416002)(83380400001)(38100700002)(1076003)(9686003)(6512007)(508600001)(8676002)(30864003)(4326008)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JuBPccbMT00+KcCh1VWuw80NDbpVIaTE7sfRklH2FsRpCA2XewD8FsLnkXcx?=
 =?us-ascii?Q?YpwQYpP7u1wX5eGndqR47cz8m0KKD7xUebiUt6UJ87D7z16tjSwXa9tzb/Wg?=
 =?us-ascii?Q?NG3lyCEMxuoFwXk9IC+p9YP4YURoX8K1AUypAnS49po7Zh+GZsTBfx8aEnYi?=
 =?us-ascii?Q?imyW6QutDEOGJkb3nAMMj1lg0w22maF4pGadv/dA/DVz3pJeqhpI0Vc2f8mn?=
 =?us-ascii?Q?yK3xjWkhP0RyBTWGYYce2JTTqAFQ3j6P0FBRSwVAXPkGlonr/6sLdvq97ugC?=
 =?us-ascii?Q?lW4ABydJ4D3nKnDgwS/y+O7ZND5u8FtEnV0tUVRlyJcJWyScspMoPq+u6ERx?=
 =?us-ascii?Q?OKoJj0P5QPmJ8WerprQylEQShnKWAnGxVYYNNTSUsOlymCj5F8sVuKRUC9t6?=
 =?us-ascii?Q?IzJqaSP2xwv/6MHCEwDy1shcpNCNNTlxNHjCuweExppYUgQsNRaikeA6cx+O?=
 =?us-ascii?Q?XRrcwFvCn/VegEabgsng9t2bZWMQGyE1aq1rT6luoespC3g57y87uNB0F3Tc?=
 =?us-ascii?Q?kyABZhvVRzGZAnERjJKdebLwdQcICwJj1bec8u8/aGlCZeEzw67jpW7VTnDq?=
 =?us-ascii?Q?XpvfeTctYRMklbGZAyIuxbZ15IMc24D1drfYJnPZZ3ZUDKI3X6xh7rUWV0U2?=
 =?us-ascii?Q?oD4TTN+1rwQzUalxsKo9mp0YvHxUzkD3SmeMa2FBaUTDr5I8QcqlS2Hn2vEQ?=
 =?us-ascii?Q?l5ERph4jOUu0BU/w7RHB4xjWwab5OLzwIlyFfekZLQi8xAeTMiMUL3a8A6JR?=
 =?us-ascii?Q?t0xlFZefvUygIXSrOegpVUi1cKwwTzDpewYqKV/p9C6xMQz3UDy6cuX8K0gU?=
 =?us-ascii?Q?e1dap+SXdQOJZma2BGpD5EqCWS6xE7S+xeOYA45VoqjIQxTZ7dZZKF3vKlio?=
 =?us-ascii?Q?4U6GTziL6AzQSW4infmBk0lR1BQZt3FKleLZc83hMcDlbEZyQpAFikDERfLE?=
 =?us-ascii?Q?zQsWZub6hntPYqMjW8MJyeFfYvBpe1HOk7knP9SNh9pzhvj6SJIp7LKrf4r0?=
 =?us-ascii?Q?WkpGkAT2ZxAqUsOlnkn/Dx04YXoTfivsRSDngtbAUoOUd2+y1VxgR9ugnuzA?=
 =?us-ascii?Q?uZ2ISRkyVXb0uBO0Z1dIe3Jf7nin4RwewdW1rWfG4RxlQXE/sVc6VCgEV516?=
 =?us-ascii?Q?/y5aXtHDjbY0HF5fmpyT7aGVUgSe0RL/gInHpfAVEwW39zf3QURaFh9Go2qN?=
 =?us-ascii?Q?LIP7BzPcl/3oipaBn5F3qSrA/Of/8/xGhZ5UpL20lIhg9nZS38fzCdD0SHgD?=
 =?us-ascii?Q?AnQ5bci6gaTwYzACdP/iVEN6iZLwhiYslc//rU22ML3FinqcElHeJDVjAq0f?=
 =?us-ascii?Q?L7zYzFAKes96onpU4sX1DMoeQvsjMoyKT69fEX0t+3dFPU+UGUMtuyQs6WlM?=
 =?us-ascii?Q?vDhgSguubBDB84LxThZlgHcWc8+SmV6jMRehzCWIMl5/H0afLJewY9wcGDf1?=
 =?us-ascii?Q?Hz8VZPfkBV8Rr8p18Xx+bxEXzQ2Ku1y7GGFUBQSljx6QRq4Dg1NUn5bYGKHl?=
 =?us-ascii?Q?S2sWTjJlPzD0Zf8Y6EONbKtxGWdGFf0Xosbp8kgeNjRajWd+5td8m1LenEDn?=
 =?us-ascii?Q?WnkQSe3FhJLCcFxhdOxGyaFeYLojYgjUKmcJntvGLAoIuPiU6MsuoBitJRgh?=
 =?us-ascii?Q?SsAfc2iRpMVWn8qYWkhT7w4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B15B1A2F44027409484A5A4F034DD15@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccdc2450-7c56-4129-bf99-08d9bb09b8cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 11:47:47.8496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4bN9uenIb+QOmgCFw7Ovnjth8Y1PZhcpSSxOjs0F1Vura6YGtZKo2BDR4qzpH0b7FaEx4RUx766gc9ia3vuIHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 10:46:12AM +0100, Horatiu Vultur wrote:
> This patch adds support for handling the interrupts generated by the
> analyzer. Currently, only the MAC table generates these interrupts.
> The MAC table will generate an interrupt whenever it learns or forgets
> an entry in the table. It is the SW responsibility figure out which
> entries were added/removed.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_mac.c  | 244 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |  23 ++
>  .../ethernet/microchip/lan966x/lan966x_main.h |   6 +
>  3 files changed, 273 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drive=
rs/net/ethernet/microchip/lan966x/lan966x_mac.c
> index f6878b9f57ef..c01ab01bffbf 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0+
> =20
> +#include <net/switchdev.h>
>  #include "lan966x_main.h"
> =20
>  #define LAN966X_MAC_COLUMNS		4
> @@ -13,6 +14,23 @@
>  #define MACACCESS_CMD_WRITE		7
>  #define MACACCESS_CMD_SYNC_GET_NEXT	8
> =20
> +#define LAN966X_MAC_INVALID_ROW		-1
> +
> +struct lan966x_mac_entry {
> +	struct list_head list;
> +	unsigned char mac[ETH_ALEN] __aligned(2);
> +	u16 vid;
> +	u16 port_index;
> +	int row;
> +};
> +
> +struct lan966x_mac_raw_entry {
> +	u32 mach;
> +	u32 macl;
> +	u32 maca;
> +	bool process;
> +};
> +
>  static int lan966x_mac_get_status(struct lan966x *lan966x)
>  {
>  	return lan_rd(lan966x, ANA_MACACCESS);
> @@ -98,4 +116,230 @@ void lan966x_mac_init(struct lan966x *lan966x)
>  	/* Clear the MAC table */
>  	lan_wr(MACACCESS_CMD_INIT, lan966x, ANA_MACACCESS);
>  	lan966x_mac_wait_for_completion(lan966x);
> +
> +	spin_lock_init(&lan966x->mac_lock);
> +	INIT_LIST_HEAD(&lan966x->mac_entries);
> +}
> +
> +static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned =
char *mac,
> +							 u16 vid, u16 port_index)
> +{
> +	struct lan966x_mac_entry *mac_entry;
> +
> +	mac_entry =3D kzalloc(sizeof(*mac_entry), GFP_KERNEL);
> +	if (!mac_entry)
> +		return NULL;
> +
> +	memcpy(mac_entry->mac, mac, ETH_ALEN);
> +	mac_entry->vid =3D vid;
> +	mac_entry->port_index =3D port_index;
> +	mac_entry->row =3D LAN966X_MAC_INVALID_ROW;
> +	return mac_entry;
> +}
> +
> +static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type=
,
> +				       const char *mac, u16 vid,
> +				       struct net_device *dev)
> +{
> +	struct switchdev_notifier_fdb_info info =3D { 0 };
> +
> +	info.addr =3D mac;
> +	info.vid =3D vid;
> +	info.offloaded =3D true;
> +	call_switchdev_notifiers(type, dev, &info.info, NULL);
> +}
> +
> +void lan966x_mac_purge_entries(struct lan966x *lan966x)
> +{
> +	struct lan966x_mac_entry *mac_entry, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&lan966x->mac_lock, flags);

I hope I'm not wrong, but you are only using this spinlock to serialize
access to the list, which isn't accessed from hardirq context anywhere
(the irq is threaded). So spin_lock_irqsave could simply be spin_lock.
Unless...

> +	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
> +				 list) {
> +		lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
> +				   ENTRYTYPE_LOCKED);

Does this generate a MAC table interrupt?

> +
> +		list_del(&mac_entry->list);
> +		kfree(mac_entry);
> +	}
> +	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
> +}
> +
> +static void lan966x_mac_notifiers(struct lan966x *lan966x,
> +				  enum switchdev_notifier_type type,
> +				  unsigned char *mac, u32 vid,
> +				  struct net_device *dev)
> +{
> +	rtnl_lock();
> +	lan966x_fdb_call_notifiers(type, mac, vid, dev);
> +	rtnl_unlock();
> +}
> +
> +static void lan966x_mac_process_raw_entry(struct lan966x_mac_raw_entry *=
raw_entry,
> +					  u8 *mac, u16 *vid, u32 *dest_idx)
> +{
> +	mac[0] =3D (raw_entry->mach >> 8)  & 0xff;
> +	mac[1] =3D (raw_entry->mach >> 0)  & 0xff;
> +	mac[2] =3D (raw_entry->macl >> 24) & 0xff;
> +	mac[3] =3D (raw_entry->macl >> 16) & 0xff;
> +	mac[4] =3D (raw_entry->macl >> 8)  & 0xff;
> +	mac[5] =3D (raw_entry->macl >> 0)  & 0xff;
> +
> +	*vid =3D (raw_entry->mach >> 16) & 0xfff;
> +	*dest_idx =3D ANA_MACACCESS_DEST_IDX_GET(raw_entry->maca);
> +}
> +
> +static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
> +				    struct lan966x_mac_raw_entry *raw_entries)
> +{
> +	struct lan966x_mac_entry *mac_entry, *tmp;
> +	char mac[ETH_ALEN] __aligned(2);

unsigned char

> +	unsigned long flags;
> +	u32 dest_idx;
> +	u32 column;
> +	u16 vid;
> +
> +	spin_lock_irqsave(&lan966x->mac_lock, flags);
> +	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries, list) {
> +		bool found =3D false;
> +
> +		if (mac_entry->row !=3D row)
> +			continue;

When the MAC table gets large, you could consider keeping separate lists
per row. This way you can avoid traversing a list of elements you're
sure you don't care about.

> +
> +		for (column =3D 0; column < LAN966X_MAC_COLUMNS; ++column) {
> +			/* All the valid entries are at the start of the row,
> +			 * so when get one invalid entry it can just skip the
> +			 * rest of the columns
> +			 */
> +			if (!ANA_MACACCESS_VALID_GET(raw_entries[column].maca))
> +				break;
> +
> +			lan966x_mac_process_raw_entry(&raw_entries[column],
> +						      mac, &vid, &dest_idx);
> +			WARN_ON(dest_idx > lan966x->num_phys_ports);
> +
> +			/* If the entry in SW is found, then there is nothing
> +			 * to do
> +			 */
> +			if (mac_entry->vid =3D=3D vid &&
> +			    ether_addr_equal(mac_entry->mac, mac) &&
> +			    mac_entry->port_index =3D=3D dest_idx) {
> +				raw_entries[column].process =3D true;
> +				found =3D true;
> +				break;
> +			}
> +		}
> +
> +		if (!found) {
> +			/* Notify the bridge that the entry doesn't exist
> +			 * anymore in the HW and remmove the entry from the SW

s/remmove/remove/

> +			 * list
> +			 */
> +			lan966x_mac_notifiers(lan966x, SWITCHDEV_FDB_DEL_TO_BRIDGE,
> +					      mac_entry->mac, mac_entry->vid,
> +					      lan966x->ports[mac_entry->port_index]->dev);
> +
> +			list_del(&mac_entry->list);
> +			kfree(mac_entry);
> +		}
> +	}
> +	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
> +
> +	/* Now go to the list of columns and see if any entry was not in the SW
> +	 * list, then that means that the entry is new so it needs to notify th=
e
> +	 * bridge.
> +	 */
> +	for (column =3D 0; column < LAN966X_MAC_COLUMNS; ++column) {
> +		/* All the valid entries are at the start of the row, so when
> +		 * get one invalid entry it can just skip the rest of the columns
> +		 */
> +		if (!ANA_MACACCESS_VALID_GET(raw_entries[column].maca))
> +			break;
> +
> +		/* If the entry already exists then don't do anything */
> +		if (raw_entries[column].process)

s/process/processed/

> +			continue;
> +
> +		lan966x_mac_process_raw_entry(&raw_entries[column],
> +					      mac, &vid, &dest_idx);
> +		WARN_ON(dest_idx > lan966x->num_phys_ports);
> +
> +		mac_entry =3D lan966x_mac_alloc_entry(mac, vid, dest_idx);
> +		if (!mac_entry)
> +			return;
> +
> +		mac_entry->row =3D row;
> +
> +		spin_lock_irqsave(&lan966x->mac_lock, flags);
> +		list_add_tail(&mac_entry->list, &lan966x->mac_entries);
> +		spin_unlock_irqrestore(&lan966x->mac_lock, flags);

spin_lock_irqsave shouldn't be necessary from an irq handler.

> +
> +		lan966x_mac_notifiers(lan966x, SWITCHDEV_FDB_ADD_TO_BRIDGE,
> +				      mac, vid, lan966x->ports[dest_idx]->dev);
> +	}
> +}
> +
> +irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x)
> +{
> +	struct lan966x_mac_raw_entry entry[LAN966X_MAC_COLUMNS] =3D { 0 };
> +	u32 index, column;
> +	bool stop =3D true;
> +	u32 val;
> +
> +	/* Check if the mac table triggered this, if not just bail out */
> +	if (!(ANA_ANAINTR_INTR_GET(lan_rd(lan966x, ANA_ANAINTR))))
> +		return IRQ_NONE;

The interrupt isn't shared, so if we enter this condition, it means the
analyzer block generated it, just not the MAC table portion of it.
If we return IRQ_NONE there will be an IRQ storm because that condition
will never go away. Could we ack the interrupt and return IRQ_HANDLED?

> +
> +	/* Start the scan from 0, 0 */
> +	lan_wr(ANA_MACTINDX_M_INDEX_SET(0) |
> +	       ANA_MACTINDX_BUCKET_SET(0),
> +	       lan966x, ANA_MACTINDX);
> +
> +	while (1) {
> +		lan_rmw(ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_SYNC_GET_NEXT),
> +			ANA_MACACCESS_MAC_TABLE_CMD,
> +			lan966x, ANA_MACACCESS);
> +		lan966x_mac_wait_for_completion(lan966x);
> +
> +		val =3D lan_rd(lan966x, ANA_MACTINDX);
> +		index =3D ANA_MACTINDX_M_INDEX_GET(val);
> +		column =3D ANA_MACTINDX_BUCKET_GET(val);
> +
> +		/* The SYNC-GET-NEXT returns all the entries(4) in a row in
> +		 * which is suffered a change. By change it means that new entry
> +		 * was added or an entry was removed because of ageing.
> +		 * It would return all the columns for that row. And after that
> +		 * it would return the next row The stop conditions of the
> +		 * SYNC-GET-NEXT is when it reaches 'directly' to row 0
> +		 * column 3. So if SYNC-GET-NEXT returns row 0 and column 0
> +		 * then it is required to continue to read more even if it
> +		 * reaches row 0 and column 3.
> +		 */
> +		if (index =3D=3D 0 && column =3D=3D 0)
> +			stop =3D false;
> +
> +		if (column =3D=3D LAN966X_MAC_COLUMNS - 1 &&
> +		    index =3D=3D 0 && stop)
> +			break;
> +
> +		entry[column].mach =3D lan_rd(lan966x, ANA_MACHDATA);
> +		entry[column].macl =3D lan_rd(lan966x, ANA_MACLDATA);
> +		entry[column].maca =3D lan_rd(lan966x, ANA_MACACCESS);
> +
> +		/* Once all the columns are read process them */
> +		if (column =3D=3D LAN966X_MAC_COLUMNS - 1) {
> +			lan966x_mac_irq_process(lan966x, index, entry);
> +			/* A row was processed so it is safe to assume that the
> +			 * next row/column can be the stop condition
> +			 */
> +			stop =3D true;
> +		}
> +	}
> +
> +	lan_rmw(ANA_ANAINTR_INTR_SET(0),
> +		ANA_ANAINTR_INTR,
> +		lan966x, ANA_ANAINTR);
> +
> +	return IRQ_HANDLED;
>  }
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 101c1f005baf..7c6d6293611a 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -527,6 +527,13 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, =
void *args)
>  	return IRQ_HANDLED;
>  }
> =20
> +static irqreturn_t lan966x_ana_irq_handler(int irq, void *args)
> +{
> +	struct lan966x *lan966x =3D args;
> +
> +	return lan966x_mac_irq_handler(lan966x);
> +}
> +
>  static void lan966x_cleanup_ports(struct lan966x *lan966x)
>  {
>  	struct lan966x_port *port;
> @@ -554,6 +561,11 @@ static void lan966x_cleanup_ports(struct lan966x *la=
n966x)
> =20
>  	disable_irq(lan966x->xtr_irq);
>  	lan966x->xtr_irq =3D -ENXIO;
> +
> +	if (lan966x->ana_irq) {
> +		disable_irq(lan966x->ana_irq);
> +		lan966x->ana_irq =3D -ENXIO;
> +	}
>  }
> =20
>  static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> @@ -870,6 +882,15 @@ static int lan966x_probe(struct platform_device *pde=
v)
>  		return -ENODEV;
>  	}
> =20
> +	lan966x->ana_irq =3D platform_get_irq_byname(pdev, "ana");
> +	if (lan966x->ana_irq) {
> +		err =3D devm_request_threaded_irq(&pdev->dev, lan966x->ana_irq, NULL,
> +						lan966x_ana_irq_handler, IRQF_ONESHOT,
> +						"ana irq", lan966x);
> +		if (err)
> +			return dev_err_probe(&pdev->dev, err, "Unable to use ana irq");
> +	}
> +
>  	/* init switch */
>  	lan966x_init(lan966x);
>  	lan966x_stats_init(lan966x);
> @@ -923,6 +944,8 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  	destroy_workqueue(lan966x->stats_queue);
>  	mutex_destroy(&lan966x->stats_lock);
> =20
> +	lan966x_mac_purge_entries(lan966x);
> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 7e5a3b6f168d..ba548d65b58a 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -75,6 +75,9 @@ struct lan966x {
> =20
>  	u8 base_mac[ETH_ALEN];
> =20
> +	struct list_head mac_entries;
> +	spinlock_t mac_lock; /* lock for mac_entries list */
> +
>  	/* stats */
>  	const struct lan966x_stat_layout *stats_layout;
>  	u32 num_stats;
> @@ -87,6 +90,7 @@ struct lan966x {
> =20
>  	/* interrupts */
>  	int xtr_irq;
> +	int ana_irq;
>  };
> =20
>  struct lan966x_port_config {
> @@ -141,6 +145,8 @@ int lan966x_mac_forget(struct lan966x *lan966x,
>  int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16=
 vid);
>  int lan966x_mac_cpu_forget(struct lan966x *lan966x, const char *addr, u1=
6 vid);
>  void lan966x_mac_init(struct lan966x *lan966x);
> +void lan966x_mac_purge_entries(struct lan966x *lan966x);
> +irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
> =20
>  static inline void __iomem *lan_addr(void __iomem *base[],
>  				     int id, int tinst, int tcnt,
> --=20
> 2.33.0
>=
