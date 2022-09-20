Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60625BE88C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiITOTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbiITOSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:18:33 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644A561D9F;
        Tue, 20 Sep 2022 07:15:52 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id ADD4E5C00B3;
        Tue, 20 Sep 2022 10:15:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 20 Sep 2022 10:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663683351; x=1663769751; bh=g+
        lYArEB0WqHuz5jc10oRdSDvq8oCSjIk+AmAkVPKaI=; b=Br9kQUmQ1ilhL1ZZFb
        x+wOD77dolIh5yZbk2ZCQwPwtlph0/J1p2rDdOJIydKQWb+1bcwJ/1XVVh7FYbAV
        ao/Axs8nrmTT9uv1mk/O6xkHH0DE3LxlQp8kFov7ewPPN2dwBaF8Z3GG9c4+f365
        Kg5pezojzlbAWAp+3RkbPhendFxcgVin1RBeL4JdWZNHLa/PNK8bcTy/7IsvmPAm
        yoVsOx/baR3XrGAurWkm1QuLAZIA9e+lIIs5Gnnc3uuXTLJaeE+/TX3Y0n0q7g1b
        KQU6GLT6hC0UxNujHIytbMqEWv+r1zyHBPjZPd6zeUbXcMowel3crUXI4xOBLLoO
        /pxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663683351; x=1663769751; bh=g+lYArEB0WqHu
        z5jc10oRdSDvq8oCSjIk+AmAkVPKaI=; b=gYxkORjQAGl370bx/s5L0xTX4W7VN
        up1ZYH6Ux2Flmz8bI03qaDKMIeWuda95wE4+1QfZVJnhMnsW014rX3ygFCiSH4yw
        pGpSaeKqLs0JG7kY91VMi12SalGYTFC/NuzeNPQb41UGbr7rIGgX5SrTiAAhgGuK
        +7EMhYUPk5J1AaDGZaM3Rc/JeauDwmLG/ACdk0gXeZzF/LxrmGhEja/qmPPxQWKM
        CgLVcfaM3fDDuD6apNAvDWzKQfwyq3dt8wvK+odQYoQZTlYtwHAj1rlygul2EX/0
        GJo2F6w1rVPpgH0kjWTnw5qaoPtfGDdprgFCMzMj5heDJ6T9RFcLxdDeg==
X-ME-Sender: <xms:F8spY-o1wE53_XkONqQBYtEuGxrQ_B5mAy4QRLCAnA1UfukzeNElYA>
    <xme:F8spY8pM9R_YriECrBHLFRfAh165ZkQlc5Qgt3bnwvJDa5-EZk1r2homh8D10kFFT
    UG8qSsVF3OzvZik0A>
X-ME-Received: <xmr:F8spYzOGB-wmtXj-aryEfVYsH-Wk7MO9IueYRAnRk8dhcjg-s-Z6ZPN68Kw6_WQNE2sLdbLOZJYUtFkFPWGgSBBO15UUfGELX7xSHKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvledgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:F8spY95hrXdlG0mJ9gqWZ0pOubD0ndw5C-UnexY3xgJYUc4_XNhnoA>
    <xmx:F8spY97jq7OdQbxod8d4fZARedQtTzYJH4CaCszqssK_4Kp9VyLySA>
    <xmx:F8spY9gVeATZ0qbU4xPN-j9dqmEqn0OdJVGDAv3no4v5jxBnmz08kA>
    <xmx:F8spY5hOHzcL477dri0_lKlgcFD9qrAMbZfb1oWV9bP0p1xhBMCy_A>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Sep 2022 10:15:50 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 2/3] bpf: Rename nfct_bsa to nfct_btf_struct_access
Date:   Tue, 20 Sep 2022 08:15:23 -0600
Message-Id: <73adc72385c8b162391fbfb404f0b6d4c5cc55d7.1663683114.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663683114.git.dxu@dxuuu.xyz>
References: <cover.1663683114.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
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
index 9c07d2d59da5..1199d4f8e019 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -13,10 +13,10 @@ extern int register_nf_conntrack_bpf(void);
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

