Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68006678C91
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjAXAJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjAXAJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:09:05 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6EE045
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 16:09:04 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 51341500084;
        Tue, 24 Jan 2023 03:03:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 51341500084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674518624; bh=JjIBPkj2InWWlEbPQ2ogc3r7XzAT+V1qihIZit83iBg=;
        h=From:To:Cc:Subject:Date:From;
        b=v3lCXmFRMOcrCIFA9QQhjsVksQjCgbCLwM8TWKCsw00wTyQrq7ZXg25LgSnSNPcIU
         yHt7VNKZqWseeS1pNKlj3BZ1Hsr6KnrQnMSqG25AqESYhVk4IPcQwI1vBRyOQQEF/2
         DBFtyZKYS2v7E+zrZM0EQm+Rl3hGBwmsbV/yEUP0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2] mlx5: bugfixes for ptp fifo queue
Date:   Tue, 24 Jan 2023 03:08:34 +0300
Message-Id: <20230124000836.20523-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

Simple FIFO implementation for PTP queue has several bug which lead to
use-after-free and skb leaks. This series fixes the issues and adds new
counters of out-of-order CQEs for this queue.

v1 -> v2:
  Update Fixes tag to proper commit.
  Change debug line to avoid double print of function name

Vadim Fedorenko (2):
  mlx5: fix possible ptp queue fifo overflow
  mlx5: fix skb leak while fifo resync

 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 29 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 4 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.27.0

