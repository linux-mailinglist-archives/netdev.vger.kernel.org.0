Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88E1308DD4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhA2TyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhA2Tx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:53:26 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3FCC061573;
        Fri, 29 Jan 2021 11:52:46 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id n14so5042099qvg.5;
        Fri, 29 Jan 2021 11:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=md/WXLXgXjLYIf4dEOqdJFLd/DrASuHmSQ7Mb4mTb8U=;
        b=kZDaR+I7/TAYuvL6VsRmibbm24Xc39thlGngC2wpldpmNTfFX56e1KigOpc3Bov9ps
         36T0hcajFZ9x5EOj3B/GrBsk4BHpUyK7doECG7ARuyYyL/tv0nCCUwRdN5GFt7EQDhUn
         /jd0tl/8ItTZLqQXvcdHW6K15Tvp/fyoatbXvyLimYoChuORVb+gR5R2o1V4QJjscHCP
         FZg70Yp7G0y1M8U5EBNK7gpjjcRpStm9YcOnQ848qYwTosnZ/P5cPlMc0JBdEXe/jXBe
         YUv1It//JInZZq+wVfOFnLe9Gphwe/toHLk1AG3a5p5BC8yp7J28unvlMOyyfPRj2I0M
         QpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=md/WXLXgXjLYIf4dEOqdJFLd/DrASuHmSQ7Mb4mTb8U=;
        b=lYexOtBdVoPYms0Xp7EivDJCsB3TOoDpnIi24+zPUOSKWEO4Hr5L/K3xTo3sNqbNzo
         0QO2q2mbLBwAFrV5G4zxiZMcZuDtOgtSXzM+qIVKEMyD4t3pt2v1KfOPJ/GjHkxixm8f
         bBY+rfogrVFuks9xjW1BtjMTsxNATM77uRtIDvMMEhg0eOU9qxkHH4t1BTZZUclatAhW
         TtbpttPqF20gbwi9ZFx/S0C1ueSlplVi03IvX0Ti5+SyIUdGsDrjrEjfmNvLlBwimrPl
         RENuXmxD1F0C8X3VslCD7rFpmXX/3mQJw33ZPPcYMNl3RC12oqVhEPOx97pbiLGMQV+6
         4Y+A==
X-Gm-Message-State: AOAM533tREjMRCdneuoY0ravYEbL7IQnj12k+lUmrx6o9Moc0VF0NRqD
        dJ0mrxZfFpy47TqE5u/tuzM=
X-Google-Smtp-Source: ABdhPJz1M0FuDW6vU+wOkRYkY7qrChh/rAaueArj4f1SKV0EXW0KILnDMSEA25urmBiQyrAYJLbNjA==
X-Received: by 2002:a05:6214:b81:: with SMTP id fe1mr2200645qvb.43.1611949965136;
        Fri, 29 Jan 2021 11:52:45 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:44 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?q?Anders=20R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 0/6] lan743x speed boost
Date:   Fri, 29 Jan 2021 14:52:34 -0500
Message-Id: <20210129195240.31871-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The first patch of this series boosts the chip's rx performance by up to 3x
on cpus such as ARM. However it introduces a breaking change: the mtu
can no longer be changed while the network interface is up.

To get around this efficiently, the second patch adds driver support for
multi-buffer frames. This will allow us to change the mtu while the device
is up, without having to re-allocate all ring buffers.

Since this is an important change to the driver's rx logic, I have attempted
to very carefully test this. Test descriptions are included with each
commit message.

I invite all interested users of the lan743x to test out these changes, either
by testing them out "in the real world", or by repeating my artificial tests.

Suggestions for better tests are very welcome.

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 46eb3c108fe1

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

Sven Van Asbroeck (6):
  lan743x: boost performance on cpu archs w/o dma cache snooping
  lan743x: support rx multi-buffer packets
  lan743x: allow mtu change while network interface is up
  TEST ONLY: lan743x: limit rx ring buffer size to 500 bytes
  TEST ONLY: lan743x: skb_alloc failure test
  TEST ONLY: lan743x: skb_trim failure test

 drivers/net/ethernet/microchip/lan743x_main.c | 324 ++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h |   2 +
 2 files changed, 152 insertions(+), 174 deletions(-)

-- 
2.17.1

