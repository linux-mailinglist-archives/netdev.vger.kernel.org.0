Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F263D182
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiK3JQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiK3JQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:16:57 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8302EF76;
        Wed, 30 Nov 2022 01:16:56 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NMYVp6lnvz4f3mbc;
        Wed, 30 Nov 2022 17:16:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgBni9iDH4djSnyfBQ--.53612S4;
        Wed, 30 Nov 2022 17:16:53 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH wpan] mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
Date:   Wed, 30 Nov 2022 09:17:05 +0000
Message-Id: <20221130091705.1831140-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBni9iDH4djSnyfBQ--.53612S4
X-Coremail-Antispam: 1UD129KBjvJXoW7trWDurW5Zr43CF4rXw1fZwb_yoW8AF1rpa
        43Gas8KFW8XrsxCw4UXF1UCFyUGr48Ca40934xCF9xuFsag340k3yxCrZrZFyUArs0vryr
        Zw4DAw1Sva1kG3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Kernel fault injection test reports null-ptr-deref as follows:

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: 0010:cfg802154_netdev_notifier_call+0x120/0x310 include/linux/list.h:114
Call Trace:
 <TASK>
 raw_notifier_call_chain+0x6d/0xa0 kernel/notifier.c:87
 call_netdevice_notifiers_info+0x6e/0xc0 net/core/dev.c:1944
 unregister_netdevice_many_notify+0x60d/0xcb0 net/core/dev.c:1982
 unregister_netdevice_queue+0x154/0x1a0 net/core/dev.c:10879
 register_netdevice+0x9a8/0xb90 net/core/dev.c:10083
 ieee802154_if_add+0x6ed/0x7e0 net/mac802154/iface.c:659
 ieee802154_register_hw+0x29c/0x330 net/mac802154/main.c:229
 mcr20a_probe+0xaaa/0xcb1 drivers/net/ieee802154/mcr20a.c:1316

ieee802154_if_add() allocates wpan_dev as netdev's private data, but not
init the list in struct wpan_dev. cfg802154_netdev_notifier_call() manage
the list when device register/unregister, and may lead to null-ptr-deref.

Use INIT_LIST_HEAD() on it to initialize it correctly.

Fixes: fcf39e6e88e9 ("ieee802154: add wpan_dev_list")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index d9b50884d34e..f6122ab15449 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -650,6 +650,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
-- 
2.34.1

