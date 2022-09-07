Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDFC5B0A5E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiIGQlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiIGQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:15 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B35D6F277;
        Wed,  7 Sep 2022 09:41:14 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AEBBF5C0062;
        Wed,  7 Sep 2022 12:41:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 12:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568873; x=1662655273; bh=D5
        y7LBsTfA2G5+vFlB5ko5FSXYhn24kIlk/XNu21VS8=; b=eLLAEpy9vNDhxkbi7z
        GSn7iqaTHIk1P7cdbDzPEWVBvI9maqeFKco2eAI/6lmv5DmZfRjPgKWeUS0HHni4
        LFuFviw3vYnyOvUiRHNccPAPrh5vIiJ2htkAq2n2BNhTEXtTEg9kE6H29Xprybsp
        cnqGxQ59IogNbc7lN2EEgqJNkItdVZD4+URQDnCQkf3AHLTm1RMD2udMxgstoINO
        08M6ma5BZ2NNUYAOlzvAwtmdYQWtmD1+9/olm+5WR1qqAAeo/DfOqNG+qFVjAJd+
        BtJKtaf19taL98sRw/YUJP4Etq0GzKN7A3QgBUHKJDZ9aBgNK9a8VX5LuUr+9VBy
        Vghw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568873; x=1662655273; bh=D5y7LBsTfA2G5
        +vFlB5ko5FSXYhn24kIlk/XNu21VS8=; b=CapcKMzDawncHDB/v7I3K4TvtvhTU
        BhhOsUWCV3YZWDoMK/D7MBm7tDWHMIxb2zc1cAZvPT2BYhxwK6jiavsTgXxFDtGt
        vVlGEste6fKYetjEw9IltR18gSE2BTa4Mxv4Ro95wPyhlEIR9I9j+n3ax1eGW75c
        Dwq8kPcXScOt9rLF4+QCoYCBA0RkuIuAsieppJh2vyOgYnbMku3OEs4hliZ10hvq
        6F0N2maeuBMTkqE9g29K1gszY3pTED5hgzwlJHBfRRbPOKZc3+Yq5wTQE+r1Y909
        aULdktHGfkzrVgTnBLRvAHYEh4JsMn/IsPdueTmv5GUNoU9jsnfXmadxA==
X-ME-Sender: <xms:qckYY8Q_nxGeyrz7YAeoBXZmKwmpjEY9sSIOCZQnEKoXmJyFzoJfmg>
    <xme:qckYY5xavpygK8mNBy1Jj5_h0c0y2uBzdSLj2iU9MjxiqWXvpbzd-IbVy7FkBmSV5
    UpvKTZFQS2Hxyoegg>
X-ME-Received: <xmr:qckYY50UpYkhmp1lLH0lC3-dAQUEjWWWiuouYgMlvxnPGa2A72U6uaLkb282Bt9i4JZcaGysQ2IsZ5gGfTI1fhz4v8PykUppWcy-OoU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:qckYYwBBbldl_1YGFBQazVNlRfzKnsSN5NIDmBEC7y7sb_TFVvK9rg>
    <xmx:qckYY1hxm3A33FJ6oWvRN-B5hN3tW5dmqwg5YnmEync1PCxrjeFCLg>
    <xmx:qckYY8ruCuigbSpoEOqawZGn3WjTiXfYv1BUW9pTRwNtfjlFHmvlwA>
    <xmx:qckYYwpIwjKTKdTjTdDtZHkec1uPJAVCO8Tho_ZM12cB6sw7gKKV5A>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:12 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 4/6] bpf: Export btf_type_by_id() and bpf_log()
Date:   Wed,  7 Sep 2022 10:40:39 -0600
Message-Id: <3c98c19dc50d3b18ea5eca135b4fc3a5db036060.1662568410.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
References: <cover.1662568410.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These symbols will be used in nf_conntrack.ko to support direct writes
to `nf_conn`.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 kernel/bpf/btf.c      | 1 +
 kernel/bpf/verifier.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ea94527e5d70..fc926cd0b7c3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -818,6 +818,7 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id)
 		return NULL;
 	return btf->types[type_id];
 }
+EXPORT_SYMBOL_GPL(btf_type_by_id);
 
 /*
  * Regular int is not a bit field and it must be either
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b711f94aa557..86b23418f467 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -370,6 +370,7 @@ __printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
 	bpf_verifier_vlog(log, fmt, args);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(bpf_log);
 
 static const char *ltrim(const char *s)
 {
-- 
2.37.1

