Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C5CBD204
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441631AbfIXSqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:46:09 -0400
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:15758
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438841AbfIXSqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:46:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8uqt4lmu8UCHlKTYGC7gQ9kqDBBmmVA7hoMW+0377iKVMNc9kdFslisEiQmWUpfaV5F3tVS+yZgq0HW3klWtzzQOI4Ji9dckWZT0Ox63GeKQREA8Laoh/2ecAkTp1DZBGg7RdZl7VmpMb71bwzaXL2LGadhDeeizbYQxpMHOrvSMsUvhX6UEzmOYav62l8C0eYKYQ1KAEEtigbzGPtTzVp/kKso9pMR7OypYk8N87JZM0F0i6Hrg2MDv1tGMp4yVmFv9SZ4lgIqvKfMvSdnmMmdaa1trVbuifqqCqJJrfec/VcF8qfULS+5GAPCD57PMxEM7OJ7tuanIjwvEVbXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay8uZKdvyAWA2yEwRqovSSeeUlTIE1bp6vfO9iJc8yA=;
 b=lUp7iLewTluGbJsYuo0viG+LifbDYb/BsLGSCiLb7z6xrSJiiSMJ2k9agAHAPahMWj2Jm4/RTEDmt3HNvERrrDQeFWpdeyNOUYbeOd47YmAEJyzRTzf0tdRPm8Ql0XjdN/5u2IUDIhTLqkL9L4rm4MrfPraY0/Ng5pHz0x/83nwTITqiCR4dZ/j1hZrIVRVAT0J1dRfbm3sBlRsS88IcxIDscxlqKTXgzuO2OafcJa/4QLLcPHfaw2QorV63EtY0APimmAIYfipIHCU6thWze4LY5bBTPxDcDXw9YS4UxVxO/5gQyCpWgqMgoEm8WGLYM89bK6t7NKbiiD8qNjMdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay8uZKdvyAWA2yEwRqovSSeeUlTIE1bp6vfO9iJc8yA=;
 b=KpPuKxny0IWfQdETS5sy17zQekeBzVwFMs1mj1T6WOSEbH8AOiC9tc5OoQZ/rsya7+4VKvZjU8eQbXCDoUHFMaHDSWiCRfEo7E/XcWoV352wp6B/V0q0b1bx2FIcRY89nao7jb7qIigUIQW943a+UTNipllOVZvkNzlsMedQ2II=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:45:52 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:45:52 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] can: ti_hecc: stop the CPK on down
Thread-Topic: [PATCH 3/7] can: ti_hecc: stop the CPK on down
Thread-Index: AQHVcwhKSTaOtxlyTEmNsu2EZ2EwhQ==
Date:   Tue, 24 Sep 2019 18:45:52 +0000
Message-ID: <20190924184437.10607-4-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcf5587c-d3ec-4d05-649d-08d7411f6cef
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB28475A4310B3B14A99EEF9EDC0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7/ka9yfZNL6hfmTCbJjSMSov2sWwAZrSgB/JZn+jdr6Yw/dvb+5wiqfTbkYT3Oa7CR92fu1Ljpomh33Qcy+57jpiL1G1QJM9FexANtcRDGT10Z4UCM/7g8+qw7CxpaITFEhWu8JliW9JPiB9UYOMXHKIgOwsXDOvOeIFfA8XBJ21xWEYcMy2cJ5zCqNFDNoCXV4N1eIfdi2gbFDnv1bPZF1+c/dvhQBjbTC3iqmpjTcgkP1Rt7KBnVYOF4i/r0astBuFAdD1ieCx+VnyDjvAVHZsBhlU0DrRtoBvh3zCZ8edGCgXGEN0PsA7tJUqDSSTqK+pQpw+/4nBdZi3QdkvQnBhGikN4eexQX3kKXTSVWN70zVun4LW55cpZaj7cqXGDc3i/npEcui08KMrTgYOe2Cy8njrRwJ1tjm7QaLi+E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf5587c-d3ec-4d05-649d-08d7411f6cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:45:52.5443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fafLRV/GsYYkNBqadqzRWmwc4codiE7l5OjPdkdQ5Ri9N+XHgU+A1yc2EYals1FMXRs+gOzNDodJ504OR6frcvzFSI1NqLgQZzVqYqCFsSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the interface goes down, the CPK should no longer take an active
part in the CAN-bus communication, like sending acks and error frames.
So enable configuration mode in ti_hecc_stop, so the CPK is no longer
active.

When a transceiver switch is present the acks and errors don't make it
to the bus, but disabling the CPK then does prevent oddities, like
ti_hecc_reset failing, since the CPK can become bus-off and starts
counting the 11 bit recessive bits, which seems to block the reset. It
can also cause invalid interrupts and disrupt the CAN-bus, since
transmission can be stopped in the middle of a message, by disabling
the tranceiver while the CPK is sending.

Since the CPK is disabled after normal power on, it is typically only
seen when the interface is restarted.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 461c28ab6d66..b82c011ddbec 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -400,6 +400,9 @@ static void ti_hecc_stop(struct net_device *ndev)
 {
 	struct ti_hecc_priv *priv =3D netdev_priv(ndev);
=20
+	/* Disable the CPK; stop sending, erroring and acking */
+	hecc_set_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
+
 	/* Disable interrupts and disable mailboxes */
 	hecc_write(priv, HECC_CANGIM, 0);
 	hecc_write(priv, HECC_CANMIM, 0);
--=20
2.17.1

