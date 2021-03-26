Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80534A5D3
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCZKuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:50:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55583 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbhCZKub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:50:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 653275C03F9
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=IYlfc1XlDL9TKirFUtSm+ZAMmU
        IUqnlc5TJeSAd9y78=; b=h8MihDBW+gLqcU4bkzCxkKgMByK3uuZKH++pyg+uzB
        1eSjb0RsxcLV1SqkLiZIh8GvvCvo43L9td6jJsV0iMfVOhEQ1U0PNMpjflVBhhed
        QgYqK6WndNjOev3cpppVIJeavRHxidsZF+dLLW/aT33UiLVeVgibpaQks5PKQboV
        nA8k8TwdJnxqTdmtTPuy1BEIH3f4eVZDEg0PM1dMsPUxPAHHhJ+d+ihNF7HXSs8n
        9b5D/J5TgfyXL1XyUv6xMXX7KG2lQ591QL2eO+XZD55hHTNnAH8K85auvdI9oEsO
        5L4Trjs7G7dL9CJ9FmnekOJCikU2TRsb1Z8B9NE5G1dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IYlfc1
        XlDL9TKirFUtSm+ZAMmUIUqnlc5TJeSAd9y78=; b=N2NXkBccP8ntt2xAtAM1KP
        IjJ5Ckg8l0PWlBiO58EbxPHW9/tCrA6YEgTjSm4iDCoV8IuKhyOn1GnJGOxf7VJD
        sRuR9IUWa2z81feR6N0mTq9vchGS60ARbHHlJxp36dv1QS8DC+Bog9T/BCU7b2Pc
        aqPOsNyfezWZTHqvXk7LttVnxdzuxFFgKffbdHo9sFCzSlD+lvShLh9g/HLsQwVm
        Fu9wtxslZOEYHJ88/uzTybwE8QRLJ9ngPg/Th5Ewoaio2vtCg6FSAMiqNxz2YBGC
        b98YetIV12b+aNSvyIYIEal1/02zWh2X5Fqeyr7gZQEDXPn4h5+N6QeCqyT8pY5A
        ==
X-ME-Sender: <xms:c7xdYHIboH5CZkSrHjYMFy9i3n2jXH_VglL8VGPNE4YJnKt9I157jA>
    <xme:c7xdYLI34jOVYWTWmCIliVx3MvfcZQ-95fsATvO3trhDnxLcC4-FBxwV6DIX9z7sb
    IPMUJ2E0MkSdMaoKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:c7xdYPv60wCKMoP3gu49l8qQXb2oTnN9JQXckPVIB2cruCdeahVq5Q>
    <xmx:c7xdYAbLBhzOsEAlmoN0HreYtKVCrJ7vFtunDLLkt7PgdZTIcF8k2Q>
    <xmx:c7xdYOaZF6NAmLTlrabuIspeaJettEq1cjaATzoXKfFcBRCif-iEGw>
    <xmx:c7xdYHnCeRWmRpUyNCVZzFq4o96v6iOnxuIn638dgpLHVnahj3YfKA>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 419BC240067
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:27 -0400 (EDT)
Message-ID: <ebd9c45e179668619567f9b8bd9112e7d05d738c.camel@talbothome.com>
Subject: [PATCH 3/9] Ensure Compatibility with AT&T
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:50:26 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
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
-               hints.ai_flags = AI_NUMERICHOST;
+               /* Comment out next line to have AT&T MMS proxy work */
+               //hints.ai_flags = AI_NUMERICHOST;
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
 
+       /* Explicitly close connections to work with AT&T */
+       g_web_set_close_connection(service->web,TRUE);
+
        /* Sometimes no proxy is reported as string instead of NULL */
        if (g_strcmp0(proxy, "") != 0)
                g_web_set_proxy(service->web, proxy);
-- 
2.30.0

