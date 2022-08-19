Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9260E59A94D
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbiHSXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244141AbiHSXXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:23:55 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757572CCB3;
        Fri, 19 Aug 2022 16:23:54 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C39D2320069B;
        Fri, 19 Aug 2022 19:23:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Aug 2022 19:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660951432; x=1661037832; bh=FD
        LEgZ53CJkDbzaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=I7M/Dbu2GJQ4twQR1u
        1z57XmoAxtEAIv5i4nJQw3IqraUb+YV7g9p1RTXDNoO8YmVLj4Tyqb7ujvZJmkjF
        ezu8wlxKDjb/X5QkGbsu8riJNDPIYZz0EgNEu45m/esqxhWbKJAIPiKKOIewRre/
        XnkKBnoClwhc1YMxadGYRQ/IiOd2GZj+tdjI5bFrcGIyiEskuIVAw4FWjfkCCMGJ
        RlKWBS7NfL38Q+ehboIJ7U5BykGbPxZvGcbgLeZec3j7XmCdOirLTRmfqQlHipDX
        8AtUv8pF9vOWirA4jaYFUPYqpTcpZOF9uwk+tefSv0/uKlgpC5dG7Fl9Zz+aPmUx
        CiiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660951432; x=1661037832; bh=FDLEgZ53CJkDb
        zaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=5B6B9Yf9EKP0Vgs2nFxKPirRksYN6
        kFglveQt2XN0NzTYYP0YGJHlQ95oWAQfTzxWrZM7tQXAiPs5+/2y/TL8ITx5v7te
        spwkdKtP0ZfYf07bPVpMvz42M/q3FFVAHFqtYksje4hNCMFplYfUf1oP1iUSG8TW
        yX2rI2S62HU7kAv0tYzPrYwfO9wAu+rnXuxwnv0Y3c/hcox/n+hBxveX5ROAZzca
        BzwbC05TN8a1yr6gs7m8UMFYcJZSQrtXyA7Zijkrm9jdo1wRc0EjufwkfzA9uvyC
        mO1aNMdFGi0lr/yBoR4xGwTKCYhMwwUfGxKztUBaYFDRN0BT4CmtODuRg==
X-ME-Sender: <xms:iBsAY7H1Pf8qpE3Sks9zFT1-gkHAyr934A6m2xBgIT4FOrsJ-QjW7w>
    <xme:iBsAY4W-QJ0MSVA76njI_etWmfzbQ4BYNoAKp9nxr57N0CnQyNMaTytyx7b_3vg_2
    N_LMe2TviuvEACgYg>
X-ME-Received: <xmr:iBsAY9L0uA8FAf3uCKcNaeo6zSScPO2eCOreCa6Jj9217bn25zcHrGo7kACiCuBSttIVmpBJ8gbj2jH9n8k3J38tfh7mK-Sh0vKR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:iBsAY5FVMPDia5fX4Ua4q5HPulr3lX9CrpiJ07FauWYDsDLJ7PQyiA>
    <xmx:iBsAYxV5ZI0B2BPiArYeZKmzLsIRgS9WjWFwV-T1cF6m480wUZ5p7g>
    <xmx:iBsAY0MI087tdzRIvcSKkvCHvi_2rNOwb3S5iFvk0qRWrbSfl-sqsA>
    <xmx:iBsAY8Oxl0Zf0GZVVSbnD-Q7N4ZYGn1inlA8LdRY8nE0Ibcsogq-wA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:51 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 3/5] bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
Date:   Fri, 19 Aug 2022 17:23:32 -0600
Message-Id: <919843fbb5b3488f2b5f66edbb49d54ef29e3bf6.1660951028.git.dxu@dxuuu.xyz>
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

Returning a bpf_reg_type only makes sense in the context of a BPF_READ.
For writes, prefer to explicitly return 0 for clarity.

Note that is non-functional change as it just so happened that NOT_INIT
== 0.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 net/ipv4/bpf_tcp_ca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 85a9e500c42d..6da16ae6a962 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -124,7 +124,7 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 		return -EACCES;
 	}
 
-	return NOT_INIT;
+	return 0;
 }
 
 BPF_CALL_2(bpf_tcp_send_ack, struct tcp_sock *, tp, u32, rcv_nxt)
-- 
2.37.1

