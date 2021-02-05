Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C51310E67
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhBEPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhBEP1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:27:51 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B988AC0617A9;
        Fri,  5 Feb 2021 09:09:57 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id s18so8610317ljg.7;
        Fri, 05 Feb 2021 09:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGM92or3yHqDVSbnQT5CKklRm3z5f4EJasgPxoGx2UA=;
        b=tGPHkmianWKtpE6ravdxAogd2bo2qUNNya6BBnY+svsKgsSa3iBPHiqezTc0WdsRzU
         /kRldujQELtGbuchqRyorScE/HMl8JY8loLvmrUQ2/9TM0/zZakOe6ULyMxyIm1Z9XKp
         DWSrGrTmrXSv1vIUVu5ZG6oHpdc5icJuXmDQteuYbs8N31Zlf1R/PpvQNoJgcdOTz8ic
         4BQ76uFL2URu3YCNmyuSIHimlDvXbLEtTcgHx/s/1hnVq3o+Eybh/HEGxpqnJTscEUQp
         VYFfcFI+JHhZQI4/7nG8qOrDNz7MvS9dVVoxq4se2i2Yy831tvKRmYtMqlv4zupiSqjx
         nerg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGM92or3yHqDVSbnQT5CKklRm3z5f4EJasgPxoGx2UA=;
        b=HHVtYoVkNtwtOqSaHuzMCoshmrA5NtTqtg6UpOhkCJS2Zk40wolNEkLLTcu4ovZRZt
         EUo1gwdbBVjNsAr1ukZBuRW+fCRWrREtlfv52XtGQEAuKpvqJrUufKVdtmbzEL/HplnN
         0HvjaPGH1pqEfFPr2ImODvWKTj3irn8b7IDkivkp08gvNfG65I+XAL+zK82l258kIlhY
         5l00bGK7A5Hz88PEXp2SKtx1TEfMdz8ZMfi86A7IbgsrVYbpiAnKD4++IohFTl37WRQd
         8wq1d4YjSeU8JNLLtIbugpWFxnhQP2h0jfR7JhJWp4Q78V/TA7ukLGQPdyeNLYc71OK2
         25YA==
X-Gm-Message-State: AOAM530UrDCaMm+ARiAQ8ND62Ale2CNvb7U3tJeCH6d3F2IbtmyUn56+
        NtNfgFHSXRL3+LbLJN2i70Y=
X-Google-Smtp-Source: ABdhPJyFBiKITnzP/gla5eq6O1ZodC8RXhD+TLwezEuorS8lN5HUr0i4kJ+seh3wovj2zTnqRr7+gg==
X-Received: by 2002:a2e:9ac1:: with SMTP id p1mr3183740ljj.327.1612544996044;
        Fri, 05 Feb 2021 09:09:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id f24sm1066434lfh.150.2021.02.05.09.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:09:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        u9012063@gmail.com
Subject: [PATCH bpf] selftests/bpf: use bash instead of sh in test_xdp_redirect.sh
Date:   Fri,  5 Feb 2021 18:09:50 +0100
Message-Id: <20210205170950.145042-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The test_xdp_redirect.sh script uses some bash-features, such as
'&>'. On systems that use dash as the sh implementation this will not
work as intended. Change the shebang to use bash instead.

Also remove the 'set -e' since the script actually relies on that the
return value can be used to determine pass/fail of the test.

Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index dd80f0c84afb..db35e40947ff 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Create 2 namespaces with two veth peers, and
 # forward packets in-between using generic XDP
 #
@@ -72,7 +72,6 @@ test_xdp_redirect()
 	cleanup
 }
 
-set -e
 trap cleanup 2 3 6 9
 
 test_xdp_redirect xdpgeneric

base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
-- 
2.27.0

