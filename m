Return-Path: <netdev+bounces-10978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FFB730E46
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A258D281689
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5D4395;
	Thu, 15 Jun 2023 04:45:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADEA7FB
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:45:46 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92965270F;
	Wed, 14 Jun 2023 21:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3z2PZQ31jcgL3I2bi77OA7ph/g0bivyWsupDTZi1kDaQmATPYby5KUgqpsI/uqKNEbprjyQampYrYnx0eOWeYTEe/qSIu0CVDQdNSmdIAFD5A209C5dv+lfQmYDChJ9uwai1hMzB6V94j/+zICbEUdCOW6GVsbMlxAobHHOjw1x238jsY44hqpbJ8oo3K1enjAeL3utDWPoTwgthhPG9Ji6CggzQoVESqjdJ0ZVsQShoGtlZsqNrOJ6pa7JevH+JIis+8TUOZHk1XJU5P/EjMRx9hNI4fHpcdbD0fwV6e+AD75orc7J3BKg3GRGLQKD6PsZKyJmfe2aFKzDWaiRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tj4M9fxqQNfCE5aujo7cGgHBSIYwBpKxgqAgVGTGBp8=;
 b=dvrZYMRnQpsS8KFhfW7jdcrbt3s6e592G88I+NNEq85Gt+VFiC4DY+1NUGj3x5LsKWdpLKcQage+LJBXN9Me1qRykRJuFzB85MuZ7iVfU3o/3aBXPjtrf+mqW1wCqDlBQCcusMfZiWIgjR8989Nwu4NmpbV5tB/piREL5H6hHLewv6hm8eIfb6Q7m9p6mst7E9p/A5VAM5CPaMOVsVKqRJ8Yy2qOK6B1KdKjIL7GoVM30NODP1ce8GoXwFQtcetDGm8cnXy1e6x631a0RATwYk6jWk01/cl+dwPo3EzM9yWANRI3ppgtLGqBFEiKvpgsBisD2M57W4mLWZiRU0TEgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tj4M9fxqQNfCE5aujo7cGgHBSIYwBpKxgqAgVGTGBp8=;
 b=ARLPWPZG4jupCbf53+rsVucLhEKk4b3LgU46PtVPLAVZ+sxnNC1x6i2KFxwKhUacNqEF/EW2p/0iduSv8RNY/5yrnFm9PJye6SAgTN+XhL+7v6hW7hVKB1piKRYafc87M+l1akSGv5CchntSS9JSGNNuPogIBi1Gz8DkuPAQUiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:37 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:37 +0000
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
Subject: [PATCH v4 1/5] PCI: hv: Fix a race condition bug in hv_pci_query_relations()
Date: Wed, 14 Jun 2023 21:44:47 -0700
Message-Id: <20230615044451.5580-2-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e72a2ae8-3426-4843-736f-08db6d5b5ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3orImqG6Du5OYL0gbiciO6rGKclc1ELywVwcbxGUl5tHGbpNd6wOcrw6ammIqGW8vQBH42S59MGzx9r4r/mg91Er5zlWe4BislcMApT2dszW5TJ8Pw8E+mipOXZMsngbH9DCUBeLQye0MAOe0JFQtdyBWdJzAZt0nYrBMheNHnKdFSu2ChRcJ2DqOjsGp+sJtiwg+iOYRDv9ho4AzsT8GJAeh2k1T0/ZKD78ETAbjDTP25a/ZjyUJPqtMI34CXddb6jyeQWpJLxSdtYhq2n+Xp3fM05EkrPt1Ju+WMyv17OSZ21qk5FrdxkjwznD8UdGrbyPYgjghiSwKboM6I4m9OgjnAU5u+9At1/ulLHMTzflerxF6FAeK8zW2CCD8oLJrJPxcvLZ0Ab/kyufLiqMAx+NlutYtoYWV9tnO3Obhrk3kKGuvHfdDEZX2CAjJZkVMAu7oGVWwYFy2a8SKqfr/RBrMsLNyejUSqmd01+fDqEP5xqLopN3l3y4nArrB1Lj6+wDrbz34MAc75IA1fehoc9O2WY/8hFX4UeUsErTPPhpJu8JQ+nn3ig+HeXWrfe8LSaIt/P0L7M82zRofkdofxDi+T34x2CV2GjsGew2pUtvXHSIzptz0CsWsyBdPbCJP/RIn6axRU4ogVOdwpAuTQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(186003)(6486002)(6666004)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AmkbKPRSjqVrMtvDz4ak1hzj3VOnz6ypBzZG9TXzI3ySUqdqDnmlF4gBdWT2?=
 =?us-ascii?Q?uf51w3a2JG9RZNkyuoVzjBwt4z9irqF42UGnAb0A31W8jzQ7HtgH4sCrj744?=
 =?us-ascii?Q?RI+BCftmUJ3N7QSq1JAFof/VOZWuWGNAP0wYLkS1C3f6OIaAAnvv9u+f4rv9?=
 =?us-ascii?Q?x070YwIMlEVJoMPUfrDGaXHOXaVK0lusvNPvLnv+S+A8d0UHWZQ8AWR+2WVx?=
 =?us-ascii?Q?YQq3qAyswA29MJlh3z6l29IaVX6QHST6lkrQrlcmD9arFVvpQzOss3yZcXyP?=
 =?us-ascii?Q?FrXeo4ZMpN732694MDEgGbuKIBsQr2H09Sl2fJ3YLdG/rJVppYgaCp5pMg6n?=
 =?us-ascii?Q?tYvmcwJRDAoCuSkdDF8rIUfepM3XozdUUzsUYiIT+yQMV6ByhoQiYrzx5MvQ?=
 =?us-ascii?Q?AGbXgGEnb+Tdk0Q2+abXJPsAZiq2fEsOEkS3xIA7CaHCeP8yil+wP+DgqsOf?=
 =?us-ascii?Q?o0oLnJ2qkW3gmIXGniy5MJYtGGkL7bh9cv4xqX0+adCja7ifvdBnWtsOX19G?=
 =?us-ascii?Q?jcu5ha3CR+e83LtcpA4lpFmcFxMHjxzpZqXjvMWtdw6ijPVlVsZ0e/ThiKY0?=
 =?us-ascii?Q?fufDkwVyLB7DrCFFarHC1w7Z38N23mQPVof///Jpa59PMvK/Jd2P1Q8MFwPb?=
 =?us-ascii?Q?o52t5PAeYATmmd/NsecYTnG85E+JQDLsI7SyfpKgRiZhcmyUw8ZtB4KNcsAW?=
 =?us-ascii?Q?GeeCNGM23Dq2qMi25qE37NU5Mlkq8pTupITwbPCOq8enL4lYX9skZbjgeLR9?=
 =?us-ascii?Q?OIZkT4GTIPVtLmuilgV/ycf3vDRN3bw4Qv8D9q/saht+KVi1gaFM2Wd4JHCZ?=
 =?us-ascii?Q?i5lxDG80hsUsCDwDGcqMExS4Yza8QaC0zefZLVfUCPhbzuO2KeM7gFsvnYO0?=
 =?us-ascii?Q?f13d74LFwtRQejff4NqvmmEC9bi/bjO0Lqgqy7S1SiSIdiiHGF1NFOVesTej?=
 =?us-ascii?Q?2hD0vS+BqDxRgB8afPvD5rp88ROwHYsvyqanSAo7l7ZXFIyJPHcM1SRyk2JY?=
 =?us-ascii?Q?EvxbNVh3ZOwFNO3m8INxE7hHH6PeTWavdxNAWjQBrDL3omGP1r08A9RuNLOV?=
 =?us-ascii?Q?sS5MmV+tvSZ9/fUQJt0IkDocFN0IT9TXSFzF3TtOZE+S8Zy+j5CR8bz/3Hvo?=
 =?us-ascii?Q?6i4K3OH/V3K2dYtjGS24QPUuW9A7S87GFD+Mf+MirXbveMSBrkneI+w2vj07?=
 =?us-ascii?Q?+WN83c8VCZzRF90HLwlfylUl/RW/y1Obrs7TDWXgUOZZjtNey50w2DmSFw0f?=
 =?us-ascii?Q?Ws4cpgiKaCQ1i72GC4nb9MbId1ncU2LtU5ikAhqPScAOK1AwyZDSGOuvLDNq?=
 =?us-ascii?Q?lk3Gb4mZZuxYliOwgQxJddanwdBaNrlsJ4BGqMIgTRmGrCZ54VW3nGNHzH/P?=
 =?us-ascii?Q?tES7KuX/Vn/UwFf+x53VuOsmwiAvxkZPzUO/zjqgEDsclVkBIYniSyGNSTJz?=
 =?us-ascii?Q?miVsoujOj+MSVzC5+8WMd7tJg+1aGwOyK4+lZ8MsrbaaSUgx1HphOrV4WWci?=
 =?us-ascii?Q?IYjJpDm+Gt9JKP6gC9Y7pWioSBL3jMQMm3wS72v1gQvh/yDYYKCyU/q+2rgQ?=
 =?us-ascii?Q?scNASzR+f7i95OGDTZHefeWls+gBhP4ct7sJ5EBZEgAE0e+sOtpSfzLIU21K?=
 =?us-ascii?Q?JHwqHMYGWAtejvyZF9jhUi933xA56Mo+O7N1N/u0kRfc?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72a2ae8-3426-4843-736f-08db6d5b5ce3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:37.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOGJFQ4zpHJbJ3OYryksj9sF+gL+kgwa4TZIVMBXBk0jso0/TqIfwsORxyUfGspvdEWeurtYLpmX9NrP+ULN4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since day 1 of the driver, there has been a race between
hv_pci_query_relations() and survey_child_resources(): during fast
device hotplug, hv_pci_query_relations() may error out due to
device-remove and the stack variable 'comp' is no longer valid;
however, pci_devices_present_work() -> survey_child_resources() ->
complete() may be running on another CPU and accessing the no-longer-valid
'comp'. Fix the race by flushing the workqueue before we exit from
hv_pci_query_relations().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

v4:
  Provided more details of the issue in the comment and commit log.
  Added Lorenzo's Acked-by.

 drivers/pci/controller/pci-hyperv.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index bc32662c6bb7f..ea8862e656b68 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3401,6 +3401,24 @@ static int hv_pci_query_relations(struct hv_device *hdev)
 	if (!ret)
 		ret = wait_for_response(hdev, &comp);
 
+	/*
+	 * In the case of fast device addition/removal, it's possible that
+	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
+	 * already got a PCI_BUS_RELATIONS* message from the host and the
+	 * channel callback already scheduled a work to hbus->wq, which can be
+	 * running pci_devices_present_work() -> survey_child_resources() ->
+	 * complete(&hbus->survey_event), even after hv_pci_query_relations()
+	 * exits and the stack variable 'comp' is no longer valid; as a result,
+	 * a hang or a page fault may happen when the complete() calls
+	 * raw_spin_lock_irqsave(). Flush hbus->wq before we exit from
+	 * hv_pci_query_relations() to avoid the issues. Note: if 'ret' is
+	 * -ENODEV, there can't be any more work item scheduled to hbus->wq
+	 * after the flush_workqueue(): see vmbus_onoffer_rescind() ->
+	 * vmbus_reset_channel_cb(), vmbus_rescind_cleanup() ->
+	 * channel->rescind = true.
+	 */
+	flush_workqueue(hbus->wq);
+
 	return ret;
 }
 
-- 
2.25.1


