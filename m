Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C61289064
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390258AbgJIR61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:58:27 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CD8C0613D2;
        Fri,  9 Oct 2020 10:58:26 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o9so5404208ilo.0;
        Fri, 09 Oct 2020 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Kyq+/ml3RrM58lYJGjEIbD5XFfST3owwENK8V6cBEBY=;
        b=SFWceBkjvvW6Qz79FDVrebFdr9ZI2US3XN9YlfwbjojtCTXRz05RcLjHdjlM1SIGh3
         Dn8iCEV2RgrwEXiMqgqhOlYyr3gncT4iEN0jmh2vlJ7s60hQQa/+ELAh+g2/4cxFsj/M
         wBI/1K8B6jxUCCmiWyzN3wRY+DGiWG9l13+qjv1mSJrD2KJxGCUf1XvViISKpGfPsfwd
         B7eWWZKssuXpnIn5n2rg9rQdx8gOGoNnISOu2e9p8RPQu0dEYjfsNWgP0eRNEL41OU2m
         HlXTVlNFSVBdsZGBNh1KdWkW2T363twOgW+RG3CUJld3a7lfRdHU/jApDlhzEs4oDJY8
         CILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Kyq+/ml3RrM58lYJGjEIbD5XFfST3owwENK8V6cBEBY=;
        b=JyiRdu/Nv+D94gf4n8wX9GSoQrSieSSHPP5CtvUUlOHHavSHYpT5i9xtwSb7tJa6UY
         e4mf4I5hyWFapErYVZgIISNQal3QB3NH2duAkEsYrBJU4PDkE+LM2WoZpaiPBHTnfA9b
         QbJtow5Muul5XZfjkH50mxJWmOefbUJQ82q2QlmMbwV2u9Jxtc5+ur9MfVVx2Tjllj6G
         dyxbMzs6CKApcoBw1rg7IYY4vLx8lLngbGCH9AUfcr2gQjGMNOvNpic4WBxJhyzXuOmp
         Ncs6Q5EDYFgG8uabIxMVxr1j4KXO38707dHDmeHzTpJdTy0ycr9pP8O4EH4d6b2VpLW2
         q2kw==
X-Gm-Message-State: AOAM5305PAJ5EwE9bYwBn4AeLOM1c5Bc/YISkBhdN7CBzLNle43VqyN/
        4DiMS145KbpNXbBvYJNunSk=
X-Google-Smtp-Source: ABdhPJyfQayNnW4pOPMAQWhriZkf9JTyL4SM5RjFJxlKnWxU2xiJvn2gJyqqBZLwxufVCTLBmTxk4g==
X-Received: by 2002:a92:d4d0:: with SMTP id o16mr9683307ilm.152.1602266306260;
        Fri, 09 Oct 2020 10:58:26 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v18sm2823134ilo.52.2020.10.09.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:58:25 -0700 (PDT)
Subject: [bpf-next PATCH v2 3/6] bpf,
 sockmap: remove skb_set_owner_w wmem will be taken later from
 sendpage
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:58:14 -0700
Message-ID: <160226629445.4390.448415070225757849.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
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
index 455cf5fa0279..cab596c02412 100644
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

