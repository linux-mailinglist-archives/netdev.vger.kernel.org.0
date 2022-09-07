Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50C5B0A54
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiIGQlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiIGQlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:12 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254956F55D;
        Wed,  7 Sep 2022 09:41:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 887D35C0139;
        Wed,  7 Sep 2022 12:41:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 12:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568871; x=1662655271; bh=hY
        FJ83JcG+urZP7+IMjlg7r0OCJ7PpIC81fWd6bEpsc=; b=F14ERLK1DAg4qfJE9o
        tqEIbl2C6rG6Fx5rlaI9TNsWWVs6il0DOz333SLAXNvgqKMqTipOgVz18O6a8QY+
        vsfAzkfQZ5dsblUm4GQk7merhWTm/OTjOlTBUXMZi0VXKk/rjFt78/+aWecTLQUJ
        kxaPuueK6J5hJOBgRus6JKzg/KAUNinMt2Xp6Jqa7HpytNNy/Nlhs0z8usNQiI0U
        ANbRL5DjdBiKsKzCR8TtphgaRXSLdSa/5tdDKFy7+xa/UQdI6+udR0t/6JNtQtjr
        UNCjM9xaI1i/npGGwy6Zng1vWuLH0P5Dru9No8bDMTS/rq4D1ChczSoXG282WGZm
        mEhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568871; x=1662655271; bh=hYFJ83JcG+urZ
        P7+IMjlg7r0OCJ7PpIC81fWd6bEpsc=; b=bYdvbN3EpZKmWProVhlner19L/0Xv
        EAuSIb3e8+xol6sENFFkshpuQZxGTDnjHlsVlm14KkzinfOGkVCtM3lwXy+f+fi+
        jFPFuWj9r47NKayQmDaMShR69GH9Aa/hzPMRPDxY9EgIf1gYt4QS6XJf/lmo/Zo4
        k8kSHer7ldmWJVl6VKCkxgasWv3SaLGCVMc78plYgPpVs7sC3qODoztigzm3en7s
        WbjE4GPWal0VeAX3sud2ZtyAW014zT1W8iRZmQyFggS9pGUyvBPD3QCWcG3hOrt1
        NXNVEThnNgMSTIxK9xQdLVN3YhB2h0imUHtdubKBH7lydApZSH0PXIBgA==
X-ME-Sender: <xms:p8kYY4DGTCk_YK4WcIgkbvRRtAkyZtqw6ph8tCz9h_FFCNCyPdFrkw>
    <xme:p8kYY6ig_dXL49526pg-YSoj5K7JA4sikdKiFpXCfJuh4Xj53YsFxYTA5WBjSTVbk
    8gnrPP5fnqzVzMD-A>
X-ME-Received: <xmr:p8kYY7mvlL2lYlqi3X-3RF9My1oxjGkcSpmqRBHLQiJD-hGyk_uDghcxzqIKy6z8K1Y6bMkP7HHO9r5YAmSyteDuokkciEVb9G8t7UA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:p8kYY-xznv-8YlLSxdcjd8PCvRrbi4A54nd7vqD7xPCew4tfVrNHCA>
    <xmx:p8kYY9QncfRpv6XjjikOlMGOB-QdhQXslPvlHhssyiHqFWCRriKPwA>
    <xmx:p8kYY5YJTc4MuxWHOEoQKolGlSVtkhk9mDxGHXsaJIYDBMRBYByzPQ>
    <xmx:p8kYY9atMNI1x9fDdVsUdhaJU2TaNjRFFPvsLIyeVgGW8BX1BlYNGA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:10 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 2/6] bpf: Add stub for btf_struct_access()
Date:   Wed,  7 Sep 2022 10:40:37 -0600
Message-Id: <4021398e884433b1fef57a4d28361bb9fcf1bd05.1662568410.git.dxu@dxuuu.xyz>
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

Add corresponding unimplemented stub for when CONFIG_BPF_SYSCALL=n

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4d32f125f4af..cee2b008f2b5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2169,6 +2169,15 @@ static inline struct bpf_prog *bpf_prog_by_id(u32 id)
 	return ERR_PTR(-ENOTSUPP);
 }
 
+static inline int btf_struct_access(struct bpf_verifier_log *log,
+				    const struct btf *btf,
+				    const struct btf_type *t, int off, int size,
+				    enum bpf_access_type atype,
+				    u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	return -EACCES;
+}
+
 static inline const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
-- 
2.37.1

