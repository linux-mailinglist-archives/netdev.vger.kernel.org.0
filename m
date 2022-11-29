Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109B363C37A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiK2PSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbiK2PSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:18:24 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C5F10E8;
        Tue, 29 Nov 2022 07:18:21 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NM5YX4lRrzHwJ8;
        Tue, 29 Nov 2022 23:17:36 +0800 (CST)
Received: from huawei.com (10.67.175.21) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 23:18:17 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <lizetao1@huawei.com>
CC:     <st@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
        <stefanha@redhat.com>, <axboe@kernel.dk>, <airlied@redhat.com>,
        <kraxel@redhat.com>, <gurchetansingh@chromium.org>,
        <olvaffe@gmail.com>, <daniel@ffwll.ch>, <david@redhat.com>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pmorel@linux.vnet.ibm.com>, <cornelia.huck@de.ibm.com>,
        <pankaj.gupta.linux@gmail.com>, <rusty@rustcorp.com.au>,
        <airlied@gmail.com>, <virtualization@lists.linux-foundation.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>
Subject: [PATCH v2 0/5] Fix probe failed when modprobe modules
Date:   Wed, 30 Nov 2022 00:06:10 +0800
Message-ID: <20221129160615.3343036-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221128021005.232105-1-lizetao1@huawei.com>
References: <20221128021005.232105-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.21]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes similar issue, the root cause of the
problem is that the virtqueues are not stopped on error
handling path.

Changes since v1:
- Modify the description error of the test case and fixes tag
  information.
- Add patch to fix virtio_gpu module.

v1 at:
https://lore.kernel.org/all/20221128021005.232105-1-lizetao1@huawei.com/

Li Zetao (5):
  9p: Fix probe failed when modprobe 9pnet_virtio
  virtio-mem: Fix probe failed when modprobe virtio_mem
  virtio-input: Fix probe failed when modprobe virtio_input
  virtio-blk: Fix probe failed when modprobe virtio_blk
  drm/virtio: Fix probe failed when modprobe virtio_gpu

 drivers/block/virtio_blk.c           | 1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c | 1 +
 drivers/virtio/virtio_input.c        | 1 +
 drivers/virtio/virtio_mem.c          | 1 +
 net/9p/trans_virtio.c                | 1 +
 5 files changed, 5 insertions(+)

-- 
2.25.1

