Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC31548B4AB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344887AbiAKRy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344899AbiAKRyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:50 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C69C061751
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:50 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w7so18347285plp.13
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=voBmFCj2+ctsMRkYmn0CD07t5j/B2Ddl/W4ZGUOIMLDokDlMGLn4mk+vINk5OL4LwA
         DzgvEt7a4oo2DyIFPtkR95qtCTnhmVNx5bCPWEwOeOIub63FHviSPt837g3yhVejcWh9
         v9+ZMQcFsVDw3d8mXe3NRW6+eoKBlyTKTmxaNF0zFtf8/Uv9HTFG/dg7B5ZmUEveGVlK
         MWnPsn2AO40sDuPisuj3WWJrPG59yf+4g2j4p2QMum0P+FO7mF6TiECO5tFrhmYBywRg
         B2E6qjempVMkR85/zVF38n0QXM43vNFXVt+PwOLiesb2VWKiORWvq2ZCceJh3NCVRuHq
         hP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=VALtkX88FxQLU+nvVwN+7PSNo0L/1fJEG9aiXLH4bdFbCdfhivnI9Af0hWJoBztx7F
         CNu6+OkkOu1YGeQF9eNVtTBgpw1Ux87B9snf/7XjKSKrft/3BRL/FrxCTFxeNmL1o4PM
         GvnzaiK1s6B7d3QfssuwknSu1nbRh6YrgKP3EdWdiRRUbdU+OcDRjoqK5uWTSjTNkk62
         Rw7clkAlcJf7NiVTCfPtxrI6+R1/qMvfQ4txt+v0uevAkZl90OcShAGCoX/hLB3gBySl
         W3r8+wldO90O2CI3lFITY/qrLkzFFLvK4Pz84dXvyZg9kyHkh96SJ/zodfyB7Zj8D1VL
         m3YQ==
X-Gm-Message-State: AOAM533nG9rDhmVSx83MFo05wUUO3Ka1stikC6mSKJsVw1DD1O/K12m3
        jtsUsCeyl/CYfpq/SQ+J3DHsde9ODncGsQ==
X-Google-Smtp-Source: ABdhPJwf2bt8mR9Bfiek37m0Rb79spqX+lXllvD/xPKuxHq7HLVuKLaiPKERPi8MMXq++13oW3ZrWw==
X-Received: by 2002:a17:90b:1e50:: with SMTP id pi16mr4388785pjb.118.1641923689553;
        Tue, 11 Jan 2022 09:54:49 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:49 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 08/11] tipc: fix clang warning about empty format string
Date:   Tue, 11 Jan 2022 09:54:35 -0800
Message-Id: <20220111175438.21901-9-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling json_print with json only use a NULL instead of
empty string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tipc/link.c b/tipc/link.c
index 9994ada2a367..53f49c8937db 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -332,7 +332,7 @@ static int _show_link_stat(const char *name, struct nlattr *attrs[],
 	open_json_object(NULL);
 
 	print_string(PRINT_ANY, "link", "Link <%s>\n", name);
-	print_string(PRINT_JSON, "state", "", NULL);
+	print_string(PRINT_JSON, "state", NULL, NULL);
 	open_json_array(PRINT_JSON, NULL);
 	if (attrs[TIPC_NLA_LINK_ACTIVE])
 		print_string(PRINT_ANY, NULL, "  %s", "ACTIVE");
-- 
2.30.2

