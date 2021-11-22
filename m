Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C94593F5
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbhKVR1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhKVR1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:27:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA0C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 09:24:44 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r5so15868298pgi.6
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 09:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZG2r+XtBAXGq2E928Ts73IWmPO+ziO1V3EglLP0MME=;
        b=WPqd9NToc9nch0KnfxaDMvuJvzYgsl+dCeFXPTFtZ5o30vTuu2xrlDZvYJf+m570xk
         CZp7nJrcNLojhQo0vmQLoKXaCFHqLjXtyZr+3wJ/tYtxa4C0W55mNHlm5os3KAFj/psw
         oG/ITz05S77OT34bBwvZpt+XCKDjo1pePytthgvgsT/3rXFnAPn89LfuXomRtwDLzopm
         vvQiIke+sZFz3SHzNyq9B1pYNNk7KEYG9tB2nb7e3zS0vNRccrz+zIsFO1Ws5wQ7+Dys
         7n4IXtpTCUiV9V4Ko0fvKd3E7aCuLUUcyj94k3RD5tj1h3V9cF/JE7I51Pc1GmwDEVsG
         fYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZG2r+XtBAXGq2E928Ts73IWmPO+ziO1V3EglLP0MME=;
        b=wneYsf/+ZjUBOEGZpTyoT7ISyz18wgrfwSwStRyNChnC5sM5uv40wBLCOX9k+rJlBo
         /35aIgu0ejqgGNwfpId3MVJkWKdJrZV4/R8hgILIwQ/gw0+9RluNiJZTgnSAzCrpKLhh
         /mdneMr8/SZ8+RWq5EsTrHiZRjy6L03l+p62fCTeSxzD8sAqFCfUcfO1h9RdIaR+Q7Zp
         lW5RYyqsBQWG6SnedKK9xtiSQOKv8PSrBajdgCRpnXGv14/Tq9BjeUC1qjOvAuZRYoPp
         Kq8uh7E0RSoB2MtzgozBcpRy1DHU8Rkz/XmCnyey7gib9dDx2jdsF0e6DiQF/V1DPMqx
         mP2A==
X-Gm-Message-State: AOAM532rOrUxzYdVwIWIVymDDVNxkfNUpktLzNYqpVCpAdn+Vx/dcMpH
        nGYWWj5RFaq1XGCYAeqpppog66hVJOQ=
X-Google-Smtp-Source: ABdhPJyDejqqsf5pxHr6YqGr9F8wNN55FT7oHILr5r3iNJvUOYmLLSb+HZ8Z39/18AbSkj1G6nVWlg==
X-Received: by 2002:a05:6a00:10d2:b0:44d:f03e:46c7 with SMTP id d18-20020a056a0010d200b0044df03e46c7mr86562950pfu.0.1637601883777;
        Mon, 22 Nov 2021 09:24:43 -0800 (PST)
Received: from jprestwo-xps.localdomain (h208-100-154-31.bendor.broadband.dynamic.tds.net. [208.100.154.31])
        by smtp.gmail.com with ESMTPSA id h13sm9660590pfv.37.2021.11.22.09.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 09:24:43 -0800 (PST)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        James Prestwood <prestwoj@gmail.com>
Subject: [PATCH] selftests: add arp_ndisc_evict_nocarrier to Makefile
Date:   Mon, 22 Nov 2021 09:18:06 -0800
Message-Id: <20211122171806.3529401-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was previously added in selftests but never added
to the Makefile

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7615f29831eb..9897fa9ab953 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -34,6 +34,7 @@ TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
+TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
-- 
2.31.1

