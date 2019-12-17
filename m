Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B71B1229F6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfLQL2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:28:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727132AbfLQL2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:28:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576582102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q61b8NZiNglATLygY8DSz74dZVTZ21KejyMo2z3MExs=;
        b=dqDHkaV8BNM9pzgfiCNExkSoLNPj1WD7CiRUXXJihEdI9BCroQAh5aA8pBhqi1m9XenkyG
        vblWSHFhXmLTpiy/tPREAFERPx9gF8ZHUuJ40hoqOjf5KndbezNx2QgSJNmn51wMTz1Y7H
        +0kQOtGP3nMEQwElM4N2ZbMHznqwc98=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-eVnkX0pENRqBlgB24wvwDw-1; Tue, 17 Dec 2019 06:28:20 -0500
X-MC-Unique: eVnkX0pENRqBlgB24wvwDw-1
Received: by mail-lj1-f198.google.com with SMTP id s25so3132908ljm.9
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 03:28:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q61b8NZiNglATLygY8DSz74dZVTZ21KejyMo2z3MExs=;
        b=twFUbJA2ZKBBuhn/lP3gPuporg5YxqvChAf4C2wKezgPTyftxKj+fTQDOeDSsK+St4
         fGzEnnMJSjoaLSQw9B6yej42nPeTVsm68ok3Gw9Vh3PaPd6CdDtnVtrKS9fj2w7zAxPx
         D6W8SWTTzaIFcHeqwmZrY1g0qrh6S9JFnmMr08hcunHqK176pJEKEid1AgVA4tXLPwt6
         Pvwt7cr2D3wDAIlFh5StpBQMbjYCRKNSaWlbttznkqDnvXFzty/EQlSiSEhMf3J5WyXw
         yGZTtGDeq/JnrlezYnx0tt1GzO8pMrjpGIRIl0Al0hfFMVVmyQQrwGBGBo/uYZFoxWAC
         s2pg==
X-Gm-Message-State: APjAAAX8+Ge7i8XijURsFWEp2gv4HtdsSFkpytF3AD4LpYrdPK90ILgl
        noc3N1R1tktZwu13f/ml9GgdeaY3zggHDkQDBAlOXlVyaq1eQWPQ43rDAF9Vr3+vibGpZ68gH21
        VZ6QRHC7mm2pg/JXY
X-Received: by 2002:a2e:b010:: with SMTP id y16mr2836013ljk.238.1576582099210;
        Tue, 17 Dec 2019 03:28:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyIH5Q5OdQH6gcERzOp/eAcntIeffs5mFBn4uuIFZewUEQ+Uus+enM8p4BfdhFU/HZqLE/fQw==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr2835998ljk.238.1576582098973;
        Tue, 17 Dec 2019 03:28:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b6sm7289731lfq.11.2019.12.17.03.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 03:28:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 943471800B3; Tue, 17 Dec 2019 12:28:16 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Fix libbpf_common.h when installing libbpf through 'make install'
Date:   Tue, 17 Dec 2019 12:28:10 +0100
Message-Id: <20191217112810.768078-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes two issues with the newly introduced libbpf_common.h file:

- The header failed to include <string.h> for the definition of memset()
- The new file was not included in the install_headers rule in the Makefile

Both of these issues cause breakage when installing libbpf with 'make
install' and trying to use it in applications.

Fixes: 544402d4b493 ("libbpf: Extract common user-facing helpers")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/Makefile        | 1 +
 tools/lib/bpf/libbpf_common.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index a3718cb275f2..d4790121adf4 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -251,6 +251,7 @@ install_headers: bpf_helper_defs.h
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
+		$(call do_install,libbpf_common.h,$(prefix)/include/bpf,644); \
 		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_helper_defs.h,$(prefix)/include/bpf,644); \
diff --git a/tools/lib/bpf/libbpf_common.h b/tools/lib/bpf/libbpf_common.h
index 4fb833840961..a23ae1ac27eb 100644
--- a/tools/lib/bpf/libbpf_common.h
+++ b/tools/lib/bpf/libbpf_common.h
@@ -9,6 +9,8 @@
 #ifndef __LIBBPF_LIBBPF_COMMON_H
 #define __LIBBPF_LIBBPF_COMMON_H
 
+#include <string.h>
+
 #ifndef LIBBPF_API
 #define LIBBPF_API __attribute__((visibility("default")))
 #endif
-- 
2.24.1

