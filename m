Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C503235DD
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhBXCn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:43:27 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54331 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232069AbhBXCnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 21:43:19 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C00F5C00F2;
        Tue, 23 Feb 2021 21:42:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Feb 2021 21:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=HjlAt4q1I57gcSh+6fE9t+TZP+zh66/1nuPwmJTGjfA=; b=YGmTgec/Bo4t
        Aoa035nUXoPMv1AwqNPT3X+f5Rygm+xIeSXV0TgBx1ZDbIPbj9n2fDxTTOV34jwm
        oseEUGc7ak3gcakN6OYuvbPgJH4BBAyR9OZnGFGsD0z+YXXWgF4fMmQGlAxwb6GF
        GuqugMwjiHYsGSMaEhCNM2cT5PTLhwB3X23oMeJN12umntbCzt6JIsoOPHmmNoOl
        xj1UTMyNu8yTXU/bTEClR0dGojgstOKzfkeKUYsHAljMFMejWdpkOzclRodvQleU
        0pFJwVZM4YcdLAVqQuYAdw/YsZ8+D7rCkKjqnfSEchysgZwMiLGgcJH0FqLB2qKh
        dxYNp+ZGcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=HjlAt4q1I57gcSh+6fE9t+TZP+zh6
        6/1nuPwmJTGjfA=; b=cmBbvmnHrfZv3dgdR+su34Sr4sDFFGJWpOiSWurjTmvQj
        2yHoBSTMGbpjzWBgQGkwKpsHLyjzXPh7wgiNbF3zIwKneIsuf0v77y3eVpCiyr/q
        W84qsjR3gBCKa9NXZMEvEVAGp0KLDgMOL3HxS1xgC2zjVY2PvGJme9UM+k2vLfWo
        kyIkzuNp2tvI7WkFgZq1OuNl7yawrBTjhR0vdtOYnCeetygty3Y+RSubgTxal3/1
        rYN8nbiK3EKjwd8M6TDPIODVAvYLXgRiyNtPz+VguoGZ0Iq8+me+rAUz9VPxqMfy
        NX9JIQ4AIihRBxMzNyegb9n4qb3TpGWczVxVeGhqg==
X-ME-Sender: <xms:Bb01YGjY8EwfziObWEby7LwHqHPtxDliJHaY-hgQWYNpclAe0H5CEg>
    <xme:Bb01YHCwzxy5AUUmTFpPbHTnGQApi-Zd_xO-wPhy4M-IcJZiLwYvDa3NHVWvfhY7G
    Y7YkKwAFG-5QM959p8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepkfgjfhfhfffuvfestddtredttddttd
    enucfhrhhomhepkfgrnhcuffgvnhhhrghrughtuceoihgrnhesiigvnhhhrggtkhdrnhgv
    theqnecuggftrfgrthhtvghrnhepgeelkedvheejhfduhefhfefgtddvudevteevkefhke
    eufefhhfdugedvfffgudelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    uddttddrtddrfeejrddvvddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepihgrnhesiigvnhhhrggtkhdrnhgvth
X-ME-Proxy: <xmx:Bb01YOEXk5tkzWEMNTC22gjJz9_UzmZpoqurr7fQ2zu3eR906HzSxg>
    <xmx:Bb01YPS8ZMsF_0zrIZAmuNoWBdptiIjtFxvGz-le41SItQDrCL8yHA>
    <xmx:Bb01YDxw2yDNMcAQFkjipPtkEgIQEid_-nLolfz4AWIcFWSj9MOQgg>
    <xmx:Br01YMry8r-Od4znNmTNZRFoz4sTDEAM5_b3Z6qXpKyF8hsHOwUhzA>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id CACF91080063;
        Tue, 23 Feb 2021 21:42:13 -0500 (EST)
X-Mailbox-Line: From af571eef0bc5d33180879c0c81a7d1b26431b915 Mon Sep 17 00:00:00 2001
Message-Id: <af571eef0bc5d33180879c0c81a7d1b26431b915.1614134213.git.ian@zenhack.net>
In-Reply-To: <cover.1614134213.git.ian@zenhack.net>
References: <cover.1614134213.git.ian@zenhack.net>
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

