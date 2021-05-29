Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE7394BE1
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhE2LHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2LHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:07:40 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A538C061574;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c20so6700743qkm.3;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdgywVTLMJ5d2mbdhxOjTBylWvVS/FWAM6bDew1xCYg=;
        b=qnSpDmVR07sbgRbINSJVZJCvQOvQI6Pr23o0zW1NivsgRTdfm72tZW5j/iBfNItWKh
         eGLY4C5L7vO0WCAxSFGV1HocVP2tHjYS6/ikLzdgBP3WDKNsvPCbVwSRTaL42qWcHNdV
         zJnL/uHJ7/4QjWNk9lLhQ9+pQ07USpezASGj+zwO6M+hmPwQxRA4EJRJtnlAPuhW1xIl
         /Qz1OckilvIzWpo5C0bKHEAJTywhf0eDiPKbGfaM4B/1ZGdDyqI7kx0se24G9WH7NJbe
         DNMJVTJ6QS6xYWvEAeLbyKrWsUUTzWySeNIJmCHOFVqwIYQI9zyhA8tdmjGgyAVSh0Zy
         39rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdgywVTLMJ5d2mbdhxOjTBylWvVS/FWAM6bDew1xCYg=;
        b=h91UoFxdsIPNaMBDlj8DjNMt9bhLO5j1qFZMCoIJ2AcBWYjqhvSwspAKo9jnj8EwiC
         X9qB9PsPxOHOOVDD6wAcUtcc5yBQ0PN+7l6sbiypZkEYHyZJtVW3PN7XUEgXHrH4giV2
         lYrLBpfoFpn3tcEouAzDNRyCDktNJVcXNFF5SQ3S483WDBSRm3TSXOwtdUxQkJXn26ER
         Dboy1i88irzQxI1rowpmT7ZwSNkIWlSGq5zmAc9yxZoHCwydG8lVrhlYHhiafJD0L/S/
         uTkPnGdAcMvDO+SaCKemu7guZdv2PgGbBUQGxJsiuwG0u26zdlRQwayUMeHRNH2TszPl
         ODAw==
X-Gm-Message-State: AOAM532KdZBxN9TqyT2O0+7vTaMgCvtHYOjtAFhfaMQ6xlGL2+uCu8Eq
        Mz5GxYgXr3AUDnTnFwi+uy4=
X-Google-Smtp-Source: ABdhPJz/BQO046kHgBlulaGt/bcphn1/4/KdCIKGFd2NNqx0FuToqYtLQ+YPPHkoJ1h27hrRE6idtg==
X-Received: by 2002:a37:2e05:: with SMTP id u5mr8022450qkh.139.1622286363400;
        Sat, 29 May 2021 04:06:03 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:5af:2aab:d2d5:7c9a])
        by smtp.gmail.com with ESMTPSA id t137sm5328991qke.50.2021.05.29.04.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 04:06:03 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH v3 0/2] fixes for yt8511 phy driver
Date:   Sat, 29 May 2021 07:05:54 -0400
Message-Id: <20210529110556.202531-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel clang bot caught a few uninitialized variables in the new
Motorcomm driver. While investigating the issue, it was found that the
driver would have unintended effects when used in an unsupported mode.

Fixed the uninitialized ret variable and abort loading the driver in
unsupported modes.

Thank you to the Intel clang bot for catching these.

Changelog:
V3:
- fix fixes tag hash

V2:
- fix variable order
- add Andrew Lunn's reviewed-by tags

Peter Geis (2):
  net: phy: fix yt8511 clang uninitialized variable warning
  net: phy: abort loading yt8511 driver in unsupported modes

 drivers/net/phy/motorcomm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.25.1

