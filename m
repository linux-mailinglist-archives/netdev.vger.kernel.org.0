Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892AB1224ED
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLQGnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:43:14 -0500
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:28011
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726704AbfLQGnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 01:43:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNuEkjqffvMH7XYHlL+DlGU065jzmsHJM5KfCFL8V1hDFupVMTcomlH31F6t+M26XowMEuUAPX5TxqtxTRKcSCqYlF28tZ8UsBZ1F5IYl5JliHyxaTK+0QC9bPWjh9LX3r3txPVczhrNI5reFOe+pec6IbdGLpn9HZjMEp7ctrvP3yuPo7CG0B+lscov0kPKtdBFt/IO1iG/tOvA5T5UGvXy7yKZ2DKnkF96Lof/Teesu+SrAxOwQJ1z3FIZdIRRwRMuaDJeNA7oDYUGfgWm8UwtFiHRt+D481vjxFzIG/cCmEhEmXXEgWA7yZKuLKmsw4alr8GjofVQl50KjRwfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HdwOCPLxlfO91NF5+4gZTFKg3jXYVSQOctYi/SCkXM=;
 b=iHHihJYRDMOGB6zcvnqXuIs9WbwOZFiKwDcgmIdTt7/UEbD2DVa/Q21rNFZLvUBySG1x21WnIoIuhLhKZ3p4vE0b+rivmuTllQ1Yp5s3vKOe7TO+5MlgJmK1YQ7X+w26KEnB5mQnY2zd1ZTN8SNtyOtB7lN2xZFrrnceCNa76A5ewPoZYnkC8i3myQdqOZo+nPmOtesDGU/YxXjEn6vMOqsqIZPLW0SNZMTHEEVsxafWJlFpoKre4/qrxkz02cENyMQeKBPgkK2n+oFa6sBFVybgtsLjdgxjzxYCgazKXkFNaEErrGSlXPhhQYwjGX0AqtkF48nVrMONA0gzDozhxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HdwOCPLxlfO91NF5+4gZTFKg3jXYVSQOctYi/SCkXM=;
 b=Qx80PqgHfgHwMGH685jBKvd1OrGEP+hCus4R3UaPbExTAkgCnQypSIk7BE2ROnVp0p42PpmQoUopRW4gxMIIZlv9KI93ngHPAEDSlgYxSIHUVqJu7iLgAJsg+yuQ7THUbtsCwpt2dME3L4R8+VL/0MkFziKWWMAuMYybmpnmdy0=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 06:43:09 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087%3]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 06:43:09 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH net-next 3/3] net: axienet: Pass ioctls to the phy.
Thread-Topic: [PATCH net-next 3/3] net: axienet: Pass ioctls to the phy.
Thread-Index: AQHVtD9BqjnLY2nNAk+Cq7P2nUR4Gqe93tjw
Date:   Tue, 17 Dec 2019 06:43:09 +0000
Message-ID: <CH2PR02MB7000A528FD86ACB95D03F4F7C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <361f63095be92df10e8e953af3b981cdac58d98e.1576520432.git.richardcochran@gmail.com>
In-Reply-To: <361f63095be92df10e8e953af3b981cdac58d98e.1576520432.git.richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc8e8324-4939-4d62-e17f-08d782bc617c
x-ms-traffictypediagnostic: CH2PR02MB7000:|CH2PR02MB7000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB7000B460EDA6CBF663637A8FC7500@CH2PR02MB7000.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(189003)(199004)(13464003)(5660300002)(53546011)(66946007)(8676002)(64756008)(66476007)(478600001)(66556008)(7696005)(186003)(6506007)(8936002)(52536014)(81166006)(81156014)(110136005)(316002)(86362001)(107886003)(76116006)(33656002)(2906002)(9686003)(55016002)(26005)(54906003)(71200400001)(66446008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB7000;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u1ACaaBe6SQu0NmAvDfddT34hB1jIVylacRNQfTXbqPAttQuEsfIqLZKenUXhaoTMmTECKmCrm6u7urshAL1+d04I46Wh8gBpDcMcGz36xhL+OiR/enwA/IOzD3c9BczAR5rVBjX3otgKnAfPPKBgz67qZoLVf3Q430RBJTjymQmkAseHA2yJCuRDa0SlNC696HZiqpUz9wBChkIpVOeXDwCbBSjNOOebi98TRX5iVDLcgwC1D8nmsUO1LpeWP03HTG/Y6M/TNrkbuMu0HE4F3d4C3k/t8z7VisZsKEfVNDqVoWndL0cLMdeeMpNiZ/MW1pf8WUdb9ZH+wSzAt29WQU4Ggq8iAHDDIO3Mv9ZrVTSx3ph499SmJ2oFedQpqirc/V+X1pl5KIemqLmX+umfVlfct/F49HrnHfwkDzVNLCt2AiIq20uimqw1my2ayoWIximPdfWl5/fPDW7sLn//+weX8U0OZc+wBsW/ar/orCUX7pURviLRbWmPigcu+Hf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8e8324-4939-4d62-e17f-08d782bc617c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 06:43:09.6265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9tSnP91MOROFM1cY600yZhbQtavipKTZWj21qNxZtoTtkcXzuXOvSXmRCrLhKA85rfLemRYtQCjK2TX8hl7jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, December 17, 2019 12:03 AM
> To: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org; David Miller
> <davem@davemloft.net>; Michal Simek <michals@xilinx.com>; Radhey
> Shyam Pandey <radheys@xilinx.com>
> Subject: [PATCH net-next 3/3] net: axienet: Pass ioctls to the phy.
>=20
> In order to allow PHY drivers to handle ioctls, the MAC driver must pass
> the calls through.  However, the axienet driver does not support ioctls
> at all.  This patch fixes the issue by handing off the invocations to the
> PHY appropriately.
>=20
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c  | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 05fa7371c39a..d0b996f220f5 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1067,6 +1067,23 @@ static int axienet_change_mtu(struct net_device
> *ndev, int new_mtu)
>  	return 0;
>  }
>=20
> +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int c=
md)
> +{
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case SIOCGMIIPHY:
> +	case SIOCGMIIREG:
> +	case SIOCSMIIREG:
> +	case SIOCSHWTSTAMP:
For hw timestamp we are passing the request to phy?

> +	case SIOCGHWTSTAMP:
> +		return phy_mii_ioctl(dev->phydev, rq, cmd);

Driver migrated to phylink so now we have to use phylink_mii_ioctl.

> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  /**
>   * axienet_poll_controller - Axi Ethernet poll mechanism.
> @@ -1095,6 +1112,7 @@ static const struct net_device_ops
> axienet_netdev_ops =3D {
>  	.ndo_set_mac_address =3D netdev_set_mac_address,
>  	.ndo_validate_addr =3D eth_validate_addr,
>  	.ndo_set_rx_mode =3D axienet_set_multicast_list,
> +	.ndo_do_ioctl =3D axienet_ioctl,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller =3D axienet_poll_controller,
>  #endif
> --
> 2.20.1

