Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C513EC1C8
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhHNJz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhHNJz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 05:55:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96592C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l11so15162523plk.6
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtLOOO3xTQU/BNF8IScqa++f9UBU8LRR9TjCuJXv4Ss=;
        b=DPwpsxsLPwYD5FPr/h+9+WwLixMdg31zCuV/romby+YscnF/O+HNO3cUY0Svp1yG3x
         946mhAhXWHa/QfYJuVtufZKTnCS9XzcTUSprRC4TnveoXtMy4neLc9B9JVetMXWuu6vp
         YsCDXkuAOf9nhBoqaLeSrn3f9Is2ejrr1uJydUibp+CokYodcEGffJd7vPk9JYCY6Zzo
         50FjPRSys9g6pVEWA7YnA0G2Q+ubY91ywhJWd23L8/3RfQpcjiMjVW8320t90rEsUceE
         +3C+KT6Yxs8/xZEbsv1FPPDmf5TroYtmDl98h0vlaESEADrckxxRZCA+1QZbXmTzz6E6
         WZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtLOOO3xTQU/BNF8IScqa++f9UBU8LRR9TjCuJXv4Ss=;
        b=VzfnjOW4pKkSRI3Jk/XACSiQHzAlHBkplKJIjtOw1P/p2QvOgk7YWUJEz+1IH0xZi4
         y8G/PrCoGc4dan/i7QsmFlBZymNUWWYl+4XZ2kMqWU/SijQD9ClLfGtyjf2Cy5uHlf0H
         lYITLvweeIj5BdntQpR1IFarTeA+S/PSfevv4a5hcRQKOJ94wPOrBbBSII/BG+GzYdVt
         hDO+DQhLKWBAeQ0kzl3wBTC45bHb9TSQRAGB/j7Zhr8sEdPAfEg6q5os0xUzIbF5Tc6b
         Ex62Cp6S9pMe+3gSAEsxz2w2/9v/BQPtV9YZmpbzK5MaEV4BT1f7nhSP/LQp1XH+pdOC
         5/xQ==
X-Gm-Message-State: AOAM532GlieZIDHBkvu5rAbJabsJObLEtNf3WRAHT6x9qDNPLzxgAZGs
        TgdqWk7CHk3zivS9hRC4ux2C5W+5Sy1zfw==
X-Google-Smtp-Source: ABdhPJzCTHi7SqqhTGNo7bdQaDWux/IEy7y0Q1Guy8dpyxwqfcfMSdKKwHENQufwNJCC20NMB+N5ng==
X-Received: by 2002:a65:6a0d:: with SMTP id m13mr6137688pgu.371.1628934929040;
        Sat, 14 Aug 2021 02:55:29 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id y7sm5220436pfp.102.2021.08.14.02.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 02:55:28 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next 2/3] bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c fdb"
Date:   Sat, 14 Aug 2021 15:24:38 +0530
Message-Id: <20210814095439.1736737-3-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814095439.1736737-1-gokulkumar792@gmail.com>
References: <20210814095439.1736737-1-gokulkumar792@gmail.com>
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
 bridge/fdb.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 37465e46..21433dac 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -192,10 +192,14 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				   "mac", "%s ", lladdr);
 	}
 
-	if (!filter_index && r->ndm_ifindex)
+	if (!filter_index && r->ndm_ifindex) {
+		if (!is_json_context())
+			fprintf(fp, "dev ");
+
 		print_color_string(PRINT_ANY, COLOR_IFNAME,
-				   "ifname", "dev %s ",
+				   "ifname", "%s ",
 				   ll_index_to_name(r->ndm_ifindex));
+	}
 
 	if (tb[NDA_DST]) {
 		int family = AF_INET;
@@ -208,9 +212,12 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				  RTA_PAYLOAD(tb[NDA_DST]),
 				  RTA_DATA(tb[NDA_DST]));
 
+		if (!is_json_context())
+			fprintf(fp, "dst ");
+
 		print_color_string(PRINT_ANY,
 				   ifa_family_color(family),
-				    "dst", "dst %s ", dst);
+				    "dst", "%s ", dst);
 	}
 
 	if (vid)
-- 
2.25.1

