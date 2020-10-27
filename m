Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB429CCF4
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgJ1BiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:20 -0400
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO simtcimsva03.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833002AbgJ0X1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:27:47 -0400
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD94BA4106;
        Tue, 27 Oct 2020 19:27:46 -0400 (EDT)
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E212A40CE;
        Tue, 27 Oct 2020 19:27:45 -0400 (EDT)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by simtcimsva03.etn.com (Postfix) with ESMTPS;
        Tue, 27 Oct 2020 19:27:45 -0400 (EDT)
Received: from SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) by
 SIMTCSGWY02.napa.ad.etn.com (151.110.126.185) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Tue, 27 Oct 2020 19:27:44 -0400
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:27:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 27 Oct 2020 19:26:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVbBhls0xx59IJTjk/zvJjRtUxv0Qdlka/wNpyFLQbO/TTA0Nfl704CuMv5GkhAb52j4cKLgbsLoc547DP92pBwB/iys0OwtljD/Srj9s7PT/bXT9E13oIvIMkmYjoWpWJW88K/hdoDeq29/4vihVzuB0EaFj1nXzMHzoUTomF2URB664o3GzaDI5Db8v7F7ozyTZoEsEGgANCZyyTHWiFM2tif7G0JHNArP9KqJ46LGdR+6hLN/z13lsaeGdvd5qyxC3D8Q/TYyjHPv7tMRZ9Dz5EOBehGvngbfD1O5SJgX2A6b613m5slK0biluFDIysoqaIUBHk0uC+DewR8RCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4DQSMFVvoR/okb6ikmo155KaSLww2SJUaU8fwOzShs=;
 b=GaSmz9kGkjuXDaUGlFz9UzrEyQe1/0EDEajlG61bXoKQua8KaOEwmMfKgn/DqFuO4v7l6Zyqv/R0l+lNgcRqUP1Tb8T3fKVN13QSRnb+Tnfhbp8nNb0Orse4HSDKRamkhGzbIwJ24lvb9DGZXY8WQ3tTiNgBRJDeylfUCiDxdp5D2c9RFa47eZG8t+oJPjI/1/zyeu822S8Ro1TvwjUTNBdcXH/ci4mbS0sdLqI0njJzDMM1hWeo7MS0eXkgp2NFJaWIU0KBwW1FVGAiEMRLvpf15xbiw/5sOB0HzorRk13N/Gi5T4GbS3La7F0e7D6SPzpGrnhGLnjnSQwoI9/V4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4DQSMFVvoR/okb6ikmo155KaSLww2SJUaU8fwOzShs=;
 b=d8NNz+b/eCvrO3sOfDmR4gyuE9oqpyvv/db5KnUChlOEs38Tf/bd69IZBaDPefp0jdJqw3NOHQw6h9oCGU15i/W1Kwkg+A6VJzSL9tbn8Tarws3nqWwc4mkOZ35OEbT0NfxB4Yf+WbybFbdrmYK0g9BshXT/jgb/rMMltVJtK8c=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB1942.namprd17.prod.outlook.com
 (2603:10b6:903:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Tue, 27 Oct
 2020 23:27:43 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 23:27:43 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: [PATCH net 2/4] net:phy:smsc: expand documentation of clocks property
Thread-Topic: [PATCH net 2/4] net:phy:smsc: expand documentation of clocks
 property
Thread-Index: AdasuMLQwu8gTK1hTbi5zinJMHAWoA==
Date:   Tue, 27 Oct 2020 23:27:42 +0000
Message-ID: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67dd3967-7ccb-4155-f4c2-08d87acfe778
x-ms-traffictypediagnostic: CY4PR17MB1942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB19428264766CAB370C0B8258DF160@CY4PR17MB1942.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GAk70o7bBdFmGI51ef+W6VxdYPhHCzqazj88SL4nzb+YBYJahEXxG04h0jv5WVbHQoWxFiCu3L9c+BXiswvA9xOPcUIdoV6b0DiFr5wSkE7fLkkPXhs7BbIN908glDfA4HHMSgSyAVTHcNUzk4LZuxd8nnUd8xuvg062493V5iYxrnII6MA45lC58OrlCgMLTn+e1OSKLgbWnLT4HL9pyuMkKM6L2bY/GpflfkEuNyKUYz7uguIqDFtlPbbkka1R24sHsupLpqc/vdta0zaOqxBK7jWpNMI3LkbdPwqHGYX1LCiYZOk0WsLV3mJpkAFeIdOAgdvUvftsOoXfvkITxaFI5Y6G1p2HkztYbaQ/CjQHz0tTA5xpeg4FrkSeZvBs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6506007)(8676002)(8936002)(107886003)(9686003)(2906002)(86362001)(4326008)(64756008)(66946007)(33656002)(478600001)(52536014)(66476007)(76116006)(66556008)(5660300002)(66446008)(71200400001)(316002)(186003)(26005)(110136005)(7696005)(55016002)(83380400001)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: a4Fl9SYDe5vNXlIUWBaFgBo34LguwjCVTQH1pERH1FSssQhqkujJvupnWz3N5xPRVfu54FV6bx4Qqr6bjAg9OCW+OK0KMHQhQX6XtFxXYQCbuEovIPuwvTKF6m5Hv2H9MIooRomJRn38LCCEzxbF2lyKy8lIiXhVllHlV/dldRlZO4WSiNMqzX+t+lXdEqBiSkIiWjSooN5ERCtIAAL83GFUQmKtWRklZvXBd0jDPh2h6srAHqQWw1jpbjX4LLCuW79s+ZXWiuuoVz4SiStJgSRYjsk4SsBqdET8NjH6PMEeOrRjVn1ANtVYqCApvDUmQ7zpMso5npdZ0o+ePi87NI51k8C2W4bktz+x1C5BbGXqb1nvnyZbcmYe8ED/Zw1I87B579LlEIwvTAZikLSCUmVgRUC9GEdfGA2MULHEQEA2xoe+6xiolI8ll087OVMnZd1188H076wW3PBPEa4ySaUAw3pPvGHx8n0AdfQ5kn+hgEw8FVeJaRMeOf73kQwV5t3C77LQTu7s1v3uWLmFKuiwOJLQeXlNkcjPi+8OasyN2GupSo2/tal9tkotOsmfEgBJeOBxa60u3iVvf8ToRpSh/IJ0SyFScVlMoMNYAz41LMnJd3/wesErHQa3LzKQSoUhNPaQQBd9ShqEOJpC3Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dd3967-7ccb-4155-f4c2-08d87acfe778
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 23:27:42.1473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zfxuwSi5kUuzDY7tyXV++Zmrn513o/ZYTeEuVLfCEC0eWMhaZgr+gnY0V12bFrTf5tG8fpmMw0cgiEKtxlw+xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB1942
X-TM-SNTS-SMTP: CF3281C303C61BD91F07B0E59FA5EC96A0DD9A634DC07BA0A6691FCF37FE3EEC2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25752.003
X-TM-AS-Result: No-0.623-10.0-31-10
X-imss-scan-details: No-0.623-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25752.003
X-TMASE-Result: 10-0.622700-10.000000
X-TMASE-MatchedRID: e7Ukgmbx2cyYizZS4XBb35VRzPxemJL0APiR4btCEeYd0WOKRkwshyOq
        wscTp19+hcO8dxqn/sHKHBviWj0QRueYMko8W4p+SMFvyr5L84KWODD/yzpvdwdkFovAReUoilv
        Ab18i4hNRPtPOBofUBuIzP61JwVnOTLYGH8Cfo/Z/OBWacv+iVe3+MRAXdfV+QXAiEiGnHpMequ
        hyYtGyCGoxicOqF8/WsGfwDYJyJijlRxm3A2wKugtuKBGekqUpm+MB6kaZ2g7Ozz5Czo7K5yDKN
        ajSZD1ZUuHFQfPC1j9MqkIC6RTdc6APzvpM+0eLkAunsgPH2yPKK2F36qCo4YljK7Pk9krBgXtz
        1s9/uyYb+NnrrnzwGgZXX8DI70XVFwVtTn8Pj+qqUcpaEPPs/ID1CQ7wlvFu
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSubject: [PATCH net 2/4] net:phy:smsc: expand documentation of clo=
cks property

Description: The ref clock is managed differently when added to the DT
entry for SMSC PHY. Thus, specify this more clearly in the documentation.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 Documentation/devicetree/bindings/net/smsc-lan87xx.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/smsc-lan87xx.txt b/Docum=
entation/devicetree/bindings/net/smsc-lan87xx.txt
index a8d0dc9a8c0e..43f4763f0d3d 100644
--- a/Documentation/devicetree/bindings/net/smsc-lan87xx.txt
+++ b/Documentation/devicetree/bindings/net/smsc-lan87xx.txt
@@ -7,7 +7,8 @@ Optional properties:
=20
 - clocks:
   The clock used as phy reference clock and is connected to phy
-  pin XTAL1/CLKIN.
+  pin XTAL1/CLKIN. If set, the clock will be managed by the PHY
+  driver and remain enabled for the lifetime of the driver.
=20
 - smsc,disable-energy-detect:
   If set, do not enable energy detect mode for the SMSC phy.
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

