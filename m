Return-Path: <netdev+bounces-10982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 440E2730E63
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EECCC280AC0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7E410E8;
	Thu, 15 Jun 2023 04:46:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A0385
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:46:08 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D4B26AA;
	Wed, 14 Jun 2023 21:46:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bnt5tHR+LSy/uRf2edgSTHqzcHAVa0KMcAxgcUSPvasbopx3tfCHQXZc6HEGsf5tVuX/t8zwKeV5Nu1onp9uFcivlL4oByyOGhzVXxtluPg6RB+/eB+YtpwZfWCAhazCs+Uc3AynFLk4K/gCQNfXl+kgb5sYYKAHCAU0kFx4lfgc4qNli0/GfcoeF/ePf7s2P5vq6+n+1NhNoOHYDQNpkYCezzmt4+IWCfwjEmqFqzCwcECypj3JdKhPlM8mqVanxMro7w/MiI6T/aPUl1zjVcqvQ3EuVg7eEOsrW9tz/UPrxxsUgr8Tmn2zJI7L5Lv0Fic+WZwhECHJFHx7Aa2mWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7Zx7niXq8Uxv0dGXqhln9VHcxvy/tzKgtrgeexHazk=;
 b=OCsltjSAGJSpQ4k8MxwU7dxef0x9fPjvaomS5ljWh1vgBoywAHGn+usX3pnsQWtmQqEWHmAkhgDLnqWK3A0BFjDQxoXsjSSUiyxvK6f9eQoJ+C5RZU1kOHguhSLWUENzECborGR0smDIFECqhnAyFsXgyQ9kTAKuSmAfoNYk4ajRNHAr8z7UuClYHBeTMdCFmW4L7gdCSCc747uH+wyATy3krHEcnypDpSLBwjoPzIiWsmfI0T/Ooj/jZ0K0laYCJfiPNnYaXlk1/CFMzDq/Dq1Joh/anHi56c8B3AgZmQWoIv4VNoQfSkf6ArbvjR9y2IcUmkH0AX5aOrxYUAc64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7Zx7niXq8Uxv0dGXqhln9VHcxvy/tzKgtrgeexHazk=;
 b=T3Yhz42R/4k4iem7x5GS15MzNORVVa/asasL+VwbufErtJ06B+ABOyKVFy+yN1ygjJBT42KR17dJPIkeNQiy9JhcWjfuAgQbHqgHnUiSSFdoh25nKdjCdH5/g5vdosFhvDlH8dnmaG1ZkFurVR4QEyreeB8Nb69vLGTLZLY1l50=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:47 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:47 +0000
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
Subject: [PATCH v4 5/5] PCI: hv: Add a per-bus mutex state_lock
Date: Wed, 14 Jun 2023 21:44:51 -0700
Message-Id: <20230615044451.5580-6-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 14c06635-3481-46b3-81cf-08db6d5b6306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c1iIfLsktYnhOlqHlg9+4n8JInyJO99kN1X7kqJHWmJi252YEwgKf2hCokpK4x8oi5Z4lKIwOXiOlBlNOKjyRTHPOyZWWIgnFtep4vOZ8UHuvZTi/ysK2mgXdVejhJ/4cPsxJofSqbIZKgcBdXqX5h7D1CdycyUwZFMb+OyIrPx9ZIQ9NfMNIaSGIbWEfN/hyjUahMdYAAfT7rzkqoNmbJpuEZm5zOKNaDzPvePUzQyb2k1pB5whcyPbrUPvU0F7tskRk1bHVkutnTnQ+rU3HRy6BSY1bvMQy4dDs+IgUxPkkFTXIZolg3FsiHaNLkBb7nMiJOkSg6QfiwGISSw+R03eKQcsKIkCD0e4S/9LqsqWewITizA+eG2I9hJb2u73Xo+PsZJ/xImc+WzpT70MSFWY2vL5blL2UrTugURYxPb7L1ywvTwGfE4itiyMJ4nMIizAK+oISXTg/4gPUnNfcL7laTfINtWWQwvpUfFYgLoMZX9d7MFjKvsijOy//Xy+cpssYNWJF5z7B2NUetang1hv6hZ1MvlvCdYDbW6WUn4ZQBSl/i8c68bL2U83PieYJQtst3jgesmhDj3W0+TN5c01ySWNW/I43qjB5NewOYnT57nlqUN8LW7mOs9zPJAmUpJ4jCgNrFSipMceZnQrVg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(186003)(6486002)(6666004)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I8XSpMiT6ij6rpdCFrxem1WwzspJ+f4suPbapzp7/7LgA9WGOg2/6VJuhHG2?=
 =?us-ascii?Q?6lpS9UvUpabjQ6C8NhAbo5fkEK8927WMu2TYY4UAipLIr2jMFUD5H4acZLWb?=
 =?us-ascii?Q?1J6bYWONfzSNONSrPmogQMIxiI56bRlEWxfLY21hx0uvpnv4vY3VgRDgurYw?=
 =?us-ascii?Q?Vno9V3D44t5Pkzd/gz5uq8ohSX5Me9dhtjqTf3B9MFXw3UtH5D0RuS+XmIH5?=
 =?us-ascii?Q?2FTUsJS4HnfSSRCzMoIpXvZXBf5ixR5+fFtldq405uf9lKF63R7/1Ho+pXv4?=
 =?us-ascii?Q?CF8MREcd9zPRhiurkFIgnNr/94huAXLvxI/E9MMqfoxtAhCub5QqiM4NvnX+?=
 =?us-ascii?Q?kZGWNNXZoOOeayyKihpfWrlvDmla8gnbyEyL3ESgGjOa5f3pvYql0sC5Cr71?=
 =?us-ascii?Q?PbbeHq1SSUTz9eYMKzKv1apNAnkSkTSG0qy5BCT8JOfdsnLhyASwbn2qxpVE?=
 =?us-ascii?Q?ISVZVRvnplLg2tlj8ROur4ybcnA74vuaIkJveKnLAXcxYitG8J2qTljgYyFJ?=
 =?us-ascii?Q?V8gaNnTmsZqEap3y2F44wmWVGGT/iz2e+5mo9oXkfU9n523U/AHRiECi1/s4?=
 =?us-ascii?Q?sqAaexv2Hnni4QwLz0pV9dii6gCukixzGqelk6XB3pM5oN+YZm+y4SdSDDep?=
 =?us-ascii?Q?fr+vjBu691jmLKxmIDqkGIpn8lHgakhwOl+o+LkUZJC33hsvV5hGMQfIMKer?=
 =?us-ascii?Q?/AvIGY4nhPAYAQDfX940R+NyRyEWte8sa0E1US7Yh1plHGgcPAH28itkOtUA?=
 =?us-ascii?Q?U8uK2xmTljUW1+T/NK3lrGh2sThGn0cmehf6kGUR6MjLme41lcFZ3dheiGta?=
 =?us-ascii?Q?AUgP+j3+8yKYrQlkYw7duNiBZdITPkx/aTrw3W97I4kf7G2q95KakfnvCQUr?=
 =?us-ascii?Q?Qme88HAnnvBUL8Xlifxsg0aXudgK/FWIwgdtoMRqj33BcgcfueohAtwDding?=
 =?us-ascii?Q?E7KjKGqVeXQZd+5wmwG1NF0qQsPg1ZvNAAV9i8nxAQZ0lF064jjjTtXdbsK1?=
 =?us-ascii?Q?RfkLw4o4TAtS/SmITr3g0Rvu9ngwnaiAmNGV1pGe1uUFxI6P6UAoZMxbo+7r?=
 =?us-ascii?Q?ojH28oR7aVEQteSZZatION49N1CFaxIL4JbY8q6kPJOn0zyO0O7pfv64b8iQ?=
 =?us-ascii?Q?i/5iSBd9LkC5GspMcHq21vpCUWLzSHunUTVNFT9DACFmC3Ud0mkPqCaQwfhQ?=
 =?us-ascii?Q?hCW0Xq19/xZ1oaYeVp/ta4cRM/0SXg1RKNG5VZxLA4m0RUUX5+Xw0ulh4nq0?=
 =?us-ascii?Q?jAZ/3RrmcRaCg8XQyOrn7uPS6jFg2hWDAZuwCtB9dTWOYURU3Zkk4p3aFjVs?=
 =?us-ascii?Q?mbhAaGwu7liJ2SS9ftbrEKVj4MnAELji8nq1Kw3je51m4o3H/bf/3Fk5bk0J?=
 =?us-ascii?Q?OQ+5SvLi+podStt9/b4asmU1T8lqpFbG8IErA5iyKEZV9A4+3mFNJXXUhOrb?=
 =?us-ascii?Q?dM8XsfKj4k8f64t/dy9q67vOMPHdb7nC+9NfppNLATP5hRNAva7NQ+qd9eYz?=
 =?us-ascii?Q?tgLrjAiFch2u+HyWXh+yhrheSuYoYFVlTz4OL1B2BUf0upgxMEWAJ77dxee0?=
 =?us-ascii?Q?Ce1GoYFeSiwTC16ogX49GZZOuhd72m0VOIUDZIsl7dCY34+5uzKN5bmSSS0X?=
 =?us-ascii?Q?UK7qfAap+a9RwhMJp1v33MG8zt+UWsJ75siyao50K5uL?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c06635-3481-46b3-81cf-08db6d5b6306
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:47.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtYAgWpq+0tExppT1n26qrdJebYRnHDDVG1X9K9t759ELAgfPqKOtXSmw9Fc1hlaNMUJACrH3gj/aEe8Ub1oAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the case of fast device addition/removal, it's possible that
hv_eject_device_work() can start to run before create_root_hv_pci_bus()
starts to run; as a result, the pci_get_domain_bus_and_slot() in
hv_eject_device_work() can return a 'pdev' of NULL, and
hv_eject_device_work() can remove the 'hpdev', and immediately send a
message PCI_EJECTION_COMPLETE to the host, and the host immediately
unassigns the PCI device from the guest; meanwhile,
create_root_hv_pci_bus() and the PCI device driver can be probing the
dead PCI device and reporting timeout errors.

Fix the issue by adding a per-bus mutex 'state_lock' and grabbing the
mutex before powering on the PCI bus in hv_pci_enter_d0(): when
hv_eject_device_work() starts to run, it's able to find the 'pdev' and call
pci_stop_and_remove_bus_device(pdev): if the PCI device driver has
loaded, the PCI device driver's probe() function is already called in
create_root_hv_pci_bus() -> pci_bus_add_devices(), and now
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able
to call the PCI device driver's remove() function and remove the device
reliably; if the PCI device driver hasn't loaded yet, the function call
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able to
remove the PCI device reliably and the PCI device driver's probe()
function won't be called; if the PCI device driver's probe() is already
running (e.g., systemd-udev is loading the PCI device driver), it must
be holding the per-device lock, and after the probe() finishes and releases
the lock, hv_eject_device_work() -> pci_stop_and_remove_bus_device() is
able to proceed to remove the device reliably.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  Fixed the "goto out" in hv_pci_resume() [Michael Kelley]
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

v4:
  Added Lorenzo's Acked-by.

 drivers/pci/controller/pci-hyperv.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 1a5296fad1c48..2d93d0c4f10db 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -489,7 +489,10 @@ struct hv_pcibus_device {
 	struct fwnode_handle *fwnode;
 	/* Protocol version negotiated with the host */
 	enum pci_protocol_version_t protocol_version;
+
+	struct mutex state_lock;
 	enum hv_pcibus_state state;
+
 	struct hv_device *hdev;
 	resource_size_t low_mmio_space;
 	resource_size_t high_mmio_space;
@@ -2605,6 +2608,8 @@ static void pci_devices_present_work(struct work_struct *work)
 	if (!dr)
 		return;
 
+	mutex_lock(&hbus->state_lock);
+
 	/* First, mark all existing children as reported missing. */
 	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_for_each_entry(hpdev, &hbus->children, list_entry) {
@@ -2686,6 +2691,8 @@ static void pci_devices_present_work(struct work_struct *work)
 		break;
 	}
 
+	mutex_unlock(&hbus->state_lock);
+
 	kfree(dr);
 }
 
@@ -2834,6 +2841,8 @@ static void hv_eject_device_work(struct work_struct *work)
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
 	hbus = hpdev->hbus;
 
+	mutex_lock(&hbus->state_lock);
+
 	/*
 	 * Ejection can come before or after the PCI bus has been set up, so
 	 * attempt to find it and tear down the bus state, if it exists.  This
@@ -2870,6 +2879,8 @@ static void hv_eject_device_work(struct work_struct *work)
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
 	/* hpdev has been freed. Do not use it any more. */
+
+	mutex_unlock(&hbus->state_lock);
 }
 
 /**
@@ -3636,6 +3647,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 		return -ENOMEM;
 
 	hbus->bridge = bridge;
+	mutex_init(&hbus->state_lock);
 	hbus->state = hv_pcibus_init;
 	hbus->wslot_res_allocated = -1;
 
@@ -3745,9 +3757,11 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_irq_domain;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto free_irq_domain;
+		goto release_state_lock;
 
 	ret = hv_pci_allocate_bridge_windows(hbus);
 	if (ret)
@@ -3765,12 +3779,15 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_windows;
 
+	mutex_unlock(&hbus->state_lock);
 	return 0;
 
 free_windows:
 	hv_pci_free_bridge_windows(hbus);
 exit_d0:
 	(void) hv_pci_bus_exit(hdev, true);
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 free_irq_domain:
 	irq_domain_remove(hbus->irq_domain);
 free_fwnode:
@@ -4020,20 +4037,26 @@ static int hv_pci_resume(struct hv_device *hdev)
 	if (ret)
 		goto out;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	ret = hv_send_resources_allocated(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	prepopulate_bars(hbus);
 
 	hv_pci_restore_msi_state(hbus);
 
 	hbus->state = hv_pcibus_installed;
+	mutex_unlock(&hbus->state_lock);
 	return 0;
+
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 out:
 	vmbus_close(hdev->channel);
 	return ret;
-- 
2.25.1


