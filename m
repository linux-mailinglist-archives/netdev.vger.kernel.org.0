Return-Path: <netdev+bounces-10981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B08730E5F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A051C20E25
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E75651;
	Thu, 15 Jun 2023 04:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686210E8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:46:06 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5D2273C;
	Wed, 14 Jun 2023 21:45:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdIJxiE2Ux8r9YSheMNYy9315ZS5/Ti41WRsHQXPQOofo7U2eLihp3NxS0XglFz5IQSJZ26MuMrs/5Kx5GxPqV0TnDQ4Pz/D07QsC7zC4Ah3CRjx8rJJRarpHO7jIYIBQV/PSJmKgp6fAIcGU/Tb4X6zuS2vIo2A5bFIPcpMSE2AETT/8x9FwD6fdFdbft+e8u98I3ypnwMY0Cgc97tadj7GJDdNwFZuA1H5p0kpDm3pxDiqAnHOARTluVrAHu7m4B9bliWA65sef0JwyzZ37sFzrjMHZmaKCd5FWv0BGpT2RBdW5hdoC9FtAxU+0/f0NectqeLzXM+5ST1tnPAtag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fk05MFCoxRZll3A/9+GZob5QTR1AZHT/r3Axt7pKpss=;
 b=PUsSDeFJU5mIJ1XIjg4Hi+MjWb5+iu4HGqBRbMFwyfBmFo+z/k5x+X00Ktl0w8vKHXwXOrBV961r2ZnfQL/XcHtDP5lHR8b2x+Ng6NjSFCvRv3RPu8azRZeYFUGn+8GmN0Mkq/KKsUY1s3R36Js+nuvLhGyGr58s2IgjabdLDxsYkjkpvR+WJ8pWKRJDEhbs6UZvV/HLgkWQEpJcjIswAMbjoDstPSkv3wZk/UleMIrjhOgNm8IvhIA+4su2TmbFVbccg9HopIhNyIY3RQKTfDMWYsktVt6lUFxoSe9Yq83pTrpdSm+sTOPxHzD435CbZimX6b9haDIYmdGW4WNuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk05MFCoxRZll3A/9+GZob5QTR1AZHT/r3Axt7pKpss=;
 b=FI53SokUMM9cpctf4KwwVK0rzTook1SE+J80Tp8gf1uQe2D9PjlIOC9kUoxCMeOVTy8haDJD+NiqVelAMZYKqXInCmW+4AXSTeoOq1R1DLlUf+BL4D9p9XEZqt9ctjrFsyyieL0kLPmSBbhk0u348naaOA8t2PTXi5QCX0DX3X4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:45 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:45 +0000
From: Dexuan Cui <decui@microsoft.com>
To: bhelgaas@google.com,
	davem@davemloft.net,
	decui@microsoft.com,
	edumazet@google.com,
	haiyangz@microsoft.com,
	jakeo@microsoft.com,
	kuba@kernel.org,
	kw@linux.com,
	kys@microsoft.com,
	leon@kernel.org,
	linux-pci@vger.kernel.org,
	lpieralisi@kernel.org,
	mikelley@microsoft.com,
	pabeni@redhat.com,
	robh@kernel.org,
	saeedm@nvidia.com,
	wei.liu@kernel.org,
	longli@microsoft.com,
	boqun.feng@gmail.com,
	ssengar@microsoft.com,
	helgaas@kernel.org
Cc: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	josete@microsoft.com,
	simon.horman@corigine.com,
	stable@vger.kernel.org
Subject: [PATCH v4 4/5] Revert "PCI: hv: Fix a timing issue which causes kdump to fail occasionally"
Date: Wed, 14 Jun 2023 21:44:50 -0700
Message-Id: <20230615044451.5580-5-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230615044451.5580-1-decui@microsoft.com>
References: <20230615044451.5580-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CYZPR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:930:8c::25) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH7PR21MB3382:EE_
X-MS-Office365-Filtering-Correlation-Id: 922d3d6e-6079-473f-4c9e-08db6d5b6184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B0dhveHBDO6jtoApQcdMvuEgVSzUfGxk5edtyeQwOgNKJa7ZQAe4Ve8RW1iJUctESvJFFAZ9nvrs8fdod2FoUxDsH61CrNWjjDJqShs4+zfS4lm7DN/Nt3oEXosfA6bVBwOHh7//BoJ/wdvGIgfWyCGAaH/OD6M1HrZbnk/m5OJ38lnJPt4G76hcaPt+FWZWWvvMCeQ4gQMVumvuPwvdp7IFGuMHUXpxOSK8k6rfukuseSumr9rpg8VE7mb16cXzipLgsr836TneIss3kBcD0fixxplcy+9xLHGlsw8mv25ijjrYhD1lLw4eg+Obo/e1/LH316bkj4GDKm/rDP+nj28kvkHLO4NNu1dVj/tMXIPVDgVrcEPcE7xnUTBJEeB976+TSJ21jlANjauauNTOXuA+fDd7r7EL2xzyWie4VcCGxcpbBQlPiP82Y0nliSJzCIxESPkfCMjgBWVUCgBsH0bxnOgHATKPbOKUXBlKcOwj8w90XwtFkk0h+7PvRocJ6X016hXZukvsKPQsNiupxew70DiF5Vqd+mbkOci43i2YNJ0JwtCNtjkc/hVMiDxUHngrbC0sZ/LC7AYG2xrrBs7QAn9zeqo5iDUkv1+2DgWI6Q+sJc9S9dAMyqnnMQ/P8l8A+PRdzxde40xq91Yzig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(186003)(6486002)(6666004)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A3Ffu1AIxQylLe1op6OQhu1vx9aWHAsXlzvgUxWBmTfstXfZmg0LlQgCpslN?=
 =?us-ascii?Q?1Zm04eSy/hnzz1gJFvnZTMMXyMZ5E6cb2nU8Rh1M2yKgQrd42I1b0SqMUAzt?=
 =?us-ascii?Q?ik2g+HezfIaZsnuIXLPCooNPgOsPMvgJJ+g/MQAPwXEh3ixt+nVA7ZFpUqaY?=
 =?us-ascii?Q?oSstuDqUy2YV4l2udkawNAh4pMkXBzgIv98b3NdDoq8dDnEnyggEFeeXV22j?=
 =?us-ascii?Q?VcXB9pDrR2SY0duwpqHJMU0UzJBgR6dlD97O4iSLqM6JrzhSR9ezBpcEo1XL?=
 =?us-ascii?Q?zJ1uR90qhcsFrEOjZxLzTazIadUDcCZbg1oSMxKubGPb7l2XCU6sHUnNz9Ty?=
 =?us-ascii?Q?j48z8vbCBgfb8GvnyFtAPWLlWLdVwRudrUjM5YGDDsR37Q3sarLWu4QU8ZdZ?=
 =?us-ascii?Q?h7EYoXd0vI6bjW3EOWnm1VCB1KwHROIn2u74XcW8zp32XK0jomQXAvCjd94M?=
 =?us-ascii?Q?SXUPBDO1YYUefY5cIeU7JcZyNB7tgXPh7B9dsHA5yBsJVFvsOiOhowWzxrpx?=
 =?us-ascii?Q?ojw25+sDoyygEb6ab3RxOSja8MFfNUNEb95k+ilxAAeLFrDbaNgL3moT8JK3?=
 =?us-ascii?Q?O+kcvsZva3ubWOPcvPHfZzMKFMvcXwtut2XbbQFvIbVVVek7ZMb5tlpvMxqp?=
 =?us-ascii?Q?+oqwH124yvZTkdg896FHWxRqyslQT4N0GN8WFaSsX3hki9u2z03rvgkxVyYC?=
 =?us-ascii?Q?B5nPwCobMxk4bPSfQxL9rGc5CtSjoza7bjrkttxpQGDsun0UJXkLc3HWYv18?=
 =?us-ascii?Q?kY3SlOJPoyx7z15krR4Tfj0I1Kt9Wwbw6dJGnNRsjRlUE+GqdYBRFcygu5n7?=
 =?us-ascii?Q?mJb8mKdT2mpVM2/KuBTxA5NBfCmPgkQ9XMKbxW4CFBYW+TAkNFsW/ltA+/wK?=
 =?us-ascii?Q?hok5ZluIaqTv218ywHUzWp4lDL5Sn9Nf7WuGHeZR59oajXHOcyrkgdzFJ+lq?=
 =?us-ascii?Q?FkjXsTuzu7XPFjB7g2kSvwy5jjNq8BUY6/IoQflBmcgBFpWlnhRN3GKCg84B?=
 =?us-ascii?Q?gcCrs3I35WVhuJ+kxPHPh8624/6W3gesKrUNVYkE71JCww9Zi70/OfDwUHkl?=
 =?us-ascii?Q?rAZL+3QmdfliUTo3byt/uPSyG7kxXYyhJz4ytx7jE5+Z1ls1UFBlMFkJ3wBN?=
 =?us-ascii?Q?EoeDfszSPLcOOUH3XJnHEhsjHMsSTlSG0XjReIbr/WNDeX91LMIHKkKQQHEc?=
 =?us-ascii?Q?m2M5vBS0/lxatBBvfQtLqF/cjZzF6mrPlqrztDhSou9WOv8kaX61EQUibIwq?=
 =?us-ascii?Q?m2zqV66Ko3K3A9aL+jnPZLrj9iqhNaonkfodK6tg7RKK1jvVDG0vCjl0VFob?=
 =?us-ascii?Q?hD4bYL/mu8ZUoq4AUzXywLqxV9m3KIWNodofTyIC3H4oRFchmCc+1rDi6x2d?=
 =?us-ascii?Q?xKpjALa8zCf2j0B089xB4BFdGrr9QuwVk18ldIckoyGUjn/ttuSQg9Z6m4Hd?=
 =?us-ascii?Q?1UFE0wsK9eUqEZCpuYi1GefB8BV9c9io/bEHgYfJKGf/EuJy5cX5a6ZlQU/D?=
 =?us-ascii?Q?Nfzm1sxWdR431R5EakACmawZNiJri7ox6oBvolcBZ5OpqUk5THBuzgjILzID?=
 =?us-ascii?Q?n9LvQ0TbVC5yKWuabR5JUS8NAgCUstI81vk5i35TTEaXj3jhQ0WTKwMmp/7j?=
 =?us-ascii?Q?JCpC1I42cm8vIOV+MjAVtsP4+rkeTYB/3yONX2qDoXtT?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922d3d6e-6079-473f-4c9e-08db6d5b6184
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:45.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOxOoJlYh5fZPvhNCqeiyk+YNPrzr0BCdAvvwUhnxCVOqga6GnIkJV9U+Q8JQeWmxeU7QrKNZ5XnyStmhikWRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.

The statement "the hv_pci_bus_exit() call releases structures of all its
child devices" in commit d6af2ed29c7c is not true: in the path
hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true): the
parameter "keep_devs" is true, so hv_pci_bus_exit() does *not* release the
child "struct hv_pci_dev *hpdev" that is created earlier in
pci_devices_present_work() -> new_pcichild_device().

The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
where the old version of hv_pci_bus_exit() was used; when the commit was
rebased and merged into the upstream, people didn't notice that it's
not really necessary. The commit itself doesn't cause any issue, but it
makes hv_pci_probe() more complicated. Revert it to facilitate some
upcoming changes to hv_pci_probe().

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Wei Hu <weh@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Added Wei Hu's Acked-by.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

v4:
  NO change since v3.

 drivers/pci/controller/pci-hyperv.c | 71 ++++++++++++++---------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index a826b41c949a1..1a5296fad1c48 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3318,8 +3318,10 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	struct pci_bus_d0_entry *d0_entry;
 	struct hv_pci_compl comp_pkt;
 	struct pci_packet *pkt;
+	bool retry = true;
 	int ret;
 
+enter_d0_retry:
 	/*
 	 * Tell the host that the bus is ready to use, and moved into the
 	 * powered-on state.  This includes telling the host which region
@@ -3346,6 +3348,38 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	if (ret)
 		goto exit;
 
+	/*
+	 * In certain case (Kdump) the pci device of interest was
+	 * not cleanly shut down and resource is still held on host
+	 * side, the host could return invalid device status.
+	 * We need to explicitly request host to release the resource
+	 * and try to enter D0 again.
+	 */
+	if (comp_pkt.completion_status < 0 && retry) {
+		retry = false;
+
+		dev_err(&hdev->device, "Retrying D0 Entry\n");
+
+		/*
+		 * Hv_pci_bus_exit() calls hv_send_resource_released()
+		 * to free up resources of its child devices.
+		 * In the kdump kernel we need to set the
+		 * wslot_res_allocated to 255 so it scans all child
+		 * devices to release resources allocated in the
+		 * normal kernel before panic happened.
+		 */
+		hbus->wslot_res_allocated = 255;
+
+		ret = hv_pci_bus_exit(hdev, true);
+
+		if (ret == 0) {
+			kfree(pkt);
+			goto enter_d0_retry;
+		}
+		dev_err(&hdev->device,
+			"Retrying D0 failed with ret %d\n", ret);
+	}
+
 	if (comp_pkt.completion_status < 0) {
 		dev_err(&hdev->device,
 			"PCI Pass-through VSP failed D0 Entry with status %x\n",
@@ -3591,7 +3625,6 @@ static int hv_pci_probe(struct hv_device *hdev,
 	struct hv_pcibus_device *hbus;
 	u16 dom_req, dom;
 	char *name;
-	bool enter_d0_retry = true;
 	int ret;
 
 	bridge = devm_pci_alloc_host_bridge(&hdev->device, 0);
@@ -3708,47 +3741,11 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_fwnode;
 
-retry:
 	ret = hv_pci_query_relations(hdev);
 	if (ret)
 		goto free_irq_domain;
 
 	ret = hv_pci_enter_d0(hdev);
-	/*
-	 * In certain case (Kdump) the pci device of interest was
-	 * not cleanly shut down and resource is still held on host
-	 * side, the host could return invalid device status.
-	 * We need to explicitly request host to release the resource
-	 * and try to enter D0 again.
-	 * Since the hv_pci_bus_exit() call releases structures
-	 * of all its child devices, we need to start the retry from
-	 * hv_pci_query_relations() call, requesting host to send
-	 * the synchronous child device relations message before this
-	 * information is needed in hv_send_resources_allocated()
-	 * call later.
-	 */
-	if (ret == -EPROTO && enter_d0_retry) {
-		enter_d0_retry = false;
-
-		dev_err(&hdev->device, "Retrying D0 Entry\n");
-
-		/*
-		 * Hv_pci_bus_exit() calls hv_send_resources_released()
-		 * to free up resources of its child devices.
-		 * In the kdump kernel we need to set the
-		 * wslot_res_allocated to 255 so it scans all child
-		 * devices to release resources allocated in the
-		 * normal kernel before panic happened.
-		 */
-		hbus->wslot_res_allocated = 255;
-		ret = hv_pci_bus_exit(hdev, true);
-
-		if (ret == 0)
-			goto retry;
-
-		dev_err(&hdev->device,
-			"Retrying D0 failed with ret %d\n", ret);
-	}
 	if (ret)
 		goto free_irq_domain;
 
-- 
2.25.1


