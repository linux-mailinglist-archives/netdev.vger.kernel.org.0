Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D0F127B62
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfLTM4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:56:54 -0500
Received: from mail-eopbgr130108.outbound.protection.outlook.com ([40.107.13.108]:53783
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727344AbfLTM4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 07:56:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgYVrTHC5IQdVPzlEaibZAdMU4e/kasam8TRVZLJ5HWMyztHfAu8ER+3ZYjLLh0yFILPzd/IhIYoUg2or9E52HQfvG32n6ExU+cla49NYoZy5wolydKD6bnu1jRt5cfud4lTvBSLl0wcHNDL7AOTb2OYLHC0Gtmq4DtZL0t1w23Rsd1wtzYTAp097O81e0G3ZxEEWDznLi8Ys1hocMLyy2/M+UdlKdtiLQo3VdNXIvCww61z9gCZKTFpIFh/W8jGfSApjMKoFNM5X6ai16m4QDd9wIZjJsbJdVMPtOCDtdaoIPWggpGxCflM8PIxrx4EZY4zIPkj/lz5ky3QdlhZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQTs8XFkmsiwkP+Ss0gLXl76gDCnUVE++GdtxCkUw6g=;
 b=j8WBQOyIEYyDweAJB1ftGTqmPD9FVA8F1jmK2KG9wuuBNO8TDuhCWfQ9WGtWPdFk9sya9itomJ3lkonPXO0rzyfrQRtqi/pvxWzQlRmaPmL14Tv3rj3iEC/lmod/nLtecTapLsC5ObyQwINtihhlf7rE+xuemQnN5vbjdk1dl9I8YnIIk1uKhCUR+QFsD962LhlDJwzYdHQFuflkzZjFaDMp27ksDuiAnFycawf6DafgzKOayeOYzzyGJK0VDuMzNstgffJIsHYVVQ4WvFfF+I/dpvlO4yCBV9ZpVBcNGirLf5jhZj9bS6mQz0Zv0cjl8L6k7fUSw+j5zpESM4SMwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=pendulum-instruments.com; dmarc=pass action=none
 header.from=pendulum-instruments.com; dkim=pass
 header.d=pendulum-instruments.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=altariaservices.onmicrosoft.com;
 s=selector2-altariaservices-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQTs8XFkmsiwkP+Ss0gLXl76gDCnUVE++GdtxCkUw6g=;
 b=nyi30NUa0qlZK1JHl0Dx2zK1yXpFjv89qwsS2PD9ilpS/b3zsYATyMnU1cI5talMssw38OKZgtJFC1OGNXaX+E2mQTIi4LrsWIlG4+LgCEShySA+bnGaqgavd3CduZYLYB8lYLCjufiVjhZbyyHZLpmnjFp13au3Ll+ur9cA2W4=
Received: from AM6PR0702MB3639.eurprd07.prod.outlook.com (52.133.22.30) by
 AM6PR0702MB3560.eurprd07.prod.outlook.com (52.133.24.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Fri, 20 Dec 2019 12:56:50 +0000
Received: from AM6PR0702MB3639.eurprd07.prod.outlook.com
 ([fe80::8ce3:7fab:e45b:6e3d]) by AM6PR0702MB3639.eurprd07.prod.outlook.com
 ([fe80::8ce3:7fab:e45b:6e3d%7]) with mapi id 15.20.2559.012; Fri, 20 Dec 2019
 12:56:50 +0000
From:   Timofey Babitskiy <timofey.babitskiy@pendulum-instruments.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH] stmmac: export RX mitigation control to device tree
Thread-Topic: [PATCH] stmmac: export RX mitigation control to device tree
Thread-Index: AQHVtzJwbbJzMzgpw0u6zEvLMmmZbQ==
Date:   Fri, 20 Dec 2019 12:56:50 +0000
Message-ID: <AM6PR0702MB3639888440F0AC658E31FE25DF2D0@AM6PR0702MB3639.eurprd07.prod.outlook.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=timofey.babitskiy@pendulum-instruments.com; 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5e1ed9f-652a-4428-34e8-08d7854c1486
x-ms-traffictypediagnostic: AM6PR0702MB3560:
x-microsoft-antispam-prvs: <AM6PR0702MB356040EDC8D6339E5BCC0A1BDF2D0@AM6PR0702MB3560.eurprd07.prod.outlook.com>
x-supported-by: MaxCon (www.maxcon.pl)
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(39830400003)(366004)(189003)(199004)(4326008)(66946007)(66556008)(2906002)(54906003)(76116006)(55016002)(316002)(86362001)(7696005)(6916009)(508600001)(186003)(26005)(9686003)(8676002)(33656002)(6506007)(81166006)(81156014)(8936002)(71200400001)(44832011)(52536014)(66476007)(5660300002)(64756008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3560;H:AM6PR0702MB3639.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: pendulum-instruments.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fab+D3f8+NKPYKE2PmRvoNaY4dd3ab4Xpw4uAevzUs2wqUrWKhFd1Yeo4VUuA6DvAwSmiaRkw2GYO+btq91Bim6VnGV8USSqsIBm4E6ZpFIQchu0G+Cw/BdO+CqWbQOaRahdu73YWmw6pnzcEljkBIXUBAsfbRiDfF8VEY4DwPov4TBOB7do0P9vpq7ggZB6Ei4LLv6I528NWMBmcMS/ZgvCS9ujhXrsC28YdjMpW5GCN89P7hrLgB0y0OtGXqCexd21K1YiRfRPLE5bVh4+g+iGBJRbO/0xJjUmvPyPkObTARBkMogfLWYL5jELCIAOIuosPo0zPM/oarGLrknmpuy3Rsr5RpP597efmFMArUkeVtQOLNhvjohVQKUFGy9urjleOSXvlJhO4sUH5PDSQl2RU4wsmshgL0i5pp7tPqbO89snAOQ8wkgMZbjn1eyg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: pendulum-instruments.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e1ed9f-652a-4428-34e8-08d7854c1486
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 12:56:50.2584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f57cf1d-13ce-4f8f-9030-888d5688f3fa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BtJRWuvvpSUagDVNA1Y6i3cUu2V8WLmZYIMOjUt7C/DuxRzfkkHlHHDvVQMHWFKLMR2wfqg3pKOKoFUyGG7sx+eXQ9RpL9vyN8WSOG5D2qNRX5ANamunf3ItzPXK73unXIGdNmeOmnGLSHhlfx850w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3560
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having Rx mitigation via HW watchdog timer on is not suitable for time =0A=
servers distributing time via NTP and PTP protocol and relying on SW =0A=
timestamping, because Rx mitigation adds latency on receive and hence adds =
=0A=
path delay assymetry, which leads to time offset on timing clients. Turning=
 =0A=
Rx mitigation off via platform config is not always a good option, because =
=0A=
some systems use default platform configs and only tune the device tree.=0A=
=0A=
Signed-off-by: Timofey Babitskiy <timofey.babitskiy@pendulum-instruments.co=
m>=0A=
---=0A=
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++=0A=
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +++=0A=
 2 files changed, 8 insertions(+)=0A=
=0A=
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Docume=
ntation/devicetree/bindings/net/snps,dwmac.yaml=0A=
index 4845e29411e4..b4a8d3e92b44 100644=0A=
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml=0A=
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml=0A=
@@ -258,6 +258,11 @@ properties:=0A=
       is supported. For example, this is used in case of SGMII and=0A=
       MAC2MAC connection.=0A=
 =0A=
+  snps,riwt-off:=0A=
+    $ref: /schemas/types.yaml#definitions/flag=0A=
+    description:=0A=
+      Disables RX IRQ Mitigation via HW Watchdog Timer.=0A=
+=0A=
   mdio:=0A=
     type: object=0A=
     description:=0A=
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/driver=
s/net/ethernet/stmicro/stmmac/stmmac_platform.c=0A=
index bedaff0c13bd..42b2f99d8c90 100644=0A=
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c=0A=
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c=0A=
@@ -465,6 +465,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, co=
nst char **mac)=0A=
        plat->en_tx_lpi_clockgating =3D=0A=
                of_property_read_bool(np, "snps,en-tx-lpi-clockgating");=0A=
 =0A=
+       plat->riwt_off =3D=0A=
+               of_property_read_bool(np, "snps,riwt-off");=0A=
+=0A=
        /* Set the maxmtu to a default of JUMBO_LEN in case the=0A=
         * parameter is not present in the device tree.=0A=
         */=0A=
