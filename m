Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6EDE59DB
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfJZLFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:05:35 -0400
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:56384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfJZLFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:05:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZM4mm1a3Fvm0W+qid35cEnOg8rP8wXqyNWkSiqENdruWaYtm9AWCuRQLidhlQU4c8BC+krQlNhKpC17NFFIBa6LJyPsFYFIfoeLcfETedymSXG7SN19CeDgXXDujucCYIk4rrTdW3LfMr6bAUlf9TfQ6JhXc5Oj1u2n3WLcGGsLZXPnR+Clejoog5opCoMu+COs3MGoPifXWueXgSXtaLxXA4AaLkpWhbZ9/b1O86RlUVyxv/kYH1KS1RuyIOGGnBYhVoF98aEwfyDOafYSSFzStc7Bx2QNdt4xCsFCUn+i0Pdv8S7KSnTPQU6LkYZusWiXXOgzbPhWWqHnwB962GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jp+a7pWL/Ktj4atHN0eck9qYvjBh6/jd2DYB1leq00=;
 b=FdIfGmZHXMXwB2uyjDteZutjjUkqmiPSFWSe4IMqhksSUl31NXkatdOHLOPEIZjR4n/04XF5GfzrrV5cCR35tfUAGXsBhLzMcI4zE2jhGZkbDWfIIKo88Ls2Y8sWdNgS8WQ/HnqJ1q3HaL3hp8GyrorppJCgGq4Ev3fUTdxWQYdHtSm707xZmPfh+9oer7S1Mnts7tXyHi4Nj3fRDpkyqoharmsaKWw5BjaghpZtrSFdcRxNcZoKRZH3PFuaIxL7aO/0adpiVmgV7Z3rZ3d4ZvjViV4nLAYgLCwlBKHKc+OMOxTbZnP2mEeMHDZXXNmDsh9aq24lxwipzJZeCJiqPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jp+a7pWL/Ktj4atHN0eck9qYvjBh6/jd2DYB1leq00=;
 b=btcop3hy4S99FvcZcu7U8cO6oQ811FFzmQd69FEzl76PLt+6zI8FUgrTJ6sgxC3po9HADzEIjaD7UlINtmvfpW6fdXR0+p/yuV7dvSErCkIqIhIhaJf3i+yzAQt1s1/6meqLnsUDD1UXHFznJeL7065tdXVjGKnUdWhRk7CSvd4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 11:05:31 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Sat, 26 Oct 2019
 11:05:31 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 1/3] net: aquantia: fix var initialization warning
Thread-Topic: [PATCH net-next 1/3] net: aquantia: fix var initialization
 warning
Thread-Index: AQHVi+1IT3BCyR2ukUyS3Wr2Tg+5oA==
Date:   Sat, 26 Oct 2019 11:05:31 +0000
Message-ID: <6774fe94ba8098e2ce6038556f1e038428098f1a.1572083797.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 6141bdbd-843b-4bd1-78b2-08d75a046ac3
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3587062DE2D9B0CB068755CB98640@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:19;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(386003)(6512007)(64756008)(66476007)(66946007)(508600001)(66446008)(3846002)(6116002)(14444005)(36756003)(26005)(76176011)(256004)(2351001)(71190400001)(2906002)(71200400001)(118296001)(99286004)(2501003)(305945005)(66066001)(6436002)(5640700003)(102836004)(6486002)(52116002)(86362001)(50226002)(6506007)(6916009)(44832011)(316002)(4744005)(25786009)(8936002)(81156014)(1730700003)(8676002)(81166006)(5660300002)(476003)(2616005)(4326008)(54906003)(11346002)(486006)(7736002)(446003)(186003)(14454004)(107886003)(66556008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Cl80aH61VaqnBEdUWJFBGTNy0Fa6lUgBbnOWoiQn+oN4fmd6nNw92GeS79tf36YNhFQNYC+PzKFkNIHCIv1x0iXXjl149Jug2eMXLJv3Nad3yvJ3zGV3hhnsRQBqpMkFcZ2XoP/8B0Bwdxs/qDe8CVQkdocI12DCQjPBhjB9FGwdO4yCxNpm8wuZrLKF+eiLjFiS4lzc7evvTl+E/XuGoI0eAWsRqtqf+g9cVXDnmPyX51xA0i8PwzL4nceRVPGohZsKdq8W/MT2wjjbDXB7DbxVT+7hkGJap4CJxem/wwItLHuDqG2J5IyFaDQk1baj98f7tvyYCt1NHC9H/VTNZqSWnVSzjzdfIRRu5pWd21LtYiHOiH4IFFUAcX8jhtPWpysoV9o3VoSBCORbpBADtAYaiHimqhBacmv63UzzA0IO/HnvwwaRMZhyB9SjVPb
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6141bdbd-843b-4bd1-78b2-08d75a046ac3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 11:05:31.7316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hW2oc1wsAJWz5e7IPSgjQGgGjUQOEuUM71IjfLpVdMMQyUAzwMfqGDd+MiEWygd8gnY66tcithIE7hZq+D4BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

found by sparse, simply useless local initialization with zero.

Fixes: 94ad94558b0f ("net: aquantia: add PTP rings infrastructure")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index 3ec08415e53e..bb6fbbadfd47 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -947,7 +947,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
 	unsigned int tx_ring_idx, rx_ring_idx;
-	struct aq_ring_s *hwts =3D 0;
+	struct aq_ring_s *hwts;
 	u32 tx_tc_mode, rx_tc_mode;
 	struct aq_ring_s *ring;
 	int err;
--=20
2.17.1

