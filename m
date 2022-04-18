Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0A505B86
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345622AbiDRPoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345946AbiDRPnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:43:10 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com (sonic317-38.consmr.mail.ne1.yahoo.com [66.163.184.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0996448
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294577; bh=V+vPgvaKFDTnMpIdljAHcVYg6xkRL77vK84TmLoWvrc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=KBeYeg05yAoghP2TDrErLC2fTqkbQwk1LybHrGzhbZtfI62m2sH0C+i/gIaidrXwGeQpPJ84v6WEjFM/G3LaIP/lB0WEPH84YCL44tSVLhG5v/LzzXce0LKav6aYiES4miVgp48VX5mE5ur68th+7EPKCoYKHeSdbc6ZmyUpnJAjk/QhEBJeXiXyv9uOGEYyHt4paRflx/VzDeNJFT40+f87lydYQcW9EB8cJCb4n1/YnkV1Nm46S1BijFPzp/UMVMBIeihJFVEjmH4FUuc2W/eybn9eg0eurNwbk0yQes8id6yHVY56tIfqjdcTtls2FNMqo5VXt9F98sOaeT1+XA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294577; bh=gqp196CrJy8cfJBCHXNL1CY8C4RfoWezbd3JR8ZOkY/=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=arNLzkRAaiqv3jFzHv9oXoMspm5yvnMYcE1rwZJ9SDcA84H7G0U59b/DJhZO/ypGhWZnW6V0pcvXjppOEMRffMl+uc7B1ms5hsjotMor1KPtNWy3LYA3jhDUaSPMjsK0+dVhyAaVXqPGb4xlzrShC55ZAWAT1bQEuuuckzTSaSK15ngN8OJWowRoCJ3689o+sMS0PjXU0N6/g3d8QDym4c8rCI/sYIaE0J6TajDIpCXnxm4BcyE4/CFprSDuZa8XTFktpYGRSrUO6XiE5FaMczxJuKRfLaIZx4s4ersRKOHFyTyEdugphWAtRkf0h0xmnMD4O3mAeOsy7AowS1J7WA==
X-YMail-OSG: 7PQfkCgVM1mXddLviGIViKMELg8ybUzTcenqgxWU8WDNdGozSKfFmQOvheD91p8
 ZyDJ2_3ppQsayx0oaYbH_eSShqkMzVkg0F2vY_ocar8sxrIcb.tso4SRSETiaOR0kQhOYIB3drXf
 faaFQ_1WQGM56pHtNbRF1lD9GJrnaZ6ZhYlxKUsXmY5VBcomwDrw5.cuzxXR4jW2Tab0MozKWZcG
 ctOdOT6_atfSTmvKifAAqKdkVjvKdoPt_pAJsu659V9TntxTKImCaMr29IF3iG8wY8rNZzIXhZgP
 nvvp9w9e_rp3p0lrCic8KGo6DkzoaJcjfcxEBZGOcJ9bIcRkuGUiY23F_yyPHm80JpAq98CdXr72
 89Q9IJ338C6nUVdAKgR37_REV.NQjOwjPbMyfydcsEWz12_7.ZdpB54RivgntK2KujavRlP_adIW
 xP5blOEk5mmJokOnsysdMbbwDRf07k_KxN485iVxv6M7UzfgYiKTJuai1ncFUnH6Z6XIF9PTa1aG
 zMANmTcRBuMdT34fkY.GtmjEROLkwU9kvV6PWdSM.f4PYRDdlM6weNHHiGxrSqeYlB7ypN6UVRSp
 vDFGK1GNLdeO5.l6yTfF4W1SD817K8oxRH3LvKxnS1MnIt4JOPQQE7cSr23HTfEBJkxEsJQbgcGB
 4ZrGdI_.MFPvW_SoBzUIzTu8vUOkovczXhjCgSrYuQiKB7y0niNEmUHAgb4vr0CdPBlGyKfRlHU4
 wi8qsLHmqKR7J6HCAORMAhcYze_d0oSSCyzFMSLDWQj52DkG3dDRu9rL5dpH8gUgdSIezmOKZXDd
 Lz98XOgb4lynXH3CY3kSdW_o1whfk7GcSW2TVuNbhmoOV8.jW_dgXvQmMKDFrUo.iKkL2PnQ1kQA
 mKXFhOx.Erjlfv_OfsecoobcwUIXc0tHWchYhGvvKE5kdOsY72hlqATZKQ3Ki5PjrhI4FetkT276
 F3b0FCecc6YPJpplt09fXBP7V_t8GTYxw7cmzD7WBKhZnU2Nb1H4XJzOi4MX13bNIMaKe09MoQdd
 kYnavfpYUqpOVyyRoJbYFB324bQUrnFKLoo0wzC19WTLnBcbVO_ipL_k8pt3XLCKDAGYRD4TIZrz
 0CiIQI4xCxjVBEOEOrfIk6XfkQqKyauhAjobDkDt_yFvMBsLy1q25B8gmy9WVDntifUo7h5H1NrJ
 dVlC7hdIns.Q8G0ojxKpPsce.bCecRVZHGSCfClViwgZY4r_CWFLAwfzIlI1CP_wdF2phF1Q5zMM
 uNxbk_RZq9ddUVS5gEI75K1_sptBGA4q3.mhdFyrkj5b0wH_zTVtf41Gn_gIkCReStCEnE6UuhHg
 X4nWIUbRmC3ooIKhDm9dL6VtgScQOIoVtUw0dfTP2kIyfJaKmtUAUfiOXbEa4Q..zqaNciXSmNAz
 eH1Z4vWekSqgeEKOeogUVSdFOUt45XCDw_WUZ5rQQvepzQEQzGFzLFgK1lTscgOuixCLGz4.21M5
 afwmFuJzjqsmj3qC8cR6qQJcazRwI5WGds9oQLjv_8z2OEFR7Je24UykXy83bK2XgIjh_GFsJvTb
 h1bUQBh2YB80K56PTpsmrlbRESe67YoAZk2nr4bIblYu045Ct8mMBrsW8pDcNEl1GLFB13q.3HUS
 U.kZO9mekjOYRRlV0ZnkEoKXCqRZK48JeV3DufpVPuJ9jpaP5SCi3Rkm3ecfYosQlporFyaLxKlG
 N4e1zk8AzdDXvatpEsdvoX38K_k86QuYl0itPq0ri9hObyvrshGfdxzJzltYQCbs97yxsu97R1kN
 TIsZ6Ek2Hvigng0DkwNkMrcodnIBg8bm9u9I32D5Hh1ol_iJDxP2zCNudzetQ3sF9iCS6jrw4ZL4
 bDuoW4DCRKOiLCl3UvK1ypwqeYtqXZqqCAahQI0AYGsc0Tzk7pkogUw49RcOXGW6hLkXmbT4f6Nj
 xjvOELMwpFy4ZPXKWof10_N_BDj3PXvQpXalAkOqoMJK_.z9CodDLqHH3tH9gc9IoahKZQl7KoGK
 sdO8wKq5jAUK0bpfWnmztWC.4tfS4PnU8fgKtpDvXC4A63xhOZ_CQivMONxdflwdOWZMUcicZ732
 hLBJfSgVqrbtTmU0Jv0_JHW.838ZSdUopOJEbpHQu9T7nXMCucpDmTXO7fqRwN_5IwbaGFWRhCqj
 ohnZdnx8EnnwGYXpdRnQgG7hokMvrtoQ0DOk9BMyQBm36U8_xpzznB8JSPtNtPFcxx7wShsUISwU
 .TcFpW_wAIAKdQB3dy6IjB9jmAEkSjXe8hvVZK6xboBJ.tpEfbrMmFppISzbiRyUV00ymjQrFaDs
 2RnFmelT_H2XbIxjVsLnxcnpdGBFCRWdlVvl969iCvWvrJg_OQICL1jAEm1jVqwixCPLw0WMg0rf
 UBxX7vn8-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 Apr 2022 15:09:37 +0000
Received: by hermes--canary-production-ne1-c7c4f6977-9gvrn (VZM Hermes SMTP Server) with ESMTPA ID d63a51ac54c25c4b8dfd633eacacc622;
          Mon, 18 Apr 2022 15:09:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v35 18/29] LSM: security_secid_to_secctx in netlink netfilter
Date:   Mon, 18 Apr 2022 07:59:34 -0700
Message-Id: <20220418145945.38797-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418145945.38797-1-casey@schaufler-ca.com>
References: <20220418145945.38797-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 35c3cde6bacd..f60a0b6240ff 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,15 +301,13 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 {
-	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
-	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
-		return 0;
+		return;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
@@ -318,14 +316,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, &context);
-		*secdata = context.context;
+		security_secid_to_secctx(&blob, context);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
-	seclen = context.len;
 #endif
-	return seclen;
+	return;
 }
 
 static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
@@ -397,12 +393,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
+	struct lsmcontext context = { };
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
-	u32 seclen = 0;
 	ktime_t tstamp;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -473,9 +467,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
-		if (seclen)
-			size += nla_total_size(seclen);
+		nfqnl_get_sk_secctx(entskb, &context);
+		if (context.len)
+			size += nla_total_size(context.len);
 	}
 
 	skb = alloc_skb(size, GFP_ATOMIC);
@@ -610,7 +604,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -638,10 +633,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return skb;
 
 nla_put_failure:
@@ -649,10 +642,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return NULL;
 }
 
-- 
2.35.1

