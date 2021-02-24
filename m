Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE09323C9E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhBXMw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235135AbhBXMwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209E264EF5;
        Wed, 24 Feb 2021 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171040;
        bh=iRc0sfwQqAWzjuoYwtBM+4CU33remUOMRZoopuz70dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIgDvq6zUMpqvJcn7OdD+h/ealt7XF8RVfOnFZCC0v0z3CJmuHrl0XObcqdPiEVPd
         HKb89rxCpkRQl/K4PTs//XL6Vf3ixKV4F86zSXoScy/cCUaC2xTya+e8LL76H5g/49
         68ne6nUMzeLaumPrNcuxhd0nR7pbhvdcbxpNBviTEilmLTcsj25xpkFABZ/lGYelef
         m2lSaz+8RJbSqT7VhXmh+Jiq220SdqH+RgqaGZE0FWK2rOHtN0t1wVE4+ocsm5FGhC
         JHsa/iF/ryukzHcQxm8Ef0CJPpNSN9lEMONraNTiX0NSceiRxYkb0zdn/2vQdh9ShQ
         z07PC9BMVr8NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 10/67] selftests/bpf: Remove memory leak
Date:   Wed, 24 Feb 2021 07:49:28 -0500
Message-Id: <20210224125026.481804-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 4896d7e37ea5217d42e210bfcf4d56964044704f ]

The allocated entry is immediately overwritten by an assignment. Fix
that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210122154725.22140-5-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee76b1fc..e7945b6246c82 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -729,7 +729,6 @@ static void worker_pkt_validate(void)
 	u32 payloadseqnum = -2;
 
 	while (1) {
-		pkt_node_rx_q = malloc(sizeof(struct pkt));
 		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
 		if (!pkt_node_rx_q)
 			break;
-- 
2.27.0

