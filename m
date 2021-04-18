Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FA3363348
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 05:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhDRDvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 23:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhDRDvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 23:51:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F473C06174A
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 20:51:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j21-20020a17090ae615b02901505b998b45so3189068pjy.0
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 20:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9V+qyodEUQpFo+Cqbo/ekfVPsKACgVLQio5ODc4eU80=;
        b=lSx/2MvAgyFfu9hNpf8W663s0du61H7FPQc+x/agpxJFGqw1+CspPxGijb2Es81QxI
         5au+sWl7bmcaKmzADFZ/s5/vTwFKWzANgxeVQoXQApSMTlpk53Z0aK0VEbMk8JLyuBla
         JtGhrRSdbe5vGRykXPrdBFdTnThUSKaDjMzdRn/btXSqT5RiCl/9K9QmHaKrGsTkosmr
         eNBNtPWmPo36dc9ldVcvDQyvmO094DhX32nHU58Tu3vFGgJiVT0ieyBVuKpwjRnjqpFK
         NI5ROmxqr5wDR08ddvkaNUz9heHoBYgwCQqrLkDMtmInPRlrI2jxEz0yjuTbCoWv1U19
         PV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9V+qyodEUQpFo+Cqbo/ekfVPsKACgVLQio5ODc4eU80=;
        b=IjuBhgTa2jnFNwC1yYiQWXwf6xh3h/o1n7dx9MawaH9HdUCL2Bk0kVZuQjVpOYH8E5
         t8fkiO4/wLUC/3wNs/2d7JjcG3SvRIfnf1fWxYb5zkCIgb73zinvfvSkKOGhR8qVr9nX
         vnLs/RfpEGF8Cld0/9an221RwGghYb8z4IlR6YaBKsl055Hk7+9bfGErEjsWuIteWt2v
         L0Zv5Aqb5s8tRMwd/xKpu5CTAoW/YJB3XTP2AeDvzjorplkGAq2NAuquw55nopTFZ87H
         A7IBvZ3lTXwbnpm6jYVwWj0eneHuHdHuAwhx0kowN9tEq/NV8K43lNvPGOU9awGoFzPG
         aZIw==
X-Gm-Message-State: AOAM532yUfdsY8CGnctj2RmLgDQUqD5Qtn4kMZxtNQ5490/pTkiojW4K
        Z+kK84AqunveIhxdz6ksP+I=
X-Google-Smtp-Source: ABdhPJxWTggnXWWvwVQy4ahYpDbTffSKWf7jC9aWDduayXW2l+HbbGrjar+XqVVy+tx0Z951avLf0g==
X-Received: by 2002:a17:90a:5d0a:: with SMTP id s10mr15010463pji.0.1618717876835;
        Sat, 17 Apr 2021 20:51:16 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:35:ab17:174d:e10b])
        by smtp.gmail.com with ESMTPSA id s40sm7974081pfw.100.2021.04.17.20.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 20:51:16 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2] ip: drop 2-char command assumption
Date:   Sat, 17 Apr 2021 20:49:58 -0700
Message-Id: <20210418034958.505267-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ip' utility hardcodes the assumption of being a 2-char command, where
any follow-on characters are passed as an argument:

  $ ./ip-full help
  Object "-full" is unknown, try "ip help".

This confusing behaviour isn't seen with 'tc' for example, and was added in
a 2005 commit without documentation. It was noticed during testing of 'ip'
variants built/packaged with different feature sets (e.g. w/o BPF support).

Drop the related code.

Fixes: 351efcde4e62 ("Update header files to 2.6.14")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 ip/ip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 4cf09fc3..631ce903 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -313,9 +313,6 @@ int main(int argc, char **argv)
 
 	rtnl_set_strict_dump(&rth);
 
-	if (strlen(basename) > 2)
-		return do_cmd(basename+2, argc, argv);
-
 	if (argc > 1)
 		return do_cmd(argv[1], argc-1, argv+1);
 
-- 
2.25.1

