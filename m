Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882625E58C2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiIVCpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiIVCpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:45:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891F67AC35
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:45:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so7830784pgs.3
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Yno7lIiE4QUqkgoMcNs/MFNAV99IkUYcJae4SRqDJDM=;
        b=nmDHwPNUbPj+Rk6Wt14n96daVPvH1abWaGY4JdubdrZojwcflT4h2O1L3YVK1UTVyL
         0nHxfVvgzcKSekHkxboPHEOe7ou+UDYfcBN8yNAixZ2uZqRf3ZCVFQMi7WvVnESdeZ+Q
         lzrDjThdVq0JzT4rwmMwRb0wzQsxUVukxa76moEBOr/yzen5AXO7ka9PQIyls8Leojz2
         YDcKdvWXFdhbN7R1g7eOWqRRcfV/CLmSd8BOZy/iL5JPIYw0ltWxQ1a1cI+IR4yRBNu0
         X2vnQ9EgTMnwnD3rbnVKXEFPfzM01g1Xg74eUGQtcP+rdFPQyOv5bqq8BriroHzRB97L
         z0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Yno7lIiE4QUqkgoMcNs/MFNAV99IkUYcJae4SRqDJDM=;
        b=as3tDsJrAyNEiXBzUY8vzZH8If4diS380sngXA0oVCbjbhMS14myyklDY4mwydTiNK
         GeCmBR6DhKAkn2KZDymgh846UEgMEshvpBjHk0aAegceqDIq1TyknX+m3fT6mLMKKvaV
         t3yyucSiFQwE3ryK/Lgd3ZypfGGpXflPHk0j3ND+/lQNoHEvMnCTjiAv3dHJVgSJE62+
         HbSBIfIFwXnWVe8dBJfP5EIkPoEunfYU71G+z5EzzfXaS15c0FWOFtVDVkDd9WFfLZ9N
         8dAAbdBdBvwKXk2rE5Otgzhcw9gOxjfKWt9cZFkk9Nip7pGTuiWUQM6z30ZdZOVYS6ac
         VtZg==
X-Gm-Message-State: ACrzQf3hOcASDZT/h0SJPg6OO5tq7iB0Hd5PZm0mkJR8Cecz7Nq8eETT
        UYpwEMSz7fkVnh0NWAlO8vo7TmyhiSlm+A==
X-Google-Smtp-Source: AMsMyM5iQlMcXhrRjdPk/MZCY2z4hKdWcI7i0e0dwuGIUM/7IA32/vGJ18XV5OQYO9agpAWrHFlOuQ==
X-Received: by 2002:aa7:9e0d:0:b0:540:94a7:9051 with SMTP id y13-20020aa79e0d000000b0054094a79051mr1407933pfq.59.1663814712848;
        Wed, 21 Sep 2022 19:45:12 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n17-20020aa79851000000b0053b0d88220csm2971547pfq.3.2022.09.21.19.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 19:45:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: add shebang for sch_red.sh
Date:   Thu, 22 Sep 2022 10:44:53 +0800
Message-Id: <20220922024453.437757-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RHEL/Fedora RPM build checks are stricter, and complain when executable
files don't have a shebang line, e.g.

*** WARNING: ./kselftests/net/forwarding/sch_red.sh is executable but has no shebang, removing executable bit

Fix it by adding shebang line.

Fixes: 6cf0291f9517 ("selftests: forwarding: Add a RED test for SW datapath")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/sch_red.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/sch_red.sh b/tools/testing/selftests/net/forwarding/sch_red.sh
index e714bae473fb..81f31179ac88 100755
--- a/tools/testing/selftests/net/forwarding/sch_red.sh
+++ b/tools/testing/selftests/net/forwarding/sch_red.sh
@@ -1,3 +1,4 @@
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # This test sends one stream of traffic from H1 through a TBF shaper, to a RED
-- 
2.37.2

