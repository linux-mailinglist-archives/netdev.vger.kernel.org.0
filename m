Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0072436475C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbhDSPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240008AbhDSPrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:47:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A3AC06174A;
        Mon, 19 Apr 2021 08:47:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e9so958314plj.2;
        Mon, 19 Apr 2021 08:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mHhGKeIctTE9q3TzmUGJDnwdfTOiVckaG8iU9u6BBb8=;
        b=U90mGE3SCk0hHq6gZdSn7f5crLx4hqsKgL310yjp+KUu94mfLaOvGCsoYmwDB2bYkN
         fqDRYA/ECwXF/mNHS+TCCzpXxr1lDJNuTilbZEVVj7YCeBjEiDpLJOh3oDr9/zbDqYCo
         iKGHUzdSjujJIzH/sLJ8K3k+Xyf9u5DlmjpCwlJIVBrnfQHAJjya377j9ZORGjHw0Zqs
         4OlM3UPZv3egKZwUcFmqWM1RMMpekeIGeIm6NUkpNY5UDzCKofuXpqjlyxau1tAJ3AyE
         thosZnwjlaHHMTkGGlAK370SddaR0E/10GdgT5Dea5fpb5QKRGRdRQh8/5Gu97JrCCUL
         3vbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mHhGKeIctTE9q3TzmUGJDnwdfTOiVckaG8iU9u6BBb8=;
        b=P0rykD3cnQLAdh31BwYwMMgUek/Fq5+uHRCknB9vN/zZh+Au7bl3kmbpW5XoLV96JH
         QqG7ZkiTgz9ytcufcL93jvUiJUX0lwCIGz5RCQGtUNUixPg9moRrIx/o1ytpuyVkMGnB
         FrNVTljUIZTF/WO14y8zc+/4kGFyqXuv8FeEU7g6xUX+DXSrUAjNSYB+duA1MyVF+ax0
         tRyyNubkGMbyzD1ooinSB47Mn9KYE+jToV7EMjuzWV6VwzNDymDrk13I4NNbrlrXEr5Q
         Nx7LiniOwf9FCfeGT42t/RlBfXzkcMAsubkLvtzKbGkDssz9IlopCl+C+zhzVBPo4t9Q
         7cIA==
X-Gm-Message-State: AOAM5308DNTo8qDyKFIKm5krJpjf+J1837OPZrihhLPxYOhhS8xr4EjQ
        S99CX8qnDVtt6dvunyhG8O8=
X-Google-Smtp-Source: ABdhPJwEv5qT/XqTbj1q/dpSsZUb3bCHW7/pzynCrX00Sh6PkmdMESDZ61kpeg+wuvILIqa6MO0Ukg==
X-Received: by 2002:a17:902:da85:b029:eb:8794:7078 with SMTP id j5-20020a170902da85b02900eb87947078mr21536236plx.25.1618847226006;
        Mon, 19 Apr 2021 08:47:06 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id u1sm15314139pjj.19.2021.04.19.08.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:47:05 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 0/2] net: ethernet: mediatek: support custom GMAC label
Date:   Mon, 19 Apr 2021 08:46:57 -0700
Message-Id: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for specifying GMAC label via DTS. Useful when it is desired
to use a master DSA interface name that is different from the "eth%d"
pattern.

v2:
  - Use alloc_netdev instead of alloc_etherdev followed by rename

Ilya Lipnitskiy (2):
  dt-bindings: net: mediatek: add optional GMAC labels
  net: ethernet: mediatek: support custom GMAC label

 Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c            | 6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.31.1

