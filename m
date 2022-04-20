Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3761B509403
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383335AbiDTX7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355420AbiDTX7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:59:49 -0400
Received: from mail-pl1-x663.google.com (mail-pl1-x663.google.com [IPv6:2607:f8b0:4864:20::663])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A123B2AC
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:57:00 -0700 (PDT)
Received: by mail-pl1-x663.google.com with SMTP id c23so3290374plo.0
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:to:subject:user-agent
         :content-transfer-encoding:message-id:from;
        bh=cabBHowk07oUnQRoZ+JOkWMaGIxjcsUNAYkcyps7474=;
        b=0xQivewDu/pfoy7LNCCiGE3aJ3LLr8ZB+8QVZwjmQQqmDxk4lr4HNinxMp909vxvKR
         1gJgf9xyR/fjGgwbZrrieUuCEUieo6PQ8Hthd7koDswuLpt6Fq2c6aKUkwr8YESysVRG
         cJ/gE78jfPBLSU7mVewQjcZzvmj49clK7h/1YUvaY4E/pRPG9WygnNrSdQA8dnSq+rD6
         htH+32CvoN8AGkXcGnfTkcymwtqGFuwzxob0mQC/+6rTR18TdDSdeSmwq+cNnQrM5Y0C
         zc0Wh8lNn8J2PU0xGoAoxPz8CaVerY2tjTCB4TVMmyOE9pqB0AaE34Oe8gAH2NrL6pOt
         ydWg==
X-Gm-Message-State: AOAM533O6TH7viomrgEuTAwFhU96+GOcgNjKNh6JunxZ0zr5xEwbL2F6
        EtqMvgTdrPaTeZlXgXfduJR4eh8Q9nGSCRPHqL3mYWKWoP8D
X-Google-Smtp-Source: ABdhPJz5sQOTT40Pi4MODlLH3Ns+UE/Rkl3Qn7qK/pZnLGy6gWay8SFoISVHcYSHc4JyCpCUTzbBnvRE+Wnp
X-Received: by 2002:a17:902:d344:b0:158:408c:4d5f with SMTP id l4-20020a170902d34400b00158408c4d5fmr23163975plk.122.1650499020024;
        Wed, 20 Apr 2022 16:57:00 -0700 (PDT)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id l12-20020a170903120c00b001569d32d9f6sm823324plh.60.2022.04.20.16.56.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 16:57:00 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from us226.sjc.aristanetworks.com (us226.sjc.aristanetworks.com [10.243.208.9])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 9C8C75088E9;
        Wed, 20 Apr 2022 16:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1650499019;
        bh=cabBHowk07oUnQRoZ+JOkWMaGIxjcsUNAYkcyps7474=;
        h=Date:To:Subject:From:From;
        b=eZoqAaOQskRlf9TLPEYx030mT56ZDxW9XtD+2SFaFBdJjCEVKYhT46iPcYtyl0S6F
         Utzx2mfmpDefclTIsUR9A6PRGfCR4r3eMJZOvIV1EzNcZX4LfAUT6Ua7LNUEpsG52g
         APWk+UP3NfvheRPXYshfpIDlqVY4D9EvjgfzcY9burbtSu3H7mot4FRA3QickLWqxj
         wigBRKuutEl20GkQNfy9k6FZT6OgZB6G9RApXGXZqeKTwlonsip2fWgliRFVZCCg52
         m0LXFoAN4f4+7WECzc9cQPKZdTlTNI5WgdhuH2mkRknB1HvBf7QDuhqQV5OOMIswxC
         i40hwPkiON1Xw==
Received: by us226.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 830155EC021C; Wed, 20 Apr 2022 16:56:59 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:56:59 -0700
To:     pabeni@redhat.com, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        fruggeri@arista.com
Subject: [PATCH] tcp: md5: incorrect tcp_header_len for incoming
 connections
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20220420235659.830155EC021C@us226.sjc.aristanetworks.com>
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


