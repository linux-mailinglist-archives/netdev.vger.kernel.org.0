Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7E483299
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiACO3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 09:29:05 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:15110
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234114AbiACO2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 09:28:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3+SQmIwoPGwxsgQZLvJmG0m+/5Mn4t3GwnJnnQV/khIe7A5egAtUyY7Ai3VaE90LoT2CMe+aDhCgRWeDPFr4cpwCmjsI+1huTDGng3slMev2Tno34+T8lVEi51g2qPZp2R1uOLArRZ5gbB2XDYcwjershebYMnMNTpGcZ2/Ll0HZnLF2TY1mALKPaQ/uZyjRYdHITLy3w12wG1jPw+qpT/am9cTR0Z8V7hPMByTDBtHfkYB8mthaP33RDRXk/1VNsL6LLiEPXlOWQ3cbWhq5yrJ69k9EBsoJSwUkbvGV2yzbx/Vg0wtHgLOZkFcLnWOeEgPs+aDIgGRqH8bkX2tpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXbOpoPmaSnkB1foHO3JgYK0MvNOW8jTbkJZqQWHeNQ=;
 b=mgggIrmjVrocSvKHo4PVXS8OQRjblYWrX7zAJpr2D8ulHuXsQVXRqWDaBw/xja4KCbrFtmSc9EMnfCuPpFHIjlo//auDdGi4JukScLio2Ix4ruweUHHpgYwORubG67gtHLu509tCq0p8eXBBdxM2dF2OOgtY/c4juGtdj9x8pK9h37s/y5bOoWMj/Lp2+csp2lfDNBEJsi5t7GZClh8N15X0w+1KE2EoxYYWOUe+meanp6EmUJPRIq1iAZzedMoTjIwY9uLBvRQ9GHq2jVInOhdbXRb48lMZxFBbcdkrfZFQK0j3y07IlyqzhcRY2YBvjG4YwqMDrVRXYAkHQEPkbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXbOpoPmaSnkB1foHO3JgYK0MvNOW8jTbkJZqQWHeNQ=;
 b=Xko6+8O/fitVVLBP991be4yRzqEkxhwlMoMkUn0h5QDpZCz8kYp5dq7UGmnS7Jc+REV1mFmxcTf31Kb2dpu5B+R/ZPZWuBzCiHdcPHj9B419/eAnsKhMR3qUe6Uhlk8Ps9alcPLS8+R6l66JjDo5JfyTRGckHsmGgGt0ls+UIKg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5296.eurprd04.prod.outlook.com (2603:10a6:803:55::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Mon, 3 Jan
 2022 14:27:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 14:27:55 +0000
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
Subject: Re: [PATCH net-next 1/3] net: lan966x: Add function
 lan966x_mac_cpu_copy()
Thread-Topic: [PATCH net-next 1/3] net: lan966x: Add function
 lan966x_mac_cpu_copy()
Thread-Index: AQHYAKMIDc/8QMjaPk+JwRMQCQIKvKxRWuoA
Date:   Mon, 3 Jan 2022 14:27:55 +0000
Message-ID: <20220103142754.vtotw3clkwdrvcrd@skbuf>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
 <20220103131039.3473876-2-horatiu.vultur@microchip.com>
In-Reply-To: <20220103131039.3473876-2-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a5d679f-5d42-4ca7-046e-08d9cec53b7d
x-ms-traffictypediagnostic: VI1PR04MB5296:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5296AA244E96811DBB5B1DE9E0499@VI1PR04MB5296.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymW1Vxs0acnVRdY1iz8iFnmjmZ+2RVCeelN1YSaAfZbcDhsjt6JB8r8LXm5ma2iHI4+AkZfCgI6+sRhTvK3P3QQWyQfGrUqF3r4JCGXQKfDMkkuhZjwqfim21MbWehVN6I23fx1LfcWLmgebUSd/0P/k6pWEMtA+nnt9WuvvbZP0B9ptTwmGTAz4E+K/l0viTSvzqABAl4QzNPdoyiBP/jM1Yyxo5aczN/AEE8y6lYsWtMJqhXD+Ek0VsOBu8lM3P5IsRKXNHaBRUigvcoNUCD04L0IMm9xkRuXmrc8YnMJCdbxWO+zJiLMJp5cXJofavoInbLdU3joH+CBoSOQrviUkTYT/4t5PjOnnO0yEC3AEa94GLJBqhW2PDdiwc2aHcWdQnwh/XgYOzcFWTUcar0Q66U113kioZOAZkJyuYUjPAy+0dZY5Bfw4xvU+psRww40fhuBTx5a+gac3pB8A5hV9RfQOC60WGQRjiq80/DREWMDZsht/okLs3Oi0UMlnpMWYVCQa5gKNTm4csrAAxgwA5gcWLhDVARJOoxM93bSwrWSt8JHHF4OxFN4+KAY/DZHlt5dC0bz2dlHUbUdRaZMS8KPx0DMZz0plpGjV04krxNWC4BGQFG02g5qBFb8sA9Lp2ys0Wwl5vFQaEZu3H+Jg4W8G1Eo8ViDQfCa7lJAkWXR6VnOF/zvxxEYo4AmvkC5ABu/JnPFvTvqHrtIIuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(5660300002)(6486002)(26005)(2906002)(122000001)(508600001)(83380400001)(6506007)(6512007)(186003)(38070700005)(1076003)(86362001)(66556008)(38100700002)(71200400001)(54906003)(4326008)(8676002)(66446008)(66946007)(66476007)(76116006)(44832011)(6916009)(8936002)(316002)(64756008)(91956017)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OvhibMyXh+6US3yqSJFrvgprzws72+M6S8o4Lp1G/Hr6kyVSUfKQIzEzpcdA?=
 =?us-ascii?Q?cJN0+RHh+43UMmCDAFE/W88trIwuD1wwg8p/GdV9+ypjYtw7nWJy1v3yEr+T?=
 =?us-ascii?Q?/doEfMFRqWHB0byiLWbov9NkaJYOk96va1huynMB5wZfxuqJK0vFfVmXKDZO?=
 =?us-ascii?Q?DG8PQCmwu3MZiQYG/vzbUxhF/BFmnex7s+h1VLneST9blk2PaHxGLk7OOt21?=
 =?us-ascii?Q?VhCNw5CEUniJE+A3q5VAmlbvtPRi4+c7Nyq7w8hmHTpqYnF19Dc9qhs3SA6F?=
 =?us-ascii?Q?eo5F0WDSi1shsLQLV5davvhJ2/i1O3nt7zfromhWz00l5ffZTFxfoHtUTgD3?=
 =?us-ascii?Q?Yvd5pxBXf2CG5pP8JwmB2mVpGVrD6LE7ZmB5iAfXsrA67CifgZB8z0hgitNm?=
 =?us-ascii?Q?qfOWkm5baWv6Rz2968R57S2f6t8OHRcV/HHPzQEc8y5mRqA0UbSFur/ajhTk?=
 =?us-ascii?Q?EQk+CfKtG9CvMVljhGyn5nNJzXfD2dpuizmeq87uhKqruQmr64CkyYDejSXk?=
 =?us-ascii?Q?irAl/JSJffoCuHrzsycKqm0zac8IJUnZjGmDEZKckNVis4Nwyg9yJXmgcwgG?=
 =?us-ascii?Q?YRoYV7zwY8NOPCEs29q3h/YRxZ+2UrvjACAbssE5ZUT5Whj+WxC06By6pmGR?=
 =?us-ascii?Q?iUGrvz+XFRSVdb3fT5Gi1+v780Q/V/ybYEviOcnYX0sdB3pTa43ACAZSckrc?=
 =?us-ascii?Q?p5h1C9XnCdbmnkLnF5R3A64KnWIEM18FNmvIhZhPcJ6zXMtb98Em/PA06dnG?=
 =?us-ascii?Q?W4QQjANMtjmSZJgLNZ3qAgfYxjb/bFgT5s1tinI591rd0ePuA6ebPjUgCH4r?=
 =?us-ascii?Q?3y5vTDD0hxSQJuTrskMHVtcHwsbFuaFEJJj0SIenfqfGsrtJihnM+4+ghVDo?=
 =?us-ascii?Q?e5YRAzmWLAeVGMzV9EVKfUWJKTakwI7JZ0cPmqHaPuMt3lLWehyKrMcilWkq?=
 =?us-ascii?Q?BMc3+q1UQLOiRh95Z6sO08SyCMeA9Fj+AEGzQ/A/jS0XUVQi8bSWu04pMQ9I?=
 =?us-ascii?Q?AWP6WbpWX+6ipd+SMvglu0mMUNFCm2KDCaPWPFxKEvTY6DKZCaE8sa+CP1V6?=
 =?us-ascii?Q?RxcwsLGSQabhgOdBS4LCzLeVuUizvmUSlIuBiyyHRHlR+ztRxmDEB1bfQYdy?=
 =?us-ascii?Q?kQBF8uHvb6Pt+ykiVUXMV3OciCZi9siCb0jHn/OrEhHxnoNoCL7gJ/YlQUMG?=
 =?us-ascii?Q?YicVNnwBo5xFv+IXyhGwp/BFkS6XOI4Vh91kBHK8oFtH0SKjwj/1D25Xa7w9?=
 =?us-ascii?Q?/rOtH10RfoI7G5o7sChRR4j4I4Y4pOtIFFqooaBUhErbQPss6IT90ImshFdi?=
 =?us-ascii?Q?a6mz9bbiFLnGd1FzHUCycz8oMMVE5XOUPBwmcpjOXVjKZfqcC/+aa37/eEI/?=
 =?us-ascii?Q?eEIUea32BUALAhnRHqnyLzbui+uiyn7FQWaITw5eWKUf7t2I2EOxJpJWCvI0?=
 =?us-ascii?Q?mCCKUQIq4kVT/oMaWcb5ImiHy1c++IKJe1a6lwePKrnjXo5HYypy+O81boka?=
 =?us-ascii?Q?XXSmjb2tESPxLYzBj7r5YMV7T/arpuCcazN8OPLjPPGt7Q7vmsQ4PdDMsJBc?=
 =?us-ascii?Q?LdyTAloLmNK9M7RLqRQXooLTj7Djkcb2J6aHX5N4ToWeIO0LHWw/PGKQZ1Qa?=
 =?us-ascii?Q?VFG9Ue/R6HmuR/xPQIA9JVE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FF0085F9CD4AA48BBED1ED62BB2722C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5d679f-5d42-4ca7-046e-08d9cec53b7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 14:27:55.0782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnYq1ejasHDr5bLpDo7gx4ZpoTR85CbZGaOsY6/K7BerbClQH9NfxqJjTTn36Hy3QzGLhm+3ni/Z9gY+0E7ivQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 02:10:37PM +0100, Horatiu Vultur wrote:
> Extend mac functionality with the function lan966x_mac_cpu_copy. This
> function adds an entry in the MAC table where a frame is copy to the CPU

s/copy/copied/

> but also can be forward on the front ports.

s/forward/forwarded/

> This functionality is needed for mdb support. In case the CPU and some
> of the front ports subscribe to an IP multicast address.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_mac.c  | 27 ++++++++++++++++---
>  .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++++
>  .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++++
>  3 files changed, 34 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drive=
rs/net/ethernet/microchip/lan966x/lan966x_mac.c
> index efadb8d326cc..ae3a7a10e0d6 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> @@ -68,16 +68,18 @@ static void lan966x_mac_select(struct lan966x *lan966=
x,
>  	lan_wr(mach, lan966x, ANA_MACHDATA);
>  }
> =20
> -int lan966x_mac_learn(struct lan966x *lan966x, int port,
> -		      const unsigned char mac[ETH_ALEN],
> -		      unsigned int vid,
> -		      enum macaccess_entry_type type)
> +static int lan966x_mac_learn_impl(struct lan966x *lan966x, int port,
> +				  bool cpu_copy,
> +				  const unsigned char mac[ETH_ALEN],
> +				  unsigned int vid,
> +				  enum macaccess_entry_type type)

In the kernel, the __lan966x_mac_learn naming scheme seems to be more
popular than _impl.

Also, may I suggest that the "int port" argument may be better named
"int pgid"?

>  {
>  	lan966x_mac_select(lan966x, mac, vid);
> =20
>  	/* Issue a write command */
>  	lan_wr(ANA_MACACCESS_VALID_SET(1) |
>  	       ANA_MACACCESS_CHANGE2SW_SET(0) |
> +	       ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
>  	       ANA_MACACCESS_DEST_IDX_SET(port) |
>  	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
>  	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
> @@ -86,6 +88,23 @@ int lan966x_mac_learn(struct lan966x *lan966x, int por=
t,
>  	return lan966x_mac_wait_for_completion(lan966x);
>  }
> =20
> +int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
> +			 bool cpu_copy,
> +			 const unsigned char mac[ETH_ALEN],
> +			 unsigned int vid,
> +			 enum macaccess_entry_type type)

This doesn't seem to use the "port" argument from any of its call sites.
It is always 0. What would it even mean?

> +{
> +	return lan966x_mac_learn_impl(lan966x, port, cpu_copy, mac, vid, type);
> +}
> +
> +int lan966x_mac_learn(struct lan966x *lan966x, int port,
> +		      const unsigned char mac[ETH_ALEN],
> +		      unsigned int vid,
> +		      enum macaccess_entry_type type)
> +{
> +	return lan966x_mac_learn_impl(lan966x, port, false, mac, vid, type);

If you call lan966x_mac_cpu_copy() on an address and then
lan966x_mac_learn() on the same address but on an external port, how
does that work (why doesn't the "false" here overwrite the cpu_copy in
the previous command, breaking the copy-to-CPU feature)?

> +}
> +
>  int lan966x_mac_forget(struct lan966x *lan966x,
>  		       const unsigned char mac[ETH_ALEN],
>  		       unsigned int vid,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index c399b1256edc..a7a2a3537036 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
>  			 struct lan966x_port_config *config);
>  void lan966x_port_init(struct lan966x_port *port);
> =20
> +int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
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
> +
>  #define ANA_MACACCESS_VALID                      BIT(12)
>  #define ANA_MACACCESS_VALID_SET(x)\
>  	FIELD_PREP(ANA_MACACCESS_VALID, x)
> --=20
> 2.33.0
>=
