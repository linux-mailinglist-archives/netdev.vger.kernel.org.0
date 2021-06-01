Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5C3974D2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhFAOD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:03:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2828 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhFAOD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:03:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvYcY38YmzWqbv;
        Tue,  1 Jun 2021 21:57:01 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:01:43 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 1 Jun
 2021 22:01:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] hamradio: bpqether: Fix -Wunused-const-variable warning
Date:   Tue, 1 Jun 2021 22:00:52 +0800
Message-ID: <20210601140052.31456-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PROC_FS is n, gcc warns:

drivers/net/hamradio/bpqether.c:437:36:
 warning: ‘bpq_seqops’ defined but not used [-Wunused-const-variable=]
 static const struct seq_operations bpq_seqops = {
                                    ^~~~~~~~~~
Use #ifdef macro to gurad this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/hamradio/bpqether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 1ad6085994b1..0e623c2e8b2d 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -368,7 +368,7 @@ static int bpq_close(struct net_device *dev)
 
 /* ------------------------------------------------------------------------ */
 
-
+#ifdef CONFIG_PROC_FS
 /*
  *	Proc filesystem
  */
@@ -440,7 +440,7 @@ static const struct seq_operations bpq_seqops = {
 	.stop = bpq_seq_stop,
 	.show = bpq_seq_show,
 };
-
+#endif
 /* ------------------------------------------------------------------------ */
 
 static const struct net_device_ops bpq_netdev_ops = {
-- 
2.17.1

