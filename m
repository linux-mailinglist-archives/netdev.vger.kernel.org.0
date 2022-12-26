Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE34656483
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 19:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiLZSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 13:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiLZSLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 13:11:16 -0500
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B3C2F;
        Mon, 26 Dec 2022 10:11:13 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 26 Dec
 2022 21:09:56 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 26 Dec
 2022 21:09:56 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        =?UTF-8?q?Dima=C2=B7Chumak=C2=B7?= <dchumak@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lvc-project@linuxtesting.org>
Subject: [PATCH 5.10 0/1] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
Date:   Mon, 26 Dec 2022 10:09:49 -0800
Message-ID: <20221226180950.86129-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The result of __dev_get_by_index() is not checked for NULL, which then
passed to mlx5e_attach_encap() and gets dereferenced.

This patch backports commit <fe7738e> to correct the issue in 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
