Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE54885FA
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiAHUrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiAHUrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:47:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F30C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:47:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo2274275pjb.2
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPipWv3MHN1kYGMaxOweRrJO5QJl/5UqDMCci+/rpOw=;
        b=V703eSsNA1GnWu0LNnGyWPzH/mmL77kx4Pk2nD2SwWRZQCai66QInPPP/kcq4EtmLT
         XkXi6v7CYJ9Y8ZtWLcrAn/Ho6xC46/Ea0aze2B/JKGYEDqg3uxetrI1wD5DYKB4BYAdF
         Zk3ElKjmwt5ExdQpXblSDsd5GK9vGqS5DMdUr2ma0NwRg26WcVDGkcXcXY5xd60HV3JS
         rS4TfFf1LpDGlKY7OdsRFU9eKu/5l1KN6RjVy8In8KD+se11arPuLL/igX1yDKUjdje1
         VEi1gY8oe2vYOUbDTZiNVP6Ivk/4VDdBeS6Evker6XCObcVr9+HeO62+OE3Iim3D6bYS
         RC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPipWv3MHN1kYGMaxOweRrJO5QJl/5UqDMCci+/rpOw=;
        b=g1C5CqjhQBtvef1Y0U29mVbUYEMkGYquOu7KPdOmE0w7PNQkDgrwDWfsYXcWVcUg2q
         61ESp0slGnoi71b+0n179KWypodbS8+YrLaBzBa5twrC3JaI1Ry1070fxEsySvuhDWPe
         N/+CLg4EwvhqKChQZIYk5osxRabbzHVd2iTHsllaKlR3fIixN9ZOgSX/otCPsPC15+Ae
         c0RyOmVoQrVcxkOlwfKH6Se4EycvxiMAlTsVQW35VWwpMyzPFSaPpCNuwKwSjN4GX040
         aHZdNqEQM+Esv7kq5OpSviWALw/moGoQDRjVSObzc1plhrxxLpUKUXXPrW+9I4C0j79e
         sGfQ==
X-Gm-Message-State: AOAM532A/egqOotk5FdA0ut++MBgdU095ijEGLRyj5PWOvZvyZo+3osz
        xpsQHK+F4pNHIVadxh41BtM28asKG8HJYw==
X-Google-Smtp-Source: ABdhPJwtKBsMEbDPZ8cyRjLp0NDV3NRbdmUlZRojdVGhnChmyecYoeKp1qlcz3GiSu3Fs7yIxorp+A==
X-Received: by 2002:a17:90b:3b8e:: with SMTP id pc14mr22382069pjb.217.1641674821628;
        Sat, 08 Jan 2022 12:47:01 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:47:01 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 11/11] tunnel: fix clang warning
Date:   Sat,  8 Jan 2022 12:46:50 -0800
Message-Id: <20220108204650.36185-12-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix clang warning about passing non-format string split the
print into two calls.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/tunnel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/ip/tunnel.c b/ip/tunnel.c
index 88585cf3177b..9d1a745d9d2d 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -301,10 +301,8 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
 	if (is_json_context()) {
 		print_string(PRINT_JSON, name, NULL, value);
 	} else {
-		SPRINT_BUF(b1);
-
-		snprintf(b1, sizeof(b1), "%s %%s ", name);
-		print_string(PRINT_FP, NULL, b1, value);
+		print_string(PRINT_FP, NULL, "%s ", name);
+		print_string(PRINT_FP, NULL, "%s ",value);
 	}
 }
 
-- 
2.30.2

