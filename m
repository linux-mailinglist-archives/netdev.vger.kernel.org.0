Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB3928913D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgJIShO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgJIShL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:37:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44998C0613D2;
        Fri,  9 Oct 2020 11:37:11 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l8so11039266ioh.11;
        Fri, 09 Oct 2020 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4G6r6URW9FykMvUhJ39nieM0iVhRm4HwhOKU1HTrCTM=;
        b=OAtH2fZawxdfViRetetKOrBvPK4Dl80F6ldjO2RIvbT33Pxk6ggv+tespKTrDRcY5u
         OyVx+gU0mocGi3SAWCraSQteQgc5cLoHYlf6vGtGEgfIBUIXztpnFYdMcbF1qDn88hL/
         QN9w0vqLGCGDD3zP72ybu3brha2ujLC4eCx8vkzjZ44BBM40Pbq/zMr1v4+R2vHI6hCo
         SKzBfjOL5NqqCg4VlhQryjrs4NtGZRIkCo0vtDqRYrNZovlHGmcABj3mryKUT+EMeoIb
         uiMkCiXtzGCifJNoeQTuCmYJl1C18cm1fQB53bGGWkl6/tmTkmvP+D4UE+I0cQZH/ebS
         Cd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4G6r6URW9FykMvUhJ39nieM0iVhRm4HwhOKU1HTrCTM=;
        b=uUjTHiyH+VWdu32Rk+Dktcf0QVwo+bptiE5XpPGxKWIBMHAXCYi1reD42j/uR4eKKV
         pN22mkpCDjUBRnYLX7y64daphBSinpMvwVshmGMxnVxgM3KayYceQYe//vrHruBm3ePO
         dxCkm1K0wnoTClPv1sh7DP6Dic06veQNNghepy3YU0PZ7jl3/n+v9V9IXuJYc2UPXLzl
         kG2O1HQlHEq/SRDhBQRiV3gMVV3NB/7DvUr2Kc961iMmjiGVLtu9OA7C3hnjUnuIQF1Z
         xDk/lV2KeozpHvJcY8raAOvWDkZPDFoiiwOdrr0x6hhzJsAvclcCQYmoADNzCNntPvnH
         f4BQ==
X-Gm-Message-State: AOAM53316xSr17rN2AuScvqvRmH5XnQhI7TvhOWUMvNTKNxREVy3Xm+D
        mgcVCc1sAlYqXQ94qR/E5c4akvWUAt9Ilg==
X-Google-Smtp-Source: ABdhPJzkicdBFXu3L0UhQ9gPkls6GWkrUA3tvWT0d9A0nxJwAxLSOSG2bDSTq/5Q7QEUXDJgXITU5g==
X-Received: by 2002:a5e:9613:: with SMTP id a19mr10045968ioq.116.1602268630618;
        Fri, 09 Oct 2020 11:37:10 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g8sm1623906ilc.39.2020.10.09.11.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:37:09 -0700 (PDT)
Subject: [bpf-next PATCH v3 3/6] bpf,
 sockmap: remove skb_set_owner_w wmem will be taken later from
 sendpage
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:36:57 -0700
Message-ID: <160226861708.5692.17964237936462425136.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
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
index 4b160d97b7f9..7389d5d7e7f8 100644
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

