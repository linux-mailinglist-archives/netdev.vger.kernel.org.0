Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B8749D254
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiAZTLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiAZTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A348C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B5F616C5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7FC340EB;
        Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224276;
        bh=G4fQW91DBojhAMi/KsD2FcgjjmZpSkt6H0YH6cJyTmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nr80BLxxz8Mphoy0vqlzreHDNPCL5clFP2xNGiOudBbUxf8cbd4utMKeK87RbiEVd
         gv3o89e8NYLrZMIV/J/jZxP0ijC1B8A2TmeSnh4gSfPO4JVShXssVq6w0Sbx+N36So
         9CYAhCjDGq0jOsx6jtxjaaxCKjVgtLhUphc2gclNwx+uDgnbEYu1ZCoK71MhYzdWEN
         CdJU+GJi8Ost+HzML93whbm/q/Zb0+zVo4CSjEJK8AHxw5lSAqR0f9zHvayKEGclDX
         LQ5e2C3YXb4wl2ceYCieL8bxY+ojYMGQe+BznCtkdww19X8S+jZCliYTqMfXMAjkZf
         Y/+aB3B1KbvZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 08/15] ipv6: remove inet6_rsk() and tcp_twsk_ipv6only()
Date:   Wed, 26 Jan 2022 11:11:02 -0800
Message-Id: <20220126191109.2822706-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stubs under !CONFIG_IPV6 were missed when real functions
got deleted ca. v3.13.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: dsahern@kernel.org
CC: justin.iurman@uliege.be
---
 include/linux/ipv6.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index a59d25f19385..1e0f8a31f3de 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -371,19 +371,12 @@ static inline struct ipv6_pinfo * inet6_sk(const struct sock *__sk)
 	return NULL;
 }
 
-static inline struct inet6_request_sock *
-			inet6_rsk(const struct request_sock *rsk)
-{
-	return NULL;
-}
-
 static inline struct raw6_sock *raw6_sk(const struct sock *sk)
 {
 	return NULL;
 }
 
 #define inet6_rcv_saddr(__sk)	NULL
-#define tcp_twsk_ipv6only(__sk)		0
 #define inet_v6_ipv6only(__sk)		0
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 #endif /* _IPV6_H */
-- 
2.34.1

