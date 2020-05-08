Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D931CA006
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHBS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEHBS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:18:26 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C883AC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:18:25 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ck5so2451qvb.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 18:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=onechronos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gyam74XnjQY/UtgneuaLJbRAlmc5L3Wl5OJCC8E3rW8=;
        b=30BiKMVhk8WcrNG75ci8MlB41Csl9yAWc/QFeoTwA2Y1O91AC7dtp55+Fbj2/y9Anj
         z0+QfvXSDopVmPmSf9JD2uLR9vGV1a/lj9VobQbvefNDPK4pjGzwI0ilcxy/46YZcqsB
         Wk6VK9emsSnY9Qy71mhq9deo0Btv+tv8cr9wYSL1uJ9bpJ/nt+5FjWp3TLL+bqXFg0Ng
         fBpo3auczxsyj1e2bTbUk4EJ7yPH6WDr80TDZhk88QJTLWgFpEXQp7oHs2FSY0SSk6Mq
         GSNxBW4LXIXLm6SSoKzXcndrLiU/6xBhG01hcSLS2Mkynr+Ab3c8QaXKtcv5exrcC47V
         RHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gyam74XnjQY/UtgneuaLJbRAlmc5L3Wl5OJCC8E3rW8=;
        b=nJmudhipOecWuXIEdBrRl8P+bSWGLHRlOM3mB1KCVMEB8w3O6hM1v0u3UerOAj4aks
         1JVLCSjtiJLJVWEGvFvsBsOMtXED1zOZhQbs27J5kBI1owVeOkiZRJ0dBH3YGBHsqixd
         6JCdSW+R92CiBXk0VjHApt6TzyiJpmkLhh31WZ/CJmobBL2w7hTkZtodtCMyZs4k478y
         SdUQXF3zBOWxZMGsMpwvSqqTvrvWEci/rz8mc0RFbC3HJG73EACgZtHh33IwFyTUwkRu
         kZ9gbwggAvKZt7/PXwixMwo73Cs31e+f22vKehnh8wpRQHEshs4VTz6F7hjBg2kMPrI8
         JHAQ==
X-Gm-Message-State: AGi0PubDY1mlhpmF0mN4TQZt6XddScU8c9XZjCkCdodjJcCXP755Mdaf
        I6PkttUkVkxO5ydFv9jgnw6I+RBL2/wpnJxhjQIwofxXoCqA3hbs7YcDIyWS20FDf8FWudNM9Ds
        CjRR8SchbyM9zXD6d90XSQMrtjsu+mo/ARDG/jYjBL3qPE0cTIlyKYZtMfmcQ/ec3F1axKLZ5X0
        QmZVtKzcjXI+CgVVOK6ANFvZkm5H70ZrxzO9WtAxXesBMANw==
X-Google-Smtp-Source: APiQypIQbauUvp+XMTR0ASaXBXw/23lM6JHciIUn2Bb1uCdn5SzpHRfNNTX7Htely9ve1gyb+tNZ8A==
X-Received: by 2002:a0c:e14b:: with SMTP id c11mr379349qvl.184.1588900704941;
        Thu, 07 May 2020 18:18:24 -0700 (PDT)
Received: from localhost.net (c-98-221-91-232.hsd1.nj.comcast.net. [98.221.91.232])
        by smtp.gmail.com with ESMTPSA id z65sm67402qka.60.2020.05.07.18.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 18:18:24 -0700 (PDT)
From:   Kelly Littlepage <kelly@onechronos.com>
To:     willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iris@onechronos.com,
        kelly@onechronos.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        maloney@google.com, netdev@vger.kernel.org, soheil@google.com,
        yoshfuji@linux-ipv6.org
Subject: [PATCH v2] net: tcp: fixes commit 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
Date:   Fri,  8 May 2020 00:50:21 +0000
Message-Id: <20200508005021.9998-1-kelly@onechronos.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CA+FuTSeDRPh2XEa6QnKYX-ROdBEhaQ0W-ak9z3npZKn7mQuHyA@mail.gmail.com>
References: <CA+FuTSeDRPh2XEa6QnKYX-ROdBEhaQ0W-ak9z3npZKn7mQuHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stated intent of the original commit is to is to "return the timestamp
corresponding to the highest sequence number data returned." The current
implementation returns the timestamp for the last byte of the last fully
read skb, which is not necessarily the last byte in the recv buffer. This
patch converts behavior to the original definition, and to the behavior of
the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
behavior.

Co-developed-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
---
Thanks and credit to Willem de Bruijn for the revised commit language

 net/ipv4/tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377..e72bd651d21a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			tp->urg_data = 0;
 			tcp_fast_path_check(sk);
 		}
-		if (used + offset < skb->len)
-			continue;
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
 			cmsg_flags |= 2;
 		}
+
+		if (used + offset < skb->len)
+			continue;
+
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
 		if (!(flags & MSG_PEEK))
-- 
2.26.2


-- 
This email and any attachments thereto may contain private, confidential, 
and privileged material for the sole use of the intended recipient. If you 
are not the intended recipient or otherwise believe that you have received 
this message in error, please notify the sender immediately and delete the 
original. Any review, copying, or distribution of this email (or any 
attachments thereto) by others is strictly prohibited. If this message was 
misdirected, OCX Group Inc. does not waive any confidentiality or privilege.
