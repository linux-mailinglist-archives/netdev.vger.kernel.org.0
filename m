Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81DE1826AA
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 02:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgCLBZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 21:25:02 -0400
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:56033
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387480AbgCLBZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 21:25:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9M8LPT607URRN11kRGEUsve9WFY8n2VN4juGywlDxl+oK7YlmfWMpu7W361FbkDk7EMhGVxLQEs5txDkKDaIdmDn6Mqet6PhPhWJ7mPcwOWS7wtb3sO89qszHiOU8OmaisGlL6fptwC6jON7e92qBVAu9qfmzbq876OrXzFOVhGkPHkBSPsLTlItIqA4NovzTrnBp2JZWsUtrLu4Y46XaZXR0XVg2wWgb75TKOJKMjos2eIz+u6DBqJinar7flt9Th02oi4n4eiUIIuwcKstUq3bBKKatst6+tM4lQEJv8rEP69KQOSl5kJYmhKwGy78M0X5st1kJJsVrasC6MNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEGdhNmSga+6lR7FVE3QIOYmc0QQSGj+LlUQLgJc1ME=;
 b=UcKNBpCEEfeWffbntMuAZtu0c4g/Gv9v7rDCpiaFxBbmtTZJqEBDG8hftRyF6fakAvWu6ZCgmTQFa8XaxsGC6PgyA3aP8UrwjIVAHegI/u99qblDkaAL5D8/ZpcvIv1NsYgsAJJ4lL2U052KE5dPqCyLvu9U30IcQpPCNuesIM6nEj4pFfM4fJhaxF/G1HEyXYpjSfRqVTsC85p9TwFRue+VNy+Gexu5KwHcCLHRyByJvbZ9EVC66Bl91J0BifjXWVfHuditKLxy8tAs7DMvZIAppZvuM12fyjLOv9sW4Q9OQGYhyMJb8/++QU8h00U4cOU8GZPEhiGG+6AO3hLw/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEGdhNmSga+6lR7FVE3QIOYmc0QQSGj+LlUQLgJc1ME=;
 b=bHXQHfrcSksL0C6ATBr8hoVxb0F+4S7v5tyHsP6Lg8MpOWdKvYrLnXWPWxXwea+3zUo2+G9F1T9xvK3sR+A3qEkYeJLYF8N4r8Gfo3IJSPVIREqaQO+zE4KoSG9mW82srsYFyHC8Fj1GybKa9ss+e/onsS0CYsufeYJNmxSDyxQ=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2864.eurprd04.prod.outlook.com (10.175.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 01:24:57 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 01:24:57 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "sathya.perla@broadcom.com" <sathya.perla@broadcom.com>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>
Subject: RE: [EXT] [PATCH net-next 03/15] net: fec: reject unsupported
 coalescing params
Thread-Topic: [EXT] [PATCH net-next 03/15] net: fec: reject unsupported
 coalescing params
Thread-Index: AQHV9/UODLqcvbJJh0mrKhiZWtyruqhEKflQ
Date:   Thu, 12 Mar 2020 01:24:57 +0000
Message-ID: <VI1PR0402MB3600AE1A8DE69790666F2950FFFD0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200311223302.2171564-1-kuba@kernel.org>
 <20200311223302.2171564-4-kuba@kernel.org>
In-Reply-To: <20200311223302.2171564-4-kuba@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54a05340-d767-485c-6ac5-08d7c6242d4d
x-ms-traffictypediagnostic: VI1PR0402MB2864:|VI1PR0402MB2864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB286439AD8C19DBB2981F7BFCFFFD0@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:357;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(110136005)(52536014)(9686003)(186003)(66556008)(5660300002)(64756008)(26005)(7696005)(4326008)(86362001)(76116006)(7416002)(66476007)(66446008)(33656002)(66946007)(316002)(54906003)(2906002)(478600001)(55016002)(71200400001)(8936002)(81156014)(8676002)(6506007)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2864;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bP8JEUsWvn6r7vNlC5hsz6pFuYpYm6vPCWPAeyFT04Ll42JIf6326IgVkjAaUDsfO5BYB6tlOw4wzgArCUWIByHP0Qm+kam0vxVZqqsGRO8cL/6D9L69RDs2ibuJV8Q9HdFqKhYl9o5wFtHXfDTQs1z+KtgHHRWeeobYmZ0OxdFW38nbIoDbh7FVYXtn15Vv2S3/rvl8PKCz+njxAeF6e8EYTpsBPuemYnMb+QVTx2j/t8DXVBlbOLN1mKE01tloDTRXEaRkSFmCheQXb1FY3mtV71UkxnyZWfGNCXniDFlmcWJHbY9QHtfEbfdLYz83Vi6qW+ZBhmfDHEh5dRQsXGT201lMtQ9Grqdy+GK24xgzCDjYJJ68ffKiypuY+zD0rNThm6vQIbkzDD1GAYSh/xpY4DOIWWYwKzzMTK2t2l54gR1Mtcxf6HjuE+8k1YMU
x-ms-exchange-antispam-messagedata: TDOHdbv8ll/RDRpb1LVyKDRSd1WQoUDjKPPZq/WT+KH3SSwHDEBw6zn3a8UTu9mKX54rKaaTE5cn9Unyt+RR2WZ0FV1Cn4xCRSQ78EdBr1I/JtPOI7yLCt+RCzn9lgU13RdfRdF7B+RH+hw+l3vYUw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a05340-d767-485c-6ac5-08d7c6242d4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 01:24:57.6315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnZBO/oQztrWESmPvtzHjMSBeNclnmHw6TO+sSfY0Im64E+alzto+0GXNQMNDj4LeXsbUdFWL6iDERC9mEkd9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org> Sent: Thursday, March 12, 2020 6:33 =
AM
> Set ethtool_ops->supported_coalesce_params to let the core reject
> unsupported coalescing parameters.
>=20
> This driver did not previously reject unsupported parameters.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index af7653e341f2..ce154695f67c 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2641,6 +2641,8 @@ fec_enet_set_wol(struct net_device *ndev, struct
> ethtool_wolinfo *wol)  }
>=20
>  static const struct ethtool_ops fec_enet_ethtool_ops =3D {
> +       .supported_coalesce_params =3D ETHTOOL_COALESCE_USECS |
> +
> ETHTOOL_COALESCE_MAX_FRAMES,
>         .get_drvinfo            =3D fec_enet_get_drvinfo,
>         .get_regs_len           =3D fec_enet_get_regs_len,
>         .get_regs               =3D fec_enet_get_regs,
> --
> 2.24.1

