Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3626A7140
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCAQes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCAQe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:34:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A94AFE5;
        Wed,  1 Mar 2023 08:33:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+/6An29Ui7JX4+52Nbtl6UBP4WmudqeYr8l7Xh2UZdQMFedjYyYmzr7qRrGtCeIYW3HWFpuxq+78YgdWRwnhI9T5Cxb4yT6yHhKNCHnhZOlL+KKYjJbTOl14EdSnut4kiBS/wfNDWrGDUrVIcV3HDac9bMEI5Qu3iM6fs5YxsksYaz/HzI/eozAS2+6bJFUSgM92ym7TALVnkWW+JPBGPp50NTtex1apxHYTbjk32pENB1jaffAObO2Zbsc/FRcTDNRmHrfdMQoeY9wYa+X360kz3TdH+/m0iyx37bDQ9397bcVdfg7gwwMP5MtXOREBpOuaKeNcFkG69c+xLuUAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kgt/t44JTJCTnDFzAl0CVVo0jn+uJ7arC8wDiyGxeyY=;
 b=JyighItzvlzeSDAjwuwzhk3Ysk3+R746wvf2u+DVQO0X2SsjYHOq8OebcTH7inl31qiNoF9WkkPPqfgGc5Ri4/erVZkTfnPFZyQjJi2VmsPeR0dWC2HHUVzQK5qnvgGFVZhz4aMm7o3w737Sejeh4ATLmJlDXOcIzcTXsVxsExVktJe7hCrD1bT8h3ZJw4Nt7hKiBXBRE4W1bt5T64rL/bEm0EplqMmmO/S+4gV1q47vqbQyMyymWvCQalUQ1R+H7AE0eINShYaihsQP5iQJs4n8kQZUV4v4pevp73q3A8lMYDGwme3yg1FcogcfGJvFMgh8cKJA9mUHiYkTXCKOgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kgt/t44JTJCTnDFzAl0CVVo0jn+uJ7arC8wDiyGxeyY=;
 b=Jg+kkJrfahNW7jAEQ2XYkBTQeWEjx+mB/ttEvee5eTpbJzDHDPGf/4zIWoEBjNGo5g6/JShdv04bUOe94z3pikeulZMEcOd702xX0tenu3IIhJO5fPwxrFopbjbo0DFkjU6jw2rP2JmRd8gzITkWLiqe4+nQ+IsjKU0qzY0Y9EQ=
Received: from BN9PR03CA0927.namprd03.prod.outlook.com (2603:10b6:408:107::32)
 by MN0PR12MB5786.namprd12.prod.outlook.com (2603:10b6:208:375::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 16:32:21 +0000
Received: from BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::d9) by BN9PR03CA0927.outlook.office365.com
 (2603:10b6:408:107::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30 via Frontend
 Transport; Wed, 1 Mar 2023 16:32:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT082.mail.protection.outlook.com (10.13.176.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Wed, 1 Mar 2023 16:32:21 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Mar
 2023 10:32:20 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Mar
 2023 08:32:20 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 1 Mar 2023 10:32:16 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <linux-net-drivers@amd.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH] vhost-vdpa: free iommu domain after last use during cleanup
Date:   Wed, 1 Mar 2023 22:02:01 +0530
Message-ID: <20230301163203.29883-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT082:EE_|MN0PR12MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: f2110bdf-e1fc-4793-6d87-08db1a7287e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YiWBJGDz895Kxro8GTfraBe0rLM8Q6xJEcr75lsh5uaoZQfkO6s/h6FpjGpWxVywVCv7Gpn2veAaL8I0lzRjYC0e1xTIzphaytFFOa9dGLN/fed8sCbDktE+DBZcDysAoGhrDJP/DKdAKoOZPDklCUEK046SJ4HsYYYFdbjPGb/avvhTLg9E5DzwywbYoQxetYs2oZJNHbgbcydUZU2ZlQp7caDURG7EGMm8L4CNvL4RwyeBaneBVuQhYtpUbuIAYlv088khtiuGQ5rQm9knlujAO8ZdroJnDmrwEP0yAy09sV/33jX220bS/y5miMiluHOOY15kFrZFYefKQkL3jz5taX4Gs5iuaZ95OCPrTeAIxpv2Pq6LrCD7GTEwW8Kyx6dQovIr5BOIfLH7uXn2thPKaRG4QljWOUt+wOrHP40QYyvqdf1fxgnqdFuU9Y3wE1noAOfK12l16euPV8aiNoHk367clUQj9ZISF2DRgoitaW/ed49hxvbpSWK1ekk8UE+Tmx6NjElpwzgSpu4dzxJw8sebetNG5CGtmTtbZ8DtyHMAk/rka1DatM+huBindeV2JYqPqUI/sPeJlNxqzdBKro3cCIBXDCUBpNstpcigpZDBF8s/GaC/NdzbqTon8KbShNytrUAkFqdsykgOabg1wZ7eBW3IfbGtw3WSYAbqPaqSiegmf7QaFrstWBVtUFyz5W/cJAcN6KaaBMG2gITAdJsQNSZwLPti0Z/c4Ok=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(46966006)(36840700001)(40470700004)(26005)(2906002)(5660300002)(6666004)(8936002)(8676002)(70206006)(44832011)(70586007)(54906003)(110136005)(316002)(478600001)(186003)(1076003)(36860700001)(2616005)(426003)(47076005)(336012)(82310400005)(41300700001)(83380400001)(4326008)(82740400003)(36756003)(86362001)(40460700003)(356005)(81166007)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 16:32:21.1011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2110bdf-e1fc-4793-6d87-08db1a7287e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5786
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vhost_vdpa_cleanup() unmaps the DMA mappings by calling
`iommu_unmap(v->domain, map->start, map->size);`
from vhost_vdpa_general_unmap() when the parent vDPA driver doesn't
provide DMA config operations.

However, the IOMMU domain referred to by `v->domain` is freed in
vhost_vdpa_free_domain() before vhost_vdpa_cleanup() in
vhost_vdpa_release() which results in NULL pointer de-reference.
Accordingly, moving the call to vhost_vdpa_free_domain() in
vhost_vdpa_cleanup() would makes sense. This will also help
detaching the dma device in error handling of vhost_vdpa_alloc_domain().

This issue was observed on terminating QEMU with SIGQUIT.

Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/vhost/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfde..b7657984dd8d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1134,6 +1134,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 
 err_attach:
 	iommu_domain_free(v->domain);
+	v->domain = NULL;
 	return ret;
 }
 
@@ -1178,6 +1179,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 			vhost_vdpa_remove_as(v, asid);
 	}
 
+	vhost_vdpa_free_domain(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 }
@@ -1250,7 +1252,6 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
-- 
2.30.1

