Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827A54840A3
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiADLRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:17:13 -0500
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:8263
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231962AbiADLRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 06:17:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUnhNN8qKxopfBplCFjUJB4yjXcdVtLirqHdZhRwRjiNhgWiXYe8RmN0Ya/PYiQIyTBerap3pIMPhjzGhXy8x1YM/L8yjK2gaWQjp01PaoaAvYi2zeVwSmDo7GXlPDa4U1dZhucBgRd0GIc4l/GWyOUrTsaL8VHu189waE07VYDh2BVwwTeqcPz/yoIm3l/IERdo621+a7RMW9zCsMDkdsM1ss3L4CXtzhcU6ZWwV051m//1iY22F1iih3YcBLzRVsn6s4Y5PLCH6shCm32ENTitcfidc3aBmwNNkadhTXdCo7qIqKrK0pYerrfoaysZ9Od4okhXGI+ts4Hy0jk9yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ac/JIjSamdPk4L9lGeJNWSdhtU3lj2wry8ibG3g/Zn4=;
 b=HKP71oCM/H1chX5H/+w3wrDDUPb7RxMCOBF75mNe1HjmimpHAkN0ha6EwdeSSSHzd/mH7u2FJsdAer58YIOyb+SJbswdjwBuXbQnJ+pqZjPa2DrNPsgApZ7IJb86Ucaqp3sbqRRTqb2FuiCIXicgHPfAoIryJ0G+8vctk4HuEeP72zMUtod8bAMlP64z315c5GD4JRoHbMOZLZBodVLEGnuqTC3QL0yon+aR6b8Od4VMwQmlx1cToUtiTjdbGyNBCCTToJUkj6QzLXGbjGZ6wm3uQVI4ichnVRfN9vF/DbqkOwqo2DqJDF1Bh1tXCvpDIs+llshPdUcQCf/98TC/EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ac/JIjSamdPk4L9lGeJNWSdhtU3lj2wry8ibG3g/Zn4=;
 b=U1tLldEug6en/+YWB5PY2gs8Sb2MCdBC6LE2LQgkT8vZLZYyGaJFEVvldJgXPFQO59Bfoi/Ld3T8uCWNle2b+CiR14+Qlqn6+IWV/6mNrJAlfXznB4SULZttbSxAVa2BeJs6gCpAVWwNt9BHv6ZAk5qXoWCtaCb9fRSSIv9DfNE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Tue, 4 Jan
 2022 11:17:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 11:17:10 +0000
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
Subject: Re: [PATCH net-next v2 1/3] net: lan966x: Add function
 lan966x_mac_ip_learn()
Thread-Topic: [PATCH net-next v2 1/3] net: lan966x: Add function
 lan966x_mac_ip_learn()
Thread-Index: AQHYAVQvYoQu8Rr2iUS6g2YiiJid86xStpIA
Date:   Tue, 4 Jan 2022 11:17:10 +0000
Message-ID: <20220104111710.twaqos2fbmjfv5yu@skbuf>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-2-horatiu.vultur@microchip.com>
In-Reply-To: <20220104101849.229195-2-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4a37be1-3ff1-4ab3-e492-08d9cf73c066
x-ms-traffictypediagnostic: VI1PR04MB4685:EE_
x-microsoft-antispam-prvs: <VI1PR04MB46851664EA785EE774577F8BE04A9@VI1PR04MB4685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q4hN04KozUlXtFuflLr9Me78ny/iKxtmzM663Fowr/rUt5JsNv7MCD4zLjrivW0sJR0Ln/Bu/HqbI1TCKhGa8C1lfuBWEURAAO2YMJzT+qVMxGN7iV19EFgHnE0mZWifMUjmrHylwRofN1MXG81WgT8DLoNznhDG9ryiDyPG0Jh+QvhGuDRbkhQGBlyXJ/3i5rfQtkVuXmK8JdAtn31IoTtm33NDgpebwdqP7mnsVbqcKmMvRoP3oROeXv7QWKfYlLWLhR3uinuuEBmw4UacYhwNjrnZZZ/fyJ7OBPlIuwyooK0QAYZthbe3sfIOw6TWjU0elbzsbE4HRgVyb8BV06/OHr8arKZglHxMTKVSq5nt66anNmMXvqkeCJmSsLz3S2IdYdPMRC+pGRP9KbnEgdnudjN4mlRwq2Ie+xyrGDn/A0lNzwSgFaPyCuS5ci7c01vaQvXk5wCxj35JA+4lKpl9ntJ3T+WEIy1Yj0IGqaSoUl8h0TBCIqZznHjCe2OiF3s4FUnE73kPjGwIXKKVMWqg2cB48YPwECZk171BKUfCwLyn8QaxyX6BO2jUp/c1/hAeL6AO+/WhhxVuTvGNeU9SClETHUcfNFzRIfBTz27ERbQG2sFp/ASS/nQruxvwObxdfAsCFrbC0C+bj0F2O5gTH0i5Z+0wjbOirlZ8BlGvxvjHZF+oYI1FS2l/NdSIJg+h1mnK+Kp5FB/SYe3tzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(76116006)(8676002)(71200400001)(26005)(66946007)(66476007)(83380400001)(38070700005)(8936002)(1076003)(122000001)(38100700002)(2906002)(4326008)(44832011)(86362001)(64756008)(66446008)(33716001)(54906003)(6486002)(66556008)(6512007)(5660300002)(6506007)(186003)(9686003)(316002)(508600001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r6liSzJPnjt4nr0NqjMIwFxYIEGoQ8w7t+S0U4Wux0prXfXNqwJnM1H2XyDP?=
 =?us-ascii?Q?AMuaKyBY/ElgT2/WGELc5bUECjCAvTy7gB5zVGZS0PyPSBzSl8Ygts8pIX9l?=
 =?us-ascii?Q?RMcfUVYtxVIJNl/Mb7AhuwcBXs0QkyCavUpem+bAIK8VVz1eCwQFnJYrtb+U?=
 =?us-ascii?Q?vvFqY+W5VFgVs/YX5+bPpq2TAklCceFSbNZGjpO1hapktPDib4Ml0WZwdowG?=
 =?us-ascii?Q?H5wK4QNiFS5UJ6+jN5rQwyu8nW5LxyzOvmOeZYE/TceeVB6IYGTqw7F0/DWs?=
 =?us-ascii?Q?gDmIMxdQrjJwD0qAFk2FUeIzDuGmo+/6Rulo7AUWXOWAkJMi0m3ydrfhHL5D?=
 =?us-ascii?Q?q5HvtCF9VI8zEeAR1lPBy3dFZI8OR4wiE/ewBz7G9q/GGK/ozWh63mIE13Sb?=
 =?us-ascii?Q?fUfXPHLEJhqk/SrzusFZfwHZvnAiVzwL/GCKDNi1S0um2anZZ+F5U5ksLiPL?=
 =?us-ascii?Q?g28PQ1wGWlHumjkW9YuBDsmb7b9fvlqQY1KQECPoAazcbR6DI+dF/OlL+oNx?=
 =?us-ascii?Q?axkkdZnvDksxNCj9K677dv2AuUXMLhWudubJy0YLYethZ9hp9H2t0h++cy9s?=
 =?us-ascii?Q?XAy5MIZC26js7xy8Kj2jFOVIqstX+CwZqgPFKqOQWFS1qzXFbbJ+GVUspYw/?=
 =?us-ascii?Q?YuiLXmpoacMD6rUJXy+lV6BtJrTwwfiGDgV3/VL4Heq6Xj/S3jEzDVZsgONQ?=
 =?us-ascii?Q?pduR8twkMsjEu0FvqPzu9SggJ/gUhM+og1M6Av8rXF9moCkI2/QUuWV+d1G8?=
 =?us-ascii?Q?z+NN6inkAT8mXthmEeB/w5lGnkLINhdinTtFDf4RL4e1kCLUUX9/Csln+bfV?=
 =?us-ascii?Q?XwZpBKE8cuyBuJL7IxiuOsuOAv+m3MFF1woQIO0yuvlshQ+CZREzhdd+JVra?=
 =?us-ascii?Q?UEQV7wloComIbBocDAk0qy8yYNJAPli9zPeWHL2tPI438cNu5hCoG1kaaSJk?=
 =?us-ascii?Q?kTGyp2QqSPkzNmgRlM8ZifxXmCEaC4ssjJE3XKUq/2v/OYOKmMODJ4NDzlA3?=
 =?us-ascii?Q?24xsLP7++XPYcNES6uHD75fDvFZU3XAbn+Ylu246xLd4pDdsQ2xSPXuwjh/H?=
 =?us-ascii?Q?THvFIevQFk9mdX593cGyaCaU+Ml2kDemiLfR0hQBN3QSDiGBV+6uvzm1yfoh?=
 =?us-ascii?Q?q2hoR1k1epIK5wTja9NH7qN9nZaur8PGAHqaR2awsiD/yQ8y7n7Q/I0j3VUm?=
 =?us-ascii?Q?9Yw0soZEgoNJr4mpfVNWY6KUB/suidcpkNqJxk5wO/4rqQ+cWeyGohkaIPSi?=
 =?us-ascii?Q?MK0Flxjdr25hpBq+PDrDygSeFgCbaOsIlEMuKY9MIOMdPaqv5hT8Ir/9JZI6?=
 =?us-ascii?Q?wPJqXNco/Gdr+sY0zPVllRfcUTT9taLL/AqIgLX7jjldenRen8PrCmHjFKPc?=
 =?us-ascii?Q?DiPyLtCE7tNAsmxFvYMqdowzN1LuHd1ZVc9HQZZZBaVuFae0+AVGGN06OrW5?=
 =?us-ascii?Q?x/YB02G198DS6wDeRIxxuDXITa9XvPQV1LW5QtrKSvpeKbJYkLlOnt4rFRqz?=
 =?us-ascii?Q?VK9zeF2OB3c2TiTYlhWlYCjnfBsQx61f5KN9uxOqsa8ieeu7Oryv/PUMBs9d?=
 =?us-ascii?Q?cEAbG/UA5pfjGnFLN8BZEKIw0NOBBnTTZNXxlrzznC9vifYK7/DbMKK0ND5j?=
 =?us-ascii?Q?R0V8FJ5HWOKk+DU4L06e79U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3E2DBEE51D42248934080CE8EB37EBE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a37be1-3ff1-4ab3-e492-08d9cf73c066
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 11:17:10.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeAFjyui7Nua0LBiuE6THBJvoN0soGq1N+z5G2zq6fIJIYTsMH9S6TO6xCeXv/v8dtCw+EVEDpd5qhhRxNzTFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 11:18:47AM +0100, Horatiu Vultur wrote:
> Extend mac functionality with the function lan966x_mac_ip_learn. This
> function adds an entry in the MAC table for IP multicast addresses.
> These entries can copy a frame to the CPU but also can forward on the
> front ports.
> This functionality is needed for mdb support. In case the CPU and some
> of the front ports subscribe to an IP multicast address.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_mac.c  | 33 ++++++++++++++++---
>  .../ethernet/microchip/lan966x/lan966x_main.h |  5 +++
>  .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++++
>  3 files changed, 39 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drive=
rs/net/ethernet/microchip/lan966x/lan966x_mac.c
> index efadb8d326cc..82eb6606e17f 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> @@ -68,17 +68,19 @@ static void lan966x_mac_select(struct lan966x *lan966=
x,
>  	lan_wr(mach, lan966x, ANA_MACHDATA);
>  }
> =20
> -int lan966x_mac_learn(struct lan966x *lan966x, int port,
> -		      const unsigned char mac[ETH_ALEN],
> -		      unsigned int vid,
> -		      enum macaccess_entry_type type)
> +static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
> +			       bool cpu_copy,
> +			       const unsigned char mac[ETH_ALEN],
> +			       unsigned int vid,
> +			       enum macaccess_entry_type type)
>  {
>  	lan966x_mac_select(lan966x, mac, vid);
> =20
>  	/* Issue a write command */
>  	lan_wr(ANA_MACACCESS_VALID_SET(1) |
>  	       ANA_MACACCESS_CHANGE2SW_SET(0) |
> -	       ANA_MACACCESS_DEST_IDX_SET(port) |
> +	       ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
> +	       ANA_MACACCESS_DEST_IDX_SET(pgid) |
>  	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
>  	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
>  	       lan966x, ANA_MACACCESS);
> @@ -86,6 +88,27 @@ int lan966x_mac_learn(struct lan966x *lan966x, int por=
t,
>  	return lan966x_mac_wait_for_completion(lan966x);
>  }
> =20
> +int lan966x_mac_ip_learn(struct lan966x *lan966x,
> +			 bool cpu_copy,
> +			 const unsigned char mac[ETH_ALEN],
> +			 unsigned int vid,
> +			 enum macaccess_entry_type type)

I think it's worth mentioning in a comment above this function that the
mask of front ports should be encoded into the address by now, via a
call to lan966x_mdb_encode_mac().

> +{
> +	WARN_ON(type !=3D ENTRYTYPE_MACV4 && type !=3D ENTRYTYPE_MACV6);
> +
> +	return __lan966x_mac_learn(lan966x, 0, cpu_copy, mac, vid, type);
> +}
> +
> +int lan966x_mac_learn(struct lan966x *lan966x, int port,
> +		      const unsigned char mac[ETH_ALEN],
> +		      unsigned int vid,
> +		      enum macaccess_entry_type type)
> +{
> +	WARN_ON(type !=3D ENTRYTYPE_NORMAL && type !=3D ENTRYTYPE_LOCKED);
> +
> +	return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
> +}
> +
>  int lan966x_mac_forget(struct lan966x *lan966x,
>  		       const unsigned char mac[ETH_ALEN],
>  		       unsigned int vid,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index c399b1256edc..f70e54526f53 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
>  			 struct lan966x_port_config *config);
>  void lan966x_port_init(struct lan966x_port *port);
> =20
> +int lan966x_mac_ip_learn(struct lan966x *lan966x,
> +			 bool cpu_copy,
> +			 const unsigned char mac[ETH_ALEN],
> +			 unsigned int vid,
> +			 enum macaccess_entry_type type);
>  int lan966x_mac_learn(struct lan966x *lan966x, int port,
>  		      const unsigned char mac[ETH_ALEN],
>  		      unsigned int vid,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_regs.h
> index a13c469e139a..797560172aca 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> @@ -169,6 +169,12 @@ enum lan966x_target {
>  #define ANA_MACACCESS_CHANGE2SW_GET(x)\
>  	FIELD_GET(ANA_MACACCESS_CHANGE2SW, x)
> =20
> +#define ANA_MACACCESS_MAC_CPU_COPY               BIT(16)
> +#define ANA_MACACCESS_MAC_CPU_COPY_SET(x)\
> +	FIELD_PREP(ANA_MACACCESS_MAC_CPU_COPY, x)
> +#define ANA_MACACCESS_MAC_CPU_COPY_GET(x)\
> +	FIELD_GET(ANA_MACACCESS_MAC_CPU_COPY, x)

Could you please add a space between (x) and \.

> +
>  #define ANA_MACACCESS_VALID                      BIT(12)
>  #define ANA_MACACCESS_VALID_SET(x)\
>  	FIELD_PREP(ANA_MACACCESS_VALID, x)
> --=20
> 2.33.0
>=
