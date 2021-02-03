Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38930D8C2
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhBCLgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhBCLgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:36:15 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2F3C061573;
        Wed,  3 Feb 2021 03:35:34 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id y187so4868023wmd.3;
        Wed, 03 Feb 2021 03:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaVlQ35WAgybEPmbAlTIUfx4arMZ+F8KRTsa3f1igzU=;
        b=upJrN7YFovrxu3liXSBoVUEGk1nrL7a+DVGqKL9T+H53jYBwvepcctt6sLTufgv36B
         JaIIo3tqLEmpcYoWAEVjMg6EmeTSjM4SwfX2aQrujQ/JYVtknmoM8wG9nZs0yoXSHtMb
         cPbp87bCukLSKJp/L8mWy+2g9VmShnvinUFe7giIJE5P4rnDpiOwfuNzqpHRCv7a7jqu
         yLbSD7srDIeuG94pmfmbFbMHrp0+VfLb52uCAYGMwy0HOZsMBg+QtKBXTrKnvMxmOsaB
         YJqExyGbPt+/Xog9pU6PWyZSL6NAwFS8TH744P7YKe9OPh7RQk2a5+/UNrMhv22pR8dy
         XyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaVlQ35WAgybEPmbAlTIUfx4arMZ+F8KRTsa3f1igzU=;
        b=YZ9a4Z6TS9KCBHfX7TrVpIhPdXFT4oOHL4Utgqgm2hQrCf/yBpREd/djGMf+ziCMb4
         1uDx5cdRbrQm3ON7swt4mB1izfollUthbg7aK/vMzHRJLS9QsDT7IsCRMsBVmJy0NsXB
         jptjJnoOGN0LVUeFj6WhIKUVTISmmdDT1BFXSMuN51ESxKeorASEpUi2ab2ZZfmQEefh
         iPMNbgv0m+R2w+gOWdbuqEq8DcsweytNSvYgdGaRmuoy/u7VXCnpt+fGEmG4V8tc1eKL
         VSknS0D6c6eO8u36VRavTfw14zYIpxdk/0ntk9hD9M34QcPrx8w8Pqvp+zemxbgWs5Kg
         xamw==
X-Gm-Message-State: AOAM5334xAwUPpiL6uatbU7JlEWRkf6drz//PhWLA5Azkn/V9CGF599N
        aQBPtT+sz04s8sii8e8fZe6IkuqAylmCxd3v
X-Google-Smtp-Source: ABdhPJywxMKo8VB4wbNSeSVds0UKXGX5ehLV2hcGKIuAr6gze4gceTvmoJE+j13PlgpL5yacGMVhnw==
X-Received: by 2002:a7b:c4c1:: with SMTP id g1mr2348153wmk.145.1612352132934;
        Wed, 03 Feb 2021 03:35:32 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id t18sm3295088wrr.56.2021.02.03.03.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 03:35:32 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Amend "hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer"
Date:   Wed,  3 Feb 2021 12:35:11 +0100
Message-Id: <20210203113513.558864-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #2 also addresses the Smatch complaint reported here:

   https://lkml.kernel.org/r/YBp2oVIdMe+G%2FliJ@mwanda/

Thanks,
  Andrea

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

Andrea Parri (Microsoft) (2):
  hv_netvsc: Allocate the recv_buf buffers after
    NVSP_MSG1_TYPE_SEND_RECV_BUF
  hv_netvsc: Load and store the proper (NBL_HASH_INFO) per-packet info

 drivers/net/hyperv/netvsc.c       | 18 +++++++++++-------
 drivers/net/hyperv/rndis_filter.c |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

-- 
2.25.1

