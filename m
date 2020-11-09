Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60D2ABF4C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgKIPAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:00:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7504 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729905AbgKIPAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:00:38 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVDgr5VCDzhfN2;
        Mon,  9 Nov 2020 23:00:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 23:00:27 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 0/2] Fix usage counter leak by adding a general sync ops
Date:   Mon, 9 Nov 2020 23:04:14 +0800
Message-ID: <20201109150416.1877878-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many case, we need to check return value of pm_runtime_get_sync,
but it brings a trouble to the usage counter processing. Many callers
forget to decrease the usage counter when it failed. It has been
discussed a lot[0][1]. So we add a function to deal with the usage
counter for better coding and view. Then, we replace pm_runtime_get_sync
with it in fec_main.c

Zhang Qilong (2):
  PM: runtime: Add a general runtime get sync operation to deal with
    usage counter
  net: fec: Fix reference count leak in fec series ops

 drivers/net/ethernet/freescale/fec_main.c | 12 ++++-----
 include/linux/pm_runtime.h                | 30 +++++++++++++++++++++++
 2 files changed, 35 insertions(+), 7 deletions(-)

-- 
2.25.4

