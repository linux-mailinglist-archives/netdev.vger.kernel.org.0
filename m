Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F591493F6
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 09:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgAYIHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 03:07:06 -0500
Received: from mail-db8eur05on2110.outbound.protection.outlook.com ([40.107.20.110]:2753
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbgAYIHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 03:07:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQLv8OgU6WSCHTBxb+A90W5UwCZi7it6unYFPyrjdAh75MS5wAIN8YNQBPSX/phJIc/94vtyau19rsYSqyOx+YcWAGwoSIZ5Z1JyZFFB8SYZ8c9aM5QbhOrNqpcI9Zfe37eNzBdg6tgSey3yX6ZFAJzeb4L9cQ+2fJ9nGrCC7K1fDIZTe4i/WUhgOfh5GW/WrkvkW19MhGCC/zhrnd6T1rBr2J9juWmna5pUtU5wFMMXOHFLkljuX/viEaJoqsULVAWlKV/V+D+ndrXWPgivayojzJjbCTCZhp4WXe4WYRHKM+B/IbzkzUFoZ3VteB4aZwh8QhPV9WtbscpiMci65A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jWG4qdVCaydfIb3gvC6T3KdTVW9QRIzlhFSRLCFyPY=;
 b=Com0oHmYSc7LLnH+AdbqrOuUaj3eYGqLVhqy6WjJpfnzdjiYG/UV+bVIq5qzupO5gGMhJuwqInwChkik8QAfjms22nQaEYzgauT5Ae76moaz+wF3/+IJMtzvjzcXOAhYUU1a201YDFjrKzgrKc6LMdsA7yKRhucuWlrkH4j1EKQfyz2IpABwpXbbzt0AmvJ1oCBOINmyJLYB/F1h6ELs63kT9V4xzPGF7eCuPnNUpYGoYxffQ0qM/lNB44yBcK8JechOulcXnY1ruPjgbgBwBm9lNx0R292yxKeq7Kf3QF7t2852D+Bp6Pc2zpfWCNOYZGJ5YHF9m3qbc7o9DHcq6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jWG4qdVCaydfIb3gvC6T3KdTVW9QRIzlhFSRLCFyPY=;
 b=OmJ2gI43O64bSHeydZPqS6BIuvxW5vVCiWmRawjZKLQY6emJD/52FXUe8iz3yC+1q+YaZ7tSxhZLFjiTX/L56G4PZs3z5hBDgHgidm+4Funw5bn0iYTDTtURYYuaKC+Xe/3xJPuHFzLCjErPKeYmySGZFX7u7qTLLQFFKW9jENs=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5684.eurprd05.prod.outlook.com (20.178.115.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 08:07:04 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.017; Sat, 25 Jan 2020
 08:07:04 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 08:07:03 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: [PATCH v5] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v5] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV01Zt85Jc6nz440+eUwbZXq2o9A==
Date:   Sat, 25 Jan 2020 08:07:03 +0000
Message-ID: <20200125080702.81712-1-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.1 (Apple Git-122.3)
x-clientproxiedby: FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::11) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5935dd57-5ec7-43f2-334a-08d7a16d902b
x-ms-traffictypediagnostic: AM0PR05MB5684:|AM0PR05MB5684:
x-microsoft-antispam-prvs: <AM0PR05MB56841997E4AB2738BBCC7963EF090@AM0PR05MB5684.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39830400003)(346002)(366004)(376002)(189003)(199004)(316002)(1076003)(54906003)(86362001)(36756003)(107886003)(6512007)(4326008)(2906002)(6486002)(508600001)(8936002)(186003)(956004)(81156014)(26005)(8676002)(2616005)(81166006)(44832011)(16526019)(66556008)(64756008)(66476007)(6506007)(52116002)(66946007)(71200400001)(66446008)(6916009)(5660300002)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5684;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UIPnRK8JoBhMYN8mu6RlDX1gTLDIlyUUrk84h6QaSPh6vDwu5LdoQN9xDpC7vYWKxN0HDrNO9Vml/8gZXgtHfLm3QtLyleZC8xJotRo7cU+hAwf+XPShMP3hv4M9iI/kPMOYa0dW1+eS/Eaz2rbJgeeXblspmEJU1KQ8gCY5NW77eDaXyYuTGR2EtELv4E2r768yW3qvFhKKKQTMjrdDGTKD0q903X0Q1Tc2Rq3AfFHYkG4Ds8EwmrWMdxBb18ZxMZvid/IyYQrySN+rtBZiP1aGjw0rSkqd32Q50sZp/YZiAYuO4jLrv1MmDtAPjNIy7Zzcu36846I+OrINCEeVPOTBQUPPhoTEQGoWmhcJh1tOWaQekNYPyd2v1z+4MfSNLjysSkzYZjqZaCOhAlT8nDQ4tUctIvvCThXDcZm0XSw6st9/SVEWDFajsEJo92DbsGFnyKnM7G14arjALC7EUbBOorxeMAPJ0+3/jQ6rayi2ZsUe16wZptJZ6B5m1q9y
x-ms-exchange-antispam-messagedata: INU6Az5yOLgn9yjJCa6qMljxS+cNRZKnOASeh0zgLe6DQhp+nwNJABXGqZ1sW8xm8o41qI8N9dkislVBU3MtJRqKjWgTw3TVMIKu4KE9Jf6qs11EWpcACNnFHXlOp5l3uvVlhsMOvNjxA/1DgyKkGA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5935dd57-5ec7-43f2-334a-08d7a16d902b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 08:07:03.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KjUw7GHYTl4M43gLwPKYnrs/6uroak0/nUovt/vG3s2eTJdu+rRI+p3BrYQ8UHB7VErvm4QcG9SG1xY9qKEyx+b6QKKL5y5pfSzEhRKt7Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently XDP Support was added to the mvneta driver
for software buffer management only.
It is still possible to attach an XDP program if
hardware buffer management is used.
It is not doing anything at that point.

The patch disallows attaching XDP programs to mvneta
if hardware buffer management is used.

I am sorry about that. It is my first submission and I am having
some troubles with the format of my emails.

v4 -> v5:
- Remove extra tabs

v3 -> v4:
- Please ignore v3 I accidentally submitted
  my other patch with git-send-mail and v4 is correct

v2 -> v3:
- My mailserver corrupted the patch
  resubmission with git-send-email

v1 -> v2:
- Fixing the patches indentation

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 71a872d46bc4..96593b9fbd9b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *dev, =
struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
=20
+	if (pp->bm_priv) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Hardware Buffer Management not supported on XDP");
+		return -EOPNOTSUPP;
+	}
+
 	need_update =3D !!pp->xdp_prog !=3D !!prog;
 	if (running && need_update)
 		mvneta_stop(dev);
