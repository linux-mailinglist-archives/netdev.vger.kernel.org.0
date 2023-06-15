Return-Path: <netdev+bounces-10980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6F6730E57
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63CDD28165A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4119E7F9;
	Thu, 15 Jun 2023 04:45:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354747ED
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:45:56 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44AE2684;
	Wed, 14 Jun 2023 21:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5ekCV6HJ6iJpq17Iu64gq5hMA+iAej3fFDdqXyC5jXwLy0fFAijGSxk27o2tfRtYZMfNSX87N4D1jrEirWPB1ElmJkNOKPtJUPaFgb6SJ7NYD+53dAMFhDMfirF0CkoneAcnM7kaAwuf+9Cv/0mjOCdqpAOvJp3c/Bbpca5ti5dNvtyfKaACYl9T+QDZirYMeR2G3n1N3OglxtUei1KVKRctjfeCi1zcjmrfyBgxaV27hGWLDjmbA1GEKCSxOgh8atiT+Xcv74TVGLHP0Pftzpgv4I3uqaatVMPGEzBG+qsQcFAz2n1XkGN++uhH5ZZFkc46SoVXMFq7v2WBYs/Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJ+hFj+wB2UrTRLkTBYFcRNUhFnHauukaAsov7l2qwU=;
 b=AZpcBatpnTVjYjB4SoSawINz2IqS8+VXBg9dWgZayjRw2UwEBzOowRtgB5c9dAe30ZBxuSXF/bSlJk9T/nz6gEUvaREBYjI9EZTxcNkpy+0ClG+dXzcqi0MPvA1+yi8aWpA84GcUJS2XOiLTtPymjiB2gu5BAF5DujaKJTWKWji0qWhQRyjjU8uj2TTvJEqZhpGsIw+gntNe2OoM4mTSxk3yvXgiWblksE9vw58VE0CIKC5g70D6w6boCWTp04pwfplI5yIBThWmBtVJ5h0N5A8KsCcDSZDRRsNNPYYo3ZIsDJr9NySPkl7GqeAQz7TINTwWxqgA4KmPYcL+clX73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJ+hFj+wB2UrTRLkTBYFcRNUhFnHauukaAsov7l2qwU=;
 b=Q/oRgxGCtWExhTY3uq8NBCHnUrlsVNFrkbEKBUxUD7GYpVE4hWnTm0h6dy922F4lW/m7gHRKdfeXqWzMDxBGHKlaI7AgpKgKMQFV0l85GgiKlGIyexAOonxZClAJXe9m6FPSLvE3eSk5CRSqLVlSgWYzTZHB3vHQPh4TJqvmLzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:42 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:42 +0000
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
Subject: [PATCH v4 3/5] PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
Date: Wed, 14 Jun 2023 21:44:49 -0700
Message-Id: <20230615044451.5580-4-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 34955f6d-e823-4685-a080-08db6d5b600b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m8pyY0EewRj8e3wtyiDfrbJhR770R7vkMOo8IPJ/DFgVoIflx8PWF/z6SqD5BsZhlxbRG/uPY7asTDtLIZdJA4ghDZydEM8Woq2lxTL5lk6mlXvXVeUQlgoZsKKcyjVhyAHPp4uXTvZ7LW65ATDrvuSRMW9bqFGiTlcru626bONd1CjE4MwgtYq4NlmfTVOVrD310iVJUK1eBN1CnCxpQ+XdvDCzBXIo/iIqsD4oPm676ZmDNAiyloSjZTXQEWyZ1l2OSQIIKhAESjZ7438xGehQYviPSjJsXBgA5nf6tgNpZOvZMxo9pnOJ1pDxsTqYu8JHYN13K3Y+upq4dFZJKSbMOcuGs5rmiXd98jherCmvBQsbWhdV4Y/m8qWWMrv8TsV3wVmNC1PCSSjugsk0oL84B/mfwkWKcPMwipfOe30jbiiYOZcOHM0UJX2GkGJJa1Xq7MMXwg5KyS2KDnnJege5RfAANxdW/czk0xd9PdhVax0o1OllQdg2x9UPjrXcdBv9nHJ1emCfnYYlZ+rNjFa0ibDVYqBAm8g8DksTvWsW6K/gl4WOjVtZktaSU9SwI6F2NrXPU1BqLsKc9Q7lnDQVj0G0GiMMetq1xlI4cvPByxqBOo/czgYqawL+t/hzJlaYXiawaN2VOUxdmzgYRw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(186003)(6486002)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kystszMxTz2sp2yzeIfJg9MvDVoNiDQWtiOhLyblR5FTPeDeLiAuD9jLCj/M?=
 =?us-ascii?Q?k3vLlNHvBH1uBeeibtN60L1inZx47f3B5ibdupTtTI5F2VKdsbkqjdWBdDgt?=
 =?us-ascii?Q?mBnhd7pTiPX3GSH5XhshMhoRNVBMhbOPV3gc8/0jnlZQQUwFWP+PCGUvpUh9?=
 =?us-ascii?Q?mK6kxY7XV4xaw+PUO6FMIu5oh5e8FRxSdh7yJZjZsVcKKsRdxArSgradFubq?=
 =?us-ascii?Q?tHQax8jNOxs2e7fRTdjsUfQ7rhprIIsoyuyn/XzBa/LTwUL5zGHjuWn7Mkq5?=
 =?us-ascii?Q?FIAv0lzNPUHz77zQ4z3zXqRMEoNzZYqX3gbSgCawUorfH8Y6knhD5MNWCYgZ?=
 =?us-ascii?Q?K/nyF/uFHrUBnVW5J8FF+mpSypOxrqKsHkpey1x36qDpo03ZWWZjI+Tu3cRk?=
 =?us-ascii?Q?/Sl4ROa3mrYBQoh+rFp+V0qeS86S6fa/Q084ubLkwNy2ASFdqUEf0m7tmxCB?=
 =?us-ascii?Q?pew1AsS9a11BYPFaPffD7dFG3S/SOVTxfwlMh1ItQpmEWWt112EBXzBCA1IX?=
 =?us-ascii?Q?c3uq1Ns6mZiE3bNKagkgr/eagkD1jpWuWzXioqG2FH774F01atONI9AzEBSl?=
 =?us-ascii?Q?YMqGZgM3/el61R2HT5ryG7/7CaKYQ23mmZV/CJLM9InB1mQbNTYkD+c4WzEE?=
 =?us-ascii?Q?TH0xbQbtbDZCu0msTxsd/4zMEKoVf9xyN4kU1aBQxvv4Qp7M9aKYLge6KsZ3?=
 =?us-ascii?Q?DE5L/MZgHZ8v+dmNea8RK+Oohm9IGt7xVOW1mdy667/w+/TU22ybDSHiJBZO?=
 =?us-ascii?Q?JmkaNk9Qww1RLaXnumdgHoUT/EXaHW2k1u1dUGDTA6qFzTuPnMqXQd8QOlmZ?=
 =?us-ascii?Q?8qNVK7ILHJvZaHiq3ly0bW3bzp99mcyf/X+iTxgr00/zY7xJ9+i7/2xXq3l1?=
 =?us-ascii?Q?jLeJruNrctukL0j39lKhhRxxSEvRlQguW8vkKcuXHQgvghOdNvdguhOuGaPm?=
 =?us-ascii?Q?SdGa7SqhvhWGJNTom4btdgncuxbEqh38XTJGIBDX3i3jVBMfK7QgTPKBqu7t?=
 =?us-ascii?Q?mf75mQoPUPth973qmnB4RH6Le9hqIrTg25evdPuVMW8sh9AgIbbsS1i0bPy3?=
 =?us-ascii?Q?mi/FR4bj9+mkC8NLSk6r9LtHtENxzG9w+PxvznV4+z3EdaLErZygVWKNl/91?=
 =?us-ascii?Q?miTcGLub9Y1U2gnwNHyeWQzP03Dcp8lVqhRMZQen1cCkLe3k7WMUB3EzWH6O?=
 =?us-ascii?Q?sxTHFh/myVQ58TwZCqwgnVPFubVHmhdR7c2MNQ+M04qt6RCrdtlMsrBFzXaU?=
 =?us-ascii?Q?81SkFweUN2trgykGXEP4GBV7zCJLmvJWkLqDxe6fQPcO0qtBvqDfAjxfgtdl?=
 =?us-ascii?Q?5NBuPMEMoeYkV6LhszmBruCO87q8OJWr7Ckb0PdqAol9NtIX2qN82Lrgm5gB?=
 =?us-ascii?Q?cKEUoUw/efx7o93MACoXtmqsx05zCRlXd8GyFud1LbvRcnkE05WqDnzErf6c?=
 =?us-ascii?Q?PTzoALtOWzpR0dO2a4DVT9KDyKT3KfrhcTb3dPymK/ANG08s6s0vQ8doiA6Y?=
 =?us-ascii?Q?wwaljCeOvpNsfkr1aZkKJPJY2t3S1VMNYVIOsAj1J6WH+tCq9aOEiCLsNByP?=
 =?us-ascii?Q?L9Jr2caF3rmSF2v2Lq3762fm4pelxVF/WFjJ/iLM21VUMsDWZR0PCFi38azb?=
 =?us-ascii?Q?vmxTGZHwHT3QF3PUy6E/mJV4ezazUa4dX5uBlBGGhR+g?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34955f6d-e823-4685-a080-08db6d5b600b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:42.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTRX6MXnBV/p1FtTD3T83mqkZYxmTo7xdXWVvYOEwESr6tMj8jSdysTl9hX/g99KtkEEczAKSB/G2yCH3JW+5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The hpdev->state is never really useful. The only use in
hv_pci_eject_device() and hv_eject_device_work() is not really necessary.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

v3:
  Added Lorenzo's Acked-by.

 drivers/pci/controller/pci-hyperv.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 733637d967654..a826b41c949a1 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -545,19 +545,10 @@ struct hv_dr_state {
 	struct hv_pcidev_description func[];
 };
 
-enum hv_pcichild_state {
-	hv_pcichild_init = 0,
-	hv_pcichild_requirements,
-	hv_pcichild_resourced,
-	hv_pcichild_ejecting,
-	hv_pcichild_maximum
-};
-
 struct hv_pci_dev {
 	/* List protected by pci_rescan_remove_lock */
 	struct list_head list_entry;
 	refcount_t refs;
-	enum hv_pcichild_state state;
 	struct pci_slot *pci_slot;
 	struct hv_pcidev_description desc;
 	bool reported_missing;
@@ -2843,8 +2834,6 @@ static void hv_eject_device_work(struct work_struct *work)
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
 	hbus = hpdev->hbus;
 
-	WARN_ON(hpdev->state != hv_pcichild_ejecting);
-
 	/*
 	 * Ejection can come before or after the PCI bus has been set up, so
 	 * attempt to find it and tear down the bus state, if it exists.  This
@@ -2901,7 +2890,6 @@ static void hv_pci_eject_device(struct hv_pci_dev *hpdev)
 		return;
 	}
 
-	hpdev->state = hv_pcichild_ejecting;
 	get_pcichild(hpdev);
 	INIT_WORK(&hpdev->wrk, hv_eject_device_work);
 	queue_work(hbus->wq, &hpdev->wrk);
-- 
2.25.1


