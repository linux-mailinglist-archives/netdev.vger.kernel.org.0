Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C674D92FD
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbiCOD1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbiCOD1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:27:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADD5483AE;
        Mon, 14 Mar 2022 20:26:01 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHdwH0qDjzcZyY;
        Tue, 15 Mar 2022 11:21:03 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:25:59 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:25:58 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <stefanha@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <sgarzare@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 0/3] vdpa: add two ioctl commands to support generic vDPA
Date:   Tue, 15 Mar 2022 11:25:50 +0800
Message-ID: <20220315032553.455-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

To support generic vdpa deivce[1], we need add the following ioctls:
  - GET_CONFIG_SIZE: the size of the virtio config space (Patch 1)
  - GET_VQS_COUNT: the count of virtqueues that exposed (Patch 2)

Changes v2 -> v3:
  Patch 2:
    - use a separate patch for the u32 converting. [Jason]

Changes v1(RFC) -> v2:
  Patch 1:
    - be more verbose in commit message and the comment for get_config_size
      [Jason]
  Patch 2:
    - change the type of nvqs to u32 [Jason]
  Patch 3:
    - drop from this series because Gautam sent another proposal[2]

[1] https://lore.kernel.org/all/20220105005900.860-1-longpeng2@huawei.com/
[2] https://patchwork.kernel.org/project/kvm/patch/20220224212314.1326-20-gdawar@xilinx.com/

Longpeng (3):
  vdpa: support exposing the config size to userspace
  vdpa: change the type of nvqs to u32
  vdpa: support exposing the count of vqs to userspace

 drivers/vdpa/vdpa.c        |  6 +++---
 drivers/vhost/vdpa.c       | 40 ++++++++++++++++++++++++++++++++++++----
 include/linux/vdpa.h       |  9 +++++----
 include/uapi/linux/vhost.h |  7 +++++++
 4 files changed, 51 insertions(+), 11 deletions(-)

-- 
1.8.3.1

