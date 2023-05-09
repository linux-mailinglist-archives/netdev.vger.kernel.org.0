Return-Path: <netdev+bounces-1259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D69AB6FD131
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E19151C20C7B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC8319933;
	Tue,  9 May 2023 21:23:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF5F174ED
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:06 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FA0D87A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643ac91c51fso3664936b3a.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667300; x=1686259300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjzNv3ZUHV49ZK4sGfHLdC7UCnLyqaopmqPP4Gwurls=;
        b=rx8gqB8x2CME/XQdZ9TQp1nX0ILhzLmPsr0vP0/CAmPNqZgfr3nkjZHPHxLhDVJmUi
         fTZOWY6QhIxBXK2hCGc7iBNJOCHYLQB22/W4BZvxbHxBvhYyD3l9hBa0ILxDXrXrTBsI
         kBoozlV2gVqNwLKfPB4hq5jnejlpwzFAilTQIkLLoSUSffO3VNDvssCEiQ40OKM6xDly
         ZNpnJJxcbAAJb6L7mlDv9gv8b6pWYQJ9wTCYZ9xalEPsoCuOfbdv4/lSdSMV7e201vFH
         TQGBUTWzx4URs61cQ0lNw9fvq3rK1LhNDq2/Ya11tNyYZuvz+lly4uRglaF0k6VDSUg8
         ubwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667300; x=1686259300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjzNv3ZUHV49ZK4sGfHLdC7UCnLyqaopmqPP4Gwurls=;
        b=FJxcLhv6IJPCpspZ/BZWGZatmfSuqK0JywY6VcCg6jN8i5vVm1I2Ej1K4LLy7clFwP
         6As/qSgC7Y651wH/8PX+EHLGcaZxxYYOcIyq/ZMwfSqnGJ0EDirMD9fVgS1PEObVhj6J
         SBVNgyrRnd7oLeNqIq8Fas2sLIIQQMnTc1gFT0px/K/atnySB5Lj61mFCJgog5Tbt3IL
         DbYDUc/ydX1HAGyXuhPSsvx4XFDSszb6ENB52sRL0hhRjK7steFcKEkIOu+oT0MfqLWi
         YwKyxgh+B8b6uxtpeb/SObG4Ij3sRH8ZX6npjQgAQHgE/J7G2X1OJPVkTqvO0C35/fnW
         GLyw==
X-Gm-Message-State: AC+VfDy5GMf46LFSPXxocVz9Vyutui2ChcQrd0oE6rYruNm2AbVmzXZM
	0EIkU8L8vniBM0Cixowne+JxaUHAKLP6fjtBwuIPdQ==
X-Google-Smtp-Source: ACHHUZ5h5+9k6ZCequIIIL7lmhadb5U+d0nsJ5ZO0HtMVgMMJ7qyEMdivP3ehQX1lHxiHczNFtP47Q==
X-Received: by 2002:a05:6a20:938e:b0:ea:fa7f:f879 with SMTP id x14-20020a056a20938e00b000eafa7ff879mr21857229pzh.42.1683667300395;
        Tue, 09 May 2023 14:21:40 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:39 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 10/11] rdma/utils: fix some analyzer warnings
Date: Tue,  9 May 2023 14:21:24 -0700
Message-Id: <20230509212125.15880-11-stephen@networkplumber.org>
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
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add error checks for cases where analyzer thinks it is possible
to us a possibly NULL value.

utils.c: In function ‘get_port_from_argv’:
utils.c:76:17: warning: use of NULL where non-null expected [CWE-476] [-Wanalyzer-null-argument]
   76 |         slash = strchr(rd_argv(rd), '/');
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~
  ‘get_port_from_argv’: events 1-2
    |
    |   68 | static int get_port_from_argv(struct rd *rd, uint32_t *port,
    |      |            ^~~~~~~~~~~~~~~~~~
    |      |            |
    |      |            (1) entry to ‘get_port_from_argv’
    |......
    |   76 |         slash = strchr(rd_argv(rd), '/');
    |      |                        ~
    |      |                        |
    |      |                        (2) inlined call to ‘rd_argv’ from ‘get_port_from_argv’
    |
    +--> ‘rd_argv’: event 3
           |
           |   18 |         if (!rd_argc(rd))
           |      |            ^
           |      |            |
           |      |            (3) following ‘true’ branch...
           |
    <------+
    |
  ‘get_port_from_argv’: events 4-5
    |
    |   76 |         slash = strchr(rd_argv(rd), '/');
    |      |                 ^~~~~~~~~~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (4) ...to here
    |      |                 (5) argument 1 (‘<unknown>’) NULL where non-null expected
    |
In file included from rdma.h:10,
                 from utils.c:7:
/usr/include/string.h:246:14: note: argument 1 of ‘strchr’ must be non-null
  246 | extern char *strchr (const char *__s, int __c)
      |              ^~~~~~

Fixes: 40df8263a0f0 ("rdma: Add dev object")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 rdma/utils.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/rdma/utils.c b/rdma/utils.c
index 21177b565bf1..a33ff420f8cb 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -75,6 +75,13 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 
 	slash = strchr(rd_argv(rd), '/');
 	/* if no port found, return 0 */
+	if (slash == NULL) {
+		if (strict_port)
+			return -EINVAL;
+		else
+			return 0;
+	}
+
 	if (slash++) {
 		if (*slash == '-') {
 			if (strict_port)
@@ -747,6 +754,9 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index)
 		return NULL;
 
 	dev_name = strdup(rd_argv(rd));
+	if (!dev_name)
+		return NULL;
+
 	if (allow_port_index) {
 		slash = strrchr(dev_name, '/');
 		if (slash)
-- 
2.39.2


