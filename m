Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0494859A95B
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbiHSXXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243553AbiHSXXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:23:52 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED22CE1F;
        Fri, 19 Aug 2022 16:23:51 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D78D332001FC;
        Fri, 19 Aug 2022 19:23:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 Aug 2022 19:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660951429; x=1661037829; bh=LS
        KB15JNkOM6IStOUGGM5d6X8gu4EdQM8BDl4wVbxpY=; b=aNnhkpkMM66t/nF6lx
        rxcIKVCKw1dh1rDSWLWYFGdO9EWptrDD3I/bH83Wx8ElgFAnEUYoBc1L821VqsPa
        SOU9x0s0XvXeTVVwzppaiT+a7hZRApxjcJPEnF882GypKiUDcAreUC8QE7OHdAbO
        Gdri5mMQPA2vS/baf2D/yjZHM55qHF+NtNmBbr5+bWv2eJLmNfAI2W+2lH1jzBV7
        tDyVksP/KhKjjaN9DDDufebvR87fLHbx3srukx0ki5fP35f62pc0dJ2Yof3IXZED
        uve9GK6xiNYBVrzVwaYw3lvWO+ubLMdBbzmpZUWwi6TyHQQuThGYc/GtewluSnGK
        PhHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660951429; x=1661037829; bh=LSKB15JNkOM6I
        StOUGGM5d6X8gu4EdQM8BDl4wVbxpY=; b=ctNYSGSp0ImYJGkkPZQXTQ1a0wrDG
        4bwogzeUHbKr+DCOHuWVJs3WVf6LHzYUCE63tBMrEP3akaQVI6KWLbF+nllWPq0O
        /uWOPPCMs3dQ0CwAMjFVZTFQ2GIh/sjwvoF07UidVzQeOtmBQCl1FsPfalBgn22V
        nRH56LPTFL5A11MP8APngo4obBCSs2j3oQJDg4OlZk50tBSH7f/9qLcl4+5j61JG
        v3eu/jainwIR+mYSIvYbcfGAO107KGVmlO2Xara3d7GyWSqBImwt5BGbj4jGsFDV
        0ut3PX9VngmhHSnXdPAYpnhZHbWJtD3XoLmeJzl/NP/Wb15xyaMfKEsiQ==
X-ME-Sender: <xms:hRsAY-XvoYkWLxQ_fulC-Yz_zpiPrP0cpxpwSCopf_u3si6xNok9kA>
    <xme:hRsAY6n-jBy-TerGhj8wbWitd8otRgU-3BRUdUcSMBGO2St1Ra9maimyg2wL6JkPf
    T81HWUs6JbYg5kH_A>
X-ME-Received: <xmr:hRsAYyacAB7jdfTHC2z6AUMQBMKxB1e11OaPcjCnmza9aTo2exGlnEFFCUgziG-cb5EZurk1DRP93o8EwFtaPxl8IgeXQLWG1ouw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:hRsAY1UMeH4BYXQC14LD-Idykv2KbeiPuPNsq0t3FFcVCcBtq7_U9A>
    <xmx:hRsAY4li0QQz0_U0gtS4KpO9dc1TXrdJiJp9Mm5k7HrCXhR3jVLUQQ>
    <xmx:hRsAY6em4FDUknbxrqoJiDczosujBnjZqgdoRk9A7uhSqBgL8gckfg>
    <xmx:hRsAYyexmazcuglZNvl-iMsslpSE1-xd9ltntUiQBC2aC94q0nxFgg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:48 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 2/5] bpf: Add stub for btf_struct_access()
Date:   Fri, 19 Aug 2022 17:23:31 -0600
Message-Id: <d99c0ed59940c82eb2d249f8559fb6cb83db3fc3.1660951028.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660951028.git.dxu@dxuuu.xyz>
References: <cover.1660951028.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 39bd36359c1e..fcde14ae6e60 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2157,6 +2157,15 @@ static inline struct bpf_prog *bpf_prog_by_id(u32 id)
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

