Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98972509450
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383519AbiDUAxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbiDUAxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:53:15 -0400
Received: from mail-vs1-xe64.google.com (mail-vs1-xe64.google.com [IPv6:2607:f8b0:4864:20::e64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D1FD37
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:50:28 -0700 (PDT)
Received: by mail-vs1-xe64.google.com with SMTP id v133so3142962vsv.7
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:to:subject:user-agent
         :content-transfer-encoding:message-id:from;
        bh=LWwI/BH/zs2PRw3S4cSl2rzpqJDY2RDYVUt6dkvsFts=;
        b=J9LRPrupXwurpDK+q2WrGfoHHxe1IoZj8AOWRHx/39OwShdQAzwu8lUbtLgEz65SAi
         pLWXPjvGYv/xP1MoVO1EelEuHUYPPL2BvCaZ/HDawcXP36gEI93S5aI5BhjH3tLHkHdA
         EVvao3pFpg8fiTlOeNyZpxSjUB4asKgEe0J7na5KHwW45GlFVEEGMz+vhdSD+649rsCT
         9FEp+/DCCPYTDAK0WbJ660TxFnlb3kORHgO+tZq3RCcosVV9CKfSzrNg3gj3ewsVIt57
         6v0HQHkfmfsZKzFRADyZ3HYVE6zAhjlEARhAMuafzG+ZuCS/yWee94XGDKo/bitp+Q3l
         6NGQ==
X-Gm-Message-State: AOAM530Vc3K5qFQFC4bdBCdIIowIARcY2KMEDHT1plcAYI3bAiDvTlkf
        gj1tGEy6whVNMMgsII27T2PmN4lRRwH2S535SWT0ERlAqJG+
X-Google-Smtp-Source: ABdhPJyx6JAyhWnwk8dFTXuMp9aOxl0jWB4NUgPircADTj8bfDwnEJh0lEtqyaEjDlkH/FqSpr9mgZ+oqwCp
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id v20-20020a67c894000000b00324c5daa9b5mr7816833vsk.33.1650502227526;
        Wed, 20 Apr 2022 17:50:27 -0700 (PDT)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id x15-20020ab036ef000000b0035d3d7f148asm404575uau.12.2022.04.20.17.50.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 17:50:27 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from us226.sjc.aristanetworks.com (us226.sjc.aristanetworks.com [10.243.208.9])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 8A460509630;
        Wed, 20 Apr 2022 17:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1650502226;
        bh=LWwI/BH/zs2PRw3S4cSl2rzpqJDY2RDYVUt6dkvsFts=;
        h=Date:To:Subject:From:From;
        b=dlEfqT+bunv39xlhI4BWZj3ZFE2fBZRwOljFenOnq0kVMO5dgZUvvoqpPNUpt3j27
         3MwqQJdRXQ+5uBrapZF3vwa7f88Y0gKgk1dTbRHIZ2EC4vWdgKr+ohlqCb2XdAHr8M
         feM/14h0lZe8PpqWOlaYO0MZOuGiTaekvbO6aNG2AXrDO6DQqyiEvJphKtp9CH9Te/
         aBEFQNSAYCPKNMnoOMDF3hK5uRwi3b/9P6p7vt71AWwUwG+a5ljbq05Oj3xGpZrWad
         HMVEaR/BglSTorvNgSoe+fItLi9YiiNx/hYOsvPQWl3+sDOMaAZ3/H0DLxAvfd0EA3
         qgrh5v1ko5hWg==
Received: by us226.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 686A45EC01F2; Wed, 20 Apr 2022 17:50:26 -0700 (PDT)
Date:   Wed, 20 Apr 2022 17:50:26 -0700
To:     pabeni@redhat.com, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        fruggeri@arista.com
Subject: [PATCH v2 net] tcp: md5: incorrect tcp_header_len for incoming
 connections
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tcp_create_openreq_child we adjust tcp_header_len for md5 using the
remote address in newsk. But that address is still 0 in newsk at this
point, and it is only set later by the callers (tcp_v[46]_syn_recv_sock).
Use the address from the request socket instead.

v2: Added "Fixes:" line.

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6366df7aaf2a..6854bb1fb32b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -531,7 +531,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->tsoffset = treq->ts_off;
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
-	if (newtp->af_specific->md5_lookup(sk, newsk))
+	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
-- 
2.28.0


