Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904BC3DBAD5
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbhG3OmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:42:17 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:60966
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhG3OmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:42:17 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 80B8D3F10B
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627656131;
        bh=wofNY4jh0EeYONXo5ssRVDRpz3oYBXrS11XkjMwqwQw=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=dstO061qhRzaIUR04Za6rsKuMgcpfY9KIWs/WdRPhlj27DXrxLyC6tLsTMq2ACVFo
         uh4N5IVT/BthBvIgeIkYEd4XRhNarzdZx6Or1DsnOioyklynbWfiYI05aPB5WSV5Qb
         vXNcaKCfuEDxRwnrH5oJLbuoBfsoMQeX90RXmauFb8AFHMrESGAyvSoWqfTq0bCfzC
         htJiBCDh3D0ZvITlyr+ptExVcwg/9r5W9rw81EVWtywT1GIz1RrnjhGLo6yQZQJuFG
         yzO9Xo6gn8EuiT1ShxEHUa1jMR7EOA9afJwXvSyQalVEz0mSk3tZkOpMIaPNmc3jc1
         Pa8+mM5uvtTWg==
Received: by mail-ej1-f72.google.com with SMTP id g21-20020a1709061e15b029052292d7c3b4so3175144ejj.9
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wofNY4jh0EeYONXo5ssRVDRpz3oYBXrS11XkjMwqwQw=;
        b=EYK35YF51soId2FJ78lcxIFrAwljJWpuELF4DULtVmLXHNDYJtjgRGpJtBA1qD7uF6
         LO0cKKYtZI28hftHnRirXi8NQJcS0NNJCOnE+KEtwFkBDjXAUoD3y0hPozR1bjQPkCm3
         7HmmkDejVwKzfRcQQSyMwHmaBRyzy0E/cgGXjHF9naUokyKeYXXnVax1+BMuKr01dGB5
         DfhSxluj1Oil6BhyYBc4DIoeTfK5UWMJYRjpBTjGVDeL4T6kS7ngt1zor7J4tEViQECM
         n9lN7wN6yr4rXJn6oay9VFBeOlYjd3/xZdX6pqjqpAjHHSZCzj2miNpWY5IOic1EA85L
         xBPA==
X-Gm-Message-State: AOAM531dlRkdrdRdgZV8f9Jh3Od/xWA2z0j6Zzsz0kSgDSV6MAmxr5VL
        6uLLT2zyDxUwRUu3RPR1M+ZhVwYe4YA4L8OEvUl2lsr1A/2gvfRtadb7qEfuHXTLZq8Mp7Juir5
        aWFhNUMQSX6S6CRZWo1hrsfsNSMY/HqZngw==
X-Received: by 2002:a17:907:6218:: with SMTP id ms24mr2871038ejc.367.1627656131223;
        Fri, 30 Jul 2021 07:42:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo7sQHS6Q74F1QUHjdt7MuN7lL1fXicUfjd5B60lldUBFvvc3BbXXsh7pFKlQqUeqpAPjfGQ==
X-Received: by 2002:a17:907:6218:: with SMTP id ms24mr2871028ejc.367.1627656131029;
        Fri, 30 Jul 2021 07:42:11 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id z8sm626325ejd.94.2021.07.30.07.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:42:10 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] nfc: constify pointed data - missed part
Date:   Fri, 30 Jul 2021 16:41:55 +0200
Message-Id: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This was previously sent [1] but got lost. It was a prerequisite to part two of NFC const [2].

Changes since v2:
1. Drop patch previously 7/8 which cases new warnings "warning: Using
   plain integer as NULL pointer".

Changes since v1:
1. Add patch 1/8 fixing up nfcmrvl_spi_parse_dt()

[1] https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
[2] https://lore.kernel.org/linux-nfc/20210729104022.47761-1-krzysztof.kozlowski@canonical.com/T/#m199fbdde180fa005a10addf28479fcbdc6263eab

Best regards,
Krzysztof

Krzysztof Kozlowski (7):
  nfc: mrvl: correct nfcmrvl_spi_parse_dt() device_node argument
  nfc: annotate af_nfc_exit() as __exit
  nfc: hci: annotate nfc_llc_init() as __init
  nfc: constify several pointers to u8, char and sk_buff
  nfc: constify local pointer variables
  nfc: nci: constify several pointers to u8, sk_buff and other structs
  nfc: hci: cleanup unneeded spaces

 drivers/nfc/nfcmrvl/spi.c  |  2 +-
 drivers/nfc/pn544/pn544.c  |  4 +-
 include/net/nfc/nci_core.h | 14 +++---
 include/net/nfc/nfc.h      |  4 +-
 net/nfc/af_nfc.c           |  2 +-
 net/nfc/core.c             |  6 +--
 net/nfc/hci/core.c         |  8 ++--
 net/nfc/hci/llc.c          |  2 +-
 net/nfc/hci/llc_shdlc.c    | 10 ++---
 net/nfc/llcp.h             |  8 ++--
 net/nfc/llcp_commands.c    | 46 +++++++++++---------
 net/nfc/llcp_core.c        | 44 ++++++++++---------
 net/nfc/nci/core.c         | 48 +++++++++++----------
 net/nfc/nci/data.c         | 12 +++---
 net/nfc/nci/hci.c          | 38 ++++++++---------
 net/nfc/nci/ntf.c          | 87 ++++++++++++++++++++------------------
 net/nfc/nci/rsp.c          | 48 +++++++++++----------
 net/nfc/nci/spi.c          |  2 +-
 net/nfc/netlink.c          |  2 +-
 net/nfc/nfc.h              |  2 +-
 20 files changed, 206 insertions(+), 183 deletions(-)

-- 
2.27.0

