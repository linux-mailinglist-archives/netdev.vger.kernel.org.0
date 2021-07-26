Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53D93D5C28
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhGZOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:16 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60902
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234725AbhGZOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:10 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 782843F346
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311152;
        bh=P0l7ucawZtHhjUJpWjjS78w5LayhCUV4MmW7+VY+YFU=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=mweqI1ywT2MEPAGkv5aGUpzkJRW0/+QKeLqdWmjagINa+9DGJdai4u9TH2wWwGcFn
         U2uMJl8KA4ivA6UT1QLt3Yaxott7m93hZexIjFPqQpvsiZFic5cAvgTIMp12EC4Ite
         UXccgkbuzWgGGInfBlXu4AVgiKgQTYJSqpCOU+3ZyNMVAn0C8Hdo6EIgaPtXHX9tZy
         ngoMVnHiZII8bePaMALnwSr+cgA6PZb4n1MD6l2Sl1eriHvg1x+f27GTbReShYqzjW
         l0x01V8AUwqn9zbzZEE6A+r01kpbiS+RPfVV003CRBekGwT0/epkNU9qvym6YuZqbn
         ITkCwtsPx2xUA==
Received: by mail-ed1-f70.google.com with SMTP id n24-20020aa7c7980000b02903bb4e1d45aaso3170231eds.15
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P0l7ucawZtHhjUJpWjjS78w5LayhCUV4MmW7+VY+YFU=;
        b=JFkW7KaM2fFLGE08nrxvVfPTFfvDuiKx5jm7Yq/22kvBP9MmvKUkYd6axIbzBjTFvS
         VjHz4LPlsEUUep/vYMhN5RAG5+NFq62mx7bJxH2O4BNRbw3R2tmqxHJpbuSzexYVw+vS
         ifKt3fNlLn7RVr9IVfxew2Q5eRpVLpU7jdBFnB28++pnf4YdixHgLzYrHfgQNxO+xQO+
         Qfx4oD/iFGHjcHnHkf/tQDrYy1vXA7jJQ1Jh7xI4bso95C36wapuRjpFssx+53E826R7
         Sc+RPDaMYKUXXOTliTdnlIyCVPLusxmXSep812hYf8HsZntnuCUA1k6z6xWNQCObxexn
         WuJA==
X-Gm-Message-State: AOAM532QtwKzp4Ny01o3HuLHLjKhIpicpt5v7iWJAQbVlhdV1C5pNUkM
        V0pc2aL3bJ90pxDNgmMzKvboAeymkEd310aT95QTZw1bNdrqUgVmfWGAgyKs/wgIL/r/Ztukfit
        zzBdaLboc6OsU3MxpQUiBUe2aK7at9cBxvg==
X-Received: by 2002:a17:907:e87:: with SMTP id ho7mr17518028ejc.184.1627311151437;
        Mon, 26 Jul 2021 07:52:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbGOBrT7HrBw1RufsByTXKDeTJ2h4upbT0ndwDrZuwP/ONxaeOmoEJ+bHKjJt9zMXOsmYbKA==
X-Received: by 2002:a17:907:e87:: with SMTP id ho7mr17518017ejc.184.1627311151224;
        Mon, 26 Jul 2021 07:52:31 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] nfc: constify pointed data
Date:   Mon, 26 Jul 2021 16:52:17 +0200
Message-Id: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Patchset makes const the data pointed by several pointers.  Not
extensively tested, hoping most of it has only build-time impact.

Best regards,
Krzysztof


Krzysztof Kozlowski (7):
  nfc: annotate af_nfc_exit() as __exit
  nfc: hci: annotate nfc_llc_init() as __init
  nfc: constify several pointers to u8, char and sk_buff
  nfc: constify local pointer variables
  nfc: nci: constify several pointers to u8, sk_buff and other structs
  nfc: hci: pass callback data param as pointer in nci_request()
  nfc: hci: cleanup unneeded spaces

 drivers/nfc/pn544/pn544.c  |   4 +-
 include/net/nfc/nci_core.h |  18 ++---
 include/net/nfc/nfc.h      |   4 +-
 net/nfc/af_nfc.c           |   2 +-
 net/nfc/core.c             |   6 +-
 net/nfc/hci/core.c         |   8 +--
 net/nfc/hci/llc.c          |   2 +-
 net/nfc/hci/llc_shdlc.c    |  10 +--
 net/nfc/llcp.h             |   8 +--
 net/nfc/llcp_commands.c    |  46 +++++++------
 net/nfc/llcp_core.c        |  44 ++++++------
 net/nfc/nci/core.c         | 134 ++++++++++++++++++-------------------
 net/nfc/nci/data.c         |  12 ++--
 net/nfc/nci/hci.c          |  52 +++++++-------
 net/nfc/nci/ntf.c          |  87 +++++++++++++-----------
 net/nfc/nci/rsp.c          |  48 +++++++------
 net/nfc/nci/spi.c          |   2 +-
 net/nfc/netlink.c          |   2 +-
 net/nfc/nfc.h              |   2 +-
 19 files changed, 254 insertions(+), 237 deletions(-)

-- 
2.27.0

