Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4744B2C7C18
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgK3AWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK3AWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:22:38 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C4CC0613D3
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:52 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u2so5476204pls.10
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fKMan7oWGvWyjqMhG7qMLjXbclAI34cwErrXXBHsZqg=;
        b=e4z8twirx+GIHIP3GV6Nd2w33uGii2KiSZiH37qGJSBmqifDHgfZhQcdI12WJUDT46
         k0zWaJtXn4WKVa6+n6xnJVWMjWmpeEQEXgEuWga0DeppUgSaNRVvzNeFXzZHywtAOaWV
         Uii9oedA5NQDuVPa6KEkMDNok9WhzETeRxcgWhnfWHSuVZ8rz3cJZgSXrNKfUKdxrGON
         93oOm1d6Rxgehm0QkcXGB8pKB+APeQhPk8l0IQtdb+sBITEp7sCxffRuO8CSuXQzyzdo
         LOQvZiXpcaAZaZfMAwJtxrItYVVjaXxonWdKVTO4c0qqOTSAO3D9SCICgqXHbXZYY7Yi
         1P3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fKMan7oWGvWyjqMhG7qMLjXbclAI34cwErrXXBHsZqg=;
        b=qS4xYq8FSrcqfaTQF8lpon7iDlCIktNdmn5/nV83MqFf8ArZZGNFX02lW6RlfhVmlB
         zwmJlg6y9/aO6n0al38dVBhIvt4EUW4hri/aMt+b1WfSBLFqf9jmeDgnQO54ASNnD2sQ
         pa65ihBsJ5VZlIMLcIYJU99dgINtKictlBIDP1Tprf30aA6nTbzVleyKPPqB0ueE7cIo
         bdFHTVPRuyvx43kBbG/+r8d8OgD/byIUaBZ/gFOu4IJWXgcQOIIMxCYhcJCmXCk0S4xD
         2vQSlRTQTnrk2XPrqoxZGfNIhr6T/eZs1YzAHu9rzfh3lkcWV3JIC2odjs26faYtPNmp
         odAg==
X-Gm-Message-State: AOAM531xFQPPs2Zdf2uAaGofjwKhehPx7XmTgkqexSaRiOITqDfKU1Fy
        2GySfG8dZNj1oIhp/cr9v+SNpPA9okDXumKc
X-Google-Smtp-Source: ABdhPJyqJ2m2lMIcuckfrHh43XYHph7ECe2ig3XckhHLGVp7j/QHOkuM3Y4UhOwGQf5LgIvb1yKKPw==
X-Received: by 2002:a17:902:eb53:b029:d9:e57a:e402 with SMTP id i19-20020a170902eb53b02900d9e57ae402mr16398047pli.85.1606695711236;
        Sun, 29 Nov 2020 16:21:51 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:50 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        nikolay@cumulusnetworks.com
Subject: [PATCH 2/5] bridge: fix string length warning
Date:   Sun, 29 Nov 2020 16:21:32 -0800
Message-Id: <20201130002135.6537-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
References: <20201130002135.6537-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gcc-10 complains about possible string length overflow.
This can't happen Ethernet address format is always limited to
18 characters or less. Just resize the temp buffer.

Fixes: 70dfb0b8836d ("iplink: bridge: export bridge_id and designated_root")
Cc: nikolay@cumulusnetworks.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 3e81aa059cb3..d12fd0558f7d 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -74,7 +74,7 @@ static void explain(void)
 
 void br_dump_bridge_id(const struct ifla_bridge_id *id, char *buf, size_t len)
 {
-	char eaddr[32];
+	char eaddr[18];
 
 	ether_ntoa_r((const struct ether_addr *)id->addr, eaddr);
 	snprintf(buf, len, "%.2x%.2x.%s", id->prio[0], id->prio[1], eaddr);
-- 
2.29.2

