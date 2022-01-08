Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047324885F9
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiAHUrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiAHUrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:47:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7A1C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:47:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so11350116pjb.5
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=aOmJyD2h62/vzqTFTZ9dSI81mhPGV87FukXYQ0Qhzlv4P+TbUnZQBDbXyJUxPw5hiq
         1GBXjojr+FaOaJ89zvgmQsNptzMm/JvwFvANCld2U5MiluYbgt95PTcKo8SqI1i3jYBD
         KBOHOqnOVQoKtGOzdwHvZV++4Z8LTILrP470qbq/m4L5eLAhSIkJD+i4rEqrsTczU97I
         X/60YXDlgqPhACcTYJfKz4hlSd68aU+1qumjDzI+xa53t+Py3ZUF/YgyC+D7paxALJAJ
         sfNhFohuI8bUCOHz6EfHAKy/J7JHA50ASsSiQ+NlYUjuWxkDG+/rNWL2+3cF3v9GjCjA
         hb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=hr3BsCyIFe6ilOOvk7GvOSi1CiKRIEPuyomcyk+P2jzoj47iHiJtRPFGaQbVlYvdy9
         fLVyPe85dgcJRoh67AQnbqTasixEVApo5XLjTk2MjwEFZ/wXkar3VGjPqbx5EW3NCYPT
         3xTJBK771c4E4BerfV0QFFxnY2xZLDO4HERxs0M1UF5iKqFhDVl9394TskAHRUaw8CLE
         gr4PrIPVIask7xvoAWgwxhHsXkzNYRFIOMNiDwyVREJfhrE2X2Ckp14HPMAR7KB2CFfG
         O7npMeQoj8XOmSljWswB/MVpnGjF4z8N1RAHKRZKqKrm1feF6j47S6FxU3k+Q9sm7A5D
         8ahA==
X-Gm-Message-State: AOAM532KyTKhwjFpzWYyJL42EmrgxUE0bkTqqSAAiE2HTk46oXt8g9DD
        NwsZH0aqhxdxh1sunPowaq5OSeWLCmLioQ==
X-Google-Smtp-Source: ABdhPJytdgbyUTyzPcq/1+ye3UML6a0vhHIfPz/6F+heaQBpdhMqlLH3vynWOxI028o1P9LMA4tm1A==
X-Received: by 2002:a05:6a00:ad1:b0:4bb:b74b:a494 with SMTP id c17-20020a056a000ad100b004bbb74ba494mr63238385pfl.28.1641674820775;
        Sat, 08 Jan 2022 12:47:00 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:47:00 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 10/11] tipc: fix clang warning about empty format string
Date:   Sat,  8 Jan 2022 12:46:49 -0800
Message-Id: <20220108204650.36185-11-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
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

