Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2D46A4806
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjB0Ra0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjB0RaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:20 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D04623C6E
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:03 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h14so7064010wru.4
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wv98y8dQ5akEeeGDMXXhLyBc+qsUn14H5JhwBcLUMC8=;
        b=ypFkDG8GwihaWq3wQQ0dfXIFbK1saigQkWJ6G37ZuynA5pBPyddMjIr2OLdiLj4t7T
         uRysDcqk7QBJbpMAl37INfvGgyve0VFS52g2zZt4tI2hr6WUP/FXbytgVmKTXme/zq6+
         ikTusHmJWpPKmz8NbE5MElYYe28l2oshnYnxulyqWyFPGHQpS2fUpG9FYBA7qpGYkfLu
         i54SPLlI5FkTZwCmKGOTyrwlcsRUVDxQtrqFhM9ETTIK/dtHQZRzRsH9+kndkjurzUiK
         zWuEyYxarg6U+RTGSHduLfiXX4nAg/laNXsvt7bjWwGXltbm7N41WSvCH+BoRqP152PE
         vDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wv98y8dQ5akEeeGDMXXhLyBc+qsUn14H5JhwBcLUMC8=;
        b=eCY9QzW8VfHtaTy7ibCHkoHL0HcaOUx8GPY+SGD95i3qFWOS98stcek8inNUnz7x+l
         mUsh3MypuHlY+NiV8VuO35FAN0I7/ZovfmiFNXWylHQ2u+lmxQ0wdeQRLfxSGYIUBdMe
         S92W43j4C7FvndBWqDN/buSJtQwKvdM1kaWtI6dV76iPx4OQahgbdgcR4lZmHEtxnAno
         tQqvxDfZ6v1hRwDxUbyGVsT7SfpZpMho6WZ0bf2ilbPZixrLwshMK/VJv8+JIirHOBFr
         3NgR/eEQuRTYYw6V2B95bZNf0Be/p0bdVNrYuCVWFsC1jwAEJDJ5V1YxnMI04pQsLDgb
         BoUA==
X-Gm-Message-State: AO0yUKXdCQO64TvA0yqWzs2jlIG3ejtEdMkuOY7TfJyEaZ0m3anPJtoO
        fen8MvZSB3Aopyj/pZY1jghTGA==
X-Google-Smtp-Source: AK7set/j6FKuw14wpYWEr4jRGRzBW+lQOieBJgr//bQ80n0qcNR1pteX36cjnx1y5zz1mouFY1ofww==
X-Received: by 2002:adf:fb8d:0:b0:2c5:5391:8ab1 with SMTP id a13-20020adffb8d000000b002c553918ab1mr21254490wrr.53.1677519001919;
        Mon, 27 Feb 2023 09:30:01 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:30:01 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:29 +0100
Subject: [PATCH net 6/7] mptcp: add ro_after_init for
 tcp{,v6}_prot_override
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-6-070e30ae4a8e@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>, stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1660;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=jad8yULOXT9XROjJ8QI8on4tZ/e81AQT8x0klIvJ/Yo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiR3KUJa9kYhI2LRjDO/52fDmz/M6wMTMFDW
 qw5jQ4h0HSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 c3f8D/423O98/uc4yGGg3XG6tCgIxWH5h/CIcb+d7+YxJwBDOudfPSp45LXimy9VGwwrxepjZt8
 K7Zc2AZiS21+SgFSF8potBC/JBzkzu7YrECTrzsidoveL8bkXVNlSbJlbeYWEE19zHs7vQr6C24
 JhneTo4YrfJFIPbEDIKyzlW+8Cvp73s/FyT0Kq/s0+JqK0RK7PxG6o6eVBWY9sGOTK/mKhrDQJq
 4Viqh3DGmgnguVxfLQf2b8+su9mHZ/hO4TSyIBSNSjAsKIdZUVDtKm4LDKmc5ehKMSwthJCQDRj
 tJHa/PtTlome4LD6OPnPfeeSgBnDPapxWaeEKKnYYVo3vuofdvqIlXDQO1iVps8U5oHr/3BAqNi
 hkT3rrvjtVmqkzeKlxGjLC9vns1Xj9VoFEd6//us88LVX+9jbXmbYbqfhj+h589jd0R9SnZ5Lx2
 0yLL23AvODWm/m6lPlgs5oA6GDyvGqOuQgDO8BptiG3p8IsLOcyXDNakazooDAd3ma8ps9N3M6f
 v5JKSYLMGJ91SLcny3JBe4PdrLkyxhHvPoc4eu9m5xdbrN6261x19VVt0IPEBMrKXqrf02mmPdQ
 NzlN0RyvPzJbyRNqr9gvCdiU6YZDlIbG6FmUx8fgFBpvqkkioyhbr/hNzmumGYUe/ZDCysoiHWG
 RGTpRtjC/EvuDGA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Add __ro_after_init labels for the variables tcp_prot_override and
tcpv6_prot_override, just like other variables adjacent to them, to
indicate that they are initialised from the init hooks and no writes
occur afterwards.

Fixes: b19bc2945b40 ("mptcp: implement delegated actions")
Cc: stable@vger.kernel.org
Fixes: 51fa7f8ebf0e ("mptcp: mark ops structures as ro_after_init")
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5a3b17811b6b..f6b4511b09b0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -628,7 +628,7 @@ static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
-static struct proto tcpv6_prot_override;
+static struct proto tcpv6_prot_override __ro_after_init;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -926,7 +926,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 }
 
 static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
-static struct proto tcp_prot_override;
+static struct proto tcp_prot_override __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,

-- 
2.38.1

