Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12DD404FC6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351250AbhIIMWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348681AbhIIMRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:17:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6904D61279;
        Thu,  9 Sep 2021 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188196;
        bh=qEiAm24eqpsL2TxBMKk2BMy+kt0VnPszMUVXtFF6ej0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpJJoGcYR837gy/TTKeM4siLN6K4mr/BpmcsjkRB17pYeR9ZShmJsej1UfkEMRlQL
         QGggT1z8Q9GW8BORxQTGfrSjVoX5Kg4KJGtuiL15jQaxjd04vsc/gUx4mSyQ1Fd4Hc
         JA3HgWtS6CyTqyJFdrFa0JJAREi9YlwmQ39mA6vVZOah1bLYFoGyp/0bRhcUUK9km9
         6Y++qX7lmeg0ocIDpROs7G1jCmBaZZXAzOwHRIX19EhgnF+rihgplxURLQHKKz0c+o
         H7m/53YbFQ5v3XcfhXd3TFA+xS5TnU+VSzX+YOlO+ki/9pfGZItJv+rLF/zTTnCjf0
         j+HQPOxm/vKyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 155/219] selftests: nci: Fix the wrong condition
Date:   Thu,  9 Sep 2021 07:45:31 -0400
Message-Id: <20210909114635.143983-155-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit 1d5b8d01db98abb8c176838fad73287366874582 ]

memcpy should be executed only in case nla_len's value is greater than 0.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 9687100f15ea..acd4125ff39f 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -110,7 +110,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		na->nla_type = nla_type[cnt];
 		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
 
-		if (nla_len > 0)
+		if (nla_len[cnt] > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
 		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
-- 
2.30.2

