Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09BF405651
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359499AbhIINTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358649AbhIINJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35029632C1;
        Thu,  9 Sep 2021 12:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188860;
        bh=3RGwpW3gG0wkrNuOkhj36/Cp/1+U2ZEWQlN+K8Mu9yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1XRpUzO3jBDXOxranjSx4tBqNBOI+alMqRoSgSG9q0AP20//rGPZblSsMDmJJw/K
         3ToTHK1X8uovei4VlKXbCd47srb2+H3jo78/hBN1CBhho1ME6GRGioGOq2rLi10Eli
         62IWDnEWdiujJlViiE44Kd8RmoHdi4IvjjRmimQE+ynNojfFHPrV5v4weASwjySlTf
         /CtS//AmtEmUI5yRxLlCidOr01noaR1qrLI7sZA0kDNf3BH7n5yv8jN4ftKN9wRi1Z
         SodMmGQf9LHcjfo3vU7c32g5miMsu1e7tVh5fRpa35lx5qWTLhYs4BXNBdOQjsaIIw
         n1X4wSkw3YXNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 35/48] rpc: fix gss_svc_init cleanup on failure
Date:   Thu,  9 Sep 2021 08:00:02 -0400
Message-Id: <20210909120015.150411-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 5a4753446253a427c0ff1e433b9c4933e5af207c ]

The failure case here should be rare, but it's obviously wrong.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 85ad23d9a8a9..5a7041c34c7b 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1853,7 +1853,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
-- 
2.30.2

