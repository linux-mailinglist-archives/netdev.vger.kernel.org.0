Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC30530C39
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiEWIdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEWIdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:33:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20CA366A8;
        Mon, 23 May 2022 01:33:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso10848274wma.0;
        Mon, 23 May 2022 01:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y53gTB9Ed9lmSuse1A51VBwBweSy6RiYxJkCMwT6bzM=;
        b=pWRTwq5PSMtvmVF9xxB+MblhF0Pci5LwzczcBOSQjbL7J8Wm8jnLEaWQlKwAy179jp
         HCDJPq6N9C8COE+8eIOcZSSKenW1ciZXXZB4Rlawg7wP3Ka7F0qhB+z0EGtR21eNnaGZ
         L7XqIUHFQbZL/ycxEQH7oVNGd+DMv7NVqJt0iI1dGmoL75P1utniXatpgSwsFvs6YQoH
         W0dUnPKuLTQGLQ5mxcaRR6ZXqPUZYNuxCm4terkob1Jul/UG5iHpyinOWGkqgOk80nAp
         zCznzflRizDYO2Fni8cpfEgFROz/YQrGITel6OJZICBVjdU5pjxSX7DIDZOXFnqs43m9
         NS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y53gTB9Ed9lmSuse1A51VBwBweSy6RiYxJkCMwT6bzM=;
        b=Sj486PYj2nWpj1DEcOeZi8GX6P2wsyWDkZED4le2JSOtoAipsbaERChXfrZ/QHwfNi
         /pijMhCHgLUrsYV7e6hocTgYOqpa31dZ9Iv10wN5gPmT/FsJuNMwvXgkWZumK1aPfoj0
         OyNmDb4YZzjrHhekrqWywXXg0GJGjB/FGNkYCQ1ZmbmDJ4NhWqFTQWRAOjv0kBnRREGu
         vi9Z1cJ6kRYeTZ4x8r86yMlttQa0cmu+hTfjCVbaIMXmU36sZHi171msOQUmlKijyXnu
         mb6aIin6ewpHDX1w6f3eq0tWaxs3RdCLu/e0g6eBxw6ZZiDC4h1wmZkR62YWrWNN2eWP
         +Gvg==
X-Gm-Message-State: AOAM533vcfs7D3xGRcW1TcuGVlz2NqpX8vvLG6KSpC7D8xnwzYzpYEzV
        iqhc+PvVODwN8gg9iUVZ8aI=
X-Google-Smtp-Source: ABdhPJwHregZiVBs17mRLTlyejK0HS23a2uyieFfVAKFrbmn1Vz93CuEs/C2yRGoXLm0+AGBGS+0Zg==
X-Received: by 2002:a7b:c410:0:b0:397:40e9:bc82 with SMTP id k16-20020a7bc410000000b0039740e9bc82mr9290579wmi.42.1653294794126;
        Mon, 23 May 2022 01:33:14 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id ay28-20020a05600c1e1c00b003973c4bb19bsm7251985wmb.16.2022.05.23.01.33.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 May 2022 01:33:13 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        maciej.fijalkowski@intel.com, davem@davemloft.net, kuba@kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        andrii@kernel.org, songliubraving@fb.com, kafai@fb.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>
Subject: [PATCH bpf-next] MAINTAINERS: add maintainer to AF_XDP
Date:   Mon, 23 May 2022 10:32:54 +0200
Message-Id: <20220523083254.32285-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski has gracefully accepted to become the third
maintainer for the AF_XDP code. Thank you Maciej!

Signed-off-by: Magnus Karlsson <magnus.karlsson@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 359afc617b92..adc63e18e601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21507,6 +21507,7 @@ K:	(?:\b|_)xdp(?:\b|_)
 XDP SOCKETS (AF_XDP)
 M:	Björn Töpel <bjorn@kernel.org>
 M:	Magnus Karlsson <magnus.karlsson@intel.com>
+M:	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
 R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org

base-commit: c272e259116973b4c2d5c5ae7b6a4181aeeb38c7
-- 
2.34.1

