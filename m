Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2554870E0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345682AbiAGDDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:03:00 -0500
Received: from mail-eopbgr80102.outbound.protection.outlook.com ([40.107.8.102]:24869
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345680AbiAGDC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nF6Fy7nSjyE6yEy52j/U0fM+Q7I5rBhJOSV/jPSBdG5Ph4nyUaa7YY8+wSYH1BHekIpdVsn9KvSEVDlRYfamNTVjleUIVFgJem7qWqehY5upUp+d7xWKGnCI5iF77UfzGHsfQwJm+1khz8fJoucl2MUuk6+w57bt04PNG5HH4Etb9o8hKwapgEqC2SEf/kUVpXhThhwvmjczLEV2JZWs8oVcnhGMfINhI4keAzUHSVhkoHOyY14mMGjosyxUi06FLNgNO4BqkrpfbaZadyKJDf8tEvxrkpEWYklxiyuz9JNShelRAx8btTIai0YV/4FJMeHBf5M0JrVpdLMFTKy74A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZSeHV6TgHNfbDkuSoB0wXfuWi9efjT1mB0l0RMzt/0=;
 b=QaOETVwfnZqL3nf6fd6OH3UxHcUqW4Jhu8S4JKeh94JJggVwOCy84abl+T3klHHlLN6ObXb/npwSKVCmk9doazyjvy0757ihbKQuFRtjgN/mGh1nGX00Jt9MdxSINSkm2aDpOJMsd2UWAWGsZx29ka61bntu8XSBciE2/fISgm8f0+qKlOah4UwK0D2n0/CepzSECEJs6z1B6R49wvIxyo0i4p0e3YH80NNC/jHmGVrrsn5sZHGK1u3RPlgMqbIGtcUv+xwnX03B3NVUv/MUNVpSTYWpWSiH7OD0prsQCcXdSNSOwBd8i/Ozk37EOOkiwXW0CLBmR5hu1yncSxtVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZSeHV6TgHNfbDkuSoB0wXfuWi9efjT1mB0l0RMzt/0=;
 b=RNmTAR7CIXbvjh/HfI7WBZRPBvCmRZX4Gz/K0C9siSYeAKm4emXq/+zPDgeZmZz48vuwZtsDY1OHwuW0MhcTER28IRGBVAoisrrp3noxLUSAilRFwbMuEqfqQdurBqV+w+/9Pe3NwPyBAyY2S/bVI+y1TMPCEg7JuB3ZSOHmcOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM8P190MB0834.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:39 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:39 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 6/6] net: marvell: prestera: Implement initial inetaddr notifiers
Date:   Fri,  7 Jan 2022 05:01:36 +0200
Message-Id: <20220107030139.8486-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0ae8033-495d-4e85-1a82-08d9d18a2a51
X-MS-TrafficTypeDiagnostic: AM8P190MB0834:EE_
X-Microsoft-Antispam-PRVS: <AM8P190MB0834572DFDDC53A5680055D8934D9@AM8P190MB0834.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:203;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6an1lyrDr3oEQwnEX5Wyhtmg+dEmuumcsU0nWHn8mJmxScYsbMFInnCpnKtQpzts6Zzvv/7yYaY3BTYlSaAcsZu2xvjbjkRDNZoCtNWUqonDCDmIwpptTjEcfuwuSbqrh2UBFS03M8JNVw8w15wovDOn9P7085cNSNSYq/B/cnWqPC6fJyK7Df8Sk6ZaeG8nq/XfXPOGz43Jmwvczh2Ga0/PRxhJznKqHd8MaEzJdCKB/qwFWY5o6sHbne40d90zLwM8MFMOe9aLP5H+NGTGnKoxEIYV3BsUTLxE6xWgjuxGHRH9lo3fyORBj+idgOVilV8N1Rx69yY74FXs6JtjHyCwrFMB9YL03hELiVtXaBiqthdD5xC3djiNbdmDchM/8RTtPbqAIjLpOSS20++0WbpcHjAdGuSRU5I0LM3dzKRkSZE325zQKkm1yWJ0yO49ZlW7ybLLJabSd2IqGW+t1aeFlQfLgZGYQY2OH1gWVKA02ddtzLxQBsjvd52/iCX5/DIw5NkssEgesiqgz+pdbwudWttTjbE1+cb8ja64UqWAarvJhirg4CwovyHQUflez5ePUn/7RIxOmRva+/W3gyliFyMCncNQE/+l0JFeigsgQ+jT7Z9pj18pXbFBVboGs2BG9q34HBcWM0oJBN28sgpvFFaQBFkDFFmuVOcenIW7rkxHOk3/fIPwISX3G3T4LLo4DvrWyX+6h8XF8Zs+pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(38350700002)(66946007)(316002)(6512007)(86362001)(38100700002)(1076003)(66574015)(8936002)(508600001)(186003)(54906003)(2906002)(8676002)(83380400001)(52116002)(6506007)(26005)(66556008)(6666004)(66476007)(6486002)(2616005)(5660300002)(44832011)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPAA6j786I2GFmhBR9khQ9jWl0oZh3/FrH0fpPxzIk9ocXhLVZ64qJTfVBgL?=
 =?us-ascii?Q?gnEE2w6ZHGvjkF9+0PWvaHh6ycOhDCVTbEhR/ThhoZrwF/NhAtG3hNl7a5Ri?=
 =?us-ascii?Q?oCyeVw9ZrmU83yBhnLatM0d1sW0OSm+dySseMMnoyY0iQBWXSRLyZ6mMbNRl?=
 =?us-ascii?Q?j2QF69WYiLn7ZXBJ+AEAudTRgwm6qVw/n4y1QOE0wvjUfbxVZiOV/3K0xV7d?=
 =?us-ascii?Q?UprYJuQDOc22SwbAyhb9JhssfQlMhAnmeuEVBXe0EVUqM4YyWJMBrs4h4cp9?=
 =?us-ascii?Q?EeV2EeP3XvBTBi9qj7vACY2+Awb5qvTLuGdOkvtzdOny2chCpMCYFyXOxrkB?=
 =?us-ascii?Q?8sxtY5DADa3Pa04d3NrcqFRKP4Jzbd0UBi52FEmufV2bKQB2SQuRZGGesG5h?=
 =?us-ascii?Q?Oeq1Vm3/jUZoY3sobnzja/sHdapjb7X2ocwfESZb5E2q4sw5qF4/ErMIvJXQ?=
 =?us-ascii?Q?8k13HVjLAWi+h9Mjfw0Y1EVOhzUYaSEJjnlBwWjfULqpOSNWB7vkxkGfFkRu?=
 =?us-ascii?Q?R+nW3x6CnUw7zSpRUPejC1xTPOLKWT+8STsO/qwC3P3ClxG7i0nIhexq3Nbq?=
 =?us-ascii?Q?J9eB8HRebxRbIWp+eGnRHxx01II1pFFeM8E6MbSdJ1JsvoW7J5ag4bHLKKHx?=
 =?us-ascii?Q?N8tQzpW5paSvxFVgGgppksy8MfmKR5g2kUGF4DvktU/fDS7q/X0VrHSJvDXX?=
 =?us-ascii?Q?cpZJkoqrI92ascj11tXFxShxOZY6OFdM5nt1zO6LxGxNYW6BRR+knN+MmqI2?=
 =?us-ascii?Q?D2aEb+ZzwYV14Mku9pufL6yJaT6pFAHEapL47+5qM+Woi8HfvdjKcVeDdp/S?=
 =?us-ascii?Q?wRrsl8Mxu/zyfYxQjVV2pkjncp5/UvLg83/qhw/BJrPxI0zK3Ol9c6uojLXo?=
 =?us-ascii?Q?B4DrvzGOH6QrXIi3prag++E3Cbin0orN9VsuPsKQHTNCaqYHgGB4+TOkezxJ?=
 =?us-ascii?Q?rQCv77AGdbqeFmQHkL0xm2yC1Hm/88LqxZ/MBsrOoBRKq8d1LjiG2e1umQE0?=
 =?us-ascii?Q?ijxFxhNrwanhoMIo5qFysuIrBRA04zTdaKZbL5Lb0duq5apRAhhlZdrh7FQF?=
 =?us-ascii?Q?/wYNL4pcIRdow7U0ctyth8tSxZwVEkLFxlGqX6PlW13vBfWxCBQXylb7r2I9?=
 =?us-ascii?Q?jSip26LpAKRqfDxsN5xNd0zajfY60p3b1eb+YJ5Fa1wrexp46Y1BeyRiPSPM?=
 =?us-ascii?Q?TJQ6cHGfodQeU2Bm9UEH9MfEL0gO5uRyHodVQXKvD/NvvMeFqW20a7SeD6SN?=
 =?us-ascii?Q?rxKje74AQ1ZsnIDUeUv971Jtcuj/5bs1sB+ue8B2HcQf9m0vJm1cYSRXKA3g?=
 =?us-ascii?Q?31kXZwx3eM0cczxsjSMJbqANHk0aemHsd0YtX7Ih6YuvDdP5siFu972lBdlO?=
 =?us-ascii?Q?iNrXBtRU+XwQFe2XBlK+hIGaygE5WwiAfxq10AEx138Ys/XEbE4iSOu8jeuO?=
 =?us-ascii?Q?I0fixu01mQwMcnGIdZRZLHtki+0FvrRGSKU+hvdUEyM/5JuGXAig6ZDVHZ6x?=
 =?us-ascii?Q?E+fHjqyS7ah40bytpT4yNqQwTXuNuvt76B5is4UvVrAw0W0nzflcNjXZwTE2?=
 =?us-ascii?Q?uUEcLh+BZPY0Cf8TcuElup/05fBRIoV6EiEe5dKLRf02q/+V/ELRt8kbS/ml?=
 =?us-ascii?Q?lrdY8LfTo8/Vb4npJKC3MeTwWam1cOUNxMW74MM5tVpVMwSeIDnSY++YlBKK?=
 =?us-ascii?Q?eufJXA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ae8033-495d-4e85-1a82-08d9d18a2a51
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:39.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/gqH7kssIIU1a+4CLfgpffaJZL2oIrXQUkgYTo8zBwbNhrd/MoiN98NqfHBxPoGKnnyQ2sUU1nJnwOE0c9eMCEKo9E7GfYqHx3+9H9yuhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add inetaddr notifiers to support add/del IPv4 address on switchdev
port. We create TRAP on first address, added on port and delete TRAP,
when last address removed.
Currently, driver supports only regular port to became routed.
Other port type support will be added later

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Change-Id: I1fc7f2b62187589011f35e79c5f56e5e42389fe5
---
 .../marvell/prestera/prestera_router.c        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index b25a26522b18..c0c6e1f23803 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -4,15 +4,30 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/inetdevice.h>
+#include <net/switchdev.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+/* This util to be used, to convert kernel rules for default vr in hw_vr */
+static u32 prestera_fix_tb_id(u32 tb_id)
+{
+	if (tb_id == RT_TABLE_UNSPEC ||
+	    tb_id == RT_TABLE_LOCAL ||
+	    tb_id == RT_TABLE_DEFAULT)
+		tb_id = RT_TABLE_MAIN;
+
+	return tb_id;
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(port_dev);
+	struct prestera_rif_entry_key re_key = {};
+	struct prestera_rif_entry *re;
+	u32 kern_tb_id;
 	int err;
 
 	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
@@ -21,9 +36,34 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		return err;
 	}
 
+	kern_tb_id = l3mdev_fib_table(port_dev);
+	re_key.iface.type = PRESTERA_IF_PORT_E;
+	re_key.iface.dev_port.hw_dev_num  = port->dev_id;
+	re_key.iface.dev_port.port_num  = port->hw_id;
+	re = prestera_rif_entry_find(port->sw, &re_key);
+
 	switch (event) {
 	case NETDEV_UP:
+		if (re) {
+			NL_SET_ERR_MSG_MOD(extack, "RIF already exist");
+			return -EEXIST;
+		}
+		re = prestera_rif_entry_create(port->sw, &re_key,
+					       prestera_fix_tb_id(kern_tb_id),
+					       port_dev->dev_addr);
+		if (!re) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't create RIF");
+			return -EINVAL;
+		}
+		dev_hold(port_dev);
+		break;
 	case NETDEV_DOWN:
+		if (!re) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
+			return -EEXIST;
+		}
+		prestera_rif_entry_destroy(port->sw, re);
+		dev_put(port_dev);
 		break;
 	}
 
-- 
2.17.1

