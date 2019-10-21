Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57435DEC2E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfJUM2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:28:03 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:30678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUM2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:28:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGHICFkWSOWWGv0Cq9tUkaW3GqueJUdcCsRTnwR/n+MDyuMPUDoKP1e9/HO8g939FZq1DIIppj01UjWk4NhfvSfmIysZ3R4hcm7krUxwe1YsFTvDqKmHax9ZGrmlZ44Aei0SDpzpIB7OuH6JNPNcf0lQhn8M5ayv2b0SRNuaAYrvkl8cUgx6yeDo1r54pKChembOEAeUri0eWygBNq9cYigPdXLxgtiejwWpuQyCFcK7T5NgX1Wye1MiRIyrQ375OEPC6xMUZLReQIRYV/S1oKAp1EkP4bOzdGsLT+76TC7YkR6w0QgeoGgIAnRK4Qz1OgOhKqjn9jhK2vvURPZnyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1w/jnm1tpg5seWwL4PapOP5LKOFFWieykIiLg+V749Q=;
 b=AuHNEC/6ypsYgBtKzZKF6gh0GdvQBIsVVE0M8baagBfZMRLq5D+zhJQv3GOhWbUr7rhmAZFXq+hgEsy7yGHwjmviFo8P4cXhdQInMsxZ8acXZ0wIeugcmD1hG7lwKZmvt5hYZTgLnF/AN8xGPc0xkS1BO+Q665n2yZ8SCFKFoT8LDNq/9tXReiOrknY0KiO76c794xOMNZd3pZO/ww87eDZU2ko5bCc2TKOmmNGINtZW8cUOAZA0EEeqqWLZRBYo7ltqhLTKIqCS9y1yITlvAr3NoQjfZYiV3D5jXc85zeger7Oo2Uyj1tEgjxh2RU2cowt1s/KYC4WsDyK18MqZfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1w/jnm1tpg5seWwL4PapOP5LKOFFWieykIiLg+V749Q=;
 b=HT82yzWI/6Ao59/hEaYAOlKmFn6zTvRO+eAQnCYP5K6UHkrGgWvKlvrKznfGpFUgKwowdQKm8W0UdoSbvKkul1XrRV9kK7eb/vqSZ0LBfHBtrNomWfnP5ZgchmanC+pmzJAAW+gZ4a7uA0GNNS6OiqOCkQOS3/S0HbtFUdD7f9U=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:28:00 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:28:00 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 4/6] fsl/fman: add API to get the device behind a
 fman port
Thread-Topic: [PATCH net-next 4/6] fsl/fman: add API to get the device behind
 a fman port
Thread-Index: AQHViAr6Rw1iSiNPmUKOlTuJQkVg6Q==
Date:   Mon, 21 Oct 2019 12:28:00 +0000
Message-ID: <1571660862-18313-5-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fcca61f-dd62-4e17-b71e-08d756221c6c
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB580743BFAAC7389A8528BCD4EC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(316002)(5660300002)(110136005)(66946007)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004)(15583001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rT7Gw5Z03MbXiFeLBy+Gv95KbNjuNLuezQa9ztrmJKtlCqeXdI1IfvM/8GpUBi/Wz7EEGO82BF3/CnJy0sajpJTHa5mLoE+auDO3A1je5YAqC8UbO4ZAzz7rxZUMb9GvdPMjSwfVeOwZ3D4jQYgntrWjqCbdweE2YYfLfxOF3tW1+aNOmwwbCr93KKUY0YD5q0zaKuzJ5OF/i5vmLePUAQAcTMeOMoH+tiyBq2OD+NSQcf5TYoIqDW0Oyop3j093wVIA8qbRJ3l0BLSHv+eIQTw5KLPKYRCfDEV5OrLMq39K9Y9iqIHrFPfaUs25+NDVE1onWgc7OYw4IoeYHw5Vkf5sqysjLFFDazq6+XOk2EZQuZvpugJgMFsT6RRDKFDUqIy6gFQ69ZZCJ32lNaI6tqOe8a7gJveIppzVKd0wX9rLndkFXstxGIPK0a/OTis3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6A10031C858B3B468B264071F5629451@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcca61f-dd62-4e17-b71e-08d756221c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:28:00.4436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vGBLF/uh34z+lmI2TMM5zgP1DlAHPIAu9z7qRDoZfkzGCQGIv2+GI5JQ/oRTyCqYAMyWhl5SYVA7m49x7rimHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Add an API that retrieves the 'struct device' that the specified FMan
port probed against. The new API will be used in a subsequent patch
that corrects the DMA devices used by the dpaa_eth driver.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/fman/fman_port.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/=
ethernet/freescale/fman/fman_port.c
index ee82ee1384eb..bd76c9730692 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1728,6 +1728,20 @@ u32 fman_port_get_qman_channel_id(struct fman_port *=
port)
 }
 EXPORT_SYMBOL(fman_port_get_qman_channel_id);
=20
+/**
+ * fman_port_get_device
+ * port:	Pointer to the FMan port device
+ *
+ * Get the 'struct device' associated to the specified FMan port device
+ *
+ * Return: pointer to associated 'struct device'
+ */
+struct device *fman_port_get_device(struct fman_port *port)
+{
+	return port->dev;
+}
+EXPORT_SYMBOL(fman_port_get_device);
+
 int fman_port_get_hash_result_offset(struct fman_port *port, u32 *offset)
 {
 	if (port->buffer_offsets.hash_result_offset =3D=3D ILLEGAL_BASE)
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.h b/drivers/net/=
ethernet/freescale/fman/fman_port.h
index 9dbb69f40121..82f12661a46d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.h
+++ b/drivers/net/ethernet/freescale/fman/fman_port.h
@@ -157,4 +157,6 @@ int fman_port_get_tstamp(struct fman_port *port, const =
void *data, u64 *tstamp);
=20
 struct fman_port *fman_port_bind(struct device *dev);
=20
+struct device *fman_port_get_device(struct fman_port *port);
+
 #endif /* __FMAN_PORT_H */
--=20
2.1.0

