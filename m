Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA74C160923
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBQDoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:44:20 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:56230 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:44:19 -0500
Received: by mail-pj1-f67.google.com with SMTP id d5so6529849pjz.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 19:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qMQAlyA9Bn+O7fHj/sic1zZ7I4DgdKcRqKlzF0tlzg=;
        b=qH8gdPAU1yUmiIVXfwAZH/pF2sPC5uDL6h8pI2HmD7Dc9p8HPsbTMPP8NmZfaBtXK4
         ZqhY2L4ssrzzpNCjDcCm8hxquyF/4vVgWob/Q77MhiQVoxcJt3j/9wnou/3QWt3ycj8g
         yt1jiaL6owKP0bDXQEWB5Z8sZPKxK1XWZh2Je3byMpAfXn7OuJ0kLHmr5ghFDbwRYhh7
         MZWGJXiOlTnA46AH9iERTZ6JQ32aFFCFqGu4WkY9UvC/LF33J7CRTkcVZ6kp1FEYJHso
         tGei52aDyHl+xie/kgp+xtMwqi2Pi9DYG2oNbkKlnVgKR4JZaKZXkSfdzzs2RNypZPHR
         yupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qMQAlyA9Bn+O7fHj/sic1zZ7I4DgdKcRqKlzF0tlzg=;
        b=tZKHFr9JHZtQ5d99DA7Lwk8FfXa7Ua6bdPAI8dOzcK4tzgMl1J55fqlHO6ADA9jdtB
         s7n6MwtfWwqnPxszbrcVAeO9tzD5ZtNet0SXgap2+rlxEk3ZGDNLn8gpsaiQA9/PuF1d
         3Wlx7Mka0z7jD4n0bkpHzffuckq35q1IMoY/n6BaslLPOzn6j6S3N+NwqVmHcURifUgR
         EVDYBY04L0S6RpV3Llvdcv/NsypASmHBXePp0qHCExF/nm7Xog/GmIsNVJD6wDmYDVN+
         ikpknQ3uiAH3wOE8pqpEdW3HzaAMJ1NoQDSklOLjGDgC3+RHICKXBJxxdf2rChX1b5Vu
         0CJA==
X-Gm-Message-State: APjAAAXyeLN3v+9jtAgYSbflP74q7zjXIrXeJl/fvYjaT1lIstYanBvn
        dBEi8k82lbudNK2zDyZIRTnRC1aw1vI=
X-Google-Smtp-Source: APXvYqzc3IruH/T0PVPK/lwMyFvBwbpZ9F16hi7Yj8OwXJ2UtoxHJapdxJCIcen7RWCZ9url6O0YQg==
X-Received: by 2002:a17:902:bd86:: with SMTP id q6mr13300203pls.143.1581911057672;
        Sun, 16 Feb 2020 19:44:17 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 199sm14868718pfu.71.2020.02.16.19.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 19:44:17 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: vxlan_bridge_1d: use more proper tos value
Date:   Mon, 17 Feb 2020 11:43:15 +0800
Message-Id: <20200217034315.30892-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0x11 and 0x12 set the ECN bits based on RFC2474, it would be better to avoid
that. 0x14 and 0x18 would be better and works as well.

Reported-by: Petr Machata <petrm@mellanox.com>
Fixes: 4e867c9a50ff ("selftests: forwarding: vxlan_bridge_1d: fix tos value")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index 353613fc1947..ce6bea9675c0 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x11 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
+		flower ip_tos 0x14 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x14" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x18" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.19.2

