Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0691E41BFE0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbhI2H2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:46 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33118 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbhI2H2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:30 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 04736214E3; Wed, 29 Sep 2021 15:26:49 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 07/10] mctp: Do inits as a subsys_initcall
Date:   Wed, 29 Sep 2021 15:26:11 +0800
Message-Id: <20210929072614.854015-8-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

In a future change, we'll want to provide a registration call for
mctp-specific devices. This requires us to have the networks established
before device driver inits, so run the core init as a subsys_initcall.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/af_mctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 28cb1633bed6..66a411d60b6c 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -435,7 +435,7 @@ static __exit void mctp_exit(void)
 	sock_unregister(PF_MCTP);
 }
 
-module_init(mctp_init);
+subsys_initcall(mctp_init);
 module_exit(mctp_exit);
 
 MODULE_DESCRIPTION("MCTP core");
-- 
2.30.2

