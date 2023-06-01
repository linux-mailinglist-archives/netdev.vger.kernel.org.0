Return-Path: <netdev+bounces-7190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D90FD71F092
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41A42281782
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD4446FF7;
	Thu,  1 Jun 2023 17:22:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643C84252C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:02 +0000 (UTC)
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581CBB3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-53fb64b3368so605047a12.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640115; x=1688232115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYVY+x2MA+Z15O+ZfNyclLRXKUSIqBWKOHC9+V73ZDc=;
        b=rthupSDB0mFhPo8Og7fGQJ1IoHgxkvbME8b1ug5K5ZfSCqMzClJLC3AOiBNu76F6I2
         E/lrFbqb4C/rDXHuZvtB+gLP80/PPh/qQqVh8t47kLDm3bGtwbx5EaWFvH0n1RsCoro9
         mIKMUHeDyJhSq14bmF2ALkhiOZY9Bn/UMjJtOBiaP4rCu5MS71OmDXUn3O/AP8ejJSnd
         Z4WtnrTHIGi1//JTuQCBKAThvdCdoychcDBSkK9fmJ1pEgbzgQBXW3xFgod2l836Qmm2
         Q195YrBsduMttEvQF5F/DhzrneOVtSiW6RCSFBAqlz+fJvftBoY5X7FvIXw5XPhr9IAv
         5cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640115; x=1688232115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYVY+x2MA+Z15O+ZfNyclLRXKUSIqBWKOHC9+V73ZDc=;
        b=OPgEzxVUMrATy9DamrqruMik4vCjWsmV103A2luZt/A/5KEqjpdKf6XaQinB4khnrS
         830bAv6kRLZ0j45rVjYIRuqbSzcyPiGXgQcNq20kppNW6K4qWTSsnskxzsh8gS9WxRUf
         yuO77s0RQNyDOwYnqCbbio8KIcXZYg2VWkazuDi0GiByMa8V6YNA1vy7rzmvhNZvJVuZ
         l7O6Ih8y3KTFIN20sxhaD0OvMxDvHC0KMfNgJQlSPHBN8OTQYTGO2sPq50aYYu7TGKRM
         JqXCZVwXR1DrwHx284eKE/dJeI9afLw5iCT0XUJGI0fwCgsXMsGU4ouwDz3A45RAdp0H
         QoUQ==
X-Gm-Message-State: AC+VfDzFtr9QaZ391+VL3hGah1iCydANxyVWlDJmoJqh1syIHlSq7CDt
	CQN0ALya/5aHZMJNJXjMLwPicr6B5GPh+yMFvVtqRA==
X-Google-Smtp-Source: ACHHUZ7JsO61Yiq0q//J/+yCE6D6omwpYh/Gzzr127idGYobajbpk4ZxgDgYk2C0zj07jjn62pw7yw==
X-Received: by 2002:a05:6a21:6d84:b0:10c:4ff5:38b7 with SMTP id wl4-20020a056a216d8400b0010c4ff538b7mr8405992pzb.6.1685640115514;
        Thu, 01 Jun 2023 10:21:55 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:54 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/7] utils: make local cmdline functions static
Date: Thu,  1 Jun 2023 10:21:39 -0700
Message-Id: <20230601172145.51357-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601172145.51357-1-stephen@networkplumber.org>
References: <20230601172145.51357-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

No need to expose these parts of command line parsing.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/utils.h | 3 ---
 lib/utils.c     | 6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 0f1b3bef34d8..0b5d86a26488 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -139,7 +139,6 @@ int get_addr_rta(inet_prefix *dst, const struct rtattr *rta, int family);
 int get_addr_ila(__u64 *val, const char *arg);
 
 int read_prop(const char *dev, char *prop, long *value);
-int get_hex(char c);
 int get_integer(int *val, const char *arg, int base);
 int get_unsigned(unsigned *val, const char *arg, int base);
 int get_time_rtt(unsigned *val, const char *arg, int *raw);
@@ -304,8 +303,6 @@ unsigned int print_name_and_link(const char *fmt,
 #define ntohll(x) ((1==ntohl(1)) ? (x) : ((uint64_t)ntohl((x) & 0xFFFFFFFF) << 32) | ntohl((x) >> 32))
 
 extern int cmdlineno;
-ssize_t getcmdline(char **line, size_t *len, FILE *in);
-int makeargs(char *line, char *argv[], int maxargs);
 
 char *int_to_str(int val, char *buf);
 int get_guid(__u64 *guid, const char *arg);
diff --git a/lib/utils.c b/lib/utils.c
index 8dc302bdfe02..01f3a5f7e4ea 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -96,7 +96,7 @@ out:
 	return -1;
 }
 
-int get_hex(char c)
+static int get_hex(char c)
 {
 	if (c >= 'A' && c <= 'F')
 		return c - 'A' + 10;
@@ -1289,7 +1289,7 @@ unsigned int print_name_and_link(const char *fmt,
 int cmdlineno;
 
 /* Like glibc getline but handle continuation lines and comments */
-ssize_t getcmdline(char **linep, size_t *lenp, FILE *in)
+static ssize_t getcmdline(char **linep, size_t *lenp, FILE *in)
 {
 	ssize_t cc;
 	char *cp;
@@ -1336,7 +1336,7 @@ ssize_t getcmdline(char **linep, size_t *lenp, FILE *in)
 }
 
 /* split command line into argument vector */
-int makeargs(char *line, char *argv[], int maxargs)
+static int makeargs(char *line, char *argv[], int maxargs)
 {
 	static const char ws[] = " \t\r\n";
 	char *cp = line;
-- 
2.39.2


