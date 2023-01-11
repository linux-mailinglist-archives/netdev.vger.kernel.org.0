Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61266666320
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbjAKSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238611AbjAKSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:38 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126ED3D1E8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:37 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jl4so17731498plb.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTIDmb64m6AEUf4Y7zL+qw9wvZsnktFS4l2duhJJc1w=;
        b=tYG4Zw9W1TT4f7xm5sfvU+zVON1tQZrhhf/JgHt3UdydjBLKIM5ReEHAf5fqEufeir
         bmUB+LZo0GBx+9tbJjgxInk4kRX3fSZrMUx8wGeqcs4xT4XGxdFqkMcWltXg5YSlWHHy
         c+mjeed0S5hEOp13VzXZPlidfOZmzA2ZhaT+ITrPJe20rgdLrRep+mFYyU0+algtZ+Wc
         Tr0VludJr3ALzEYlx4hfkLD5rzmdsqLDChRMPv7rorgWkG83yjlLDrhmkMBS7CCQ+HWH
         zMH1+XJb9ciIUKyzoAajhA2l/uTCqNg3rRI0Ykpv2jGOtNlxEY9RW1rCbWSWFzxlj9A7
         6Zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTIDmb64m6AEUf4Y7zL+qw9wvZsnktFS4l2duhJJc1w=;
        b=tblOKp3mXsPzQ+4l2jkkih0CXMZeSaVH2LSc9Ggud0bOrxTzZbHyszy65//xb/9O3e
         0cOPRTDdeGzYg6MG1XK+7S+Vv6pJeldnMaxDSfpGk8/7+TyvXcuTKbYrQWGQo9Teua7H
         ZAlgv0OQC9ZBWgNnJgmUpfL6lcPHtAbyICK7jf+Qa5PzeQSg4KTF6dX0WF1PuJrs9xhZ
         oVOeY+XC1eg8X1365vWjqxc7KmMn7KaQeZryqSnIc9CxiZ/8nL5gGQQcXVy6vQ9mEVde
         5Y3GaQzorC5MyihcM596bLfM43y4yJxAhB7rYpVbHvpLCczdMXOrlqYk+dW7paFihp8V
         zgyg==
X-Gm-Message-State: AFqh2kocBY4GPLApCMqAxFL3ie2TDwATIWMsbsahi+LwEw0B9ROumWE6
        /fq6kD5ZB/xqsQNfsCQ+v0buRhPya5EjQ9Pishk=
X-Google-Smtp-Source: AMrXdXsNtHY4LWR07z6reC7MAzbceH9IZXeNtmcnh/gglB5a5kJXZOWLxpPey/fVnpFbHi9rrxK4Bg==
X-Received: by 2002:a05:6a20:988a:b0:ad:79bb:7485 with SMTP id jk10-20020a056a20988a00b000ad79bb7485mr69594340pzb.11.1673463156278;
        Wed, 11 Jan 2023 10:52:36 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:35 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 08/11] tc: replace GPL-BSD boilerplate in codel and fq
Date:   Wed, 11 Jan 2023 10:52:24 -0800
Message-Id: <20230111185227.69093-9-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
References: <20230111185227.69093-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace legal boilerplate with SPDX instead.
These algorithms are dual licensed.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_codel.c    | 32 +-------------------------------
 tc/q_fq.c       | 32 +-------------------------------
 tc/q_fq_codel.c | 32 +-------------------------------
 3 files changed, 3 insertions(+), 93 deletions(-)

diff --git a/tc/q_codel.c b/tc/q_codel.c
index c72a5779ba3b..03b6f92f117c 100644
--- a/tc/q_codel.c
+++ b/tc/q_codel.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Codel - The Controlled-Delay Active Queue Management algorithm
  *
@@ -5,37 +6,6 @@
  *  Copyright (C) 2011-2012 Van Jacobson <van@pollere.com>
  *  Copyright (C) 2012 Michael D. Taht <dave.taht@bufferbloat.net>
  *  Copyright (C) 2012,2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_fq.c b/tc/q_fq.c
index 8dbfc41a1e05..0589800af0ea 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -1,38 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Fair Queue
  *
  *  Copyright (C) 2013-2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index b7552e294fd0..9c9d7bc132a3 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -1,38 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Fair Queue Codel
  *
  *  Copyright (C) 2012,2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

