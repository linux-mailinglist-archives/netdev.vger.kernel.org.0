Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A5C3097C8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 20:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhA3TGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 14:06:38 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57923 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhA3TGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 14:06:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 37AB55C0136;
        Sat, 30 Jan 2021 14:05:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 30 Jan 2021 14:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=p5QLBBi0PqJEVMh4blUcldzbA0
        CV0zuQArtJpoYs/MU=; b=RT+X4LIvjVslThD4KMgf+j3VKAllgBKT6aMBKeGTy+
        KiLA6WLDVPRz6NbQHCUNQVLkLJSROuIseCN/APXV/FI04ruxhxpQ0HYLeSpJUe8b
        N7jZSC8ad6lrYjGY+JJ+O1EldldIRuDebrU8mSqJtkR8hnQt3HIpEByt52gT+VjT
        9jezYsKLVKZ847C78IBsQ3aDkQ1YVnTLl8o6bd4jUkb+gjUqSBph+M69ytQIlefn
        PJpSEr1uuCwFL5KQBzt8Ht3xpZ+Z9tDATX6UgRA/zRnOpfDvGqxVgiHgnFpWB2sg
        sax8PWCQyxDsiAxlYcwQF68ZthA2zJT2iEphMK+FInXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=p5QLBBi0PqJEVMh4b
        lUcldzbA0CV0zuQArtJpoYs/MU=; b=ZNhdQ8kHLmA0B2FUoSybFxooE9PJXU5A1
        KnyF3UeFf4MzdTobRzpcMIq45ekr+whN6EUkHZAKd880gRpZ7CSgrG9Zc5CWhskt
        nu7MH2wWrnopRi4aTZ13Cw/hWdK5ti5eKrT8MwNcVf+PCENyIPYIXcgKZhqnTkhT
        JjFOU1kND78odx2kSSdGnBfwJkSdiyMomsZ5nNdwyf4EjIH3VGFLY/r0uSKJ0Gus
        d+sRL4weQyvmnPtiLGo9nSfOyO49x1hGUt1KyjM4+V6iJsSgPfZA3pB8TsbKeQxD
        rOjTRHg/UFkCaC3cSSYh/XnOexADQ84qSqByunX1YnBAMJIF4w01A==
X-ME-Sender: <xms:-q0VYGrGqz5vTuW7C63Ou_geOSJf090r8Cs9oVbTxRU6MfW4z5HWZQ>
    <xme:-q0VYErTFCEruRijrvsTSXGRrTPIta5MxCp5VXp5dtUU27IS0Tdln51_el5WFJco6
    B41KQspMTiPTqRpOdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggvnhht
    uceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucggtffrrghtth
    gvrhhnpedvieffteeukedtleevfffhvdefgfdtffehtddukeetveffgfevtdefheevffeh
    gfenucfkphepledtrdejledrudelledruddtudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:-q0VYLPKSrcrFxJdsb5fGjKnK-6IuO0tH5WliJSvLhkHsVFiQlrBJA>
    <xmx:-q0VYF6M3Jhh_HaTiXXwGo9YHE8Y9IPiLFBADEZkULV4OsDVKKndjQ>
    <xmx:-q0VYF7872LBx1sOa7a7vxXcQFgOc5IkqjaIg5gHZTmucsVRnMhiHQ>
    <xmx:-60VYFH3DmfrtlV8wbx1c01slRTcu07vpU3f5YF1Flw80JHxtcLsUA>
Received: from neo.luffy.cx (lfbn-idf1-1-1264-101.w90-79.abo.wanadoo.fr [90.79.199.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34D0124005A;
        Sat, 30 Jan 2021 14:05:30 -0500 (EST)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id CBAE4D5E; Sat, 30 Jan 2021 20:05:28 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net] docs: networking: swap words in icmp_errors_use_inbound_ifaddr doc
Date:   Sat, 30 Jan 2021 20:05:18 +0100
Message-Id: <20210130190518.854806-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 Documentation/networking/ip-sysctl.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..48d9db9151ac 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1196,7 +1196,7 @@ icmp_errors_use_inbound_ifaddr - BOOLEAN
 
 	If non-zero, the message will be sent with the primary address of
 	the interface that received the packet that caused the icmp error.
-	This is the behaviour network many administrators will expect from
+	This is the behaviour many network administrators will expect from
 	a router. And it can make debugging complicated network layouts
 	much easier.
 
-- 
2.30.0

