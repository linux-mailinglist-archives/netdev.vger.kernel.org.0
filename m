Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C29125D2E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLSJC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:02:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29067 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726609AbfLSJCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 04:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576746174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QxDIaWdT8batw2rKwD3TMKwDU+xiK4PL5KHw6ZGQad8=;
        b=Ebe9uCj658u0sb8tVELVDAywYMu9UgQcaAjoz9pRbinnu2eEZQfH0oA1aU7BjZ5SGkacl0
        Uly/73pomZ5tEbN2AfB2U5LfQYSziL3bZJIxYKlklypmfMpWdPXPu07TQXsPjfgZSXJWqV
        uJB+CEnwKUZX4uPBrL7YkFBEL78GMOU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-rsm-lvq_NJmROM1Zw2yykA-1; Thu, 19 Dec 2019 04:02:53 -0500
X-MC-Unique: rsm-lvq_NJmROM1Zw2yykA-1
Received: by mail-lf1-f70.google.com with SMTP id x23so485594lfc.5
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 01:02:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxDIaWdT8batw2rKwD3TMKwDU+xiK4PL5KHw6ZGQad8=;
        b=d/2gASSoF6tfHRd+bYFCrw8h4JyPLKAMcjbKJkXrJ04nDGziBXivdxIu3z7o7T3dcx
         H2tAEbpNs+83DplgocbF8VquNgDLRDv+RgBNBCGTvGQmI9w6xnqqugcWsXQ6WUiXmc5i
         ApdqWMQOtDKcIq5qt3LB3YnlbPgYCcpYN0Ch8Ei/whnt0BH8sxITc1WGQMrmgqzg/zqz
         w9pob3CX0N7lXwsIa5+XF7ClUSiBfxgyJEUuUDv1lp4TEumjMsQLWaavbPDDGnVI/MPd
         YWz0ABqtWjKGwKlC1VoLaDOBIfH8sA0vM2lcCW4JJxBL+WD0u5fRD61eNvnOHkz0lWEm
         VMow==
X-Gm-Message-State: APjAAAUI9sA3DXVLd2Xje2AWwPCAriSfDQomy9REIjOLSerQuQj805fh
        LyHQ40+CyIFDWehZu+CbS7zz+4kr/KRuqUfXxiP/cCZGBNs/QP/v4I+yEOofRvBa5tGKvw4U/fU
        RRBPbMt/oyskNrakv
X-Received: by 2002:a2e:8745:: with SMTP id q5mr5223636ljj.208.1576746170738;
        Thu, 19 Dec 2019 01:02:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZ+C/Pil77EjYzmhfrYVbigzr+NO1QGwq89zUMQ8vsExgbh4KpvgbQCNNxUhznT0vQHIKypA==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr5223627ljj.208.1576746170531;
        Thu, 19 Dec 2019 01:02:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i4sm3089417lji.0.2019.12.19.01.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 01:02:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3D17D180969; Thu, 19 Dec 2019 10:02:49 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH bpf-next v2] libbpf: Fix printing of ulimit value
Date:   Thu, 19 Dec 2019 10:02:36 +0100
Message-Id: <20191219090236.905059-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh pointed out that libbpf builds fail on 32-bit architectures because
rlimit.rlim_cur is defined as 'unsigned long long' on those architectures.
Fix this by using %zu in printf and casting to size_t.

Fixes: dc3a2d254782 ("libbpf: Print hint about ulimit when getting permission denied error")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Use %zu instead of PRIu64
  
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c69a3745ecb0..59bae2cac449 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -117,7 +117,7 @@ static void pr_perm_msg(int err)
 		return;
 
 	if (limit.rlim_cur < 1024)
-		snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
+		snprintf(buf, sizeof(buf), "%zu bytes", (size_t)limit.rlim_cur);
 	else if (limit.rlim_cur < 1024*1024)
 		snprintf(buf, sizeof(buf), "%.1f KiB", (double)limit.rlim_cur / 1024);
 	else
-- 
2.24.1

