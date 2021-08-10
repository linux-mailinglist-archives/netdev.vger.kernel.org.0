Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9893E5CBE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242250AbhHJOPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242201AbhHJOPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCDD760F02;
        Tue, 10 Aug 2021 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604911;
        bh=l3tXfFxjH3YDOLrwS73W639NpIt4rX6vnRziL3Pjj1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8iotNzmxUWKyimZT4NdHpZUAuqK/mCTQyYrKdgGUmAMYxnyjHb82+JviZ9cyhrwQ
         wn/10Tb2SbfZ+8keWezt1KTvytNZHnVhawmXb6o2oiSySkgAzUKS3pTtB7g7Wb79dw
         r4oMejxeQAUDL9jsH6oh7mSGweKFx8TNnbJR8oqV9EqTup5Tyd9OD1AKGUPQT9plu3
         FZ1P+kDxbJvwuAepsYFITMVbrHWn3ZQjXuGef99cRD/EzjjBYQV5+2xKN9PbAtM1To
         YNWuPteDJk+eAR/E6pgshf2CYPnbxT3Y57311hiZSneXrpwQdNRoG6j765JhEAbU5O
         vDcaEJjrhRRzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/24] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Tue, 10 Aug 2021 10:14:45 -0400
Message-Id: <20210810141505.3117318-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
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
index 2e8afe078d61..cb40ff0ff28d 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -241,7 +241,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
-- 
2.30.2

