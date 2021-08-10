Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C463E5CFC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbhHJOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242490AbhHJOQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F063610A4;
        Tue, 10 Aug 2021 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604944;
        bh=iD9D/k5aNOEcdSZegmyuiigYvh4NINWH+mB9toJlgiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oru6hWTAM+gaYYbgkmtvAxoDMB3brMgrKrQ3/qugXJsHEjQv/ta31Gy+m41ssQ5ad
         lP1Ivfa+yvkFfqwHWQKs5TnBQ5PFWusQbH64Y51LS/0gD7nJ7sho5iGugf/61jJk+r
         4toVIQcYZQIKU54YsNd2VFlCbnE6AU1qbtV3PCIrjLRLLCQcccnanIwiCbmbPyPl9r
         J6iOlRnmawwwp0GJ+VLeJccRX7YsqSvNvtYMGmbjN6SB65H8cFEA48CA0hzdGUtV93
         02nnMl3GG9hCRcoFe0G/V17GYCsQNZtLUxBCx41SnAALeopoy6KZNrkzwsId+/I8+R
         u7R44kqdQh27w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/20] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Tue, 10 Aug 2021 10:15:22 -0400
Message-Id: <20210810141538.3117707-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit 480e93e12aa04d857f7cc2e6fcec181c0d690404 ]

The list_for_each_entry() iterator, "pos" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_ipcomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 4d422447aadc..0814320472f1 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -250,7 +250,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
-- 
2.30.2

