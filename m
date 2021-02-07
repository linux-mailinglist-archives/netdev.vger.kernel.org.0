Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF44C312445
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 13:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBGMWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 07:22:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhBGMWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 07:22:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117CBnkM005124;
        Sun, 7 Feb 2021 04:21:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=e157QmSF+Ommf3V4h3Hf/yp0Im5FbIiKZoaL9ZMtVp0=;
 b=cdx+QXJzkWpi34YxSME0HWOacEEdZ6i/ICIhfmSUaUjw3mxpMGaVZHQ0YxH9kshqYNCo
 Wjc761gk7vJ3mm5n/VKrkRji6aW++BBqhR2nfgV9eV+UfXET2d+wubZgiKBlinyIFCUU
 7qgrNMHzlpPtDVEek0h0FUEPJaCAEk7nFnKFCdRrVnuwOpcXR6g1V5rs0XqfXEC/A+8E
 yAzdI/oOzc/Z5tWoDPCb6pPHyurYX1XMct7LMjDfl8X7oKP/TbbQuAoO/OUE2cnMc5V9
 JVUEWR4l5emYnJclv3Zuk9TzxHExfUAZiHsrF5kGkH67imxwRLU9ccx8wLHWKR2cq0gu zQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq1y43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 04:21:47 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 04:21:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 04:21:45 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 04:21:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq8l3PIyTFGyeFGssNHdEBp2yhFO63f4Vufwg5aFnUe4rkZmF/soclO9wmztN4jccKyWIcBFGIkwujtZBNFfhW+dqwZgwQvNZAV+meReyaiOLbBGzmTvkKpFf7ZJeQH0NX6tOWWXoQEVCVzBaKKuYgdg7PsgBgKY0rklyQelppsh73n2QPs86FYT7aUVZKzSuJXM5LWjOmBsnopMymXmjiVQh7mdiWeJDW+Y1U/T5dwX2wETV3kUnkMBGw31QfJeuwF3kLLbB9ZAySgkdlmpsnix8apJ40BJ0M/ZanmTtRPiijWBGxa1lHKg5qTatbY5WYW7XYvDMZAzV8uh1otYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e157QmSF+Ommf3V4h3Hf/yp0Im5FbIiKZoaL9ZMtVp0=;
 b=GBJ7UZENJ/gM7JvzoYrAjZbfrgaIioV7ffY0Dt7GbTcdAWmdBdhnq1mDw1MhB+u/Z1I1VnpN0GOFCH3BX/xQbzqYOyzaU8aAyHRMIDk3efy3n5xI2hMkVyNpKZI9yJ7mQC6Z1r3eXwiPd7Z5pYo6IIsie2oDdyc6TdvlhSkleBf7xA+nR9NQSldxYBwzmXpVTaOSOMsBDpNuBlUR5+W+M9qhpYeqjJ++OOsdgPH6cCclW/FC2vyXFXQs6V8tPshBdvuC31BF/Ext9leHOoSGBfzLAv6umHLikuFrS9jqYIoaOknL4Ik7cgLGcv9i/e1lsGg6LdMXtdVNOH8crIONuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e157QmSF+Ommf3V4h3Hf/yp0Im5FbIiKZoaL9ZMtVp0=;
 b=J3BfAqvk8KIvJ1mrKYryM2wLXb/8+r6HszxLSifTh61sxgK1wZ8nEiGGr6V5hxsFCLNfnKe9/DiVh+hETqm8ne1v5OgREP/ujqDLLI9DJ6CirSGCZ0YRgLJ9j4m4XFjQN07xp5LsJh2zCrdquCuTRJPrUFoqaSaXt3Ns8ONAdUU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3905.namprd18.prod.outlook.com (2603:10b6:5:346::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Sun, 7 Feb
 2021 12:21:43 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 12:21:43 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Baruch Siach <baruch@tkos.co.il>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Yan Markman <ymarkman@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Nadav Haklai <nadavh@marvell.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3
 SRAM memory map
Thread-Topic: [EXT] Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3
 SRAM memory map
Thread-Index: AQHW/SobMD3vDu1MAkO+p8Aai21QfKpMgmUAgAAZ2bA=
Date:   Sun, 7 Feb 2021 12:21:42 +0000
Message-ID: <CO6PR18MB38731B7D025AE9202104E707B0B09@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
 <1612685964-21890-4-git-send-email-stefanc@marvell.com>
 <87mtwgxik1.fsf@tarshish>
In-Reply-To: <87mtwgxik1.fsf@tarshish>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: tkos.co.il; dkim=none (message not signed)
 header.d=none;tkos.co.il; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d52fa8bf-a998-4958-76d6-08d8cb62edde
x-ms-traffictypediagnostic: CO6PR18MB3905:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3905830C29A9081371254AC0B0B09@CO6PR18MB3905.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oW9F7OweMC8SqGtgeHsmdb1VXAYVhKHr2Y90Yr3HM97oXLGMu9Wdkvvo+xG4QU/a3MUskIlv+XIPuouB0GXMzmtyfnUIE51JYo6eWyh6Fthw+zRrZASKT9/T0qCTDPtXrY3+CUUhAmE+2BJyjOC0waRE8bROr48lGCR1JjqTUsMJzspb/j5GAxQQdI7wEcO8tdxA94qtmmxVCDiB5L/no042ZP6/XytLkL3rTiW4rsvp7PYji6MG9wo2zxuA8ww8VV8HWe2a7s6/JAPRLUBIFQVwpdNTlg7s5L7nIui0v+uEV6oMqnp+GsrYGfa6B1y27Hl/XXhvjXMM9sKhhHFs3Bh38LubS99cAda/zrXBIkYpE7ZgJKYiAFTrF+4F4w3T0AHatc/Vd+PRmWHloYyiAl5TMn4RHLgd9YF9D23x69be1GNrGeX2AodZfqUL5WYReOO3vM1uzUiLahuTHs46Ug/15MyjFo847q1zoO7kbhpFvvJf55PW8mppUpUeBO5VLc10pfq6VVqzNXGReyx1lA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(346002)(366004)(2906002)(83380400001)(316002)(71200400001)(33656002)(54906003)(86362001)(76116006)(8676002)(55016002)(186003)(7416002)(66446008)(9686003)(66556008)(66476007)(64756008)(26005)(66946007)(6506007)(7696005)(5660300002)(478600001)(6916009)(52536014)(4326008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GoY/Uro7L7Miz7mPm12y1hiDMOuMBxFMmlEQO2HEr2+RPYE2FBEBFDCViIEu?=
 =?us-ascii?Q?gu7FY/GJnmgS/h/uuCLXC5fAu0zk11ZMaYidkfPLIGTqyGGehF9VLULsFw4K?=
 =?us-ascii?Q?5WNCcK3dEMXuMY3AFyRsKhFQJhqNPcJXYD8gS6fijqkbo9pMYrdKyOU/PSMf?=
 =?us-ascii?Q?p+UQRsYM08KPRrzsFp/ERLGp84gPas4ez6OT9BgfTdZK+mvb8I6LoBZOdHIq?=
 =?us-ascii?Q?yq8kZ2GaruYfo/LrTqRWfnq3iCkgptiSLSxcIohMxxT7LNRXb6z2R5QsOIaY?=
 =?us-ascii?Q?DuhbyA9vCi8aydjrijT0fg3KnHZrYzQqXkoIFDh31ZSl6HfXRXoU85uYktJF?=
 =?us-ascii?Q?K3IGD0qW97Sb5+MlWVEV7ISG004KAWTjg9EG30YPvp0QGQ8KvwJHHcd23kLd?=
 =?us-ascii?Q?b5sUznQUOyGQ5c0BDoiD7mPmarj7b0+zniVByP+mCIU1ygMwH1gqkmOjaaMV?=
 =?us-ascii?Q?PtTwt83q4T/s9CUMVvM+Yv6bJuf2BDi/OzAqbnN23RnNADOTddx0h1L3i2aL?=
 =?us-ascii?Q?AjdeJh199qaRaCtBZMoe+dtEivJJY6ZwqNM/PoQ6hQ+n9vHHGrqQRXTkHFMP?=
 =?us-ascii?Q?BvsXooHmPSRdoAR9FrCQhmRW3qPxSFYG0y18kb9UdNuwXuJo1fH3JZbgDQQR?=
 =?us-ascii?Q?SKNhMLJ8mPqA853u1R2KKyrOIh3cIcVF28Pv1D9NbYbFto5uhvLxT1ROgODG?=
 =?us-ascii?Q?qyYZv1+ZKUjuLcZIRlg6fyhHo+/xA6GwaqnF0YkaxHhs6OBlVxwX6UxYEaac?=
 =?us-ascii?Q?9rKHnCHp4spCFMS7xj0S1WhI0KiN1/iFIEmnB10qv1x9IdvALGfAZ68WGMLX?=
 =?us-ascii?Q?oDa6WnuOpPOTqW5D9seFMO3c83SOaBxt6h2cSozQldZ1woF+fbpSDX3eISPl?=
 =?us-ascii?Q?y5N/XiGBckIlmCfRmOVl+S7B65I5RcGLGEGT5jcMtIiNFQQKWf7WPg3ACC6F?=
 =?us-ascii?Q?VSFy8OQ7yz3qo56Z39MJWX9hB3yqdnbrdEyXMowLU92IcuEjQlz7+Ay2PCFk?=
 =?us-ascii?Q?aIKUnX06OfEGVIHNA4hW0GmBXmM23lh+OJAECBwgquHhYyix0nFN8EsfG5dX?=
 =?us-ascii?Q?IPOrbw7yUshjvMaIxwZZNtp1WIJ+alIpirbeQNuk/DZTFXkv0zSec7sicGZ0?=
 =?us-ascii?Q?81+cfAfl2gP8ATsT1HXk+f+Pc9EpFdW5RN9pvhgsMAEQLD3Rw//AXwoLgLDS?=
 =?us-ascii?Q?NNaZhC/U+TGQFrMkZSuOLW4YHh6fpVKteIORvtzw+hX6KsvAz9lDrlX/Z01V?=
 =?us-ascii?Q?AKwARi9OF+JpvFFcBmr0KXuSlhDj53QeVCV+ZfNBsuRSAm3pVRtTOL3/+LAW?=
 =?us-ascii?Q?OYM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52fa8bf-a998-4958-76d6-08d8cb62edde
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 12:21:42.9942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUOlGmK7FuTwqzd2VkTFRcCdQTW6Mj3TG0Sy9F+PLfxFwytDC+VpQZhXSZ1PV+Loc7snVHxHRs/qx3lOw0nQpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3905
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_06:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  }
> >
> > +static int mvpp2_get_sram(struct platform_device *pdev,
> > +			  struct mvpp2 *priv)
> > +{
> > +	struct device_node *dn =3D pdev->dev.of_node;
> > +	static bool defer_once;
> > +	struct resource *res;
> > +
> > +	if (has_acpi_companion(&pdev->dev)) {
> > +		res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
> > +		if (!res) {
> > +			dev_warn(&pdev->dev, "ACPI is too old, Flow control
> not supported\n");
> > +			return 0;
> > +		}
> > +		priv->cm3_base =3D devm_ioremap_resource(&pdev->dev,
> res);
> > +		if (IS_ERR(priv->cm3_base))
> > +			return PTR_ERR(priv->cm3_base);
> > +	} else {
> > +		priv->sram_pool =3D of_gen_pool_get(dn, "cm3-mem", 0);
> > +		if (!priv->sram_pool) {
> > +			if (!defer_once) {
> > +				defer_once =3D true;
> > +				/* Try defer once */
> > +				return -EPROBE_DEFER;
> > +			}
> > +			dev_warn(&pdev->dev, "DT is too old, Flow control
> not
> > +supported\n");
>=20
> This warning will show on every DT system with no cm3-mem property,
> right?
>=20

All DT system would has cm3-mem property if " add CM3 SRAM memory to cp11x =
ethernet device tree " patch applied.
This is also only warning message, without any functional impact.

Regards,
Stefan.=20
