Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49B715A33
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfEGFnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbfEGFnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:43:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05AA206A3;
        Tue,  7 May 2019 05:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207788;
        bh=qVtoMk06NoobzEni3vifw0l/ypgB/K+JtUqLcthkzg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve3S3jRwQU3eBYvi5U8cQItx92jHZL/VXgABcKI5Ogdhj5gXrdCLjg9mFnMnuRS5F
         d6wmkwng/Il3fHHpzbkvodVmIFZnXEUppLp9/zRHUKxBFJsAxNdD0ol/kxn4auKcSn
         ObZoOSB+iyOBiAYk7nwcCbkBXnHOFpjrydFSKbPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 09/10] selftests/net: correct the return value for run_netsocktests
Date:   Tue,  7 May 2019 01:42:45 -0400
Message-Id: <20190507054247.537-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507054247.537-1-sashal@kernel.org>
References: <20190507054247.537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 30c04d796b693e22405c38e9b78e9a364e4c77e6 ]

The run_netsocktests will be marked as passed regardless the actual test
result from the ./socket:

    selftests: net: run_netsocktests
    ========================================
    --------------------
    running socket test
    --------------------
    [FAIL]
    ok 1..6 selftests: net: run_netsocktests [PASS]

This is because the test script itself has been successfully executed.
Fix this by exit 1 when the test failed.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/run_netsocktests | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/run_netsocktests b/tools/testing/selftests/net/run_netsocktests
index c09a682df56a..19486dab2379 100644
--- a/tools/testing/selftests/net/run_netsocktests
+++ b/tools/testing/selftests/net/run_netsocktests
@@ -6,7 +6,7 @@ echo "--------------------"
 ./socket
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exit 1
 else
 	echo "[PASS]"
 fi
-
-- 
2.20.1

