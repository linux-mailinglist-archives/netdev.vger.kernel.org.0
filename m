Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B15490FEB
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbiAQRuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241860AbiAQRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:30 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C97CC061747
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d10-20020a17090a498a00b001b33bc40d01so196609pjh.1
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=LDGATO42NpM9zpiTOiW/lKKoI0saJ8EGgRbb88Kykcu+7AW4v03gP1a28CdX8JuXbP
         rK53TnYikYzME8+WEBIe+MdhXIWONMmSmh+K6HGxJ27zMQ2eFh0Y8KaqamcWUlb+f8+6
         hwjvkqrkK0U3FUuu6H6phavqmjvMrgTdPhQwt6t+QEyBsCB/DmPVzOOir0p2/0SC7sa+
         5/UwB011YG/QJfxLP4R6yXHCNBi9zehhWxL5HySld1HPeMhrd42EWE9KbzCMuOoWFSsl
         c6cHxz+a5hxjFULN3v6tA8Nf1zdq4LKGvHC+iNy0Hpe4LKnkSkOpj7J8sVyxVk6+ixGe
         /08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=eZN1i/O/4iKGkeTd36N4mvY7CoBvUe5mVVWUpdvC4g9CMOklLRXpe18lUM7WDJuuCu
         CpSD22Gj0IMsAjqJzPUbhDYsncG8ry0aeQ7JbLmBYJWWiN/QIF6eqwUEhxSuj4LWLGsF
         4fWWPRQTDCqryhGrTybli6GQ2PPciYQyw6VmE9jQw8XGTIvxQWcrCApiZojNiAZCXlnP
         /JUpnUKynBJCHTG20qwm9aIsfjIChYMlbucASd2Fx0JbtPsxvFjYSE/gNAmPft0UcHi8
         2MsJIpSlJfLr1j/1oSerfdz/iMEVCoZ7kqW78c4zygQnIYCAmUH40+dRj+zX7SMjtw47
         cB1A==
X-Gm-Message-State: AOAM530BlTJcnz7ekO3nDrE9zX26w+yjW/z2AmGQ13eKCe9GWNsS5w/j
        zWuSC+Qapm6nKVMOI52N3e1Sc1irMZaBLQ==
X-Google-Smtp-Source: ABdhPJxakXOpdBkR+OyWpsD9spqRM4o9MFcUmUmsYzRYxz1j5azsUqe9CZRJM9NXrINnpeXHYxB9bw==
X-Received: by 2002:a17:902:6acc:b0:149:7087:3564 with SMTP id i12-20020a1709026acc00b0014970873564mr23814799plt.168.1642441829487;
        Mon, 17 Jan 2022 09:50:29 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:28 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 08/11] tipc: fix clang warning about empty format string
Date:   Mon, 17 Jan 2022 09:50:16 -0800
Message-Id: <20220117175019.13993-9-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

