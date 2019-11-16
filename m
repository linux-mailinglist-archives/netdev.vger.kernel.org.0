Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD76FEB07
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 07:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfKPG5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 01:57:22 -0500
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:27877
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725971AbfKPG5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 01:57:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnxTFAbVXa9sBF7oXoyK/WLahkT2QIAnipLFiKBKk0tBCRyBhUolCqAYTPIqpbFhxtgFxz/jP1euX1rrgiPrGcvXH0/cekidPHyhZi88Km4wMQDeAZ4ModGlY1k8MaNovVUUzLrhD9QjQhnq3Pp9RrvIL/I/daLlPels7G+fcGBDfcbYL1wQlmGcRG8/DI+TAFb5SjSNposPZiWO29eEVDkxQV+Db40EECWMAMk1ridZGGAmrdFEbQthHD8h1UTP3I3occpD7plwzXxeYfEhY/8dpAa3h2SWutdocinWHRgTLXpPm7ZKYDnGpDt7Z/d/nc/o5j6ItAfn5eHQ/bX5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X38avBEdCH0s9FOTzOaCtrwhP0u3ajjDW/PKqElt0o=;
 b=emNYgItxoECwz4a/UarkyqutT/7pqZ1assrUVXBLEqBnaMQbDuPDaDgcYxxAwoU2kXW4m8hk//l4Cbrht6a3JTyoi6TIAzrEkq1TyPmFwNELoTb3XqcqmfwFtlRhgDPRcBJkfWN6RVDwn9yFOHYovLrGqpf+J82kJQcHJri7PG3HNlwiX4EQOrGNddmyxRB03f9vW1o1mDPQWSOhqyi3xPya/PWcSB27tTJUVSm4ddhI35WszAduDb5Usjh1PKYCMoizxdobf5VTuzYPafk8l18/J1SaWTMMH9K4A5lFcpAizJd5mk3x6T8DaRWpuZ3YfWwamH+6whS3d78KB1WvnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X38avBEdCH0s9FOTzOaCtrwhP0u3ajjDW/PKqElt0o=;
 b=C7tg7TrPDzo7rEjc3j6eSlDHP1z0ClJOLXMFjC7V6WhEAAxM7xUDWpNOzqzDQdHBzmN7NWRJS524gUQcLjqn0xPTZRkbXZFaco0CUFo45m70Bim96I+Oo4+n6BccrADMXGyVNJKQ/4p4t06oFR0BpNAdGyytCk2MSYAQfjdPw2c=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3951.eurprd04.prod.outlook.com (52.134.13.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Sat, 16 Nov 2019 06:57:17 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2451.029; Sat, 16 Nov 2019
 06:57:17 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Topic: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Index: AQHVm/DMOznlKnTJFkKJdT1jxlx3n6eNXN9w
Date:   Sat, 16 Nov 2019 06:57:17 +0000
Message-ID: <VI1PR0402MB3600CE74E0EC86AC97F25026FF730@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191112112830.27561-1-hslester96@gmail.com>
 <20191115.121050.591805779332799354.davem@davemloft.net>
In-Reply-To: <20191115.121050.591805779332799354.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d03fdd2-dedb-4c88-0ee8-08d76a6237eb
x-ms-traffictypediagnostic: VI1PR0402MB3951:
x-microsoft-antispam-prvs: <VI1PR0402MB3951A2BBA20F15F55AA4F971FF730@VI1PR0402MB3951.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:335;
x-forefront-prvs: 02234DBFF6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(189003)(199004)(316002)(25786009)(66946007)(66446008)(64756008)(186003)(2906002)(2501003)(26005)(66556008)(66476007)(76116006)(6506007)(8676002)(81166006)(102836004)(66066001)(81156014)(54906003)(476003)(52536014)(486006)(71200400001)(71190400001)(11346002)(110136005)(99286004)(86362001)(5660300002)(6246003)(33656002)(305945005)(478600001)(7696005)(6436002)(446003)(74316002)(256004)(9686003)(14454004)(55016002)(229853002)(8936002)(76176011)(6116002)(3846002)(14444005)(4326008)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3951;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v/FLGRqLGhrzLTrD/Ait/zR18cjY8UT9NSOW5SPkFN82h5IYtzfgITpleuT5UbbwqeAgvTEPmRynOLAAjslA2Po5m+PgMiRfMwsP3y1rWrCzJxkYGQE8xrNhLpUYqsFJobrt3LfD7nsOw/0BtxQaonQFUEwaWlxJxUtnXSwr4qO0hqgCb1xsZmx8Fbdow2W4mErdkkXS566TnQkPRMDWtwktugcDNnigPlJ+6zfWJ6AXy/Bv1ywhFF43t9PaXnP9Z8Pyz+laYNiu2iJdIkg1rFsRuG+qxkn6cgawXzuIFneYrQK32+kA2Ye99KPbTQJsZIIOVrRFLM4S85QrLPXSc+sPhKRunhE75rUBiG+3gv9UDhLxlr/aJ7JfWQk/bNNE/pdF8bZyu51MqG3Xx24i3jgHlbV1XuvKlsL3E7E31nIZAdaAqMh5PGNvbwlJCOKn
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d03fdd2-dedb-4c88-0ee8-08d76a6237eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2019 06:57:17.1256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEk7fjF2PU/r6Nk8iPw7L7oe6fXrQzZAsgrOA/gABMb0GUYeSVuGDv8otozxRw2hNjcIjxbQII+rVLaOYDQD7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3951
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Saturday, November 16, 2019 =
4:11 AM
> From: Chuhong Yuan <hslester96@gmail.com>
> Date: Tue, 12 Nov 2019 19:28:30 +0800
>=20
> > If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> > automatically to disable clks.
> > Therefore, remove only needs to disable clks when CONFIG_PM is disabled=
.
> > Add this check to avoid clock count mis-match caused by double-disable.
> >
> > Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in
> > remove")
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>=20
> Your explanation in your reply to my feedback still doesn't explain the
> situation to me.
>=20
> For every clock enable done during probe, there must be a matching clock
> disable during remove.
>=20
> Period.
>=20
> There is no CONFIG_PM guarding the clock enables during probe in this dri=
ver,
> therefore there should be no reason to require CONFIG_PM guards to the
> clock disables during the remove method,
>=20
> You have to explain clearly, and in detail, why my logic and analysis of =
this
> situation is not correct.
>=20
> And when you do so, you will need to add those important details to the
> commit message of this change and submit a v3.
>=20
> Thank you.

I agree with David. Below fixes is more reasonable.
Chuhong, if there has no voice about below fixes, you can submit v3 later.

@@ -3636,6 +3636,11 @@ fec_drv_remove(struct platform_device *pdev)
        struct net_device *ndev =3D platform_get_drvdata(pdev);
        struct fec_enet_private *fep =3D netdev_priv(ndev);
        struct device_node *np =3D pdev->dev.of_node;
+       int ret;
+
+       ret =3D pm_runtime_get_sync(&pdev->dev);
+       if (ret < 0)
+               return ret;

        cancel_work_sync(&fep->tx_timeout_work);
        fec_ptp_stop(pdev);
@@ -3643,15 +3648,17 @@ fec_drv_remove(struct platform_device *pdev)
        fec_enet_mii_remove(fep);
        if (fep->reg_phy)
                regulator_disable(fep->reg_phy);
-       pm_runtime_put(&pdev->dev);
-       pm_runtime_disable(&pdev->dev);
-       clk_disable_unprepare(fep->clk_ahb);
-       clk_disable_unprepare(fep->clk_ipg);
+
        if (of_phy_is_fixed_link(np))
                of_phy_deregister_fixed_link(np);
        of_node_put(fep->phy_node);
        free_netdev(ndev);

+       clk_disable_unprepare(fep->clk_ahb);
+       clk_disable_unprepare(fep->clk_ipg);
+       pm_runtime_put_noidle(&pdev->dev);
+       pm_runtime_disable(&pdev->dev);
+
        return 0;
 }

Regards,
Fugang Duan
