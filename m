Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3D40BE85
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhIODxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbhIODxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:53:50 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C53C061574;
        Tue, 14 Sep 2021 20:52:32 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso1736657ota.8;
        Tue, 14 Sep 2021 20:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EWlyAfIJ6LK6KpxwIys48q3PWxQlxyDohB67wcgCd/M=;
        b=nUrn/Lw/ozglO0/A9wBQBB3xPkoAzmKdrQprI3+VccXyvcgJsFFh6Bxae1HWUezXd4
         AQmb9ebsH9GIgQE1wl9KXWoc7PiSvaIXe9WbY/IYmDO2508scavL+H0oJX9G/cISxyrs
         l7dPZq/Rzp/uC/iEYMQydnJlrkX84nLnxe5tih2wDXRTX+TvBe2oCSsAxdYX1HhGNItO
         ZbYGuPbTSYb0At2GGZVSlG9XTXaXKO2wfMUzpjKvNqfo/sD0H9uxRzfXaUWlNF9avXLB
         uvmw7xVrRzDHurwjcA9UUGVm8zBBI/SskOAh6S7tIPd1LrwGhQjamQId6BvHpdzk92Fe
         Aq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=EWlyAfIJ6LK6KpxwIys48q3PWxQlxyDohB67wcgCd/M=;
        b=LjwCgFED5njp+u/j+TJYe7dYhwrrI687AyWsiQmkAQvI+Y4BSxaFr84MGmD6CQ2CqI
         wA20udHUY16ZX8D6Pk7+cNi3xgZksyaWXVhEL9ZKU8JaaXvpQpqcOimkEkUfPeP1tk+N
         vHstZUJLJJGc9UK/KlP/bHiEtcjGKRaOmdKaMSCwFB54EhM9bZBhsKSiWEa0pT0FVwrY
         FyTZfZhp2gc7+xd0fI+efpBCOd0uN7PylgIn2PyhvM+DAajFX/CFvdg5IpqlbSYf7oB8
         OZTdw4g9dZlfQhhwV1OSYBa15msZM+VHjVQw17ofnycRGvd+CLWlkrCb1dCmhSBb8m27
         KQQg==
X-Gm-Message-State: AOAM530k0XA2LhbRRUKFy6kZXelNdGlSkbXM+McVf0nPUm8o0Y3sLy/3
        e2iUTyoyoXOfScRZf/JyJFJExQ+RbtM=
X-Google-Smtp-Source: ABdhPJzoMC19sXj6sgU0ESAUjmLqYY7d90Vdr5m68MaI4eRv2IeMsJvMNWYhojvqU0D2qXE51sqMMQ==
X-Received: by 2002:a05:6830:1f0a:: with SMTP id u10mr17832026otg.53.1631677951631;
        Tue, 14 Sep 2021 20:52:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x1sm3017780otu.8.2021.09.14.20.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 20:52:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-alpha@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-sparse@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 0/4] Introduce and use absolute_pointer macro
Date:   Tue, 14 Sep 2021 20:52:23 -0700
Message-Id: <20210915035227.630204-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel test builds currently fail for several architectures with error
messages such as the following.

drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
./arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0
		[-Werror=stringop-overread]

Such warnings may be reported by gcc 11.x for string and memory operations
on fixed addresses if gcc's builtin functions are used for those
operations.

This patch series introduces absolute_pointer() to fix the problem.
absolute_pointer() disassociates a pointer from its originating symbol
type and context, and thus prevents gcc from making assumptions about
pointers passed to memory operations.

v2: Drop parisc patch (the problem will be solved differently)
    alpha: Move setup.h out of uapi
    Define COMMAND_LINE for alpha as absolute_pointer instead of using
    absolute_pointer on the define.

----------------------------------------------------------------
Guenter Roeck (4):
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy from fixed memory location
      alpha: Move setup.h out of uapi
      alpha: Use absolute_pointer to define COMMAND_LINE

 arch/alpha/include/asm/setup.h      | 43 +++++++++++++++++++++++++++++++++++++
 arch/alpha/include/uapi/asm/setup.h | 42 +++---------------------------------
 drivers/net/ethernet/i825xx/82596.c |  2 +-
 include/linux/compiler.h            |  2 ++
 4 files changed, 49 insertions(+), 40 deletions(-)
 create mode 100644 arch/alpha/include/asm/setup.h
