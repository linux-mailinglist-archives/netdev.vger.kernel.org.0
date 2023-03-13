Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3641A6B79EF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCMOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjCMOKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:10:06 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2087.outbound.protection.outlook.com [40.107.247.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7501A6BC33;
        Mon, 13 Mar 2023 07:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReT18tiCR6XgZo5+oVPrA2SIHo3ANfYCCMmT6UTYZnloSn0DRzTTWBRyhqS9u1s8bKixcXYrqxaEhFusNAN04DRko2Q8iI8r5zPUYuXtf/RTo1CsuHnds2y0/7D7YfKHkrVN3A3mnvtz4OYtA7pp3bQ2r2daoX4CB3Shv9BpDgAR8R+ewIUiGfu7to4G3VwAGEqu3e8Sf2aKFyljYxH70aXs4BxjZjJG3+uuJ8+SWFh5epP1KcxWuqSuZq6NbGPLPXN3CgXETmGjQpQq9oi8P8qRwot9K0kWE/JbYK99IBvHL4yEKBUnqxwehHum04ish/yJJuvyOdr/7dgkAMG/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lfnd9GeZPdlVaEKMuJLdvJcm8ylC5I9TGjLWQqtXRM0=;
 b=f9XJNf0D1soQZDVLitCcRNU9HmNf/SaHKmrrl4quEdUXI0nsnxE0i0WNVvNt6L3Sk4xIGpVCNJo/EUenZgJUTREzNlva/VqoTAISwYV1aGAtReqfO4H1qrGp+OUBauP6vMuMwzjB10oEbP6zt19nUwNDYEiAkSs90i0EZhFyto1hgFPGlHO2yxdnWPJTJHlt+0YS0yH0kC5jDGE3DFC3bxm2y1Q+Nx1Vg9zLyCob5AOh1LGeWofg2XVkTK7ZZy7vQgwjBkDdsergs8mIhGfdj2YXkFvcm4HvcllmlCiRs8IrpBe3IGSB/HsmZEk93KY/aCspAy+sd8ryAPG6YKyP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfnd9GeZPdlVaEKMuJLdvJcm8ylC5I9TGjLWQqtXRM0=;
 b=ONcICCZzRRF4DOkYM02c/3KGsmKleA/1ui1WBa+mQQ7IDhJe4zeZNFDFPWy1P6Z7c2+aFjEhgp1Kk49lGOBJ9rBJLebhMSTgYQY7BULDRDGh3OGUsvPqtX5J1GYZoEwTPOB5IFZN/lbegbIgJXI1BR025UBDZQYlIH8ZSJhX2AY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DBBPR04MB7594.eurprd04.prod.outlook.com (2603:10a6:10:203::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:10:02 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:10:02 +0000
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
Subject: [PATCH v9 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Mon, 13 Mar 2023 19:39:22 +0530
Message-Id: <20230313140924.3104691-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DBBPR04MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b79775-3dd6-4597-8494-08db23cca304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +vmFTkhPQfXEDvilchB6VoBnQtEi+tTKfcliznr7TJEiAGJj7tMgaTw6BOTUSdOXRKbdUtVoQ/CP/o61XY6Qp1oCZjj33pzv67Vyjh6zNzglwh3kVMSbHy2zpcWiLcSUATK2Vupo1kbnzw+4L+08Qd+ARe//KPN8PGAbhjVvDeayD5lZaSeFsMkhB5oUYodnKyaWSF6Pxb7b/oBph8FK9eFORQcHgX86wnfvbtwRWYZNeeJtVxR6uqqJPA5pbq9iC5IPM9OUF44Zx74ymwuUevgMANkVwiwrtJexf7E01Jn/p2ZKlAoseiIoD+DSjmm6IqdU/8zxSlRyDq2rWEcemPclrINsljVpIbtkGWWmWNI/XRi+rZmWD5tDrt7onr1Sn7U5cRrUD288kkiVUpa2GVTTSSvwnFLLyW024L0RuwvfzKJH+o5zw0EP8XEaPAqS7UcrHj0Nq7BxBZJehoezhQyyrN5qyXS4405KNDnqGyzQR72EHTlCnTDYzM5jwKQ1KMiU4FAURPjMlpXSpRVgl8KlukDowfJ3zaQsfiOt/atuKC5dtsv/yu7rjuY2qdEy3eAXdeCB7Cl6MsmgwkO7dTMiXhY7HjC74goafCu7piesI2u8OKw7mWHUAYbMVXqniGAPCYcscaJhnlxaKzTKdKsEwo9hqGO8NNRWyF/ukqzjqDpJSjP18Wn4J9HhtfiBQm45vc4f8AkjQVJW9p64XqIkQd4w3p315GHqqaTR07U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199018)(36756003)(86362001)(38100700002)(921005)(38350700002)(52116002)(2906002)(7416002)(5660300002)(6486002)(8936002)(41300700001)(316002)(478600001)(4326008)(83380400001)(66556008)(8676002)(66946007)(66476007)(186003)(6506007)(1076003)(26005)(6666004)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+rIPC4CzIV0H+zMwE256qA10Z6vqG6k1KEfaGsetE/BIR6appJNjmPWaYu/?=
 =?us-ascii?Q?UrxvrGutW5C6ox4P5WIgZO9HNKmm7VBZPb+tcR0OnQSCrwdzRNBzTcPGGMxc?=
 =?us-ascii?Q?mGNkWmz47tahz2lBYBZYJ/N7epJ+E795+xHQvt0SEZ3xtRg82uZQrAn+CumK?=
 =?us-ascii?Q?77V1/Kdr58yN0KQG5k5XaR1lfU7UmLdXM6RoHNLqawMQ6WEXNuDWtXnZ3/9R?=
 =?us-ascii?Q?3QVfTgiHhtOGTcevW2JbQkwOTJrmyJIL8xv6uTprqBk3OxncwBHzMCo/8c61?=
 =?us-ascii?Q?gpQ1xQOXqfBsaOV+Kry8SrIPyNs3DYJ5gDPshCfAcqJWkuHb4bHM1SLaNf6y?=
 =?us-ascii?Q?2aB3rjCzmBjcTpJp9VhRa9BLXpXknBC255CiKgtsuSn5eO+tBmYzVsLy6L6E?=
 =?us-ascii?Q?Tql0ZO44mU4D/k+aVtUE56YkZ1P1c2oapa6oAN1swaae8rJJzWmlOU+I8qRw?=
 =?us-ascii?Q?7YKJdLUSsWHcfDkHeWr37P57rjYVh4Peb0QjediIFlTrjFN9fXsHuaU4Kf62?=
 =?us-ascii?Q?J1U3c2kTyvPkFe5skzCW5bvyOmzzlMQ7mq24CvigoBrlNn3Zcpvuuhn0Od3p?=
 =?us-ascii?Q?4LSOdN9/3Mml7bdjLblRWIxdlOFcQu6dIKfJDcf1p0xfXJnDVWNwfPZmKuEJ?=
 =?us-ascii?Q?qmtxBropjUwhcVzMjDVHJ//33d1lB/iOuAXWPs09bAiFUOArnDicAbMUw0xN?=
 =?us-ascii?Q?cDgd3NhF0tOET2DVSOh4q4/Kp3vhWFNxwRoKtW9EU8m+jOZmvIuET12bqqj8?=
 =?us-ascii?Q?2d1z84sZ8kffWDivBBlXHd9CL6kZ8kEDi9EmwIFMfU8BUoH7JTAoFX/gI/5c?=
 =?us-ascii?Q?b5rBlJDIu89kgv5R/KWVjp3Bq/nvUkj5RXbbP/0UEzDXLbGoJ5VO3+tj1XOS?=
 =?us-ascii?Q?U+SEQ6zRFcH2PcRjEBcyfE/s/CVtcwSXdkX8WkTZ5IsAPH+YQ5YfGvBnhxW3?=
 =?us-ascii?Q?++jAlUYGR1u/SGwFL0ToZItYpgI8ZJCF3FTZS1vulfAbMGtE9wgMfQkTKPHx?=
 =?us-ascii?Q?k7BjLYhagcMuzQUtHT8sjU0rYyd8zIiwSISCvISgMjtwoLBsULY/wb9ElRKD?=
 =?us-ascii?Q?UAAguJtMwcSRq9Tw/+RcHSNpna4Q4A9Ho6msJ5VttLvr3awGJ1fLPlsArwDD?=
 =?us-ascii?Q?JbyDkzm+pcH4WWom8fVNoXigPtD4BMsdy4G0n8261GyN7K/x5O9Ap1c67oS6?=
 =?us-ascii?Q?nWXC+6UqvVQMhTEug0tlGJ2Mz2tGFpc5Unhrjv6ZVS3OlEGOuZ7Ba35tRW+1?=
 =?us-ascii?Q?DFt+XW74YINPKvrtdD6NgrKyTla6u+50DQcVdWkxT/hOif7rYPWz4xnVK2al?=
 =?us-ascii?Q?SaygdgVoUUNcMMsMdo1gem+AeGcewacOjNbREcljdUrR/nNOyyhug+7iPICO?=
 =?us-ascii?Q?TrSsTd+LZRNI+UQEk/zw668mLTNwWI3pqtW6bCb7zYiSoGNYRYvJQjKD9zKu?=
 =?us-ascii?Q?a8bVtxwdhPrY7bmkKRapQrLJpHyT3cDFhCgCyegQjX3Hl9EASfg1dvNVCQ6e?=
 =?us-ascii?Q?Mb/42gYIN5ekrNcGar1DHt1FQmqbRVbFehSXcINB7nL4B/45cptG3v+Q4Qka?=
 =?us-ascii?Q?Wx+YyOFT24QdyFA0PoG+4fW4UiTGvDrrOSc1JZMEM4ip6YWKSQXqQDih8p5g?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b79775-3dd6-4597-8494-08db23cca304
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:10:02.0037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/6TjMMjF2MVGSPDJfSXdNwxEWhQgkZM32+C2fpnnGofKYJuqsnPymJyWJ1CFBFBa2KxlZXTPIjrrwEVTj018JjiXG3KiFtQKAdi3r9yBgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7594
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
---
v3: Add details to the commit message. Replace ENOTSUPP with
EOPNOTSUPP. (Greg KH, Leon Romanovsky)
v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
(Simon Horman)
---
 drivers/tty/serdev/core.c           | 17 ++++++++++++++---
 drivers/tty/serdev/serdev-ttyport.c | 16 ++++++++++++++--
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..dc540e74c64d 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -366,7 +366,7 @@ int serdev_device_set_parity(struct serdev_device *serdev,
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_parity)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_parity(ctrl, parity);
 }
@@ -388,7 +388,7 @@ int serdev_device_get_tiocm(struct serdev_device *serdev)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->get_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->get_tiocm(ctrl);
 }
@@ -399,12 +399,23 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_tiocm(ctrl, set, clear);
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
index d367803e2044..8033ef19669c 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -231,7 +231,7 @@ static int ttyport_get_tiocm(struct serdev_controller *ctrl)
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmget)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmget(tty);
 }
@@ -242,11 +242,22 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmset)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
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

