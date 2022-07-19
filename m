Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26857A0AF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiGSOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiGSOIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:07 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55998545EA;
        Tue, 19 Jul 2022 06:24:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z22so6584266edd.6;
        Tue, 19 Jul 2022 06:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2o7Ejsdb6BQMlwWJHxT3lqJ+rt9+L8L+SWAj5OOr/s=;
        b=kD1zc74aUKlJqxOwyLGbN/AjoHeHgra8w0bbMKU8zKTzWA2mkqUWS3jSb8FjanXnGP
         CYLgmElkYpE6nQ2iebc4bKA5CUvIQJ8HYcnvfVxXH2aBvRfeGhEQnSKeJgFiJ896mhK8
         ZCJlHnHmmCIkKemUMbSyzPDZsp5p6HNYmHPbu15Nxsv90jegT4e0ObbgEdGVC8W6IHJp
         HD1wX0qtBrWcar+p7AXLB4TmXcTKC+IoJdH3ZS7hb8POiRFHc/JSjtbkuzUm0Q4FckA7
         ThmKJ0XAdChV0Qh7srS+cxANzr123T/O7PpPaG96Aq1Hvh51zAxhPlrVosaqa84bzLit
         +QmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2o7Ejsdb6BQMlwWJHxT3lqJ+rt9+L8L+SWAj5OOr/s=;
        b=N84dxJGo2MTdsIq4B29qTpHKkmaqfIAgtcmhP5E1ESO6+nSvk6mm78CcqOFtnmEwvt
         WLtrxCoVpCjFddN6piJmQS4lm2POBThIpBGmljHEQtSTMLXEu93OX4HAUAxRBPGEOHvO
         popNk3xV0ea7giAWSPmcjwFu1s/OxiGBN43EC4N06db5zxh0DfNx5TfcED/9Hkwdyjpv
         cIHP/GPbQMIp4Zu0mpjCJKLjHoFFcZmniSCVQeK+H/kUYjDRP7cH+oZopXgVkv/XfTaZ
         BaMn42mTqpNQxdgwOaQdb67tchLPJWXKQ3cPXYhbIlSouVKBAyBO1k2Yl2Cg+Mz+GEly
         RiUg==
X-Gm-Message-State: AJIora/shOP/E3v/uEtmv0Ft3yam03uLbWYq6SCdLtwYyMqZffXJjH4c
        4UHmRTp6V8ogMbBnGC/9u7mrO0tq99vQjw==
X-Google-Smtp-Source: AGRyM1vn4yvEw6W5PLz9FxJnCpCDBCdnpm4Oc2+ESihZ0C3yQY9POuXgg/0DbTc6yIn4o0bOtb/vFQ==
X-Received: by 2002:aa7:dbd9:0:b0:43b:6e02:7e37 with SMTP id v25-20020aa7dbd9000000b0043b6e027e37mr10115420edt.341.1658237084592;
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090632c800b0072f3efb96aasm1951096ejk.128.2022.07.19.06.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 09/13] net: netfilter: Add kfuncs to set and change CT status
Date:   Tue, 19 Jul 2022 15:24:26 +0200
Message-Id: <20220719132430.19993-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7067; i=memxor@gmail.com; h=from:subject; bh=uVaLU7NheOIBQ6hr1+LFHwqhS6mK16e/8d85OGvwlYQ=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlqRkMxl4TLzJ//oKAKU0p6ct0je7vt7dGWgnT ftk2f6SJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RysAfD/ 9/sYH9RQ+IOywS+HhOJbkZ41l2Z0JbybPsAPg36V4Qtc3nGHRi2NXColT9NJfw+ny8I9V2jgKmvyKE MASPeA1Aqrk1ze6HcDhv4sWquMd8cIscDdrsKNg3zlMMwOo5TsP4GjyycXf5qMHf+rYyCbLSdu+Uln 7s88Jhr3qCcFottfn/Z4wJN7HSRIokhTAdMAho0YUZ3PJ91sPoKNc5Nsq30CpLW85uErSBNzW2y+Bj Yr4b8+aIcc+DrcKmoSsx2Wh1jmE9KD8wtWtB/BA6FWCmoqVFu06qSTDWLX+V9auRA1MZYHMC5ANexJ j2MtNfcoBNjLss1SI1A/ekKjDOBELTmBYFykuBXuCmSV9kRVAaB19ePzRf9X7JpaAoLAJvJDh8p99N /+jV4uS2rjxJ5q9OiEUbfbeY502mwfZYBekgMYmynA/bzR1670QVvpttuflYwEg6iTDaCdXqFkGESg s376YNJsGIATzLxjKfEVCR/LIIE3x3lSOlYTCWrhGjZcsh78qNQ7nT4o3hXZ6LE40Gart+t4o8WmWc 5CCGFmUfB8d3r0264hO1JMJRL/orPrWH63TQ5kx+RR9ZBz8jVqtWZER2xv0NyXWJ71ac12mnwWxdJs TSsIq8uZgCoK0kMPGQLwhneRCLcFrXVFOSlZCokxt7U7OqJyrqaLUi6EZ3Fg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
instead of sharing one because KF_TRUSTED_ARGS flag causes strict type
checking. This would disallow passing nf_conn___init to kfunc taking
nf_conn, and vice versa. We cannot remove the KF_TRUSTED_ARGS flag as we
only want to accept refcounted pointers and not e.g. ct->master.

Hence, bpf_ct_set_* kfuncs are meant to be used on allocated CT, and
bpf_ct_change_* kfuncs are meant to be used on inserted or looked up
CT entry.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  2 ++
 net/netfilter/nf_conntrack_bpf.c          | 32 ++++++++++++++++++
 net/netfilter/nf_conntrack_core.c         | 40 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c      | 39 ++--------------------
 4 files changed, 76 insertions(+), 37 deletions(-)

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
index 7d7e59441325..6d9102e2b597 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -394,6 +394,36 @@ int bpf_ct_change_timeout(struct nf_conn *nfct, u32 timeout)
 	return __nf_ct_change_timeout(nfct, msecs_to_jiffies(timeout));
 }
 
+/* bpf_ct_set_status - Set status field of allocated nf_conn
+ *
+ * Set the status field of the newly allocated nf_conn before insertion.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @status       - New status value.
+ */
+int bpf_ct_set_status(const struct nf_conn___init *nfct, u32 status)
+{
+	return nf_ct_change_status_common((struct nf_conn *)nfct, status);
+}
+
+/* bpf_ct_change_status - Change status of inserted nf_conn
+ *
+ * Change the status field of the provided connection tracking entry.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_ct_insert_entry, bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ * @status       - New status value.
+ */
+int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
+{
+	return nf_ct_change_status_common(nfct, status);
+}
+
 __diag_pop()
 
 BTF_SET8_START(nf_ct_kfunc_set)
@@ -405,6 +435,8 @@ BTF_ID_FLAGS(func, bpf_ct_insert_entry, KF_ACQUIRE, KF_RET_NULL, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
 BTF_SET8_END(nf_ct_kfunc_set)
 
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
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
2.34.1

