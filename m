Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927B55B819F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 08:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiINGrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 02:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiINGrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 02:47:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A8161726;
        Tue, 13 Sep 2022 23:47:21 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MS9lV2t1mzmVGh;
        Wed, 14 Sep 2022 14:43:34 +0800 (CST)
Received: from huawei.com (10.67.175.83) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 14 Sep
 2022 14:47:19 +0800
From:   ruanjinjie <ruanjinjie@huawei.com>
To:     <jgross@suse.com>, <sstabellini@kernel.org>,
        <oleksandr_tyshchenko@epam.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] xen-netfront: make bounce_skb static
Date:   Wed, 14 Sep 2022 14:43:39 +0800
Message-ID: <20220914064339.49841-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The symbol is not used outside of the file, so mark it static.

Fixes the following warning:

./drivers/net/xen-netfront.c:676:16: warning: symbol 'bounce_skb' was not declared. Should it be static?

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
---
 drivers/net/xen-netfront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 27a11cc08c61..2cb7e741e1a2 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -673,7 +673,7 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 	return nxmit;
 }
 
-struct sk_buff *bounce_skb(const struct sk_buff *skb)
+static struct sk_buff *bounce_skb(const struct sk_buff *skb)
 {
 	unsigned int headerlen = skb_headroom(skb);
 	/* Align size to allocate full pages and avoid contiguous data leaks */
-- 
2.25.1

