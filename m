Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820293BB606
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 05:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhGEEAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 00:00:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6391 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGEEAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 00:00:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJBf02gSFz77Td;
        Mon,  5 Jul 2021 11:54:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:58:09 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:58:09 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     <nickhu@andestech.com>, <green.hu@gmail.com>,
        <deanbo422@gmail.com>, <akpm@linux-foundation.org>,
        <yury.norov@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
Date:   Mon, 5 Jul 2021 11:57:33 +0800
Message-ID: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tools/include/* have a lot of abstract layer for building
kernel code from userspace, so reuse or add the abstract
layer in tools/include/ to build the ptr_ring for ringtest
testing.

The same abstract layer can be used to build the ptr_ring
for ptr_ring benchmark app too, see [1].

1. https://lkml.org/lkml/2021/7/1/275 

Yunsheng Lin (2):
  tools: add missing infrastructure for building ptr_ring.h
  tools/virtio: use common infrastructure to build ptr_ring.h

 tools/include/asm/cache.h          |  56 ++++++++++++++++++++
 tools/include/asm/processor.h      |  36 +++++++++++++
 tools/include/generated/autoconf.h |   1 +
 tools/include/linux/align.h        |  15 ++++++
 tools/include/linux/cache.h        |  87 +++++++++++++++++++++++++++++++
 tools/include/linux/gfp.h          |   4 ++
 tools/include/linux/slab.h         |  46 +++++++++++++++++
 tools/include/linux/spinlock.h     |   2 -
 tools/virtio/ringtest/Makefile     |   2 +-
 tools/virtio/ringtest/main.h       | 100 +++---------------------------------
 tools/virtio/ringtest/ptr_ring.c   | 102 ++-----------------------------------
 11 files changed, 257 insertions(+), 194 deletions(-)
 create mode 100644 tools/include/asm/cache.h
 create mode 100644 tools/include/asm/processor.h
 create mode 100644 tools/include/generated/autoconf.h
 create mode 100644 tools/include/linux/align.h
 create mode 100644 tools/include/linux/cache.h
 create mode 100644 tools/include/linux/slab.h

-- 
2.7.4

