Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC85BD1FD
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439649AbfIXSpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:45:53 -0400
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:15758
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390679AbfIXSpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax9ICqbnFDbCoHHwuSVA4p5WNd6L37xaKGC9w3OGaezwsoeOblFYFNpQDheYP70xMgm5Kpj3rPeF2Ids8OcsQAquizdX5WcbiSM8GNNZcdcRjNYH90ddLuxm1wY6kbk8mQgasbkS06DEmsv6hSmhVB5PZ0V6cGCU9nGwgLSi72mx0ZfwrbTYyg0aFQwOpGUnu/tvnBtY9e/pi9GjdvaplDIdnVWqL9e+O+E7sy5TbS8bQ/qEcQIwzH4Jxqna5TPRHSt6bKIdo/zlJlM0XbOvPiaTdTFzoyd6VVUF5iwTN8uZXO/hUjKJ+q/9hbfiqUMkKE61BJ42b75yHPtXff6OrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS4Yw15mtcqmbfmXdmqO646TxDyPxapbaIW+G2z1APM=;
 b=eqLb89cTQhwCd8G7f9RVgKXiHGXCz99RzamN8DSRLp3kLPaP+Q9klg2Lk6G8qEtqwBDn2j1nH7N/XlEiJSITMPXdxlyfgO1aogh21jRtQ5b1yw8gJXhWO+JyzcoCBOlRMTbTYcFGFnwMvdd3/k2tFYF9Rr17laSRqIhnoe1A7NZ3Q9RNTku6wV4uTNHGq3vYoA6c/BHtAIT2pmeiHKjkitQcgP2w1eJc43atkW6JiWy01O8yNMRmdabnEnEG3Rt6wv61TqKLTjaE/eJswbZLp+3ZlxldYN2F9fJrpuWGD+sHe7h2qzvppJjrQDxQ3ODRau4IocVdr8+rkNFJAj2NgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS4Yw15mtcqmbfmXdmqO646TxDyPxapbaIW+G2z1APM=;
 b=lwHkotIw74q+ZbCVsWG1bXa83rcuVHcpnqz0eLKRwSxFF1nfk8AcJcEgx75Shk8Deil+sjdu1vndf87w7HFa3UKlF+uGf5sQIR44h8w43rWFpM76pMIuHPSXYNeJEbtmxlnOb5Q/v92dzE9cBGoUrkGaVdRip244xEXbPm00TmQ=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:45:49 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:45:49 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] can: ti_hecc: release the mailbox a bit earlier
Thread-Topic: [PATCH 2/7] can: ti_hecc: release the mailbox a bit earlier
Thread-Index: AQHVcwhIi0E+EPtTwEyHCREMstQTEA==
Date:   Tue, 24 Sep 2019 18:45:49 +0000
Message-ID: <20190924184437.10607-3-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR05CA0065.eurprd05.prod.outlook.com
 (2603:10a6:208:be::42) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bcd1559-54da-4a98-9ca8-08d7411f6ae7
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB28470D562EA575DBCE1538D6C0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(15650500001)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IQnt8eCSmHvjbci9J7wh6YJz/qR4OwgWMe+j/1TIpEWsDlaGddGV+sBHPQqzRVXZEopFIUEtpcvPXWYQAdRWfUGcywCD42XiE0lh0cmb34vhoLNGEM/WUzP2e4IVCt2tl1vPh0AN2bok7sP7v/yehaZTghjAKO02eGBK4AnPoIC9xYGQmlgp4iKoQk7T433aHogZR622AyzXfygivei4xvTBVsNIy88Fu8m0cI0ehbSSQiEDKydrBw0eJ7G8a6KpfcM9hUPipqliD2Yfymr47FVjdsi7KZBFd7FeSYNQI2BNub7vSJQw0I1FrNY6sA9f3ysCob8t6ygSR8U6AblIclzIFWnHrbN4qUyd53kShNirdjn77MW2ra37KoJV38EgaiteJfJEoLOSO+U/ILoC3MZIcZF73+mqZvaON09UqUY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcd1559-54da-4a98-9ca8-08d7411f6ae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:45:49.1519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYs9SmFABiml7OJDZZNxctt3r13U9y4Cqfx1OqHADngMRunt+JVMfqeSeMm2bcOyQYHLIsDRg8in21GIGheC9Cma61zWp1zhWCz7Gmt7pEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Release the mailbox after reading it, so it can be reused a bit earlier.
Since "can: rx-offload: continue on error" all pending message bits are
cleared directly, so remove clearing them in ti_hecc.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index f8b19eef5d26..461c28ab6d66 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -526,8 +526,9 @@ static unsigned int ti_hecc_mailbox_read(struct can_rx_=
offload *offload,
 					 u32 *timestamp, unsigned int mbxno)
 {
 	struct ti_hecc_priv *priv =3D rx_offload_to_priv(offload);
-	u32 data;
+	u32 data, mbx_mask;
=20
+	mbx_mask =3D BIT(mbxno);
 	data =3D hecc_read_mbx(priv, mbxno, HECC_CANMID);
 	if (data & HECC_CANMID_IDE)
 		cf->can_id =3D (data & CAN_EFF_MASK) | CAN_EFF_FLAG;
@@ -547,6 +548,7 @@ static unsigned int ti_hecc_mailbox_read(struct can_rx_=
offload *offload,
 	}
=20
 	*timestamp =3D hecc_read_stamp(priv, mbxno);
+	hecc_write(priv, HECC_CANRMP, mbx_mask);
=20
 	return 1;
 }
@@ -695,7 +697,6 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev=
_id)
 		while ((rx_pending =3D hecc_read(priv, HECC_CANRMP))) {
 			can_rx_offload_irq_offload_timestamp(&priv->offload,
 							     rx_pending);
-			hecc_write(priv, HECC_CANRMP, rx_pending);
 		}
 	}
=20
--=20
2.17.1

