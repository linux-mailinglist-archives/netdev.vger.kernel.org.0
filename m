Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9ECE10312B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKTBdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:33:16 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:46413
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfKTBdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:33:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYFp3eRiPz5Ts9qQylKWypabqbADjDrt76PUZnpEbbpx3s8HIEsOhwGdbAMXYh0Dl+S5J9XyfmOBQ4F75ubhrqN7Iv71XXAJKJc++ZkORKq7l+o3JMSQwILTrEoXHYoCl2bF26H8T/JnMcUlVtXGQS4bxsCAQO4/tzoIkcKqX4o054BPupJVAYyi8yO4B5hCq/PDHsTHx7AwYfKcvm9jiT75pIXTUJ4dCtc7lMGMtk/+5DVoFhkMrXIZnzWVto6kYUu11HfOVKq/MRapc5MwC0okx1/kwKEqRyQWYYn49mOo7ZJsZOi5lB5FBMnOzKDUn9B/etLkALJHl2NM1laUvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAPgrb3gk8nKbL8ADDZ13OmbfJ+/7X9c3lrkMe9nsgo=;
 b=SOEAhZXdL49Vp3hkWpsQmTfaOMiA4AGbrgHO/briy7YqU45IMC4yyIaI1WOoG9/Cl1wxt59eYH8Txo8NEAGC9oMcAdClU6uvZWzShicXPyvTjU1iJOdA0XpJJrDLsmAx+Ury+anzxPub/4eUPGEaJid9xlaJ8lnPTK26jNGeKI8IfCZ8Qj2VnSVjNb8Ta6xXejMoULgni90PJhYQqX7YVf1TeDVfW1XENzBrnxGrGae6ISTdt6wAt8Gel2dXGxFcOZpAXpiVlD2fa3ZGDxnuprVplRVBFE0oc53C+wt5Wqxg9WwMjuDjPTDAkTeQVS5fp4caO7gfTgTf68EfmWZvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAPgrb3gk8nKbL8ADDZ13OmbfJ+/7X9c3lrkMe9nsgo=;
 b=jU3rByNYXG5CDr3lf5aRbDvXLpFkC9H344qVLK802baiHSgLcaSNrBJ+MTAt8bI0bB+1NbANROPVoWG9mNp8tcxlwGZ1IzzlhiTmdJ3Ba+fktESiD/wV+UclLYbQbcnOHspL7AtYf1wyrD+qdCzcDa+bBqXpKR+V8lqL7Fsf2cw=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3439.eurprd04.prod.outlook.com (52.134.2.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 01:33:11 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 01:33:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH net v4] net: fec: fix clock count mis-match
Thread-Topic: [EXT] [PATCH net v4] net: fec: fix clock count mis-match
Thread-Index: AQHVn0FjeP+5ynWFrkKEfPaLxMT/yqeTRiQg
Date:   Wed, 20 Nov 2019 01:33:11 +0000
Message-ID: <VI1PR0402MB3600B65E741DB82ACA31FC6DFF4F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191120012513.11161-1-hslester96@gmail.com>
In-Reply-To: <20191120012513.11161-1-hslester96@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d05709d3-d14c-4b58-b349-08d76d599adf
x-ms-traffictypediagnostic: VI1PR0402MB3439:
x-microsoft-antispam-prvs: <VI1PR0402MB34394E2FAD4D62610F50E336FF4F0@VI1PR0402MB3439.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(189003)(199004)(256004)(14444005)(476003)(11346002)(74316002)(186003)(52536014)(5660300002)(26005)(76176011)(102836004)(6506007)(1411001)(66476007)(66066001)(486006)(66946007)(64756008)(66446008)(66556008)(76116006)(33656002)(7696005)(25786009)(14454004)(6116002)(3846002)(9686003)(6246003)(55016002)(229853002)(71200400001)(446003)(71190400001)(478600001)(6916009)(86362001)(8676002)(305945005)(8936002)(7736002)(2906002)(4326008)(6436002)(316002)(99286004)(54906003)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3439;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bpAlt/E+GCOTHQrwy0gXUKdhj8kCKZGLVUZ4gJ/q5IG72fqCful1wuJiLquqWUnXauypzK/AjhsOxYhDjaGg2kTTapkU2MvoXPOz32tQwBdYT8GvsZzBiQsRvHYWS++ztX9t1NvMWmGOWrk5gubk4b5icyN1ynp5GFYdIn9XRM1atKSnymHA2bA99Dmiy375hGT3QCcCp+oCmyI98UYhuUa8nAzXzfXySXJrWycMxOQDiq8RtcT1C7MH4Y9yizb0/hrrM/2zhljVusZ/59780YHo5g+6j4xhuyRjI01ow3mgUv9vUno/yGAQq8b/+Mlay2w/b7DzbauzW/Oqr3UK97kZAcpumwA3fkFQM7CYsnt7xdY30WGh+2a04xO4Zue9CChaNLwrp31IY7dw1Vxo4P+hpwVI9JM5IBViq0z6lzxs+dX/p4iQcpWBePVGmQwW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05709d3-d14c-4b58-b349-08d76d599adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 01:33:11.3323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tM+Qr7n4kZp6l6+vVPeQpplICni3V6+db3as37FOabaShWxga5sDya6HoGpPaOfup0J2IVjX/OOXIXZMUtKUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3439
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com> Sent: Wednesday, November 20, 201=
9 9:25 AM
> pm_runtime_put_autosuspend in probe will call runtime suspend to disable
> clks automatically if CONFIG_PM is defined. (If CONFIG_PM is not defined,=
 its
> implementation will be empty, then runtime suspend will not be called.)
>=20
> Therefore, we can call pm_runtime_get_sync to runtime resume it first to
> enable clks, which matches the runtime suspend. (Only when CONFIG_PM is
> defined, otherwise pm_runtime_get_sync will also be empty, then runtime
> resume will not be called.)
>=20
> Then it is fine to disable clks without causing clock count mis-match.
>=20
> Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in
> remove")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Suggested-by: Fugang Duan <fugang.duan@nxp.com>
Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
> Changes in v4:
>   - Fix some typos.
>=20
>  drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index a9c386b63581..4bb30761abfc 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3636,6 +3636,11 @@ fec_drv_remove(struct platform_device *pdev)
>         struct net_device *ndev =3D platform_get_drvdata(pdev);
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
>         struct device_node *np =3D pdev->dev.of_node;
> +       int ret;
> +
> +       ret =3D pm_runtime_get_sync(&pdev->dev);
> +       if (ret < 0)
> +               return ret;
>=20
>         cancel_work_sync(&fep->tx_timeout_work);
>         fec_ptp_stop(pdev);
> @@ -3643,15 +3648,17 @@ fec_drv_remove(struct platform_device *pdev)
>         fec_enet_mii_remove(fep);
>         if (fep->reg_phy)
>                 regulator_disable(fep->reg_phy);
> -       pm_runtime_put(&pdev->dev);
> -       pm_runtime_disable(&pdev->dev);
> -       clk_disable_unprepare(fep->clk_ahb);
> -       clk_disable_unprepare(fep->clk_ipg);
> +
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(fep->phy_node);
>         free_netdev(ndev);
>=20
> +       clk_disable_unprepare(fep->clk_ahb);
> +       clk_disable_unprepare(fep->clk_ipg);
> +       pm_runtime_put_noidle(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +
>         return 0;
>  }
>=20
> --
> 2.24.0

