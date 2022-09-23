Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3472F5E835A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiIWUR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiIWUP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:15:28 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4DD1231D8
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n12so1541128wrx.9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QSlxelZmZQkauh748b/7aNwlVR4EaKtqFDpMBsT7q2s=;
        b=U6NipO/WIQWxS/+Jj3d/rVPxFAUKikH5/3i+w/aOIgkOpIBtgKhtkrV3ClKF7MyDGa
         MxEWLc2NhU4QPjlJxtZO4qziF0EFHJLKqGcuAzHAfyYYazgxLCJIm1oq3ee9oLKqcM1E
         1d1fBFIMAtmLQYGJwlus2jofkrfEGouUvI0g8hAWL4ojN1v6JxLErDYCoHPX030i48FA
         B3pgPR6DYKK4dkwNqmAhsrFnrGQY5jsR+LVEwwDiCD3CS7JEZ/DoXuk8Y1L24RspQR1e
         +HTd+azien7FwppHeI+V/vzKOt7oV8kZHmVgHSaqqbFPSnLx6+XfWG/fBXnF4Wn1rkIy
         FDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QSlxelZmZQkauh748b/7aNwlVR4EaKtqFDpMBsT7q2s=;
        b=sWoZUKU6h8gJ+B3rWy8TEOht2nnnqxB86RwjI0H9uDY0ALLhtKqitnHuoCdUybOA/f
         apjgTAvYQF0vV99snPcIyf0y+EP1oIKux9pY7Yd+pMSyF2K6vLZHPYGDvB8L927tk1rt
         u468y6RwpauKLAs654TBQFXFpFZvjxj3/GIV3kuvtb9EaIo/SIM1acE+N0XWowRjwD8s
         BBHe5MWNj5DZ0/l7qcRXOZtzvCmoHRJQxk578QTPKP7+Iw/p+zTxVx5272KFkfbDM2uH
         kufzj8xs/jOJlHKVxher7TXi7buIOQ9S5T4mSmurNo5L2/4Sh5oNs57+ZaFON+LLK9cR
         9wWA==
X-Gm-Message-State: ACrzQf0jrMQpUkXcEtSitHJgvU6njtdO6Y2/+PCLouo6H5IXL1Bc0ROI
        u4ld8TKqYpJsJ+mEy6ra49lffg==
X-Google-Smtp-Source: AMsMyM4Mco6j50zScn0pA1uSr0W0RCMLK0MagZMF94m1Efp9WHSd2cOmkVjbX1l1RMC/fTgjGZzsJw==
X-Received: by 2002:a5d:6808:0:b0:22a:c437:5b36 with SMTP id w8-20020a5d6808000000b0022ac4375b36mr6285460wru.459.1663964044375;
        Fri, 23 Sep 2022 13:14:04 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:03 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 24/35] net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
Date:   Fri, 23 Sep 2022 21:13:08 +0100
Message-Id: <20220923201319.493208-25-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete becomes very, very fast - almost free, but after setsockopt()
syscall returns, the key is still alive until next RCU grace period.
Which is fine for listen sockets as userspace needs to be aware of
setsockopt(TCP_AO) and accept() race and resolve it with verification
by getsockopt() after TCP connection was accepted.

The benchmark results (on non-loaded box, worse with more RCU work pending):
> ok 33    Worst case delete    16384 keys: min=5ms max=10ms mean=6.93904ms stddev=0.263421
> ok 34        Add a new key    16384 keys: min=1ms max=4ms mean=2.17751ms stddev=0.147564
> ok 35 Remove random-search    16384 keys: min=5ms max=10ms mean=6.50243ms stddev=0.254999
> ok 36         Remove async    16384 keys: min=0ms max=0ms mean=0.0296107ms stddev=0.0172078

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/uapi/linux/tcp.h |  3 +++
 net/ipv4/tcp_ao.c        | 17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 453187d21da8..42850ae6e99d 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -353,6 +353,9 @@ struct tcp_diag_md5sig {
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
+#define TCP_AO_CMDF_DEL_ASYNC	(1 << 3)	/* Asynchronious delete, valid
+						 * only for listen sockets
+						 */
 
 #define TCP_AO_GET_CURR		TCP_AO_CMDF_CURR
 #define TCP_AO_GET_NEXT		TCP_AO_CMDF_NEXT
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 8f569f43e9c2..ed8cacb61694 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1461,7 +1461,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_DEL_ASYNC)
 #define TCP_AO_GETF_VALID						\
 	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
@@ -1586,11 +1586,26 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
 
 	hlist_del_rcu(&key->node);
 
+	/* Support for async delete on listening sockets: as they don't
+	 * need current_key/rnext_key maintaining, we don't need to check
+	 * them and we can just free all resources in RCU fashion.
+	 */
+	if (cmd->tcpa_flags & TCP_AO_CMDF_DEL_ASYNC) {
+		if (sk->sk_state != TCP_LISTEN)
+			return -EINVAL;
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+		return 0;
+	}
+
 	/* At this moment another CPU could have looked this key up
 	 * while it was unlinked from the list. Wait for RCU grace period,
 	 * after which the key is off-list and can't be looked up again;
 	 * the rx path [just before RCU came] might have used it and set it
 	 * as current_key (very unlikely).
+	 * Free the key with next RCU grace period (in case it was
+	 * current_key before tcp_ao_current_rnext() might have
+	 * changed it in forced-delete).
 	 */
 	synchronize_rcu();
 	err = tcp_ao_current_rnext(sk, cmd->tcpa_flags,
-- 
2.37.2

