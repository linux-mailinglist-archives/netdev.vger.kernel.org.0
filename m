Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647AB604933
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiJSO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiJSO13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:27:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20706.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::706])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB6B192DB0
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:12:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0yEXQDZoab2kL7QX9AXizRHp73T1MKP+zAdt/JCCJ1csIvTytT6Wnj79rMK0Jgi0tiDQ9mtM9mpYHg8DWaM0tkYzu0DHlbHoq1GG0/B0do+nklUqoL9UkeUbwdTe3wHxHCida+1mE0qDzLmFbFr6C7zU9OsQDDjpfCJtinKfnJ3JgdBsekES7z1xkoTRseMBEu/4F+me/cLg0BTmB2h/hl8jjoSR3AJzTQVG08Za47lxaG2IaJLVOm7+wbU6aeLJO4Z8Q30J6jEjmKamZrDppISZOFcTZ9xYoEofm5lQpPCv8rV3Hmk0NduYoiaYP2utgq3le87TYWY2pmdE7svLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxSDEVf06/ovcEqcGaJ3dBu6yC//3IwCFMt2ir6y1xw=;
 b=K4f+/IYLHV43evQgbX6iFoQi/zv4W7kQXEh3BClhrvZ1j4PfqhfPoMQPTvNrSXxn3LecQtUl6Y7RWv+DhWmbB5yErHUZ+ser9uwa/T9YPMyFuDlaEdZ6zB3cXPI2Rat+OoxIVq3s3CZYeeYKjWImreI+SBG1S80ha6uHfGJaWdwZ58suHLkzo1fKZ1vXFefAF3hHFU7MDBq/ihArkZmAjWzUsWW1ozfhOschEPj3N+pImbYLQDQ3SAKePAU1pLb7tubU7FgkbYyPgzHze2swJKHDvlY5X4igW9cFaaJPKClbjeih6F8UC83jcJgFWKcMrYA0H/7xLseFc2VvVEeHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxSDEVf06/ovcEqcGaJ3dBu6yC//3IwCFMt2ir6y1xw=;
 b=nlpg40V21MhO+pMixjaaWlvq0J4ifyhTMbhjQ9euAR1Zc3EkmfpT91Nhr27kMY9CvH/WxMc9OH0Vk3dNITwBW9/mt4g4s4MfDc1bOvQTo8rWjdRHe+V4RdsgrdxaEw6JY0jSzsL6svo47dFBoWW+IgGshep9Y5EoCXyxhiTTxcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4404.namprd13.prod.outlook.com (2603:10b6:208:1c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 19 Oct
 2022 14:10:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 14:10:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 1/3] nfp: support VF multi-queues configuration
Date:   Wed, 19 Oct 2022 16:09:41 +0200
Message-Id: <20221019140943.18851-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019140943.18851-1-simon.horman@corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc92b1a-4747-4f5e-1c16-08dab1dba889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ocfp2+ozfPI1rHRxAPdv4wzNdh3FcSo0pJ0qxee+ASB8iqjPPHaT1g5O1pPHCMyvSsN3VZucWekzy3KY0qsF65Kd98JicEqbWOjXwJpIK1jMPvaHAJ5FPi9uUxFWQj0FEOicKHKz4UBzBu1vb4nGEF0tWPu9SDxsbWlnu/598QwyVZWTimExwcHhee53UY8HZMQkvmMipC+4NqK6Ja+gv0LcHyaPRmIRRe0HN7/R07zH6QwZ+FbF8b+5O3+Gk0UVmiPV4vjNwJaivR/RyQh71NKe2HzXkDKp3kW2MItFR6HfhsP1KIT3V3qCvx/ytOvs1B75KweHrL+HGMBVE1Uw7ipnxmiKz/PVMZ8DqpNFC67EJzbFQYx8YycWbXltv6Ll2eTCYJdgBmPVpJJdbDgSeh8D828sai8/pfhFsF4cJSNKNbioMGI2Tth/u713b8KVFAILpnplwR0KgYMjiAoiEcrnF0RQZQVwUjWdGuLqgT4g2bjD5TTSpo67UEpdPN+xWzqc435w2x3s2xHS2UF2DU/3m8+ssR9Ttq3nDMQxA6KSji+S8ppSAYXe1+aziyIlZVNnAsUNL1n+cts8Wj63W4aF08cAgeUTM24OWaG2ou8e3MJ66bnF9rbn0RmK/megojo2ZdsxRYDdMHEVEENH250qL+m5wAzWSiCIqArniZP+bIUwk4TqALWF4DI0R2ccwVkQLEl5LBDYk8i5SMVqolTEQ7F6PUL31KMZDCEpw0IO1dXeBxdFZKpRRutBaNp3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(366004)(346002)(376002)(396003)(451199015)(1076003)(4326008)(66556008)(41300700001)(66476007)(7416002)(5660300002)(6506007)(2906002)(8936002)(52116002)(2616005)(6512007)(6666004)(107886003)(186003)(44832011)(86362001)(36756003)(8676002)(66946007)(6486002)(478600001)(110136005)(38100700002)(83380400001)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VBLh1t++EA41+EWDSqDmeKSnfOOyjk2IXvXQ4swJWA24GdsYhDxuRgvoEls?=
 =?us-ascii?Q?xhyx5qTR+T4NCyejejoWgHF5g3RQOHdDc5L2/co+ukOjJMvIX8FLpKCLdmG6?=
 =?us-ascii?Q?pQcLh7rmEjatn6lahyDRXEOLSQ/DaEJZzZuSenIspOnM8H31bWToKtu+aKi5?=
 =?us-ascii?Q?x3XUiLPClsnrjHpItEnCbYBwdZnh6R5+HYPwINxyAXbIbq0u/JRJMB+9DHgl?=
 =?us-ascii?Q?D5oyAlYd6Rr5pbBTzbW3Rfa8lQ3UV+GWCKrP/f2EcuvavarGtTecCFjR5Dwm?=
 =?us-ascii?Q?y56Twl7JrG+yxNQ/Hrs23u6GtClx0yfHu93jC9GFK514D1yzNRSBbawLUSaX?=
 =?us-ascii?Q?r4/mu4vWZ5yHuOs0trz0yMvRVsRwpsgoG+3ft5AVcy9pdXCalqObIo+rkgBw?=
 =?us-ascii?Q?kOztGCkLIZgsw3M64JgBKqePlPkui+kKFD67MK5n7+T5ZHcoTr4RTcT4/2sd?=
 =?us-ascii?Q?nno34EPnS0O8dRlPZmLhAxr5eHpzHVBb6ysDKVEwGEv4MZQQh5paia3heb3G?=
 =?us-ascii?Q?TUImF63G75IMRxYek5p2U9CROf0vw/y6nz/EQ5RBj/yFljcOacXMi9XwfmC9?=
 =?us-ascii?Q?Rq8kkgqH5zvNvNaaGe+DgqZZLD8WSoNO/9posd17idR4S0DkBZSW4YZZuwvW?=
 =?us-ascii?Q?ul5JYgSI2z+I2WYtLzos4vRDlx2AhE3/m/rTe/LC6Wxi11ZR5C5p18GAu5db?=
 =?us-ascii?Q?zzXggXTcKqWsSXVkV3VifLvSdWH8XYkbULSMovylqnMNbAraqw69zswSkpjH?=
 =?us-ascii?Q?50zxold8bmhu3LRGehUVL2DsN17fZIfQ6SJAUU6WTtSh9nfMa2VgDfkHhZTZ?=
 =?us-ascii?Q?jWsQkZtLUCUs9dHo3aNaknrfvl9KtRZi36tgSt8b9WxjQhKHTz85chiJ0VDK?=
 =?us-ascii?Q?GV7adiTLv6RMtNcviDML2qkMWccPM1qFPhl/TI9ZiU7nIMJzrymmrmHziL/G?=
 =?us-ascii?Q?co7mdiomV8uqx/H0nRQw3F/vW13yWKV30vVOVYKkTETwofYJiamnLdKaHhbn?=
 =?us-ascii?Q?GnKTKKQAF8+/1m/sAk8gwNIVqK7pVkcoTDO4OkVzLKgYiwljv1ZrYTO6f1nP?=
 =?us-ascii?Q?qpwWXXdKb30D10YscCID3MBT7fbXY0yC9tiEfg8QlTzKdYs871ZwFN5M8Ilh?=
 =?us-ascii?Q?VQHmeBG0rpiKdhjUubtqWBAZnQ1F+P2LSAejuaWC/F3bEU8oyPOY0JBVPaup?=
 =?us-ascii?Q?yCrZOu4D58YZtrnNBtKTQc02SOT7HvFkkU1rNdYFtz0pM6pHdDYFlCkYVQPD?=
 =?us-ascii?Q?VFw1VKfHt0TK4QHD2eMi1P8PeeaAXC+yKpyGGr/9agQeHdH1Vgl+gu/2BZff?=
 =?us-ascii?Q?JlYbwqdHWc2L6ooQ66e08HCon0QJMGppr/sgGLvvRQSaGxhYvwe9SKL2SVSP?=
 =?us-ascii?Q?ZoujRS8nm89VFrZ7LXYqFBa/VeRLxtjfTSH3E6RwEK6C6tOkrwzzjXjqIiz4?=
 =?us-ascii?Q?4V421DYvz8+GYSZhatQZNQ6EUqaUIjyDZUrRrL/lrcomkeuaMAr4f43qEJma?=
 =?us-ascii?Q?Ot9odbyjw55/9H5C3UQKEYpmBMZtFzh/1GPI9gSisN1tv0/xACEERFf0oNI8?=
 =?us-ascii?Q?ca2o1GV0L+7artPBFmX929QOTsal+MC6fYsxJ5ZotW/FBdoQuiHptMdODr+z?=
 =?us-ascii?Q?HEJJ8aZSeNLWyYxgkgstBqohBTt0kHrNzJap2gkkIUzJ8rI7roPuvYze2PoK?=
 =?us-ascii?Q?kOHf9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc92b1a-4747-4f5e-1c16-08dab1dba889
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 14:10:21.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Sy2X+Qt6nmAfjEp8TkVFk8hY4VJ2+ZG5ibNaRy0Q0qwjYf2f0ctUu2PpZjaezt5Pqkrigw/+mLT4YbsXw99HqDr3GhBmknWuOMXlX8xaRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Add VF setting multi-queue feature.
It is to configure the max queue number for each VF,
user can still modify the queue number in use by
ethtool -l <intf>

The number set of configuring queues for every vf is
{16 8 4 2 1} and total number of configuring queues
is not allowed bigger than vf queues resource.

If quantity of created VF exceeds expectation, it will
check VF number validity based on the queues not used.
The condition is that quantity of the rest queues must
not smaller than redundant VFs' number. If it meets
the condition, it will set one queue per extra VF.

If not configured(default mode), the created VFs will
divide the total vf-queues equally and it rounds down
power of 2.

Signed-off-by: Diana Wang <na.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   6 ++
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  13 +++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   3 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 101 ++++++++++++++++++
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   3 +
 6 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index e66e548919d4..f0e197067e08 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -29,6 +29,7 @@
 #include "nfp_app.h"
 #include "nfp_main.h"
 #include "nfp_net.h"
+#include "nfp_net_sriov.h"
 
 static const char nfp_driver_name[] = "nfp";
 
@@ -252,6 +253,10 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return -EINVAL;
 	}
 
+	err = nfp_vf_queues_config(pf, num_vfs);
+	if (err)
+		return err;
+
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		dev_warn(&pdev->dev, "Failed to enable PCI SR-IOV: %d\n", err);
@@ -847,6 +852,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_fw_unload;
 
+	pf->default_config_vfs_queue = true;
 	pf->num_vfs = pci_num_vf(pdev);
 	if (pf->num_vfs > pf->limit_vfs) {
 		dev_err(&pdev->dev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index afd3edfa2428..c24f990bcdbb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -17,6 +17,12 @@
 #include <linux/workqueue.h>
 #include <net/devlink.h>
 
+ /* Define how many types of max-q-number is supported to
+  * configure, currently we support 16, 8, 4, 2, 1.
+  */
+#define NFP_NET_CFG_QUEUE_TYPE		5
+#define NFP_NET_CFG_MAX_Q(type)		(1 << (NFP_NET_CFG_QUEUE_TYPE - (type) - 1))
+
 struct dentry;
 struct device;
 struct pci_dev;
@@ -63,6 +69,10 @@ struct nfp_dumpspec {
  * @irq_entries:	Array of MSI-X entries for all vNICs
  * @limit_vfs:		Number of VFs supported by firmware (~0 for PCI limit)
  * @num_vfs:		Number of SR-IOV VFs enabled
+ * @max_vf_queues:	number of queues can be allocated to VFs
+ * @config_vfs_queue:	Array to indicate VF number of each max-queue-num type
+ *                      The quantity of distributable queues is {16, 8, 4, 2, 1}
+ * @default_config_vfs_queue:	Is the method of allocating queues to VFS evenly distributed
  * @fw_loaded:		Is the firmware loaded?
  * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
  * @ctrl_vnic:		Pointer to the control vNIC if available
@@ -111,6 +121,9 @@ struct nfp_pf {
 
 	unsigned int limit_vfs;
 	unsigned int num_vfs;
+	unsigned int max_vf_queues;
+	u8 config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE];
+	bool default_config_vfs_queue;
 
 	bool fw_loaded;
 	bool unload_fw_on_remove;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..5deeae87b684 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -78,6 +78,7 @@
 /* Queue/Ring definitions */
 #define NFP_NET_MAX_TX_RINGS	64	/* Max. # of Tx rings per device */
 #define NFP_NET_MAX_RX_RINGS	64	/* Max. # of Rx rings per device */
+#define NFP_NET_CTRL_RINGS	1	/* Max. # of Ctrl rings per device */
 #define NFP_NET_MAX_R_VECS	(NFP_NET_MAX_TX_RINGS > NFP_NET_MAX_RX_RINGS ? \
 				 NFP_NET_MAX_TX_RINGS : NFP_NET_MAX_RX_RINGS)
 #define NFP_NET_MAX_IRQS	(NFP_NET_NON_Q_VECTORS + NFP_NET_MAX_R_VECS)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 3bae92dc899e..3c2e49813655 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -289,6 +289,7 @@ static int nfp_net_pf_init_vnics(struct nfp_pf *pf)
 		if (err)
 			goto err_prev_deinit;
 
+		pf->max_vf_queues -= nn->max_r_vecs;
 		id++;
 	}
 
@@ -754,6 +755,8 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 		}
 	}
 
+	pf->max_vf_queues = NFP_NET_MAX_R_VECS - NFP_NET_CTRL_RINGS;
+
 	err = nfp_net_pf_app_init(pf, qc_bar, stride);
 	if (err)
 		goto err_unmap;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 6eeeb0fda91f..eca6e65089f4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -29,6 +29,9 @@ nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool
 		return -EOPNOTSUPP;
 	}
 
+	if (cap == NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG)
+		return 0;
+
 	if (vf < 0 || vf >= app->pf->num_vfs) {
 		if (warn)
 			nfp_warn(app->pf->cpp, "invalid VF id %d\n", vf);
@@ -309,3 +312,101 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 
 	return 0;
 }
+
+static int nfp_set_vf_queue_config(struct nfp_pf *pf, int num_vfs)
+{
+	unsigned char config_content[sizeof(u32)] = {0};
+	unsigned int i, j, k, cfg_vf_count, offset;
+	struct nfp_net *nn;
+	u32 raw;
+	int err;
+
+	raw = 0; k = 0; cfg_vf_count = 0;
+	offset = NFP_NET_VF_CFG_MB_SZ + pf->limit_vfs * NFP_NET_VF_CFG_SZ;
+
+	for (i = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+		for (j = 0; j < pf->config_vfs_queue[i]; j++) {
+			config_content[k++] = NFP_NET_CFG_MAX_Q(i);
+			cfg_vf_count++;
+			if (k == sizeof(raw) || cfg_vf_count == num_vfs) {
+				raw = config_content[0] |
+				      (config_content[1] << BITS_PER_BYTE) |
+				      (config_content[2] << (2 * BITS_PER_BYTE)) |
+				      (config_content[3] << (3 * BITS_PER_BYTE));
+				writel(raw, pf->vfcfg_tbl2 + offset);
+				offset += sizeof(raw);
+				memset(config_content, 0, sizeof(u32));
+				k = 0;
+			}
+		}
+	}
+
+	writew(NFP_NET_VF_CFG_MB_UPD_QUEUE_CONFIG, pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_UPD);
+
+	nn = list_first_entry(&pf->vnics, struct nfp_net, vnic_list);
+	err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_VF);
+	if (err) {
+		nfp_warn(pf->cpp,
+			 "FW reconfig VF config queue failed: %d\n", err);
+		return -EINVAL;
+	}
+
+	err = readw(pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_RET);
+	if (err) {
+		nfp_warn(pf->cpp,
+			 "FW refused VF config queue update with errno: %d\n", err);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int nfp_vf_queues_config(struct nfp_pf *pf, int num_vfs)
+{
+	unsigned int i, j, cfg_num_queues = 0, cfg_num_vfs;
+
+	if (nfp_net_sriov_check(pf->app, 0, NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG, "max_queue", true))
+		return 0;
+
+	/* In default mode, the created VFs divide all the VF queues equally,
+	 * and round down to power of 2
+	 */
+	if (pf->default_config_vfs_queue) {
+		memset(pf->config_vfs_queue, 0, NFP_NET_CFG_QUEUE_TYPE);
+		j = pf->max_vf_queues / num_vfs;
+		for (i = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+			if (j >= NFP_NET_CFG_MAX_Q(i)) {
+				pf->config_vfs_queue[i] = num_vfs;
+				break;
+			}
+		}
+		return nfp_set_vf_queue_config(pf, num_vfs);
+	}
+
+	for (i = 0, cfg_num_vfs = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+		cfg_num_queues += NFP_NET_CFG_MAX_Q(i) * pf->config_vfs_queue[i];
+		cfg_num_vfs += pf->config_vfs_queue[i];
+	}
+
+	if (cfg_num_queues > pf->max_vf_queues) {
+		dev_warn(&pf->pdev->dev,
+			 "Number of queues from configuration is bigger than total queues number.\n");
+		return -EINVAL;
+	}
+
+	cfg_num_queues = pf->max_vf_queues - cfg_num_queues;
+
+	if (num_vfs > cfg_num_vfs) {
+		cfg_num_vfs = num_vfs - cfg_num_vfs;
+		if (cfg_num_queues < cfg_num_vfs) {
+			dev_warn(&pf->pdev->dev,
+				 "Remaining queues are not enough to be allocated.\n");
+			return -EINVAL;
+		}
+		dev_info(&pf->pdev->dev,
+			 "The extra created VFs are allocated with single queue.\n");
+		pf->config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE - 1] += cfg_num_vfs;
+	}
+
+	return nfp_set_vf_queue_config(pf, num_vfs);
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 2d445fa199dc..36df29fdaf0e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -21,6 +21,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_CAP_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG		  (0x1 << 7)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -30,6 +31,7 @@
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_UPD_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_UPD_QUEUE_CONFIG		  (0x1 << 7)
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -67,5 +69,6 @@ int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
 			      int link_state);
 int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi);
+int nfp_vf_queues_config(struct nfp_pf *pf, int num_vfs);
 
 #endif /* _NFP_NET_SRIOV_H_ */
-- 
2.30.2

