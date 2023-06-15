Return-Path: <netdev+bounces-10979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FA0730E4D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5CB31C20E46
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5A780D;
	Thu, 15 Jun 2023 04:45:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F197ED
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:45:50 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B94212B;
	Wed, 14 Jun 2023 21:45:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/biEWcsmTCTqLammabYpFl15iT+OG/inM8YgfOuU1EOlpszV+iXH+HxeaG0uYL9ExF0/OLKrgvHHvesS0NngFLyMy91VKKAOTKtwdLnJIUgTurz+XFuXCLzJyCZGT9CR77loLUaV9jpTrWTYyLbYYuocdwXdNMRSZUME/PGvGWrwQYW2kvtNbbF+HP9htuFpM++2ck/pJjaQeakAJd1EXzmEptAxup1u64yT5J9NXm6om27iLbUwM7PaFsPm6tJ9+9sVl1rEwW3wZ1d4oQRhg0HgZ26Tc4XRTl9y1S8wKR9ESGkzXe9IFc68FOHj9ND/ic6aFLvLibKFdTqEeAg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XB/ceB0iHCgRi4TRsvtgV9J8qIRTlPRi2g1VdUtXxNY=;
 b=E8Srw66dx5NtBcf77yLJmX7GX78xXpVnXsBCYB63JOCcVKOR3pObjLblYw91SzhwK8Bb0R/5APvDYR9+l1mVfZ6gprl/fTuQJjmQnrsRhjWeQvTWMcKH0VU7IfN9XtDcOl+C+AhSwueNzFUBrjzZkzEVjgTE6B4h/TB4h9hfIEdFOKErItagEn0jE9Ji+vmm2fdWZkiEmhI42UQGEYGA5/cfP8YK/W294wSE353235zOrT9SLIi4xJt8ZVBV9IKkOZygH/R+Naq6iRQNhBh9ASWUJykZJ6S+loMEqENUZtRKkoLQthgGTjLRTIDi6jS+/4bzItXcdLjfd8+c6CxZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XB/ceB0iHCgRi4TRsvtgV9J8qIRTlPRi2g1VdUtXxNY=;
 b=ILjqORlQ42ZKWOR4IyhC1vwoph/UZTJh47qs+mIKFXwNTvz0J+/b1BoXKbmXyz+/7Qs9VfZQv/eljIudERVW57SDydHNbu/qRs+EpzyMqOLFR/CClWC0fGIUteV3s4U0f6kpmu5EA7QUuF7C+mWRIuhG/r0hLrSW0I5kslIjPxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:40 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:40 +0000
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
Subject: [PATCH v4 2/5] PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
Date: Wed, 14 Jun 2023 21:44:48 -0700
Message-Id: <20230615044451.5580-3-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 51762adb-e74f-476a-08ef-08db6d5b5e87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lXSZXza3O2NuL/1PxOkl0LNDzssPJ2Fh7NWiDabgjNC2YgEwZZK+bMgB50nqIokvah7X0xKCgA9g4j/4gKW1G64XumE2GE2c2uUShCECy/UTRlzREHvtZIOMdAAx3thorxLejZZrhgJ44Zn2Zql8GG2ESvW/HV/kyAR5d8CBSMaBofn6+cY5fQn8EEjDRqD+A6G83IPUph82byUm1eySjMRIO6pkNNNiXqOeM2/azgty5AQpN8qZ0QhtZtFuBmhhvx9ZVUxhw99uFdarsv67z4YcTC9l3Pvh/w022lJ29KeeUpu+dky6vtD7GmDZBQQXmYFo/fpiI1bX4VhqXm6DCMnySbNWcMg3ylN9VEh1nrxRktYqXCZSAIc/NHP3H++jF3ICNw/kt+otF72pVqmtDq9xlBT8KY4SCGF93aHsKT+kwL1Y8u9qnP17WcsKD2grDB9+L2XjqeRHloi5h0oGASF5sVMJm+fLdUNzWWxW+zlqlGx7cf1INP5iFNp4uC2/ACMV3E4MdA7KjrGbh5LfZKcEHVcrak0/CQBV7YEpkLPYc8cmJPJBnlhdTr8TReCZZKFQh2pMT8mvEje9zMIe4NhrH3KRyZYCPG458P7qew7kUSdUsV7ndV+RGiRTaqP7VXuIAxP9I7RoyCNl7DAuyA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(186003)(6486002)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fqSWqSSzHFwQWZ4yMEUHfnI/0Mgy6PrEHgNZaoAg0nSm6MjEAHyyy9EVPbCB?=
 =?us-ascii?Q?UfECwds449RK3noHNjxpPEx46w9RiLmWfLrXIRJclUb9BV668vQ38vmPdkZU?=
 =?us-ascii?Q?dZ41NtmUKqvhPB4emyD5fPvZt2lnKW+AW3XT0i7Qyo9Q6kAByUWV5M7VjH3R?=
 =?us-ascii?Q?sSZXfnQPahdlkzUekRtwNtqfhjRmsgHXaxBxFfaXYn5DJfEwTKXlQ8bI/JMJ?=
 =?us-ascii?Q?YNafNIyt2io389XGY+A+z6SgAR8w9ZYBGAD/+3w6Lq9DOBs4isu7WM9ydjk3?=
 =?us-ascii?Q?EBdrX7lY2mUSp8xGBkbuYOaEJzQ0N5N/aUcIBauKFLCM1YtSenizmJ/EX4o3?=
 =?us-ascii?Q?/MBHMVqn3OQYpRMZAdEURP0UdsDPafV2nS0+K9wwsd4GluJE0AvxqZflcvDx?=
 =?us-ascii?Q?4qvEGiOAyqPxLmkMMA1deyytuZuq7BrwW12t2CI2prLTTcSXew4yazVpPYGg?=
 =?us-ascii?Q?4fUjj1rTvkT3dIRlKO+VgQB1YOtGJ5ofFAXP4Z814bVRTLr3L3lTefzSUWWu?=
 =?us-ascii?Q?SgxioV+YAh+y+YjJu3cnWZRdvkQSxEGH7UPRC0GyQ2vmMsAWsQWyeLzpqnf0?=
 =?us-ascii?Q?EsfEWzMsGDqfp8ohO1uguZnsnEwyRLfGN+lW3Lm24mXfYwe7+pBMPsqD+10m?=
 =?us-ascii?Q?avTwNOHCh15jGTDOg2xVau4SfSX5HEpgxWcJ/WOK5+2x2p9ZUC79gas/k/Dd?=
 =?us-ascii?Q?MEMFBORfNH/ue5U89uiY9U1CNHa03rC8GeD5JCGl5hQLsQy4qc7/PyIlhgA/?=
 =?us-ascii?Q?/vXDqhNtbE184urq8hGDTiqwSN6LtNxQwPpvDf9+yZjm2++SJxuBteFklwch?=
 =?us-ascii?Q?u9R2iKK+lb+b5Sx89vLAVcGYyIw4uF8naBv+OrKbd4DrDmDVQ9/BW32CLmCi?=
 =?us-ascii?Q?vmGPmIA7LKY+KO/MFZ3oQlCm70E/90WcIzXW/1jOUVHryAHoJ7FRNg/Yc+B3?=
 =?us-ascii?Q?QkWf7VltfFL/EHMW8iT13W+/kMb06KrG+USa4lLOF6felVnblP5tqXys/xjW?=
 =?us-ascii?Q?/m72vJYbveTUMW+yG/Nn+27Dw2hLsys9nYKj/GL8uvwcdpK2o3cEwpEFPEgC?=
 =?us-ascii?Q?41r5xvO1RHJsV2YvH/gz8g+90hFVB1xVbe/rWkOjxYnnCkmeA2ZZd5SJoMFa?=
 =?us-ascii?Q?ZppoZZzpikpmDEAR0eRUxKUo95xKunc2B7qad+Uv85PtGMvViqDQgaYeyrRy?=
 =?us-ascii?Q?kz+6s2y3iUGVZOpLeaHaNWL+SlymgxXyYOnlatp4tANNXouF6WwgK6AGT0as?=
 =?us-ascii?Q?fJyWiMh9wrBRrt79u2504OscG+ygBytYpg2dHx1Ml/ZKSyQ99v8FuBdq1WWA?=
 =?us-ascii?Q?1MAYbZA2ykd3XNiTE+ilb7Z1RJKsI6P/rv7piwQ+AHUq+vOwzMYw+S3BM3yJ?=
 =?us-ascii?Q?oZvovIXFTG8nh/oEqj2JzTQ91hjLo5nwFq8q1G0Tx9EgMVlGWnntlYUbYc3a?=
 =?us-ascii?Q?cI8ajEc1zxTQOX2rZfXCxwEKbrhGkQx6kvQVTeL9BpnZRG6tAhAM3q4CoEJd?=
 =?us-ascii?Q?Wyt5oHn3kwYjb0F/pv1tXYJQVlL1z1FWKyr7zRf/LssNHuWSaZ2uaftwcyzx?=
 =?us-ascii?Q?aSEBVZphaRDIn09WV9zFyXtBApNGkEkH4NZUjUZPey9jOAtODmyLy5F2vcXO?=
 =?us-ascii?Q?uczpHn2/SUl0WWSfpGXD0AaOOCplYvsdcExvILfnhbOW?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51762adb-e74f-476a-08ef-08db6d5b5e87
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:39.9982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiboE7hAa4C4GRVPTbTLdacuh6GorxpMadwtxmFK3yIzEtgDaO4QDOnpvB6kBj2CP7L5dS0E5G6m8BoSov7+MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the host tries to remove a PCI device, the host first sends a
PCI_EJECT message to the guest, and the guest is supposed to gracefully
remove the PCI device and send a PCI_EJECTION_COMPLETE message to the host;
the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
the guest (when the guest receives this message, the device is already
unassigned from the guest) and the guest can do some final cleanup work;
if the guest fails to respond to the PCI_EJECT message within one minute,
the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
removes the PCI device forcibly.

In the case of fast device addition/removal, it's possible that the PCI
device driver is still configuring MSI-X interrupts when the guest receives
the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
hv_eject_device_work(); if the PCI device driver is calling
pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
leave data->chip_data with its default value of NULL; later, when the PCI
device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.

Fix the issue by not testing hpdev->state in the while loop: when the
guest receives PCI_EJECT, the device is still assigned to the guest, and
the guest has one minute to finish the device removal gracefully. We don't
really need to (and we should not) test hpdev->state in the loop.

Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

v4:
  No change since v3.

 drivers/pci/controller/pci-hyperv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index ea8862e656b68..733637d967654 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -635,6 +635,11 @@ static void hv_arch_irq_unmask(struct irq_data *data)
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
 	int_desc = data->chip_data;
+	if (!int_desc) {
+		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
+			 __func__, data->irq);
+		return;
+	}
 
 	local_irq_save(flags);
 
@@ -2004,12 +2009,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		hv_pci_onchannelcallback(hbus);
 		spin_unlock_irqrestore(&channel->sched_lock, flags);
 
-		if (hpdev->state == hv_pcichild_ejecting) {
-			dev_err_once(&hbus->hdev->device,
-				     "the device is being ejected\n");
-			goto enable_tasklet;
-		}
-
 		udelay(100);
 	}
 
-- 
2.25.1


