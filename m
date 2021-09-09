Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD9F404C67
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbhIIL4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244419AbhIILyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F15B61373;
        Thu,  9 Sep 2021 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187894;
        bh=qEiAm24eqpsL2TxBMKk2BMy+kt0VnPszMUVXtFF6ej0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlzDDyY5W5A5A5QonZQBrnWtY8lHth2qvYoWgaxDM6aRSRpTn2aye+yslonLob0aJ
         q+lDKElQX6sZkHDwwoKkkx9j1q40l9u8Q+OCb/FS5L0aXE69a5XRvwBDw6rmXm7U+S
         Jw/9GsIhMDkIQDmeHjoE8KeW9Jl3Xz2cDBZaaYp8LgDbx5VWqHmowvrEo93x7mTOoW
         f+ac6fYmY2fB2AiFlcJQyWkZKPdgstf6cRmOBAhXnBrDXsgD8xi/9ql9HDmMzc472P
         RVq2e2fpqECYtETxiLBSWXWf2JHIUwpIfPd4borgw0MAqaziJyFeQF7N351+HZI4eT
         TZTV8STUkGFFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 175/252] selftests: nci: Fix the wrong condition
Date:   Thu,  9 Sep 2021 07:39:49 -0400
Message-Id: <20210909114106.141462-175-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

