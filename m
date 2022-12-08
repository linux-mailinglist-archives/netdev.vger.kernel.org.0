Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051A96475CC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLHSxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLHSx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:53:29 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0450843862
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 10:53:26 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7B0D232007F1;
        Thu,  8 Dec 2022 13:53:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Dec 2022 13:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1670525604; x=1670612004; bh=oQpUiAzquAnHQSdwmDxVfY3Hv
        LBU3jBLxX/opSkSHQs=; b=vQz/Yl35g4zeIUVEgj9GFgP4o6ZzPe5z23UybDrCw
        r/UibbKuJuGgvsf3DdjHfj3COpwpASnQ2gNrZVKe3bgmb6tXOyRpz0tBxMWMcV7g
        YiO97B8IHhyhqZQsLWXNFHLiet6KiXc3WLXL9tL77WRdgcAwJDuVKgZCWM69NjaP
        dg6yeJieyLLxs/rdl6pB3vqzPeCfSIZ81FlyQkMJnV9jRKJpI05waE0pjNedHzD1
        6Kmkb1S3t5cZzn5pseVCMX0zCTIcNGsuaPZY4W5zphZDDYZ639NWIvCymLujVysC
        JgNlmPDc+NefdMW1NzzQOhrlUIJODWcRXr9Y3b5CPVbUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1670525604; x=1670612004; bh=oQpUiAzquAnHQSdwmDxVfY3HvLBU3jBLxX/
        opSkSHQs=; b=Ice3ubQTs5zcd+ShVjc7N7QtfSB7EdmNm0Qyd4EfUjkc7F8B+hZ
        jz8/dXg+sKyCRbKMWg54DkVV3eKuc5+o0f5swvcLnyvd3VOQT7e6XUf+wO0sZwl3
        DlkKrUPEj5PZt5ZkZlKZ9+4CNQhEc8bU5uEa54tVCsRY7hxOV4+6dSmK8jQpP44S
        tiGictxRGLM26428FpRuRDPQpSIGiTMsKY+2+y8t87c+9S9NBS9gvXZcmf2XdOux
        UiAKB04jpK3U72hYtpr6Eje/tVBafJKWN0A5lUaLZguB6JuMqCi1u+uGPlQHyYys
        Tv3rvZxZIrrqdeDbN2TT/k87R1zqojN4UoA==
X-ME-Sender: <xms:ozKSY9HLaQWacvaieyTgsqKc8sSYJcOhDCn8f2XtuOo8J3gOrv4RDg>
    <xme:ozKSYyWqy8Vrn28NI1NMHt93kdMzkdHAKfKPxsMkA-OHwVlYvcIjyvL9rvt7gdJxb
    cNxeB81eqA0YkqKSA>
X-ME-Received: <xmr:ozKSY_IHERrKfeIQDaVc9UNUYumVxjNTpmmJtAntSO0ZZW38wJytDMZ8zOFrTmlYs5dHeZARZnidDj89ypbts4gNRkXCkQDVk8FBCWKEqjY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepvdeggfetgfelhefhueefke
    duvdfguedvhfegleejudduffffgfetueduieeikeejnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:ozKSYzE6X9osXZokEn8r_rofm7jq8JZWvKleOU9Vw5tdEMLVovLtSQ>
    <xmx:ozKSYzWRQ-j_3eeu6n1h1zjwNls1PoTFyBw03ZbZ0vkZdAy370BhcA>
    <xmx:ozKSY-MN_ezJh7iFGL5kZaughLS1UJz0HmCsfWBzWIcr1uK-qZgMJQ>
    <xmx:pDKSY6f61j6EXYIJphTsV7vZi2zpUx4itUM7J5Ii1yqzWkUVrgjAaA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Dec 2022 13:53:23 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, stephen@networkplumber.org
Subject: [PATCH iproute2] ip-link: man: Document existence of netns argument in add command
Date:   Thu,  8 Dec 2022 11:53:06 -0700
Message-Id: <25bdd4763e23c73aca71f17d43753311de0c268a.1670525490.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip-link-add supports netns argument just like ip-link-set. This commit
documents the existence of netns in help text and man page.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 ip/iplink.c           | 1 +
 man/man8/ip-link.8.in | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/ip/iplink.c b/ip/iplink.c
index 301a535e..adb9524c 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -68,6 +68,7 @@ void iplink_usage(void)
 			"		    [ mtu MTU ] [index IDX ]\n"
 			"		    [ numtxqueues QUEUE_COUNT ]\n"
 			"		    [ numrxqueues QUEUE_COUNT ]\n"
+			"		    [ netns { PID | NAME } ]\n"
 			"		    type TYPE [ ARGS ]\n"
 			"\n"
 			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 88ad9d7b..6c72e122 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -43,6 +43,8 @@ ip-link \- network device configuration
 .br
 .RB "[ " gro_max_size
 .IR BYTES " ]"
+.RB "[ " netns " {"
+.IR PID " | " NETNSNAME " } ]"
 .br
 .BI type " TYPE"
 .RI "[ " ARGS " ]"
@@ -437,6 +439,10 @@ on this device.
 specifies the desired index of the new virtual device. The link
 creation fails, if the index is busy.
 
+.TP
+.BI netns " { PID | NAME } "
+specifies the desired network namespace to create interface in.
+
 .TP
 VLAN Type Support
 For a link of type
-- 
2.38.1

