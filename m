Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCFC47939C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhLQSMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:12:40 -0500
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:32961
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239962AbhLQSMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:12:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCpsuuXj3XyuzQjXAyP5gWHVcDLRsXKiReQJFtrVu61tu80Z/xaKzc+b4eFbRoF2+H1VXPGaaMmamY7w1c9ZmvT2m00m15tepJa+6aWlmPm6n464xeCA91vPESqcEKcaVvZT6vLgZYa3OT6eUrkS6PS/mafrNnBw+ojKJoyTdbeLgMyELDOoU7BuiBn9Vxyc+6oS4hkJFMCvzFSVq619mU3JSNZUBYg/In/y6F43Fs3tf+7s5DzGFWhyxYkRHt9PfHfEjprYXcfsIFGbeSxkP/aqQ3PNwuB9dbKMH7EPlET2SvaOWs7SIUVTcGDt3ME/LzhnZqoj0YMKJtqhwMumKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOo49HqJGFY9wt78628vVJXcY391XWjv+3ggnDT+OmE=;
 b=QilrsojQFQ9ZX+u+o9GHkDLLd3WYlvoVNKsVcrcoxGWIvHAYAGtidn1k+GSf8hbItX4pmHzPJPVIfYav5yDTtmbX/pUkoiRXhjU3yvCMh85MSU8FPQLhvcwsAT+ynNsWqRZle7vH5oeTlpWTFpJ03Eoo3biahnjiOVms6oOkYttSNA81xH3dzH7/PkLzM2wkoj5UDHMOBSZyFPIKf/rjLu47b4nxWPbefhthnbtUxmdf+zGmRq0uqp5O7Cd7y9zQHiiz/gRuoziyPnj4AybDECDfpLjq4R3OFoSLNyBlbCVfKV0uK1pEnOyA3skyo6YhullZ9jh2vdcEqsd/TReXiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOo49HqJGFY9wt78628vVJXcY391XWjv+3ggnDT+OmE=;
 b=JvWx9zCvQWxcJj2Ld1y9ALrPt1/tqPiSYnL/UwC362GTuq4H/2Gmr1YWkbMB5WEDhnTWcomXfdCy+iDvPBHnjHkITRF0vv5Bmlu/xiPC+ZOzuV3M2jE92eKaZoi6XdMNFD4RLvtKpVXQVA4KfNkcsVm8qqecBHeRd9BCQk/cTgg=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 18:12:36 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 18:12:36 +0000
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
Subject: Re: [PATCH net-next v7 9/9] net: lan966x: Extend switchdev with fdb
 support
Thread-Topic: [PATCH net-next v7 9/9] net: lan966x: Extend switchdev with fdb
 support
Thread-Index: AQHX81485q7W8Qj6DU+J0X6deflh6qw2/JiA
Date:   Fri, 17 Dec 2021 18:12:35 +0000
Message-ID: <20211217181235.wquhfoq6qyqsfkxp@skbuf>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-10-horatiu.vultur@microchip.com>
In-Reply-To: <20211217155353.460594-10-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5406aa4-c63e-4351-be51-08d9c188cdc2
x-ms-traffictypediagnostic: AM0PR04MB6465:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6465A1E23F99B7A0F0470FEBE0789@AM0PR04MB6465.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zzwOtA88UbDHZU0ZRno9zOGsSvM5ctqG+rQRvrb85fanUA+AJyy+FnCR3pp08Yh4cRtsWY4+13hzI/wYb+BSjoIyDs2lpnkGsOjrXOHCDyaUdy+yVlDIak6OWD3MRqCVXC6E+NXNdgkzTQ6YDmhgnov/s7SbMAGlC+40+FFxk1i5d87orrqFvfnR1GBts6o8iz9jsOSIwqjF8KgTvtyANkWmLRjj9cQgnu1tFRZOkYlPyIpP/Adm6EaYpPmEPxrN+pGl/iMOtX+R+mq6nwfszymLjLecguTQwF+U39cdh9QnkdPzN9X0iWzMxnqgWLPCC3V9aW7ZB8c1hBaM8MIPbkPawngSqOJ6zBFv926kutwts1rV97Pu+dIuVZivk0aP7wSqJBpyiEjMv/W5txWNLhgjxbUuQu7yXIZPHm32aahQliJDYkgTiT+/564zngQ2QnchlwVENESsAEL64EU2us7+qLYsROTK10ibBQxHzTZk8/cjqK0awO+U7CRoqf9Y/fN/NpsCSh9o4clyHiAg25fXBxEXYBe1IRAqlszG5gd7t4OkXkDlyBZszoV9gE0y0t33AM0emT4ag6VFEzDfIMkGrb3Gjgk754Y0OK03z+VYgdQmH2Nud5zxbXBgZN+Wgmn/0uvnVpAM74ZmZS+OS+ArBn29MyrUiJOnv/S0aTESXOfIqNg+eRLBGPWo7xSUYXkyKixlJZ4ImNArsOwjFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(38100700002)(6486002)(54906003)(122000001)(8936002)(6506007)(33716001)(6512007)(9686003)(83380400001)(6916009)(316002)(7416002)(38070700005)(44832011)(86362001)(76116006)(66476007)(4326008)(91956017)(66556008)(186003)(5660300002)(508600001)(71200400001)(66446008)(64756008)(66946007)(8676002)(26005)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LPt/sASIw9cyM9/Ik9pAEI4gOBrsuBgL+nMg0s3EEnd0/mkigBxEMxkCCvnV?=
 =?us-ascii?Q?2T+7sK8TYyiAUOX2UquGongZSfCwnXc3t7Ct3vwJivU/kkbAXOFSrDcuLPpU?=
 =?us-ascii?Q?pXnrpc9uwzqhtTn3BC1kGs/MNsUy6czptIH7KfxSGFNLDsvOEXZM6Czju3lU?=
 =?us-ascii?Q?1NzQ+dYdyuCa6vuV2ao74Gg11fFNU9j/viTCGciX9AHinfpoxIFbp52keWyb?=
 =?us-ascii?Q?bW/buXUaerWc5WUFkcUPGQnUY57lVU9jvTZwe/y/hPvSOFPGWVpVQ+4AL3ic?=
 =?us-ascii?Q?FTO4zWFCGlQX/HvnXf5N8BQDG5513NMhfFnUtXd8tCD55fjI+cybliYnCzjP?=
 =?us-ascii?Q?Zil1mK7QFqr+UNkqye61Vo5kWejKHfpuj16yBDiL6DqbJO+L+OMb1u08p9Hw?=
 =?us-ascii?Q?ZE2F4j5nEKZxG9AtQbxL5Sa1uzmT2AnaLUO5y0hlZQSXzR2prAuQDpynMh5L?=
 =?us-ascii?Q?kfhEYIvC1rDIykUaIxZPw/JF7dyMNBs//4DfFc3paF4LBnmaFWYmAjTiBUR5?=
 =?us-ascii?Q?JIakH18bUaM9eBHlvnpvrDzvVUbcRi4hivyFnIYoDsIlAUldRropsZHpUFkj?=
 =?us-ascii?Q?u8+A6XaTMk5OAeqk7wCCfhBb69pMzn15AtWKhiOqY1P7xwcG0SQgY15nnCBl?=
 =?us-ascii?Q?fhOY8769AUr1Ra3HStRLw8c2RsYIksu9P751FX7yhKarCXkFDT4j1cLDr9fc?=
 =?us-ascii?Q?fI/23ADfk8++1dhHlvEFxTLt+bbZYofbO1EZnadmoMB/oPrErxMq9VhwYM17?=
 =?us-ascii?Q?CR9YghnZtQYiyveeUIRCknRJcB9V7C9V7vo9hNXxgePTdIrw+Erwrr91+goX?=
 =?us-ascii?Q?RDa+IljjlWO7jOLgnDrxhCIg9ZJdYEKysWsTIHAL0ZfJ8NyvbG/8lz6ZyXJm?=
 =?us-ascii?Q?AIJXbKtwTRLI2fjxjfnE7n/msuzccSi+M/2pYByqkl0aNfV+iVivXCJnVnbu?=
 =?us-ascii?Q?Lz03fdapWd02TYc33/n399n31i+H7VUTLjvEj/bTb5ZhDRD0fUh7wBVslle7?=
 =?us-ascii?Q?P7K5Alxi+rVQ3/DTofHx6DwEjJLDJ4sBWeHbE3uG5TCFn9UTOrKHgUKZNBcH?=
 =?us-ascii?Q?D2hLGZuykzQp1Cy6Bj62bzfM2ZFpAoZySy/MiFVIN5BsDUCiuhoGKtkFgWwt?=
 =?us-ascii?Q?mjOJx2TEaFokA1s3pnOCoYjhq0eQM9JU3WLMPHSk3GBQNpo3cIUkdhVxzrWX?=
 =?us-ascii?Q?UGcm8E3Ndq+O4Y9NerdaxejKCDQxIPBLsxxpq8mDj2r5WrgNs2op8Exv7i5A?=
 =?us-ascii?Q?yybyr8EqtMqmfYKLwoNPHhuTVmK6y5bmGEKTaNVOFj130zUZXHybNJ8pSzma?=
 =?us-ascii?Q?WPFUJXblPUbkXtIBvKqDNhYpcIahlva5pGzWIP/QGB0+J8IBprB2WilTDx1N?=
 =?us-ascii?Q?xiZyDrkpBZbtd8G7MNORsHr4QhlSlsRyrnjTn1FE8HA0Bmx7JZ0SRJ2hoiYU?=
 =?us-ascii?Q?xGZR+5K+YSFLBNU3gdAfve8kdtt45l0EMUowwqobcDl663Us1WRZ4Nd4ne/q?=
 =?us-ascii?Q?J8y2C1NTvlQqiecmVF7MqebUfFzjDUCaQzB60F+BrQvbKgAHFBOzvm8mJXxv?=
 =?us-ascii?Q?0pOmfvfjqXBtwBlReWf+CL99lEamx+zPdK45JkxdF2YNWVBnL6M3VFVIbcbN?=
 =?us-ascii?Q?UjO8KQ0+ghgrBd24E92x1zQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8FAA79077FFBDD46A8A5618EE807DF89@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5406aa4-c63e-4351-be51-08d9c188cdc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 18:12:35.9771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvZ0XTsyetXqMc+LRAroEK+yDvd1qR8FlTk6/QIVC/RQFHh5DtWo/6TBpJfjMHCe81jnUpjtKnVjKX5bJmNMSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 04:53:53PM +0100, Horatiu Vultur wrote:
> Extend lan966x driver with fdb support by implementing the switchdev
> calls SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Looks pretty good. Just one question, since I can't figure this out by
looking at the code. Is the CPU port in the unknown unicast flood mask
currently?

>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_fdb.c  | 244 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |   5 +
>  .../ethernet/microchip/lan966x/lan966x_main.h |  14 +
>  .../microchip/lan966x/lan966x_switchdev.c     |  21 ++
>  .../ethernet/microchip/lan966x/lan966x_vlan.c |  15 +-
>  6 files changed, 298 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
(...)
> +static void lan966x_fdb_add_entry(struct lan966x *lan966x,
> +				  struct switchdev_notifier_fdb_info *fdb_info)
> +{
> +	struct lan966x_fdb_entry *fdb_entry;
> +
> +	fdb_entry =3D lan966x_fdb_find_entry(lan966x, fdb_info);
> +	if (fdb_entry) {
> +		fdb_entry->references++;
> +		return;
> +	}
> +
> +	fdb_entry =3D kzalloc(sizeof(*fdb_entry), GFP_KERNEL);
> +	if (!fdb_entry)
> +		return;
> +
> +	memcpy(fdb_entry->mac, fdb_info->addr, ETH_ALEN);

ether_addr_copy

> +	fdb_entry->vid =3D fdb_info->vid;
> +	fdb_entry->references =3D 1;
> +	list_add_tail(&fdb_entry->list, &lan966x->fdb_entries);
> +}=
