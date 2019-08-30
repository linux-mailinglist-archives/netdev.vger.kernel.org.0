Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813E4A365F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfH3MIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:37 -0400
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:8016
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfH3MIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMHOKySD3dpGDuFv0wk8zBW6zDHHVWMHEX8qNkVB8GEaqDmGSd0UV6Hd3GMlDjzHpFx8Yf3G7IgmbQwA8l4L8w6leLjDojulkKB4JN88GU/iyuKYSdR4DctNjTAQCyXwekLmbAgJw4TO8hjpWiJAC3uVFljsuyuuvHp4Ls/kwErkt/D0o/sx+W2JZQfFelyOKv4SLvr5FPyTltmLV+EEZq2ubOSO7eSZjUu7J3KHCUTb3RLNzAJlJCJrBOFulz9HnA95emt06T9AgDJaO38P1CLEa3f5EmtE0TW1CsGhNy1yo6sf+smXh/nYw2SeM+cCFOC2BOiTc5tgtyvqEbDhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Rl+gYPA2PrLODrcHpLLhSPk2B13H1CQGx/6eSNrFMg=;
 b=LuvSGvSJ6w+mjpaAGBL7hwMoUzScfoNXJl8mNcuv3IdWrS35LSylfTFRPXrIByqCsVutlvj6b0Rbect7XKSRDdF33FnTFeehsVaa8DS3P2hdbDgUgwBw5oRilo+RqgCkJmGXjrgNEtg82g1XQXZQFnkXMW/8Cu7a9eEfEq+t8OFuGbfZ77kVVxBM+Ew6jkh9u8oJjBNYJvWlPoK62Se68BgS0cKv6V9D56Ik86TU2q53jUSMJMZSPKwkNf4IlHodfieOaYVgcwX41wJwsLYRD3CGohNNj9eN87xuw5VWNVlICLtz7koUsrvi4LXqtDLXXTQHSDi1RR7CtmA3mBnC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Rl+gYPA2PrLODrcHpLLhSPk2B13H1CQGx/6eSNrFMg=;
 b=q6FQ3N0anMM8Py5Nv//eG+lBNs4XYZc0vJNmqwu4p9NVorCBMHTkgLxuSowlCE8+HwebGRZJSMoKiH8xhJiCZj71HSSXVZsZkVobXvczezk9MRtLPRKelWaxE30VLGuYmLsi8L6zwVXxVINmAMl3+XlwM1dv7l+4/M05Fyj2d2Y=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:35 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:35 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 3/5] net: aquantia: reapply vlan filters on up
Thread-Topic: [PATCH net 3/5] net: aquantia: reapply vlan filters on up
Thread-Index: AQHVXyumGvZ/d+9cU0+cZHzBe31Mow==
Date:   Fri, 30 Aug 2019 12:08:35 +0000
Message-ID: <e555196b06b42d7a72c9c57dac1d736907ab779b.1567163402.git.igor.russkikh@aquantia.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1567163402.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0012.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::22)
 To BN6PR11MB4081.namprd11.prod.outlook.com (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e59d711c-5695-44bc-9d05-08d72d42c84b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB16846B963F3CC2C7F340A04698BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(76176011)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(11346002)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(446003)(118296001)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RM8oDzeN2KD6/OeR51983HPmIfeOe2NYSlijbV6X6sof8DiI+sTy9F4tHabFvNnOOv1leOcX7tNmzevq5NZdpJrq2z18fPDh8vi5cMxtRGHfAbKxgxEfbL2pmHcGK0KDrOuAshOLtUsWb64Jf3Gh/0dtc9s83vny1YSGhqTqantwfyZRBFQPL3k2Bnq+7JJWxUhWwhpf8m8YFrkekGE698HTZfUAn41IeqEUPKbHdwKAMlPp8asY3lua4+ZJqIsh1hrGnKFRM3nPJ02/uCZLD++6zq+ibpv5Ln4Wr81whdq2H5wgKUbE6yFr+hQLOQW7kO0eyPBTUlRIGLWC5RROubICSIAjdjWIqvxRvtTD+e0fcBDmN4fBmCfCsGQiabycJULTNGJPBw7s/rcY9edRdgdwhiLEC1B+DuGhWlPkIwY5tdH6+axnKETArm8Q5svEvjcZQ63GsGNl3sAi+2jwSg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59d711c-5695-44bc-9d05-08d72d42c84b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:35.1822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TFxfrtE0u13SNCh219t0Jj+p6evaNpTNwfYCWb1IYfTujgm2SWr8GXxciO1j4cC/tfDOmiJk4GFuUN8nuYw3wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

In case of device reconfiguration the driver may reset the device invisible
for other modules, vlan module in particular. So vlans will not be
removed&created and vlan filters will not be configured in the device.
The patch reapplies the vlan filters at device start.

Fixes: 7975d2aff5afb ("net: aquantia: add support of rx-vlan-filter offload=
")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index 100722ad5c2d..b4a0fb281e69 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -61,6 +61,10 @@ static int aq_ndev_open(struct net_device *ndev)
 	if (err < 0)
 		goto err_exit;
=20
+	err =3D aq_filters_vlans_update(aq_nic);
+	if (err < 0)
+		goto err_exit;
+
 	err =3D aq_nic_start(aq_nic);
 	if (err < 0)
 		goto err_exit;
--=20
2.17.1

