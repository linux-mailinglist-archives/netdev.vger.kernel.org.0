Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B34EB627
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbiC2Wlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237977AbiC2Wlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:41:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E498D232117
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 15:40:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b16-20020a253410000000b00633b9e71eecso14301991yba.14
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 15:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=55JjpPbk3Y7WOpykUyXt7wH1TGQR1/LtZdMUbAvIVMs=;
        b=qX3i/Nw/HqKEYHup8amZuE+i2wPURXKr/5BAcB7jIFF0+msEMixUa3UgLAJ50Se7OV
         uyr1nQ6tC+OzNsJhFFNKJpFlRYQEOdfrdmiIWYryZa9U+Oubgo07ryvepE9B6ETZ1VoG
         UgCgRUKM31ncZtpopbDAkAKfN/EYCNoCtyOncNGFR1OywMDt0C/fRIEKMz658xXY3sXz
         rSCP5IEfR/m1/WpN3EHDf6KpUXvKTWPuCkcrboqxZxIzmtVZ70BVZAu4gwl4Usln/kv1
         nnP/oWRnTdxeamBSk6xxLsmD1wCbX6Qj0YN0PFJL5eqJ/dKthgzcbg5NZVw8Qz3vRyo1
         Fraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=55JjpPbk3Y7WOpykUyXt7wH1TGQR1/LtZdMUbAvIVMs=;
        b=WZpjk5YCRVEztEq44U0Bb1wybrpuLAE7fST3hAI9o+8eKyI011cH9E9Q9uydi2qaXO
         4aDBwhJzRnoIpVMEbfyoT1tX0fY70f8ypiDFPdydmL8MuvO2V9d5qId8CeZbmECejLQH
         xFiISUuKv9bPs3DuLCFWwJdifFbG/I3ULkX8Ojir3K+MB3BP3e9zt1CYRbVf7UYF4eUR
         vefH5rblIr0Y4q/buzC0oh15P1ZpoNcuXpOIgsDpgURd3Nt4RR2QXrt9a8fieATR0SGc
         hjCJwriz5r91eeEAXtbw3QvqowhtMWAB0S0MvtRLo5yQNR4VJLVWuMVPifAG5saAb4Il
         ws+A==
X-Gm-Message-State: AOAM530HAfIA+N+T3YPchuJbpOKqRfPY2AryBPEoKkiop56ADorFsDTG
        uHOoXUuFA/zx5Wdmwe0kI4ALAsavV6sMF/Czxw4=
X-Google-Smtp-Source: ABdhPJySXpfYyG6+zVpTR4IIDEDIftMPbYNbI9MH3Y4DgnMswi8Vyagy7p0fxXZFTK+T6UpIhTF2rkLIX8Tq2/alwxU=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:75a:7c26:987c:fd71])
 (user=ndesaulniers job=sendgmr) by 2002:a25:26c4:0:b0:633:64d4:2b84 with SMTP
 id m187-20020a2526c4000000b0063364d42b84mr29292732ybm.428.1648593600139; Tue,
 29 Mar 2022 15:40:00 -0700 (PDT)
Date:   Tue, 29 Mar 2022 15:39:56 -0700
In-Reply-To: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
Message-Id: <20220329223956.486608-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1648593596; l=4543;
 s=20211004; h=from:subject; bh=5slE50Y/sReDbpFV50LnX2HSeC48C/EwsulabxEX2AY=;
 b=qrVKmwgB+c+z+CeXQOhS6rjRIAZu/2Wrsrlcq7EKGqSdZjeyWxrfJNKXWI3wHnZmJLb/M85Dploc
 41bx/78uD5Tx5oHMxesWB1z9dYo+509XZkUz0pdnf8rnJ9/hmR+r
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2] net, uapi: remove inclusion of arpa/inet.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
from Android's SDK, I encountered an error:

  HDRTEST usr/include/linux/fsi.h
In file included from <built-in>:1:
In file included from ./usr/include/linux/tipc_config.h:46:
prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
error: unknown type name 'in_addr_t'
in_addr_t inet_addr(const char* __s);
^

This is because Bionic has a bug in its inclusion chain. I sent a patch
to fix that, but looking closer at include/uapi/linux/tipc_config.h,
there's a comment that it includes arpa/inet.h for ntohs;
but ntohs is not defined in any UAPI header. For now, reuse the
definitions from include/linux/byteorder/generic.h, since the various
conversion functions do exist in UAPI headers:
include/uapi/linux/byteorder/big_endian.h
include/uapi/linux/byteorder/little_endian.h

Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/uapi/linux/tipc_config.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
index 4dfc05651c98..2c494b7ae008 100644
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
@@ -257,6 +253,10 @@ struct tlv_desc {
 #define TLV_SPACE(datalen) (TLV_ALIGN(TLV_LENGTH(datalen)))
 #define TLV_DATA(tlv) ((void *)((char *)(tlv) + TLV_LENGTH(0)))
 
+#define __htonl(x) __cpu_to_be32(x)
+#define __htons(x) __cpu_to_be16(x)
+#define __ntohs(x) __be16_to_cpu(x)
+
 static inline int TLV_OK(const void *tlv, __u16 space)
 {
 	/*
@@ -269,33 +269,33 @@ static inline int TLV_OK(const void *tlv, __u16 space)
 	 */
 
 	return (space >= TLV_SPACE(0)) &&
-		(ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
+		(__ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
 }
 
 static inline int TLV_CHECK(const void *tlv, __u16 space, __u16 exp_type)
 {
 	return TLV_OK(tlv, space) &&
-		(ntohs(((struct tlv_desc *)tlv)->tlv_type) == exp_type);
+		(__ntohs(((struct tlv_desc *)tlv)->tlv_type) == exp_type);
 }
 
 static inline int TLV_GET_LEN(struct tlv_desc *tlv)
 {
-	return ntohs(tlv->tlv_len);
+	return __ntohs(tlv->tlv_len);
 }
 
 static inline void TLV_SET_LEN(struct tlv_desc *tlv, __u16 len)
 {
-	tlv->tlv_len = htons(len);
+	tlv->tlv_len = __htons(len);
 }
 
 static inline int TLV_CHECK_TYPE(struct tlv_desc *tlv,  __u16 type)
 {
-	return (ntohs(tlv->tlv_type) == type);
+	return (__ntohs(tlv->tlv_type) == type);
 }
 
 static inline void TLV_SET_TYPE(struct tlv_desc *tlv, __u16 type)
 {
-	tlv->tlv_type = htons(type);
+	tlv->tlv_type = __htons(type);
 }
 
 static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
@@ -305,8 +305,8 @@ static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
 
 	tlv_len = TLV_LENGTH(len);
 	tlv_ptr = (struct tlv_desc *)tlv;
-	tlv_ptr->tlv_type = htons(type);
-	tlv_ptr->tlv_len  = htons(tlv_len);
+	tlv_ptr->tlv_type = __htons(type);
+	tlv_ptr->tlv_len  = __htons(tlv_len);
 	if (len && data) {
 		memcpy(TLV_DATA(tlv_ptr), data, len);
 		memset((char *)TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
@@ -348,7 +348,7 @@ static inline void *TLV_LIST_DATA(struct tlv_list_desc *list)
 
 static inline void TLV_LIST_STEP(struct tlv_list_desc *list)
 {
-	__u16 tlv_space = TLV_ALIGN(ntohs(list->tlv_ptr->tlv_len));
+	__u16 tlv_space = TLV_ALIGN(__ntohs(list->tlv_ptr->tlv_len));
 
 	list->tlv_ptr = (struct tlv_desc *)((char *)list->tlv_ptr + tlv_space);
 	list->tlv_space -= tlv_space;
@@ -404,9 +404,9 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
 
 	msg_len = TCM_LENGTH(data_len);
 	tcm_hdr = (struct tipc_cfg_msg_hdr *)msg;
-	tcm_hdr->tcm_len   = htonl(msg_len);
-	tcm_hdr->tcm_type  = htons(cmd);
-	tcm_hdr->tcm_flags = htons(flags);
+	tcm_hdr->tcm_len   = __htonl(msg_len);
+	tcm_hdr->tcm_type  = __htons(cmd);
+	tcm_hdr->tcm_flags = __htons(flags);
 	if (data_len && data) {
 		memcpy(TCM_DATA(msg), data, data_len);
 		memset((char *)TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);

base-commit: 5efabdadcf4a5b9a37847ecc85ba71cf2eff0fcf
-- 
2.35.1.1021.g381101b075-goog

