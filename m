Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE11121EF
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 04:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLDD74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 22:59:56 -0500
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:6216
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726804AbfLDD7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 22:59:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6XIA0tNkiwrPS3UBDbhW5c4VZFnmgzyVN4niX0jxXqNw/gXpp/8fMtzbc/CkKErOZAsVXxsx3WETqlOQHORfkZcFLb5hhTmuGoKr0xF1PyHwWtsWl3BjNa7jInJlK/Ie4pJ5h7w+F9++wmAH1ICTeaZfbwtcxdJHr626ejrEBinFlS99pfEP5fTB8BxQtjk+/xjfV+a8vpIBwUC0XkunK9cu3T3a+3AmveAUeza2xkOYubb2dcPBZtyqbeoES+dpXeGX4WHFEpQ8nCwQPknrJnL3FHygByfHrT0u3X+2XcQ/YDj25QHj+KcU6uXa2NRvHmVe3lN8A8V29hVvzwSlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXexEJVnl/xEIpKkqq1x6epAL1V3IDl57gkiOME/5po=;
 b=aE0s9IH9go3xsPHdMEwgfD3y2EtWDFcZhIPUSkpH3NIg9/jPCNfqrMwJ1NfU+/ITrd6tUyL39Xr1SN4WvU7e/RyLvIKuxVK11FzYHL6gBYCGOImv7TheiQg2lUVREZ9A5bCdKroMAzSEyK9p7c1UdGlqCuRsMc4vE2lXizWLZN9jYPNW1EC1L48N4wNak+R86Fs6tJrvthmsHf+uJ+OMuOFAU6JIrHNIDRhtaB2FizhJ4vQ1Vj24/09+fMOcNfxNLcQlLh7PvW0/lE5crQz6N3HTTm0Pyd+hqW/XFcxePaBzCstVymCIRrwjudETwZd7JbesqeMYyseP/woLZGQfYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXexEJVnl/xEIpKkqq1x6epAL1V3IDl57gkiOME/5po=;
 b=eh38D/dzYFeMZtv6DZ7xOc/u6UofG8pO83I9Q3KEcT/NscU68TfEb5pefbw384b/Js5LkemNAeE2Bf6a8Po154dZZed1iO0N7eEF8CrUYxrlc2RiXMI6S5TQZHmImfyEku17/fmqOE/jnizJMTWTZK+fw4zC83jdyxaWO1jSIkc=
Received: from MN2PR02MB5727.namprd02.prod.outlook.com (20.179.85.153) by
 MN2PR02MB6813.namprd02.prod.outlook.com (52.135.50.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Wed, 4 Dec 2019 03:59:39 +0000
Received: from MN2PR02MB5727.namprd02.prod.outlook.com
 ([fe80::948:464d:e305:9adc]) by MN2PR02MB5727.namprd02.prod.outlook.com
 ([fe80::948:464d:e305:9adc%5]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 03:59:39 +0000
From:   Naga Sureshkumar Relli <nagasure@xilinx.com>
To:     Srinivas Neeli <sneeli@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Srinivas Neeli <sneeli@xilinx.com>
Subject: RE: [PATCH V2] can: xilinx_can: Fix missing Rx can packets on
 CANFD2.0
Thread-Topic: [PATCH V2] can: xilinx_can: Fix missing Rx can packets on
 CANFD2.0
Thread-Index: AQHVqdOPUv7+hq6CjUSnDAohvbmmXKepWmLg
Date:   Wed, 4 Dec 2019 03:59:38 +0000
Message-ID: <MN2PR02MB5727E5E2BF394AC2898D5E1FAF5D0@MN2PR02MB5727.namprd02.prod.outlook.com>
References: <1575375396-3403-1-git-send-email-srinivas.neeli@xilinx.com>
In-Reply-To: <1575375396-3403-1-git-send-email-srinivas.neeli@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nagasure@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b377bdd3-2a0c-4805-bbe5-08d7786e628d
x-ms-traffictypediagnostic: MN2PR02MB6813:|MN2PR02MB6813:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6813C7BD94430386A3ED4E13AF5D0@MN2PR02MB6813.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(13464003)(199004)(189003)(478600001)(6116002)(53546011)(11346002)(6436002)(54906003)(99286004)(107886003)(64756008)(26005)(25786009)(71190400001)(446003)(229853002)(14454004)(66446008)(55016002)(186003)(102836004)(4326008)(2501003)(8676002)(9686003)(74316002)(6246003)(71200400001)(2906002)(81166006)(3846002)(6506007)(33656002)(110136005)(86362001)(6636002)(7736002)(256004)(7696005)(305945005)(66476007)(316002)(66946007)(2201001)(66556008)(8936002)(5660300002)(81156014)(76176011)(52536014)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6813;H:MN2PR02MB5727.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cPSu2VKPAILvtkzf4cU3Nmbtf+UtMN7uvrzs1J5BDIbLgk5EFiKhgrnWpflg/z8Mn6TAMlMERBmU4CEyuiijl6S2Sa1VOiivfszCEGPAWZwDlRyuFX0qZO2LcptTCtUb5QRXkKg3A9+sOSHOKNI5aeICjYkucnd+BYC0K9t5XoaROHB9e3QmsBf4+Hs2tq1a+0pJbHeDzQUiV4V8d6NNBkkTa9TcAz4iRIkkZq00rxbmXaF0AgbrrFuzRH3o5LM3IM5DJL9dTwscCiBuaEd1SGkMfhoF8wxnnpgxroWA85MbUqw6p/vlyfZZIgMJ3vYfbOLjxB1tXb9uVrCdaHpAbp7X9An9t2VSvla5x4se+VuX58sxcoU/hqU9LavjYNi+Zo0J5EG0wrhmFltAM5xZp1KdBxhQcH/SvnuwcyK1moiqEuQ9BSdqWgMD5X/AXYR+QUkui0XK1C1ebbZD+qh6AXWaKQiIjh/sUpIowHnWL1pwdf8nsEiDMeb5kmSWaQdi
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b377bdd3-2a0c-4805-bbe5-08d7786e628d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 03:59:39.0446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N39VlpqxBGrIlMGauCvZS9BpQaD1zyD28g3RnbspcDV6pAK+nJWkCoXwiR2c5ZOmL4A38WRFVc0FNCZQJvm2Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Naga Sureshkumar Relli	<naga.sureshkumar.relli@xilinx.com>

> -----Original Message-----
> From: Srinivas Neeli <srinivas.neeli@xilinx.com>
> Sent: Tuesday, December 3, 2019 5:47 PM
> To: wg@grandegger.com; mkl@pengutronix.de; davem@davemloft.net; Michal Si=
mek
> <michals@xilinx.com>; Appana Durga Kedareswara Rao <appanad@xilinx.com>
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git <git@xilinx=
.com>; Naga
> Sureshkumar Relli <nagasure@xilinx.com>; Srinivas Neeli <sneeli@xilinx.co=
m>
> Subject: [PATCH V2] can: xilinx_can: Fix missing Rx can packets on CANFD2=
.0
>=20
> CANFD2.0 core uses BRAM for storing acceptance filter ID(AFID) and MASK
> (AFMASK)registers. So by default AFID and AFMASK registers contain random=
 data. Due to
> random data, we are not able to receive all CAN ids.
>=20
> Initializing AFID and AFMASK registers with Zero before enabling acceptan=
ce filter to
> receive all packets irrespective of ID and Mask.
>=20
> Fixes: 0db9071353a0 ("can: xilinx: add can 2.0 support")
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> ---
>  drivers/net/can/xilinx_can.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c =
index
> 464af939cd8a..c1dbab8c896d 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -60,6 +60,8 @@ enum xcan_reg {
>  	XCAN_TXMSG_BASE_OFFSET	=3D 0x0100, /* TX Message Space */
>  	XCAN_RXMSG_BASE_OFFSET	=3D 0x1100, /* RX Message Space */
>  	XCAN_RXMSG_2_BASE_OFFSET	=3D 0x2100, /* RX Message Space */
> +	XCAN_AFR_2_MASK_OFFSET	=3D 0x0A00, /* Acceptance Filter MASK */
> +	XCAN_AFR_2_ID_OFFSET	=3D 0x0A04, /* Acceptance Filter ID */
>  };
>=20
>  #define XCAN_FRAME_ID_OFFSET(frame_base)	((frame_base) + 0x00)
> @@ -1809,6 +1811,11 @@ static int xcan_probe(struct platform_device *pdev=
)
>=20
>  	pm_runtime_put(&pdev->dev);
>=20
> +	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
> +		priv->write_reg(priv, XCAN_AFR_2_ID_OFFSET, 0x00000000);
> +		priv->write_reg(priv, XCAN_AFR_2_MASK_OFFSET, 0x00000000);
> +	}
> +
>  	netdev_dbg(ndev, "reg_base=3D0x%p irq=3D%d clock=3D%d, tx buffers: actu=
al %d, using
> %d\n",
>  		   priv->reg_base, ndev->irq, priv->can.clock.freq,
>  		   hw_tx_max, priv->tx_max);
> --
> 2.7.4

