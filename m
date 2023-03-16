Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1FF6BD6FC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCPRXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCPRXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:23:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A07DB863D;
        Thu, 16 Mar 2023 10:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnO4jogeYEDM2eXWNhucEqDUa1wdVVn5Rj/bhzufEQJVIBruzYhnETpOH/iKzE4ypTARv/qbfKrkIXItsiqs/miXaD301G4APOQRj/QhJZkB/nNoURjI/bQm/Gtl3njXDBC/flcOfUYQNQaceMOqaeMiDdreVJQkRfy5RGUkf+5KEct7rDdVrw9BoDiDyzIxSkknsIvsK1XpFrd3A1KYeMexIs8c20pfE+uoq1B/54BlFpo+r9zLFy5ZABSA4xMA8AGERxRYNvUfralwRl60Cx613UztxnX/s7H+dUlsE725QndrY+uBUn9vRJ8xArOge98OwYSZ0y4QCYvDOMkxGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEUux4oIC4z4fMGUhCjhIyOb8tcBYNB4Ks+ILiH/W0w=;
 b=PDWpDipfnDgf7owRT1RbY3ZwOB4isPrv9WCRPc2jTptZN6uVkShUbcCCjkDtfTvatkY11k43X3NaR8FpU34EZmlnI9YboDIFHdnfacvoblpliNVYYvk9XB1VUvrrTqCYr/+nq1VXOdokzjjqHfvQ5q/6vA4Hp2z4dmVJHIQU8g6OkSQOtkEGFivdEKWAA0c5ZQ0a5ErVn63VzmdKxBlssgrs7GOV7bjmyW4oYgy3dNJtXmrj34O0iwgGMea4VxtbOjVII0Dwz2MSbFPty4cmwFzXEb3/cZyux5D+IB2hHOgSOIXVMDzm/j8cB5pWabtTl1ZGP639RgMdu/yhqcmqzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEUux4oIC4z4fMGUhCjhIyOb8tcBYNB4Ks+ILiH/W0w=;
 b=mBIC81hmuExfQxFxF3ssK4oNzZ9jwTimn/F87BAn53ok3pGi9FSx31cqGIDJHPxQ6yUhX5mXvvnQzlcWWOhsjCYzQO4FqxHffLKXYp2YD9SHBkQ5fbeY3916Io2CNe+PtzSkokxMWYHjN2ceKejTe+57150KrfG6Wet1/G3wFqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by PA4PR04MB9293.eurprd04.prod.outlook.com (2603:10a6:102:2a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 17:22:56 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 17:22:56 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v13 2/4] serdev: Add method to assert break signal over tty UART port
Date:   Thu, 16 Mar 2023 22:52:12 +0530
Message-Id: <20230316172214.3899786-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|PA4PR04MB9293:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6dd7d6-42a7-443d-963d-08db26431536
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrDkB1mN2/dbUT3TethJzM091bojc8K7iBHRGW3tbnjc9k40HEAAO9nOP9CpCF68jGGG62gakM9s4SExaRmHEwXLktbq0skVG/4YihAMqKvG3nuzEGyhDPqre8iawyfiUNYhPOqoOU8tXv3fHLddTcDEWpN1lebOqYRXiXSn7SXZCLo5fRVJra52kAv4/7MoBOJXtSYY05UP6lupA4qSN0Fu/nZZKFqUmJlJfOEPAHmVps5z/0Lx/swt4Iyv+KbM1cl20HtdAlgMMoguAIPOjRVrWF/RKS4kRXJPgZH9AmocbCf59NkFcWUKGsC/BQPQF5OaAaYVSJ15MMyTN/25EIV7k/5ejywsWg6Ml3U3kDEoXZVq0DOmaM0kwfO9ikzi+LZAy972TtI/jQTIDLNEBvOJcjTxAkAXzS104ShGFJREIKmBXgDmTeNGtpkEhoD2kjBz74w0TmbZGffaVFGAqThTIxv1N4on0N38yKP7aVBqWXhk7pAGtufOWOfkyhp8vzCWChQZKF3Be2S+6HUByqF/znZX9t0EQeEyuUnWzgRN0s64MO3UVQf3BlOvk16ZAo08EdX5R/zcJE62JX+s9VIHqvxY4BfEKzCZVyrYCyC4laYgq9dseLylprx7Q6FhfA1fMvoGCXjXShThJV8l10P+oXTpDMpa43LOYdzkcQylPEi+mRvo8kbNvPlBJyz+VANC8WqbdY14FAnIz7L8shdswhzOMh44eHdHcBhY2cM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(6486002)(52116002)(6512007)(6506007)(1076003)(478600001)(26005)(83380400001)(2616005)(6666004)(66476007)(66946007)(316002)(186003)(66556008)(2906002)(41300700001)(4326008)(8936002)(5660300002)(8676002)(7416002)(38350700002)(38100700002)(921005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UpVxV6oUKpz/+1WwElTFQIYbB+8B9Rdg831/HfhgJpcFGo5AdokWAOi8ZgNg?=
 =?us-ascii?Q?5YIm5HA9qJ/9OTy7cC+w1YphY5kl6XHo75ZFxPMY0G+Hhlte+Y0yCRPYX59e?=
 =?us-ascii?Q?PdpVoHG8Fea8XbQXx//qLuUL98kVRN3RIjeaQB+B3BmGhd9Rgk43WPDFz2V8?=
 =?us-ascii?Q?/PXKbvay5UFxA86hiQCYIWWrhzZ+dMiwR97ZWu5v7BHKGWnlXwT3ARNGLRHK?=
 =?us-ascii?Q?MoeU/mFBnVrgL4EzdX4HONChaaBv4zqkaKqxYpcnscXiNOmcrRvKb9WOQZhT?=
 =?us-ascii?Q?dZy7ULch+31Cn4hisyfqdywEMo8SPV+FTJF4lAzRegjj5XDoaXGbuP/eqpwd?=
 =?us-ascii?Q?n8rpjgZDnzpBxMRNzqsd5nLkcmHwV2d9ewObryNlvWSkWc3gTtgeeq1AKsub?=
 =?us-ascii?Q?3GelQAWy8zN0pA0Jzo1YJ+SwdSaRdkWoQaKBPmObI5puV7hv5HRjH9rVWBTh?=
 =?us-ascii?Q?1cRWVpc3gDt9jafGF5dcSJMkNnz/egFdfl6GOBlKX8Gxtcg/TdeFIGrR34JK?=
 =?us-ascii?Q?soJ6iw/R/gKi+jZ+nGe/k1S6LYWPyka3GmkSXhlmpuob+1Mc2g6JDC2NsAqn?=
 =?us-ascii?Q?ET17hO0ev65mSNW5M4JeP/36NKJJG7mgu3/JOoMEqe/nPuxvcgOeRxGupAmG?=
 =?us-ascii?Q?VLPlWJWUr+7vI7+nGlpOLQBPOc1JBCfhuv8tFMcUvZBgJuospStWtGSCUEC5?=
 =?us-ascii?Q?LVWXMpMcyGLyKTo2vtY8cqZPUaFbXiwFExS4VIrhBWHAGc3Zu1zjaQWE2jaC?=
 =?us-ascii?Q?nbz/JDSOLppFKl1RrF5RMRHWGV92K7s6KLUoVNyiRB8NCDx+KxuP54NYq2gW?=
 =?us-ascii?Q?LqHD6jr+mt4XLtwIx96UmaUAihGhW9Q3/hTKqVtqNsiVhh1cUc3ZXLPyuf/O?=
 =?us-ascii?Q?gD95J9+tuJM3ogU9wEO/yG71Zxtovs6xve4UlJ/Bv6PfRi5uNNItvwBf5DQr?=
 =?us-ascii?Q?97xncVyrtg7BVdKi8LAFSwgqGD3v6jnGCa6MtN0K62QPwImiKrLm8Hvac1Fr?=
 =?us-ascii?Q?QrJ3j7b/mt4vlScIj07ngICF+U8cfjDyu+NZWO5JKj5drfqrzO0C5AbY/zJ+?=
 =?us-ascii?Q?tqWC2kZOZO6R5JKlrYNz4GeK3mOyewiyBW/Qbw8zI83yTXv8zVVBamsPGnqY?=
 =?us-ascii?Q?WmIzBLf8V1rytlbgcMBE3o8iaLAP9n5eEDGi5/ukj3SgttH4e3Ez+yVCL6d5?=
 =?us-ascii?Q?+NyTJom+vBW9iLE3T/veNMf91d+dvTbcqts0UH7RqJ+dsOFIjj0E5BkMhqbo?=
 =?us-ascii?Q?eeiPFrJjRJQ49SAIxGNYpE8BfYRRha+C8siqZqSBW1sY9DO+80If1KODjTSv?=
 =?us-ascii?Q?lEuJ1odpErJu4nKsxj64ioZDFvkFL7dowicY8k2rMvnEkmJpybW1yVQK65b2?=
 =?us-ascii?Q?9B/P0KTgSdIjDKbuY616D7NiFvXJIxGOIREjjNdaewgAug2Yw412ZDYa7KSe?=
 =?us-ascii?Q?G6e94atQJXR/aWo2Kdg69iXQcnEMUZnlrvQVsPW84xN8/JAaLiJKp7nE2jfQ?=
 =?us-ascii?Q?zwYUVEBPD5VNDgw91nDScbA6tf6/3P9jLjiI1wwb9jxFS4jac8uPJTqZKyDw?=
 =?us-ascii?Q?Idr3LkAidZ2L0E1Uq75YADi02ENX4UcnYrQLFf5P3sY0EBtgeKkL16VFk6yK?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6dd7d6-42a7-443d-963d-08db26431536
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 17:22:56.6276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucAe7wL98F5Bk6mh5vgzvCHegJyh1pEUH0D5cGVJ4VHdEVas6Y3NNRPRpcY2sOBdQwB0v6rY2t6tA+wyZx97clUcdf6Nrci+h8QpNVVXgWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3: Add details to the commit message. Replace ENOTSUPP with
EOPNOTSUPP. (Greg KH, Leon Romanovsky)
v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
(Simon Horman)
v11: Create a separate patch for replacing ENOTSUPP with
EOPNOTSUPP. (Simon Horman)
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index d43aabd0cb76..dc540e74c64d 100644
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
index f26ff82723f1..8033ef19669c 100644
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
index 89b0a5af9be2..d123d7f43e85 100644
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
 	return -EOPNOTSUPP;
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

