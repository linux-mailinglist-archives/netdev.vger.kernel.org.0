Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBE1D2BF6
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJJOBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:01:31 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:63120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbfJJOB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxjqX4TJc/fuK1bgLyYHhMa7LbFc5PVTnLAhUCDojN9y7ksFsKpPtlirHEQ+bTencxiqTdO2FmdjJ7/N/VHFN+cRBogEirKOjzXNJ/VpSqzCGiaRSznaeKxJtzbrng1BPr7e+oSy97dnJpTOdkEEqsar/DkbJY/WPKVhXFzV2jU6P0+mcwdXiWMPPGNtzjeI3kG9xyavLx59ZPObUFeOp1rRZYbXR7xVZ87QXmy3ScFJ+gNSlwEPOhhh9m1Fb5as/vVClK/+Zd8lX9cFS8iArywbE/19eCpkPQDTo2wNVSDJC6Ep/R/2LRiYHpjsRCZH5xpuNaaNCBSd/9XtfNlUIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN+4ua9wVV7rVolW/Ua5tc/901+RVksG7RYMzx6/Kcc=;
 b=P98k4OjvZF7FgLnsulnqsR+YzYjcWUyzsLUKXCvrSxHQGfEBRoHn1GASkRyYC6h6Js0ikLd7YpNgC9UCeR2YaxrwwZAkOwmPI8asJQPvCyr6qLnjnu5Znxue0kpZtPtxzaDW/j17zoqVfWN6Ey0nbBev1Mb6lAZj4VM7L0B3W59L0qYsfe/GVkWeH06tyJE8NIvcv/eluoCAnNhgECFZJKxfB9OMSTcNkK75KMk3U74pypGGXr3QLsrwrCuGfHacJirZYUKLGzVxv8GcbnvwxNBVHRshbKiaXRrQWAqCE9lU5IaXWdKUZOtf/DE5DnBVhKW+ojKVhzxT8Q7WXDEAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN+4ua9wVV7rVolW/Ua5tc/901+RVksG7RYMzx6/Kcc=;
 b=aMVl7VbegTqBYX4bnghPZocTi/1cznnv3sjB4gisWXOykJZx51Lw4nXjI0KeSdxHijbRFFoRLss8/eDQh7TN4fV++aNmRfYO1Gzkt7GEK/WPdg9Pb4tCzLtGtSMjOu0PR2OWEXRZIF7F/6GrbldmXsjpx4IV3fQtOB7WoVrkY94=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3779.namprd11.prod.outlook.com (20.178.220.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 14:01:25 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 14:01:25 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 3/4] net: aquantia: do not pass lro session with invalid
 tcp checksum
Thread-Topic: [PATCH net 3/4] net: aquantia: do not pass lro session with
 invalid tcp checksum
Thread-Index: AQHVf3M0ebCMvPl4nUaJkTfsga4ZDQ==
Date:   Thu, 10 Oct 2019 14:01:25 +0000
Message-ID: <7e7176877b703aa5b8d819030983691f1733d3ec.1570708006.git.igor.russkikh@aquantia.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570708006.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c65e4cc9-3375-4066-249a-08d74d8a5655
x-ms-traffictypediagnostic: BN8PR11MB3779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3779B3B3D75DEA1870C7BD1098940@BN8PR11MB3779.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39850400004)(396003)(346002)(376002)(189003)(199004)(66556008)(26005)(446003)(14444005)(64756008)(476003)(6916009)(8676002)(14454004)(81156014)(81166006)(1730700003)(4326008)(508600001)(36756003)(11346002)(2906002)(66946007)(186003)(66446008)(3846002)(66476007)(256004)(107886003)(2616005)(5660300002)(486006)(6116002)(6486002)(25786009)(305945005)(7736002)(316002)(6436002)(66066001)(52116002)(386003)(118296001)(99286004)(54906003)(5640700003)(6512007)(44832011)(50226002)(102836004)(71200400001)(71190400001)(2351001)(76176011)(6506007)(8936002)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3779;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3SHY7zUQU91aJE9Ru12jstmdEVdhKXumjjVg2MJ6vkzWYY52klwhLObwI9smJBhEDZeE8p4i1pd3oxjACaFxD5GMJlOlSYFxCToaBHfGg5RYv/x9LW6+LqI9zK0lJ3jkctTxNF/n7qnw2xQ647CnA3SMCHD7PA729JAMH4Lv+OZOMGCMMIyCJ4okYQis3JUq6VcCPriAoesR5k58nnMFG9j9uh5siFv7GS2vSdIg0rx+UNF6HRm7bTdtm2qCo2q2kzTaekQ70aqg6mCxHIruRWBJ5s4Q+j06uXl/J0xM7B51dPZw9UV05nQmUJcVBCNk6QqvTZoquKEvb5maypZ9xs/fW7McwFsy9m9NrWW3cYe6+PYr79AswD2KXR8HlwBFyE7Z1EYFeR+GUm8a0hsHMrmGohUHc1YsTCxfeouAWQk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65e4cc9-3375-4066-249a-08d74d8a5655
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 14:01:25.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xxA1VpZVQTvn7c0/4+J78esL/EwVVlxbmksa5ks8qbi8tHFddItnS4IZvqllXOrvSLDXyfRavu+E3eP7kyblaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

Individual descriptors on LRO TCP session should be checked
for CRC errors. It was discovered that HW recalculates
L4 checksums on LRO session and does not break it up on bad L4
csum.

Thus, driver should aggregate HW LRO L4 statuses from all individual
buffers of LRO session and drop packet if one of the buffers has bad
L4 checksum.

Fixes: f38f1ee8aeb2 ("net: aquantia: check rx csum for all packets in LRO s=
ession")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 3901d7994ca1..76bdbe1596d6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -313,6 +313,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					break;
=20
 				buff->is_error |=3D buff_->is_error;
+				buff->is_cso_err |=3D buff_->is_cso_err;
=20
 			} while (!buff_->is_eop);
=20
@@ -320,7 +321,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D 0;
 				goto err_exit;
 			}
-			if (buff->is_error) {
+			if (buff->is_error || buff->is_cso_err) {
 				buff_ =3D buff;
 				do {
 					next_ =3D buff_->next,
--=20
2.17.1

