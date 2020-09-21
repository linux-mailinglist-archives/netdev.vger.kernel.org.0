Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995F72718BD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIUAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:10:58 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:17287
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgIUAK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:10:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPJ3ZVzg5bGwwjd7+T8pPeKhe+gErclVMFB9RS/FzpZr8qy1ghpnTE4oDe7Mx4RCoLNfPJ4ihR4fM/lF6GZX8dmcaqcq0omPbjw/ouZcVU0wuadIrjrEQvu1acvmHthd8pB8x005GN4zp24xvTtNP2dQERvCRr1oKS8JfOnMVREBcz0e2Pa+NCv0br7Jqgopw59XpU+BIYnYGDiIMxnebt9AE8vR4C2wSC2fjcBfDvyq21eNZIJyNXOesTiVIMi56qvqAaYsTqwlV/oaNcm2wA3XWTnPGqGu8Uj/3UhTLVxctDoZodLKmoj6Y0/EpTPM0zM1Shx4Cbo/QfELmQraLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5FqWTw3SkqjQ1qYHYjT2oa5/hlm8JiyGOm1hlMVMu8=;
 b=jQRnZrx21Vf7TFTtrHASOWZUvAgwItwKdsj7XGhVP7O4cZBOx/B9Ti8oT1/2911f1D1EuH8Md1Uc3yVsi/48zC+kyOsbRdrmhdN7SiYbvnFha74YwjzCKimdZPHeoo4DPScBTdv5HxmkM7wg/mQV+VE7L+jxzaL/nNM/XianLYHOumSPVRdMztbGW4np/W5fWDWF2pl/Jamcpw0n020xR002kmwloLV8MSw3Fv3mRDk+WOaU+zsXBgQs4Z2bemWZGXcF56LmnK407tQBvk6YfqHmfaqeDUes1NmMhkqor9E5rv1EOyypfdJeW+mLW3zT+Ywg59U+0cz1K51D3OpqPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5FqWTw3SkqjQ1qYHYjT2oa5/hlm8JiyGOm1hlMVMu8=;
 b=i871xk596FmTZETC/rNtKH+s0GbSIn4vjGdK/lpYu+o53eczJtYmDxcxD3ET3b00JMypoXy9ORcm/Q3o3ZQS3Np8dfl/+HhzPMcka2/yR2ul7IdXvguYm58gL6A+2oKKE+1mHKLXXoDOiAXCLhS2Vm2j5njVWCccJboM/fn1UAA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:50 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 2/9] net: dsa: rename dsa_slave_upper_vlan_check to something more suggestive
Date:   Mon, 21 Sep 2020 03:10:24 +0300
Message-Id: <20200921001031.3650456-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:48 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4ee472d-dfd6-46d4-769e-08d85dc2cb5f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501F487EA49218CBFE82CD6E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQttpSwg+tUQpsp2VHThwtmeSFhtjVT1ril7vGYXssvg0hJr/0qh1UdySg2GVdG5GP/KAO3oM1GsDwHpvUU5nmqU44wqQdGHzrRHLZdB7fHVfNVeZAsEE16wceRlhKUQtX4KlHpXF6fLSmH5AsyyFMHOm3MfshBOkQw7ZvUJ8SdUDmMF+JBcmR/nLEM52lH5kps7uQEALCsAtKzEyUeTwLFrGzy5pwxwoaRsCz+BlpqtYPRjxn5H8BLi1rHlNI9xcPg5IYw7v5pEbC3GXAQhPcARYHU2eyK+EeoMQN6NDKMwEcQucwVnF1wYL05cx+82oSv+fy6+5pnhdohllKgQMypCJ9mRwjRQOVj8NI0di9bTHc3CtLbLfIdSH9yvbosa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hFdMwZAjaul27LH/jIuCOHupzpGV/pJQuRLLSkmJAgzor2erSMjdVTBPdHU8vfWn+M4rmtb4eNDtUOq13vIPfPF4d7w56KdEDYFOwKVZrzLl8D7it9cELHeYuyT61/6RxxRmVRl7zwTKsMoxkDcdRzPuiWav5TfE4Gb8R0e3Kv4jYbmkhKZr0s0JjMLfxxpfZ+vpxmm/zo9ijeDV4Ipg3VmOgLbelst077kkA0loFnb3FVLkHt7T1tUZs5j6HTmy5kUet3vYI0J0ibn8DqAP9RuzGn5JYKB3WxSaMVfKlaegs+3A6zqUHAHh7cIB0FhM1etS4a7aM8twINutW9/mYTux+M/Hbn8NM+0pzNNtoiwDXlxOb6MRRsdzDtiqem2J+9kP2EaeNx6z2JLBdKBRIY8xGN1YXuredIrUJF93wKwrHANMhfFPoERt98MfhpShI3N8pV467HFlngU4NDe9k0KaMlg66TGuy4NzPGx78DCmiDtJV8cjx679BdXHUriTBahOaBZRZVOzFVHoYnCw1VLMs5N7eKpyiom8Vk2QPf28G2uGhZu4DEseKtaOIE7lbHXFUqMBuPYEW3roPSuutmznBwDm1B3xQPtKkqdCCjbRud9ITMdmKFLtEn+Q3Dld7RP7/ynp33NOIAkqCJFqQQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ee472d-dfd6-46d4-769e-08d85dc2cb5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:49.1813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLMNllMz4G3+Bavq7F/sr3yQyCGtVGrgJAx3l6dpIZT79HIVk3QTvs7xBsi0qc9f3t7tV//UnssUzQCHdOaZDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll be adding a new check in the PRECHANGEUPPER notifier, where we'll
need to check some VLAN uppers. It is hard to do that when there is
already a function named dsa_slave_upper_vlan_check. So rename this one.

Not to mention that this function probably shouldn't have started with
"dsa_slave_" in the first place, since the struct net_device argument
isn't a DSA slave, but an 8021q upper of one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/dsa/slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a00275cda05f..1bcba1c1b7cc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1909,9 +1909,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	return err;
 }
 
-static int dsa_slave_upper_vlan_check(struct net_device *dev,
-				      struct netdev_notifier_changeupper_info *
-				      info)
+static int
+dsa_prevent_bridging_8021q_upper(struct net_device *dev,
+				 struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *ext_ack;
 	struct net_device *slave;
@@ -1949,7 +1949,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
-			return dsa_slave_upper_vlan_check(dev, ptr);
+			return dsa_prevent_bridging_8021q_upper(dev, ptr);
 		break;
 	case NETDEV_CHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
-- 
2.25.1

