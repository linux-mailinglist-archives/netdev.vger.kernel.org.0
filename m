Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8BBBE757
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 23:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfIYVeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 17:34:17 -0400
Received: from mail-eopbgr810115.outbound.protection.outlook.com ([40.107.81.115]:35180
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727058AbfIYVeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 17:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdbStwKOOP+Hg/57wPbiSQcGWxpglpU7XU3OWDG+f3DQ1YAEtfyauPlb43Ttu1u4GQOV7KGOXK7IUutzrI3JAdm6s61uCWfs9MrGlj99ejE4pqOEFdWtN/fGnsFSXNVmpTSpqNVz+hGXEm8fg5QlCxkykHHQ6OnX0PeKdMKC6O84PqXaGzd69LykmuIjrL+8Xx5/7utXC0+YTRBcoD0z6vgxrP2VHwR3orlD9x9QNoHrY+QWU5UmwRCDonwf9hnORKac9djeuupApD3y3KHIaD7K5Ivum2g2zebgCR4iyv7o0WRR9gnKhKQWeSN7EXIpxi2MxFC+IuYVMauCg9DVPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Apwfe7or50AEwPyEfOZNW/LvlnE2nNKDqtypMigcvtw=;
 b=McYjmXl1SlABabXR2kcpRRoHrmvJ4Fi/27ko3SyP16oq64hgfDTKmbsWuNRCW7cv6wmzMIPM5Zd7LwSDCEoRxMXDapz9NwLGcrS+lK5QUa2szcieZ46UjV3nVqV2JcsdFJMOGgfgrEHdhs6BUAUNH8WjgNxSRNbjMYR94eHqwXfLtAgAMCdtnYTIjSgauH5YOcyRSupK3FS7UuS10u2ll51ZJTHO84blra8RyngEHd8DqteboeeBelt8ea4qRoLae9iGPXW5+BfELJGKOF+j1IVW2L/ay4O3tIWi8YNGBiiqt+PHNn3apDU2WO4256jkx0YQOZ6HvVGBrhWe5zm6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Apwfe7or50AEwPyEfOZNW/LvlnE2nNKDqtypMigcvtw=;
 b=A8la0tCfzBQ9rQ11enSN+eld1VRtMpXkf3sMmcJQ4f5WLsdNmpDNt5RnTIDu0RU5gTZemMrudIDhcSzMn9wrSfMkLMwZtlRimzsi5V3M/2u1UBMCtYQN5OgX4r3bO/huO1E4ZPvrtL6ycDw6PRNwxIX6hAg9bHQjqrd+FCifHVg=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0989.namprd21.prod.outlook.com (52.132.114.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.1; Wed, 25 Sep 2019 21:34:14 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383%9]) with mapi id 15.20.2327.004; Wed, 25 Sep 2019
 21:34:14 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
CC:     Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2] hv_sock: Add the support of hibernation
Thread-Topic: [PATCH v2] hv_sock: Add the support of hibernation
Thread-Index: AQHVc+j5+OoX7/VHfE+B55yc8kBPyQ==
Date:   Wed, 25 Sep 2019 21:34:13 +0000
Message-ID: <1569447243-27433-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To SN6PR2101MB0942.namprd21.prod.outlook.com (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1606be42-1fc7-40e7-4fa0-08d742001c02
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: SN6PR2101MB0989:|SN6PR2101MB0989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR2101MB0989DD2EA942911F33A40CD7BF870@SN6PR2101MB0989.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(189003)(199004)(386003)(186003)(2201001)(305945005)(64756008)(66946007)(66446008)(6116002)(6486002)(6506007)(66476007)(36756003)(66556008)(110136005)(7736002)(316002)(3846002)(256004)(5660300002)(26005)(107886003)(14444005)(2906002)(6436002)(22452003)(25786009)(71190400001)(71200400001)(6512007)(102836004)(8676002)(66066001)(1511001)(50226002)(43066004)(2501003)(486006)(4720700003)(8936002)(476003)(2616005)(99286004)(478600001)(4326008)(81156014)(3450700001)(10090500001)(14454004)(6636002)(52116002)(81166006)(86362001)(10290500003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0989;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8o1ucOez5seSdlMe1w5MjZb/YJiCTS19LdHW3lTZ+Xjg8/GAPmKuQqptAziz5nnauwiBsbGn3h8Fp5Hr5hMmKyutJFGYWH6FSafF1qaMrtRQTtgRPhMljWSF9ECLgf6x+GJZ90nEGr+vOOZ3DL9S7q74fcre7e23ttMBKvSOMngkUn92MnM8LfjvRdqM/vLJSQLwvIaQqqclcAFQ0hZqWVnlzBHq1MjkM0Eva12E9lwCkmDNzpL0nqfd8qmsWyz3oRQcp6hdzj4YvNgxGiy2ujzOHa3OqfKhebX2tB/fZbub8Cy/P30O/QejGMECRUxSC8VhV0c3iDtJO4eoc5U9cdQCvanm2/WpJ0nlsUDDCCXtYzBXUknqhXSdp+h/3INvPkS6CsfIttXsxXg4lscgE8BtD6wPR3tmR+YTnF0gWO4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1606be42-1fc7-40e7-4fa0-08d742001c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 21:34:14.0437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D34/TWFglJ3hXhRhoHWuv6zwMg9R025Foh7SzSaW8JcP73E/F2G5XUJzSG2RAafCKSLstF7QBKS2ODwASMHI/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary dummy callbacks for hibernation.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: David S. Miller <davem@davemloft.net>
---

In v2:
    Added David's Acked-by.
    Removed [net-next] from the Subject.

    @Sasha, can you please pick this up into the hyper-v tree?

 net/vmw_vsock/hyperv_transport.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index f2084e3f7aa4..4c02e38aa728 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -930,6 +930,24 @@ static int hvs_remove(struct hv_device *hdev)
 	return 0;
 }
=20
+/* hv_sock connections can not persist across hibernation, and all the hv_=
sock
+ * channels are forced to be rescinded before hibernation: see
+ * vmbus_bus_suspend(). Here the dummy hvs_suspend() and hvs_resume()
+ * are only needed because hibernation requires that every vmbus device's
+ * driver should have a .suspend and .resume callback: see vmbus_suspend()=
.
+ */
+static int hvs_suspend(struct hv_device *hv_dev)
+{
+	/* Dummy */
+	return 0;
+}
+
+static int hvs_resume(struct hv_device *dev)
+{
+	/* Dummy */
+	return 0;
+}
+
 /* This isn't really used. See vmbus_match() and vmbus_probe() */
 static const struct hv_vmbus_device_id id_table[] =3D {
 	{},
@@ -941,6 +959,8 @@ static struct hv_driver hvs_drv =3D {
 	.id_table	=3D id_table,
 	.probe		=3D hvs_probe,
 	.remove		=3D hvs_remove,
+	.suspend	=3D hvs_suspend,
+	.resume		=3D hvs_resume,
 };
=20
 static int __init hvs_init(void)
--=20
2.19.1

