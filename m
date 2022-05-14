Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E97527484
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiENWkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 18:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiENWkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 18:40:08 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00046.outbound.protection.outlook.com [40.107.0.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D2727168;
        Sat, 14 May 2022 15:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyB6wW3We2iEOkjmcJjhdGGSnpAVMJcx5nqYWGJ45QyvKl6IjnjA7IDTcBtGrykeF+iv4XY0T2lrhc0xYF/G+Uxo8PUgPtfEaC0SIBBXEI2K4GOlOHnYTTs0U/tam+TiSG4w6B+8BksnFhjHhqax8GuVNLuWyPpMW0zHxDUAqSdv5VpP5tutqIBCQU9YiaU2cHvNJf2UXHaQOxyMAJ65JN8YN1Me8XVDRkxOC3hYaVdmdXXOUynPI7q6IMCsZ2IWJrxeq83fxUA3tuFJPypzHpgwjuIztkuRmPn8dyZXbRky6KJzD05aIyPXd3VLcN4Z8CiE8rHtdLcme8WGVWzCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gODYJksYp4YDb7p0NODo6HHHRJnyUeL+gdiwiC7Xihk=;
 b=np1zR2HWLX7tUjLumKTyLMP/pIoX2wE3JHb+xWCD9OvdCycmYsuAYX5c9nR1DNhkp5H3esqkhY57m4yh1HiHJiBALhTJlKqhX2NjGYALixHWWrLUMOHkw4FjB3tczULZkyPsXlEQX4R07L97EvTmqWf8v/+tRG3fAR/TdMSUQnlWgRx/7B8uZOoAoPSYXvrFyzV/aF3PfhJXS2kV0BYAI65lRBg6i7Ur7z9H50a02shyGgpbq3eYQx5wRTkTWVr5SfUVRqDC6vEz38LuaOjwSk4LKElWVRvVVWIJn2ThYIEjzmV3GjVbpxp+erhGpfTrVhVcLr4QL7BOXycpxF6UCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gODYJksYp4YDb7p0NODo6HHHRJnyUeL+gdiwiC7Xihk=;
 b=K26qvKzhKfXEggyvD0F3XewcFA16ZEc5HIh8atuWQ054bm8yYscZHkoGrYw4R8LgKzTOi4E/of0Ev2kLUxsrPt4Xn9rUL/ZFyjr/N6XKXsfYAGQaU6g4/d8HCtLKA501FWR6PYXqCuctpM9el3VBWPIMne7PbUGa5Mf2pPWWnss=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6192.eurprd04.prod.outlook.com (2603:10a6:803:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Sat, 14 May
 2022 22:40:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 14 May 2022
 22:40:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHYZ6RHhg5iGg0Rm0uC0ArSy8F0MK0e99AA
Date:   Sat, 14 May 2022 22:40:03 +0000
Message-ID: <20220514224002.vvmd43lnjkbsw2g3@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-3-maxime.chevallier@bootlin.com>
In-Reply-To: <20220514150656.122108-3-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72088e01-ccbc-429f-3921-08da35faafe7
x-ms-traffictypediagnostic: VI1PR04MB6192:EE_
x-microsoft-antispam-prvs: <VI1PR04MB619285C2179710A9183D0B00E0CD9@VI1PR04MB6192.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7VqykzCi04dTuwhfBxUxqEnJfhNtLUuPhsbc5TbPaRkuk0P3nxj7ZlcdSGnDNYkKLAy4C6lHwikyOWMSCVtycl4y6LHbZooBKSrF8nzIMJCcQp3Eo/5uj5md9rzEke+99w0kEfKZpYvcSrmF5DGQUUaFrHvZ+jz9xMHZ9X5vP2eFW42bl+Xpi0Ii+Yv3gREP6IcKvJ0ikVLoIoOPrjs9ALOGiei3WTTPuDOs3uDr46vmrYa7TkG8L5ZZS3Ev1Tb3DyBXjOa17KOv4COufXyxwxItvSbrSU0YTQyOS4Stqx6jkLF6TS7WCEMCpUeW1mAvzvAYDu+kcjTk26ims8ngrliwY1R1rCkAj025fQyvtEL7cUF4TW9TErXGB8r9j0TCJFlnOCAGUedXwLUQaGaN9b3hpyn+vQyg62ZNsKR0Fj+goT4pPUh6OKrC9Fpk2i2LzlRZMK/dK80Uf4PWRgwmxc7fGysRZ7NShrQDazbkGvttZHLDj6uDqveLanWmRZOlYoUT6Y258IO/b56YYyhsPWsX76OJdb/bLUiE5aQSMDYPIwYcj3FuO8zoNyqaLAxXJA4VD0tOdeT7uXAX8gX9eqaI8xZpQg1ethXAgaGFWxEb35j+YSWoBMwLIls3A7P7TG3OWvua/L2HtMftcoFOQDbvaMcEFHiF6QVj0D82J04pLY4/SQZMslnrETOgoL4vobdrSzEsOoL8VIWEaEY4Kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(186003)(1076003)(316002)(6512007)(9686003)(6916009)(54906003)(2906002)(91956017)(6506007)(508600001)(33716001)(8936002)(71200400001)(66476007)(66946007)(86362001)(64756008)(8676002)(76116006)(4326008)(66446008)(66556008)(26005)(44832011)(6486002)(38070700005)(38100700002)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dB7q/Td2eMYe8COBaQFkoVSFyBPR5vsmEZkC+Iv0TG2ssp7LrxauQzTLBZYg?=
 =?us-ascii?Q?QAF5z8nl28QWRf4yWnUX+9KMBr4VWBSWh0gRqyE/N7Bz8eYJH5KeDb/Zdcxb?=
 =?us-ascii?Q?q1WXP4t0tshonnKTRWFKPqE5LPNJODkE67Ly2vekK8UUXgj0N3ToOVqu8fXU?=
 =?us-ascii?Q?6BANW8ha58ic7RxY/Z4gvzWHklxIlko46zOvkC/KvIpXBZenUt7EiOvxhZKe?=
 =?us-ascii?Q?IwecW81sWRClhTYOPDiDBfbmrgduHVn/XMnxtR2pcMLx4sgvQcr/9MCHCbxt?=
 =?us-ascii?Q?BeVG0CvsOwzLDZJfAt9rw/8Ag6pJUKD7FRuZO2K7tMyWorqiWKZE9AwFZl//?=
 =?us-ascii?Q?qyRshuvpfICmnbX2E4noGQFreTOyfx7IwAdDUZEEEkmuEA9QG68vY27Y5j86?=
 =?us-ascii?Q?4/R6vFY04VJoxp8gE1TcPs/l+QPgQ4Z2Y9ADRVQ77FOS1fJXQn3KSY+FxWmx?=
 =?us-ascii?Q?Q4SEgk5BKsUSKpRvE71tN1dwSeKZj1CNxx5X1wN6/s5hCnHKLgF6+UPKk0LM?=
 =?us-ascii?Q?AuMJYgiiXGqke8Ep3EQ07Wyq5QZvCkKvSw0fE+CjeMajZOJ3HhitKIhT55/K?=
 =?us-ascii?Q?mYWykt9ytbJe0ukD3LshNXcYXUAQfSYsQ/wNNpJTlIrzztBeJ9kHFuhQi4hc?=
 =?us-ascii?Q?Wvc+Cf37BfyAU42O4yFPtEzne9JQaiRnEBRLtkt5UANb8DK5Frk60fGUThQj?=
 =?us-ascii?Q?QjtLv772bqdbIrF7CG777ZoXyLqcuNUp6c7x0JStZkWJc+49fxhyv5QIzNnb?=
 =?us-ascii?Q?va+3JZE8GToQHXADSDdbo3lgOQRqqEa5jp3fGYymqW6hK59Knnbtfr+q2bWs?=
 =?us-ascii?Q?sG5yT5neW3hk5KEoNu2URLGTgGclkyzM2pSRp7QYBGZeDkzme33ClG249is4?=
 =?us-ascii?Q?VHAoDB9AwRE8D36mwOn+FWqCXzMkRGRasJgqvpGbFUcyo2UypvlXNGFB1oQQ?=
 =?us-ascii?Q?QBEAB0JD5au6hHboBM26uoU5xQIJ8/Pv4AHxVVEliQqreIsKeEl8PthDD5eB?=
 =?us-ascii?Q?lbBQVhNS6verG7x+itZ9vYrE7mqrfYAjmZLOII407fVBwLChdbcvaostqbKe?=
 =?us-ascii?Q?kfjKXyQLML6OLfqgvzoHpxwCU9JYCnNKjVlWlt2vcW3esD6QGP9FGMm6gxH4?=
 =?us-ascii?Q?HxtPxGH753t0psJROqRw6y7RIYOMuUiYseAwinHee8HqmEGbouOsYXhN5Hyb?=
 =?us-ascii?Q?KCi7cj6u5gK7Y+z+Ha1rZhyrZt4Y1OcxhWZNYB88NAG3FxHb2U0S9KiL8kwE?=
 =?us-ascii?Q?aASz79qSXlnQEH74CkMjXdl79M2e24GPHBG3caIFpULOi1CiwSZKYNkZYQhM?=
 =?us-ascii?Q?5cwRb+VX9iOcYaV1WdwSXYQV6gw76RVsT4CbZfzxSnr5g6le5wberAsTW35K?=
 =?us-ascii?Q?Dop9aEid1/WQ4z3JFR9eAueuZ3t9aT6udqHZeNyWmDGAu1BBY0V3FiLM3iU0?=
 =?us-ascii?Q?Z8Bf+8pckAEKO47edFa8FW3B43C4SwDFpLY5WQDtB5V/ndtuKXlJIXhjLL6J?=
 =?us-ascii?Q?CPFEXnO/KGyDzcXxKWYVe1CDaau+r5cT6N+WYj1c7BF/7F89we9OKCMGKeuc?=
 =?us-ascii?Q?zbSCT8uecYrSuTMg00qBAFjbolUAkuif4AgnWJB3k9w6TdTN2qaYkMlHLIqD?=
 =?us-ascii?Q?q6W93Lxpw6L/RbGg+FH8XGrtNXyt/GB2VGlTm7In4TprJlhQv2A9KA79ZEM+?=
 =?us-ascii?Q?/8VlGh7zYG5BYiCovFGU+TTv7nLysGwkkFyyU/XkjDjiFaacpK0BVxa4Q/Jh?=
 =?us-ascii?Q?l7GRKIVL3eNbZ5i6NJWhKX85gfXTEX4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <675263ECFD8779479FC28E14E7E49F72@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72088e01-ccbc-429f-3921-08da35faafe7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2022 22:40:03.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pXmECZhqCi/4x7BxP5BC9dT1WuJoriSOS8Fm2f7Q0SsjfIJYdjn7PM7FywLjypZeSi/RLdDBLrPtECBSWKnQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 05:06:53PM +0200, Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
>=20
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
>=20
> This out-of-band tagging protocol is using the very beggining of the skb
> headroom to store the tag. The drawback of this approch is that the
> headroom isn't initialized upon allocating it, therefore we have a
> chance that the garbage data that lies there at allocation time actually
> ressembles a valid oob tag. This is only problematic if we are
> sending/receiving traffic on the master port, which isn't a valid DSA
> use-case from the beggining. When dealing from traffic to/from a slave
> port, then the oob tag will be initialized properly by the tagger or the
> mac driver through the use of the dsa_oob_tag_push() call.
>=20
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---

Why put the DSA pseudo-header at skb->head rather than push it using
skb_push()? I thought you were going to check for the presence of a DSA
header using something like skb->mac_len =3D=3D ETH_HLEN + tag len, but
right now it sounds like treating garbage in the headroom as a valid DSA
tag is indeed a potential problem. If you can't sort that out using
information from the header offsets alone, maybe an skb extension is
required?=
