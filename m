Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C27D8BF4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbfJPI6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:58:16 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:41621 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388817AbfJPI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:58:15 -0400
Received: by mail-lf1-f46.google.com with SMTP id r2so16755715lfn.8
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 01:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/+4sUm7d4zOmxV/DS5enUnVCl8aumQR4W4v3g1GZPP0=;
        b=KkR7GEHpT+Of8CpaVbhXHSe9RE21dpY6+aaR84aIojff9Bxmpe5s9fMQfIbGgLHVcJ
         8ONYzYo4caQ1EvbJlmInyey0wAUZh1UNlvfFYKXA5sjKUU9JpzyexDnkNTqdxNUlfE78
         QfDoiTvZBoQjmjDVRP20GUB+3dZVa9oss6mpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/+4sUm7d4zOmxV/DS5enUnVCl8aumQR4W4v3g1GZPP0=;
        b=Fr/lawV6l0yJhvtnwJ+m3T2IpKVZCDLYKWnrcpWJWkumRKh4TS2fG6rsH8xsPJXemD
         h1cJbEQCCtNGbjxKgrAiBVfK+SsS8HoXqimEge62bOOIchEHs1hf7wk0Z/v7fJI1s3cR
         XWE18ThCkC2XUcXidscMw6Cl3ZEo3KJWnkqFHZb+nqdDuSfy0R26PB0f69KgC6SUY9LX
         rY9naCzMOPN4aCyVEZbkWT3j8ZQcirk6bTTgEWfFJ+M3s61ZIJn78EdFfNzQpPj3X4Hg
         mpMBiYPaycqF49GTfidl8dOytbfU3Sp9PVplP/L3N2vl3LJTlcQ9XjHMDsnIcLYuILo3
         PjTg==
X-Gm-Message-State: APjAAAWFHOPG4fSQWWK11AnPlmF7CDlTxZEAhzOlbtuZMxGcrc4ZD9Fg
        E2ibsLovUoW6JJtDJ4alg2Fcl5FXeH78zg==
X-Google-Smtp-Source: APXvYqw5zxBWvIpopn/S5WyBrW/zOe3siFtoi028J+TB9HrUijW5o69Kf8RRT+aK0IjOG/qr5YV72A==
X-Received: by 2002:a19:148:: with SMTP id 69mr12460027lfb.76.1571216293141;
        Wed, 16 Oct 2019 01:58:13 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h5sm6542515ljf.83.2019.10.16.01.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 01:58:12 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next] scripts/bpf: Emit an #error directive known types list needs updating
Date:   Wed, 16 Oct 2019 10:58:11 +0200
Message-Id: <20191016085811.11700-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the compiler report a clear error when bpf_helpers_doc.py needs
updating rather than rely on the fact that Clang fails to compile
English:

../../../lib/bpf/bpf_helper_defs.h:2707:1: error: unknown type name 'Unrecognized'
Unrecognized type 'struct bpf_inet_lookup', please add it to known types!

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 scripts/bpf_helpers_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 7df9ce598ff9..08300bc024da 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -489,7 +489,7 @@ class PrinterHelpers(Printer):
         if t in self.mapped_types:
             return self.mapped_types[t]
         print("")
-        print("Unrecognized type '%s', please add it to known types!" % t)
+        print("#error \"Unrecognized type '%s', please add it to known types!\"" % t)
         sys.exit(1)
 
     seen_helpers = set()
-- 
2.20.1

