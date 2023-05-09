Return-Path: <netdev+bounces-1265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 762546FD161
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27345280EC9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AE319934;
	Tue,  9 May 2023 21:24:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A5A16427
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:24:08 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114310A1D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:23:48 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-64115eef620so45606222b3a.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667291; x=1686259291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qyY9vSMxUyGRonOCTI8WhaWai7ZHTiWjUcLExZFkG0=;
        b=H1hastndYW8J9JI09S6LwY8EKAx2GSoJCl29yBNEOnGVCoRGWxYTN2RFFtKwTF7OSN
         cVnLfVyqUbYUrcYGuPSsJXZqO87EV3jlosDwJrb9m+bZGm1ANS36fbeAgFJD36/NF0ZR
         RPZ/U66aWye9KIGDywUGVJ4xaWTjwHtiCs/ztiUwYecxHsRtrEijpCVfiazWqzrWGH0r
         3U8mI3NTvMnuGFeAAH0X/ZeTYf3xrZBHoXF2MynCbjTkMoTnrQC5c+hV8TKdtQ24up/a
         GScXrhMdAnpTNfF1JFCGp6DN2q+UX5XrUhdtsaMyVABEZfyRg8/ZwjyJD8301dK7S094
         e8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667291; x=1686259291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qyY9vSMxUyGRonOCTI8WhaWai7ZHTiWjUcLExZFkG0=;
        b=QKn5Z6Q9m2PT3ucJi0U0IgIzZDzcZcK9qQafKi5CuHuvNkzRbF3igOW4BiRtOBqOhQ
         5BBG20micV1tYxFi2ApSr7XCDYRLsmMukirQ37YoE471UO8IHUGdDlf2HHipJPd8oXCD
         3rsA2CILrB6jx5UbAF36KS+LF10zF5D61/tzrvzyPqPjaD+8YwB16gWiiappW2K834tx
         qNKR9a+EpYg139SfOorNaGcrNpkxUktrb6nMNa3wXrQDhgaRn03x8da2YpbPI2oEZ5qd
         iqOnPooy3VKvM9q7P0iAQcQYIvxhKq2lCYBjW0YTy8tiZDig740bZzcBiyqNrGwXFq5s
         2kwQ==
X-Gm-Message-State: AC+VfDyJgvXJVSy+Wz38nin40rQv1XWspbDySz0jfD5foCG8c8yx68LA
	fusMWaA5xTrnYhBQpnJQbK8Zz5KRxssF6mPhLjidQQ==
X-Google-Smtp-Source: ACHHUZ4wBdbrcLdzfxcdnB8CwRf931S+Nt3COFqYDJ3MRNvQ+AjM/Be18jrU1wkEoISDJhbhe0K/3w==
X-Received: by 2002:a05:6a00:298e:b0:63c:b3be:9784 with SMTP id cj14-20020a056a00298e00b0063cb3be9784mr22294384pfb.3.1683667291174;
        Tue, 09 May 2023 14:21:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:30 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 02/11] ipmaddr: fix dereference of NULL on malloc() failure
Date: Tue,  9 May 2023 14:21:16 -0700
Message-Id: <20230509212125.15880-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509212125.15880-1-stephen@networkplumber.org>
References: <20230509212125.15880-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Found by -fanalyzer. This is a bug since beginning of initial
versions of ip multicast support (pre git).

ipmaddr.c: In function ‘read_dev_mcast’:
ipmaddr.c:105:25: warning: dereference of possibly-NULL ‘ma’ [CWE-690] [-Wanalyzer-possible-null-dereference]
  105 |                         memcpy(ma, &m, sizeof(m));
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  ‘do_multiaddr’: events 1-4
    |
    |  354 | int do_multiaddr(int argc, char **argv)
    |      |     ^~~~~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_multiaddr’
    |  355 | {
    |  356 |         if (argc < 1)
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch (when ‘argc <= 0’)...
    |  357 |                 return multiaddr_list(0, NULL);
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (3) ...to here
    |      |                        (4) calling ‘multiaddr_list’ from ‘do_multiaddr’
    |
    +--> ‘multiaddr_list’: events 5-10
           |
           |  255 | static int multiaddr_list(int argc, char **argv)
           |      |            ^~~~~~~~~~~~~~
           |      |            |
           |      |            (5) entry to ‘multiaddr_list’
           |......
           |  262 |         while (argc > 0) {
           |      |                ~~~~~~~~
           |      |                     |
           |      |                     (6) following ‘false’ branch (when ‘argc <= 0’)...
           |......
           |  275 |         if (!filter.family || filter.family == AF_PACKET)
           |      |            ~ ~~~~~~~~~~~~~
           |      |            |       |
           |      |            |       (7) ...to here
           |      |            (8) following ‘true’ branch...
           |  276 |                 read_dev_mcast(&list);
           |      |                 ~~~~~~~~~~~~~~~~~~~~~
           |      |                 |
           |      |                 (9) ...to here
           |      |                 (10) calling ‘read_dev_mcast’ from ‘multiaddr_list’
           |
           +--> ‘read_dev_mcast’: events 11-12
                  |
                  |   82 | static void read_dev_mcast(struct ma_info **result_p)
                  |      |             ^~~~~~~~~~~~~~
                  |      |             |
                  |      |             (11) entry to ‘read_dev_mcast’
                  |......
                  |   87 |         if (!fp)
                  |      |            ~
                  |      |            |
                  |      |            (12) following ‘false’ branch (when ‘fp’ is non-NULL)...
                  |
                ‘read_dev_mcast’: event 13
                  |
                  |cc1:
                  | (13): ...to here
                  |
                ‘read_dev_mcast’: events 14-17
                  |
                  |   90 |         while (fgets(buf, sizeof(buf), fp)) {
                  |      |                ^~~~~
                  |      |                |
                  |      |                (14) following ‘true’ branch...
                  |   91 |                 char hexa[256];
                  |   92 |                 struct ma_info m = { .addr.family = AF_PACKET };
                  |      |                                ~
                  |      |                                |
                  |      |                                (15) ...to here
                  |......
                  |  103 |                         struct ma_info *ma = malloc(sizeof(m));
                  |      |                                              ~~~~~~~~~~~~~~~~~
                  |      |                                              |
                  |      |                                              (16) this call could return NULL
                  |  104 |
                  |  105 |                         memcpy(ma, &m, sizeof(m));
                  |      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                         |
                  |      |                         (17) ‘ma’ could be NULL: unchecked value from (16)
                  |
ipmaddr.c: In function ‘read_igmp’:
ipmaddr.c:152:17: warning: dereference of possibly-NULL ‘ma’ [CWE-690] [-Wanalyzer-possible-null-dereference]
  152 |                 memcpy(ma, &m, sizeof(m));
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
  ‘do_multiaddr’: events 1-4
    |
    |  354 | int do_multiaddr(int argc, char **argv)
    |      |     ^~~~~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_multiaddr’
    |  355 | {
    |  356 |         if (argc < 1)
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch (when ‘argc <= 0’)...
    |  357 |                 return multiaddr_list(0, NULL);
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (3) ...to here
    |      |                        (4) calling ‘multiaddr_list’ from ‘do_multiaddr’
    |
    +--> ‘multiaddr_list’: events 5-10
           |
           |  255 | static int multiaddr_list(int argc, char **argv)
           |      |            ^~~~~~~~~~~~~~
           |      |            |
           |      |            (5) entry to ‘multiaddr_list’
           |......
           |  262 |         while (argc > 0) {
           |      |                ~~~~~~~~
           |      |                     |
           |      |                     (6) following ‘false’ branch (when ‘argc <= 0’)...
           |......
           |  275 |         if (!filter.family || filter.family == AF_PACKET)
           |      |              ~~~~~~~~~~~~~
           |      |                    |
           |      |                    (7) ...to here
           |  276 |                 read_dev_mcast(&list);
           |  277 |         if (!filter.family || filter.family == AF_INET)
           |      |            ~
           |      |            |
           |      |            (8) following ‘true’ branch...
           |  278 |                 read_igmp(&list);
           |      |                 ~~~~~~~~~~~~~~~~
           |      |                 |
           |      |                 (9) ...to here
           |      |                 (10) calling ‘read_igmp’ from ‘multiaddr_list’
           |
           +--> ‘read_igmp’: events 11-14
                  |
                  |  116 | static void read_igmp(struct ma_info **result_p)
                  |      |             ^~~~~~~~~
                  |      |             |
                  |      |             (11) entry to ‘read_igmp’
                  |......
                  |  126 |         if (!fp)
                  |      |            ~
                  |      |            |
                  |      |            (12) following ‘false’ branch (when ‘fp’ is non-NULL)...
                  |  127 |                 return;
                  |  128 |         if (!fgets(buf, sizeof(buf), fp)) {
                  |      |            ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |            | |
                  |      |            | (13) ...to here
                  |      |            (14) following ‘false’ branch...
                  |
                ‘read_igmp’: event 15
                  |
                  |cc1:
                  | (15): ...to here
                  |
                ‘read_igmp’: events 16-19
                  |
                  |  133 |         while (fgets(buf, sizeof(buf), fp)) {
                  |      |                ^~~~~
                  |      |                |
                  |      |                (16) following ‘true’ branch...
                  |......
                  |  136 |                 if (buf[0] != '\t') {
                  |      |                     ~~~~~~
                  |      |                        |
                  |      |                        (17) ...to here
                  |......
                  |  151 |                 ma = malloc(sizeof(m));
                  |      |                      ~~~~~~~~~~~~~~~~~
                  |      |                      |
                  |      |                      (18) this call could return NULL
                  |  152 |                 memcpy(ma, &m, sizeof(m));
                  |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                 |
                  |      |                 (19) ‘ma’ could be NULL: unchecked value from (18)
                  |
ipmaddr.c: In function ‘read_igmp6’:
ipmaddr.c:181:25: warning: dereference of possibly-NULL ‘ma’ [CWE-690] [-Wanalyzer-possible-null-dereference]
  181 |                         memcpy(ma, &m, sizeof(m));
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  ‘do_multiaddr’: events 1-4
    |
    |  354 | int do_multiaddr(int argc, char **argv)
    |      |     ^~~~~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_multiaddr’
    |  355 | {
    |  356 |         if (argc < 1)
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch (when ‘argc <= 0’)...
    |  357 |                 return multiaddr_list(0, NULL);
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (3) ...to here
    |      |                        (4) calling ‘multiaddr_list’ from ‘do_multiaddr’
    |
    +--> ‘multiaddr_list’: events 5-10
           |
           |  255 | static int multiaddr_list(int argc, char **argv)
           |      |            ^~~~~~~~~~~~~~
           |      |            |
           |      |            (5) entry to ‘multiaddr_list’
           |......
           |  262 |         while (argc > 0) {
           |      |                ~~~~~~~~
           |      |                     |
           |      |                     (6) following ‘false’ branch (when ‘argc <= 0’)...
           |......
           |  275 |         if (!filter.family || filter.family == AF_PACKET)
           |      |              ~~~~~~~~~~~~~
           |      |                    |
           |      |                    (7) ...to here
           |......
           |  279 |         if (!filter.family || filter.family == AF_INET6)
           |      |            ~
           |      |            |
           |      |            (8) following ‘true’ branch...
           |  280 |                 read_igmp6(&list);
           |      |                 ~~~~~~~~~~~~~~~~~
           |      |                 |
           |      |                 (9) ...to here
           |      |                 (10) calling ‘read_igmp6’ from ‘multiaddr_list’
           |
           +--> ‘read_igmp6’: events 11-12
                  |
                  |  159 | static void read_igmp6(struct ma_info **result_p)
                  |      |             ^~~~~~~~~~
                  |      |             |
                  |      |             (11) entry to ‘read_igmp6’
                  |......
                  |  164 |         if (!fp)
                  |      |            ~
                  |      |            |
                  |      |            (12) following ‘false’ branch (when ‘fp’ is non-NULL)...
                  |
                ‘read_igmp6’: event 13
                  |
                  |cc1:
                  | (13): ...to here
                  |
                ‘read_igmp6’: events 14-17
                  |
                  |  167 |         while (fgets(buf, sizeof(buf), fp)) {
                  |      |                ^~~~~
                  |      |                |
                  |      |                (14) following ‘true’ branch...
                  |  168 |                 char hexa[256];
                  |  169 |                 struct ma_info m = { .addr.family = AF_INET6 };
                  |      |                                ~
                  |      |                                |
                  |      |                                (15) ...to here
                  |......
                  |  179 |                         struct ma_info *ma = malloc(sizeof(m));
                  |      |                                              ~~~~~~~~~~~~~~~~~
                  |      |                                              |
                  |      |                                              (16) this call could return NULL
                  |  180 |
                  |  181 |                         memcpy(ma, &m, sizeof(m));
                  |      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                         |
                  |      |                         (17) ‘ma’ could be NULL: unchecked value from (16)
                  |

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipmaddr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
index f8d6b992d254..a8ef20ec624a 100644
--- a/ip/ipmaddr.c
+++ b/ip/ipmaddr.c
@@ -102,6 +102,8 @@ static void read_dev_mcast(struct ma_info **result_p)
 		if (len >= 0) {
 			struct ma_info *ma = malloc(sizeof(m));
 
+			if (ma == NULL)
+				break;
 			memcpy(ma, &m, sizeof(m));
 			ma->addr.bytelen = len;
 			ma->addr.bitlen = len<<3;
@@ -149,6 +151,9 @@ static void read_igmp(struct ma_info **result_p)
 		sscanf(buf, "%08x%d", (__u32 *)&m.addr.data, &m.users);
 
 		ma = malloc(sizeof(m));
+		if (ma == NULL)
+			break;
+			
 		memcpy(ma, &m, sizeof(m));
 		maddr_ins(result_p, ma);
 	}
@@ -178,8 +183,10 @@ static void read_igmp6(struct ma_info **result_p)
 		if (len >= 0) {
 			struct ma_info *ma = malloc(sizeof(m));
 
-			memcpy(ma, &m, sizeof(m));
+			if (ma == NULL)
+				break;
 
+			memcpy(ma, &m, sizeof(m));
 			ma->addr.bytelen = len;
 			ma->addr.bitlen = len<<3;
 			maddr_ins(result_p, ma);
-- 
2.39.2


