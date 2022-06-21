Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AB055384A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiFUQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiFUQ7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A73F1F2EE
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655830756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YCgohv6YKpP79Fb/LAmxKfSz4BrbHijkGAU+wCajKM4=;
        b=XE6EkymxfU7N4KMKZzLZ/Xg+vPMdkCiZEyxPFNnxqCgJLf18Ah2XoBXp8BO2vnuORVsAV6
        H15RmCtCfOeY5R/IdnsK7k04/1lnMt/+53ghIfvGgl4lyCdkBPT6ej0InnSB17Ti3U3CKV
        7DjSAZpWGku//sPESOlXkvLxUmBiimY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-oBMNP4SxPB6Rh-CnDdL4dA-1; Tue, 21 Jun 2022 12:59:13 -0400
X-MC-Unique: oBMNP4SxPB6Rh-CnDdL4dA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F8EC811E76;
        Tue, 21 Jun 2022 16:59:12 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9052166B29;
        Tue, 21 Jun 2022 16:59:11 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, paulb@nvidia.com
Subject: [PATCH iproute2] man: tc-ct.8: fix example
Date:   Tue, 21 Jun 2022 18:59:06 +0200
Message-Id: <5dce1b939c42a170fdd7697ee8e2699a7d5f7b24.1655830634.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc-ct manpage provides a wrong command to add an ingress qdisc to an
interface:

$ tc qdisc add dev eth0 handle ingress
Error: argument "ingress" is wrong: invalid qdisc ID

Fix it removing the useless "handle" keyword.

Fixes: 924c43778a84 ("man: tc-ct.8: Add manual page for ct tc action")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/tc-ct.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
index 709e62a9..2fb81ca2 100644
--- a/man/man8/tc-ct.8
+++ b/man/man8/tc-ct.8
@@ -74,8 +74,8 @@ Example showing natted firewall in conntrack zone 2, and conntrack mark usage:
 
 #Add ingress qdisc on eth0 and eth1 interfaces
 .nf
-$ tc qdisc add dev eth0 handle ingress
-$ tc qdisc add dev eth1 handle ingress
+$ tc qdisc add dev eth0 ingress
+$ tc qdisc add dev eth1 ingress
 
 #Setup filters on eth0, allowing opening new connections in zone 2, and doing src nat + mark for each new connection
 $ tc filter add dev eth0 ingress prio 1 chain 0 proto ip flower ip_proto tcp ct_state -trk \\
-- 
2.36.1

