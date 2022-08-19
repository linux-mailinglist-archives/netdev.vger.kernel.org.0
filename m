Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038C359A965
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiHSXX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242454AbiHSXXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:23:52 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258C52CCB3;
        Fri, 19 Aug 2022 16:23:48 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 008F232005D8;
        Fri, 19 Aug 2022 19:23:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 19 Aug 2022 19:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660951426; x=1661037826; bh=3n
        Trx1gGoWVgblHqB1LDPbAAM4EJshkejU88GCgaCtI=; b=Twnpr7RhbB3SV85kvs
        c5SYmZFasjvHlr5iqRySqQpuBW+4CP+L+bTh5ydcExtcM0E8y7LWIFZ2V+qhN/qr
        BQljJq+5P9/jP2KXicqjkuqsIZSGs8+226fK2kgQlBqbRXWZybg88W5kkww1VlIY
        Aw5OaR4VfJkCOQ8xarwgnygpDEY/Z/eMLVaIo7s935cnN5q8frjoGVCCy+FR6TPJ
        XwnEV535Ptj/i2dBUvNcFD80Oxvf3JFq8u+sJZ9w7mTijS7YFiY6u0qlgErfXHQd
        iAfVZ3UDMGqvgX+Fl8vvZCbolL3owdg3bK4ap1nZp/Cgf0YUYKIMm6vaPQjikrq3
        HUiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660951426; x=1661037826; bh=3nTrx1gGoWVgb
        lHqB1LDPbAAM4EJshkejU88GCgaCtI=; b=s1rsfVPMGEZ+4UZT2KI6/KXp4br9v
        4VoNpUF5Q96JmMCm6jeE/z6FVpDyYYvUtYDwvQcQjtRlicb8Txaf3POHiryKoMTY
        jNigxxo/hj4kDqMcLuvHj3niFOFh+zbYn2P1bvhHs0HZiyWekLP9B7JdaVCYbNd8
        4atWnJgCWNtZj0xTL81mAPskZVB5AnPJXMEXvdfZq53K3EeD1K/HjEjpMfjEjkdW
        EMVWSIfAm+RuTI1J4m0OGiv9do3bSZLCky4j9aKXHsDJEShi/fuSmkZ7EtWz1DHp
        5w+c72I8l/IP6qo2hxSdLDejOKoh7bhgFaYpC8zzjMDd6sfs5ErnqgjsA==
X-ME-Sender: <xms:gRsAY_E59pIvzkdocA-h8WEHbnObLxpUzgMBQXUXt7b1LEgwm-rxZQ>
    <xme:gRsAY8VNB3uFUxUZgTee9E_A2W65z_DTz-IEGyDPbpCO4zUOPSEr-A4lC4GfzScUg
    KBJ3quCuQw5GBIyZw>
X-ME-Received: <xmr:gRsAYxJz93DzasoKTdhOPTSEM0TiHq6Qhq4fYCs1Nxhj82HWgAdyYBRhRZ9WiKgLjg-QZmswxe3w_15PlU0gCSjQwtryThcmGSY5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:gRsAY9GWOWA_Ihh3_LuhgPRaY16EJnnSh3ZOqMyFS9o9nt-IwpOLEA>
    <xmx:gRsAY1XB9DgSpiNDI9z4kDGg4ejDzkgTyfqb0o9B-ZsjmYeZjuAsRQ>
    <xmx:gRsAY4NLK5f7VDT3V3fdY3U5ir4cwSPHCxn-TyJ6XoU6hWRZvzl7mQ>
    <xmx:ghsAYwNFh07pETgDySj5o9VpRj7UbdtmwqQEVIjOB3mCs1y1nQdUKA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:45 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 1/5] bpf: Remove duplicate PTR_TO_BTF_ID RO check
Date:   Fri, 19 Aug 2022 17:23:30 -0600
Message-Id: <02989104a2f1b3f674530bb6654666a3809a7e5f.1660951028.git.dxu@dxuuu.xyz>
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

Since commit 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
there has existed bpf_verifier_ops:btf_struct_access. When
btf_struct_access is _unset_ for a prog type, the verifier runs the
default implementation, which is to enforce read only:

        if (env->ops->btf_struct_access) {
                [...]
        } else {
                if (atype != BPF_READ) {
                        verbose(env, "only read is supported\n");
                        return -EACCES;
                }

                [...]
        }

When btf_struct_access is _set_, the expectation is that
btf_struct_access has full control over accesses, including if writes
are allowed.

Rather than carve out an exception for each prog type that may write to
BTF ptrs, delete the redundant check and give full control to
btf_struct_access.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2c1f8069f7b7..ca2311bf0cfd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13474,9 +13474,6 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
-			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
-				verbose(env, "Writes through BTF pointers are not allowed\n");
-				return -EINVAL;
 			}
 			continue;
 		default:
-- 
2.37.1

