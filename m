Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995DB32D064
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhCDKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:06:55 -0500
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:49536
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236700AbhCDKGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 05:06:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNOpLSx1onApCGaB7s9j3OWyoFVcg0mFjcTFAnnTEyIxapskkH5sFHzB8dHUiuC+IErusG1qNRT95EPXvVzNx7AWWVrQbfoVlYyK/fK8PrritR7Po7IJf2LeRaD7Dl5BZn/2w8MuQmglwWktabtWh8saxZVAxR4GyyRSlmejG+zoeJnkg2lv26hgqtlLvVwI4Nmh8lb6dRlLm/WLP5CG9w1Fda8VTDwKEqb+2kNY7/NI6AKXS/58lhSpZk8YoShFOO5Gz8rUdf81+ePPX3YE3Thpl5Pbc4HwvR3kECzdwfjuXjpMENR6ZjBxLKsxs1WEQXCPy8OSCrGe70cvc140XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFa6bu3L4MCymMLGGgddrk9laDD9SxrgSrgBAfhvt9M=;
 b=Gsu1NN1Z5saYVXYe4E/Q1OeFLO3PNwdsnf+2fzcrB7zLCoF/gu/5pJkmEA74Ku+7eNPH/FvC3SW18VpNjTbnw5zuc/zlK2aMbjqwZ9ObL0pokCHoqI8kfB5pr85fr76xtbxGf9z+IL2T8nIysY0TA/B8XllrqdzUp3y08rCJDMyZyQrOdt7Eis9mM4J/br25dm+6tdHidMMA+NGfU9S+z5LbKPYEiTjOM7YPkemL6s23pD2ZtPMjGyvEKz4oeeYi8sGaZD6gjF0RPBAumoOFciDg2yDcs1j66QM9SgI20evfkdpAEso5leBSGvXiE46yq8hvh5NluXcbfYq+54bQ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFa6bu3L4MCymMLGGgddrk9laDD9SxrgSrgBAfhvt9M=;
 b=WQScbGE35PTiIz4S18hxrvtk/QyA28yYPBqPhdtuH0yPKlKVxmPFOqbSPndaYVlQe1BzkvBarh8W2KWxEGRKmjFhGOUpHDywm3KZ1ZBdLnvWsdULYueVxlTbg4piExsBRBMzANrYO5WcuVApn6a606Cmvfal9OHI26XEphddj4Y=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB4139.eurprd04.prod.outlook.com (2603:10a6:5:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 10:06:00 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::ec69:6629:7fb0:cd72]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::ec69:6629:7fb0:cd72%6]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 10:06:00 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "michael-dev@fami-braun.de" <michael-dev@fami-braun.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] gianfar: fix jumbo packets+napi+rx overrun crash
Thread-Topic: [PATCH] gianfar: fix jumbo packets+napi+rx overrun crash
Thread-Index: AQHXEKTJ119l0eDB9EWatoIEiwRqtapzhBFQ
Date:   Thu, 4 Mar 2021 10:05:59 +0000
Message-ID: <DB8PR04MB67643BBB399B02ACBA48C06F96979@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20210304031238.28880-1-michael-dev@fami-braun.de>
In-Reply-To: <20210304031238.28880-1-michael-dev@fami-braun.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fami-braun.de; dkim=none (message not signed)
 header.d=none;fami-braun.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.225.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eec9f65b-ce2f-469d-210a-08d8def51c97
x-ms-traffictypediagnostic: DB7PR04MB4139:
x-microsoft-antispam-prvs: <DB7PR04MB4139D0E0A7BB9B8BC7CFCE3A96979@DB7PR04MB4139.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0zRKpKSNtZUll8Tcg8QBpYyzW2Dc5k9couFHcWJ4miiE1MPsV71abn65PtYQsFvE+aWo6TJkvopwfYjb1ucq/ci1CvoZKMjrvZ2jsHuFY92HLdyfUqZaWq8DWJovFsSO21Yx84K6RtrAGGR5XoDgJvbY66s+wTpTpdVJU0QkGdwqrtbmn6Z4h95IUbuj5AfHm1DkmmFv1Kx7tAdZupG2c+ZvaRSf7qyaPfBrq08kSicQVMHO64cyGOmSSCU9/VAtH9EHvyZ+ZKgtMJFTgUO3LiQ7mcno7ucE1tqcpiTgTTzxSznqzg570GXr9BGgNND7/ssnG75qv4J/YyM9PjfTqNSPs1t9AC+A1/1669WFhUr5OFphL3A5Jph+5xGhl9IEC+g6XTUDrPy4HqZcL7BPvEhu3Yvwx9YP6M5tq/5abcICzhb1lGTygNArWDMTZN4bfT68yupY50opGC7dugxSi+x0v5ThR9Rzeu2MNTOdVYijqCWKwBOv5vILdoOTRRW1jWR2xRcFhm547uySiE29PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(8936002)(44832011)(4326008)(186003)(8676002)(9686003)(71200400001)(33656002)(52536014)(478600001)(66946007)(66476007)(316002)(64756008)(66556008)(83380400001)(66446008)(6916009)(7696005)(26005)(86362001)(55016002)(6506007)(76116006)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Hb1Rw1GVEzdjmuWgazP4uOQPWEsi2DlDLASSYAMcj3x+VxcZApRK5xT5R/Mm?=
 =?us-ascii?Q?IXhFrkO87+3PlSlqpoIXB78f8B2mVhS5UFf856znupIMDDW0/m3m53ul13q+?=
 =?us-ascii?Q?zT0BHyjGdun6+DHkJoBtw3mVk1J0/VR5/qnCgZuJrpYTw5q7cL58iw77OIbK?=
 =?us-ascii?Q?fVTHiAOKZzJ8sgTOxRAJ1O9Ok3DHMBxKCImnJg+bzwpMXua0ZsDey0VeVEow?=
 =?us-ascii?Q?oG9Spb/lSM8uf9Lclk1GdLuFUJF0Geg8wGW311zzySBq8A3WrnahuMlWip9t?=
 =?us-ascii?Q?nBOTaPuvAC3eGCa9szTgzfoFg80hIa9ZWAGC+kvsCnJVOPdNLQuYJ3MG6bL0?=
 =?us-ascii?Q?trhZvplPbzmhtyxGG/zcE2eQWM2W587M/J4dlQsc563XPfrk63PjwDqQMcfh?=
 =?us-ascii?Q?FSmPFSggYhhajbXFyVXrcj30pZvltMwCL/H8o3YloGhy9pUYxsn3wSiFRihr?=
 =?us-ascii?Q?WyVxfP0lUVURrfQRxNUj8c5gG3+5jJMd2d+miwv8722gHXdnnF8Z65C5zt8p?=
 =?us-ascii?Q?ID0YcxJ3uNF2f7tNDbAVxPJs4vugMCXsSMvUgipfQbqji6mbYo5LntawUDs8?=
 =?us-ascii?Q?S0sR5KpDblFMMR526RX9nii8QVy8hPf+ypNgypNVLGYswb0j5aWQQXuC08Yk?=
 =?us-ascii?Q?Vqzd++RZ9GaQgHGP7X0bQAVAwTTECI5CNawEub0QyTfz2vItnD6sCHNZKCs+?=
 =?us-ascii?Q?Xm+z0oMwmFv0ROIKLeQoBbaZEXgtkZ56hm8NaRfeA+s9jzypFS5vMC7YXGjR?=
 =?us-ascii?Q?4QjlnFuJKuRQyLWYFLBRynBEYsaSkXtTK3ElGElibUghkRsns6iOIqwHqAxI?=
 =?us-ascii?Q?4Pkr8YkhRg1Yw+1h0eOQlvZAYafLh2yKS3Ox0Tz445h0RAhrmOkXpIyDoFo8?=
 =?us-ascii?Q?JatkbeAF6KK77hNyPPZjoqzrU6XWXVQ1SsLI4jQ/xZ6G27btnC/E5eYTlCIC?=
 =?us-ascii?Q?KBRcD2RlmRDmVT62T6SDuuo23y03dFJmwSKOPo+J+2V4P6Ow8lw8cnIIP/kW?=
 =?us-ascii?Q?reuFvRNDtXbdUv4/b8Hfv7yG/Nhdkrhi/4NV0B8eKHFMP1RWeU/glCgNuyzi?=
 =?us-ascii?Q?E/06FeUrzdWjboXDHoZwnEk6Vba+DNpDNjFG7krbIcYXq3llnVaGq7HYp3Zu?=
 =?us-ascii?Q?ynz0siz+00EJUW/2DTfROx4YuWjGjlTKMgUcJbbyqXkGh5cgcKuMUdd4xRhQ?=
 =?us-ascii?Q?UsSNRHABUj4xxtFgulwy/7HWH0NiPyYfWAx5woRcTye82Z6q6hpT8PMOyiUG?=
 =?us-ascii?Q?DoyFxsV6u33gq6NUjXDq8YdafZVa0UokvOtO1haV2wszfJ1mvZSWuTfbnTUA?=
 =?us-ascii?Q?UeY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec9f65b-ce2f-469d-210a-08d8def51c97
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 10:06:00.0195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AoVEC0c/aO+LBHCGKZs+e2BAgbxw7944Ulj+co0o0sDc6yJ0h0SZENT2qh5xzVEOXP9qpbxjNbkLCLKxlrj0yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: michael-dev@fami-braun.de <michael-dev@fami-braun.de>
>Sent: Thursday, March 4, 2021 5:13 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; Michael Braun <michael-dev@fami-braun.de>
>Subject: [PATCH] gianfar: fix jumbo packets+napi+rx overrun crash
>
>From: Michael Braun <michael-dev@fami-braun.de>
>
>When using jumbo packets and overrunning rx queue with napi enabled,
>the following sequence is observed in gfar_add_rx_frag:
>

Hi,

Could you help provide some context, e.g.:
On what board/soc were you able to trigger this issue?
How often does the overrun occur? What's the use case? Is the issue trigger=
ed with smaller packets than 9600B?
Increasing the Rx ring size does significantly reduce ring overruns?
Thanks.

>   | lstatus                              |       | skb                   =
|
>t  | lstatus,  size, flags                | first | len, data_len, *ptr   =
|
>---+--------------------------------------+-------+-----------------------=
+
>13 | 18002348, 9032, INTERRUPT LAST       | 0     | 9600, 8000,  f554c12e =
|
>12 | 10000640, 1600, INTERRUPT            | 0     | 8000, 6400,  f554c12e =
|
>11 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  f554c12e =
|
>10 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  f554c12e =
|
>09 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  f554c12e =
|
>08 | 14000640, 1600, INTERRUPT FIRST      | 0     | 1600, 0,     f554c12e =
|
>07 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     f554c12e =
|
>06 | 1c000080, 128,  INTERRUPT LAST FIRST | 1     | 0,    0,     abf3bd6e =
|
>05 | 18002348, 9032, INTERRUPT LAST       | 0     | 8000, 6400,  c5a57780 =
|
>04 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  c5a57780 =
|
>03 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  c5a57780 =
|
>02 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  c5a57780 =
|
>01 | 10000640, 1600, INTERRUPT            | 0     | 1600, 0,     c5a57780 =
|
>00 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     c5a57780 =
|
>
>So at t=3D7 a new packets is started but not finished, probably due to rx
>overrun - but rx overrun is not indicated in the flags. Instead a new
>packets starts at t=3D8. This results in skb->len to exceed size for the L=
AST
>fragment at t=3D13 and thus a negative fragment size added to the skb.
>
>This then crashes:
>
>kernel BUG at include/linux/skbuff.h:2277!
>Oops: Exception in kernel mode, sig: 5 [#1]
>...
>NIP [c04689f4] skb_pull+0x2c/0x48
>LR [c03f62ac] gfar_clean_rx_ring+0x2e4/0x844
>Call Trace:
>[ec4bfd38] [c06a84c4] _raw_spin_unlock_irqrestore+0x60/0x7c (unreliable)
>[ec4bfda8] [c03f6a44] gfar_poll_rx_sq+0x48/0xe4
>[ec4bfdc8] [c048d504] __napi_poll+0x54/0x26c
>[ec4bfdf8] [c048d908] net_rx_action+0x138/0x2c0
>[ec4bfe68] [c06a8f34] __do_softirq+0x3a4/0x4fc
>[ec4bfed8] [c0040150] run_ksoftirqd+0x58/0x70
>[ec4bfee8] [c0066ecc] smpboot_thread_fn+0x184/0x1cc
>[ec4bff08] [c0062718] kthread+0x140/0x144
>[ec4bff38] [c0012350] ret_from_kernel_thread+0x14/0x1c
>
>This patch fixes this by checking for computed LAST fragment size, so a
>negative sized fragment is never added.
>In order to prevent the newer rx frame from getting corrupted, the FIRST
>flag is checked to discard the incomplete older frame.
>
>Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
>---
> drivers/net/ethernet/freescale/gianfar.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>
>diff --git a/drivers/net/ethernet/freescale/gianfar.c
>b/drivers/net/ethernet/freescale/gianfar.c
>index 541de32ea662..2aecae23bfd0 100644
>--- a/drivers/net/ethernet/freescale/gianfar.c
>+++ b/drivers/net/ethernet/freescale/gianfar.c
>@@ -2390,6 +2390,10 @@ static bool gfar_add_rx_frag(struct gfar_rx_buff
>*rxb, u32 lstatus,
> 		if (lstatus & BD_LFLAG(RXBD_LAST))
> 			size -=3D skb->len;
>
>+		WARN(size < 0, "gianfar: rx fragment size underflow");
>+		if (size < 0)
>+			return false;
>+
> 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
> 				rxb->page_offset + RXBUF_ALIGNMENT,
> 				size, GFAR_RXB_TRUESIZE);
>@@ -2552,6 +2556,16 @@ static int gfar_clean_rx_ring(struct gfar_priv_rx_q
>*rx_queue,
> 		if (lstatus & BD_LFLAG(RXBD_EMPTY))
> 			break;
>
>+		/* lost RXBD_LAST descriptor due to overrun */
>+		if (skb &&
>+		    (lstatus & BD_LFLAG(RXBD_FIRST))) {
>+			/* discard faulty buffer */
>+			dev_kfree_skb(skb);
>+			skb =3D NULL;
>+
>+			/* can continue normally */
>+		}
>+

This is indeed an invalid state. If you hit this condition, discarding the =
skb is the right thing to do.

Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>

> 		/* order rx buffer descriptor reads */
> 		rmb();
>
>--
>2.20.1

