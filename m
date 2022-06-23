Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4715D558930
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiFWTi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiFWTii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28591EECF;
        Thu, 23 Jun 2022 12:27:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q18so70597pld.13;
        Thu, 23 Jun 2022 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/IuSNY1nTR+i2SmVAA4oqUp1JTqS3dcX7JKuVibnNI=;
        b=OS5Y1n2KlxPV2GCSCzyO6/im/laq+l0XbrOcYiGEaGjvcB4N+Fwcd+PN3Dbs+a/URO
         Gc7KdRvBroRDFHmV/BuxDKnVYEerV69Wq7wSYe3kib82WwLvvJ/rXxmfujDwYjTUN0yx
         4XY/po2aThnbv+CNkV403T+sPWwLnyqJr/VRCerofB5YznNaNFEZF3SqGd/DvpBu50td
         6IHtqHdmNXur9K0UvJzmE3mZVxoe58bvBRpKUmLkzY9xkgGFGqy31k8h2fbmOWpjUsAb
         lhuiykwW/V6n2aavl7kyLNYIq1zZCn3chCccDNOyIbtRdY+Pfq6HP1YsWEqsu+6Fr0gD
         n5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/IuSNY1nTR+i2SmVAA4oqUp1JTqS3dcX7JKuVibnNI=;
        b=Ir8tjwI6TRYSt2eoJ5CTdwHKNawhmQUjWF06H6WXOtFccvbgZaaKu8E6+plNPxMtXm
         ptxaTtn1OP+7VgaAU7fOm/RRJI7kMrofYyqKXb+MfuV9riN/fDghZl+ysA3+diArrzrV
         55gLLyS8U2cDQGm0+WvwdIC1VC0odewaSUEUDq20wp2jH+j++9OYp73/dH9EKqSljsRL
         Cr76WUVwk3lRFaDb6eot18Pjc5TYpiOvit0L0DZYGHWzzVLB0OFRutt5uhlAqFzhwYZ6
         rPXwXBJ8PgMm/dtE8vev6f5nF2N3IR8xTEYwJhrJkSQD5C/Uj7gdE9hPPIu1ueXG0sag
         Xveg==
X-Gm-Message-State: AJIora/A/RO8cYSAaMyIVDxokDkTONpbgutJmFcV1KDFF2y0v67WY+8d
        NcpnifU1yyRmQXDmozIlJ6c0mzj34NtH7w==
X-Google-Smtp-Source: AGRyM1tCb5EtyO0w4L+lAX/vi9CssffJ8U2CoLQ2TKrl5ySJ9rEe2tunON4aklOp4IuAqv/AstaI/A==
X-Received: by 2002:a17:902:f787:b0:16a:1e2b:e97 with SMTP id q7-20020a170902f78700b0016a1e2b0e97mr24672383pln.27.1656012427265;
        Thu, 23 Jun 2022 12:27:07 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id z19-20020aa78893000000b0050dc76281e0sm786pfe.186.2022.06.23.12.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:27:06 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v5 5/8] net: netfilter: Add kfuncs to set and change CT status
Date:   Fri, 24 Jun 2022 00:56:34 +0530
Message-Id: <20220623192637.3866852-6-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7434; i=memxor@gmail.com; h=from:subject; bh=5vZDzfYMdwGatzyK+LNL9zGsmO8GE8lBDG0BNOIDIhU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5LCo0N3KkU4qPBz5fo08oK1ygYQ6wgi4A/0kHO hm67GHWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8Ryu0zEA CNlOeZlLcx9yjWSQoQMUbCFe1X6P/EDzjTY9teX9qlqXqfbuVAi4wLoEUZDiAUQmAyN5BJhWRhCmFm 8Br6PgvwPVfIiWo9e/cpqJdebMiNkQcjaMDdMEeu9TmSXVQMhLQAbN5IzKxEhb8nOuJNSxAwOK+LuB W8yQLcN61aTC8X5xciHM9kEwlPJpRIPpdSrcVQqFn6GR3Y+eLmvwbUzVMV/i9bVwP6/UWzJ+1iSuET ZL8KwS7yP48EYkfExDbvp9rhBFVuA7FTvc8pJyGFpEep6loVAI4nl2X9ioQcGg1OVNNLfJngFp/tNC zQ1KyPJW7NbfBMya1JIwP3L5oVEIiS1lM2ICwE8kr1Od9pw0SqkmDrQs1AW6dIW7ep7UA0VBIxk2Ye md6VQkApVTTBVckhCaFRFVGS8KITLm01K2bT19px0+HUDYHz9KvOSNDdedFcCF4uJiBFfn0xZBJgBp 9wwLK5ZcgtWZrZpJakrXpIsVnyYKuA8YiFLip7bCYO/ZJiOX7hhBEBXbX3ymIV5rEiFQJ2m9IxioxM S0qJiDpP4lBxL06o44xH5PlgHxg1DrqM9VwIACT5vaFUmhgXa3Rg1l3Wpa/IhWAoR0/DMBy5/kMRSl OdfUaSstDRhRFI0LhBOwhVaybYklK6Mdl9VBDXayO3nIxUgYcGItC4FDiQbQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce bpf_ct_set_status and bpf_ct_change_status kfunc helpers in
order to set nf_conn field of allocated entry or update nf_conn status
field of existing inserted entry. Use nf_ct_change_status_common to
share the permitted status field changes between netlink and BPF side
by refactoring ctnetlink_change_status.

It is required to introduce two kfuncs taking nf_conn___init and nf_conn
instead of sharing one because __ref suffix on the parameter name causes
strict type checking. This would disallow passing nf_conn___init to
kfunc taking nf_conn, and vice versa. We cannot remove the __ref suffix
as we only want to accept refcounted pointers and not e.g. ct->master.

Hence, bpf_ct_set_* kfuncs are meant to be used on allocated CT, and
bpf_ct_change_* kfuncs are meant to be used on inserted or looked up
CT entry.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  2 ++
 net/netfilter/nf_conntrack_bpf.c          | 37 +++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c         | 40 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c      | 39 ++--------------------
 4 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3b0f7d0eebae..3cd3a6e631aa 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -98,6 +98,8 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
+void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off);
+int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status);
 
 #endif
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index db04874da950..6975dda77173 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -394,6 +394,39 @@ int bpf_ct_change_timeout(struct nf_conn *nfct__ref, u32 timeout)
 	return __nf_ct_change_timeout(nfct__ref, msecs_to_jiffies(timeout));
 }
 
+/* bpf_ct_set_status - Set status field of allocated nf_conn
+ *
+ * Set the status field of the newly allocated nf_conn before insertion.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct__ref    - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @status       - New status value.
+ */
+int bpf_ct_set_status(const struct nf_conn___init *nfct__ref, u32 status)
+{
+	return nf_ct_change_status_common((struct nf_conn *)nfct__ref, status);
+}
+
+/* bpf_ct_change_status - Change status of inserted nf_conn
+ *
+ * Change the status field of the provided connection tracking entry.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn.
+ *
+ * Parameters:
+ * @nfct__ref    - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_ct_insert_entry, bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ * @status       - New status value.
+ */
+int bpf_ct_change_status(struct nf_conn *nfct__ref, u32 status)
+{
+	/* We need a different kfunc because __ref suffix makes type matching
+	 * strict, so normal nf_conn cannot be passed to bpf_ct_set_status.
+	 */
+	return nf_ct_change_status_common(nfct__ref, status);
+}
+
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
@@ -403,6 +436,8 @@ BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_set_timeout);
 BTF_ID(func, bpf_ct_change_timeout);
+BTF_ID(func, bpf_ct_set_status);
+BTF_ID(func, bpf_ct_change_status);
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
@@ -412,6 +447,8 @@ BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_set_timeout);
 BTF_ID(func, bpf_ct_change_timeout);
+BTF_ID(func, bpf_ct_set_status);
+BTF_ID(func, bpf_ct_change_status);
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 572f59a5e936..66a0aa8dbc3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2807,4 +2807,44 @@ int __nf_ct_change_timeout(struct nf_conn *ct, u64 timeout)
 }
 EXPORT_SYMBOL_GPL(__nf_ct_change_timeout);
 
+void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off)
+{
+	unsigned int bit;
+
+	/* Ignore these unchangable bits */
+	on &= ~IPS_UNCHANGEABLE_MASK;
+	off &= ~IPS_UNCHANGEABLE_MASK;
+
+	for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
+		if (on & (1 << bit))
+			set_bit(bit, &ct->status);
+		else if (off & (1 << bit))
+			clear_bit(bit, &ct->status);
+	}
+}
+EXPORT_SYMBOL_GPL(__nf_ct_change_status);
+
+int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status)
+{
+	unsigned long d;
+
+	d = ct->status ^ status;
+
+	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
+		/* unchangeable */
+		return -EBUSY;
+
+	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
+		/* SEEN_REPLY bit can only be set */
+		return -EBUSY;
+
+	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
+		/* ASSURED bit can only be set */
+		return -EBUSY;
+
+	__nf_ct_change_status(ct, status, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_change_status_common);
+
 #endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b1de07c73845..e02832ef9b9f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1890,45 +1890,10 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 }
 #endif
 
-static void
-__ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
-			  unsigned long off)
-{
-	unsigned int bit;
-
-	/* Ignore these unchangable bits */
-	on &= ~IPS_UNCHANGEABLE_MASK;
-	off &= ~IPS_UNCHANGEABLE_MASK;
-
-	for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
-		if (on & (1 << bit))
-			set_bit(bit, &ct->status);
-		else if (off & (1 << bit))
-			clear_bit(bit, &ct->status);
-	}
-}
-
 static int
 ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 {
-	unsigned long d;
-	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
-	d = ct->status ^ status;
-
-	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
-		/* unchangeable */
-		return -EBUSY;
-
-	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
-		/* SEEN_REPLY bit can only be set */
-		return -EBUSY;
-
-	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
-		/* ASSURED bit can only be set */
-		return -EBUSY;
-
-	__ctnetlink_change_status(ct, status, 0);
-	return 0;
+	return nf_ct_change_status_common(ct, ntohl(nla_get_be32(cda[CTA_STATUS])));
 }
 
 static int
@@ -2825,7 +2790,7 @@ ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
 	 * unchangeable bits but do not error out. Also user programs
 	 * are allowed to clear the bits that they are allowed to change.
 	 */
-	__ctnetlink_change_status(ct, status, ~status);
+	__nf_ct_change_status(ct, status, ~status);
 	return 0;
 }
 
-- 
2.36.1

