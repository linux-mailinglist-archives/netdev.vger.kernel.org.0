Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA9EC31C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKAMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:46:47 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32929 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKAMqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:46:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id t5so10162635ljk.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSTLEPaxXRk5sSmG9oSsPXFVdXLQlUfBUPDhCvkx5go=;
        b=RlJIncS5V/VeZ8tPU8EEBpDu0ecPVdk1TB589EL92OS3o6Lj/2CpEeDsKsB6b618GV
         8L3X3n1laq2hQ/uB/NIkih6WDZyT5owW4NktaFEqJOQeK6yQN3cufbWoZnaHcSDpgim7
         sLB18ckMTXbKNu2euww+eB/lnbRZu4oTB+QR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSTLEPaxXRk5sSmG9oSsPXFVdXLQlUfBUPDhCvkx5go=;
        b=tbrdI43p2WyRmmtNOVP2aEezUmjRHJ382ySHfHm/h1uKUjWhEoE6ks19yjfmWinePt
         Hy57nRYfPxPlUOmk8wQc8ySIKV7Kz+PGlRwba9xSxqc75faeicStdT9mdAO1JIUfKca0
         pS3jBpmYJf8GJbdlfldHo3kAeIvU97Sx8sHLsGeCet/dW92FsWPefP8fKdu87syaVnaZ
         WFHamTS2fLvNPiOMH29i0mhd1UugL+HSzU3GaAFFhcfGUVb5BI53WZrI+444y5tHS8Ai
         dkeP4ewNCozlssboStc5r8F63f6llNu83IUPuv/KYv6SLRQ5ub+7pTewAS5E5mgCB0MZ
         WxBQ==
X-Gm-Message-State: APjAAAUTLPaVWRQQhGXBR/DXa4t58YrkRGqq3BvDDFpFfZYsmO1YmWil
        KpJN+PmZOIKzcg4nQORMrF+qxMBsFos=
X-Google-Smtp-Source: APXvYqxE/rdihjXmi5LCYrM2menfTABueMAuRtPKQ209emxoC+iX2FZZzoleq8tRAVMciQR9j1ZvPA==
X-Received: by 2002:a2e:7a02:: with SMTP id v2mr3015462ljc.224.1572612405283;
        Fri, 01 Nov 2019 05:46:45 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t4sm2297909lji.40.2019.11.01.05.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:46:44 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 0/3] net: bridge: minor followup optimizations
Date:   Fri,  1 Nov 2019 14:46:36 +0200
Message-Id: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
After the converted flags to bitops we can take advantage of the flags
assignment and remove one test and three atomic bitops from the learning
paths (patch 01 and patch 02), patch 03 restores the unlikely() when taking
over HW learned entries.

v2: a clean export of the latest set version

Thanks,
 Nik


Nikolay Aleksandrov (3):
  net: bridge: fdb: br_fdb_update can take flags directly
  net: bridge: fdb: avoid two atomic bitops in
    br_fdb_external_learn_add()
  net: bridge: fdb: restore unlikely() when taking over externally added
    entries

 include/trace/events/bridge.h | 12 ++++++------
 net/bridge/br_fdb.c           | 30 +++++++++++++++---------------
 net/bridge/br_input.c         |  4 ++--
 net/bridge/br_private.h       |  2 +-
 4 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.21.0

