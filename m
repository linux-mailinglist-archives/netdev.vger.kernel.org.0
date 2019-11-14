Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BB3FC0E7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 08:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNHkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 02:40:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbfKNHkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 02:40:24 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BB7169B37EB07AFF63AA;
        Thu, 14 Nov 2019 15:40:21 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 14 Nov 2019
 15:40:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <borisp@mellanox.com>, <aviadye@mellanox.com>,
        <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub.kicinski@netronome.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/tls: Fix unused function warning
Date:   Thu, 14 Nov 2019 15:39:46 +0800
Message-ID: <20191114073946.46340-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If PROC_FS is not set, gcc warning this:

net/tls/tls_proc.c:23:12: warning:
 'tls_statistics_seq_show' defined but not used [-Wunused-function]

Use #ifdef to guard this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/tls/tls_proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 83d9c80..3a5dd1e 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -6,6 +6,7 @@
 #include <net/snmp.h>
 #include <net/tls.h>
 
+#ifdef CONFIG_PROC_FS
 static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsCurrTxSw", LINUX_MIB_TLSCURRTXSW),
 	SNMP_MIB_ITEM("TlsCurrRxSw", LINUX_MIB_TLSCURRRXSW),
@@ -32,6 +33,7 @@ static int tls_statistics_seq_show(struct seq_file *seq, void *v)
 
 	return 0;
 }
+#endif
 
 int __net_init tls_proc_init(struct net *net)
 {
-- 
2.7.4


