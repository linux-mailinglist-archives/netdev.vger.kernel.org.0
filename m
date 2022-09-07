Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589B85B0A56
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiIGQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiIGQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:14 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FF86F271;
        Wed,  7 Sep 2022 09:41:13 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A00E5C0077;
        Wed,  7 Sep 2022 12:41:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 07 Sep 2022 12:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568872; x=1662655272; bh=FD
        LEgZ53CJkDbzaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=Y8UCcRfy52k1n+VUJ2
        5YBUSdMwmvEIK2kLIqj4I42n3NfPMwGxq1p/AftPnbMe+sghpgnUI0+5vShO49dh
        qpE249q1OYd2TzpAd4nXRfhqDa2jZsi3ZR4br+Zi5ESVU28JMlswv/Yrg7XmaLHY
        PXLwgaIcCrV8lWms4WsvbwiPbjlPAHdss+cjaQ0M/CZqYmQIUueTjju4N7ojKCAh
        OdtGbTyhiFWVHRTxLjCuoBGm4WQLW+E2ujttg4jNIFxvPLxMwYpTixsl5Yw98Sty
        GyMj4u3UkdXwA7VQkcU51KsvModxdvhUYRnmZyn9A8TeSCuYkgFmvXunrjkLiaL3
        ladQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568872; x=1662655272; bh=FDLEgZ53CJkDb
        zaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=Xy3tcBDJXTKkRDnUn/5C8AVI6YM30
        pmuvAYiInQocWKLMb8shnJV1tYo3E1zok2BuT4TaWjEZhakFCKBBC8Izof9smxhk
        l5c0alcLjfx91vmc/au9cuwcZB17LPJUwMR28Obt2GljFN1ErwlrNecHrqQsCX8g
        tVOklpLKWkiU1Fktk0Srevt/DJXD7ulbrbGWdSdHwLAXdQwmFw3xdMY7l5CyIQi2
        n7DR71aiGBHYBKv6JVtCA3lpKmaKdZE2OT2+RY/jdL8/09hxwJ4Zj+GnG85LwgMv
        kN1pFbzhXbPgvK31QLZEGRc0EyvVGxPkZ8+9KQpvoySCcqBGTYt8mI48g==
X-ME-Sender: <xms:qMkYYyJ0rn0Oss4fyy2AyU5nObHsmv_747eYFDb7Bt-0MqhbzQFqTg>
    <xme:qMkYY6Ia7BJidQuzMEeFooWTmBDKtOpIw3svKgL65Vmxic4LeN4cOsOR_OuBmLKhI
    SeFo71siXcsJN7Sbw>
X-ME-Received: <xmr:qMkYYys7LS-Zgg68fPH6Axwz8-Ayt0A4YDMJ6YaFluQRe-Dl49ZlLd3Kx7QxjL7-oqenjI0cukL4OCxKvzHjkF9y4AHdpp-p--E7udc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:qMkYY3Y_8tPqLYlD3FihpFa3DdCF2GLHE5CP35--x2c4NUcEdVwM9A>
    <xmx:qMkYY5bNNPRDQBrgSbw_TAIlVlLdawqzYFSuUKvwGJagjpyf79bDKQ>
    <xmx:qMkYYzDpXobPPUD9-CiElNIkfV1OTYubQ7e0ws1nau7_UD0B6Svpbw>
    <xmx:qMkYY_CnQcTHEFSs3V5dzOyUx5URlmvYTukUqHdeBXUQ6Vd90I0MoQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:11 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 3/6] bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
Date:   Wed,  7 Sep 2022 10:40:38 -0600
Message-Id: <01772bc1455ae16600796ac78c6cc9fff34f95ff.1662568410.git.dxu@dxuuu.xyz>
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

