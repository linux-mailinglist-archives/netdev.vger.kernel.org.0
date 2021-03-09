Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27215331D6F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 04:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCIDWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 22:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhCIDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 22:22:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98599C06174A;
        Mon,  8 Mar 2021 19:22:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so5873916plg.5;
        Mon, 08 Mar 2021 19:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1BJUNb3lQRiC5sVIz839O78v77O5TxTS0w+wrputiFY=;
        b=WlyrRFdNCBuAkvSvGNBRurvvROD6cJGfZ60F5dXXsmt4sw/m93x+hJnHDdN4dvXAyC
         /4Sr4BsX0g4i6l77F2OMuiTSdx2I76koSmIc+UhZl6XQenxA0cv9PUHi8QHkxbVs9gey
         i20zdLYqgd27vFmuKbjLgyMtrL6TW1GQxF+LucktLjhiHqprK7OwuDmyJpPwLWpzFb+Q
         0xk46hGpZC28ACrWkaGb9q8PdWdR4KokYlHbMP4jGJ/Cl4ZMd3L+BIrVT2Ju/A7UQffO
         RBIAt7UuhIUCbwf7i9kbATC1JWz3wQIrWgaOXQGyHzcUBiXYlZr6eXtjUOE8NRDBqquO
         xO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1BJUNb3lQRiC5sVIz839O78v77O5TxTS0w+wrputiFY=;
        b=SQnJRhapKd8yMhSJaldEc4saPUzI1dmnER7Jxlv5TCg+mD/iTkBpVjTEApRlhfnfDs
         yAWV2yxsOMaqbf3m4xf2H8whjo1lvltxR0f8/K7+fXiwOkshw2je5hfCdJ/OiOfZRxPB
         3NgZXXyah6GnEVnDlE+6yb2BUGWmx17UZ0V03a9apagOjObSlU29ci4t6aRzEMrVA1t3
         LcQftVAFZ+W/US6c01t6vGQ+IdxS0xc06fx5ZKclIZCrQ7y/gM6WUW/2Y1vdsGKPFUVl
         yscszCv1bMHw451IuAwerWxWMLPeGyiIupQjnstsKcyY5kCsm8WFPJq9LgwtNIHOFBZP
         SELA==
X-Gm-Message-State: AOAM531jj7lu7Tk+ofXu43WkFvyWQSvU+RaFq1aS9QNS6p4nAbOXWYgE
        Tn+3zt5iZOUAXeg0Hw07bnkbu3sk6Kc=
X-Google-Smtp-Source: ABdhPJwyIG813QkkKmak7OLR0nfssCj+IIkArqQ8gFkvNu53wvrM6I1EI1E1fiGIsHpPBsCQyYI1SA==
X-Received: by 2002:a17:902:7898:b029:e4:182f:e31d with SMTP id q24-20020a1709027898b02900e4182fe31dmr23177459pll.13.1615260147904;
        Mon, 08 Mar 2021 19:22:27 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l15sm739632pjq.9.2021.03.08.19.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 19:22:27 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel opt failed
Date:   Tue,  9 Mar 2021 11:22:14 +0800
Message-Id: <20210309032214.2112438-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fixing the bpf test_tunnel.sh genve failure. I only fixed
the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
there is no geneve opt"), when there is no tunnel option and
bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
packets and break all geneve rx traffic. Just set opt_class to 0 and
keep returning TC_ACT_OK at the end.

Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 9afe947cfae9..ba6eadfec565 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -508,10 +508,8 @@ int _ip6geneve_get_tunnel(struct __sk_buff *skb)
 	}
 
 	ret = bpf_skb_get_tunnel_opt(skb, &gopt, sizeof(gopt));
-	if (ret < 0) {
-		ERROR(ret);
-		return TC_ACT_SHOT;
-	}
+	if (ret < 0)
+		gopt.opt_class = 0;
 
 	bpf_trace_printk(fmt, sizeof(fmt),
 			key.tunnel_id, key.remote_ipv4, gopt.opt_class);
-- 
2.26.2

