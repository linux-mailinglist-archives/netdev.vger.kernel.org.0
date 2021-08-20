Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6793F2563
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 05:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbhHTDg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 23:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbhHTDgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 23:36:17 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829DDC061757;
        Thu, 19 Aug 2021 20:35:40 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 14so9567419qkc.4;
        Thu, 19 Aug 2021 20:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgh7JrRkcx9hCV2goz+b7Zq4sC7ybgcPmkhc9duiNfg=;
        b=blrip4eMq/uC82E/D2FZMuXVujwFldAMJ4vZJCXjLt3jA8TTmmLQcqQG7JS3yYe6NR
         MvpoCMqWKOL44d1YXG8EKt0gaEW5LzqFXoWQgw+yFErIYIVlNMbm2b3zeeOWeVuqmAJ5
         VXBsvaclmwT15lZjpEHuXYZvdodUOx4SA27LNTExxsy38n3CCOn4adimt/QgrHzeQa04
         80rNMW2avuz3QVW6cy/HOjzg4LMRkDtrJtieUTfLTWT0+zBC38qvf+8PKDWSWclhaYvQ
         syITFlKePDdVpKCV3t3F3CKPwar5jWeGLS1aCA60QGFsQGNcmHibTphZrp6y3GeJRnQi
         NJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgh7JrRkcx9hCV2goz+b7Zq4sC7ybgcPmkhc9duiNfg=;
        b=J7uakKKABQCfyJl/a4owQ6/RurkKSoXsZS3kbG9y30B6f2yClKu3PzPvElXfGgZQAz
         435l+/XQ7yiHILVeThcLTfnCKqYE1G4uYNYv/eB9t8y/OiRCneY5ROxJUspBRCpUcx2z
         i04Uy+Fg8Ex9M+hDKKXT3vSVZBgj/Bs70u/9jgYSX2rSn4h0GoE2gkbiads28i63MQkC
         uDIjuYlZGY9vaZEY7CzbTjgYMPe4mT6+SVAO7OTY9IonrvIF5DbS1vYlAQ5d5GDeZfBN
         UqQoY9FlsaTzkBqGAIMH6biV+Lv2i2SmNyEnnuHxg2xFYPfLKiPD2xHuLWH1PpS85Qqh
         PO4w==
X-Gm-Message-State: AOAM530kXt0QtjYWxkhpoXVB99w6gF4/LUgmnK6HsoTdEHCqDJEmzPxK
        rTcIkKU5W3BNRy4oAEn7jQU=
X-Google-Smtp-Source: ABdhPJzn4IXVKzCEtkWiW91ZWXfFs4EAjGQ7vxQ7WwjsiCDTo6uKjQmN+WDcDHTq3XWiI4C3hF9cGw==
X-Received: by 2002:a37:e20f:: with SMTP id g15mr7043720qki.450.1629430539792;
        Thu, 19 Aug 2021 20:35:39 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g7sm2147341qtj.28.2021.08.19.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:35:39 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] tools/net: Use bitwise instead of arithmetic operator for flags
Date:   Thu, 19 Aug 2021 20:35:27 -0700
Message-Id: <20210820033527.13210-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 tools/testing/selftests/net/psock_fanout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index db45213..3653d64 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -111,8 +111,8 @@ static int sock_fanout_open(uint16_t typeflags, uint16_t group_id)
 static void sock_fanout_set_cbpf(int fd)
 {
 	struct sock_filter bpf_filter[] = {
-		BPF_STMT(BPF_LD+BPF_B+BPF_ABS, 80),	      /* ldb [80] */
-		BPF_STMT(BPF_RET+BPF_A, 0),		      /* ret A */
+		BPF_STMT(BPF_LD | BPF_B | BPF_ABS, 80),	      /* ldb [80] */
+		BPF_STMT(BPF_RET | BPF_A, 0),		      /* ret A */
 	};
 	struct sock_fprog bpf_prog;
 
-- 
1.8.3.1


