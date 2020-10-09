Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8463C28816F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgJIEom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIEom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:44:42 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B942C0613D2;
        Thu,  8 Oct 2020 21:44:40 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b2so8061765ilr.1;
        Thu, 08 Oct 2020 21:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4gkE+w1Qs8ezFeaPKV2wW5bemZHCEITfhAmzV/zUEPU=;
        b=b3P2FnpJl0G4N3eNTHIa7386f+S200GCO0E87U5tc+/SDDtl1eQrtN4/Oot3DrC8qg
         rnLKKziRVwMJ060N11NXOxgAta0x8Nh0GKlVZd0gyLxNKagmGJIQ7aCx5IxIXPFyE2mH
         Z0ZXdWJ1svMf38M3pUI313RcqbAGXWuFAjEQACEOOoKhZJ7Yf0QebFRy4iCRST8HA1bG
         GEuzHKxyh77iOP7PaQlDoMdqzYYNqZ8yl/n+hol4pGsa9r6HeXQSNujaZeE+owiFAcIr
         IH/tnRkf3Qykq3CaCz8cpT+jCYH6uiaxkBNefzspEsrs3v8QJffhi1CEbSq5ncbQ99GC
         xQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4gkE+w1Qs8ezFeaPKV2wW5bemZHCEITfhAmzV/zUEPU=;
        b=LYTo/Jn9O7CbK8yyHkjw8xjMKlL4/jKdwhG2d5u6ggLIM+0VoSdQh1+Nn6Nvymp/M1
         Mvs/l1deLohTILRuABHM8f8afdmUXgcBSdK4ilC/Bf4LmicTx8iAEuXUPXR/pFRrF8Kk
         yYMZacId10wil4R8NMkbggMxRMhq/SuRu1k/2yMPVD9CmzcP3xGPqfIlcrMVo2wmCdnh
         xHm4nINlmLf11yqqWNFsZH8z6sRg0e41P+kufvGolPalpKLWb1O6lUZKN+J9O0wr6t3Z
         Zz5PFn3A8PIJM7D0uPYdxd7kcCvycbu6EE0OT4DcEstquMzNeWTkXihOLOQ4MmtcESpb
         8EtA==
X-Gm-Message-State: AOAM5324kna4Fa2YPqi/e8Iagf74TYmJo5eE87VMirLzMXwZ6O4pv78j
        3V12SAEltFjNzPsEnl76qGs=
X-Google-Smtp-Source: ABdhPJzestMsc5QVbsSnDmT0bWIdMdmlSBWT3wc6i5wwOOCnKa2pcKYMsHa3q8JYiy3V3VI0ClDgXg==
X-Received: by 2002:a92:c5c2:: with SMTP id s2mr9542412ilt.177.1602218679884;
        Thu, 08 Oct 2020 21:44:39 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e15sm3608786ili.75.2020.10.08.21.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:44:39 -0700 (PDT)
Subject: [bpf-next PATCH 3/6] bpf,
 sockmap: remove skb_set_owner_w wmem will be taken later from
 sendpage
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:44:27 -0700
Message-ID: <160221866732.12042.16556499859895432372.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb_set_owner_w is unnecessary here. The sendpage call will create a
fresh skb and set the owner correctly from workqueue. Its also not entirely
harmless because it consumes cycles, but also impacts resource accounting
by increasing sk_wmem_alloc. This is charging the socket we are going to
send to for the skb, but we will put it on the workqueue for some time
before this happens so we are artifically inflating sk_wmem_alloc for
this period. Further, we don't know how many skbs will be used to send the
packet or how it will be broken up when sent over the new socket so
charging it with one big sum is also not correct when the workqueue may
break it up if facing memory pressure. Seeing we don't know how/when
this is going to be sent drop the early accounting.

A later patch will do proper accounting charged on receive socket for
the case where skbs get enqueued on the workqueue.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index dabd25313a70..b60768951de2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -728,8 +728,6 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	    (ingress &&
 	     atomic_read(&sk_other->sk_rmem_alloc) <=
 	     sk_other->sk_rcvbuf)) {
-		if (!ingress)
-			skb_set_owner_w(skb, sk_other);
 		skb_queue_tail(&psock_other->ingress_skb, skb);
 		schedule_work(&psock_other->work);
 	} else {

