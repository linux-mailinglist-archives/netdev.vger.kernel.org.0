Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179F9A365E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfH3MIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:35 -0400
Received: from mail-eopbgr820084.outbound.protection.outlook.com ([40.107.82.84]:11072
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfH3MIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuR2UR5KrPEZ4ewFiqj37bpl54v+2kveGqxKHOln5pbA9sovydSf/26C8HuqrokXiKnrPtbpROT4yVNPIEH29a9aWqrj7H+m08SrONVDZRwwvn71Rn8jotkUEqMTqwpyNJxWRmrga/ZSe5NtkASQyvsdAJMhORegcWUjv0g0ZFFMN/1WQrhcFIZj/2mkiOnD5fUw1MuqhKmmg69+Y8qjSiEUi7RPc3fy783b5KtANFFrAlwzYY4DTks2jS7C/1b5In1NjcBDZOIFXeV73y1a0ImIlyVC9jQU8pudx7qsu+X5u5/NLWAeoz2S4hzdcntJlIe2R2jVZ8grSEBmwVPkZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGl57bmGZ+9SBa2eVnexsxM5S2aue84Tg8uYJNvGGcU=;
 b=hOMdrmPD97VZJ+wn67MUocQapDCR1gGYCpc0RknzXB9n0hfqscvHj61BzPsfPgxFX39D1MHtGEXe7BKNNroIfo5nd6ITfVrGf0sRGq4raCownZr8DVZwHuqDZ8C6A0RFHTdir11LJiR+WVfpFuRfkD3xN7Tibcq979TTuBIzr3haJvwjBUCnfqkdTHgjny6plvNI/4wLdpSQ+Wktcu2wKdn+Ui8KOft/UpnflSyZgag9HWBbBsvzJj2jcdF3wG1prZLfF+vlXmuDFZCXEW6pepEgu2jAnsXHrDGrNY2cHLXBm58hVW9bqmAzq6EYilcqP0L3BLlsZhv1bAySEndNnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGl57bmGZ+9SBa2eVnexsxM5S2aue84Tg8uYJNvGGcU=;
 b=nWrwvLJI2jqTIzampLr2+D2ZhsSO20wyuo4IkFtz2vvWMhk45rq8J36PUv4UadrSRuPDKb7CCZb29K881cVbNGbOsQi2iQKlekfG4KXXvte5NW6sYJEyhh9TLiOBgbuTTu1Obkgs3gjzvDpvYAd3QCtb3+ijKWB0iKhoLFSa7lo=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:33 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:33 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 2/5] net: aquantia: fix limit of vlan filters
Thread-Topic: [PATCH net 2/5] net: aquantia: fix limit of vlan filters
Thread-Index: AQHVXyuk/ABQWm2y/EO17sdAD77/hw==
Date:   Fri, 30 Aug 2019 12:08:33 +0000
Message-ID: <08980a3dfdb000281344ad45820e2da652ae0b51.1567163402.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: b5d6cdb4-6e24-4384-8aea-08d72d42c6b1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1684DCDFF4D3F94C2CA7DD0198BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(76176011)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(11346002)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(446003)(118296001)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: md6qeMerp3zbniLOT/8HizZMp01F8OenCuKZnT+Ph/mKtSUloCJuWG1TuOclcxylc++HfMZJf/MjRY066MsiokwDAZG+ZkU2YI2CjAl484UBxFJ+GnC5nOR3JQkYq0Zb9j3ZRKOdgWm0Wdu+59Q1326ET0jOjVRMkz1KuBD612g+8BZwNn5C2LW0v9r578gducTtFxok380xyR50uEZ9K5qCBGPqKyUfCo/bkCGIw/P4WbjR8DDE3cHPrDyZIfZteYWQU9+G39R387ySgWtSipxauapcj+x7JH2FxZw/TdA3rpVGtWhHlwcNa3GQ4DiMwqeWDhwgHe4nLQrMPcRgxEucoVAHfZ0WQXOx3X7bjF6qBOZnGrBz0uYmr6VReloDhZ6ACKCtEVtSFJ+25oXmH+Uizh+tXVmKZJpI6SyqtAVrT+nic3lQK7r1M7qgd3jByQfRYG6yhCoZ75A6QoYS8g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d6cdb4-6e24-4384-8aea-08d72d42c6b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:33.1384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUD/T+S9CC2u6npwgcyVeFcyetciWjrX5LRALcdu+WGD7/fvbjDlYPKFjhh3ixo6CPYOVUKujf4BIVugT2Gvig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

Fix a limit condition of vlans on the interface before setting vlan
promiscuous mode

Fixes: 48dd73d08d4dd ("net: aquantia: fix vlans not working over bridged ne=
twork")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_filters.c
index b13704544a23..aee827f07c16 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -844,7 +844,7 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 		return err;
=20
 	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (hweight < AQ_VLAN_MAX_FILTERS && hweight > 0) {
+		if (hweight <=3D AQ_VLAN_MAX_FILTERS && hweight > 0) {
 			err =3D aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
 				!(aq_nic->packet_filter & IFF_PROMISC));
 			aq_nic->aq_nic_cfg.is_vlan_force_promisc =3D false;
--=20
2.17.1

