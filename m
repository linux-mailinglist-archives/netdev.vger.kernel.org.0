Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CBC94C11
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfHSRwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:52:50 -0400
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:35234
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726987AbfHSRwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:52:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHS9JZ5dMdcsP/1mlefLlihqki+MlHrUji8EVkS0x+A5cYccQkgsIP4M/erMObsr+EixW4XQtmxUOqQDSudnlBVd91cKwgkpi4EurABvJ3EIzU8kwYmj0H3uc8j8W9DkRi91zFXxx649dpoLVNYP2Eq7Yl6v3ADs1czs8rJNAj3ocQFu2vwjyPB77ExvlBHtNGpNhMoXAuZ4xk667Gq9pTgGOm8XG/I3gtmFbFuIYj7gVRu21MizpGg/CcvRhJCLMAwWM8Kh2w2CMAEVhREiex+huBk7dpd6kyMuuj3yhaoi8rDAHdiWPHlGnErdvashlQASFfEc4sqCiYEONgai5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZN8exIZxQJNoy1Nos+vfOC/4wouVSNGEb7Sui+svSY=;
 b=Lo1kpCtsMANW80R5WPjG5gNGyqiBZGw+XTGj4ScsKbddGs9k01RLP6MT7oc8l894ZaE0Gj4K3IOMqgecm1QKZexX64842xjd4nfafLAu6m7HMy80p5EtgPiAVTE78dnHIF1q7WS6loXrH3WQFCs1Hk6YYylphxGMsTfQmQkFWdIzylK5a/wLZ7c2jplAefR3qUt6djcVXeMpxUAgdkyU/Ha26+Aq+R+1LmP8Jdod+mGd11aNK3/fu5gz2AyWdPDxbMl3MokhrCl1BMKc3mZoQTUfcaFI+sfWWrhbxMyRs9qGBuwvjm1KMMiTWefTXvrCPTSBIe2JxESeWvVWGXuFAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZN8exIZxQJNoy1Nos+vfOC/4wouVSNGEb7Sui+svSY=;
 b=sJIbD4hOnmz/PFUrxGqxY00Il0JzaXpIbt8Hzv3Bn/2HhGn+iIx6fjF+c0dFWKcC++6Yd7IbGOLlXuHqFbDjCEXl+1YlQXzvw+RDTp7kIu3Q1gZzo6blilr0gzi6QxvD+UN9Yo5wtc/Q8muvadmhhfeRKYZqK0htq9Z5S5oRTj4=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2710.eurprd04.prod.outlook.com (10.172.245.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 17:52:47 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 17:52:47 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Topic: [PATCH net-next 0/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Index: AQHVVrbp3sXqlhaADUOxsnFHbVKf3A==
Date:   Mon, 19 Aug 2019 17:52:47 +0000
Message-ID: <1566237157-9054-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0024.eurprd02.prod.outlook.com
 (2603:10a6:200:89::34) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9eddec7-daad-4c68-6d2f-08d724ce0b92
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2710;
x-ms-traffictypediagnostic: DB6PR0402MB2710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB2710CA41B3B866910FE3A8A18CA80@DB6PR0402MB2710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(51234002)(189003)(199004)(71190400001)(86362001)(81156014)(66556008)(66446008)(478600001)(386003)(53936002)(64756008)(66476007)(3846002)(81166006)(6506007)(45080400002)(110136005)(55236004)(6512007)(8676002)(36756003)(6486002)(14444005)(14454004)(316002)(486006)(102836004)(66946007)(6116002)(25786009)(476003)(26005)(6436002)(2616005)(5660300002)(44832011)(256004)(71200400001)(2906002)(186003)(52116002)(2501003)(7736002)(305945005)(50226002)(66066001)(2201001)(8936002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2710;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Hai028OxQ64N+AjXVfuduTavG1FIEvbUUOllVnEYMzR4nz9lbadUkN7+lRbF/WdamRhz9SYHliSFfGzjV6n7t6v8F0COsi9qFH5i2x2VRdP8haKOUBz+JoiRS6PXAvFlGWVZ6gVWXCr53x6/yT0QzcSeHyn179j/EuBqbem+iOkHwL0nB8tmKikR6nvz9vKOVxl+1E2BthyaTogxmlyEuMmezR3rktuGgvTESmk3qBjv/T94YS/NtmfQLWQujTJTZb+9AZ0v8GTqoHHVlUBped7hpQlHtdVhSHdnGviC/MJUYaVEcq2eJTG6lE/KUv9TAtIpoYtE74R1cUM3bRtKMBcn28LIE2y97/lNLSH/QicPT8PQbtnIG70H8dNSZNWhD231Hx0zAt9KO5lWRehVR7vOaCbCVwPAXwi5BuPBjDk=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8DAFCFD3E105234193FCAE8D599788FD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9eddec7-daad-4c68-6d2f-08d724ce0b92
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 17:52:47.4082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P4/g17tG2+Dj3mdAVg9QdskdKHdm8Iz6MfEray/lElyLKFU7XLKyTmfu0ZjN9QbKwun1WpSHXXunSqp4hceCeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, using a Clause 45 Phy with the "Generic Clause 45 PHY"
driver leads to a warning, similar to the one below, as soon as the interfa=
ce
is brought up.


  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 146 at drivers/net/phy/phy.c:736 phy_error+0x2c/0x64
  Modules linked in: fec
  CPU: 2 PID: 146 Comm: kworker/2:1 Not tainted 5.3.0-rc3-NETNEXT-00816-g48=
e924c73178 #20
  Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  Backtrace:=20
  ...

This happens, because the Genphy driver does not provide a config_aneg() fu=
nc,
so that phy_start_aneg() ultimately fails such that phy_error() is called,
producing the above warning.

This patch adds the function genphy_c45_config_aneg(), which allows
phy_start_aneg() to work correctly for C45 phys.


Marco Hartmann (1):
  Add genphy_c45_config_aneg() function to phy-c45.c

 drivers/net/phy/phy-c45.c | 26 ++++++++++++++++++++++++++
 drivers/net/phy/phy.c     |  2 +-
 include/linux/phy.h       |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

--=20
2.7.4

