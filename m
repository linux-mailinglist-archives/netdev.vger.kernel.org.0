Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E146062F
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357420AbhK1Mom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357423AbhK1Mml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:42:41 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ADDC06175F
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:47 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z8so28946182ljz.9
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z3V2gn0c2YFt2+cTusFxfusIoNQLOBG2uZ/j1RK+3Rk=;
        b=qH2I+q44UzCcqBO7qHcVrdVQfrxO+fd7x7ogaHKopkiW4U1gTNeUlnyrpZaA40NNlr
         IxyNIJ4lOz2Iy5lUlmz3xp6I9Aa98RODyDTa1zjhGEfHqCy4Aj3hiPBBc4pDipA/iUE2
         5faIj64Qt7jNhwH8DYt9Wl37bzvFFQRjtNejSX8BUG3NBUYA6ImsZratt76jW6gPW9FF
         umNVdbUeNEcUe/yTS+YkRw4OcDUMzY96Gw1rCYf85G/cPGspxSs7gSZT0QYdUDYiXAYk
         zod4fbiItx25smiiRZLdaPioLByzkNIN0LaoHqbjSp/2VDk4FPjveaBwMJQxKfVcCWCD
         VcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z3V2gn0c2YFt2+cTusFxfusIoNQLOBG2uZ/j1RK+3Rk=;
        b=rNhiuWxD7c77PM+XJwEfZYlNLC9ojrAJSsgwnG6fezajivvZbKdTNCWGu1w+uQ+1dV
         YjYhRV9DVs5evoKTqfI+1hAKQEnC5Ca7QcAEPM9Gnyrtkj3Hu7ZrQSyN/pEsPaE5udCw
         exP2Zjf4/6sf/DwweiBDlfI/of3RU5CirtwM0AoxyUm6sSep+XpJ0DdHy0uOniS8DDLe
         WlWQ/9AqJZkDhAjteC7E4QiGGH/o/Hrewv74SPGQIEXu8N8T8NRR89o51kpFBolWqwL5
         6HdoJvbsK4OHEVipCZByTkd36/flJh0UrSn3EUgQGgH4WWA+4IFtX0XeRV8OXwxcrUCQ
         KnJA==
X-Gm-Message-State: AOAM531lXoRqkevhdVZSAf8aoR619I6BHH4kqEBhp/UpBgwIFkiUob9u
        borf5XeOo4DeBRv8nLIlV08=
X-Google-Smtp-Source: ABdhPJy/8vaxtj87IBmi9KuZpjzFn8BW8lF8IboWL4R8vfqwW6W0eKmNe/OEhtdnfTD1/aBAAL3IBw==
X-Received: by 2002:a2e:a211:: with SMTP id h17mr41889842ljm.486.1638103125864;
        Sun, 28 Nov 2021 04:38:45 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id v198sm976533lfa.89.2021.11.28.04.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:38:45 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/5] WWAN debugfs tweaks
Date:   Sun, 28 Nov 2021 15:38:32 +0300
Message-Id: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up series to just applied IOSM (and WWAN) debugfs
interface support [1]. The series has two main goals:
1. move the driver-specific debugfs knobs to a subdirectory;
2. make the debugfs interface optional for both IOSM and for the WWAN
   core.

As for the first part, I must say that it was my mistake. I suggested to
place debugfs entries under a common per WWAN device directory. But I
missed the driver subdirectory in the example, so it become:

/sys/kernel/debugfs/wwan/wwan0/trace

Since the traces collection is a driver-specific feature, it is better
to keep it under the driver-specific subdirectory:

/sys/kernel/debugfs/wwan/wwan0/iosm/trace

It is desirable to be able to entirely disable the debugfs interface. It
can be disabled for several reasons, including security and consumed
storage space.

The changes themselves are relatively simple, but require a code
rearrangement. So to make changes clear, I chose to split them into
preparatory and main changes and properly describe each of them.

1. https://lore.kernel.org/netdev/20211120162155.1216081-1-m.chetan.kumar@linux.intel.com

Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>

Sergey Ryazanov (5):
  net: wwan: iosm: consolidate trace port init code
  net: wwan: iosm: allow trace port be uninitialized
  net: wwan: iosm: move debugfs knobs into a subdir
  net: wwan: iosm: make debugfs optional
  net: wwan: core: make debugfs optional

 drivers/net/wwan/Kconfig                  | 17 +++++++++++++
 drivers/net/wwan/iosm/Makefile            |  5 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c  | 29 +++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h  | 17 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 13 ++++------
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |  5 ++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 18 --------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 23 ++++++++++++------
 drivers/net/wwan/iosm/iosm_ipc_trace.h    | 25 ++++++++++++++++++-
 drivers/net/wwan/wwan_core.c              |  8 +++++++
 include/linux/wwan.h                      |  7 ++++++
 12 files changed, 133 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

-- 
2.32.0

