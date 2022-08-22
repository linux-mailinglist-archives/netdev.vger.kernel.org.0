Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9C59C61E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiHVS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiHVS0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:17 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAAD481D0;
        Mon, 22 Aug 2022 11:26:16 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0D06132009FD;
        Mon, 22 Aug 2022 14:26:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 22 Aug 2022 14:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1661192774; x=1661279174; bh=FD
        LEgZ53CJkDbzaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=UJYfUVVs/mBxT49m9b
        n1uePz4uoXsZqBsr0bzGQrMFxhSA5RghnxKRxLpS1rKhio40+2RE9q+IbNufIXPH
        KcohpLadBTEiv1SIQ7GnQAE11OaKKuIWxZbMAgfz+qwAalVkyOBUulWsPi4Wd/Dj
        FmqcUir8kNBZ9BCuBU4y3NWbWEkUVht0BspPjA1GlJttQSAE/LW5LtxAVpuX/hIO
        QWIHL7IiBKCox3K1vtNiWUqP5/UP23ZmLmOL9Rpr+GFjHDrNvQBlfsFF5U+ErP1J
        lPYFc4ygLE0A75Joesy+wd0hcinLdM8N/q0F/i0U96n5C5aZk0R3c1Hi5OaVY9rX
        Le0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1661192774; x=1661279174; bh=FDLEgZ53CJkDb
        zaxSWQi0+Z8DuQ2sCXFgzw84z6QC2g=; b=12dmfYfDGodw4x0gBDzQayW+tZ7X4
        uwpaJ+jSuniBdfZP1DcareaWWlynO7aEX2TZrQztt40etAP7Rq9SWzsn9exeMM9D
        SFMsgnKwGiBlWiaNREKqNFc1snFR1f116xoejG6sEuH1sj8P+pIr00Z+6NZpk/f9
        5TTA3RnoVu7wo5eFj9thTyo9TU0lyH2CVjlEbmAyoXph3bxje2gdmETa4al25P1r
        nCQlr6cFCG1Y3LEMOn1EVHatxic1gkvfHujoU7KqkVZSoX32IwIqdTsz9besX+li
        AsSg6UfrWaapQjCxrnuRfFptqqksJSIHyuNmxWEb2beslqVIF7k5FjYIQ==
X-ME-Sender: <xms:RsoDY3Tch9cMAG3wcJpPQ5_E0BCbzf7A4ARMw7bN7casAWg5qOsZhQ>
    <xme:RsoDY4wxz--0W4qT-_YGpDirMKsipesTzndJo5aWVuOP7EKd8G-JfMPQoKSRCG5Rj
    R1b5-JsswB2PrRm1Q>
X-ME-Received: <xmr:RsoDY804LE6E3lTcLM-QuEs1bVBFctlYe4-Y30JFs5hfp2rkx0H1cJkzaESsO_VBtCD2Zj5Mc3qOBSbJxdRgy0pXe0fKvacUJLdi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:RsoDY3DJu2vL0TeXnr2alvnV5ATvVVYCfKy1vth-XW22z66xpk6Elg>
    <xmx:RsoDYwgpc6VSQk-anyd46rFdAZ1xh8WVR7pQBFJTrx7FWQvGy7hYgw>
    <xmx:RsoDY7pELC03hMqbmuLuoMdS8PAsemTkjIT1Ns7f2gkChSF3sKdHlg>
    <xmx:RsoDY_r5pPNWaQYPl--XQanR2KKk4Nw12gnJ8-W6yiGEdzxxBZaJTw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:13 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 3/5] bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
Date:   Mon, 22 Aug 2022 12:25:53 -0600
Message-Id: <919843fbb5b3488f2b5f66edbb49d54ef29e3bf6.1661192455.git.dxu@dxuuu.xyz>
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

