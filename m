Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929F74F1AD6
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379235AbiDDVTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379714AbiDDR4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:56:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE5334BB9
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 10:54:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2e9e838590dso88077467b3.5
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kD3wL+jXoZgMtS0viPnco/UYxkyMbtIPzARqoAqPbwY=;
        b=WYo4HNZAwXrwLP0qlAd0FABk6y96oJiOctkOErnmhDQFAekOv4v7chWVr3f3Qh0Q9T
         z4+llx0o/F8GBC5LLGld2hRsUZ0d7d70OML12Z2Gf9ONiXcZ+h7GRzw7lkBOnNJCT8Jd
         D2eTdW04fjZ4NoYfKwg2OvTNQ+JqBoHwp2r6V8EI+3NYn3q6hbIk2lvyg/vAf2UHj74c
         QS6Xw6+Y6NJa1Oc3Jcg5I/3svmOw6OyLTSyWVihA0RA0Sji0kWha3sDRnqlwT6I8bjZQ
         rzHPjsJNeWt5BOXV3ux12mHTGwOyvLdNaYgSko1VHVagAeHgO81rFnVfwhieejciHJ28
         bSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kD3wL+jXoZgMtS0viPnco/UYxkyMbtIPzARqoAqPbwY=;
        b=MpfBlqSd2M8OUgg3TgAQZ/KJrWai5d3YHpSMskv/trMFJWRaUz+LnAmXMezjhAlGC2
         0TbqQf3DBh6etjQumQSaXBOUTy9cvaKVH0PQXXPqwGKRsZ95Afe5PhhElfKczED8XAp7
         VpqUuTii9hejxTi8lkgPRRftwtRB9WnWHEgSnZdgaRs5hlLygJnldlzzvPRZeB3mgZ1z
         qR/bHVnqM8KpiLPaRJtW3BYEk8bDjxwl+YsmM3CFGd8yFAUm/borBbsGsn1f7ciluVrj
         LQ6cij7X6Kz/EXr7lLMu3JPSfnsoLx7w74aUNKbYR3KecbCpWRyjQG/zplVi3olYP5Px
         ULpg==
X-Gm-Message-State: AOAM531Gp1KdUiQu7KW9pN9O3DiLzGacy9Yc0OL9S3bWl8yQ6z4KY6Sy
        FyEe3wVmqN8FNsfX9RHVoOgx7sOerHwCKdfvRJ0=
X-Google-Smtp-Source: ABdhPJxTVi5OZotbfZSehOWa3aQ3MEEZMwR3jw8243Jt0T0zjDz/WMGViBbOCa9jjUde+gYSrzLROK2KV7SsMPWmNTg=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:9d5:9b93:ffb4:574a])
 (user=ndesaulniers job=sendgmr) by 2002:a25:1585:0:b0:63d:de88:5aa6 with SMTP
 id 127-20020a251585000000b0063dde885aa6mr882284ybv.201.1649094892610; Mon, 04
 Apr 2022 10:54:52 -0700 (PDT)
Date:   Mon,  4 Apr 2022 10:54:47 -0700
In-Reply-To: <20220329160137.0708b1ef@kernel.org>
Message-Id: <20220404175448.46200-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20220329160137.0708b1ef@kernel.org>
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1649094887; l=4089;
 s=20211004; h=from:subject; bh=khSjrHk7nW4o9cbWWjQxFTbsHtqXeG+OBf0183HZoTY=;
 b=efrzYgGo+h+jeE0KwRYGDhyUzYY804nMchdq+L44+8D1q0L3AXuRd6BNdlWb1zJz8J0kE30bAyoV
 LUECkyb8AYFVzKTBFw3MxBGTORsUeBNwq9oW3d6c/k29j/bqMMDB
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH net-next v3] net, uapi: remove inclusion of arpa/inet.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In include/uapi/linux/tipc_config.h, there's a comment that it includes
arpa/inet.h for ntohs; but ntohs is not defined in any UAPI header. For
now, reuse the definitions from include/linux/byteorder/generic.h, since
the various conversion functions do exist in UAPI headers:
include/uapi/linux/byteorder/big_endian.h
include/uapi/linux/byteorder/little_endian.h

We would like to get to the point where we can build UAPI header tests
with -nostdinc, meaning that kernel UAPI headers should not have a
circular dependency on libc headers.

Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V2 -> V3:
* Use __be16_to_cpu and friends directly.
* Rebase on net-next now that the merge window is closed.
* Cut down commit message.
Changes V1 -> V2:
* Fix broken patch.

 include/uapi/linux/tipc_config.h | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
index 4dfc05651c98..c00adf2fe868 100644
--- a/include/uapi/linux/tipc_config.h
+++ b/include/uapi/linux/tipc_config.h
@@ -43,10 +43,6 @@
 #include <linux/tipc.h>
 #include <asm/byteorder.h>
 
-#ifndef __KERNEL__
-#include <arpa/inet.h> /* for ntohs etc. */
-#endif
-
 /*
  * Configuration
  *
@@ -269,33 +265,33 @@ static inline int TLV_OK(const void *tlv, __u16 space)
 	 */
 
 	return (space >= TLV_SPACE(0)) &&
-		(ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
+		(__be16_to_cpu(((struct tlv_desc *)tlv)->tlv_len) <= space);
 }
 
 static inline int TLV_CHECK(const void *tlv, __u16 space, __u16 exp_type)
 {
 	return TLV_OK(tlv, space) &&
-		(ntohs(((struct tlv_desc *)tlv)->tlv_type) == exp_type);
+		(__be16_to_cpu(((struct tlv_desc *)tlv)->tlv_type) == exp_type);
 }
 
 static inline int TLV_GET_LEN(struct tlv_desc *tlv)
 {
-	return ntohs(tlv->tlv_len);
+	return __be16_to_cpu(tlv->tlv_len);
 }
 
 static inline void TLV_SET_LEN(struct tlv_desc *tlv, __u16 len)
 {
-	tlv->tlv_len = htons(len);
+	tlv->tlv_len = __cpu_to_be16(len);
 }
 
 static inline int TLV_CHECK_TYPE(struct tlv_desc *tlv,  __u16 type)
 {
-	return (ntohs(tlv->tlv_type) == type);
+	return (__be16_to_cpu(tlv->tlv_type) == type);
 }
 
 static inline void TLV_SET_TYPE(struct tlv_desc *tlv, __u16 type)
 {
-	tlv->tlv_type = htons(type);
+	tlv->tlv_type = __cpu_to_be16(type);
 }
 
 static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
@@ -305,8 +301,8 @@ static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
 
 	tlv_len = TLV_LENGTH(len);
 	tlv_ptr = (struct tlv_desc *)tlv;
-	tlv_ptr->tlv_type = htons(type);
-	tlv_ptr->tlv_len  = htons(tlv_len);
+	tlv_ptr->tlv_type = __cpu_to_be16(type);
+	tlv_ptr->tlv_len  = __cpu_to_be16(tlv_len);
 	if (len && data) {
 		memcpy(TLV_DATA(tlv_ptr), data, len);
 		memset((char *)TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
@@ -348,7 +344,7 @@ static inline void *TLV_LIST_DATA(struct tlv_list_desc *list)
 
 static inline void TLV_LIST_STEP(struct tlv_list_desc *list)
 {
-	__u16 tlv_space = TLV_ALIGN(ntohs(list->tlv_ptr->tlv_len));
+	__u16 tlv_space = TLV_ALIGN(__be16_to_cpu(list->tlv_ptr->tlv_len));
 
 	list->tlv_ptr = (struct tlv_desc *)((char *)list->tlv_ptr + tlv_space);
 	list->tlv_space -= tlv_space;
@@ -404,9 +400,9 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
 
 	msg_len = TCM_LENGTH(data_len);
 	tcm_hdr = (struct tipc_cfg_msg_hdr *)msg;
-	tcm_hdr->tcm_len   = htonl(msg_len);
-	tcm_hdr->tcm_type  = htons(cmd);
-	tcm_hdr->tcm_flags = htons(flags);
+	tcm_hdr->tcm_len   = __cpu_to_be32(msg_len);
+	tcm_hdr->tcm_type  = __cpu_to_be16(cmd);
+	tcm_hdr->tcm_flags = __cpu_to_be16(flags);
 	if (data_len && data) {
 		memcpy(TCM_DATA(msg), data, data_len);
 		memset((char *)TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
-- 
2.35.1.1094.g7c7d902a7c-goog

