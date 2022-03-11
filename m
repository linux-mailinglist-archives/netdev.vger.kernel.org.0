Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF314D5FF3
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiCKKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiCKKof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:35 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EE114F282
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXkNkD2tQEyr8ZvE7V/Dcei/WyhTomhx8pioq0I1BXgn9Zm1xHPuhy2Zo8NrrIjDmuKQI64yxWaz0kjQpdiVbf9BZFsHjPO9b+OfGf2yTkcOzP8V6hJ1L7Xt12ZnEoQAvSLYVXipoXua7RpN+eEa2G0K38tTBUcTs1PZXgASLJ1FSb3Vi4lGOOLkKYu4vBhbxBr6pwOlP6nbjTCkO4VD7FjLPvzuox8dJ0/tJDUpWvAdISoD+JNJI700EM/xXb6aQFmwSDNDpASgh7BpiChvwHBvKg6A2yWsWi0NMCIVxlZa/zRj6vZya9NqNgUrzUpfsjjaYX1u06uXq766XLt1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSQxqUppioeK84yAekuRkD8QZMX7pL0aixLVXcMPviU=;
 b=A5nyIA7qbmloP6YQscMQqQR/FTGEe/1kAonZlfteoqGnzwGkIvY8nOF8bVzGUoLQwP5podt3G5axqwZIDj+0RfyIuEaL/S1CwayTRhGc6KuDW+JmupkkiEF8JA766vNqTEb1NwBmxAyESE6cEVfSn5rL3XW/PO1GsVA+cRYJD5R90y+7GBsUKwRq150pbn8nwoC48MCtly8k5c+YxVFGpDBIrc7vmY/mtW1tj4g2ACho1yLT533/nf/7lDa/j7Ue1WXA8kQiZbDHKI+yW0CD/p8SURTIS7rHQEb2JbjlviVyelJ63KkXh9s2or8nBCkhi4d3fa3mcL5GbctEBDx5zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSQxqUppioeK84yAekuRkD8QZMX7pL0aixLVXcMPviU=;
 b=SvnAWERRSJXiXbzrpO7j+P7d4XbdXlRu5y1vMy/ePbMrSXEwZC0an2+yc1ZXZggaysMxy2pKUsGTxE373+W/qPv6/r9oweKdLDLm43jpksl/tIrQ2bhwc9IAV4guLRQORsRfR0AtkfoMh8sg3ZU2EjQDH1DI/DNB6lyVqmMKUds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:29 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 06/11] nfp: introduce dev_info static chip data
Date:   Fri, 11 Mar 2022 11:43:01 +0100
Message-Id: <20220311104306.28357-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb1d16f7-f196-4b71-3c6d-08da034bfaf6
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB4748BA0F43F78B9913B6E7B2E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXUA74TXeSGfH98TA5FaDpszlXcYU4zwC1GYFIRVmaKUNwq8Hd9eLbs0KwDk3rwgABDMw1bYbt6Mpo+T+DJS+c78EIsYipy6hanZddJ6I3plVDJWtvX4S+SZPqaEgFczsyXGpLUWYsclvqVHCa26AnVENI4iv6SlkWWiwzQXxOIMrYpIcc2hgScEfSYSLYf7f6PDvC0HpGzh+V1NEeE+p7dzfKhPz6HtGdDIG0jTSNkmofZvHxIVFjuw74ERGGtXWTjMJDEffnemqIxLjX9q562VD1fc32q9YhmmZkR6rAdw05uztyJ9SuaZGeqRO1oEdFo3vHhxmPrI3y7bo64wXf78F05AyCCqL4+QYLZgiO6JFr1rvWoROLi+CFUkvIJbXRRBxf0qtOblTH8vZvag07atwBAGx7a+IDDU8hozUO2o64z1AjS3km641Q+c1jJcPp/krr6QylpvJ+bZ8hSyBdh/0gj6PA+kq63zNRpswCxfbgUJHThBQ+W1lYw51k94ZPVX3o6/dqAEd7p3xD6RJf0aXjDhqY66kUzgrceWnruU0WtR0GpB/lc1FHH9Xw8BYJ7XoP8u8esHSvfC2iq9+FZQuZPRSZUSQjZp3Y9hQbdktY4kog5U7BOrzXqXaBKqZtKgBH4OK5oiP+h5UZQJBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(30864003)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3vec1LN8bAepCu1A553M9/QQz037J/mkYoq+/I7tFKH6Euff9nCsHZG2nDIV?=
 =?us-ascii?Q?mLFeJ98SJJ+QmTBwGw0zI52oHdH6OhedTC9/vGqsM1BhoMlGEWP4QcMesxKX?=
 =?us-ascii?Q?YsTx29gNxhidKuGsj9UHsZixLN9GWzKH/dMUf/OeHYIG3hSp9dZCEZw09mkn?=
 =?us-ascii?Q?LJf/ZgULohmscfTbTZzXO/vnXFijAU5nxX5r/3QqXBo6rlW4Kj7jkrqoUmML?=
 =?us-ascii?Q?eHcoVykO7fFZZTvIgohZ6d8Qj/+sU/fUAj0T+nSC1+8vTcdd3IkTUW5UmXEs?=
 =?us-ascii?Q?TokIOUmj0GFmAUJHGpwy0to1rhnplUy6PsOKz/UdO94RMkCB+wy7i9ztyNw5?=
 =?us-ascii?Q?Odkf6YyYfbekYsqXE15ZAze3O0fBToq9AWHKSVMNboV+hlVf7jaNjZJykIba?=
 =?us-ascii?Q?8opgB6f3zTuZ/WOy1kD8fwDfxDreoQB2EIGFJB62qJ41kaR1N1a5Pkgtrv2S?=
 =?us-ascii?Q?pHLQLun/2myBz/ThN2sgdn8xjDiCU1YiiCS0CdIQmzta8yn4i+VF/NgX8p1L?=
 =?us-ascii?Q?p9vuBarGF5I0hI+9d34KFshdy+IWJ/dzKcmgIpwT/crQ2fLlSeJyQT69TYHM?=
 =?us-ascii?Q?emhKuw+a34Wftan1v3wxUbdodSwocYWQFxVMwNg0rAZF3oei7WGtl/i/teSO?=
 =?us-ascii?Q?ztZabjMIoYIfNEHv846QfH3uH7oyKYF1vKW1d8WOffVl7r/xft5CWoPcNQTy?=
 =?us-ascii?Q?JHVSbk3unpJDRs9hIYkWYP3e1kbE02/mk2JAnc2reF1Tj1yIn00DhfRn8mCr?=
 =?us-ascii?Q?OimOAbZP2Z7LF9vSJIa9U4tA/g/LbqCW7faniWkIAJnVGke9yE/20/IMLQqz?=
 =?us-ascii?Q?2HQRXVEjr+FuJ0nAEZHT1fTNvegwJsIME+ADipssS1VdzGkEDCzVDRTK9pEV?=
 =?us-ascii?Q?0eQEfIu6RDvzylPmscXiNwabx4xGS5702FymjHjrQIIVZCjyNNjp4sxoEn4t?=
 =?us-ascii?Q?85CnrKLj7M+sBoQXqSC92HXDKPAlud5SME1NFO5HAIMyWit86/rD8Y5UB1uw?=
 =?us-ascii?Q?mKXv0SMzBe6Nou12pVuNGwXYltW6TpGSfl/wmpn9UgzE90o+wwFi51SLRF7A?=
 =?us-ascii?Q?wGupp0/Gmg/oYUKAUOr5X0IF7kz3yhMdMJ9AOHfDm3/rw24sgwlODq7GQQix?=
 =?us-ascii?Q?D1b1EuyPHv+ZSCTdjFLFJXiujLkq1gkcEIxTED94hcHB6LXb9rIQiowrg4HX?=
 =?us-ascii?Q?T0O9CJTQinEoI0xwDHrz6tAA67R2XD/Gl++N2tMlVHnZTVtlUilXKGlK8CGz?=
 =?us-ascii?Q?GECVtdCmu7nP8dGKrXTzWUPte59o/07NOTg26uCL+t7qDgzcXw7Hu//nr410?=
 =?us-ascii?Q?PEgCTJdTF6Ofr1q3TQoAKvW7CslKr7TJq+NskuLWwbcT8Gn+z3JQ4D7mFgE8?=
 =?us-ascii?Q?czcT/13aCsB0P4yAXfEKxl6eNTLH4YJjH03YZG5ywtRCMoi6tGXVT4KleRIu?=
 =?us-ascii?Q?OBUh1gvE11DIorAEJGLeE5cVLDIv7rvHuqq0nUXfn9GNsSXpw3wlZpxSVpt3?=
 =?us-ascii?Q?2QHHsbCWb/wyvpdozLop9WDs7LGuoqteWeHqIYY+P5OhZGCEP7qJCRcUMQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1d16f7-f196-4b71-3c6d-08da034bfaf6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:29.7030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJQx79T3gwplp+lvAz3qsD5vhP/YIjvxLwXvtiErNHHVPbDai5+RbJwrgUapZbQMY0kKtNQEtx+98e0mCdXU6iUGQsqZWNntgjibHfB2g1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

In preparation for supporting new chip add a driver data structure
which will hold per-chip-version information such as register
offsets.

Plumb it through to the relevant functions (nfpcore and nfp_net).
For now only a very simple member holding chip names is added,
following commits will add more.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile    |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_main.c  | 13 +++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_main.h  |  2 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h   |  6 +++++-
 .../ethernet/netronome/nfp/nfp_net_common.c    |  5 ++++-
 .../net/ethernet/netronome/nfp/nfp_net_main.c  |  3 ++-
 .../ethernet/netronome/nfp/nfp_netvf_main.c    |  9 +++++++--
 .../netronome/nfp/nfpcore/nfp6000_pcie.c       | 11 ++++++++---
 .../netronome/nfp/nfpcore/nfp6000_pcie.h       |  3 ++-
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c   | 10 ++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h   | 18 ++++++++++++++++++
 11 files changed, 68 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 9c72b43c1581..a35a382441d7 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -5,6 +5,7 @@ nfp-objs := \
 	    nfpcore/nfp6000_pcie.o \
 	    nfpcore/nfp_cppcore.o \
 	    nfpcore/nfp_cpplib.o \
+	    nfpcore/nfp_dev.o \
 	    nfpcore/nfp_hwinfo.o \
 	    nfpcore/nfp_mip.o \
 	    nfpcore/nfp_mutex.o \
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 8f2458cd7e0a..aca49552f2f5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -19,6 +19,7 @@
 
 #include "nfpcore/nfp.h"
 #include "nfpcore/nfp_cpp.h"
+#include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nffw.h"
 #include "nfpcore/nfp_nsp.h"
 
@@ -34,15 +35,15 @@ static const char nfp_driver_name[] = "nfp";
 static const struct pci_device_id nfp_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP5000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
 	{ 0, } /* Required last entry. */
 };
@@ -667,6 +668,7 @@ static int nfp_pf_find_rtsyms(struct nfp_pf *pf)
 static int nfp_pci_probe(struct pci_dev *pdev,
 			 const struct pci_device_id *pci_id)
 {
+	const struct nfp_dev_info *dev_info;
 	struct devlink *devlink;
 	struct nfp_pf *pf;
 	int err;
@@ -675,6 +677,8 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	    pdev->device == PCI_DEVICE_ID_NETRONOME_NFP6000_VF)
 		dev_warn(&pdev->dev, "Binding NFP VF device to the NFP PF driver, the VF driver is called 'nfp_netvf'\n");
 
+	dev_info = &nfp_dev_info[pci_id->driver_data];
+
 	err = pci_enable_device(pdev);
 	if (err < 0)
 		return err;
@@ -703,6 +707,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	mutex_init(&pf->lock);
 	pci_set_drvdata(pdev, pf);
 	pf->pdev = pdev;
+	pf->dev_info = dev_info;
 
 	pf->wq = alloc_workqueue("nfp-%s", 0, 2, pci_name(pdev));
 	if (!pf->wq) {
@@ -710,7 +715,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 		goto err_pci_priv_unset;
 	}
 
-	pf->cpp = nfp_cpp_from_nfp6000_pcie(pdev);
+	pf->cpp = nfp_cpp_from_nfp6000_pcie(pdev, dev_info);
 	if (IS_ERR(pf->cpp)) {
 		err = PTR_ERR(pf->cpp);
 		goto err_disable_msix;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index a7dede946a33..9c72a0ad18ea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -48,6 +48,7 @@ struct nfp_dumpspec {
 /**
  * struct nfp_pf - NFP PF-specific device structure
  * @pdev:		Backpointer to PCI device
+ * @dev_info:		NFP ASIC params
  * @cpp:		Pointer to the CPP handle
  * @app:		Pointer to the APP handle
  * @data_vnic_bar:	Pointer to the CPP area for the data vNICs' BARs
@@ -88,6 +89,7 @@ struct nfp_dumpspec {
  */
 struct nfp_pf {
 	struct pci_dev *pdev;
+	const struct nfp_dev_info *dev_info;
 
 	struct nfp_cpp *cpp;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index f6b718901831..9fc931084bbf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -105,6 +105,7 @@
 
 /* Forward declarations */
 struct nfp_cpp;
+struct nfp_dev_info;
 struct nfp_eth_table_port;
 struct nfp_net;
 struct nfp_net_r_vector;
@@ -571,6 +572,7 @@ struct nfp_net_dp {
 /**
  * struct nfp_net - NFP network device structure
  * @dp:			Datapath structure
+ * @dev_info:		NFP ASIC params
  * @id:			vNIC id within the PF (0 for VFs)
  * @fw_ver:		Firmware version
  * @cap:                Capabilities advertised by the Firmware
@@ -644,6 +646,7 @@ struct nfp_net_dp {
 struct nfp_net {
 	struct nfp_net_dp dp;
 
+	const struct nfp_dev_info *dev_info;
 	struct nfp_net_fw_version fw_ver;
 
 	u32 id;
@@ -942,7 +945,8 @@ void nfp_net_get_fw_version(struct nfp_net_fw_version *fw_ver,
 			    void __iomem *ctrl_bar);
 
 struct nfp_net *
-nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
+nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
+	      void __iomem *ctrl_bar, bool needs_netdev,
 	      unsigned int max_tx_rings, unsigned int max_rx_rings);
 void nfp_net_free(struct nfp_net *nn);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 67a87fdf7564..5d993772c1d9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3962,6 +3962,7 @@ void nfp_net_info(struct nfp_net *nn)
 /**
  * nfp_net_alloc() - Allocate netdev and related structure
  * @pdev:         PCI device
+ * @dev_info:     NFP ASIC params
  * @ctrl_bar:     PCI IOMEM with vNIC config memory
  * @needs_netdev: Whether to allocate a netdev for this vNIC
  * @max_tx_rings: Maximum number of TX rings supported by device
@@ -3974,7 +3975,8 @@ void nfp_net_info(struct nfp_net *nn)
  * Return: NFP Net device structure, or ERR_PTR on error.
  */
 struct nfp_net *
-nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
+nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
+	      void __iomem *ctrl_bar, bool needs_netdev,
 	      unsigned int max_tx_rings, unsigned int max_rx_rings)
 {
 	struct nfp_net *nn;
@@ -3999,6 +4001,7 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 
 	nn->dp.dev = &pdev->dev;
 	nn->dp.ctrl_bar = ctrl_bar;
+	nn->dev_info = dev_info;
 	nn->pdev = pdev;
 
 	nn->max_tx_rings = max_tx_rings;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 751f76cd4f79..8934d5418b1a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -22,6 +22,7 @@
 
 #include "nfpcore/nfp.h"
 #include "nfpcore/nfp_cpp.h"
+#include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nffw.h"
 #include "nfpcore/nfp_nsp.h"
 #include "nfpcore/nfp6000_pcie.h"
@@ -116,7 +117,7 @@ nfp_net_pf_alloc_vnic(struct nfp_pf *pf, bool needs_netdev,
 	n_rx_rings = readl(ctrl_bar + NFP_NET_CFG_MAX_RXRINGS);
 
 	/* Allocate and initialise the vNIC */
-	nn = nfp_net_alloc(pf->pdev, ctrl_bar, needs_netdev,
+	nn = nfp_net_alloc(pf->pdev, pf->dev_info, ctrl_bar, needs_netdev,
 			   n_tx_rings, n_rx_rings);
 	if (IS_ERR(nn))
 		return nn;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index 694152016b25..a9e05ef7d644 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/etherdevice.h>
 
+#include "nfpcore/nfp_dev.h"
 #include "nfp_net_ctrl.h"
 #include "nfp_net.h"
 #include "nfp_main.h"
@@ -39,7 +40,7 @@ static const char nfp_net_driver_name[] = "nfp_netvf";
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
 	},
 	{ 0, } /* Required last entry. */
 };
@@ -64,6 +65,7 @@ static void nfp_netvf_get_mac_addr(struct nfp_net *nn)
 static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *pci_id)
 {
+	const struct nfp_dev_info *dev_info;
 	struct nfp_net_fw_version fw_ver;
 	int max_tx_rings, max_rx_rings;
 	u32 tx_bar_off, rx_bar_off;
@@ -77,6 +79,8 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	int stride;
 	int err;
 
+	dev_info = &nfp_dev_info[pci_id->driver_data];
+
 	vf = kzalloc(sizeof(*vf), GFP_KERNEL);
 	if (!vf)
 		return -ENOMEM;
@@ -171,7 +175,8 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	rx_bar_off = NFP_PCIE_QUEUE(startq);
 
 	/* Allocate and initialise the netdev */
-	nn = nfp_net_alloc(pdev, ctrl_bar, true, max_tx_rings, max_rx_rings);
+	nn = nfp_net_alloc(pdev, dev_info, ctrl_bar, true,
+			   max_tx_rings, max_rx_rings);
 	if (IS_ERR(nn)) {
 		err = PTR_ERR(nn);
 		goto err_ctrl_unmap;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index 252fe06f58aa..aa8122f751ae 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 
 #include "nfp_cpp.h"
+#include "nfp_dev.h"
 
 #include "nfp6000/nfp6000.h"
 
@@ -145,6 +146,7 @@ struct nfp_bar {
 struct nfp6000_pcie {
 	struct pci_dev *pdev;
 	struct device *dev;
+	const struct nfp_dev_info *dev_info;
 
 	/* PCI BAR management */
 	spinlock_t bar_lock;		/* Protect the PCI2CPP BAR cache */
@@ -1306,18 +1308,20 @@ static const struct nfp_cpp_operations nfp6000_pcie_ops = {
 /**
  * nfp_cpp_from_nfp6000_pcie() - Build a NFP CPP bus from a NFP6000 PCI device
  * @pdev:	NFP6000 PCI device
+ * @dev_info:	NFP ASIC params
  *
  * Return: NFP CPP handle
  */
-struct nfp_cpp *nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev)
+struct nfp_cpp *
+nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev, const struct nfp_dev_info *dev_info)
 {
 	struct nfp6000_pcie *nfp;
 	u16 interface;
 	int err;
 
 	/*  Finished with card initialization. */
-	dev_info(&pdev->dev,
-		 "Netronome Flow Processor NFP4000/NFP5000/NFP6000 PCIe Card Probe\n");
+	dev_info(&pdev->dev, "Netronome Flow Processor %s PCIe Card Probe\n",
+		 dev_info->chip_names);
 	pcie_print_link_status(pdev);
 
 	nfp = kzalloc(sizeof(*nfp), GFP_KERNEL);
@@ -1328,6 +1332,7 @@ struct nfp_cpp *nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev)
 
 	nfp->dev = &pdev->dev;
 	nfp->pdev = pdev;
+	nfp->dev_info = dev_info;
 	init_waitqueue_head(&nfp->bar_waiters);
 	spin_lock_init(&nfp->bar_lock);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.h
index 6d1bffa6eac6..097660b673db 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.h
@@ -11,6 +11,7 @@
 
 #include "nfp_cpp.h"
 
-struct nfp_cpp *nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev);
+struct nfp_cpp *
+nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev, const struct nfp_dev_info *dev_info);
 
 #endif /* NFP6000_PCIE_H */
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
new file mode 100644
index 000000000000..6069d1818725
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include "nfp_dev.h"
+
+const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
+	[NFP_DEV_NFP6000] = {
+		.chip_names		= "NFP4000/NFP5000/NFP6000",
+	},
+};
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
new file mode 100644
index 000000000000..514aa081022f
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef _NFP_DEV_H_
+#define _NFP_DEV_H_
+
+enum nfp_dev_id {
+	NFP_DEV_NFP6000,
+	NFP_DEV_CNT,
+};
+
+struct nfp_dev_info {
+	const char *chip_names;
+};
+
+extern const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT];
+
+#endif
-- 
2.30.2

