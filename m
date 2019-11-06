Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B2CF10D5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfKFINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:13:09 -0500
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:9447
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729881AbfKFINI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 03:13:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciAOEyTH2TLxyEAzdcBAFldWSVYYCmUS+yP7mBROU12q21wCDqodZPcbFhdQyz2YmS8Ai3NrlXDIwVLqN8XgeirNHTAH+rgXq46B/u9ubg9rX3/8f0K3M/fEzfZIqIykgan3zoUpnTlvkQQN9+k2bWtxrAbJlN7AozokEuYloZQ38o9U1yCfgj90vP0PQPLLuvnsNc8Rp9DG8ZO3mfLXP2KwohpTMwZDsOeKkRAj3dIR1O1mrQy7/DtiRE83SMfBRb3xkJp0ZLbyFlhxV0Medlv8iFGajfHNzl1qtJzWAPjxJxJmJr5HiNgWhosZOuWJ9JIdVKe51UgO0+/qAiHYqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDG5toMBYB+CJstZ6hJBQc/qDHkq8bgFuNo1FT8HW+A=;
 b=E8D+lcHSBOgD8ksPMqw7zM6b0aCVHI3LVPw+9dxA6j31KuyCV+PZ9nyIeXc3+HjPYAT8Y+KSf2ftxuLjp8sNC70Q2W8M8lUX54QKpKNhVsl21zg5732zIoO69bQ9Sln/NxMSIGdkmXY9V3PGgSgryIoPzxytMU+1EsFzDWH/TVgJX1pX5cHS+iOCUgM6dT7FkBsONFzeJgmSziWn2By/Fb1zwnBTgAxbDmrfouD662gDQUK1He6UEFH1dlHJJG0GXF9PdFxB9iBTKDhYzDT1ebR26+Ur1CkyA7eqzEa0ZAn2C5pLI8TCQ3kc/NOtplxhyKHeVpWtQqw55f4UgPkEdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDG5toMBYB+CJstZ6hJBQc/qDHkq8bgFuNo1FT8HW+A=;
 b=CD5T4lcLJam8VVc620PgfWA6C8oqUCJYnBBFHq2dMfryHoXWIfhlfr3vDuk/Wv05VoUDd5Dw02wR3C6pbfKDYzBpZ74I+m/hcZY+nRn91G0CfMqDonzPnKZUXc+rM5dhHNZyE8gHMNriFyFuMvHbIAzZ8K+Y6VnkrUjQcwIM/KY=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2751.eurprd04.prod.outlook.com (10.175.22.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 08:13:05 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 08:13:04 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Topic: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Index: AQHVlHh1RxWa9XB3VkWu+bqZPxdiDad9ymZQ
Date:   Wed, 6 Nov 2019 08:13:04 +0000
Message-ID: <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191106080128.23284-1-hslester96@gmail.com>
In-Reply-To: <20191106080128.23284-1-hslester96@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b26e4eb2-7c18-42ca-50d7-08d762912651
x-ms-traffictypediagnostic: VI1PR0402MB2751:
x-microsoft-antispam-prvs: <VI1PR0402MB2751FCE4EA71611C9E244BDDFF790@VI1PR0402MB2751.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(199004)(189003)(74316002)(54906003)(81156014)(66066001)(486006)(1411001)(11346002)(476003)(14454004)(99286004)(81166006)(52536014)(25786009)(8936002)(86362001)(5660300002)(478600001)(4326008)(2906002)(14444005)(6246003)(55016002)(33656002)(7696005)(305945005)(446003)(6916009)(7736002)(6436002)(229853002)(76116006)(102836004)(66476007)(3846002)(6116002)(316002)(66446008)(66556008)(64756008)(71200400001)(71190400001)(66946007)(256004)(9686003)(186003)(76176011)(6506007)(8676002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2751;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlOKWji3cBsbZ+LtZ9nMfwhyYUl6F76F9znrb50VUVRMhG3CGu0sseRZeYwiLKUVdLqN4D1RV/aI43Q64U89wnfPs8vAa5+s+PywWWCQLNtPYTyWOCyO3ZxBD0xfTLQ3xPXScp6wsCzcxk2lB7BqnowFG2O8TuyOJL7Et8I2WMpvxd9IPBYqxXI30PD3QArdBMgwVU7vJBVrpSLrSZYhxEzol/Xmh5idP48MczLE7Sut3i/2oZ5xdqc8PJ2cDMYofmaMwGvJ5EBoy6uwUOMeI6ei6VecM75gtH41cDWQlhXmXlSNhVDR6t6GLDlPGnRUZIghLfhM36qJku2CT5bu5kq0bRxEERLPGYxvYzL3lX0wXnB+8jVabE8TcaMjSh+YY7tXCviiTi9Nj7hDxCiDfD5P3L5B4/rcZsYq/bBWE5zJPNoddlLZm/PhdwJLdITo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26e4eb2-7c18-42ca-50d7-08d762912651
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 08:13:04.7558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUHNE7XY0LWTmvL0sxN02rxMVw7AnQyO8tUZAv4ubPGLk8NpUlsuG04M5zr9wK7AmHgbay4XNa+kWknCcwdHkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com> Sent: Wednesday, November 6, 2019=
 4:01 PM
> If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> automatically to disable clks.
> Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
> Add this check to avoid clock count mis-match caused by double-disable.
>=20
> This patch depends on patch
> ("net: fec: add missed clk_disable_unprepare in remove").
>=20
Please add Fixes tag here.

Andy
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index a9c386b63581..696550f4972f 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3645,8 +3645,10 @@ fec_drv_remove(struct platform_device *pdev)
>                 regulator_disable(fep->reg_phy);
>         pm_runtime_put(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
> +#ifndef CONFIG_PM
>         clk_disable_unprepare(fep->clk_ahb);
>         clk_disable_unprepare(fep->clk_ipg);
> +#endif
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(fep->phy_node);
> --
> 2.23.0

