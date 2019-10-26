Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95D5E59DC
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfJZLFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:05:37 -0400
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:56384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbfJZLFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:05:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvNrNg52wP2BFN2Jabr2DEfTixeN5lProcZZLb4Z5nTZkpnMzvilkHIoOiWhbDKUhjmMePm4PmWINQV5Z3crt6sIF6QJ67hwmodMIJRHpE5p7aGEjIqWO0lc9TBiuZE5zl1JT4ddbxxE3dzo2Cu8knoNdFw4o+KFqj8JhqZFxZQ2aVnoO1BJFx943RQ5wwsjMoTBmHU/3+tDQEqJPHwfaE/AbPREk+WrHaA/oOtAz1dd06xtfOy4ljajCD30XdYMtSsvoAKEckBuHmxecWdsAQ8++Z8y7D1n/8PzkXxdJ1vD7k4J7aWyMYS9sdnyQoGRX4l+4IEJKCBEM++pPmkX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr9IAjkKkXJznVy9U1lZHAqwPdSrGoF2P2Aex3WOWUs=;
 b=L1kqmcuMbfDCgUhZ47+04RUK95YUd0q2/TkualbL/o+Np0QbtGnMBtLVxllKN3YUgV58mojsPzLmz4jER1rO2Lrcbe9Vh44rFWAYN+TCCAOaDVVBuytakhC6zUCJE+rDAC0bhLT1Ya+uUojPtdXtF8yT9hRoe/CA6Km+bC4KjR+u+Z+ulDhlkomxqVqimdJ92S5zbRhuQftRo07HorpZlbapAyh2FeU+ycsFmplS7AclfaXvf5WlrwKkUTqNXcHn1fVOnnFogMvGIAF4DZeTHF8+72wZfcPS/FJMiKdGVhjWM5TSzOZUNJCHXMMHZIiaG/QO9K/dUavds14w0Isv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr9IAjkKkXJznVy9U1lZHAqwPdSrGoF2P2Aex3WOWUs=;
 b=QxrCpw5FTfB+jqXBNVV2sKy76D7FjtzOK1l16hYz1GbbX5G4xs9pHhKnLzUe2r2JIIEv1oiuhHMuE4OViCfSp/upYOf/fIoA/rul4RLSvZ9jZfAXb/QVixAPga9fY26zmQgNpenUKgCoHqHDMcz6suFwtI8jbeA3YzGP1VtxDMo=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 11:05:33 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Sat, 26 Oct 2019
 11:05:33 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 2/3] net: aquantia: fix warnings on endianness
Thread-Topic: [PATCH net-next 2/3] net: aquantia: fix warnings on endianness
Thread-Index: AQHVi+1JtCRJEZmLjk+xhyVdiVIfrQ==
Date:   Sat, 26 Oct 2019 11:05:33 +0000
Message-ID: <c3d9395d58dc76f2fdf2ad431bd5490edd2a794a.1572083797.git.igor.russkikh@aquantia.com>
References: <cover.1572083797.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1572083797.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::25) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2feee49c-405f-4391-09ac-08d75a046bac
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3587B67CAD37E704FF10B6C598640@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:107;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(386003)(6512007)(64756008)(66476007)(66946007)(508600001)(66446008)(3846002)(6116002)(14444005)(36756003)(26005)(76176011)(256004)(2351001)(71190400001)(2906002)(71200400001)(118296001)(99286004)(2501003)(305945005)(66066001)(6436002)(5640700003)(102836004)(6486002)(52116002)(86362001)(50226002)(6506007)(6916009)(44832011)(316002)(25786009)(8936002)(81156014)(1730700003)(8676002)(81166006)(5660300002)(476003)(2616005)(4326008)(54906003)(11346002)(486006)(7736002)(446003)(186003)(14454004)(107886003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iVmjN4AnvvW3KVe3FibL1A4+6t4mWBZIcWGN14VMPxsgSy4KEua2PQ542/9mY8VqyzwBrDBSuvtFO3OCvyIB90U/IXfal7wI3590+CLSXQbX5wZiD3wT6K5ab58uCi52ZEwTqqyzvOx7q+RwmGqzzAqTBv5ImjTvCaCE9LBnM3hBHGDiGq/+Ije/Z9ZF2MXbqPSVvSL8t9wb0JJzkzhJZrqDiXZwLJ0EzbGG6l33KlXdV+ZUHY3a0QV2EqQ19RPWLlBnve2EpNPjyp0PseG7gFgDY2crnaE9vOZGiTwqBCIa6dHZmLbREHoYzMjVVdASHIImCjrYWSzD+BTLmTukTtb9yJ6Y31jTqc2FigpOM6B6gPduDQiriBrN0OTSIeDqoIKCwoW0VBcFeYLQ3cnMUJ47M5M0RP5b/bhBRsn11FTsY+u/3HTTPRy6FKyq862T
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2feee49c-405f-4391-09ac-08d75a046bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 11:05:33.2038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NU0DsPHsuWKjZkQsqhIHAPj8UzYmP6F9t/woqg3s5FrPFONfz0lzfPPqVO6v9G5+wIjqdZYLGQf9f+CgTZGTKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fixes to remove sparse warnings:
sparse: sparse: cast to restricted __be64

Fixes: 04a1839950d9 ("net: aquantia: implement data PTP datapath")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    | 9 ++++-----
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 51ecf87e0198..abee561ea54e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1236,9 +1236,9 @@ static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *se=
lf, u8 *p,
 {
 	unsigned int offset =3D 14;
 	struct ethhdr *eth;
-	u64 sec;
+	__be64 sec;
+	__be32 ns;
 	u8 *ptr;
-	u32 ns;
=20
 	if (len <=3D offset || !timestamp)
 		return 0;
@@ -1256,9 +1256,8 @@ static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *se=
lf, u8 *p,
 	ptr +=3D sizeof(sec);
 	memcpy(&ns, ptr, sizeof(ns));
=20
-	sec =3D be64_to_cpu(sec) & 0xffffffffffffllu;
-	ns =3D be32_to_cpu(ns);
-	*timestamp =3D sec * NSEC_PER_SEC + ns + self->ptp_clk_offset;
+	*timestamp =3D (be64_to_cpu(sec) & 0xffffffffffffllu) * NSEC_PER_SEC +
+		     be32_to_cpu(ns) + self->ptp_clk_offset;
=20
 	eth =3D (struct ethhdr *)p;
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 37e6b696009d..ee11b107f0a5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -41,7 +41,7 @@ struct __packed hw_atl_rxd_wb_s {
 	u16 status;
 	u16 pkt_len;
 	u16 next_desc_ptr;
-	u16 vlan;
+	__le16 vlan;
 };
=20
 /* Hardware rx HW TIMESTAMP writeback */
--=20
2.17.1

