Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD0477A5D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbhLPRR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:17:56 -0500
Received: from mail-eopbgr30093.outbound.protection.outlook.com ([40.107.3.93]:41798
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233600AbhLPRRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 12:17:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9vVUsoRVXHdH9DyPsbWCNWmqke0Z+uLE2YS2NrpihYcse/6UJXIsLuoxlkS63ZdXTbvAovdzjHlND5DTPIM3uE7BmIhBuDzUlgzjsQ4AdFN03Ismhj6vKuLsU5zUJG6PCsfMMvbtNxHNplPVw2/SDN4TAx0YxoZAfSAuzrXjWNyJ4VlS4byaXVyPgvKluJzKgftg78Lr3J3k6R+5pavpegqdUFN1JdI2q0R0ANSOmQZYmoA3rQKKHvK9mrNNhwW1yiIxZLmLRCOu0cfGmDST7GgbNiHtOHvthkqCFv6yUYa0aVZdnkf7lqJ6uCbUStl9NiIkZqEIWqYLtUhzVb8nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfcIDTMDj2zA56Hb95MTPR6bHMhmRSArE6E6oANKPHw=;
 b=XZDr6AccZERwbSNnXPDUqSYR9ERTtHomAzvLvmyWLf/gDgE+4le3BnSoDMHts9u+AFsjJbA5Mync1c0VP6E2IH1v9YDSQpc8SSyLwFT8FjK99s2hsljyGTt83/N8J0TW8NdwDeJkZ76IhTFMFnM322bhIB4ou8U3Ska8Kjij7vr5J04xkfcARbfVpeSlzuX70aE7m/SVVk9bxhbFa/Sj9nXxGvBHMpgSPBgWM8D1fJaGlIETNZ/xGhv4sNzLORk4bXE/H/8Xl11y5ibyhH3Lzd1rz2Opa/xv2Byf5l/vjzfZ/94Xi74yMlAd3Tj4Ow6omjs6jbqr0a4fWFnvcrJzYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfcIDTMDj2zA56Hb95MTPR6bHMhmRSArE6E6oANKPHw=;
 b=Y+bBL90rtiYbSKv3x++3EOQyHfA4EUgdPc6a8E3ZHmcuFAZrXCNvbSqnrr3bkuzteJlZcsQcuOJZR68KV6iVDiQVjQ24SJbYRoNuGCZsXH3gVdE/7OiokQB3o5Iewh4yNBAwOoua3QPxK9R+E6d/lpKulYNpvnOQY7gSooyAyEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0116.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Thu, 16 Dec
 2021 17:17:52 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::14c6:2e15:77ea:c17f]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::14c6:2e15:77ea:c17f%9]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 17:17:52 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix incorrect structure access
Date:   Thu, 16 Dec 2021 19:17:14 +0200
Message-Id: <20211216171714.11341-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::18) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e2f2a6-83c1-45d3-7f0c-08d9c0b7fe25
X-MS-TrafficTypeDiagnostic: AM4P190MB0116:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0116B1B5DF73FD592CBF001493779@AM4P190MB0116.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JoYm59+vbilAtVXKEJVYBH073+1xCc9H1dMettdFAKLgFRTd43rToUJLrlunl4paR9rKXYqnteUaUkV+V2DTQ9aAurP5qqHcxuZwDVklj39ImEOfJV8d3OdpjmkvceLR9GTZnv4A9bxE8Eqsyh4hcR0K4mCKAN9jfnpfwbUhnJcirUOy7XlAyMC6yRui88mOQhnkSCS+z0g26Ts+vUSCtIPWgZqg5J5/NuZq/VCDvnTifYJbOhFDB6/On2tvc1dV+erkdjKHwh9zvdDYW2+mh24h1qVa72b5FCAPLryH95brSQwqTaguh6oB+8c1onO3kUHMh/nVYNRNQWXzPSQrCKOhIsPlwq2m/mLcDBZGB0z/a7wbWLp4FtbECvt7XXODUbWVu1qPzwhTjQ9HBJFdenhY+eq8Z7eTG9h1kkySKBuTLAv/ZJX2fJOXZgonZwmH2J28wF7LU9pVmxBRbd/utxSwyaElGZL+YrH1LVhlL53SSIbAZQwUo7chw9yywiOId8uujFx6Di0ZTUdM13zVX7uGL4/VO0yLRoaKnS0TOsjJTCVD4C3Td2qkzMjWVy9Yla5Wy8t+983nTa9WH0541G1fqrjsH5OtEYHizmhkgwh9f0oLyIX6i3+CQ2ZE6WbimurCVX5ZosQZ92UCenn3VoyqDVrF0eyoMlIsTmtxsgkh0UQEMXINCU/bkA5FHqA+Dc5Y/EvpMbweL7+ZrJ/lJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(39830400003)(366004)(38350700002)(2906002)(44832011)(6666004)(83380400001)(86362001)(6916009)(38100700002)(66556008)(66476007)(2616005)(5660300002)(6506007)(186003)(6512007)(52116002)(66946007)(1076003)(508600001)(316002)(8676002)(8936002)(36756003)(4326008)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A9ok9kQwZ9MFAdet7hdhAnt3Ce5AjZ5c1i8N3H9Y1NJ/pmBF0BmEMIbAnJI6?=
 =?us-ascii?Q?k2bzReO3Zo0DQHTqQHUU5+oe03iA9AV+mRp0KAsZdomvJf2Y/U+XvHsIPH3o?=
 =?us-ascii?Q?loolo0cDdleLDv41+PV0vCJprcnTJCWlWw2u+k0mOjISO17CvWuNf60uqH33?=
 =?us-ascii?Q?34MyZgQyqfp4+/N7Gr4G7jiBbIgsLes4d7yJn/QmuW+dr5CMCpV6YbRP2sur?=
 =?us-ascii?Q?mBIH0c2h368PJ5O4IMqBOsOE8Qr4OqhFnikPaKVPPEhnf4Q+IXXmg19JEVxk?=
 =?us-ascii?Q?U1f9boY2kCBAT+9idLAualmmrrYokoUMc5pb5pWLfu+CM0reB1M1ac/ylrPC?=
 =?us-ascii?Q?OEQJOw9f9BJjNbrZ2O5Jx0w+oreA9+/sHc/n405haO58pYN6GaBEokBKdcx7?=
 =?us-ascii?Q?F7PWaXJr6Myi23pev+sCQCc2MpnwMhL5rGBd9tqu58amAxxhBJ40XvZ9HB1W?=
 =?us-ascii?Q?TJCYrxZOhQplP+qmdS9SmXDLL1Wiihq0aA2WSyc/P3lppNls1bDMPl2OKoKY?=
 =?us-ascii?Q?2yH3LydDqZB4jZfS9TJWhrNEJTwkkUaswj9Wv29jg//GBDojobllGDc+2+od?=
 =?us-ascii?Q?qET065rhpamCGShoOMp+h3k+7p6yT8+Ek4wDhgU+GyCd1KM/+fRQD8otOsWI?=
 =?us-ascii?Q?pc+FxB5LAWwqOr/l0KTiHOLdrm8KmQ8CbeK/l/2qbFAKt78/OwsZ//tPYx4Q?=
 =?us-ascii?Q?efI3cdLKRf8JT4EIu9dXQJvI3bw6qEKvVRpx3ObhWBMDzHk1kV/5o0AEKaCe?=
 =?us-ascii?Q?CGkfNP4ZYxLeZawzr5U4XqT9zP0uZCdye9y6Lsxz5QurOLHr0Gqm3I49uhuX?=
 =?us-ascii?Q?NS/v4+R0ItnFMyYqYK3iBpAcl3CBaiJmzCG740XpSlQX9E2NA6oAf3DKb8TT?=
 =?us-ascii?Q?sUersjAgUJkO/dM1NgAeOJMSpUIe5G3wVvWibouqiEPOiAzPGxENoad6bxn/?=
 =?us-ascii?Q?P1ROl1Cs8kkw5Z3hjB/u45rwg2hXRiKX2W1J+rKVqMiRJAXTowLhsxaJHSM6?=
 =?us-ascii?Q?O+CIOus78wGXw7c/LP+/6x6Wo1CLl0H10PbKjxmxLbOaTsLmi39rjAbr38AO?=
 =?us-ascii?Q?YIR8UyhlmPxPeqKgmZerBzFK61Pt/ZBkbBdeh4TY9vYclCA10EN1a925T5m7?=
 =?us-ascii?Q?WX6qiHgAEFJksPZcjhMva4iXaO44LgmE2vejJKEL1Rv2otOiDE4gLp4GJTnr?=
 =?us-ascii?Q?bgbaz6tzWyYrPkcCKDbbU1+3fFvxpMuAuuKOMIjqKiz5gmZUQDOy9tHXauxy?=
 =?us-ascii?Q?z80Zy0NXsMUdKTZyzdjKukj6oYEtMa6dayaIxwuJE+iaZlBBc/iaKL6fYZ3y?=
 =?us-ascii?Q?N/19SVneUcpIZDN4baZr/0cvvAU1An9QCpefXHF1lIkzJSAKIAjkbt5pSZ2Z?=
 =?us-ascii?Q?SqHhTqsplY7Lz+9upI2ElHmwqktmsrJ8juLrwrOhhsYN7c/yZj+VtPY7Fsg2?=
 =?us-ascii?Q?mz2NvvBd60RCQ6XZFd3k4PY9REc+NhYeFFPXwfvESD1HGi+WTjbu4l1XYb6n?=
 =?us-ascii?Q?dSVMQ5tKmoAYfuZK+pqS4bs3rTRtksK0GpPq1GA5jS7Yh8eFu+9TsVp+0Wdd?=
 =?us-ascii?Q?c2o5kHsjnZ18GVaN0Jpx6mJ18G7R6fG1f+wrgL5kYlDXKypIxjvJzv/q3UQu?=
 =?us-ascii?Q?K2gxh6k081KZ/waZcQK6Jh+X9xNlbqlm0VWyZAMM8E8atVNKP1xK0X/AUZnB?=
 =?us-ascii?Q?T8thzg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e2f2a6-83c1-45d3-7f0c-08d9c0b7fe25
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 17:17:52.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1yXelgNQacMjl9iDwDX6ri9quz6h+RCzy6KxPwSlz4ce02JXFuKrLKqZDLmbKwIXnTtLorsBYggTcSWk6JUkr8+q5BmxpHCQR4hzfZkpGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In line:
	upper = info->upper_dev;
We access upper_dev field, which is related only for particular events
(e.g. event == NETDEV_CHANGEUPPER). So, this line cause invalid memory
access for another events,
when ptr is not netdev_notifier_changeupper_info.

The KASAN logs are as follows:

[   30.123165] BUG: KASAN: stack-out-of-bounds in prestera_netdev_port_event.constprop.0+0x68/0x538 [prestera]
[   30.133336] Read of size 8 at addr ffff80000cf772b0 by task udevd/778
[   30.139866]
[   30.141398] CPU: 0 PID: 778 Comm: udevd Not tainted 5.16.0-rc3 #6
[   30.147588] Hardware name: DNI AmazonGo1 A7040 board (DT)
[   30.153056] Call trace:
[   30.155547]  dump_backtrace+0x0/0x2c0
[   30.159320]  show_stack+0x18/0x30
[   30.162729]  dump_stack_lvl+0x68/0x84
[   30.166491]  print_address_description.constprop.0+0x74/0x2b8
[   30.172346]  kasan_report+0x1e8/0x250
[   30.176102]  __asan_load8+0x98/0xe0
[   30.179682]  prestera_netdev_port_event.constprop.0+0x68/0x538 [prestera]
[   30.186847]  prestera_netdev_event_handler+0x1b4/0x1c0 [prestera]
[   30.193313]  raw_notifier_call_chain+0x74/0xa0
[   30.197860]  call_netdevice_notifiers_info+0x68/0xc0
[   30.202924]  register_netdevice+0x3cc/0x760
[   30.207190]  register_netdev+0x24/0x50
[   30.211015]  prestera_device_register+0x8a0/0xba0 [prestera]

Fixes: 3d5048cc54bd ("net: marvell: prestera: move netdev topology validation to prestera_main")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0dbad5cb88d..9064353ea0fb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -765,23 +765,27 @@ static int prestera_netdev_port_event(struct net_device *lower,
 				      struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
-	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netdev_notifier_info *info = ptr;
+	struct netdev_notifier_changeupper_info *cu_info;
 	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
-	upper = info->upper_dev;
+	extack = netdev_notifier_info_to_extack(info);
+	cu_info = container_of(info,
+			       struct netdev_notifier_changeupper_info,
+			       info);
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		upper = cu_info->upper_dev;
 		if (!netif_is_bridge_master(upper) &&
 		    !netif_is_lag_master(upper)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
 
-		if (!info->linking)
+		if (!cu_info->linking)
 			break;
 
 		if (netdev_has_any_upper_dev(upper)) {
@@ -790,7 +794,7 @@ static int prestera_netdev_port_event(struct net_device *lower,
 		}
 
 		if (netif_is_lag_master(upper) &&
-		    !prestera_lag_master_check(upper, info->upper_info, extack))
+		    !prestera_lag_master_check(upper, cu_info->upper_info, extack))
 			return -EOPNOTSUPP;
 		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -806,14 +810,15 @@ static int prestera_netdev_port_event(struct net_device *lower,
 		break;
 
 	case NETDEV_CHANGEUPPER:
+		upper = cu_info->upper_dev;
 		if (netif_is_bridge_master(upper)) {
-			if (info->linking)
+			if (cu_info->linking)
 				return prestera_bridge_port_join(upper, port,
 								 extack);
 			else
 				prestera_bridge_port_leave(upper, port);
 		} else if (netif_is_lag_master(upper)) {
-			if (info->linking)
+			if (cu_info->linking)
 				return prestera_lag_port_add(port, upper);
 			else
 				prestera_lag_port_del(port);
-- 
2.17.1

