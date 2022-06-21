Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F286B55383B
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiFUQxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351871AbiFUQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:53:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 886451C92E
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655830404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PqF/8FLIuc0+ykdTcV5mPwQis+SJR4URQzkrPTZhPBg=;
        b=icnAflSaYZ44aN2BZCYtHNng7b4SYUrph6N6BH950knBsLqhA+b0ND/ryepO01H15wwVmB
        KpLi+J4+954KXKYhlReIwWYe5OSzgoRCB1LVHWuJDje95sj10mWrXLhAWrC+jg/3MGKXet
        GihdygyiuQ7xlf0lWhAV0wSLRA95IVw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-8rtpob-nP6OoR3OBIDz2Rg-1; Tue, 21 Jun 2022 12:53:22 -0400
X-MC-Unique: 8rtpob-nP6OoR3OBIDz2Rg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BDB23C0E21D;
        Tue, 21 Jun 2022 16:53:22 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC15E492C3B;
        Tue, 21 Jun 2022 16:53:21 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] l2tp: fix typo in AF_INET6 checksum JSON print
Date:   Tue, 21 Jun 2022 18:53:08 +0200
Message-Id: <0ad5dc13773e29d2e30c9f0911eddeb7d2c751dd.1655830297.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In print_tunnel json output, a typo makes it impossible to know the
value of udp6_csum_rx, printing instead udp6_csum_tx two times.

Fixed getting rid of the typo.

Fixes: 98453b65800f ("ip/l2tp: add JSON support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipl2tp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipl2tp.c b/ip/ipl2tp.c
index 56972358..f1d574de 100644
--- a/ip/ipl2tp.c
+++ b/ip/ipl2tp.c
@@ -258,7 +258,7 @@ static void print_tunnel(const struct l2tp_data *data)
 					   NULL, p->udp6_csum_tx);
 
 				print_bool(PRINT_JSON, "checksum_rx",
-					   NULL, p->udp6_csum_tx);
+					   NULL, p->udp6_csum_rx);
 			} else {
 				printf("  UDP checksum: %s%s%s%s\n",
 				       p->udp6_csum_tx && p->udp6_csum_rx
-- 
2.36.1

