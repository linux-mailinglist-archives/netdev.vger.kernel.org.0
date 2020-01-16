Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43113D63F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAPIzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:55:35 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:38532 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAPIzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:55:35 -0500
Received: by mail-pg1-f180.google.com with SMTP id a33so9562579pgm.5;
        Thu, 16 Jan 2020 00:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axl4EKweDKbvR0z3KyY3tqCSjovhSbHRzZUpaSSb2xY=;
        b=USmOi2+i6Qey3WW8OzYuUdYyaKzlEt/5OZMeUQYleuCu987d3wDxP5gQrCPO7RvpIL
         v7ZzehjHkeikBfDav+kXJhOnHpMJJZzNqeWl/ak9bZquEpob9LOZt1XMEo2cHkQdbxom
         xGDMoGICwxHPnnW7+K13vicyvjTWkVNw/injgvy0OS0p1utwFUkPwlU/UcujLUzxHQuc
         Ae5tyCZ9gJPCR5xDI2yjsKSr82rQLpwUKgGAFh8emIKUedBuWW42visJtIrQJA1MW8Me
         7TOZ3MtsqIGpeKU7Q6RCZPWZeuDBOBaPHUE/ReJNzl/jlTNw3UV4Xa9bq/XO26civazo
         9+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axl4EKweDKbvR0z3KyY3tqCSjovhSbHRzZUpaSSb2xY=;
        b=pyUpl/rIMnmTnUhRIV2YumvLYUKNr/9oYsPt1IMVwrVce82Ll8HvALxuR1FJxtmyzj
         EYVx4Z8tVoFDvNqpIEO1mkZheer0Rx5o/FC4ilg/8ERYxi9sh/rGfkDXg/T8rB+Lb5GD
         2c3/p6KPdFxkN2xh+E9JagrdAT0TxpDZJHKCSpLqu0uFTW8wL2W31izyKHqSlZlDmLIC
         KbP1nxj11BWe/KKFGFRjNyFrgbsJlJ+CRPn1Gwykx5yy9+rZbt66eMchRsMfdGfKr8V1
         Vux378T8lToI28VTO1O6W3Xwr7B4kaBp0pCHbz2H40OF0Xaooqpgn9rZ7r2M8OWPIwqd
         Q0Cw==
X-Gm-Message-State: APjAAAXfBf6fATIz2MJj2elIl1VtyWzFd+wn6znnMfFfuK+h0YNBupOT
        Q8juuXhLqXUbLS3yf3dC4b0=
X-Google-Smtp-Source: APXvYqyQL/0EEQK68za2k8s++a3Mj9kWVmGXtF7/MJcygzPJqzvDXYfkPAQJPO4k3MJexYTT/gKaGw==
X-Received: by 2002:a65:63ce:: with SMTP id n14mr38876499pgv.282.1579164934638;
        Thu, 16 Jan 2020 00:55:34 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h3sm2643746pjs.0.2020.01.16.00.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:55:34 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 2/2] selftests/bpf: Add test based on port range for BPF flow dissector
Date:   Thu, 16 Jan 2020 17:51:33 +0900
Message-Id: <20200116085133.392205-3-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116085133.392205-1-komachi.yoshiki@gmail.com>
References: <20200116085133.392205-1-komachi.yoshiki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple test to make sure that a filter based on specified port
range classifies packets correctly.

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 tools/testing/selftests/bpf/test_flow_dissector.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index a8485ae..174b72a 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -139,6 +139,20 @@ echo "Testing IPv4 + GRE..."
 
 tc filter del dev lo ingress pref 1337
 
+echo "Testing port range..."
+# Drops all IP/UDP packets coming from port 8-10
+tc filter add dev lo parent ffff: protocol ip pref 1337 flower ip_proto \
+	udp src_port 8-10 action drop
+
+# Send 10 IPv4/UDP packets from port 7. Filter should not drop any.
+./test_flow_dissector -i 4 -f 7
+# Send 10 IPv4/UDP packets from port 9. Filter should drop all.
+./test_flow_dissector -i 4 -f 9 -F
+# Send 10 IPv4/UDP packets from port 11. Filter should not drop any.
+./test_flow_dissector -i 4 -f 11
+
+tc filter del dev lo ingress pref 1337
+
 echo "Testing IPv6..."
 # Drops all IPv6/UDP packets coming from port 9
 tc filter add dev lo parent ffff: protocol ipv6 pref 1337 flower ip_proto \
-- 
1.8.3.1

