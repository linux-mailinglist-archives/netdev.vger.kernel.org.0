Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7B4EFDD5
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 03:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiDBBy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 21:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiDBByZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 21:54:25 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50079.outbound.protection.outlook.com [40.107.5.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62AF15A238;
        Fri,  1 Apr 2022 18:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gy554HAL1at63TqpENlmFO0CCsTrheLUH9+B/pN6Id1PnjXHeImUYmc0QuHyt49r8KGwko+p0yD/tqNXwjIwxivoaDuM3kYh1qEqcQmLUfRxn5ngh5aiNTf5zioWyZ5U3s+JvWZMxmuqafQ8zC7Oyc3eiphTxaKIG7Qaz4a1HWzjZhMnQmzCJ6y7/QcojEcGyw9yMvrty6+G7VUPId0JI/dS0z556k8mpkyw4Tf/BDx/0ql8iQjTEo7F1uXCrdjA1U7IDNRkJm8l/OspiOitADgs47UmWTUPp2xK1mvp5KPtKIC05p1Pf3ieyNHTpRQBJyx8zt4rDiyJZmb0uJ/jfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ij63lRjbCF93NjZbPJEdXUkLp46KYTJrWGvkbyjN84I=;
 b=A4q+zet7xIdZbGGFCjEHAD3Z/Vhb4s4kmHCd20zV48KKUn+Es86plSPT2yHHHEXM+WNEeIrfqU8metUnlr9+kuIkgTwUwoVY4+KBay1Sqovv/bYVP+gdg3DGngefabcD4J+0VBMIMQDDkKIsiYJSiyxuZf876ODrW8xWj0NFZBB4Ghlo5dzZwiGsd7Xu2ZnbZciWIWdOB7a+6gVtson44H9zPBGhB7Do4OLe0FD0kBO6G8dLENWFaP994cL5qPq0F7oiUudm6zwnCgQ72StA8nTdqxTu5nb/ZsttDCdUBTnFhxWhRA3bRe8ejftZoj7ZzGqRuDt/StdhQTMNX5ZAtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ij63lRjbCF93NjZbPJEdXUkLp46KYTJrWGvkbyjN84I=;
 b=I0OT5XGcc08Dibqpck2t8H+EqQUh3tbt87eGuV3MdHSbkzLL10fxm6iGOOQqH3UOJAHbHDxLpqxjy/rH7nN+2G0P0g9PWsWftiEEDFIGU5NToCgtZWaLa1EpY8MB+pIctoGY7E60LarpRntPpPdvStfRsvRmSS8Pw4f0dfpWtPI=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DB8PR04MB6700.eurprd04.prod.outlook.com (2603:10a6:10:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Sat, 2 Apr
 2022 01:52:29 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::389f:e6eb:a7a2:61b6]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::389f:e6eb:a7a2:61b6%7]) with mapi id 15.20.5123.019; Sat, 2 Apr 2022
 01:52:29 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Stefano Stabellini <stefanos@xilinx.com>
CC:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 0/4] dt-bindings: imx: add nvmem property
Thread-Topic: [PATCH 0/4] dt-bindings: imx: add nvmem property
Thread-Index: AQHYPzDdeGvQwiTmbEmT1yMzXeipjazOYVIAgAvbfICAAasQgA==
Date:   Sat, 2 Apr 2022 01:52:28 +0000
Message-ID: <DU0PR04MB94179B979091FC517FB8AEC388E39@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
 <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
 <YkZEIR1XqJ6sseto@robh.at.kernel.org>
In-Reply-To: <YkZEIR1XqJ6sseto@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 078daf56-e203-4519-bbc3-08da144b71d3
x-ms-traffictypediagnostic: DB8PR04MB6700:EE_
x-microsoft-antispam-prvs: <DB8PR04MB6700A2B746DAB81C8E75E91A88E39@DB8PR04MB6700.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RXNt8HpN/wMqRjTeept6DtZCelOaXHQoQHQ7FDu2a9G9XMzTpoeA8JdN5Nd5o6KeTIEoidjGKQ3Z9o7bBOMijAUxNaj1RbTKBHwH1Z8Fc/hRxmsLPe29CqCfWtToxCsUqRzXo6Sq4YCaxXVKx8MzHiR/mi5sU0CyLfFD3y7cSLODT0PIKGwDn22DFujvW+3R/Gm3WNjYgogY+AuPXwxUylVT32MsiNsaNQjhbj+1nnHztShYHz7p3yf6b4dsY7oRk131kWm83OAIjFq9WRJB8bBoOD1GUCuMDvDN+GNr11jiQYiXlZYpVyyDfR6VggTlZ1wkzFE/ZrhwzZbJ0+7e8GjrFgUhPbTJLiM3PQ1NCI5i0Dhb2Yk6tiOpBvCvfBF5C+epSIW3SX/MTvfGe62XMasezlrQqaDv8C1CZdLeHE9+fhdelA/sO1jd7fs2Bx2nPQAqOmkD16IRKrMZf0AGtc+tTNlEu2nE8Gtf8gJx4joKQpKhWDJFtVDmyDYBwp2uyPAYjeIyXBkqE6Tx0+jEu4jJastJDCtqNPdxj5gbO/3NbF9dVeC22hJPB3HEwHyIAdW1MGB+zgzxUbpQMW3JJSo2KNlvl1UkAt8v5NoXVbfkkiTL0R252pTKLh0oigTXC2c8I2X9Xa+OpJ6MSfRloJwp4Qiy6AWYBLlWsmxRPhVCf7Nq0tYP3YnOtv4oWtbSCh71KZCp9zsMpwmoTIkLFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(6506007)(5660300002)(54906003)(110136005)(7416002)(508600001)(83380400001)(33656002)(55016003)(66574015)(44832011)(71200400001)(4326008)(8676002)(26005)(186003)(64756008)(66946007)(76116006)(66556008)(66476007)(66446008)(8936002)(52536014)(2906002)(9686003)(316002)(86362001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9rSWmk2Bkr5+xvSO4HqCIFGVI0QF30sfj/6uCxv4l+x1xG0rNk/qHUHWAy?=
 =?iso-8859-1?Q?MMWHUFMDaUs9ozCCKtyHxgMP2UZrVY1m52Z6rQavtSzOUJn69ItDY8KZT+?=
 =?iso-8859-1?Q?rIsIi0eDGjgXqATvcvAPG36ZWtsQvdB9wOfiZU11vAmutBtZgslaLaY1Ku?=
 =?iso-8859-1?Q?iGXBk8g878W6I4I1MUqGkmU88+R/JQIifem5Maq/5XHamqCbPIsTY5HCyD?=
 =?iso-8859-1?Q?U8tzdXHW42RCCii5guMzLcd+ieuaMNAM/r6GaWBOH5gysYHklSh2rVLd16?=
 =?iso-8859-1?Q?3nWeI/DeWle95VDkfL5Iea/5h4XhZ7MLtgzhU+VLgi6PtO27EA9KOmwqsG?=
 =?iso-8859-1?Q?l++DhO35KapTSRgeuFGpsXn2i1kQQoafYytEZg7hI4Exg8/jwMmnO6Y8LH?=
 =?iso-8859-1?Q?Yc+tue1+3PtvQ9OsEF8lDGba020pHXj2EtyzOxJ2jRLnQNtwmHTY5wp40n?=
 =?iso-8859-1?Q?1FxeJofdMwwfLBPZCU0igzMYZPgBGTcXnx30FMpcB2NQ/QVrWq5bZIxAKD?=
 =?iso-8859-1?Q?/XNBZrqvNHgw5gddVdGpsETfGDFabg9bdKMBmOPtUMZSirs/hBNo+p7JFB?=
 =?iso-8859-1?Q?wQASVCeEegdJBlBk6I4yYBlgbShDP/qG3xvCmd0iTgzlykuefd2H15ZJO9?=
 =?iso-8859-1?Q?CvvW+8phRsdNIRB5sFUR66kV17TWhpqockE8nhu9x6OkWltOE0FACPtvOZ?=
 =?iso-8859-1?Q?p/hWjTjAmRbQcMwiCPIfTiZ3RUBlkCCGEft/ByAp3fpU2mzFOMQc+ILOCZ?=
 =?iso-8859-1?Q?hqP/LnT2bUGz3wT2dHwzHrJRzYsYhWTl6Q0sEJ5+49pThEMKGorho3fK+M?=
 =?iso-8859-1?Q?JMlm0px43x+n+J0M3EQ1W47EYzIS4sRyFSwbViAMEDGPmyVEyoxJx4Jc+O?=
 =?iso-8859-1?Q?Zj2Vj1/774Kj3rDigbzZe2ypwF6/tVkGX8UrcicBW3G0NzMdHxOWiGJ5Fy?=
 =?iso-8859-1?Q?3rd/AOoh7zE1ldxpYlZxpNP1MAGOKTySa7jFDvzwc5Q/GSAgAZxxGiGfUp?=
 =?iso-8859-1?Q?VdFZQEX0lDn2rHSDwQ5nc2rOfc9gxChT7pwxWjtWo5Hm+1tNpZt/gd5FJB?=
 =?iso-8859-1?Q?W28OGkwcDiYnsAmC9k3Zd3nnFhKcaY4bqfHBX3k30wpJQoPNEo/2SJnucN?=
 =?iso-8859-1?Q?vTQ2KxXFIreiphGyhcGzXy622ozzI3RXjCSL9rsKbuJECwcct/HDkZ/QEt?=
 =?iso-8859-1?Q?ldFYcRr/1uhdetOG9iDsPLxNw1D+TXuNJKt6n+gn2s53mqCrgU6va99Nvk?=
 =?iso-8859-1?Q?B7aY+iWTmIIpCWcFzFZMktbWEMLR4tyr9LXxhnoSmYdA7RnfwIW1K4+ZqC?=
 =?iso-8859-1?Q?4EMHyGrUZ+MehlHKWYBQxt6vJIuPPW4+sPx6eJI8aeYInIYiDESPE0s2RF?=
 =?iso-8859-1?Q?mHvo4uB/2M2eR48MGABcybitMynkyzTjUT5AIDkICSWnUOjuiznDRptPFN?=
 =?iso-8859-1?Q?Ihp2eLw1INqK+SWCBzd8lvrEP+qXt8F2mLWB9zhlvEIOepvCTka5xmSBri?=
 =?iso-8859-1?Q?e+hFsJARsh6KS7SOPv8NWUUq/fcBsaR4P4jUtqL8FxIbjwtbdDMhLhYE01?=
 =?iso-8859-1?Q?3jJ8G3ymUAwCob8nL3BUD1xNQ0sZNz6FP1yjmpT28t8V4nhnVS+0F95jFy?=
 =?iso-8859-1?Q?J/uNC9DGIkBU+nsrUWvtJAd9oRHnld88Qnq75CUuSTmV6fCWGsGgsLBtjR?=
 =?iso-8859-1?Q?9Tp0QSLnZG36OcwfaKTz5xyR6Qc1apjG6+rZk+4jxm/p/RHkIN5d242DbY?=
 =?iso-8859-1?Q?NN9m+bqoQDClgluzNnOCjZekWcSNODIyOXlCMqLiBFXa2d?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078daf56-e203-4519-bbc3-08da144b71d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2022 01:52:28.9901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbanGGS90/26xm0rOazaqiD3tQ5O/p4Nclc6Y47B+29tPx9Zngq11Q4Z3bgpCKOaOBnwvsKHeEauCzag9HMLtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6700
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 0/4] dt-bindings: imx: add nvmem property
>=20
> On Thu, Mar 24, 2022 at 12:11:04PM +0100, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >
> > On Thu, Mar 24, 2022 at 12:20:20PM +0800, Peng Fan (OSS) wrote:
> > > From: Peng Fan <peng.fan@nxp.com>
> > >
> > > To i.MX SoC, there are many variants, such as i.MX8M Plus which
> > > feature 4 A53, GPU, VPU, SDHC, FLEXCAN, FEC, eQOS and etc.
> > > But i.MX8M Plus has many parts, one part may not have FLEXCAN, the
> > > other part may not have eQOS or GPU.
> > > But we use one device tree to support i.MX8MP including its parts,
> > > then we need update device tree to mark the disabled IP status
> "disabled".
> > >
> > > In NXP U-Boot, we hardcoded node path and runtime update device tree
> > > status in U-Boot according to fuse value. But this method is not
> > > scalable and need encoding all the node paths that needs check.
> > >
> > > By introducing nvmem property for each node that needs runtime
> > > update status property accoridng fuse value, we could use one
> > > Bootloader code piece to support all i.MX SoCs.
> > >
> > > The drawback is we need nvmem property for all the nodes which maybe
> > > fused out.
> >
> > I'd rather not have that in an official binding as the syntax is
> > orthogonal to status =3D "..." but the semantic isn't. Also if we want
> > something like that, I'd rather not want to adapt all bindings, but
> > would like to see this being generic enough to be described in a
> > single catch-all binding.
> >
> > I also wonder if it would be nicer to abstract that as something like:
> >
> > 	/ {
> > 		fuse-info {
> > 			compatible =3D "otp-fuse-info";
> >
> > 			flexcan {
> > 				devices =3D <&flexcan1>, <&flexcan2>;
> > 				nvmem-cells =3D <&flexcan_disabled>;
> > 				nvmem-cell-names =3D "disabled";
> > 			};
> >
> > 			m7 {
> > 				....
> > 			};
> > 		};
> > 	};
> >
> > as then the driver evaluating this wouldn't need to iterate over the
> > whole dtb but just over this node. But I'd still keep this private to
> > the bootloader and not describe it in the generic binding.
>=20
> There's been discussions (under the system DT umbrella mostly) about
> bindings for peripheral enable/disable control/status. Most of the time i=
t is in
> context of device assignment to secure/non-secure world or partitions in =
a
> system (via a partitioning hypervisor).
>=20
> This feels like the same thing and could use the same binding. But someon=
e
> has to take into account all the uses and come up with something. One off
> solutions are a NAK.

Loop Stefano.

Per my understanding, system device tree is not a runtime generated device
tree, in case I am wrong.

To i.MX, one SoC has many different parts, one kind part may not have
VPU, another part may not have GPU, another part may be a full feature
one. We have a device tree for the full feature one, but we not wanna
introduce other static device tree files for non-full feature parts.

So we let bootloader to runtime setting status of a device node according
to fuse info that read out by bootloader at runtime.

I think my case is different with system device tree, and maybe NXP i.MX
specific. So I would introduce a vendor compatible node, following Uwe's
suggestion. We Just need such binding doc and device node in Linux kernel
tree. The code to scan this node is in U-Boot.

/ {
 		fuse-info {
 			compatible =3D "fsl,otp-fuse-info";

 			flexcan {
 				devices =3D <&flexcan1>, <&flexcan2>;
 				nvmem-cells =3D <&flexcan_disabled>;
 				nvmem-cell-names =3D "disabled";
 			};

 			m7 {
 				....
 			};
		};
	};

Thanks,
Peng.

>=20
> Rob
