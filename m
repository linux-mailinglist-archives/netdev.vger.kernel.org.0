Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327891F73B0
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgFLGHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgFLGHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 02:07:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8309FC03E96F;
        Thu, 11 Jun 2020 23:07:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so3225318pjb.5;
        Thu, 11 Jun 2020 23:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JEvUUzirrseeTgZyQCQj6IhJaMAfwmJ6wJglPFtIGDY=;
        b=GqiItGxEX8++bQb6zbVj9Cn+NBTVFDaXRPDlso+VvCigIG9NEsk6x9CCNr7BlxmxGo
         ib8zzELIsm1PI9EKOO2okeTgH6pGQ0E9Nf0vaGgVeCoFWblMFGcmjKyDjTSDL++c/+2M
         t2iX3GlptrM+anUdCphOGeJ1ePRRqPw7nM2TjFgAeAfgXR1A/AXzI5arGaqvy5+apQ+P
         nFmijyHaiadtW3KA5BHxwf4wYqvAKg2ndBQzeF825qqyiMjTGSoEpKXLAiIf4e8eknho
         NyC7E+IPQTC32ul7EziR3Ia2RR/I37tiTujejehjhhpWMaNrtlF1b6tEHcMT1LMkZAOB
         7kfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JEvUUzirrseeTgZyQCQj6IhJaMAfwmJ6wJglPFtIGDY=;
        b=idTwzkBkvo+lCbtFfWSP+XH6KHc0psCxVIUvdJnany5CuhhGAfEmtnu4YqWtb0d2L4
         e9YHV6RPcfkmINUY38952T/tqyfyYReh1aYACXuhpUh9Iaq+NfDTzIaNOZhTEo8y8xmy
         6mxjbRDe5021yQm2yuAl7FyDv48nygeu2HjHjFtUSmYGxbBS7PoSO9gCsKlxNmpDoJJ8
         Y6znUAaMBdxdMOCbBwjvU1lcDl9My0vyaGrPZdAOoko2Y2Ej3jr+M1EXhjCYLBzKS4jC
         nunUuKaV1j2Zdm1b7cJcRYB5hfg5GL2e+VRO1F2fQL85s/CSoRT5c8L3/LeM83tUb9uG
         O8Qg==
X-Gm-Message-State: AOAM531YjYTeGtAy28MMwQ2GfG0qtmRKEZCLUXv+QGk7VI3NrFQtxmmq
        ShMMZ2V6EeavZQ6cvjRLkjI=
X-Google-Smtp-Source: ABdhPJwlwIrsbAmyWazk7Coz2Lk2SYiWLiHCF1bdWmovTv77Ds46gqIwP/z7hQRyEiINklZ1KqKWIg==
X-Received: by 2002:a17:90a:5e0e:: with SMTP id w14mr11458586pjf.128.1591942068165;
        Thu, 11 Jun 2020 23:07:48 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id g19sm4808563pfo.209.2020.06.11.23.07.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 23:07:47 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mptcp: use list_first_entry_or_null
Date:   Fri, 12 Jun 2020 14:05:34 +0800
Message-Id: <9958d3f15d2d181eb9d48ffe5bf3251ec900f27a.1591941826.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use list_first_entry_or_null to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/protocol.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 86d265500cf6..55c65abcad64 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -234,10 +234,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (list_empty(&msk->rtx_queue))
-		return NULL;
-
-	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
 struct mptcp_subflow_request_sock {
-- 
2.17.1

