Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D022AB222
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgKIIFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:05:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7618 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIIFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:05:53 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CV3TJ3j5BzLtfG;
        Mon,  9 Nov 2020 16:05:40 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 16:05:49 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 0/2] Fix usage counter leak by adding a general sync ops
Date:   Mon, 9 Nov 2020 16:09:36 +0800
Message-ID: <20201109080938.4174745-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many caller forget to decrease the usage counter when call
pm_runtime_get_sync. This problem has been discussed in detail,
[0][1] and we add gene_pm_runtime_get_sync ops to deal with usage
counter for better coding. Then, we replace pm_runtime_get_sync
with it in fec_main.c

[0]https://lkml.org/lkml/2020/6/14/88
[1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520095148.10995-1-dinghao.liu@zju.edu.cn/

Zhang Qilong (2):
  PM: runtime: Add a general runtime get sync operation to deal with
    usage counter
  net: fec: Fix reference count leak in fec series ops

 drivers/net/ethernet/freescale/fec_main.c | 10 +++----
 include/linux/pm_runtime.h                | 32 +++++++++++++++++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

-- 
2.25.4

