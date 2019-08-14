Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516FD8C5FA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfHNCLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbfHNCLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AFA20989;
        Wed, 14 Aug 2019 02:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748707;
        bh=KbEKVT02qESa8FCLgt3PGP+TDpILOUbdE9UvKXRpwT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeiBoWvwcgYZxEEz5Y2soZcHQWwFHY9LCTlH/8s17z2qCtoK9VKkCEpu7cCIRS7CD
         NHSaMTBKEjDmM+E6fHwuS2eA2VkWLk6Z4fo8OQYeAwZIQldB5ZdhpVsh9EKy24Q4ua
         aIOzOH5sRHBkv1b2kx0jzfoKiFonYmucNmkjuzkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 032/123] selftests: forwarding: gre_multipath: Enable IPv4 forwarding
Date:   Tue, 13 Aug 2019 22:09:16 -0400
Message-Id: <20190814021047.14828-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit efa7b79f675da0efafe3f32ba0d6efe916cf4867 ]

The test did not enable IPv4 forwarding during its setup phase, which
causes the test to fail on machines where IPv4 forwarding is disabled.

Fixes: 54818c4c4b93 ("selftests: forwarding: Test multipath tunneling")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Tested-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/gre_multipath.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath.sh b/tools/testing/selftests/net/forwarding/gre_multipath.sh
index cca2baa03fb81..37d7297e1cf8a 100755
--- a/tools/testing/selftests/net/forwarding/gre_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/gre_multipath.sh
@@ -187,12 +187,16 @@ setup_prepare()
 	sw1_create
 	sw2_create
 	h2_create
+
+	forwarding_enable
 }
 
 cleanup()
 {
 	pre_cleanup
 
+	forwarding_restore
+
 	h2_destroy
 	sw2_destroy
 	sw1_destroy
-- 
2.20.1

