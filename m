Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E3D11BAB2
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfLKRxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:53:55 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35151 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbfLKRxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:53:54 -0500
Received: by mail-pl1-f202.google.com with SMTP id x9so2106652plv.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xGVgxOXTDXZxUPv4l2tA8nMoXXfaum0oAoDgnC1FUSI=;
        b=eWRaE/hq64Ql2QJIK5Nv6aT5CnjIDZ/2O+nTyRxw9IqO/NM8PxoLlD0SrDZrpLYDP9
         k86fA8wZft6Ac7PHWm4Bymto/yDiJDuFtdDQApeVXVtUhSEnSs8zEnCJlW+rOhQiydmI
         cva8Y01MUfylLuG3sCWswhxeYfcr5UYrx2xQAmwgQbwpt6/treALtp9d0YiCPNl7zcA9
         pY9KOAlesrJCAjDl52ula36oBuT2qpXD8KuuyWUBbxtpD7joNr7w+IPdoMcGp23pP5Gx
         CcNZ+3UL2xljPfwq94GKIl1KSrwA6E5xjfpSnWOPwUzlfXkFMehnXFefwHoZOS3WO2nH
         IlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xGVgxOXTDXZxUPv4l2tA8nMoXXfaum0oAoDgnC1FUSI=;
        b=B9eZUzIt7w0WWIIZj1l4qXoeCbdZwl4dgL2rN6G8Tlq5dW47vOUEOSNJr5zFQfdVaW
         jQcmP1vOM3YY2TOikhgGo3aFzMxidT/q/sV4AaQLwwZivJ0vyrdaXJ3/EGoLyDY0C4mr
         wbc2dnBGFDwYYPOuRxcP5iOTPw1DMzqeZkZVF1V2LYnsOA5+AiVCfIXomqfKhPv/KHDx
         X1v49mLcmKTMcJMZSX3wwMtt88FajbUFYjs3lEP0ShewFjmdcxFIfhVH+Qbu3Ox/Bk1m
         VyErPzFegGNABiy/XvtuVb0C1XGwFTFOzUWx9NG8VQFBshiPnAGV6tb4WiN+959eBmDZ
         rSIQ==
X-Gm-Message-State: APjAAAUa50y+o5c4GyE5Fe4TSFqHjiRwUN4EFYjgMDUH4evUYzToGcjF
        j6WyW+AR0x+qIeCMIH+mQeB7hH7LuzbDmSfwN3skC72RNWSD60jKT5nqLmAeC+BGz3MbQAa/GjK
        NXjulrGE7qSDSNcLWEVLMK141A+TtoY44PimRGleMWosACcVSpHEXTw==
X-Google-Smtp-Source: APXvYqxWrwynamCuA/Qel0vqHsKVYW/kI7Ae8n8iSx5lCUuuVvonXNsAcllXE5LfmeWYq1vGWKb5FUg=
X-Received: by 2002:a63:e14a:: with SMTP id h10mr5417663pgk.74.1576086833863;
 Wed, 11 Dec 2019 09:53:53 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:53:49 -0800
In-Reply-To: <20191211175349.245622-1-sdf@google.com>
Message-Id: <20191211175349.245622-2-sdf@google.com>
Mime-Version: 1.0
References: <20191211175349.245622-1-sdf@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH bpf-next 2/2] selftests/bpf: test wire_len/gso_segs in BPF_PROG_TEST_RUN
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we can pass arbitrary data in wire_len/gso_segs.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c | 2 ++
 tools/testing/selftests/bpf/progs/test_skb_ctx.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index a2eb8db8dafb..edf5e8c7d400 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -11,6 +11,8 @@ void test_skb_ctx(void)
 		.cb[4] = 5,
 		.priority = 6,
 		.tstamp = 7,
+		.wire_len = 100,
+		.gso_segs = 8,
 	};
 	struct bpf_prog_test_run_attr tattr = {
 		.data_in = &pkt_v4,
diff --git a/tools/testing/selftests/bpf/progs/test_skb_ctx.c b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
index 2a9f4c736ebc..534fbf9a7344 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_ctx.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
@@ -18,5 +18,10 @@ int process(struct __sk_buff *skb)
 	skb->priority++;
 	skb->tstamp++;
 
+	if (skb->wire_len != 100)
+		return 1;
+	if (skb->gso_segs != 8)
+		return 1;
+
 	return 0;
 }
-- 
2.24.0.525.g8f36a354ae-goog

