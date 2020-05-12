Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D271CFC4E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgELRg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELRg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:36:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F8C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 10:36:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so6669534pfc.12
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 10:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zXF8T5Hmgxl4piOMIc8gs1joL11fUNjfjdlSBgbf5ik=;
        b=OUodHlpVdxouTSm8CwjlQlKg5yo9K3fhu767ZeOi4sq7doTWw6kj5QYMHCaYNPh+EI
         Wp7PMZZZaix2wE/9GyWgFN/tamn97u0a/eC6nKK/ale5LwDHlz8H6GAmH07UlHRw9a+f
         drVI5MKVFhW9PaY/0WXUry/Rqfv+7NF+gRbtWnGfzW2bv4vVdk0E3FmMI2FOFgecgsht
         9QffXLS93EovQ/kn2wkKDJIYUiG/kgTSKWgQEhHmush50hW/F8rL3ofHrDi8Bh/+fhWc
         gq9aa4wz8Ny0Q3Qmdul1BkQQ8KpbOpS9H3xGJoiro2m6/BwD0W/yx0F6dJPdTS1nVsQD
         vg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zXF8T5Hmgxl4piOMIc8gs1joL11fUNjfjdlSBgbf5ik=;
        b=iYhuAhcXMAbLkEMKW1rFqYODLVNB+7CRE+DoLk0P0bgDq7FLVJ5g4QRxTc85on+puu
         3vIekYkKAjvNikfIfaRBqIUyI9f7VpfrYcO8cLoqHAlO7++yenDBcr8BQHtHsG/zZlqf
         7HVWCInLSmLxFvi/d5GX2f4pyLsEZ+uZoFSBOabQYN8AmJWF3o3BEA5k5acjnTZoNapp
         gVcsoIfm4dputc1yFbL3ramkkS1uzcvKniukaagSdmgu3srAzlQPZjtiObAqoZHXC7wb
         CAzt2sN4O4dTvUXM9dle4pKxajxD6HB9oVy8GNaDIwoZHfEirK8PQ/8He3et5WjgsTf0
         81UQ==
X-Gm-Message-State: AGi0PuZe0ZJf8ixHc9N8N4vxQ344oSX3zLEM3Vxjdaxf445Se7yEfWVM
        zDb7zKCBog30JwSBnTiRGMdFGeuKp5Q=
X-Google-Smtp-Source: APiQypKr5JzySlKn9IIfon+KMXmIoDsN2ePU2RHXve0szUn41ILO/JwD3//zZlTdvEr0lFivIpdsRg==
X-Received: by 2002:a63:f447:: with SMTP id p7mr14942249pgk.111.1589305015801;
        Tue, 12 May 2020 10:36:55 -0700 (PDT)
Received: from sc9-mailhost3.vmware.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id k10sm12601930pfa.163.2020.05.12.10.36.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 10:36:55 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] erspan: Check IFLA_GRE_ERSPAN_VER is set.
Date:   Tue, 12 May 2020 10:36:23 -0700
Message-Id: <1589304983-100626-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check to make sure the IFLA_GRE_ERSPAN_VER is provided by users.

Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: William Tu <u9012063@gmail.com>
---
 net/ipv4/ip_gre.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e29cd48674d7..0ce9b91ff55c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1087,7 +1087,8 @@ static int erspan_validate(struct nlattr *tb[], struct nlattr *data[],
 	if (ret)
 		return ret;
 
-	if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
+	if (data[IFLA_GRE_ERSPAN_VER] &&
+	    nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
 		return 0;
 
 	/* ERSPAN type II/III should only have GRE sequence and key flag */
-- 
2.7.4

