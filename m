Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047A04309C5
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbhJQOb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:31:59 -0400
Received: from mail-bn8nam08on2040.outbound.protection.outlook.com ([40.107.100.40]:10752
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229994AbhJQOb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 10:31:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ag8puPjvSQhgn754bbIrgVVHNMFmW2hdFKVdimkdPcvF9oLHY7MSLha5LdsYsakrGn8DJcp4275EuRfxWF381J4eOmIXDrSE7xnGev/6vnodHM4I1zz4d0dZl6y2GR2bhxNTg7559Pie0zyDzMIw5WEbcj78A7/S09Vqdl/6WM+5cnBOdWzU5UIDRATFQUWzxTdOEqnP2LtP1mgc4C1AolC5MhLgz2n1jUid+9ipdrrz1Hsi4ZrqSH0wkLr5JHVT7slzAPmhFnPAKlXNq8fQ8KwR1w30nSDfIjX3V6H07D94uNa8u06MTssgVCJOVxApO6EeqHqJQA31CeWBi9fQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhPQAiuOwceN/uCfoRBisN53PNzDPeTLF2xfkENMgz4=;
 b=TfxO2+zGyaGklAomyiNfeMh18YpZKENKsOrh0cu0eyw4fyZnmQb+VxgM2mPpL/VlBMugIO1MPiFrsBaDxxOJa6eXDVzdiq/W+vEn27OhXoXQ+PA7uRPZZBt1CC99Pcy7Ucr3VsiYd3yHSe+TjxGZmMhiHEGlMYlz7AXtdXgY77Wr1nmUlsMiSI2rZZWVNlILYn6ySArvHQkgYviy9POBnonF7hyiwelgbg3lnSArh71AKybq1fviBXeTkmsrqidsjfqpl2ZPsu4BAkzWe8uBtzbBDGgRyUE7R+r0McGIYSZDb+nTbN2Fw29JkHs1OwltfOE5tGrN4DR5Jg9Si6KN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhPQAiuOwceN/uCfoRBisN53PNzDPeTLF2xfkENMgz4=;
 b=iDd+r6KfIF0lh/OgHIcN12z7sMbNrLSwNGIrB4o2cJ3RGs8STRUYH4OhPHqojvA0jqGLU7BeE+NGp71q8XMmBK9Z783GtFrxOe51UBZUWc6N8/JBeYMigiAzAPC5+BSZbYh4NpRpNYbutYUBjWU9E7uuiwB1O91SQtA3Jhqj2tp9yrx485o9twX/AJuQnueiEjk/ruwJvP83zWrZBSCKTFG04pxzaXp5iH6P2MfFhtDJlXqNRtMx2aWyyJC28mOD96JrDgMZGcCR2/bfZAlma4EdBLjrZO15fihi4Iy0bk6vFMWbmSj3z3lufKc9asdjkWoSDVnQiUWimd6G3Crlxg==
Received: from DM3PR03CA0004.namprd03.prod.outlook.com (2603:10b6:0:50::14) by
 MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Sun, 17 Oct
 2021 14:29:48 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::60) by DM3PR03CA0004.outlook.office365.com
 (2603:10b6:0:50::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Sun, 17 Oct 2021 14:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 14:29:47 +0000
Received: from [172.27.13.186] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 17 Oct
 2021 14:29:44 +0000
Subject: Re: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let
 vfio_pci_core drivers trap device RESET
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-13-yishaih@nvidia.com>
 <20211015135237.759fe688.alex.williamson@redhat.com>
 <20211015200328.GG2744544@nvidia.com>
 <20211015151243.3c5b0910.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <d91f729b-d547-406f-353f-04627d4e555c@nvidia.com>
Date:   Sun, 17 Oct 2021 17:29:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211015151243.3c5b0910.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afc8b5c8-e290-4985-f6eb-08d9917a9246
X-MS-TrafficTypeDiagnostic: MN2PR12MB4093:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4093BCBBDB44CA0CC3185194C3BB9@MN2PR12MB4093.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifBmfE9v9cZkK40vBcOjsgFA7I24VmdWmmqGGpw54xX6kkXMkulibZwW7hC1zFc2M8j/2THwyLIBcS+0VqytgKT1K4jVFGS8mlTthCNQAGjCxUf0+2CZjTngA1rZH1FDsdANsI84QkvQ9izqa0Pod32HON7HcCv9itgu7wbOfgmf6VOJS7AtLXNMov6v6mh3I2nsR3K6X5H5I/M+Grui/SY5dWzFY5V+Dazovh1GL2D7u6Pf7rXXY9s7O/d4ZBFO1v61Cg+PNCjmfSh//RduvGA7Pfjq5Kmuo0fNN8F44ifuK5GoOw//VdDITItnHHde93dDP7Ot8KlBqDqIqNqT3p+88l+SLmqREDFsvf5Q6G3S/RC5+KngSDRuN/SjA+pZymmjYK5MOGCG+MOKjzctoUpFf9tUL2hWsfDgdy0gqq6Cy9Xgb/qAEuX0fj7Zf9vo1Ajtz3gcgUhn0381lzmnhFJdnKbZXTzdkSvfO4ttxSgr7+ZABoCVl/ZlTHaT3QniV2/usUxx2o/uARIhSnWYLLjnCcQsPWFRmmnmjlU8L0fggOKdsOlaQDp7nutUqgewLDH15zD2kCW9WRvsZyCrIr5q4h4/Dzgstnn8IO3EHEJJ3oGf07hNq2fC6gEaWZ33apsm1U15StEG6vCnZHeGDbeXL1l2JmPqRoaN3Ls6C29obQU3rFN5SGMBvpuKj1mDE9fBe5zUNuXA2sE0C9/3uHhcznZcqPrcvgy9gVWTdfY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(107886003)(8936002)(31686004)(70206006)(6666004)(426003)(36756003)(16576012)(82310400003)(53546011)(31696002)(8676002)(26005)(16526019)(86362001)(2906002)(6636002)(70586007)(54906003)(36860700001)(186003)(316002)(356005)(7636003)(47076005)(2616005)(83380400001)(336012)(5660300002)(110136005)(508600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 14:29:47.4738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afc8b5c8-e290-4985-f6eb-08d9917a9246
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/2021 12:12 AM, Alex Williamson wrote:
> On Fri, 15 Oct 2021 17:03:28 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Fri, Oct 15, 2021 at 01:52:37PM -0600, Alex Williamson wrote:
>>> On Wed, 13 Oct 2021 12:47:06 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>    
>>>> Add infrastructure to let vfio_pci_core drivers trap device RESET.
>>>>
>>>> The motivation for this is to let the underlay driver be aware that
>>>> reset was done and set its internal state accordingly.
>>> I think the intention of the uAPI here is that the migration error
>>> state is exited specifically via the reset ioctl.  Maybe that should be
>>> made more clear, but variant drivers can already wrap the core ioctl
>>> for the purpose of determining that mechanism of reset has occurred.
>> It is not just recovering the error state.
>>
>> Any transition to reset changes the firmware state. Eg if userspace
>> uses one of the other emulation paths to trigger the reset after
>> putting the device off running then the driver state and FW state
>> become desynchronized.
>>
>> So all the reset paths need to be synchronized some how, either
>> blocked while in non-running states or aligning the SW state with the
>> new post-reset FW state.
> This only catches the two flavors of FLR and the RESET ioctl itself, so
> we've got gaps relative to "all the reset paths" anyway.  I'm also
> concerned about adding arbitrary callbacks for every case that it gets
> too cumbersome to write a wrapper for the existing callbacks.
>
> However, why is this a vfio thing when we have the
> pci_error_handlers.reset_done callback.  At best this ought to be
> redundant to that.  Thanks,
>
> Alex
>
Alex,

How about the below patch instead ?

This will centralize the 'reset_done' notifications for drivers to one 
place (i.e. pci_error_handlers.reset_done)  and may close the gap that 
you pointed on.

I just followed the logic in vfio_pci_aer_err_detected() from usage and 
locking point of view.

Do we really need to take the &vdev->igate mutex as was done there ?

The next patch from the series in mlx5 will stay as of in V1, it may 
just set its ops and be called upon PCI 'reset_done'.


diff --git a/drivers/vfio/pci/vfio_pci_core.c 
b/drivers/vfio/pci/vfio_pci_core.c
index e581a327f90d..20bf37c00fb6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1925,6 +1925,27 @@ static pci_ers_result_t 
vfio_pci_aer_err_detected(struct pci_dev *pdev,
         return PCI_ERS_RESULT_CAN_RECOVER;
  }

+static void vfio_pci_aer_err_reset_done(struct pci_dev *pdev)
+{
+       struct vfio_pci_core_device *vdev;
+       struct vfio_device *device;
+
+       device = vfio_device_get_from_dev(&pdev->dev);
+       if (device == NULL)
+               return;
+
+       vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+       mutex_lock(&vdev->igate);
+       if (vdev->ops && vdev->ops->reset_done)
+               vdev->ops->reset_done(vdev);
+       mutex_unlock(&vdev->igate);
+
+       vfio_device_put(device);
+
+       return;
+}
+
  int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
  {
         struct vfio_device *device;
@@ -1947,6 +1968,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);

  const struct pci_error_handlers vfio_pci_core_err_handlers = {
         .error_detected = vfio_pci_aer_err_detected,
+       .reset_done = vfio_pci_aer_err_reset_done,
  };
  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..6ccf5824f098 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -95,6 +95,15 @@ struct vfio_pci_mmap_vma {
         struct list_head        vma_next;
  };

+/**
+ * struct vfio_pci_core_device_ops - VFIO PCI driver device callbacks
+ *
+ * @reset_done: Called when the device was reset
+ */
+struct vfio_pci_core_device_ops {
+       void    (*reset_done)(struct vfio_pci_core_device *vdev);
+};
+
  struct vfio_pci_core_device {
         struct vfio_device      vdev;
         struct pci_dev          *pdev;
@@ -137,6 +146,7 @@ struct vfio_pci_core_device {
         struct mutex            vma_lock;
         struct list_head        vma_list;
         struct rw_semaphore     memory_lock;
+       const struct vfio_pci_core_device_ops *ops;
  };




