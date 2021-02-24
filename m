Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658D23245C0
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhBXV0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:26:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54289 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234055AbhBXV0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:26:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7213A5C01A0;
        Wed, 24 Feb 2021 16:25:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Feb 2021 16:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=tnJKexTzKw0qVsJnjOY0FhPyQOVWwb55paZsLwXZnsI=; b=Sj8UOTKx5czL
        IwTyyi25XRQ1fpsEoEdt69hNcpSLmbG/QbiSlL0/HK69k1mVskwmHnCOttWf+Dvk
        QibSqVMPA8nEOgskaUxtYcaoa7fEpzF0h0zGFrdu1GHvUUoafKYl5mIoGR+K1hqW
        zr0w+Fzr03IhurgNyo3Xr3TvQwWVTOt8np8cp4Mpa9CaVnkdYQCe0uGG2asjFrCe
        u6Im8nTtvCJ2Fg4bycHQhUDG5pqQ01F9MKOR7mmXyNLUPloXGG77IGIg4rMI0lj3
        CNtwXrOtEOFUzGLuasmMyrtF0k4mRcyh8yLBXYmr5w/I4jGHvelAGTIh35d1Mp4I
        Dh9I2vRUFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=tnJKexTzKw0qVsJnjOY0FhPyQOVWw
        b55paZsLwXZnsI=; b=nC0XO5GxxbRygeckJ0aBZN9ghZJgwPi5QD35Fw4YzYaqp
        6B9z/urOeL6gVN6D7hSCEYbcdv4SPx7hgx1+d4qyXw0rdy7olXKYIgWa7p/G+/FP
        A5HntTww0mhIj1lmPo/MM33WwkHZdgajDR1L7Cl6Izx/1rBlZO5IwnK+VA2nkE5z
        VrcydoUhAum0XRK9yDstMH8x8BPiOWVu4rp6tRgaggwE52Lourg3ZSAVWtNznGBQ
        FR/+tfRLn5obn/14jLPkeMzzFq6O492uMX/Cqs47svoWwaFKj1ZT75IjtBB3gYnm
        qD0hSPbJPFNsAkwhPeeKoLRS9PV/bkzKdjcZ+DfYA==
X-ME-Sender: <xms:TsQ2YHWJjSI-B3AksG_Y59F2si8Alj4XtzFL-FezwEpQhnpZDQ2xaA>
    <xme:TsQ2YPnAlFUcQLvwVRf52YnqEK0r0z17QQAwnIWe8TvBwW9JWzmehD2uj1puSG0pl
    4GbZKWf9eIuvAaVvpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeejgddugeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkjghfhfffuffvsedttdertddttd
    dtnecuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhn
    vghtqeenucggtffrrghtthgvrhhnpeegleekvdehjefhudehhfefgfdtvdduveetveekhf
    ekueefhffhudegvdffgfduleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    pedutddtrddtrdefjedrvddvudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehirghnseiivghnhhgrtghkrdhnvght
X-ME-Proxy: <xmx:TsQ2YDY4ouDOysv3C6m7qF9rOrKPie977eWmsVs-gnBxQGHhDYPGAw>
    <xmx:TsQ2YCXfPU5jPyHNZGMUrC4sAMUF1T9it_5uI1RPbr2LupQerk0vbg>
    <xmx:TsQ2YBkFM-_1JlyAwiVC2S-G5wQBsfo6GGtAMlD1uc01k7BlxB93rg>
    <xmx:TsQ2YBvKQdouou9M7R_z0kHf3MiSwP_XlbrjiWMdpoP_GiGePkvWiA>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB217108005C;
        Wed, 24 Feb 2021 16:25:33 -0500 (EST)
X-Mailbox-Line: From a6b6c7516f5d559049d669968e953b4a8d7adea3 Mon Sep 17 00:00:00 2001
Message-Id: <a6b6c7516f5d559049d669968e953b4a8d7adea3.1614201868.git.ian@zenhack.net>
In-Reply-To: <cover.1614201868.git.ian@zenhack.net>
References: <cover.1614201868.git.ian@zenhack.net>
From:   Ian Denhardt <ian@zenhack.net>
Date:   Tue, 23 Feb 2021 21:15:31 -0500
Subject: [PATCH 1/2] tools, bpf_asm: Hard error on out of range jumps.
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per discussion at:

https://lore.kernel.org/bpf/c964892195a6b91d20a67691448567ef528ffa6d.camel@linux.ibm.com/T/#t

...this was originally introduced as a warning due to concerns about
breaking existing code, but a hard error probably makes more sense,
especially given that concerns about breakage were only speculation.

Signed-off-by: Ian Denhardt <ian@zenhack.net>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/bpf/bpf_exp.y | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpf_exp.y b/tools/bpf/bpf_exp.y
index 8d48e896be50..8d03e5245da5 100644
--- a/tools/bpf/bpf_exp.y
+++ b/tools/bpf/bpf_exp.y
@@ -549,9 +549,11 @@ static uint8_t bpf_encode_jt_jf_offset(int off, int i)
 {
 	int delta = off - i - 1;
 
-	if (delta < 0 || delta > 255)
-		fprintf(stderr, "warning: insn #%d jumps to insn #%d, "
+	if (delta < 0 || delta > 255) {
+		fprintf(stderr, "error: insn #%d jumps to insn #%d, "
 				"which is out of range\n", i, off);
+		exit(1);
+	}
 	return (uint8_t) delta;
 }
 
-- 
2.30.1

