Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0088FF4890
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390798AbfKHL5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:57:46 -0500
Received: from gw6018.fortimail.com ([173.243.136.18]:59004 "EHLO
        harmonic.fortimail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390570AbfKHL5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 06:57:43 -0500
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (mail-co1nam03lp2056.outbound.protection.outlook.com [104.47.40.56])
        by harmonic.fortimail.com  with ESMTP id xA8BvdWa001123-xA8BvdWc001123
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=CAFAIL);
        Fri, 8 Nov 2019 03:57:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/51uaPiJ3x6KGjcZFIl3sZlAeLVQr32OPVXzSWFJbQLFPBWke0Lf5B73wqy64B3DBrLAyiwrVbPoZ+njGUM9WfRJvwMWVZT4BX9h6Bz6Wyvm0u5Oor2koFkfIhACuOQ1VwjFBI4NRIlO1FCscx9vv0u6IIN2+gpTML6+hsW4E6Y6IQ4voC0E35cLno52ddTr7hU1nKwr3vyLjBaFUM/QMADINZm0uCcYiNVAojEdULuCPUeYXVZv+byB9AqueVqT8uDor5wloNOVQdLzi6t/elbJmJhad9FYIbUcwvvVPp4dCdKG1zkLORRJRinh8gbOJZpxaNnxq33Pa735qmS4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CItxNYmVDZtXdycvdAxCNPQHm6zDpMlZHpE+bE+elQ=;
 b=A38xxj7llXwAAQJJMeR3692w8bjDukLQRk7jqf4otmM++atzueH4q80XltL4dFyR1yohMfLE4R9UQqQu3dspGUBdQJyuG6S+LULoQDtLCrCkH5wLQBtRufhvMPJyHvSj/lWj+jBAKvjWFlBgBhJ09blCSjmapD1aHjvuwb+6uXP62dxmVyu8jBKxgSZ7F4CcW2pMognqEZzBzHQFKh+ZsiZ1DD8qw34RjATJcAmHEf8YEz1epmS1frFBF2lFV1S3wXYb3oS43JWOsoDnY9Ord6Uw5+ojRwOfp92/g1zbKoyEb+rNuKKwwanLUl9RWV+i64YqPN2LvVY4Nc/Wl0XGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=harmonicinc.com; dmarc=pass action=none
 header.from=harmonicinc.com; dkim=pass header.d=harmonicinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmonicinc.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CItxNYmVDZtXdycvdAxCNPQHm6zDpMlZHpE+bE+elQ=;
 b=I5RIVC6aG+Ve+Thq3+os3JwYvzVZPIlA1IdGzRiuJdeUpO0iV4eAyOBR+yNghHxRGP4Y15IAkA44bZPzlYN1t1TuC4bYAVR5nnq9MJkjMGpDiYYX8Jb3JazR+OPa+HOOYSL93lXrxlfVrRDk7qcqNi1+9YvZXUAkHIEyvN9cCas=
Received: from MWHPR11MB1805.namprd11.prod.outlook.com (10.175.56.14) by
 MWHPR11MB2064.namprd11.prod.outlook.com (10.169.235.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 11:57:37 +0000
Received: from MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c]) by MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c%8]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 11:57:36 +0000
From:   Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
Subject: [v2 PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Topic: [v2 PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Index: AQHVliu2hS4tUfTZBUOOBuPSFgajHg==
Date:   Fri, 8 Nov 2019 11:57:36 +0000
Message-ID: <1573214249.10368.25.camel@harmonicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [87.69.44.145]
x-clientproxiedby: PR2P264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::31) To MWHPR11MB1805.namprd11.prod.outlook.com
 (2603:10b6:300:114::14)
Authentication-Results: harmonic.fortimail.com;
        dkim=pass header.i=@harmonicinc.com
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=arkady.gilinsky@harmonicinc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Evolution 3.22.6-1+deb9u2 
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66f0e999-3ca9-4c11-1cda-08d76442d8a0
x-ms-traffictypediagnostic: MWHPR11MB2064:
x-microsoft-antispam-prvs: <MWHPR11MB2064A5EBD100045987B60E42E27B0@MWHPR11MB2064.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39850400004)(136003)(366004)(189003)(199004)(2201001)(66946007)(8676002)(71200400001)(66476007)(66066001)(66446008)(71190400001)(81156014)(6486002)(86362001)(316002)(256004)(25786009)(14454004)(8936002)(2906002)(6436002)(50226002)(305945005)(110136005)(81166006)(103116003)(7736002)(102836004)(6116002)(3846002)(486006)(36756003)(476003)(2616005)(478600001)(44832011)(186003)(26005)(53546011)(6506007)(386003)(64756008)(99286004)(52116002)(5660300002)(66556008)(6512007)(2501003)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB2064;H:MWHPR11MB1805.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: harmonicinc.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ivhOPNSLJjiX1URfwC8BoUPiI4ddAV/NSZr/P8Csi4e+sD1TfQpvnbJg8BYQUcq/0uhKixmeLq7V5mtSf8aR1ZU1FpR+0549j19jjjAeXHqzCW4WA7UvNJ1bjBIqqkOMcJxeyxWZYx3/TCEhmTd/M/ZshGGg5RP60BA30fA8dbP8l0gCt5lAq90WflbJJIQekFthV/n8xAAdmUeV29/hxIx1sp3UC3u7Et+P+Sc4QpgCtWkBbM7v4FQVNNH+jNJ3P2QhOk8A9mdRmETdHVt56fX2hdOm1AYsXjhBiGb8ozC5q+OefAUxBJiTN2Zwq3mfAESXS6623WrWVjMOk8fFp/CDWvRLW3HlISU/B+XWh16vHcwuJ8iYr4FpqsMrKxIBhZ//brihy5XvykYqzseuN0o3askU8BH6WPjCGEfTVTaXrtFNfniG9SgFxKJSZomI
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <47ACD554EB3AE14CA7094BB8846B960D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: harmonicinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f0e999-3ca9-4c11-1cda-08d76442d8a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 11:57:36.3504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 19294cf8-3352-4dde-be9e-7f47b9b6b73d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykXQ8zv7BNkXcDPimvpixboZOAIrtrUJjJ9jAXIemBB4AmInBdiUdWZnBDD7hTGyMqXx2KMgkXNZDYN3YA3NSORSNF8cjXbrxKLwx1J84ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2064
X-FEAS-DKIM: Valid
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From af0e91423ea6ea37b48ee8b555314fd01964335d Mon Sep 17 00:00:00 2001
From: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
Date: Fri, 8 Nov 2019 13:48:03 +0200
Subject: [[v2] PATCH net] i40e/iavf: Fix msg interface between VF and PF

=A0* The original issue was that iavf driver passing TX/RX queues
=A0=A0=A0as bitmap in iavf_disable_queues and the i40e driver
=A0=A0=A0interprets this message as an absolute number in
=A0=A0=A0i40e_vc_disable_queues_msg, so the validation in the
=A0=A0=A0latter function always fail.
=A0=A0=A0The commit fixes the issue and adds validation of the
=A0=A0=A0queue bitmap to the i40e_vc_enable_queues_msg function.

Signed-off-by: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
---
=A0drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 8 +++++---
=A01 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/n=
et/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 3d2440838822..573252e9fb78 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2347,7 +2347,9 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *=
vf, u8 *msg)
=A0		goto error_param;
=A0	}
=A0
-	if ((0 =3D=3D vqs->rx_queues) && (0 =3D=3D vqs->tx_queues)) {
+	if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
+	=A0=A0=A0=A0vqs->rx_queues >=3D BIT(I40E_MAX_VF_QUEUES) ||
+	=A0=A0=A0=A0vqs->tx_queues >=3D BIT(I40E_MAX_VF_QUEUES)) {
=A0		aq_ret =3D I40E_ERR_PARAM;
=A0		goto error_param;
=A0	}
@@ -2410,8 +2412,8 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf =
*vf, u8 *msg)
=A0	}
=A0
=A0	if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
-	=A0=A0=A0=A0vqs->rx_queues > I40E_MAX_VF_QUEUES ||
-	=A0=A0=A0=A0vqs->tx_queues > I40E_MAX_VF_QUEUES) {
+	=A0=A0=A0=A0vqs->rx_queues >=3D BIT(I40E_MAX_VF_QUEUES) ||
+	=A0=A0=A0=A0vqs->tx_queues >=3D BIT(I40E_MAX_VF_QUEUES)) {
=A0		aq_ret =3D I40E_ERR_PARAM;
=A0		goto error_param;
=A0	}
--=A0
2.11.0

