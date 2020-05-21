Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7711DD805
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgEUUIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:08:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFA5C061A0E;
        Thu, 21 May 2020 13:08:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so3762282pjh.2;
        Thu, 21 May 2020 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=h8798kykb/Brr0NlbljMYDJsYj/j/qJhu/3+WCso6Tc=;
        b=epK5J1uYN8YNE1E8c45S1rfMeYoE9cSTW90L3IUND9tO9Cwc1fBXdpPKsLJaBkDrv7
         y//y6K7X5ulv5pyFdWtvoetaBqXr8HOHUcuBMJwYOxU4+Hh0lgwbJPTP/s/c7WslMJ++
         S2CMNFD8vO6oI/Qae/8/v/zjirc5Ah0J0ZFxz40logz/oaC2RLALGswil0zdzavXD3l4
         a9jZwSX5s01F8X0ewk0bna/9CQF/nd7DU5EoGOwXrHyjva3L0otTBYtO8JUSU6dV4/qF
         TkCzFO9fdK/9hgQoVVjbYq9S91MzvWUT9bkwtyvjZQgYUEsIEYNrnncErc0rUoQFLPt8
         T3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=h8798kykb/Brr0NlbljMYDJsYj/j/qJhu/3+WCso6Tc=;
        b=YgiIFsE5GBFdLZHqhNBINMNWTVumaWUMDqW/D/yXFr9sdfcwnwiVleFEewXP+KPc6u
         FTgX0cXYDcTjRUBAkbNua168eP6Ij0lDhrDrLKy/i5RLY6mAtliD4JAo4o6CMkqj2efc
         ik9tQt3oG2Ygx4Q4xq0nwZ6JbUUx2nrBalXwtlcFWGwKUbTkO5HxQdAXa/cOL3bjscF4
         WARIA7wMfLKGUZh1dTM+kdcT9ySLsordSJpd4i+le4e+UDst6gkq/UZQPVJ4Z5cQtOGT
         z9BPtXqLQX68cHBltCMuRWcunK0mPtqsbBW+HqimJqpDINBWBvoQDA2dDbxOCgKQkbs1
         SNog==
X-Gm-Message-State: AOAM532flEAz4zwQVMo7P9awZ2zlW2rEjEg1Xg+tLC9UvYBzpAGpOEdr
        +K9bsa9CPtKx9VVqH701w2Y=
X-Google-Smtp-Source: ABdhPJz1V77OVN0A5a85/y8hSJtTxsg2bQYoWCIKXLOdNkY3bFJYHAhYGXtpvXMmkCPcmz7w6N2JBQ==
X-Received: by 2002:a17:902:b68d:: with SMTP id c13mr846910pls.210.1590091720009;
        Thu, 21 May 2020 13:08:40 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q3sm4364649pgp.69.2020.05.21.13.08.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 13:08:39 -0700 (PDT)
Subject: [bpf-next PATCH v2 4/4] bpf: selftests,
 add printk to test_sk_lookup_kern to encode null ptr check
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 21 May 2020 13:08:26 -0700
Message-ID: <159009170603.6313.1715279795045285176.stgit@john-Precision-5820-Tower>
In-Reply-To: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
References: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a printk to test_sk_lookup_kern created the reported failure
where a pointer type is checked twice for NULL. Lets add it to the
progs test test_sk_lookup_kern.c so we test the case from C all the
way into the verifier.

We already have printk's in selftests so seems OK to add another one.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
index d2b38fa..e83d0b4 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -73,6 +73,7 @@ int bpf_sk_lookup_test0(struct __sk_buff *skb)
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
 	sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
+	bpf_printk("sk=%d\n", sk ? 1 : 0);
 	if (sk)
 		bpf_sk_release(sk);
 	return sk ? TC_ACT_OK : TC_ACT_UNSPEC;

