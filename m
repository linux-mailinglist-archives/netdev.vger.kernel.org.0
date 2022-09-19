Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328975BD558
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiISTpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiISToy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:44:54 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132011C2A;
        Mon, 19 Sep 2022 12:44:53 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 54B795C048B;
        Mon, 19 Sep 2022 15:44:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 19 Sep 2022 15:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663616693; x=1663703093; bh=dN
        +OIBsiVSjDk2R7rxiA32sundoaplSbdoorgq9KOXw=; b=D+hBSKSbhckgHzTw1p
        dzeewFYUq8ar1wE2lSvFCWMAB9xZaE1k823Gggl9KphR3PypXt0IFZ2N1zqJioXn
        0IHZiozNAugU8IrEwp10dyDPp0uY4uu3iKFK5JmgWPe48DYwsyT2k+Z8QVNMyQyT
        D2RbaiDeQjvK8OUML7i8syYAs+RhXP38/ctLr1z0mf0lnis+ieDbGFqNt0zaaWpW
        LttsWamal7pHsARwZnO6iUGdB6Mwa2e0o+RcEkjKlzY38abNlOqj5RJ4d79LjTt4
        KcGHMDXx6pLsOlA1zStzJqK9iqBq5m2mqKUsmz2QsnaxO/AyGJoj7YFCiBBcIWmn
        RSTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663616693; x=1663703093; bh=dN+OIBsiVSjDk
        2R7rxiA32sundoaplSbdoorgq9KOXw=; b=NjWWjGNOlMbU2tBDb11pQRltLQb0B
        Lq2KWTdZbSW90zr+1dZ2li1425HUxKvFxdcezA6B1LF5X20qpA8+UNkKgMPr2/HJ
        rEu22uWHuiWHBqo8NEKOvXUyZiE/BDqKLQW/r82M+jTomM2XOmg3k2K6ftVDN30+
        QUA1yF83YunJv94YP0Nj7p0rgkTRnJJdLIJ/PzUqK38t3E5jS/JbystZYEpmmoob
        zXEkVb9aBG/0HVaw3MTe7/wnWDs1+DnsdYzHNqEymXUp6+zZR+7ncz6zWb9ry7Zm
        7npydq09ldWKqgepZ6ErJVeysu/qO3lFpTOidRjWU8ABmk9cKpUDQ3QSg==
X-ME-Sender: <xms:tMYoY9OR5Nf_hWREHIcMJbOX8XhILgyGx8LmdFX7jNtfdGJNRrLwUA>
    <xme:tMYoY__Ez_f1uGyBxS1oNEoobHt8AvRNTJHNK-gtSvykSjrfzWQFfz37nH94JpFuj
    1nJ2--dCOXK2CvJEA>
X-ME-Received: <xmr:tMYoY8RS6OJstlGzSFS7cWvNoscJ_66kcU8uKVvCMjrvNgnfmBjCok2XtG7sqr09U-mAoO41vdYUdngBME8Am_GFwLPKTnAyu7TN7BY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:tMYoY5vB2uBl05l4eygHxlT5Sx6j7_QQ0aozhhZvbRJFiPQ2qcT6HA>
    <xmx:tMYoY1d1PWjow7ZIs3UgGCYoDaCQb0-oja880tqhINLEq8Zv-96ToQ>
    <xmx:tMYoY128sbg3cZMzytcAGqrnQn1Sy_GooOatTpo2LzNU9VkXhDb0Xg>
    <xmx:tcYoY12gU8H-Xi7Cn_DqaCak2V29MPzo3VQxliNoNwP1Rp1TPJXHCw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 15:44:52 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] bpf: Rename nfct_bsa to nfct_btf_struct_access
Date:   Mon, 19 Sep 2022 13:44:36 -0600
Message-Id: <07deb5b553790049638758250a118a96be6768d0.1663616584.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663616584.git.dxu@dxuuu.xyz>
References: <cover.1663616584.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The former name was a little hard to guess.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/netfilter/nf_conntrack_bpf.h |  8 ++++----
 net/core/filter.c                        | 18 +++++++++---------
 net/netfilter/nf_conntrack_bpf.c         |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index 73f2b78232e5..d1087e4da440 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -15,10 +15,10 @@ extern int register_nf_conntrack_bpf(void);
 extern void cleanup_nf_conntrack_bpf(void);
 
 extern struct mutex nf_conn_btf_access_lock;
-extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
-		       const struct btf_type *t, int off, int size,
-		       enum bpf_access_type atype, u32 *next_btf_id,
-		       enum bpf_type_flag *flag);
+extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
+				     const struct btf_type *t, int off, int size,
+				     enum bpf_access_type atype, u32 *next_btf_id,
+				     enum bpf_type_flag *flag);
 
 #else
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 4b2be211bcbe..2fd9449026aa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8608,11 +8608,11 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 DEFINE_MUTEX(nf_conn_btf_access_lock);
 EXPORT_SYMBOL_GPL(nf_conn_btf_access_lock);
 
-int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
-		const struct btf_type *t, int off, int size,
-		enum bpf_access_type atype, u32 *next_btf_id,
-		enum bpf_type_flag *flag);
-EXPORT_SYMBOL_GPL(nfct_bsa);
+int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
+			      const struct btf_type *t, int off, int size,
+			      enum bpf_access_type atype, u32 *next_btf_id,
+			      enum bpf_type_flag *flag);
+EXPORT_SYMBOL_GPL(nfct_btf_struct_access);
 
 static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
 					const struct btf *btf,
@@ -8628,8 +8628,8 @@ static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
 					 flag);
 
 	mutex_lock(&nf_conn_btf_access_lock);
-	if (nfct_bsa)
-		ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
+	if (nfct_btf_struct_access)
+		ret = nfct_btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
 	mutex_unlock(&nf_conn_btf_access_lock);
 
 	return ret;
@@ -8708,8 +8708,8 @@ static int xdp_btf_struct_access(struct bpf_verifier_log *log,
 					 flag);
 
 	mutex_lock(&nf_conn_btf_access_lock);
-	if (nfct_bsa)
-		ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
+	if (nfct_btf_struct_access)
+		ret = nfct_btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
 	mutex_unlock(&nf_conn_btf_access_lock);
 
 	return ret;
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 77eb8e959f61..29c4efb3da5e 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -502,7 +502,7 @@ int register_nf_conntrack_bpf(void)
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
 	if (!ret) {
 		mutex_lock(&nf_conn_btf_access_lock);
-		nfct_bsa = _nf_conntrack_btf_struct_access;
+		nfct_btf_struct_access = _nf_conntrack_btf_struct_access;
 		mutex_unlock(&nf_conn_btf_access_lock);
 	}
 
@@ -512,6 +512,6 @@ int register_nf_conntrack_bpf(void)
 void cleanup_nf_conntrack_bpf(void)
 {
 	mutex_lock(&nf_conn_btf_access_lock);
-	nfct_bsa = NULL;
+	nfct_btf_struct_access = NULL;
 	mutex_unlock(&nf_conn_btf_access_lock);
 }
-- 
2.37.1

