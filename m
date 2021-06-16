Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268B53A9E51
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhFPO7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:59:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44524 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhFPO7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:59:37 -0400
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <andrea.righi@canonical.com>)
        id 1ltWyw-0004dI-AB
        for netdev@vger.kernel.org; Wed, 16 Jun 2021 14:57:30 +0000
Received: by mail-ej1-f69.google.com with SMTP id n8-20020a1709067b48b02904171dc68f87so1045892ejo.21
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8a4xq8lMfa/LYfpYCOAoKmUJPps9DKcxfcjZnPhoHfw=;
        b=NjxO4iC06mxyK0yzGBKR6+kByL96zKBQ9m2Ymv+/8rE1tvY67rXacGNK7W8yVuRgsC
         cAeym9ZNMrkzqH4KBhRIbp256SNT7Z/vD0T7gEJqGLiXdLCq3NXwNgWsgWIFCXSYTL62
         +dCssKW/y/9Xg5svGJivYmo7y/FZ7zHa8eV63zbyFmFrVLNsrFjACDV8reVNhCk1G+Ce
         JtnjZ3BaSZyclIigLR3ZwKXyvV02dYo9wPGYzT6y3Tx0H55HNWR7P3xCvyucnljODo81
         c87kR/98xsA3eVMgJYggp2s9C54oHpd46QpmKaP5zT3FH48FZecpWOvZ18rpZ4KT+JCT
         Lk1g==
X-Gm-Message-State: AOAM533fjwrgUIKfVQoIyysChXcPUafP7V9YQVXGIfgdocin6YcNsF/g
        e2iMZLITp2ySNsFwujEWVCmyG6xKipup6P9U2JwTNJhtwrmz6lejwxo4ljdCejDdZn5no/8a6VX
        12PXaws00Aup6M1dUNCHK0lL5sOt60sa6ag==
X-Received: by 2002:a05:6402:40cc:: with SMTP id z12mr9322edb.202.1623855449143;
        Wed, 16 Jun 2021 07:57:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0x+c1CqYwSTRfdh/qpSq2BG+BtPzscae96/sH0AdsUtHuvEFm+xaOmkVdZvXxu0t3A449FA==
X-Received: by 2002:a05:6402:40cc:: with SMTP id z12mr9305edb.202.1623855448906;
        Wed, 16 Jun 2021 07:57:28 -0700 (PDT)
Received: from localhost (host-79-46-128-215.retail.telecomitalia.it. [79.46.128.215])
        by smtp.gmail.com with ESMTPSA id p13sm1777726ejr.87.2021.06.16.07.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:57:28 -0700 (PDT)
Date:   Wed, 16 Jun 2021 16:57:27 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: use bash to run udpgro_fwd test case
Message-ID: <YMoRV6IOOVhS3nEi@xps-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udpgro_fwd.sh contains many bash specific operators ("[[", "local -r"),
but it's using /bin/sh; in some distro /bin/sh is mapped to /bin/dash,
that doesn't support such operators.

Force the test to use /bin/bash explicitly and prevent false positive
test failures.

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index a8fa64136282..7f26591f236b 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 readonly BASE="ns-$(mktemp -u XXXXXX)"
-- 
2.31.1

