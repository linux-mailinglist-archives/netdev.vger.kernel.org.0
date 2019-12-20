Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179D612763F
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfLTHIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:08:22 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35204 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfLTHIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:08:22 -0500
Received: by mail-pj1-f66.google.com with SMTP id s7so3720419pjc.0
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 23:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VkSt1ax+YAi0/mMhSwhEi8OzDSFahuyLq2lVA3SwBbI=;
        b=qaa05edqYwWQnq8m2MzNaWQrBr0kX89i6LgkkTEVJXtDrMEhpKuHbCf1H9EiDDgaf+
         SNnFlg0suDvE0iAlR6Sirpu7mj54A2fCkA1us1OEo/nTjhByOGZyGSrQtU4Qgwl4R8jm
         J7YEEAVRZh2u73aNy3cbxfJnCdOxJgu1z7sPB6cfPA4oiWXaVbyQ2kIo4gqL3p83gdqI
         sSd174hdEquaPy5Kx6hqYwxZZ6XBi3V8a27nrgV+29EEoGKeXDTPWtQBdCsT6NjTmf/X
         CqFsLgdGQygC5PHnMgATnA7itpe+Q8UR741BitmPBFajX4OFC/bqSYKgwvk8oerzZqiy
         BxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VkSt1ax+YAi0/mMhSwhEi8OzDSFahuyLq2lVA3SwBbI=;
        b=GZi8vl+UJ5K8XakFPhuwLsuiZTgNT38DyTjGzvliDP2xg1TdV4PhCZZEWGyu1P6t1c
         3Udy+3Xg5qK2CBs1lR/cyHToM5rNcz00xTgz1CWTbzVaMEGfPt2QIKaWenOiZFDDK7n1
         KjA0plC4xTtYWlHJRew+JUbuemIhO7AL/UA4Ku+fDbhK+lYkHzxbcdaBOulwA41GSp79
         wtFhINbmcA6yJMxzcMNiNEfHPW6bwRjx5X1J7QOPvpjlq3b1taIKd5cT2x9bcP2u3JQn
         VK5ZSHhqGOZRRFXIhlXc+C9Wp1NaHhGQDUxU1Ivg4Qdys6ufLJZxGAIBJ+VtGrpVxp8o
         3ZRw==
X-Gm-Message-State: APjAAAVHfU66et/l93I40SmBqytKmOfmjVsd01w6K5Jx6KsddwlCcRDb
        0M84iOEr00W6HQrIoYPaeJnBq8FdhD8=
X-Google-Smtp-Source: APXvYqykSkSC5iMD1/AUbHlmtqbwoB7KFjGLdZQM+RUT43LaNV31iwUlT/16w9xyyNv8xFXGgxAszg==
X-Received: by 2002:a17:902:fe0d:: with SMTP id g13mr13494034plj.277.1576825701217;
        Thu, 19 Dec 2019 23:08:21 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i127sm11781410pfe.54.2019.12.19.23.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 23:08:20 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: pmtu: fix init mtu value in description
Date:   Fri, 20 Dec 2019 15:08:06 +0800
Message-Id: <20191220070806.9855-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no a_r3, a_r4 in the testing topology.
It should be b_r1, b_r2. Also b_r1 mtu is 1400 and b_r2 mtu is 1500.

Fixes: e44e428f59e4 ("selftests: pmtu: add basic IPv4 and IPv6 PMTU tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/pmtu.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index d697815d2785..71a62e7e35b1 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -11,9 +11,9 @@
 #	R1 and R2 (also implemented with namespaces), with different MTUs:
 #
 #	  segment a_r1    segment b_r1		a_r1: 2000
-#	.--------------R1--------------.	a_r2: 1500
-#	A                               B	a_r3: 2000
-#	'--------------R2--------------'	a_r4: 1400
+#	.--------------R1--------------.	b_r1: 1400
+#	A                               B	a_r2: 2000
+#	'--------------R2--------------'	b_r2: 1500
 #	  segment a_r2    segment b_r2
 #
 #	Check that PMTU exceptions with the correct PMTU are created. Then
-- 
2.19.2

