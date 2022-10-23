Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0C6094C9
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 18:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiJWQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 12:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJWQlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 12:41:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9439C13E81
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 09:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666543280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MFKZ48m37/6gVpp6y3kFZj9Q0aKkRUmdq2r+fTNgINs=;
        b=BIE1xgByUkozXqQRUZ9IRGO30c16+KL5LN5zdmbIxiBsi8DhhYrEYVkMIB72SY/xoCqOrr
        EkHaVwHbAW/o7+Qdot5md7FTbxDJO23Mx0wWqchE6+C6qwGKNxwNNwNt3HS7nFRv6qDccB
        kR38yw91IX7cxyfv4g4cPw8g7yI+CAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-QDyxCafpP2id1-3N-0dHbg-1; Sun, 23 Oct 2022 12:41:18 -0400
X-MC-Unique: QDyxCafpP2id1-3N-0dHbg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72D08811E67;
        Sun, 23 Oct 2022 16:41:18 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFBF8140EBF3;
        Sun, 23 Oct 2022 16:41:16 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next] genl: remove unused vars in Makefile
Date:   Sun, 23 Oct 2022 18:41:01 +0200
Message-Id: <a5fd2030a1e4051f9cadaee20ab95b29bdd52662.1666543197.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both GENLLIB and LIBUTIL are not used in genl Makefile, let's get rid of
them.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 genl/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/genl/Makefile b/genl/Makefile
index 2b7a45b6..0bd27ff6 100644
--- a/genl/Makefile
+++ b/genl/Makefile
@@ -11,8 +11,6 @@ GENLMODULES += ctrl.o
 
 GENLOBJ += $(GENLMODULES)
 
-GENLLIB :=
-
 ifeq ($(SHARED_LIBS),y)
 LDFLAGS += -Wl,-export-dynamic
 LDLIBS  += -lm -ldl
@@ -20,14 +18,14 @@ endif
 
 all: genl
 
-genl: $(GENLOBJ) $(LIBNETLINK) $(LIBUTIL) $(GENLLIB)
+genl: $(GENLOBJ) $(LIBNETLINK)
 	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@
 
 install: all
 	install -m 0755 genl $(DESTDIR)$(SBINDIR)
 
 clean:
-	rm -f $(GENLOBJ) $(GENLLIB) genl
+	rm -f $(GENLOBJ) genl
 
 ifneq ($(SHARED_LIBS),y)
 
-- 
2.37.3

