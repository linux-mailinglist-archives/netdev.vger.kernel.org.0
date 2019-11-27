Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E4B10A9E5
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfK0FUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:20:01 -0500
Received: from mail-yw1-f73.google.com ([209.85.161.73]:36380 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0FUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:20:00 -0500
Received: by mail-yw1-f73.google.com with SMTP id z73so10819051ywd.3
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KP09QWIUHs0r8XGA1sW0Y1i5euBm0SkJkbuzlsUp1Fc=;
        b=kvasFKfP1tCg0YqtxDEOCIgMFUK1rRJL38I0QmeXt7e/75BUuUaM9blJwA+idP3aGG
         K+bH2dqEGmeoUVSLW1DNPTuowqC1e3Y09+SkTrWrKrdZNSgxXaOShkhEy8GjKE0KVoeM
         ecqTzupqt1/jWGJbjOzYW369XB/HjZXOSZLQMoOg4Edl/g9aW0Cl4O3r/qTF9CpeiZ9M
         E0HtHBH4X0xQQwkbQW0/piojjIyUXWs0ZizIHRuU+84hbhB8rHswbCCX6lIrGffb9HnT
         tL63SEWDcgf/KCZhQcleefa6HhJHaPyDCx4r3WnBTyJfTdnxxiJ/Y3i6k4DMLRRQ7+9f
         H3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KP09QWIUHs0r8XGA1sW0Y1i5euBm0SkJkbuzlsUp1Fc=;
        b=oK9Sp0du23E8/dREHpVpQmQBGTKUZed0tjzdkN9+q3iQOQIMt57UlB/2+A1eUYiUkQ
         lDv1NWL6lKQAGr8gV825iRe3SZGPob3ysYbhYZESG2ncNOf3Ityrnu8O4h4hiy9u5vSK
         WA66Zv6PQBzbJrr7kqb484P+/L+WLqE+kzZGs1ZDI3e8V92wD6o80Il58h8xIcAHq5nv
         zbs2575dIGwpjKHjnxvo3JXqSx867iuFisWMiHA7kcy8s7oMNAjV80/s4tkeXQPKTzcj
         XX80bpm+NqT3N36eNVMHGxRoKdvgp4aGRKtfXwsVszZQ0JXraJc7BS4a6JEdSNmclOGK
         /z5Q==
X-Gm-Message-State: APjAAAVocvJtHc7Jws7JehQ8bTEuNrNERLSY0UYJM8TYdRcM4ZpfRZ/R
        1tjsV1ppYIBWsg6GVI/0pE2PtcP3U3sE
X-Google-Smtp-Source: APXvYqw/6/DKKbdRY++BAgdZv3GLNQe4DJaqBl8af6zo6H3y9XBdJgKxaoMCPAzHMyTQyoiDWlCXmg9xMhht
X-Received: by 2002:a0d:d307:: with SMTP id v7mr1587671ywd.300.1574831998298;
 Tue, 26 Nov 2019 21:19:58 -0800 (PST)
Date:   Tue, 26 Nov 2019 21:19:34 -0800
Message-Id: <20191127051934.158900-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH iproute2] tc: fix warning in tc/m_ct.c
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>,
        Paul Blakey <paulb@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Warning was:
m_ct.c:370:13: warning: variable 'nat' is used uninitialized whenever
'if' condition is false

Cc: Paul Blakey <paulb@mellanox.com>
Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tc/m_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_ct.c b/tc/m_ct.c
index 8df2f610..45fa4a8c 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -359,7 +359,7 @@ static void ct_print_nat(int ct_action, struct rtattr **tb)
 {
 	size_t done = 0;
 	char out[256] = "";
-	bool nat;
+	bool nat = false;
 
 	if (!(ct_action & TCA_CT_ACT_NAT))
 		return;
-- 
2.24.0.432.g9d3f5f5b63-goog

