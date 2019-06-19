Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FB94B246
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbfFSGlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59381 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:41:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 78DD521AC2;
        Wed, 19 Jun 2019 02:41:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Q4VSQOids1PkFwHFx+mOs1A8TXdoBKUm7PqxXlxa6UU=; b=JffIqRAf
        SlVQ6am2RGjyAIm9YJFjeOi8VNp6QUT7nqYM1UXtWV23iMNgmQwNxm1H2fmUXHHO
        O3RlPlFBOS95WTvFJ6Jl+M7ZdL3vq0sXZbtl+VEd1Kje9xTsHEB6vXHpA8dbYgAA
        AYfJjhIcfxpPjRHV4OwL5/c/bTWWxCTvndai8QtYnzeOK8TraLvQ6t52+hpA0783
        7bVCOgS0AbsHrJUceLHeQPupLTMRh6RnbXlfNM8+oDjter49OK8zepgE/wswf/hN
        hpjJw4rcP2L18tISQ4M5eHGoDKp0VlqM1VjpkJVcDIJzrWRhuZcyeq+NTqqj7KIJ
        tNq5zXTaVV68tQ==
X-ME-Sender: <xms:MdkJXcgJwPEsCKGMD7oFizPdVNTWDfqHt_td5LW0kbyQmb1Xi4LjLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:MdkJXbB5gcQDyaAj8ZSqv-7KM-xhhoUyJT81L9R3v4x1oBRxgnHUVA>
    <xmx:MdkJXRvm_QC7ul-w0jrE0FHA4oGTNZJztoLp55-8bwIuw_dGriB2-Q>
    <xmx:MdkJXYaElTsfGdLjwlMz6ERu89ywFTBzTvzNsh5B9RBtmbceYrsGhg>
    <xmx:MdkJXZohAihrt0Bb5kn4m_JT0xuxq2c9kpBQTz2gd6mFFN7kJVDKBA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB88D80059;
        Wed, 19 Jun 2019 02:41:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/8] net: flow_offload: implement support for meta key
Date:   Wed, 19 Jun 2019 09:41:04 +0300
Message-Id: <20190619064109.849-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement support for previously added flow dissector meta key.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 36fdb85c974d..36127c1858a4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -10,6 +10,10 @@ struct flow_match {
 	void			*key;
 };
 
+struct flow_match_meta {
+	struct flow_dissector_key_meta *key, *mask;
+};
+
 struct flow_match_basic {
 	struct flow_dissector_key_basic *key, *mask;
 };
@@ -64,6 +68,8 @@ struct flow_match_enc_opts {
 
 struct flow_rule;
 
+void flow_rule_match_meta(const struct flow_rule *rule,
+			  struct flow_match_meta *out);
 void flow_rule_match_basic(const struct flow_rule *rule,
 			   struct flow_match_basic *out);
 void flow_rule_match_control(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 3d93e51b83e0..f52fe0bc4017 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -25,6 +25,13 @@ EXPORT_SYMBOL(flow_rule_alloc);
 	(__out)->key = skb_flow_dissector_target(__d, __type, (__m)->key);	\
 	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask);	\
 
+void flow_rule_match_meta(const struct flow_rule *rule,
+			  struct flow_match_meta *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_META, out);
+}
+EXPORT_SYMBOL(flow_rule_match_meta);
+
 void flow_rule_match_basic(const struct flow_rule *rule,
 			   struct flow_match_basic *out)
 {
-- 
2.20.1

