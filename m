Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9943F454411
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhKQJsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:48:04 -0500
Received: from mail-eopbgr150117.outbound.protection.outlook.com ([40.107.15.117]:60302
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235381AbhKQJsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 04:48:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROwtpwJ7ovI4nHAp1FYSWGjllhOzmF1oOhOPUwJBSBSQvTE7n83cDv82EXJKojp9TBn4Mt7KZ5AuopfoyVLLAutWtpjkrIgpuGJYmhZqb1LSb5ln71JKwfVRoTepWavCy76r15AC7i5WgUDV7Cpx7UKWybA7OGL/r+Wo0DqtkQRCVh76APg1RzeS7/6KqI5xh29k8Ii1IOdPuuPXtI1eHZUEju+Z0AUUCMEklyTask0e5Ybuf7PPCzEnEjfTM9cYOGhI1WYC7lWkJko9F8d61rco/HYCQdqoSk/xCz0L1+evqp20DJ8XNegQrN516pBWcLOEyq1d4UmDC81Ht4lhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PAlIqiCyCHzkSN3c6eFghiSD000sli0QQFOZ7UYnBo=;
 b=YRL4rqPlizGf68l4p0xdqccDjrA4MpSvgNcFrZcJVh6mMjRCfxWx/44fR6OgcEz2wSZilZV7k2dX/Eddg/TcSuhDJw/EKuo5CGcAxcCVuX0RfD3AY1Y4hRcQme0YfTArp1D2sFgNApkQgxNpsGUaVikrQfeU78N+lImSkS2oAa18gx7PbSUY5BkQyngNrODEzXlFV5Z9lGbohZly158BRXIzL+HCK2YJNLbrlQOkArvxLZEsaa9PA1lL0xZ8JqZxD4NE52rF0kdNaSO6l+Y9K5ZhL3CwDQq16Wajx/ndyM4HSi/YWQ/znagjLLSUgY0LBVipviVlNp/cViFf5JLPcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PAlIqiCyCHzkSN3c6eFghiSD000sli0QQFOZ7UYnBo=;
 b=gIsyYenU3ZuinLUM8/0eSbmn1RRlfbAAUnaIYdRrjdASM7YvzOrxumgrf6yWTD2J4MAZ25oWskXIZcFPhH/7THtQzO5tMwmLQNQp/MMP0ysdpUoNQSH/+Fe7B7++Dhzdw9hDCduA56kY5jpkPDP/xgfHIu+qV7iVj8w3KiYHbCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0989.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 09:45:01 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4690.026; Wed, 17 Nov 2021
 09:45:01 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix brige port operation
Date:   Wed, 17 Nov 2021 11:43:51 +0200
Message-Id: <1637142232-19344-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0035.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::18) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS9PR04CA0035.eurprd04.prod.outlook.com (2603:10a6:20b:46a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.19 via Frontend Transport; Wed, 17 Nov 2021 09:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa9990a4-afe7-4430-5ef2-08d9a9aeece9
X-MS-TrafficTypeDiagnostic: VE1P190MB0989:
X-Microsoft-Antispam-PRVS: <VE1P190MB0989602C2D30AABFBFC7ACA38F9A9@VE1P190MB0989.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VROFRdX5LxQp5nwDc+T8NRqL9EhM8kYZN6+e6wN9XHfXgcRo1Ob7YE7cyd0kJveVqwT3xa84ym2IoJEHj+Yhg10fWkA+qPa9ObHLoOFSneH17i6uPnpsu9V16EZ+ulvD/2GO7iLlTrhjFaRj1zH3Kq+6dmR3prgD/iGk2gwJ71chDZMIHZOuWZkztW2ZqKsj7ko2kfvnWxXVuiYFV8sxuAl2CYCjSYrgPn8j+HfDpWLD9OHgtwTBv3bxBAV0FmZ06V0RZegr9tBlxtr6K6iFc/utk+d0jADdCfUr1zIYNU8iAwBI8hk9HwYgU5wIkBsluRqKff5JkJ6k3nUAkz3r3NngzCsDm70POB8OjIkkLyvt/06D9ZZOmN/N5eSSehYQfgN4e7enkpVthnhZYOgji+s3JdwqtSH1pq4uqxy2l2Eik8Y89XxCwX5q4IKDV5hxk0T3zxcSVF7mZQ7kO48PsnZxk20CyTd7Zjdj1sOgWGE7+bsdSOy/psfYAHgYoIIkjFnmlUQP8QjyYNytOBmOQhGvpaS5bGheLvMD1DMbvJlp62yS6IbIeuByOQlCMB796m6Ttzeodzyrde+mLiuEMxNODj/t8AZAeiYYWtCF+BGKcMcLqiglajzTC0V7WiD1t+ijqJLeHRVgu5o1FhV5B1lVgDJiyxAaUwlGyeIlvs7bMfaArg8oaY+U+phyJ9wHByKecS2eu4DUIt4m89cLtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(376002)(136003)(366004)(396003)(6512007)(6666004)(508600001)(316002)(26005)(4326008)(956004)(2616005)(83380400001)(2906002)(54906003)(38100700002)(38350700002)(8676002)(45080400002)(66946007)(186003)(66556008)(36756003)(6486002)(66476007)(5660300002)(6506007)(86362001)(8936002)(44832011)(6916009)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cN5Mjys0x3yGhUnna2Nl1pcw3/5kHGtaWOR2ZAftzjnVA7KuxRpCgEFslDEH?=
 =?us-ascii?Q?kz9cG2vIcUGiWyYR7YZ1JomC+BOa1qVKyqDt1E0kFi8bVAcZeXHriRVTku9h?=
 =?us-ascii?Q?7MAmy6q/Dwp0LS1NsYJ1Ppvt70jgeBvgi/VSSCaC/Q2iNZl2h5My5DXzyhGa?=
 =?us-ascii?Q?/e8Osavn11uf0POoKGPJzPc/l5HlhcAeutMz2FLdxb30cS58jwW71TBjkDnR?=
 =?us-ascii?Q?jynwZz6ljg13mw11zxpWaAbsGufiBsXssckk6cBNqk1cQ5wfeetyXQ9/dTSC?=
 =?us-ascii?Q?IacLiLvWjdDxSZhmHC1zbWbI/2BMI1Lp77ft1hXpkJp78TcKRoRyXeYq2S5M?=
 =?us-ascii?Q?6b3YBE1Xh8IYkTrP0A9zlYoJhQrvLA8vai4kBpeqCQ9gg8vJq6y3G2bTQEJQ?=
 =?us-ascii?Q?4ATc7oECsFKt0+hRH25jY8Le4c2X5839dXqCliUocP6LbsAIfF9r+701BMzU?=
 =?us-ascii?Q?a9DUC6OkF5h61QM2rbpNte1z481M+QP5dYMe2kF6wk/KsZE2Wy5B5uUJ2Fd7?=
 =?us-ascii?Q?oLaSL+IuXYr2TRJwyz67rGehx72ZACtxSGdYX9szLkNh+y8SyaxFA/F/xgdK?=
 =?us-ascii?Q?t6wTcOe+DnhbbYrDo44FTEr351utaS6B6QKHUcfDrLBQq6dISYoNj/fm6AP1?=
 =?us-ascii?Q?n0hp96vLrrA1IAWP18mkEY+SxKz7IDjCp90J9E4CzSH11mv3SDoikgFV1f0C?=
 =?us-ascii?Q?HMnIrQBsioY8RnTdC2VZxWLa/N6pT+hmkdnS7WsxgbH2TX2049djP4N9g6tn?=
 =?us-ascii?Q?dVajPv55ipErMSqkiZjIUhj/KR6e345UPp95ayqG4cMET2M12g47zWV9HMFK?=
 =?us-ascii?Q?6llByzblMiQ9Sc1QkW5ySEDM98raeCvIst/KBVntut1uHrOwdXpr8xjoZFXT?=
 =?us-ascii?Q?6EmS0cbhsyf4d+LDJym381ekR9YVGbj4WCoJJw+6zI7wwJlf4k+waqmzUn6f?=
 =?us-ascii?Q?GJzaXRJMC/NwazhoJ4uAWoN3gwpctv3uBk+kwKC1rrM/3GN+DwqEbMhympno?=
 =?us-ascii?Q?xcJhMIo2ZnBf5AeChUBo2tZFVCE+dUYLg0bZItJHcs084xA04qvnrsh8sFIs?=
 =?us-ascii?Q?HotVDFO9Sd4h6/0lzy3pdJX3F+eaJPhFxf4HMpe+2oaer+dwnId2lfPHO9yo?=
 =?us-ascii?Q?7pyeUTGYvutS+4UQVAP8WXLRq1h32PzYwQj6k7sP9dSgbwHOTDOACGe4TMOJ?=
 =?us-ascii?Q?xMV/wjYJGTPlItKFD5Itm/PdU4d+WUcXh6XxKbj0UXMqGYOumxQ/D8IpoiTj?=
 =?us-ascii?Q?2Us713IMt0kEmEDH9PBE4Ll4sJYRQDhpp44eDru5BRHyx8VsjGblzuPMaMol?=
 =?us-ascii?Q?ad2Zxx/I+i1hrg3n0O6vIEwyOtlB1eriLUW/hSuGifgN8ggWuEVjZMSs27t0?=
 =?us-ascii?Q?bjOzDhnNUgZU4gHv657jLgp6yBrntoqPOKOinWDbxz/UStOJJmOb4h6niI+1?=
 =?us-ascii?Q?lQvjG7xB747oHbWKDHgDHg0WlBHe2J7K3EEXPy+JUMVDDQnDl34KUnTXHnT8?=
 =?us-ascii?Q?YONQtfoTdEtVcnhuhha8r93QXyvptjIXyVKrmMtEOPObxxKV7s/aZIsmaBep?=
 =?us-ascii?Q?lawcMUjA8KPl9ieGaBQJFBOiTPUgH5VeSo4CW3uxTZMgXJc2GPLBqt6+GCtN?=
 =?us-ascii?Q?uEVsuIuFMZlzDsWp0iY0QDXjQ42MdqentGTgGu35Vok3aMi4J6tBtvXLwk7w?=
 =?us-ascii?Q?q57kpzxTpq+wQf+36+eAjNqzSHM=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9990a4-afe7-4430-5ef2-08d9a9aeece9
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 09:45:01.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wGIZjAqzc65+TYO96bNoFJoVrsE1Ko+F8h9nAyGmUMMinqMkLKTd4AICXoWrnyZAMj9Sum8bTyVtmlDG9cgy0KMN1lbWq56LlrcpYJV4SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0989
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

- handle SWITCHDEV_BRPORT_[UN]OFFLOADED events for
  switchdev_bridge_port_offload to avoid fail return.
- fix error path handling in prestera_bridge_port_join to
  fix double free issue (see below).

Trace:
  Internal error: Oops: 96000044 [#1] SMP
  Modules linked in: prestera_pci prestera uio_pdrv_genirq
  CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
  pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
  lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
  sp : ffff800011a1b0f0
  ...
  x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
   Call trace:
  prestera_bridge_destroy+0x2c/0xb0 [prestera]
  prestera_bridge_port_join+0x2cc/0x350 [prestera]
  prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
  prestera_netdev_event_handler+0xf4/0x110 [prestera]
  raw_notifier_call_chain+0x54/0x80
  call_netdevice_notifiers_info+0x54/0xa0
  __netdev_upper_dev_link+0x19c/0x380

Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3ce6ccd0f539..f1bc6699ec8b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -497,8 +497,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 
 	br_port = prestera_bridge_port_add(bridge, port->dev);
 	if (IS_ERR(br_port)) {
-		err = PTR_ERR(br_port);
-		goto err_brport_create;
+		prestera_bridge_put(bridge);
+		return PTR_ERR(br_port);
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
@@ -519,8 +519,6 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 err_switchdev_offload:
 	prestera_bridge_port_put(br_port);
-err_brport_create:
-	prestera_bridge_put(bridge);
 	return err;
 }
 
@@ -1123,6 +1121,9 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
 						     prestera_netdev_check,
 						     prestera_port_obj_attr_set);
 		break;
+	case SWITCHDEV_BRPORT_OFFLOADED:
+	case SWITCHDEV_BRPORT_UNOFFLOADED:
+		return NOTIFY_DONE;
 	default:
 		err = -EOPNOTSUPP;
 	}
-- 
2.7.4

