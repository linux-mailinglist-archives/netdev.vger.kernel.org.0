Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40ED59C633
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiHVS13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiHVS0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:15 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFB3481D9;
        Mon, 22 Aug 2022 11:26:13 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id EE5D332009DF;
        Mon, 22 Aug 2022 14:26:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Aug 2022 14:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1661192771; x=1661279171; bh=LS
        KB15JNkOM6IStOUGGM5d6X8gu4EdQM8BDl4wVbxpY=; b=nqjfk//FtMa2MoirZv
        jk5oQjexN2OO9FATNA9UsX8hVUMSUMMaWgfGdQjX6FyEWiS2Tswm9sm37V3B3YBg
        1k9b3vTM8gIHN7cxb7TqCAL5MwtSweL6PT8IHsoQKln0gW6lKOUwbvf0a+m4LbfZ
        99AP8UORLD9g2cspJ4qe0j9YTiB4jk0jFeFBt8Wd7uO5bVKDvW5qGr6hBRNPCCQQ
        uG8nG32fr8LW989VuzIgAyop2zTfi3ULgnj4zUAU7SUVwuX8bpe6mfh4lj1iXnNf
        E+HSi6/zCchFxthMOEiAosB84w/+j4WgLPSF4jENnSPrLB7WvdunHB9N9atZo8xV
        ONHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1661192771; x=1661279171; bh=LSKB15JNkOM6I
        StOUGGM5d6X8gu4EdQM8BDl4wVbxpY=; b=fxh6f/XgGL11QfGuHmuS/ham4YqUV
        RwgIv0dG7c6XB7zB4RzvHLQnogbqbv7jSc592N6Z1DCY0M2Et8YSF4OgzSQG4goR
        4LIQxJd77YM+9t/KG07lXUpYSuKExi0OUR4rU3K1gmuLZlusmNeFeTRlCkcc5gov
        mPoIcjlWB/xcsU2HJzUIdE3YZV0ThZKSp8AkLXryBiJxbvLa1mvm3zaSwDuRrn+g
        RHKtHL/iIH9F2yb3mTInlOKMwS3uNYdG/K1Vv/t3at5nwLtvugN0XbSxChh4Icbj
        HjD2lbssXur6jcNz0FAAL3PYbu1EgsSzi0trqLkt1J/rn0FdfK3xi/3cQ==
X-ME-Sender: <xms:Q8oDYyyjQafl9Go1EGdeNiMDQDnLXvSbW3U22YYOPLoBd-5MmtIz0w>
    <xme:Q8oDY-QdEgz_AztRch6z0yezbfPBlFWlZ1kSbWlHPSMg3l_4B8e9QMZG9C4q1LgHD
    egjq8BXhwJPFK9HZA>
X-ME-Received: <xmr:Q8oDY0XqIajjseZeC1RSk3nOtbcYILijL3A0Ao7gZsOoVDhwe25hBzpsF_8fQUsu_v22zDSQwYsGDkn--mz3U74mZbLrGnYKbyxU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:Q8oDY4gpaiEHkigwRgkt7nsaynFl9gsEMxecXLFMB3L3ysntClfrAg>
    <xmx:Q8oDY0CjJxFXt5pUgRxwXrE5QCq1AKgi6Vj9N2jQO4Jw1AF21fmqew>
    <xmx:Q8oDY5KecmqCVJFrWvXtyJcvnbuqJpNb-P5s1yRn4_vG-t4wjN3sDQ>
    <xmx:Q8oDY9J5FcWDPjjZVIpgHNgb_nh3oqibAweL_TBMwu8ZqLCurVKwgA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:10 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 2/5] bpf: Add stub for btf_struct_access()
Date:   Mon, 22 Aug 2022 12:25:52 -0600
Message-Id: <d99c0ed59940c82eb2d249f8559fb6cb83db3fc3.1661192455.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661192455.git.dxu@dxuuu.xyz>
References: <cover.1661192455.git.dxu@dxuuu.xyz>
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

