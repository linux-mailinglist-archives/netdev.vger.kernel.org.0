Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E196AC959
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCFRIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCFRHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:07:48 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0630.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD7D60D63;
        Mon,  6 Mar 2023 09:07:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFPwW88BU4WkjNGlz7zeXe+LkkhNxfWekWfnW8VOIoY3vrJpwSargLbh/goqtTQvkl4ERsTA4JeGnABUEJc2nNJds7UbL1shjscAk15c8482TXf2R3lkGwxNJTKv8qE6uWv2FuNZ1S3Siv1ShAi7P61JRD+fYq5U4Jtc4WiCcz1EfYk9mdRMMhfJ+6J9j/R7/NuMinTk+EJ95p+8ScqeGo3gn44a7jHR7jFhMEC5EqIoMf24fUgr6dJg+57HTV5n9Y36hsnfv/s4XFBX0vn2+b0Gmqi2kOM7GF8O4jY8XKZajqU60Bd3eE/ejq5BoGzaBvEwuTgxQ5kIraveR2agAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8vUV52mlQbn5GtqgDoRGrOJqgeNqnjP4c40QHQo9Wg=;
 b=WRWOtx2rt+a5+VLKgCGhn0DFMLwN+lv0dRjArSxIx9xkgQYIYNBuL5HsY3SqVFr5Wn/EyQoy+eMo8nYTFGIH7sWkgc4Newanos5ZxmBxtgPtM9bJcn0F+WM8YztvqxoiDZIl2zv4cfjo301yoaiQWTba3yk1ZsqFVIhVQlk3u5k6FkLtdgxVdT4YVvN2q2DIOGrEWdFLL7KIWKMtTlfmLQG5P+zA7pkkhucQrDenH4JLNdXumGpjqUTfVAQHl0HAa3u3ZmRDuert74XoyLTIwo3vt+MUM//REZLf7Nr1uW5N0ibEp3ExaKPXUJu/6cZv5kTPm1kEJSwBm5gne96GMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8vUV52mlQbn5GtqgDoRGrOJqgeNqnjP4c40QHQo9Wg=;
 b=d5p2y5XSa5VD/STDq/9fNuFIwpISoSjDQld92j1kQYRHn2nHdd7JEC41R+EJloy/tc4dNtcE+Z8JOuxn0gssj0xEEarM5BxPoHQblKBXx2BXJr5/LsPVd2Syfwz80w7QbBZFits7bHXTz/am8gjX5H0ui1P6hOOufaI4g4khN5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8556.eurprd04.prod.outlook.com (2603:10a6:20b:437::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:06:09 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:06:09 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v7 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Mon,  6 Mar 2023 22:35:23 +0530
Message-Id: <20230306170525.3732605-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
References: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB8556:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7894ad-8c04-4664-1476-08db1e651492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMXr3WQupuChf1Mflfddc7ZwGbctkgACK/+PUK6Cn6S6JhgVbCEhTeeyKmb4eWqX9dU2PNyzumbYlii7zj5OuPR7p8TOll9y701t368p2k61SRZrjAJxrQCluSc+9Ae9gM+X2ln6KyV5nCrpATANLmdhstMb7sgX4vLBnfguymlCUy+ammVNYYQ2dc/+UqypI17dtSHyj+1jVf4yuM5DVYqHT9GnMhUOKwTHSFzDEdJANruGQ3NSSEok3EisoHzTVG28bXg0ZAICp8dZo02FLSFBZ1nP+9gZEwKDgw8f75GdT75lILcYlMUpZqsdMCHd6hAUtAnycW9IeifF1AC6kvr2K2d//PHp/5d8bTIuMOLJNVs0U4ENqHnqcqg3t7yYfUnD1GLEdsX6VrVvaRWagd9fAlrs3Ulgna5RBjBlNsvz4BJz4ch5UgEcOQCkq1ZCDI79Kq7ZhPI+RvSBTWaFGPhLthTeYs81h5D+/+w6bPdoSv/extQCqO46lmlESdYnTmUdIup2WN/n4X3sLyVgmOMeVj7k2jGYrXh2iH39aDktSLHcCBfUSnI/4/SV+H+zqk6vGof5qfdxFhOlpfTkZAZUXNWygklfQf7gB98JXfTkPXISWzslfYjIXkjyHKcS4ZRIYs5V7Vpl7UV/21PzC1H0djxHFtbxjyOonaDZId12d21RZbw2wpS/Wi88+OD25j91X3UqIQRMB53xqgMe6S4I+SJBJ9eK0CWRYsx5qZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199018)(316002)(36756003)(83380400001)(86362001)(6486002)(186003)(2906002)(5660300002)(66476007)(66556008)(8936002)(66946007)(41300700001)(8676002)(4326008)(478600001)(6512007)(1076003)(6506007)(26005)(2616005)(7416002)(52116002)(6666004)(921005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S+snMWRqyGZwadQ3sotdnw1Pl4Gzg/O0kvQ310ZQdu82qe/eYRxRjp+ISPxo?=
 =?us-ascii?Q?eticl2y0rzWNDlOj5zkS2uyxg2+VcwR/QFnOMgkjbKIqMh5jGoCnLK0JRsqz?=
 =?us-ascii?Q?HmzN3vGfeVHoullUdDRUzIHbFSUvRSPxMd//UGNNqn1Whjn7dWNDTXNfEGfb?=
 =?us-ascii?Q?CcSfLjO/btFJMfLHw8re+5x8g8h/VtZ58OH2iOzXWHVnRfk9IHkNRucOKPA/?=
 =?us-ascii?Q?slQgAQDCP+BL/fvmHKpNpBvLtadQvm1xZ+BnU1WiLARWvXYXbm91TyD16Tt3?=
 =?us-ascii?Q?0okbHBTYXgqXFWn64pux4+84FBa2nhyTk8jk2ypcQyYIm37wenY+I2XgeNbx?=
 =?us-ascii?Q?elxdgqHZHsW7PAjFxmxO8L+9fxJ19OpWFAILyVyc9zVn5o6+R+AOOPNB59dm?=
 =?us-ascii?Q?xcuZa1oDRAckL6Fop61ikyfoGEm1Kj0F0hhhv8KOOHUa16mDoUQdk5O74w4V?=
 =?us-ascii?Q?K+uhfBLu/+avK5FGgRgRSqSb0RwbsSjuvqlHyXulxXMMhdmQOgnGof8TWiyO?=
 =?us-ascii?Q?n/wyiPJF0BzDLqN4PX/X7kIHvtrSM79PcVBVZR9kWLEqgndJFx1RDV77nt7G?=
 =?us-ascii?Q?gBy5W9cvxNIfqYWIBGi/BP7jRBHIIermWQ8PAgAHoxrMQeL+GZVzcUT6vc2Z?=
 =?us-ascii?Q?2JeGrNaBPlJlW+SPiFGwjYxPvhVUaHTsXyhfNLmh0gpAKHhSLRFyN4USk5dC?=
 =?us-ascii?Q?IY2nQIi8dMuGvxM1dnhiT7oXPWRMpUnbeO3dPeuWDuR8agdA05Bz9lo/su0S?=
 =?us-ascii?Q?IbermFQbcedKkUgfPonxWVqzxlZVCe5fyaff2obslCcN4kAYbnmjVRaiba9u?=
 =?us-ascii?Q?WDR9prZtsqMjjTO+nZ2gyGQlYYXwEL+ca4DzktvM+13vbp+galxWqHJHfdtg?=
 =?us-ascii?Q?1+h2QT8+UT1I1jjAhDNpMGbwMWQxs5QR7XnIa1dstdznA290Z2G/pmVbv1Rb?=
 =?us-ascii?Q?cSgNcCekqULsfrBuyMI1YRr7fkHVaCQv30Z8gHI7u2/ePoFKqJ7qYiExYbpM?=
 =?us-ascii?Q?adhodIPhmFb2w8ruqIgw9rAxSbB/cOj0K8O95p5lUdXWCA3gyqsxYN/kJMvx?=
 =?us-ascii?Q?0pb1D0QgK8ki5u5v7nykypSycqoDpLdWs8xubvGMKFTjT2keCsiOcFwdvHYx?=
 =?us-ascii?Q?UQDYDRHgsgkdi2gtB46W2inST2VWhOcPdtIdzAYF5+M7F7GO/Ujbp4G4SbEa?=
 =?us-ascii?Q?ASuHDFuEPyl7g3ayQRWFD6tXbtAZ+elrADDOEaHVyHq4w/1W/3z9KdWZMgal?=
 =?us-ascii?Q?+34lq3o3R12hgAy9UJbZCPeXTR09VQ5Rum7G7uP+wSEEov1sM5Nm7zyjxuHw?=
 =?us-ascii?Q?vu5Us1OP12gPP4cZbHeCdwGpYuvmMYcVnMwohp0RiaGDh5fcGme9x5ZjYnRI?=
 =?us-ascii?Q?Vs5ybtfzASDxD+m/y4cPpCAa4UFaevRQmIGMORYc4rEQMqt4t4zOA1aDSj0f?=
 =?us-ascii?Q?twdGIH+ucs83hkTxEJVwMyhYRwVVnu3P6v0YQDf5EAoS7KM+ZsCWZ0TCK5Gd?=
 =?us-ascii?Q?T/HLa0z97Jqu5m5JscmB1jzPblNn+FzItwfAe9e+dQgSqXfINdvby2DFTNrq?=
 =?us-ascii?Q?+odgNC3Taiaa7D2kXLnQkB6grjQfLbuclACPVL0azgo3ZnBiNaswxxMFY0QN?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7894ad-8c04-4664-1476-08db1e651492
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:06:09.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtXOqWnTDaV959+6F8SWCgWwa+f2pvDY0npJfidEjSsYWCOwoehpDIsE/MqFZIRM//jsHR1H5u8L5u5QS6SREUYTfv2Y9m2xOR40gGXxbxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8556
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds serdev_device_break_ctl() and an implementation for ttyport.
This function simply calls the break_ctl in tty layer, which can
assert a break signal over UART-TX line, if the tty and the
underlying platform and UART peripheral supports this operation.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v3: Add details to the commit message. (Greg KH)
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..f2fdd6264e5d 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -405,6 +405,17 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 }
 EXPORT_SYMBOL_GPL(serdev_device_set_tiocm);
 
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	struct serdev_controller *ctrl = serdev->ctrl;
+
+	if (!ctrl || !ctrl->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return ctrl->ops->break_ctl(ctrl, break_state);
+}
+EXPORT_SYMBOL_GPL(serdev_device_break_ctl);
+
 static int serdev_drv_probe(struct device *dev)
 {
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..9888673744af 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -247,6 +247,17 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	return tty->ops->tiocmset(tty, set, clear);
 }
 
+static int ttyport_break_ctl(struct serdev_controller *ctrl, unsigned int break_state)
+{
+	struct serport *serport = serdev_controller_get_drvdata(ctrl);
+	struct tty_struct *tty = serport->tty;
+
+	if (!tty->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return tty->ops->break_ctl(tty, break_state);
+}
+
 static const struct serdev_controller_ops ctrl_ops = {
 	.write_buf = ttyport_write_buf,
 	.write_flush = ttyport_write_flush,
@@ -259,6 +270,7 @@ static const struct serdev_controller_ops ctrl_ops = {
 	.wait_until_sent = ttyport_wait_until_sent,
 	.get_tiocm = ttyport_get_tiocm,
 	.set_tiocm = ttyport_set_tiocm,
+	.break_ctl = ttyport_break_ctl,
 };
 
 struct device *serdev_tty_port_register(struct tty_port *port,
diff --git a/include/linux/serdev.h b/include/linux/serdev.h
index 66f624fc618c..c065ef1c82f1 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -92,6 +92,7 @@ struct serdev_controller_ops {
 	void (*wait_until_sent)(struct serdev_controller *, long);
 	int (*get_tiocm)(struct serdev_controller *);
 	int (*set_tiocm)(struct serdev_controller *, unsigned int, unsigned int);
+	int (*break_ctl)(struct serdev_controller *ctrl, unsigned int break_state);
 };
 
 /**
@@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
 void serdev_device_wait_until_sent(struct serdev_device *, long);
 int serdev_device_get_tiocm(struct serdev_device *);
 int serdev_device_set_tiocm(struct serdev_device *, int, int);
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state);
 void serdev_device_write_wakeup(struct serdev_device *);
 int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
 void serdev_device_write_flush(struct serdev_device *);
@@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
 {
 	return -ENOTSUPP;
 }
+static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	return -EOPNOTSUPP;
+}
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
 {
-- 
2.34.1

