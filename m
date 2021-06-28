Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CE03B5F60
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhF1Nwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhF1Nwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:52:37 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEF6C061574;
        Mon, 28 Jun 2021 06:50:11 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id q190so27430400qkd.2;
        Mon, 28 Jun 2021 06:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6dmBo+A285XUjxDQvlhCvL2u9o4Cc8V4RCXPQxZOuC8=;
        b=pt/XCClrV0xYnmJZVX/n6lVjVVLidE498luN3+7F7P6Wy91zbVt81mCA9sls7hK9TB
         1T4JQAh5EHZiWknJmKCS/b3jBHLJ8dhcjlfiBgbCC2JC56Q/ubhAI80TLPZ00lmcLeRs
         MitmcQJEGMe8sszvce8prHplhfWkpiZcJXccC/cTv9ZzHoqmDAVvFVmLGnwEA/c2jA5G
         vOCSSTxFCfGw4ye8EbPBNGenAs9Ar6ITL8JJo0iOHUDy4939caWANcCtdoaSOF0GFbnn
         IfPDvjoeOvQ83GSNgSWzempZfQW17ns/4Ok9u1z6npz7vj/24FuKNSwisz7sKUh1wA+x
         4PQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6dmBo+A285XUjxDQvlhCvL2u9o4Cc8V4RCXPQxZOuC8=;
        b=DfK9k1ZWg8kmy3KOb93sYjxlQV010kEFOZFpW3/svlSLF0XTxyMcnNPbXDuqFokDGf
         S1ea+FDqRKGDwrjWgzH/NgeFm5G4ZCaGcPYGghpYPzv0jTjD2Op6sGPmVhkgZnVyYd9P
         S6skN0k+KgVYAiDK7RU0k+yFG2BhyHuJ1yo4n9GDHijVnE+YEnV8OP4EToX7TIonIMt7
         nGxjUTnpQ9VN1K8p1X5crPQZyejrUssQnP1GO6GQHJ7FyToDQcnSXUhFT93ydFk0+Ilb
         DShJ1yeh3U66Qf6Cdr5qrcpPsYWZ9PWa+ysXZ3Ml66tpU6XiK1VIPVhMUI/089jF5HK6
         q9HQ==
X-Gm-Message-State: AOAM5339BcIebWk5Fte3/xcywTHd4cBgpjmZ+jm8zylA+PoAOw3AQVQr
        KxKqbm3RI0ZJ2gZScMJbxOcXxf/EWQo=
X-Google-Smtp-Source: ABdhPJxg1Y6lCLXfes19EcCWLW9ylqAr0Y6iLi9otC0KW7mhiTe8bzKf+wqLdBSBNvw8EH0nC3a8Bw==
X-Received: by 2002:a37:a687:: with SMTP id p129mr14753036qke.48.1624888210276;
        Mon, 28 Jun 2021 06:50:10 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:8502:d4aa:337:d4d])
        by smtp.gmail.com with ESMTPSA id f19sm10760518qkg.70.2021.06.28.06.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 06:50:09 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v3 0/2] net: update netdev_rx_csum_fault() print dump only once
Date:   Mon, 28 Jun 2021 09:50:05 -0400
Message-Id: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch implements DO_ONCE_LITE to abstract uses of the ".data.once"
trick. It is defined in its own, new header file  -- rather than
alongside the existing DO_ONCE in include/linux/once.h -- because
include/linux/once.h includes include/linux/jump_label.h, and this
causes the build to break for some architectures if
include/linux/once.h is included in include/linux/printk.h or
include/asm-generic/bug.h.

Second patch uses DO_ONCE_LITE in netdev_rx_csum_fault to print dump
only once.

Tanner Love (2):
  once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
  net: update netdev_rx_csum_fault() print dump only once

 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/once_lite.h | 24 ++++++++++++++++++++++++
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 net/core/dev.c            | 14 +++++++++-----
 6 files changed, 49 insertions(+), 75 deletions(-)
 create mode 100644 include/linux/once_lite.h

-- 
2.32.0.93.g670b81a890-goog

