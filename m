Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BB0318A3D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhBKMRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhBKMNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:13:40 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9EBC0613D6;
        Thu, 11 Feb 2021 04:12:57 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id w36so7765424lfu.4;
        Thu, 11 Feb 2021 04:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNV9PIpRM97w5EUj5LEBMerf9M/CsAl4IPaukAHNjGI=;
        b=ECL7XQKbNY57jk9I4nznwVWNOUXaqO1kR4hnSj2AFyl2mv59NpaEJEBtVFfvaISV0q
         ox2Y4961Sb8d8h2JqDzuDf4q99InLrlHuv0eBwYqnUYUQEg4z7Q+45QdfjpKQkYfXQiO
         XXDp3N/B8UvTqA50qVIvmFMtD2vnzY1AQmZgYj34Or5CeI6L4djLi2MN56YmnXhz0BEf
         NbeMKJyybkGZbYFx38rEXzMb8gdAp7gxBh0H63pdI4HoaXbnjUxi9yhIBVlDOWVNY/0r
         mEs2ZSO29/FpsuLJcJJ1a7Tr0ToCUafdXPOBeadaqvhStnbg1TVV+XZV0EaiKujRMyGc
         KNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNV9PIpRM97w5EUj5LEBMerf9M/CsAl4IPaukAHNjGI=;
        b=M3rg1niJ7tK1XUMeJxvtqiAG6QUYRc/8xchYzSna19xG7TIdPIq5tZmWQQnNFbQmnn
         0D6EiQ6jIzq1YlmWKj+N+3xaN4WTcb3uA2jEqdlyNzR4YKkZvsXjG1U+ZL+bSJH4hHI9
         Ft57SQ+YiXNNv0/j5g5b/8Ixu23c01p4yawlvRKEeEdrZzqSCHL/iAhk3TqzhS1ApbMF
         p5GUIZMBC/QBr0bmPx/C78xLLJggr0z5fkq8IY91ACTosxE87/KQ2+j3DmT9t1pV1HFq
         1HKFnUbCY782UCy7Ql2taTv7lMDI3kn8391jVFUoHCRLIgUKqieaxtBL0VZIT4FFzUGd
         4DEg==
X-Gm-Message-State: AOAM532UUa0W53WAfguV5vc68WY6V9fDlRfuYZUDKG4fgEKgmoPz/pUu
        PtDGZJFZff4CnW59qj3Huog=
X-Google-Smtp-Source: ABdhPJzMYy/J3st2yAjzLP2T5iat/YkBWSiBqTkgop0Rkeh/bki4BT39t/D4pjwv198KhBqTtUt2uw==
X-Received: by 2002:a19:7f95:: with SMTP id a143mr4014313lfd.419.1613045576164;
        Thu, 11 Feb 2021 04:12:56 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:12:55 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 0/8] bcm4908_enet: post-review fixes
Date:   Thu, 11 Feb 2021 13:12:31 +0100
Message-Id: <20210211121239.728-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209230130.4690-2-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

V2 of my BCM4908 Ethernet patchset was applied to the net-next.git and
it was later that is received some extra reviews. I'm sending patches
that handle pointed out issues.

David: earler I missed that V2 was applied and I sent V3 and V4 of my
inital patchset. Sorry for that. I think it's the best to ignore V3 and
V4 I sent and proceed with this fixes patchset instead.

Rafał Miłecki (8):
  dt-bindings: net: rename BCM4908 Ethernet binding
  dt-bindings: net: bcm4908-enet: include ethernet-controller.yaml
  net: broadcom: rename BCM4908 driver & update DT binding
  net: broadcom: bcm4908_enet: drop unneeded memset()
  net: broadcom: bcm4908_enet: drop "inline" from C functions
  net: broadcom: bcm4908_enet: fix minor typos
  net: broadcom: bcm4908_enet: fix received skb length
  net: broadcom: bcm4908_enet: fix endianness in xmit code

 ...cm4908enet.yaml => brcm,bcm4908-enet.yaml} |   9 +-
 MAINTAINERS                                   |   4 +-
 drivers/net/ethernet/broadcom/Kconfig         |   2 +-
 drivers/net/ethernet/broadcom/Makefile        |   2 +-
 .../{bcm4908enet.c => bcm4908_enet.c}         | 228 +++++++++---------
 .../{bcm4908enet.h => bcm4908_enet.h}         |   4 +-
 6 files changed, 123 insertions(+), 126 deletions(-)
 rename Documentation/devicetree/bindings/net/{brcm,bcm4908enet.yaml => brcm,bcm4908-enet.yaml} (81%)
 rename drivers/net/ethernet/broadcom/{bcm4908enet.c => bcm4908_enet.c} (67%)
 rename drivers/net/ethernet/broadcom/{bcm4908enet.h => bcm4908_enet.h} (98%)

-- 
2.26.2

