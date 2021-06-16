Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AC3A909C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 06:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFPE2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 00:28:39 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4794 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFPE2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 00:28:38 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4X7Y74sRzXg41;
        Wed, 16 Jun 2021 12:21:29 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 16
 Jun 2021 12:26:28 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] samples/bpf: Fix the error return code of xdp_redirect's main()
Date:   Wed, 16 Jun 2021 12:25:34 +0800
Message-ID: <20210616042534.315097-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

If bpf_map_update_elem() failed, main() should return a negative error.

Fixes: 832622e6bd18 ("xdp: sample program for new bpf_redirect helper")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 samples/bpf/xdp_redirect_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 41d705c3a1f7..c903f1ccc15e 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -213,5 +213,5 @@ int main(int argc, char **argv)
 	poll_stats(2, ifindex_out);
 
 out:
-	return 0;
+	return ret;
 }
-- 
2.17.1

