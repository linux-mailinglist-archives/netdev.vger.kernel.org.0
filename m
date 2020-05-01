Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE0D1C0FF3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgEAIrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgEAIri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA63C035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:38 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t7so3467363plr.0
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NuXkYasNKdE8gXAViAwS/O7ZbHUpG4zZKK3dPqbMz2I=;
        b=FO6JpogQe7nNm9gBk6o03uSbnAlu/InR64PuWfkwjTZ5MbVCd2ZZiW9d3f4f8hMsaT
         HHEmwv5uwfHIpmCAp1d2UA+7kjGarMvdonbG4Ve0/Yug+26QWXRUpZmiCRwJp+si4+T3
         KsaNIKC1unrGYEsGDs4wKJAZTaMgc+y2w/YwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuXkYasNKdE8gXAViAwS/O7ZbHUpG4zZKK3dPqbMz2I=;
        b=QDgjvtZFVZ5W2jcrZlc+0B+S3BLeYtehIOD60LV8rZpTkT+AGACBu+JEmdDkiYZIv0
         FtgnWcT5Qfu+UPRj2dUUCikyKr0Yd/BJcKIWZwvSyTrZZEcuzv8N1mbeA5jgu4t6ZDlu
         dBL0b4ATlflrBo67gXN3SUeyRoXC/pdbkmNNSeaEsFp8Tf9V4ai/i5BRpkYE0zwcjUKz
         dWGPfFGL/E5hf4yyIRmHz1e3fHS4XJMo+5YDLv4eRjaQxFjjtTupCYniu1ZvbXviW3kc
         FTbdv9+YoQ+EgmSH2koD4Y0fZqVmBj7KNeYQgZvYONwlBM7ExX0nOkspMobQo8pRW1nx
         fRCw==
X-Gm-Message-State: AGi0Pua6GmK4AzhUCCN7YoL94jdAymf4FjKLfBB2SaaP2PngaPquxBXA
        r1iL3PiWj0wslRStiBYFiNrlzfaQ8aQ=
X-Google-Smtp-Source: APiQypJUJPCEe9fVYonkr5qvNlo+QkyP0lCNOQo+gFka6w0QMzVjrQbLx7mMn2HJpySRi57xDhGdSw==
X-Received: by 2002:a17:90a:3b0c:: with SMTP id d12mr3532067pjc.78.1588322857939;
        Fri, 01 May 2020 01:47:37 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:37 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 4/6] json_print: Return number of characters printed
Date:   Fri,  1 May 2020 17:47:18 +0900
Message-Id: <20200501084720.138421-5-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When outputting in normal mode, forward the return value from
color_fprintf().

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 include/json_print.h | 24 ++++++-----
 lib/json_print.c     | 95 +++++++++++++++++++++++++++-----------------
 2 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 34444793..50e71de4 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -44,20 +44,24 @@ void close_json_array(enum output_type type, const char *delim);
 void print_nl(void);
 
 #define _PRINT_FUNC(type_name, type)					\
-	void print_color_##type_name(enum output_type t,		\
-				     enum color_attr color,		\
-				     const char *key,			\
-				     const char *fmt,			\
-				     type value);			\
+	int print_color_##type_name(enum output_type t,			\
+				    enum color_attr color,		\
+				    const char *key,			\
+				    const char *fmt,			\
+				    type value);			\
 									\
-	static inline void print_##type_name(enum output_type t,	\
-					     const char *key,		\
-					     const char *fmt,		\
-					     type value)		\
+	static inline int print_##type_name(enum output_type t,		\
+					    const char *key,		\
+					    const char *fmt,		\
+					    type value)			\
 	{								\
-		print_color_##type_name(t, COLOR_NONE, key, fmt, value);	\
+		return print_color_##type_name(t, COLOR_NONE, key, fmt,	\
+					       value);			\
 	}
 
+/* These functions return 0 if printing to a JSON context, number of
+ * characters printed otherwise (as calculated by printf(3)).
+ */
 _PRINT_FUNC(int, int)
 _PRINT_FUNC(s64, int64_t)
 _PRINT_FUNC(bool, bool)
diff --git a/lib/json_print.c b/lib/json_print.c
index 8e7f32dc..fe0705bf 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -123,20 +123,22 @@ void close_json_array(enum output_type type, const char *str)
  */
 #define _PRINT_FUNC(type_name, type)					\
 	__attribute__((format(printf, 4, 0)))				\
-	void print_color_##type_name(enum output_type t,		\
-				     enum color_attr color,		\
-				     const char *key,			\
-				     const char *fmt,			\
-				     type value)			\
+	int print_color_##type_name(enum output_type t,			\
+				    enum color_attr color,		\
+				    const char *key,			\
+				    const char *fmt,			\
+				    type value)				\
 	{								\
+		int ret = 0;						\
 		if (_IS_JSON_CONTEXT(t)) {				\
 			if (!key)					\
 				jsonw_##type_name(_jw, value);		\
 			else						\
 				jsonw_##type_name##_field(_jw, key, value); \
 		} else if (_IS_FP_CONTEXT(t)) {				\
-			color_fprintf(stdout, color, fmt, value);          \
+			ret = color_fprintf(stdout, color, fmt, value); \
 		}							\
+		return ret;						\
 	}
 _PRINT_FUNC(int, int);
 _PRINT_FUNC(s64, int64_t);
@@ -162,12 +164,14 @@ _PRINT_NAME_VALUE_FUNC(uint, unsigned int, u);
 _PRINT_NAME_VALUE_FUNC(string, const char*, s);
 #undef _PRINT_NAME_VALUE_FUNC
 
-void print_color_string(enum output_type type,
-			enum color_attr color,
-			const char *key,
-			const char *fmt,
-			const char *value)
+int print_color_string(enum output_type type,
+		       enum color_attr color,
+		       const char *key,
+		       const char *fmt,
+		       const char *value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key && !value)
 			jsonw_name(_jw, key);
@@ -176,8 +180,10 @@ void print_color_string(enum output_type type,
 		else
 			jsonw_string_field(_jw, key, value);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value);
+		ret = color_fprintf(stdout, color, fmt, value);
 	}
+
+	return ret;
 }
 
 /*
@@ -185,47 +191,58 @@ void print_color_string(enum output_type type,
  * a value to it, you will need to use "is_json_context()" to have different
  * branch for json and regular output. grep -r "print_bool" for example
  */
-void print_color_bool(enum output_type type,
-		      enum color_attr color,
-		      const char *key,
-		      const char *fmt,
-		      bool value)
+int print_color_bool(enum output_type type,
+		     enum color_attr color,
+		     const char *key,
+		     const char *fmt,
+		     bool value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key)
 			jsonw_bool_field(_jw, key, value);
 		else
 			jsonw_bool(_jw, value);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value ? "true" : "false");
+		ret = color_fprintf(stdout, color, fmt,
+				    value ? "true" : "false");
 	}
+
+	return ret;
 }
 
 /*
  * In JSON context uses hardcode %#x format: 42 -> 0x2a
  */
-void print_color_0xhex(enum output_type type,
-		       enum color_attr color,
-		       const char *key,
-		       const char *fmt,
-		       unsigned long long hex)
+int print_color_0xhex(enum output_type type,
+		      enum color_attr color,
+		      const char *key,
+		      const char *fmt,
+		      unsigned long long hex)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		SPRINT_BUF(b1);
 
 		snprintf(b1, sizeof(b1), "%#llx", hex);
 		print_string(PRINT_JSON, key, NULL, b1);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, hex);
+		ret = color_fprintf(stdout, color, fmt, hex);
 	}
+
+	return ret;
 }
 
-void print_color_hex(enum output_type type,
-		     enum color_attr color,
-		     const char *key,
-		     const char *fmt,
-		     unsigned int hex)
+int print_color_hex(enum output_type type,
+		    enum color_attr color,
+		    const char *key,
+		    const char *fmt,
+		    unsigned int hex)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		SPRINT_BUF(b1);
 
@@ -235,28 +252,34 @@ void print_color_hex(enum output_type type,
 		else
 			jsonw_string(_jw, b1);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, hex);
+		ret = color_fprintf(stdout, color, fmt, hex);
 	}
+
+	return ret;
 }
 
 /*
  * In JSON context we don't use the argument "value" we simply call jsonw_null
  * whereas FP context can use "value" to output anything
  */
-void print_color_null(enum output_type type,
-		      enum color_attr color,
-		      const char *key,
-		      const char *fmt,
-		      const char *value)
+int print_color_null(enum output_type type,
+		     enum color_attr color,
+		     const char *key,
+		     const char *fmt,
+		     const char *value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key)
 			jsonw_null_field(_jw, key);
 		else
 			jsonw_null(_jw);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value);
+		ret = color_fprintf(stdout, color, fmt, value);
 	}
+
+	return ret;
 }
 
 /* Print line separator (if not in JSON mode) */
-- 
2.26.0

