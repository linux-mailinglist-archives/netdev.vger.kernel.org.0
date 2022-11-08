Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2344620F69
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiKHLsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiKHLsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:48:09 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E90910541
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:48:07 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N65vG03pkzmVj7;
        Tue,  8 Nov 2022 19:47:54 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:48:05 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 19:48:05 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jiaxun.yang@flygoat.com>, <zhangqing@loongson.cn>,
        <liupeibao@loongson.cn>, <andrew@lunn.ch>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net v2 0/3] stmmac: dwmac-loongson: fixes three leaks
Date:   Tue, 8 Nov 2022 19:46:44 +0800
Message-ID: <20221108114647.4144952-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #2 fixes missing pci_disable_device() in the error path in probe()
patch #1 and pach #3 fix missing pci_disable_msi() and of_node_put() in
error and remove() path.

v1 -> v2:
  Make another two error paths 'goto err_disable_msi' in path #1.

Yang Yingliang (3):
  stmmac: dwmac-loongson: fix missing pci_disable_msi() while module
    exiting
  stmmac: dwmac-loongson: fix missing pci_disable_device() in
    loongson_dwmac_probe()
  stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

-- 
2.25.1

