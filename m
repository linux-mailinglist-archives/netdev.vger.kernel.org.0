Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8A8263FE3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgIJIcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbgIJIbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:31:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C71C061573;
        Thu, 10 Sep 2020 01:31:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j7so563707plk.11;
        Thu, 10 Sep 2020 01:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7qt3/l6N2AZLqaqvzhij+GOrBrkyjnxL/cc0fShcUdk=;
        b=Z2AL50nn/FtLTyGy4R8nWtAT01imkaha6rroHgeaFmDYp/+B6tp/hZawK4cCI4+I0R
         9EakqKXdEGBc5cv41G+qLBZ3lvIFomJD9axUcrcofb+EutCM4Lx6jDLBJmw+wZya6UJm
         LCWRE3N7qWRerpDiv9ykg5l0i+eeusSZfQSqJ1wz6mZGT0ORJCNhUSuJi4+ObPoRw9Pu
         gwFIXwPr8XKE157hRXFKWJ28wLCiCRQKccgKd2v3R11/rDQD2cj3Ef5itZUKUQHNpgcb
         Nn3HzUdhrKZ0OERL1bBen+sUSEy2y44q4lem9RmzHRhFYzRIWGUH1k9AY4TjXtMGlIth
         TV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7qt3/l6N2AZLqaqvzhij+GOrBrkyjnxL/cc0fShcUdk=;
        b=irJKYMW3cO+HWN51WRZLZx5XLIAFX5gfA1DVkJp7RZSpuNXbXhm/6bGLAVS01EA+Lk
         UksYdzlD1b1faqsiCp10ZjdGiQ69NnTNncV9NTi3I3PF7clBd3dnZ/08c3VlHesIUV2j
         QXpalrwBaRhHqtaf4ylOloowbqY0k8IPuPgpzE1J+qi099Fy4X3flBfR945aHUWOjh4D
         WBXMPBYK9V0JcYLmhDEZXXtWEbaDxSx45dMxgPESk9pgJvpkjQ5dr8ohOHV80GhIhQG1
         mOFUMrkiN6SB2Sc5m04tSBNCbVA1Uwkq9zwQalseeDSAER8ZUgSw0BcJ+xIYjXmGytw3
         eWZg==
X-Gm-Message-State: AOAM530gGSF7scOsm1m0iPjBVY0bkxKJjsVoVAJ6USkOSEpYVem0IVp5
        MZGequ9S4GPukEbrKEe60Ls=
X-Google-Smtp-Source: ABdhPJz297VamGf6+zuAL4AKKDvvUPi8m0yGDADgStOcR9lFJOGM4ZSI5pEZ4G3Adqkqzr+vENjKLg==
X-Received: by 2002:a17:90a:4d47:: with SMTP id l7mr4297027pjh.30.1599726682871;
        Thu, 10 Sep 2020 01:31:22 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c7sm5183438pfj.100.2020.09.10.01.31.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 01:31:22 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/3] samples/bpf: fix one packet sending in xdpsock
Date:   Thu, 10 Sep 2020 10:31:04 +0200
Message-Id: <1599726666-8431-2-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
References: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the sending of a single packet (or small burst) in xdpsock when
executing in copy mode. Currently, the l2fwd application in xdpsock
only transmits the packets after a batch of them has been received,
which might be confusing if you only send one packet and expect that
it is returned pronto. Fix this by calling sendto() more often and add
a comment in the code that states that this can be optimized if
needed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 samples/bpf/xdpsock_user.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 4cead34..b6175cb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -897,6 +897,14 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 	if (!xsk->outstanding_tx)
 		return;
 
+	/* In copy mode, Tx is driven by a syscall so we need to use e.g. sendto() to
+	 * really send the packets. In zero-copy mode we do not have to do this, since Tx
+	 * is driven by the NAPI loop. So as an optimization, we do not have to call
+	 * sendto() all the time in zero-copy mode for l2fwd.
+	 */
+	if (opt_xdp_bind_flags & XDP_COPY)
+		kick_tx(xsk);
+
 	ndescs = (xsk->outstanding_tx > opt_batch_size) ? opt_batch_size :
 		xsk->outstanding_tx;
 
-- 
2.7.4

