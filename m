Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C44587AC
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhKVBH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:58 -0500
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:54525
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238774AbhKVBHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 20:07:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R73kVdSG1zocuTABpXKWvs9tEufJVziA/2I8D95pZE2rkJgItpJTLa83SM2P8WYXnFhRg1DBn1pigkUQeFLwLXiPHk/x8dSX+du/WKbW/XFAUT5fSjGZ/6sNoC26pHDYsaMIlj95dqe7aGkA8G1j8hzs9qKeCRcn4tHafUZd1/tmuDMbsFRuTrSWv1gJRPny6zcyC6+r1UvnRfG/ICAE2VrV0fChuw9cSN8tO28dv6Bp3BxvT8FtQM2Oj6TWBQ10vVMn98XqZH505S1M3m9ADHKK3YxnvO7W9s1TdTPqOkGNMo7JqhG+wf5XkmkkYX6wg2+0AwZaJkL3318ZHlA+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0OZHNqPFdCuaVHP5lWao4K8DPErne5MzjIUKlPshkE=;
 b=iyU9+S+GRx2r04BEA3rjOsqOrDTYcv89LKrswjzrTJyiiawSC18le5BxQqEELfzRCdIq6dwhCDBmuiwtVIkuR9rqhcGMN/h9f0PrA+DQoTJ/77HnEN3fsNvIosb3v7KAtLZRTNEGVIHB8gDRs3HZCKu3ddQ1V8ay2QIKcr0hpvryXCZQj/Cr9SM6sivQeEOKZGB+VxWiz1XYZBnjcTGFhwZZ179HoM9DTpl1f91QYNQ5StmR4bFUc359w8RCLgaY3KP5effEJYXLlRQ0Nzqjwbd9dzdssYjLbAjdcoGkq3VpVW4m8d76fpwNVzzWG+pQxPe/3GNQhyi+QTZRrpKXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0OZHNqPFdCuaVHP5lWao4K8DPErne5MzjIUKlPshkE=;
 b=P5c69YzZI04nxPoojKMU+Wh2KkDopUexea0Y9gHLH/a7lzaFc+cUX/Y2VVHc0F4C+uClKVCQOwQ/pJi2GrIE3WrvhcVcRDqHGFYJVZfnjhH57LfzRvtm1wagLhOKgtYgGwsC03qT8DSFjgCHSNiP69xkJerXf0YWa6EDLLUS4HM=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9129.eurprd04.prod.outlook.com (2603:10a6:10:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Mon, 22 Nov
 2021 01:04:23 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 01:04:23 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Thread-Topic: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Thread-Index: AQHX3gYWa6hR5mqzLUWfsAuyvlR+A6wMidaAgAIziwA=
Date:   Mon, 22 Nov 2021 01:04:23 +0000
Message-ID: <DU0PR04MB941710123952E0D448A1B38E889F9@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-5-peng.fan@oss.nxp.com> <YZkTkagrQ/zafYEQ@lunn.ch>
In-Reply-To: <YZkTkagrQ/zafYEQ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a225cdf-a71b-4bb1-b6e2-08d9ad5405f4
x-ms-traffictypediagnostic: DU2PR04MB9129:
x-microsoft-antispam-prvs: <DU2PR04MB9129AD7BD48AAC06C66A4357889F9@DU2PR04MB9129.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u296s2L0/d3BH0d3mfUKd4YJehJ2IQiKPm20QN0XHWXd9ZFZp2a8ICMD/bF0IsJHizIb7hmqFQYUG2cHdfP3Txx/M3rzOW2VnouOD8krMc+RcwAJOE/xnfY2PInsagZmPJGOpKNUxBtMOP3u/luyNX3+H5CgEEAR0BrqDPop7R8F8DCr1QQSsGz4djnZmLYEoIiB2hAR792iy9J+R82Y8V5SYj+rt9aHLtNdUSLGTeq9QKoMa/+gwSlUpd+8e5lSUN+RtwxWyPmW0/OFsQy6kdCWv04RzfGdLqozkVnLmS3sc9MMdFWj3hr1bgdTCR3p+AC9f/gIoIlMg16KXkvGUP+xgLeY9MuIYYN7jd9+ERrUslcb+ejpZZHKRwi99Qsx9I67/jtst+99EAkoeukqZNVrdgqny+cS/8m+DlPlq3/Z56QrOv72CEYTWgpkrRDAqLdifRilTTHDHGcobp5/4wWC46uR/OvyJ61sfKqveFnrI5c3V+eypZI9yUidp3994XOr7DvQ9heoSgopE55yl3u/msyjLznpu+/0q/QTBq4oKe5Tm4ti4lDAE7Ol77kOwOqQu6JHpCadYw7Hzuc4NPKBssxAqq9XS0j1hz9HndwqyIf6lFWmn0InAbKSVY/o3btxjhGV5VIVaR/El7oz2jPJZ5UjzEzsk2PQ50417wv2HqrV7SYa1Tn78nZCvdvBrZ9cyOv+PG4dGos9lmhzK3KMno1khEQdy/XhhowAQFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(44832011)(4744005)(4326008)(52536014)(7696005)(5660300002)(9686003)(316002)(7416002)(8676002)(86362001)(66476007)(54906003)(38100700002)(2906002)(55016002)(71200400001)(66446008)(64756008)(76116006)(38070700005)(8936002)(66556008)(66946007)(186003)(6506007)(110136005)(122000001)(508600001)(83380400001)(26005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yELqUUYIaf/zi20gSmmjw9SNGWuZERlvFPJIPXdI6JDhbU+X2WIv2TMrvhVE?=
 =?us-ascii?Q?G1M+rWsncGyxOKUZMkKfqG409Xn2z1bvXfpLeEB/9+csgiyCDdl+r6kaPhax?=
 =?us-ascii?Q?njp81F7nM6/+/HJlDbuaJmG62AeLxIqkeZs1JSPKJdfiQ8eXgrQuCPc+jSKK?=
 =?us-ascii?Q?dccJMXZVX1VqUKwwqCC+sR+E/rQL55kZGNqMBJu9KsIsiFa9hTs4AKFdf7K3?=
 =?us-ascii?Q?S6raig/H/w+GPC5v+GfxC4L+O9yAl09fQ2FOChrSQdqimb5sjM2bq1K6dXIa?=
 =?us-ascii?Q?K1GQksKHLG5TuLbriX51QVpaHuzwefjfolyGRz6RFeIaRa58z3QM0iKk0v84?=
 =?us-ascii?Q?fnHW7NbS4Utd1Ciu6i6vJojfRqF4IbFgmzeomz+PIFD399GdowIQIX26VS4H?=
 =?us-ascii?Q?x7ilXPPhphvklahDFUwh5DLEx/jUBts2g6yTcI0sxHnCA/B977ytJ4l1HvWq?=
 =?us-ascii?Q?Tnh9Kdym2GGv3+SvJWR3ofmt2Hj0NQvcj8IHNnoOEGvtGttndygzB0MBZ/eh?=
 =?us-ascii?Q?0m6tNLZF3LodYapcUNZZzKxo6caQqsehZ4pexVGU3As8JsLr5rESIWMR1n6F?=
 =?us-ascii?Q?TbfaEEbbQR7XJLrcBYzibvKDeNfscMGx4TcmwMXzxf1V+jeOQXAN9SPI2pak?=
 =?us-ascii?Q?R5l8FzK0U1R6nfq2DmL1gx6nw5wA7acPJd21tGrqme3s/ZpuMPgSlCGQMEdo?=
 =?us-ascii?Q?4vyGaujOM/osGNxkaSxpuwo3nONjFMuKs7+CVA+CjS/m/RuR8KNDSOM2QHeG?=
 =?us-ascii?Q?iWVteT4azbRp5FLr2Qp+koRTtmyJweHPGggtGA5KecbsOwyv0QY2r5PBLz8l?=
 =?us-ascii?Q?VS4De18Z28AjqtblScwcLADyCQqXrfuQDxkYGufyfll0cTfKqy2UA0b6vfaE?=
 =?us-ascii?Q?eYdrZPuI1iDv2ZV53+b17VWeRskG1VgTa7lQktDdebNgqWLzWJjvK8R7WSV8?=
 =?us-ascii?Q?PT1ZcbOdru7O1lsXtu4MIu5QeVqXaUO8OhNkpMeZ8zVtArbiI0l0uyxQdr5v?=
 =?us-ascii?Q?zOLSzHhMn+7DcbUTaa1sWbGRGyqalx4brUCINeziqW6RCbDNVpJiQS3aTyF4?=
 =?us-ascii?Q?Zuej/rjLMuqCru0Fi8t3sVHXxkKbPMCFv7fZ1acEDuABGNsKUG1jUvli/5PL?=
 =?us-ascii?Q?6Fe2Ld8FFkQBDdkR/Y+qBsUepWlI5GoQmEJG+cIlMiEt57DfGmPPU17+LI0t?=
 =?us-ascii?Q?sA0w40J7lma+/dcM2onqpZb1QmVwYP/qwOxxyHAP/IDO8CweRgwd4qoJRLNR?=
 =?us-ascii?Q?jos0wDo4AEZCHuLKo5cmTy+P9insHnOmEEIYofGoIE/IG0BIkkOg4+KqZHXy?=
 =?us-ascii?Q?hJhIoiFK0SrOwMbZjjgMGwPj7H3kwNeCGzNpX8KeCZG6pJMYy/3cK5l74Xa5?=
 =?us-ascii?Q?ahHcLzvQ6Z1C0xnk4FWc4H25hlcpfPPnDBhlsCZe/EkkyflWEYW61Vz4+e8n?=
 =?us-ascii?Q?i2cJYR9TGAh3t+wBVjjXQ3EC0C5e7LISRC69h6NNyONBz/zbYN9CRUOXsBw3?=
 =?us-ascii?Q?oxIkThZ9IKEDAXZe4DJtHRfzufr47oE5JskC/JMz8XuiHF4xAx1sFVvy0igJ?=
 =?us-ascii?Q?SbGVcu+UALp9LlNEbr2lXHl0ygvZAK4gaeZf4wwvk6lIcH2yGZ54zfz78tjn?=
 =?us-ascii?Q?tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a225cdf-a71b-4bb1-b6e2-08d9ad5405f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 01:04:23.7461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUbUeEbvKuIcxRwl1JPYiaNtWgPvzq24X0ngv98h1mhXf13cbiJGsJ4hLrO9C2+7xIeH7fAxrgyABPsE4MTz+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
>=20
> > +&fec {
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&pinctrl_enet>;
> > +	phy-mode =3D "rmii";
>=20
> Is this really a Fast Ethernet? Not 1G?

Not 1G. it only support 10M/100M ethernet.

>=20
> > +	phy-handle =3D <&ethphy>;
> > +	status =3D "okay";
> > +
> > +	mdio {
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <0>;
> > +
> > +		ethphy: ethernet-phy {
> > +			reg =3D <1>;
>=20
> I'm surprised this does not give warnings from the DTS tools. There is a =
reg
> value, so it should be ethernet-phy@1

I not see warning per my build:
"
*** Default configuration is based on 'defconfig'
#
# No change to .config
#
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  DTC     arch/arm64/boot/dts/freescale/imx8ulp-evk.dtb
"
Anyway I will check and fix if the node needs a fix.

Thanks,
Peng

>=20
>   Andrew
