Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5191354AC65
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbiFNIq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355582AbiFNIqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:46:21 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834544338A
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 20so12779082lfz.8
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oAM/zOlGk69QAKmLEbCK7uqIsInmgsnJK9Xbeld2dog=;
        b=SoN3jyIQNNsSO7JvxajFVqlgulTcTmb7za0HscZds7fr0jY/8RJqMME/cDfPiHpE0q
         w8G5t1YfM1/2KXP0sB3ABVU4CZFYeXBrkROawX7KXInxPIWra5F4CGzFo4MvJlOKqWjk
         tqYkN3xMfvrKixnJ4i3u3S43w5Tq0cvHaIdLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAM/zOlGk69QAKmLEbCK7uqIsInmgsnJK9Xbeld2dog=;
        b=fcNLE+LeMq88FY2zJIXvCkbUYlAPXEGcGvI7DDgzoqsTv5FMFrB5uALeYNUUj4a6LJ
         rHWgSMhSoiEDXCuJU5kDfjfnAFhM/+owr4d3W70pNyewL8kAx1CAd3pexYl64dOm05wn
         tWvay5tCinHgpJBOAsF1jw0lY9vFp07hYcMTbr2SJysMDDjRmhg7k57sQmd/JOPP6HIv
         wf2M728pdqCOjfWrYaKNicA8KnsGqzNETihTMG56nYZiheyAZ/rcIrQo92ITGlssJ84u
         OCaVk/yQSJ8hgWJI37e8c/kv19MEOmCEfZciUwJewLXJz+Mw1mfjLLDz7U+Se9sbFhpf
         bF2w==
X-Gm-Message-State: AJIora/GkQuJJKORpeGXnCpNQS6M0CCOIv+BA/4SucBHzb2+sPp2Jsez
        wNiFsXjwPW+k9jBnjspoeSwi06lfUuy46adz
X-Google-Smtp-Source: AGRyM1tzG0TopbkaXDtd7WfOts0IhCRlPW54nF5yv2F+oFI5wCP+/gDXlo7C19R81acSp7hNGVYawg==
X-Received: by 2002:a05:6512:3d8c:b0:479:51be:727f with SMTP id k12-20020a0565123d8c00b0047951be727fmr2491926lfv.289.1655196376583;
        Tue, 14 Jun 2022 01:46:16 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g1-20020ac24d81000000b0047255d2118fsm1306116lfe.190.2022.06.14.01.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:46:16 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH net-next v2 0/3] dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
Date:   Tue, 14 Jun 2022 10:46:09 +0200
Message-Id: <20220614084612.325229-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a board where measurements indicate that the current three
options - leaving IO_IMPEDANCE_CTRL at the reset value (which is
factory calibrated to a value corresponding to approximately 50 ohms)
or using one of the two boolean properties to set it to the min/max
value - are too coarse.

This series adds a device tree binding for an nvmem cell which can be
populated during production with a suitable value calibrated for each
board, and corresponding support in the driver. The second patch adds
a trivial phy wrapper for dev_err_probe(), used in the third.

v2: Improve commit message for patch 1; add Rob's R-b to patch 1. No
changes in the patches themselves.

Since Dan Murphy's email address bounces, cc'ing two other @ti.com
addresses that have touched the driver in recent years.

Rasmus Villemoes (3):
  dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
  linux/phy.h: add phydev_err_probe() wrapper for dev_err_probe()
  net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell

 .../devicetree/bindings/net/ti,dp83867.yaml   | 18 +++++-
 drivers/net/phy/dp83867.c                     | 55 +++++++++++++++++--
 include/linux/phy.h                           |  3 +
 3 files changed, 67 insertions(+), 9 deletions(-)

-- 
2.31.1

