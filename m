Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC7B3EF0ED
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhHQR3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhHQR3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:29:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B103C06179A
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so6427552pjb.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeFtRhSEJbzsPSHwAOVZxdiX+JzPhBUDakNsooVwFFY=;
        b=aw2kNv5zZt/Jzl5qxLU9BG1mlyb2D0Mk+O7qN8HQOjiaCBKoWGt6jneB8Gn/HqBNaQ
         vP4kwqEQhl/t3zBgXFxYl1RM5SUfBUgxRl46BN1sB2WSb2rZvIwdkllKrtHLWIQFMbCX
         3FoDvQPvMu2cbx+BY7PE0fcb64jM2Al0bLUDO4hZmDVWx/KdvZPMQXkuDFmowUb+Aly8
         9Mb8KEg/Hf0Xw3x8HTDkRIezw8Y+bWMkTf8vusgK5a5jyBq8VEiLdXU207ZayVGjdOqJ
         oFHDqktkelVua7G79wcKVowznwpk73GlsLF9E+Emm5HQmR6mYSeR7r5O+oVsoizU+MlI
         zicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeFtRhSEJbzsPSHwAOVZxdiX+JzPhBUDakNsooVwFFY=;
        b=IHekq7aVQwlk9W4fiXgBenF/LFi/EVSbxlA3tPo9yIlONFLdDWknOX8Lr3X51meJtM
         /jGAoylT8VGJpDbYkgYW9mDpU9lotyTXQ1atq65oqB5pcmsf9n7K+p6hjrd1kZ4jFtMm
         baQlfUxeptdqGPnA2XcBc6Fk1T8i9wbNfgR9GkSve+PIQsmxrtsvNVueyNanBzahH/kG
         F6l3QYnW9PfCco2u20fmRg0sfkoz6EMgJdbDFdUBos9a2k7xIA/X3UObgauxWyvQLarZ
         oXiYk+mMA/Ju6TVpIVRU2XsAnGzO3J6hS68ooc9M1jigynurLFfTUf7N5YlgRVS8L6if
         uNWA==
X-Gm-Message-State: AOAM530jZaR4DjKf4l/divVAjdarjjXD37HaeCdJCkD1ilOsPbt4zEOC
        iw72ssQ859YMttOoZBngXxTRsyfIn9Jq72y4
X-Google-Smtp-Source: ABdhPJw5OyiXb9BUWMGbSNLv8vciY+HfNtZ2Tjwj699ZPrmosNfiQpvuLygLpT4hRq1km5qpbb0jWA==
X-Received: by 2002:a17:902:c401:b0:12d:b1c4:5df3 with SMTP id k1-20020a170902c40100b0012db1c45df3mr3620806plk.15.1629221313379;
        Tue, 17 Aug 2021 10:28:33 -0700 (PDT)
Received: from lattitude.lan ([49.206.114.79])
        by smtp.googlemail.com with ESMTPSA id y5sm3872096pgs.27.2021.08.17.10.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:28:32 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2 v3 2/3] bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c fdb"
Date:   Tue, 17 Aug 2021 22:58:06 +0530
Message-Id: <20210817172807.3196427-3-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817172807.3196427-1-gokulkumar792@gmail.com>
References: <20210817172807.3196427-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be consistent with the colorized output of "ip" command and to increase
readability, stop highlighting the "dev" & "dst" keywords in the colorized
output of "bridge -c fdb" cmd.

Example: in the following "bridge -c fdb" entry, only "00:00:00:00:00:00",
"vxlan100" and "2001:db8:2::1" fields should be highlighted in color.

00:00:00:00:00:00 dev vxlan100 dst 2001:db8:2::1 self permanent

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 bridge/fdb.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 37465e46..8912f092 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -192,10 +192,13 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				   "mac", "%s ", lladdr);
 	}
 
-	if (!filter_index && r->ndm_ifindex)
+	if (!filter_index && r->ndm_ifindex) {
+		print_string(PRINT_FP, NULL, "dev ", NULL);
+
 		print_color_string(PRINT_ANY, COLOR_IFNAME,
-				   "ifname", "dev %s ",
+				   "ifname", "%s ",
 				   ll_index_to_name(r->ndm_ifindex));
+	}
 
 	if (tb[NDA_DST]) {
 		int family = AF_INET;
@@ -208,9 +211,11 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				  RTA_PAYLOAD(tb[NDA_DST]),
 				  RTA_DATA(tb[NDA_DST]));
 
+		print_string(PRINT_FP, NULL, "dst ", NULL);
+
 		print_color_string(PRINT_ANY,
 				   ifa_family_color(family),
-				    "dst", "dst %s ", dst);
+				   "dst", "%s ", dst);
 	}
 
 	if (vid)
-- 
2.25.1

