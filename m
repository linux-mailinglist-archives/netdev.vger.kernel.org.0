Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2A91CB1BF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgEHOZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHOZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:25:51 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0A8C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:25:50 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g185so1679648qke.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=onechronos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=nCLzDktolbOeGOlHrqXDzfbniXrQbZ/c/BBOGy4Pd+E=;
        b=0drYguSmFRDjeXvdIdBKyXSuPIjH41nGfb6ous0wUue28CNWNUQlmpkF+vpbyTTzw0
         Lik1hNKlBi1pagAQUokfinWEPqpt92OV4bCNz7j+yATNJMIA2zT7BWQGcp6cJvjPlhuI
         ME4lhQQj4lx2bZnDpfDU9dXHscImeSVvloC2Ug+M+oiUjM64uYvW9CqsWU/+SleCp7p6
         ioISnHuJEXAye0/IN6Ew1PsEb5ABO4DLqxmTs5KIcYBjEHeRf3d8V6UELRz/vdd/fxyt
         TPfcdT9ckfwgy2dIaXg66yyYCVIfBs0Q5lDTBMQXtWdwOrm6NoWQdcAQOxT4MI+ZszCf
         iQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=nCLzDktolbOeGOlHrqXDzfbniXrQbZ/c/BBOGy4Pd+E=;
        b=a5EE6mVDp4NhewyIhI7Jqti7GsXnMEmfUlAuwpoVvbJcDnJQY4OYw5Zj7InnxeNoPm
         A98c+990Cmk0yzGqNSgHi77n9ygS/TvIdWSl2ZKUMpUhCmonyUX5S+xgoKEPadxeIYv1
         geI060Je5Votemm5JDQ7cFRSw5O9N4xGBa3KOlKeWTIEjOsS3nU5rNkc5laS7UfqlFhC
         6cFTTCWil357uJ4qtU9ICGhADdClhsB1jNX2zCU5ku/uSSFy9zFZ8T3iYntZnmMx5ARt
         njQijSbglSiidBeqCqfpIllu/1x84pkA2QyiktkROGsSxigQ5+ugXXwgscLERfxbVyUW
         6vDw==
X-Gm-Message-State: AGi0PuYwHIWrzPnz0tQBvpretlm3C0XRarPgGEq3B7S7pyM1KJ2T84tv
        Ci43sUNrel81bqkr6dbq0lIPskiA8isUhmHnCg0XN7b+6BLp5OfiowB3ioba0oZ/krtid1Zr+ks
        w9YWTKt7F9dmcnu3CwsJWKuXdeRnc8YrNhNTNtytPjFbSuz7QOlYgnqbSNUOK8TN1kpcoEQa4NR
        SjGP1GiNwSNLbkV8l2OPxvy0zb+qimeyu3khxPx8TH+TW6sA==
X-Google-Smtp-Source: APiQypL0kAZcx4x6Kx/Z+azOfnloiHHyhfbByA5Ia+2iJkexFhY8HZMaFi6F9I1QXzEK/t2DeucCjQ==
X-Received: by 2002:a37:902:: with SMTP id 2mr3076206qkj.83.1588947949851;
        Fri, 08 May 2020 07:25:49 -0700 (PDT)
Received: from localhost.net (c-98-221-91-232.hsd1.nj.comcast.net. [98.221.91.232])
        by smtp.gmail.com with ESMTPSA id z1sm1261097qkz.3.2020.05.08.07.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 07:25:48 -0700 (PDT)
From:   Kelly Littlepage <kelly@onechronos.com>
To:     willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iris@onechronos.com,
        kelly@onechronos.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        maloney@google.com, netdev@vger.kernel.org, soheil@google.com,
        yoshfuji@linux-ipv6.org
Subject: [PATCH v3] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Date:   Fri,  8 May 2020 14:23:10 +0000
Message-Id: <20200508142309.11292-1-kelly@onechronos.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
References: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
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

Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
Co-developed-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
---
Reverted to the original subject line

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
