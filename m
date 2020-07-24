Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5B922C4EF
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGXMR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXMR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:17:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97923C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:17:26 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gg18so6376683ejb.6
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r0XXjv5NIan35Cvixq5mkpAqk/oQk5lQeUFLVMcFoY=;
        b=fbRO6cQPmknwCmXslvagCsZXIfdV9WKyJMVF+by8QrQn7WQtJJ7h9j6VKuRsVUY5xo
         vW3PwlxCI2dnakLGVKazhCPFlPSoCjSwp/RcVVCumV9HSNDt3kvgmjoTShsyhfwJi0Oq
         VOg1RzdE2qgkm+/jwF/vwjdH9CLmd0tpDXA/RA8JQPzOa2P1w4TlkiuTpeW5B5DErx0l
         HF+EWGEXHiQIGGOS/xXSNio0bkPdMbA7UYvg1GrLMb7E7rNg6UQHWxcYYHCEG3tmFjBD
         XY8/LkZ1ZtNj2C1F58a4jKO6tqlums44gYFGW3cX7uHgahGX3iW1BsXI0lUsq0ZOntap
         /oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r0XXjv5NIan35Cvixq5mkpAqk/oQk5lQeUFLVMcFoY=;
        b=W3a0Ii3LksB18kPpg0x64MoRfYT+5U2BOTO9qh9oV2Q60Fvztbkgkh56Fhj92IsiyR
         bNXY2BKGJuh4riLSJdQhLEDKUsUNR1zIBvyWqi3rdGkhOnmIafo2lnYTevv57x887iTV
         NCZfXbaxSLvpONnrhwMieVTKm4G0Zrsr1xHOunFbRhODtj+nXx+GEfXZ/geb2KLd/40y
         YRj8bCG+5L9vVK6bzaKBb1bt4oqZCo1qpF2ZUOV06SixELhlTD+A8uPT6tsS5Oowzz5Z
         si4DoClr7SGRUHtvi1M4XJCyXCwmAlhDS1EQMRJXTDhH3q/mGEpv4E1BQZpWI4YcC9V+
         tc+Q==
X-Gm-Message-State: AOAM530K7q6c13nZdGUI0EKZemopNfmVi6ktXUv6I5EUnbWMHXP/4yr5
        3uXSY+cLuO+6F8xGf0GW4mY03cNjmfRDnA==
X-Google-Smtp-Source: ABdhPJyjZK/KFog8kppXokuJ0RVnSfSzEMbusuZA171Ofc01XwY9TLnbG5PNVGvihVO1B8B4LR8f8g==
X-Received: by 2002:a17:907:100a:: with SMTP id ox10mr137764ejb.351.1595593045193;
        Fri, 24 Jul 2020 05:17:25 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id 23sm630642edw.63.2020.07.24.05.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 05:17:24 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2] mptcp: show all endpoints when no ID is specified
Date:   Fri, 24 Jul 2020 14:17:18 +0200
Message-Id: <20200724121718.2180511-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to 'ip mptcp help', 'endpoint show' can accept no argument:

  ip mptcp endpoint show [ id ID ]

It makes sense to print all endpoints when no filter is used.

So here if the following command is used, all endpoints are printed:

  ip mptcp endpoint show

Same as:

  ip mptcp endpoint

Fixes: 7e0767cd ("add support for mptcp netlink interface")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 ip/ipmptcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index bc12418b..e1ffafb3 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -273,7 +273,7 @@ static int mptcp_addr_show(int argc, char **argv)
 	struct nlmsghdr *answer;
 	int ret;
 
-	if (!argv)
+	if (argc <= 0)
 		return mptcp_addr_dump();
 
 	ret = mptcp_parse_opt(argc, argv, &req.n, false);
-- 
2.27.0

