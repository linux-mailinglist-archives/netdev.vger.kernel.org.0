Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AEE6C8472
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjCXSEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjCXSC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:02:29 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174F21EBF4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:02:10 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1547692wmo.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680906;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zuw2erxWxN5w5OumRyDezAp9ZQrKWII5iPGuyyJ7AGg=;
        b=XTcadnmYOguGCR+C2pmVjNkmkNkENM2n3A2EVXooe5xjZ2rvqCINMdo/dUyFJXKgio
         ZYLxpVMWNeM2c5B9ILQTfg+K25wtemcKCe5PeHEDvByKqpgnxIWrEH3XZJYBWLFT1qaY
         6VotYobHEGu3S3KA7268ThC2Y/6F8e74yBSfsWHHq6/LzPQrFgNDAwwCQXKtJkOMm5v0
         /x4rchFG3Ko34CixaKhWV8Le/k/dXvuijskzGzIq/S50IReS2g09/XzoftHHDkCTtIjo
         N+Y0lp2QN9o1/GO3n9sOCLiiuEMY5+AdWgHtUF/qatPsb5QgddmFI4PGgBrJKnMoLOnF
         zhYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680906;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Zuw2erxWxN5w5OumRyDezAp9ZQrKWII5iPGuyyJ7AGg=;
        b=rigB6ggUXiQ1gtraU/2KkAnZLXaloLsXTLyAQunoiQCgy3XFpWSvkjJSOCowmaDpkm
         /4UENhT5aZ1vC63IcZd1j12P7YXw2QntpwFplBbNjPJdhnyg3ZCadFJ57x34i88zZesj
         mpN0SPhWWmlmst1MP+X4yvLSoVURZYbOMm1G+aPv4AzmpaFVnAO0KJTcN9aoP0PxX0oi
         Je6knPbONe4J2d2F8Z3zVxWFkcvr6q/7X5AKVurvtKHB9KhgTI2qtbgMNGhPYozLQaJ/
         jBvlcznb6mEXxIn1X8vslN2Lh+Y3PmuO/loMXalv1mj3k2E3PRwqMrXs72TfXMOHXIl1
         rOwQ==
X-Gm-Message-State: AO0yUKX8B70sAFY30bWbjDvuYlwQWj7BvkS++2wQlpWe6MCueyGpSp3c
        NZfGK0WPn1f4tp0uP1pJB4o=
X-Google-Smtp-Source: AK7set+mTuUc3baq7KW493qA2Cn0N/1w1e9mRk3jayei5wTanYMc/T69LmwBh7TQdalNGoFQRNre1g==
X-Received: by 2002:a7b:cc85:0:b0:3ef:5940:5f45 with SMTP id p5-20020a7bcc85000000b003ef59405f45mr2180815wma.23.1679680906230;
        Fri, 24 Mar 2023 11:01:46 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id d8-20020a1c7308000000b003e20cf0408esm5469501wmb.40.2023.03.24.11.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:01:45 -0700 (PDT)
Message-ID: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
Date:   Fri, 24 Mar 2023 19:01:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] net: phy: move getting (R)MII refclock to phylib
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From c578be6534254bfc3fd627d9d7be07b1bb46f92c Mon Sep 17 00:00:00 2001
Few PHY drivers (smsc, bcm7xxx, micrel) get and enable the (R)MII
reference clock in their probe() callback. Move this common
functionality to phylib, this allows to remove it from drivers.

Heiner Kallweit (4):
  net: phylib: add getting reference clock
  net: phy: smsc: remove getting reference clock
  net: phy: micrel: remove getting reference clock
  net: phy: bcm7xxx: remove getting reference clock

 drivers/net/phy/bcm7xxx.c    | 20 --------------------
 drivers/net/phy/micrel.c     |  7 ++-----
 drivers/net/phy/phy_device.c |  6 ++++++
 drivers/net/phy/smsc.c       |  9 +--------
 include/linux/phy.h          |  5 +++++
 5 files changed, 14 insertions(+), 33 deletions(-)

-- 
2.40.0

