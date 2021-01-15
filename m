Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E093F2F7ABC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbhAOMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387774AbhAOMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:54:01 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DC1C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:20 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id f11so10246095ljm.8
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=FObdO1fj9dLhx+LIdPnFaQ+AzRj5PD4IKnm0PhT7+10=;
        b=N9S/nDWFUdQtJaxOZHtp9hfIW1yp6XOXsi6GSDAPC3TpcGelmaVMpH0+9eEtrEH+sv
         qzsYOVqfUMXh4KYJT5wKzWL2GWMO7XzbjCyz8XglJKi8rI5rC3s5mq0ynoSn2NW2Zv9M
         V8mSgbF9HWSXaorptWSWLz9iGi8F2P09EwQkREcRBmWrE2AcaNvATx/iz92d9EN+JSNs
         Z/LPEHgffxJgOH1GRDWA4iQvahrg0lKpNPWD/ExNXPtLxJZSMjpY+GXOsSXGTZPUiUhZ
         59Zqlo+belpVYoStJ8NUyleQEeDHVvVphTdjl04QmCYTKiOAqImYvd4+kmgpY+UFY0nd
         O79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=FObdO1fj9dLhx+LIdPnFaQ+AzRj5PD4IKnm0PhT7+10=;
        b=fGtQyGXbPeg+XlgTxcDpmOdftT2vuZJ5qUL+qAU9geSyRo2x6gF7fh3tG5UuvxNLzP
         AJpMTCO/PsK8QbhI+o1Iws5teQej2r8bqk8/eL9Ht9YWgbztWWhLaDfO0PB5taCR94xg
         Jhy7d6NJ6qp5bZdUJHPpI1RN77vWm71zokFIy7tZWvPfjUdfmBO1FMHXeXbdWBfROCf3
         wnmygWRzwJFtT/ohsVWXadAllf+N3CR89cio6pkoywS+EGukHaO/66i66zoCIUhRB0wE
         LPmwEmFRYxw0+L+lqml+P9iqpzI9pCejH2jvBTPqxGYltR4xmB1czt0sTZU2sfyWFGgj
         KJ5w==
X-Gm-Message-State: AOAM531ZXk4NQZCv8yamcK9ZHZ7bjMgmF4f6KBjm+9T8V1XUwNvXlQ+f
        olsbLuhZ1ZMSKrbxsBmm06u4BA==
X-Google-Smtp-Source: ABdhPJxctShfNpL6LkkzrS7oRIExwEpR1pV6GxLwKthLFPOMvnqVkbeMVGNDBENtnTWpqJXJ3FtWlw==
X-Received: by 2002:a2e:574c:: with SMTP id r12mr5593868ljd.139.1610715199145;
        Fri, 15 Jan 2021 04:53:19 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u22sm892590lfu.46.2021.01.15.04.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:53:18 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Date:   Fri, 15 Jan 2021 13:52:57 +0100
Message-Id: <20210115125259.22542-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot kindly pointed out that Global 2 support in
mv88e6xxx is optional.

This also made me realize that we should verify that the hardware
actually supports LAG offloading before trying to configure it.

v1 -> v2:
- Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
- Simplify _has_lag predicate (Vladimir).

Tobias Waldekranz (2):
  net: dsa: mv88e6xxx: Provide dummy implementations for trunk setters
  net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware

 drivers/net/dsa/mv88e6xxx/chip.c    |  6 +++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  5 +++++
 drivers/net/dsa/mv88e6xxx/global2.h | 12 ++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.17.1

