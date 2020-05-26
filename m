Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FEC1E1911
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgEZB0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:26:05 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:37861
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387888AbgEZB0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 21:26:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esFHdHWaYapKCx2dNhqW0+zHMMG7OAfW3oFjFUoY8fzdg7s+kTBWBJvV+4C9RxVwE0ckvOVW3Txtf1T9ovAnYmYsk4A+VXezfOjIfR8Nv3J1LsO2RxGi0/mL2kMgp4fMPogJ7Fe4P1zlUbTuXstBcLUgOeSq3Q+Oj86BFzOqxbRxdWXlmvdYEOjJJi6D3/T3pmzD7Ll0t19VVsD+FoZdz7ZxUHE5HZad/JyeaSYX1PvlTcZx87N/Lgmccpid+mYbqaNqtS3V9DW/HvqiCYc9TOMy+Uw/neHC+rCfH3RmKeGOqmW9BzSANxQb9T5CBcjNMkgEoYKLAJAfYcEI8k4Ldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sA7j34R/4a/ZqsZ4VouzlDCvotN7rO+WGUEhboHa98=;
 b=jC/1gHFMtNfz3P0qC8IaGh/qH/SfQpwG55Ul6VrMNkqlZw9Ihx8FTGbbJXPNKpk1OUp1X9ewXBddGz7ztX5rQ3vTpU5AzSxRkdMDx0w+kjj7AyNw3I1mGo2ffx4BxGYnCTaeoYdKzBvRnLDdgXNiOiZ922CT1N63K6M0T8RfSahwNpBBoC91s50lOO4bD1sCjfrY5xKUy/jn1QyT6LB/M68Tzp8u40I+gxzrer90VK7rnzTGOCOgSY6loakx7DdoC3Sgb2sYoXDgDILVrwWxBreNzrb6xgaZgqVBbk39P/vEpKFoXAdo+9k4VM6OTs81K3g+OFrQtRoQVlP67UcWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sA7j34R/4a/ZqsZ4VouzlDCvotN7rO+WGUEhboHa98=;
 b=KBhDQAXJByQknzED0zDOczcHzN741oqGliohnPZo8LOydDXLdBcWTbkDMlzMv6DNUeCOfkEv2iED7enfFHI6rLLnWQUZmVkb5RYXvW4QMvjlgo32DljVy4A8ztFik/rrqLdYhyTIITNwaj5zJoqQMnEU6CrgER2I3F/yIoOK9Cg=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3846.eurprd04.prod.outlook.com
 (2603:10a6:209:18::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 01:26:02 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 01:26:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH net 1/2] net: ethernet: dwmac: add Ethernet glue
 logic for NXP imx8 chip
Thread-Topic: [EXT] Re: [PATCH net 1/2] net: ethernet: dwmac: add Ethernet
 glue logic for NXP imx8 chip
Thread-Index: AQHWMoAaeIGICg7st0GgTA/0z5mM6ai5kKyAgAADSdA=
Date:   Tue, 26 May 2020 01:26:01 +0000
Message-ID: <AM6PR0402MB3607B8911CFDDE4E3E0EF0B3FFB00@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1590402554-13175-1-git-send-email-fugang.duan@nxp.com>
        <1590402554-13175-2-git-send-email-fugang.duan@nxp.com>
 <20200525.181317.1216905484376882401.davem@davemloft.net>
In-Reply-To: <20200525.181317.1216905484376882401.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11578fdb-79d2-4cb1-bd03-08d80113c095
x-ms-traffictypediagnostic: AM6PR0402MB3846:
x-microsoft-antispam-prvs: <AM6PR0402MB38462D6CFFEBE3A5112EA105FFB00@AM6PR0402MB3846.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 041517DFAB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mW1WSU9jQdDGd8bhHpfDmFi6qvvz9miUrOYPlj1BTrx2elSZXbI3xqFpFMuR96YRJaVxIf52Q8LgduAPg1gJCEGFRkbc6zcvALUN15L6bUZCoXiyOGZ2HMbLvFc0Y/cVgYx8sYJ7rWeDmcqNj0T9cXtf4rCgPS4EHDNPpv/nnbIlW7+3ipIEQlvjxR8qFgWeNt5C7UPl1C+POdk3mJPQhdxleqHyeZXD2KVVjjjBml8cJgyNziClwUk20gu1DC7Y67E/WfNUoGQ8VgNu4ARgcc0d0bfgaE4q9ZYN77VzyLnyFM9OA/C1+lXlVyTXWL97Iyc0mGxW9mUqgs00ExCJAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(9686003)(4326008)(55016002)(71200400001)(54906003)(316002)(6506007)(2906002)(7696005)(86362001)(4744005)(5660300002)(186003)(26005)(66446008)(66946007)(52536014)(66476007)(76116006)(7416002)(478600001)(66556008)(64756008)(33656002)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 09v0PEY2OBmgxbYe+ek2wUzj88M83VDArVKtEAk7ofzL1I6W3LnotkBxosSegRZkOhmmWwbF5Pt1k2e87lJqG+/GPXFcNrGmB8c+hh6SxJcT17PNUzd0/C+/6/DgeTEZ71TZlNUEOAr1RtQ2sRcUbnZgz+CmHASabEA3eJMsRtnVhLw3jP9/e0C/iyYov3nsGVJzQc1e7AmQv92wvSKmxdHDx6Vn8I2ChQkxo18FDhUM9nDO5ub8uWpx4NlUbsi1DvpsbI7fj+tyMOn0VmhlYCPnM5r3cVYBMadM3SwM7cZFNdLjyBozGTVPMQjQU0xWBKChALiTk1b4w014PHb8MqQABD3iuiIsAJrrjFGcOAPYeJj6YB4o70ZYCLurx9Dh8COMRW/TWDsQcl2/Q3SJ0khmGMahANkutP8KIG8vHu4PMy1Wky3s3poJCtsiYpBu6JMl0ex1dTUtx/llseuEAGdfUYw+fMrbSq8Gt5RTCrhY8Jsqzz2XnjNlBatOL69m
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11578fdb-79d2-4cb1-bd03-08d80113c095
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2020 01:26:01.9180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkj/2LDqkU0Gp7PQWnEetD7bAU00ONhQ52noTlL954cg+L3Ekf3LzFJ+6kuHA1TGjpfWEvpiHr5amagbovmBQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Tuesday, May 26, 2020 9:13 A=
M
> From: Fugang Duan <fugang.duan@nxp.com>
> Date: Mon, 25 May 2020 18:29:13 +0800
>=20
> > +static int imx_dwmac_init(struct platform_device *pdev, void *priv) {
> > +     struct imx_priv_data *dwmac =3D priv;
> > +     struct plat_stmmacenet_data *plat_dat =3D dwmac->plat_dat;
> > +     int ret;
> > +
>=20
> Please code these sequences as:
>=20
>         struct plat_stmmacenet_data *plat_dat;
>         struct imx_priv_data *dwmac =3D priv;
>         int ret;
>=20
>         plat_dat =3D dwmac->plat_dat;
>=20
> In order to have reverse christmas three local variable ordering.
>=20
> THank you.

Thanks, David.
I will update the change in v2.

Andy
