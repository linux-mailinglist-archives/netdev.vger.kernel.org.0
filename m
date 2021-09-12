Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E56407E4A
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhILQDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhILQDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:03:09 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E1C061574;
        Sun, 12 Sep 2021 09:01:55 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso9867776ots.5;
        Sun, 12 Sep 2021 09:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=369lDAEYI6mhcg75EK6D9X/8m+ItLAaJCovGP1Kk1FE=;
        b=mzzQHVTUH56eSIfjTlTliV7cmskLg33EaeKzO5HpHV1sLBJCnDeUTO07YqZjy8jZZi
         hc/YKR5o5m4S1dhCH1ubOowAKoNHBkftRpvPF3tAKX2O/vLWNUWirs2OJM60lekpwhzC
         txQAZJIuSaIx0vhp5gLjFEo1pu5ochkFYkjwVBu9lVk1CsdkUD451UPHlwZzjTbrkUKC
         Ulr81r6kJiBzVU2KCCmddPDNuQjIEPpPH6bRoU2nuoPStcWL8WXjiAMfawWmnMXXuCXy
         fcoNkia2JJk+vUXwukWytrb9OM4o6u9GchgXrZR60T/nCrQW7mslnQqJDd76/ueDBGHr
         0Q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=369lDAEYI6mhcg75EK6D9X/8m+ItLAaJCovGP1Kk1FE=;
        b=lCwF30NWKuGKFYbHsmku+JDE/xzoLSg9MZXOffvsjmYiK3CR6ZBjLQ6Z3uKKtv9Gf/
         X14tpxtGPnrNDGkYKU1C/khM6pnlOuexDIhSnFI1Ttw4UeF0isPFPa3UqMyhPhRw6cDo
         MFfU96DbNbfL0v10IcaJSZMEMRa6DW3DNwbx5Exbl5oPXrnX8HThzbd9I8iyTP3/sV/G
         /xOqNespXGvzXNM8KG9ZbfCRH4xUxwostc7G3/KM7XFRqquygmxuVB5rXj0JBNLbfEWS
         8POhGEP4XfrGa7mITeJLrBFdD3rD7lx7kmKxsn/VPbUWi0OX/Y9rsVcuepTf3FXliqYv
         twiA==
X-Gm-Message-State: AOAM531ffXIgIPtg27emr9PW69FpdgYAC3iJJxvU89oA4d8vsOviigH6
        X2cLLKT15VznkJ/e34PSDnU=
X-Google-Smtp-Source: ABdhPJzneesaRyA04uz0dYaU3J/hFLUe4dPodIY2EmY/vwBEQ8lVRgqbUa/daSuh3fjZ3lZqoBw0Xw==
X-Received: by 2002:a9d:75d5:: with SMTP id c21mr6148356otl.118.1631462515002;
        Sun, 12 Sep 2021 09:01:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s198sm1074938oie.47.2021.09.12.09.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:01:54 -0700 (PDT)
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
Subject: [PATCH 0/4] Introduce and use absolute_pointer macro
Date:   Sun, 12 Sep 2021 09:01:45 -0700
Message-Id: <20210912160149.2227137-1-linux@roeck-us.net>
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
on fixed addresses.

This patch series introduces absolute_pointer() to fix the problem.
absolute_pointer() disassociates a pointer from its originating symbol
type and context, and thus prevents gcc from making assumptions about
pointers passed to memory operations.

----------------------------------------------------------------
Guenter Roeck (4):
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy on fixed memory location
      parisc: Use absolute_pointer for memcmp on fixed memory location
      alpha: Use absolute_pointer for strcmp on fixed memory location

 arch/alpha/kernel/setup.c           | 2 +-
 arch/parisc/kernel/setup.c          | 2 +-
 drivers/net/ethernet/i825xx/82596.c | 2 +-
 include/linux/compiler.h            | 2 ++
 4 files changed, 5 insertions(+), 3 deletions(-)
