Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E393245B7
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhBXVXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:23:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45367 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231160AbhBXVXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:23:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C7D15C0184;
        Wed, 24 Feb 2021 16:22:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Feb 2021 16:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=FCF8aonc9ebZcZPHGE96nk/DwPt6Xq8FPGjmmFdgfeU=; b=r4eVqGoNIZa1
        ncJwen/uBLeAl5gI3m0KT0vfj/CEfWoiY+jkItrtxho5o0y5njpAq9m4nWQFg2MO
        Y1xitlXpZYuzeqbJ4dIHCVnQ2kXHrE4xUWBKTVE5qOKQFR+4Wzxc5NB4HOPQwIl2
        WKUnSHueBh+rsfJxX1vZowihA3Bff7P5wDquHc1Ro+c7aPgK4u08hia3TPRqLR7r
        SvGEPp4lLyZYgHRV+MbDIz6pkHeIkIuNy7QsW44zgrogNKaIsB1jEIl5CpehChJz
        nm4If67mk2N0I/dZABqXLeu5MXPHD2NlAf50ltWy1uUMVal22g8Wct2kp7PBl04L
        ZOtTEMkfTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=FCF8aonc9ebZcZPHGE96nk/DwPt6X
        q8FPGjmmFdgfeU=; b=LElZT34yWUplxZyP4RFHnCnHfoJSa9nB1x6JTJFql9X53
        MIDz8rMfainJ8gVHAcxOBqV8aXVaOvtnGkoevpFqIDq7TLBk/xj9CvPRRzIUDcaY
        2gLwzratazOFC9TLTGYuQ/LiQbi8pKaooqHHBWEtWoGQmsqsj317Zf6v3yuNj0F8
        YnpEHe2o5/puP2mOR8XKVbdKpIh4Y8xL7KLFfGJd52FHwvOXZTHx89fAtgdLmMSm
        0mYpWDvymnc17A+qQW6Xyi2al8IzTJ19OHywn7pgre/Ql4l5MGcdpSwMwHIRyVOs
        YZgik21i49Yj1lV5WI61Bs7z7EQzTM8V4WDZ6HgaQ==
X-ME-Sender: <xms:p8M2YFbUReJg8M5DXclpDC5BcBZpajSqBEafe6krMakpuNmekdXtBw>
    <xme:p8M2YMbIvq-iYPcnQAg1XfZWjncUvtHCdEjUK5Gbcm954UNNTAjPB3x4ccywwGZF0
    22svETfhgIGhrhzALI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeejgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkjghfhfffuffvsedttdertddttd
    dtnecuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhn
    vghtqeenucggtffrrghtthgvrhhnpeegleekvdehjefhudehhfefgfdtvdduveetveekhf
    ekueefhffhudegvdffgfduleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    pedutddtrddtrdefjedrvddvudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehirghnseiivghnhhgrtghkrdhnvght
X-ME-Proxy: <xmx:p8M2YH-4hf6fj51zJIt4GzfSTZJoAeVs-PO5fMJl3aSgT2vhQU5hKw>
    <xmx:p8M2YDoUqf6AUR3GS14UeUIQdwzEbc4vnEBMQhPjeUQi_TAHH-cN9A>
    <xmx:p8M2YAp95YOe4UQ_yUEnlRQkF-G0DPCSTEjKgu5_sWLxJSJmGC4ZOA>
    <xmx:p8M2YNCsFOXHUgsZ0GJTGpldInX3pJ9iIoS-4ruXBiQrrzwQEb7reQ>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15DE41080057;
        Wed, 24 Feb 2021 16:22:47 -0500 (EST)
X-Mailbox-Line: From f4c6670a6348231d3d6f307a1313c6c1fb85fbe5 Mon Sep 17 00:00:00 2001
Message-Id: <f4c6670a6348231d3d6f307a1313c6c1fb85fbe5.1614201304.git.ian@zenhack.net>
In-Reply-To: <cover.1614201303.git.ian@zenhack.net>
References: <cover.1614201303.git.ian@zenhack.net>
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

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Ian Denhradt <ian@zenhack.net>
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

