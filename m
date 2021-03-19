Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66398341F84
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 15:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCSOdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 10:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhCSOdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 10:33:41 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23E0C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 07:33:40 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jy13so10052591ejc.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 07:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z7Sz/CK4hbMD3nRwNEK6nTqGLG3yRvjpZSZAqilc0ao=;
        b=TUB/tsAcFpJz+6axd/lQVuSa8TeGKgcn4MBUy56vp0j0+qEb33GveHaY0/mZ+l106q
         OaKoxhpPKA7gEVIxsdtvtTivLePQlaMyPrxX9W1qX7x+Yj5OCirBDXv8+AIfzcCk3ida
         37piLIJcOuUyNnq8QCk5c671s9M5KRH9bIk/RvInuL0pd9ZxxZYFH1s27HVm/bp5l+X4
         mlWudDF4539NjXLpzrJm4OWLwE53IaXz/AyTA4+iJ0iTNekklEHzSopsATJmtveg8wbH
         16+GSnp6wjlaWMrUwpdsrCGEc09ordw7o7914SrOehgEkoYbPXGnLr0Z3mAHPjRDJslS
         r5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z7Sz/CK4hbMD3nRwNEK6nTqGLG3yRvjpZSZAqilc0ao=;
        b=fAS3k9z9F9KnYDjDeXg0/uCY/ptRGCNhuru5TjFaTasX8arO8vXh+9BFiOwDZw2wsC
         Azmz7zc5YTrLK4ejFJg+dVytQc19rLW0OApxnMxKqa9GzGochvZb4JxcxOaP40xD/y12
         6cpZZQXtpIIvxOFSEKiypc8sVAxtB7Gx+k7lYne5vklYwTLlDWXMxMFXRtNyXoRJRbeh
         9674fL13LjMMvUCGyW286XFfaT4FuW87hiPFPOqDqpDAAKM/hkHd3ivWqWN7GHQe9AOk
         nolk84ROcdCNIfsi8zClx/0oRKCLIQy22xV49uyeowL+3m3tDT+4XNKWw72tHKIjubOq
         +WYw==
X-Gm-Message-State: AOAM532BqEF56Sd4VFl/nRAGli6HSlxIvXI7RDJgZNryTWujn4Rr85jw
        1GY8uhrQpsV1MHhTLqoTKDUAiJs6SsniIA==
X-Google-Smtp-Source: ABdhPJxCIQlh3d8YsEUIeArr2wgWLgLetCgxCUlfE9TQT0UWF4gtxP7rla5Px3fb8Sq6l8AyV8Yt2A==
X-Received: by 2002:a17:906:a1c5:: with SMTP id bx5mr4928601ejb.166.1616164419399;
        Fri, 19 Mar 2021 07:33:39 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([111.32.64.26])
        by smtp.gmail.com with ESMTPSA id lx6sm3774945ejb.64.2021.03.19.07.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 07:33:38 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value
Date:   Fri, 19 Mar 2021 22:33:14 +0800
Message-Id: <20210319143314.2731608-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ECN bit defines ECT(1) = 1, ECT(0) = 2. So inner 0x02 + outer 0x01
should be inner ECT(0) + outer ECT(1). Based on the description of
__INET_ECN_decapsulate, the final decapsulate value should be
ECT(1). So fix the test expect value to 0x01.

Before the fix:
TEST: VXLAN: ECN decap: 01/02->0x02                                 [FAIL]
        Expected to capture 10 packets, got 0.

After the fix:
TEST: VXLAN: ECN decap: 01/02->0x01                                 [ OK ]

Fixes: a0b61f3d8ebf ("selftests: forwarding: vxlan_bridge_1d: Add an ECN decap test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index ce6bea9675c0..0ccb1dda099a 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -658,7 +658,7 @@ test_ecn_decap()
 	# In accordance with INET_ECN_decapsulate()
 	__test_ecn_decap 00 00 0x00
 	__test_ecn_decap 01 01 0x01
-	__test_ecn_decap 02 01 0x02
+	__test_ecn_decap 02 01 0x01
 	__test_ecn_decap 01 03 0x03
 	__test_ecn_decap 02 03 0x03
 	test_ecn_decap_error
-- 
2.26.2

