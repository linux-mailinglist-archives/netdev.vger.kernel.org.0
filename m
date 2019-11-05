Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA734EF294
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfKEB0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:26:33 -0500
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:38882
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728761AbfKEB0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:26:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ6k/Q+bgdcCbstl6DgsoGUn8JqslHvBJZcsJAr0vjjUlv0Zgz2MJ4bTO2Z4c02/paqvTIkQV36lMcM52kEgwnp2S6W2GW/rVmL4EFPhRXoeH+PGB56Lpg5c0ChiVG4OM8nBJbBzVhp3CUDrP22yvIcqJlS3jzbY9vQE9JIfh+ZPDgCJYBTm6D5QaL46+fbiRvfL/sunpDVisTI/c7btHIAUzLXDZu87sHo4nXuw8pqrDs7+Y4+WsonGsuJ5Gcu2y19EWX9okTJS6Ul9UNm0Tslzb9t2nSvQ4eZs5fL+jK3MuSvJdJkqamXS3XPs7h/ed+634228nYfqwOtwJa4u2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpJ9n+63atz/pnyMZBI18pvJuSjiTRx5+gEX9kBAgoE=;
 b=DgD1Zu4liT7juLsclCelE73cY5lxZce9aSWGycp6tI8bzzHosg51b0gEqok7fJ16iFgtS3lAPcmDlC5sws/c9YBI9QCwOy29oGBBgtFhpad5BjTVL8ZFfQbQUJ5vL2eth7v9mNpv6hadLsNSW7bdBYweKPfEQml3isKHPR4mCK3fEL17aYILvgXgpI5ZIgHLteRmJKBgcNdCARaBotjjgNyBK3i/jJ/OdW+POT/S0/UV/uuz7mW4zqnY3PmF/bVPKzq17G0whiG5tNNLo/oHHbpNqRbeXGQHnllowFjEzT2hn/0I6lxyVDftlNENg5aEFBmOqd20PrckMUIG/yvkIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpJ9n+63atz/pnyMZBI18pvJuSjiTRx5+gEX9kBAgoE=;
 b=Hn/V7Hs4H/uX/WYqP6fUGpWUc+dxoJwo25tCYVoYsMRyX2yoSI+KhHXQBkf6qi+MHDDL++wYGDT5VW4vAGqZO73B4VVgRfuZWzuYa/7CnUcX3c9OWTU1iaPw6EYa8mWtQPModwZlY5Km/3BlTbpnTHlUkjvJJ91m6VtfnGwSNRI=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3951.eurprd04.prod.outlook.com (52.134.13.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:26:29 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:26:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Topic: [EXT] [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Index: AQHVkyeLajpiMEtWy0a0Faj4h+gvxqd7yAhw
Date:   Tue, 5 Nov 2019 01:26:29 +0000
Message-ID: <VI1PR0402MB36006B7BEAA7F4BCB9278598FF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
In-Reply-To: <20191104155000.8993-1-hslester96@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c16a978d-006b-4bf5-6322-08d7618f2f18
x-ms-traffictypediagnostic: VI1PR0402MB3951:
x-microsoft-antispam-prvs: <VI1PR0402MB395116BBC317C00800047921FF7E0@VI1PR0402MB3951.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(189003)(199004)(66556008)(66476007)(7736002)(2906002)(305945005)(52536014)(66066001)(256004)(25786009)(7696005)(6116002)(3846002)(316002)(186003)(476003)(26005)(76176011)(6916009)(99286004)(8936002)(6246003)(86362001)(54906003)(64756008)(66446008)(14444005)(5660300002)(81156014)(81166006)(102836004)(66946007)(4326008)(486006)(8676002)(446003)(55016002)(229853002)(6436002)(14454004)(74316002)(478600001)(1411001)(71200400001)(11346002)(71190400001)(6506007)(9686003)(76116006)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3951;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMEfDrb3JzLU8IWSTKR0e0t5RD7u1CR0cxmQDBGWH43iqE1DyxBEwPKB3Wfrln5OcwSAYe8RBe54SMzk2VbcbS271r90oLYvUEkRW35fw2Eufm8eCSaYNGYCOLroD+Ft8l1eF9/hQ/3xknQbHMaSF8Z0f6PDeZ4B0CI6/VblX1PCJzsIYAvAnE5SWQ+B46U84G6TB7gsg11ITKuWtnj+MNUzzsDGydzjHYN1bFVm1K+O73dwFuX6z67ycSFD41nfpwTwMqkSVyTouH+yl/Pnd4HFiK0km7QRNV8crZiFR8fbdvOOlEMygOzSyQcHFOV8rXcYeNJqZXBWReqBWfBGadIMMsokX7v7fc7Wx6lCskGdZoRPU6vrDCIQu3jacpkl+33LFQWCD1DU0ulDkAoCeVlPmPek1ZtWAKdt4VkLJ1nhsg1UpyGIrnn92gmCEJtJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c16a978d-006b-4bf5-6322-08d7618f2f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:26:29.3550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YD4Vn60M+PtIxcShevFb4Qs1QS9NAc85HsVd3Kt1OybVfg9d269g1gaRT1ux0UIpFg4xMT4xXZZETPCVbN/w6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3951
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com> Sent: Monday, November 4, 2019 11=
:50 PM
> This driver forgets to disable and unprepare clks when remove.
> Add calls to clk_disable_unprepare to fix it.
>=20
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

If runtime is enabled, the patch will introduce clock count mis-match.
Probe->
    Enable clk_ipg, clk_ahb clocks
    ...
    In the end, runtime auto suspend callback disable clk_ipg, clk_ahb cloc=
ks.

You should check CONFIG_PM is enabled or not in your platform, if not,
it can disable these two clocks by checking CONFIG_PM.

Regards,
Andy
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 22c01b224baa..a9c386b63581 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3645,6 +3645,8 @@ fec_drv_remove(struct platform_device *pdev)
>                 regulator_disable(fep->reg_phy);
>         pm_runtime_put(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
> +       clk_disable_unprepare(fep->clk_ahb);
> +       clk_disable_unprepare(fep->clk_ipg);
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(fep->phy_node);
> --
> 2.23.0

