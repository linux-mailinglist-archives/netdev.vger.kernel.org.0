Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6256628183
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiKNNk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiKNNkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:40:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDB1F2D0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:40:25 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9r5v4JhMzmVpp;
        Mon, 14 Nov 2022 21:40:03 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 21:40:22 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <horatiu.vultur@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <casper.casan@gmail.com>,
        <bjarni.jonasson@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 0/2] net: microchip: Fix potential null-ptr-deref due to create_singlethread_workqueue()
Date:   Mon, 14 Nov 2022 21:38:51 +0800
Message-ID: <20221114133853.5384-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some functions call create_singlethread_workqueue() without
checking ret value, and the NULL workqueue_struct pointer may causes
null-ptr-deref. Will be fixed by this patch.

Shang XiaoJing (2):
  net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
  net: microchip: sparx5: Fix potential null-ptr-deref in
    sparx_stats_init() and sparx5_start()

 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c | 3 +++
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c   | 3 +++
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c      | 3 +++
 3 files changed, 9 insertions(+)

-- 
2.17.1

