Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164BE4E2C8A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbiCUPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiCUPoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:44:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFECA174BA9;
        Mon, 21 Mar 2022 08:42:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFhTWSXAdQ/Kc4dOtfqr3+tho3YOeFSjD9oLrMalmBppys0v6GRQM3zSQTOXH3Kn9h4bUY0nPT5I9BdE3uxX6WKbN+hsn+4ttEIDHJH2VXbMMel9E+XOOJcSi6bP1ZNpfDbCIIqKl1LqMryTA8s0G2uZwdgcqQ/dp5lU+4TcJFsd1Ff1pDtpuL0uvu/M9plY9f6PEbKA0JD1EV0eg784d3A2ihdSekReU8eHiQVPajNp3fTKU4nJjTuwQBf4DTwcJ1mnR03DRN+GYTtCCJgbYCALIYD7YsT01V8Eud6qZXkQbjIN6hM+Jf824cmW4BL5OxAZXQIRMmIOSl4vZrEV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zfPLp9swCMVmgqRmZXC6U3T0qj5RwiziL4zJWFeUzc=;
 b=oW3jFH8pLzXAEDRaufH9uojFxyioZoPrBjK1So3dQgU1RIQoiLZF0HRyCo2wiukNcQRWnHQcEYidkqx+KvsS4jL5uEu5NseM7wZrIUvVDO7iETrLXaVqz9zvZgYfaeWTLYpdrwaeQ/Qg/DG+nc8pvQhLM4OhiVnq4F/mntoJy6h3BmPDMNS6m/xVTHzEsP1BrdBwoXQu4YrFIFF251BKf6Iwaxr6Ho6t7XFk7yGFKr4D2YouWMiAoRCSgK1q+D+iU26W2j0NXmY7EmNP2xr5CTyIXaZNSK91PGfjPUoDt/oi7tnMnM2FW5+asdSU3IJfXWIafi9hx0FCUs6ncwsKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zfPLp9swCMVmgqRmZXC6U3T0qj5RwiziL4zJWFeUzc=;
 b=szOpZg43ja8If/nqcY09zvCwuMePelfvLbw7NWSobQ7zzfONqd9HSe79EWE5O6WH+BH9Gk8NkmQpnYwtzIQjVy/wOkZCrBLFY8N9ePgH3zQ8nsG5nhTUHmOaIbgfBRWgq4wfLUot2PVUPppTtTBL4HIZF4NUcLcVWUEgxb1JJRE=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BN7PR02MB5059.namprd02.prod.outlook.com (2603:10b6:408:21::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 15:42:52 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e0b3:f0cd:fc05:3659]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e0b3:f0cd:fc05:3659%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 15:42:52 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andy Chiu <andy.chiu@sifive.com>,
        "robert.hancock@calian.com" <robert.hancock@calian.com>,
        Michal Simek <michals@xilinx.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Topic: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Index: AQHYPTgrb7N/skG57UG0+vcByqvdZqzJ9vVw
Date:   Mon, 21 Mar 2022 15:42:52 +0000
Message-ID: <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
 <20220321152515.287119-3-andy.chiu@sifive.com>
In-Reply-To: <20220321152515.287119-3-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45670fa2-9a1e-4410-7a78-08da0b5175e2
x-ms-traffictypediagnostic: BN7PR02MB5059:EE_
x-microsoft-antispam-prvs: <BN7PR02MB5059CBD1776611A3BEAC688DC7169@BN7PR02MB5059.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o8yN/G+jZu8CkKqnFeBj7nGDiT3lRaZSoGjhPA0r0wG4ITDcQA1MipIguMbuGfBtywJ7cNy3UWeJ2rlx49CCcWHq/St5xeHZ27YNvUwHzCOxGUXV1KyumJ6xQeVFLl2vsv7rCt4Q5wJiTGErA/zLxgF4fOsodpOIrk/EAytHJHy1X+NeUQmkYZJWaHlrmLmo6E4fmA+lCA8dRA2KhxW+8Ke+G0HfOo+3g38nEFsbJLnlTqw27vS8g1SRSgfOvW22YEASRchjyEE3q9DPaQHn4KF9uydR/S71bK7OEnzh1r/h7aOcabDlo0YgPinlvMXMJ4kb6aMsPYruKGT7aw3OmDzH+opZoU1LVW/7b5z3e2CMHsYMe9xqxmZM35TD3/8p1zqv9m0QghksoKhAt97FZlmZPi0CnL5JZx4lKEYK3P6yyyAmT9pea1Zb4bBNhRD9Dxgb+sZQxkvgr/d1n/8K0djF0keMcXcF55W5xyHgNa7ePur5FPGvKi3Kc2442dxfBnt5cOArjXQhZLNqqPekJ83vcjbjl2rCr6LR5tggZDGeumA9oTj8rTmf5ItGmAiB6bqTXpOkoLOuRxxDePrEfiNTJiJXdngiK5tGfBboXWVSiL2zTAI9hSrDnMuwSzZAgkxzciiY3+Sz1eXHOhENh3QL2u6WbzVDYGAZ4WYLR3UmWsTaFuB9+ZrChfnToTKaYnMOGgwPyNfIkfwCIXdMHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6506007)(2906002)(76116006)(66946007)(71200400001)(7696005)(66556008)(66446008)(8676002)(64756008)(66476007)(53546011)(4326008)(122000001)(38070700005)(508600001)(7416002)(8936002)(52536014)(5660300002)(26005)(33656002)(86362001)(38100700002)(107886003)(55016003)(186003)(316002)(9686003)(54906003)(110136005)(6636002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l1P0s9UfEY5pL5z0oL3IsP3ZUwmG3cX+FAQOT/YzBpvE3BGtKLA+m8z1P7F8?=
 =?us-ascii?Q?XHtXc+C2NiTqaOu/F5JgvLCzz0iv56iJR2awsiyKo0PB4ul6ej9SFbMdmmqP?=
 =?us-ascii?Q?P8b+UPuy4SG2XrigiEKUI3IkciVnKnD0FytKsw27aEY1GvOEvyCx1kGHdrcE?=
 =?us-ascii?Q?V87cGUpB7CzV0v8AV0nnUX59VSWo7RejRY1HdIx9jOfSYEijwqVKgca7zvK9?=
 =?us-ascii?Q?MBIGqZ5ySGJhME5W4YyeayXWUnOjh3wBiCM2h9HGLvjnGEQPm7MK+YwvmwVk?=
 =?us-ascii?Q?G/KDRmldLGzGdhXiAPdH61FX9kSIDT5K+pnMld4zFdVRnrgfWfsP1SWMi8KX?=
 =?us-ascii?Q?YzhPfB5MWVpf3pkZI06xy0oil3+iY5todLjDFBWdX2x7TIyU8CH6oCeSyM33?=
 =?us-ascii?Q?69wmsZSnca19EZo0PIBIioJ/25AFUs1F6GcUJa8x8QYatcVxnxqzrq71+txM?=
 =?us-ascii?Q?1c7vAfmNgvPE0fwq9yGS0HEC2dr3tgSyo6Hx0myCu/R1ZL/1/I6yFotkHgoy?=
 =?us-ascii?Q?GeWeEZe5AYzo7qHZCxvnpVzyOgd6YWE8wp2lSZsrTc52vGWUaPN0V5+oQiDP?=
 =?us-ascii?Q?BaaVNXtXsatbk1vgJUr6wcsPlel4llXWr2LBkbTFQFYJLnFYA/3QGdPY9OnP?=
 =?us-ascii?Q?m724mpgfM8Gkjdca3+/PVfNPIV/hc1M/Bp/X57Ho/i1+Ks99D1+7DjePLFRo?=
 =?us-ascii?Q?46pVUbmnYetZ3bb706rLfGS+XJLJMeTGGPyvU1yuIX1QCE1/BQ9BtG6F8FjN?=
 =?us-ascii?Q?CN0ULShJhmqDJPDjeFq0wg8yEuz3Y37IO+Erde9YG5I328t6H2K1wQs9H3Ps?=
 =?us-ascii?Q?TxCdVtD1wrVk3ki7fM5aGExcCKQw2KRXePA0+nDwaYL2l2ry77DdOQbI3Wwk?=
 =?us-ascii?Q?PeTDQU1xRwIOn+SCmVhOJfbHngnKJ6i7ZAx3GaQRE9I9d720SnKWmUvYVSCu?=
 =?us-ascii?Q?h/+/lXw9MUD//wfyLzt4D3a/c1Aqf2VYhktEy9x/sGt/2ijkoljesQDu4dIj?=
 =?us-ascii?Q?2vATAxFlZCEzoLH/LN4LHn+Uk79M/ompF8jfwSpcPurf5GFh1IDVQtwivz1O?=
 =?us-ascii?Q?9/tGAnkYRSzSc1V9LnSXa+QiAdtawnB6FfK5Y+lgnZpFGpXo7bfwvxKLPGri?=
 =?us-ascii?Q?5wgFZc0CR5b9kIcPThg9TV9pxXQMSF/C2a/VX7R8H7e2iJQAmEMzsbZoY32T?=
 =?us-ascii?Q?kUFnIhnAkGYMGxr5mL0JH/WemY8LqHrW7ccjD7vAktIWZfiuCGTpVpcnB927?=
 =?us-ascii?Q?dW46jKQY8w764yDtxFRmGRRYwB7k03BZIEc3tAKNIk0Bj9AALVeVplaNfinQ?=
 =?us-ascii?Q?MLSLyh+E/nuIuHC0Jd9NWrzor2GrN9JNkYS4G25pUHBe7WbwYYcTsG3g+2Nh?=
 =?us-ascii?Q?mNq62xRCKGRmL57DQnxkzpeqr3EDOXyJPCMnEhJ2dxbKS9Ef+WcUk1EsLRXx?=
 =?us-ascii?Q?P4poAhglXEdUlDYsPJ9S4XdS04bO50Mq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45670fa2-9a1e-4410-7a78-08da0b5175e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 15:42:52.3598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IkvtL4TJG22t8Rh8Q/gbbf1z8EvvuZ6SUY04r7FMfP4vaUeEsi1RIvdEZGezo59qUMp1Ywfo1vGDCA64vf5ZAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andy Chiu <andy.chiu@sifive.com>
> Sent: Monday, March 21, 2022 8:55 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; robert.hancock@calian.com;
> Michal Simek <michals@xilinx.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> robh+dt@kernel.org; linux@armlinux.org.uk; andrew@lunn.ch;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; Andy Chiu
> <andy.chiu@sifive.com>; Greentime Hu <greentime.hu@sifive.com>
> Subject: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
> attribute
>=20
> Document the new pcs-handle attribute to support connecting to an externa=
l
> PHY in SGMII or 1000Base-X modes through the internal PCS/PMA PHY.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  Documentation/devicetree/bindings/net/xilinx_axienet.txt | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index b8e4894bc634..ba720a2ea5fc 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -26,7 +26,8 @@ Required properties:
>  		  specified, the TX/RX DMA interrupts should be on that node
>  		  instead, and only the Ethernet core interrupt is optionally
>  		  specified here.
> -- phy-handle	: Should point to the external phy device.
> +- phy-handle	: Should point to the external phy device if exists. Pointi=
ng
> +		  this to the PCS/PMA PHY is deprecated and should be
> avoided.
>  		  See ethernet.txt file in the same directory.
>  - xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
>=20
> @@ -68,6 +69,11 @@ Optional properties:
>  		  required through the core's MDIO interface (i.e. always,
>  		  unless the PHY is accessed through a different bus).
>=20
> + - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Ba=
se-X
> +		  modes, where "pcs-handle" should be preferably used to
> point
> +		  to the PCS/PMA PHY, and "phy-handle" should point to an
> +		  external PHY if exists.

I would like to have Rob feedback on this pcs-handle DT property.

The use case is generic i.e. require separate handle to internal SGMII
and external Phy so would prefer this new DT convention is=20
standardized or we discuss possible approaches on how to handle
both phys and not add it as vendor specific property in the first=20
place.


> +
>  Example:
>  	axi_ethernet_eth: ethernet@40c00000 {
>  		compatible =3D "xlnx,axi-ethernet-1.00.a";
> --
> 2.34.1

