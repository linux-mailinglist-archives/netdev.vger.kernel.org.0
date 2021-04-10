Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACF535AE1F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhDJOVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:21:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39771 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234836AbhDJOVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:21:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CDFE15C01BE;
        Sat, 10 Apr 2021 10:20:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        G1F2fDHqZXAnu7GAO+4YC0JgSWJLXjPEuJvtZBCYYps=; b=kbCdDicWkkLVWGY/
        HpDrZY9IiNCSGXhbmQI9s6KcIwpkq8nwHqGkn/48Ck9M6Uiee2c0tET9SSqCHsIm
        Pvm5KDwtFRXBYPOjJF2wgmgTSZf6Mj7RD/bWjNncLZ/+wsmtMBJhtcu5phaiyqbt
        FsmnJbYdheDZ9YMlSWBl1ZJa/AVYYDJtJrt1JR50RfceioCtczn7PjrncDiPdQpV
        Vk/O0E6KEIijJWR6pvo5nZOPEMJpEB+3hJ2LQR1wvFGB6NQXU4Qw+aObF8UVuPMW
        Jo7T/PgG1UAJp03bveaxbLoObTLawgqJ8xIDpaZKAukMZ6ku7SFBTsSHwaAOzQak
        IzxbGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=G1F2fDHqZXAnu7GAO+4YC0JgSWJLXjPEuJvtZBCYY
        ps=; b=ZAtC5gFBmwlVAHhfCjRoujsoAxKqXYCt03M7AzugEwhnxuZit8kt6onrB
        BSyKwWl5t9QkXQW1uQC1GM3w53v9BpdGZ4VFQ4GKdWuESKNiQHlPiJYQJZ517lpB
        QEgpmXyFGZ8WbG7UpYygTlevc2wPeSCr+ElPn7hGMgLVIBaeYc6N07TrCFRngrHV
        7kJ9xLvsnKZXXHCFAIw61idby+L7v2TA65k8ZLD5rfyAsicWRY8qZ7GaGSMaTx4j
        JtYTJROvGrzkXMuHyBb8cTQ8Gx3KVzQFD/oVaCul2+kiyF74y9EiyM+VafyVgAp4
        8SBXkCSrlKW7tjTWSeYg2fxuzM1Bg==
X-ME-Sender: <xms:QrRxYCg507NhSrM3ik8KLjOiwToaJdYk8_zuigS6kCCxLGspy4Oq_g>
    <xme:QrRxYDBiH__WHeyoO-cJ4vwVysWy3gXfspZgu82EAeddSsEGkQ9JyNpPhTtSGCKie
    bgbPUTDdjL5Ud5Ezw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:QrRxYKFGNO50hNr9TgibBSKSTpHWGlSWq66yRgjSOOEg6eDbhdKX8w>
    <xmx:QrRxYLQkBmOWZHYLejWVx3zyuCaXRCp8-VmabbzejsmRe6a9XRnHAw>
    <xmx:QrRxYPwcy9j5hk3ZkHPcM92IzynEL6cFyanhONJ_3aSzwf6vuqIGRA>
    <xmx:QrRxYIqS8cl3mbsIZhAvCqt7BsZJtUi74WmgHN5F6_qULx5CPEIAFQ>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D0B01080064;
        Sat, 10 Apr 2021 10:20:50 -0400 (EDT)
Message-ID: <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
Subject: [PATCH 3/9] Ensure Compatibility with AT&T
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:20:50 -0400
In-Reply-To: <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two issues to ensure compatibility with AT&T:
1) Explicity close connections to the mmsc
2) Allow MMS Proxies that are domain names
---
 gweb/gweb.c   | 3 ++-
 src/service.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/gweb/gweb.c b/gweb/gweb.c
index f72e137..995d12f 100644
--- a/gweb/gweb.c
+++ b/gweb/gweb.c
@@ -1309,7 +1309,8 @@ static guint do_request(GWeb *web, const char
*url,
 			session->address = g_strdup(session->host);
 
 		memset(&hints, 0, sizeof(struct addrinfo));
-		hints.ai_flags = AI_NUMERICHOST;
+		/* Comment out next line to have AT&T MMS proxy work
*/
+		//hints.ai_flags = AI_NUMERICHOST;
 		hints.ai_family = session->web->family;
 
 		if (session->addr != NULL) {
diff --git a/src/service.c b/src/service.c
index c7ef255..a3b90c5 100644
--- a/src/service.c
+++ b/src/service.c
@@ -2527,6 +2527,9 @@ void mms_service_bearer_notify(struct mms_service
*service, mms_bool_t active,
 
 	g_web_set_debug(service->web, (GWebDebugFunc)debug_print,
NULL);
 
+	/* Explicitly close connections to work with AT&T */
+	g_web_set_close_connection(service->web,TRUE);
+
 	/* Sometimes no proxy is reported as string instead of NULL */
 	if (g_strcmp0(proxy, "") != 0)
 		g_web_set_proxy(service->web, proxy);
-- 
2.30.2


