Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F263131C4D0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhBPBIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhBPBIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:08:52 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F20C061574;
        Mon, 15 Feb 2021 17:08:12 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id m144so8071094qke.10;
        Mon, 15 Feb 2021 17:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZaZIFaqLAcoIpglIDw+HT+fI3iJImvmhXF5r3MbSWiw=;
        b=LlwATVsqlkdjR3p89OA+DRvHw8i/XF7yJACmu1f3UKODxORuHbXcOpDlFhM25N1UPL
         9fAZ3gU5gtZinwjL8uxTvBWN/my6tVuDSxwSjscUn8j1Co2oTWunSgL/FBkFb/jzfc9K
         s50/xVJVSGq5dA8rLc41yRCXBxkLjtKlxhvDdpl5hAMHphhNchUm5bcLGjIxQHkT4PLh
         NzkekLTFQcZ1PSQmDrdHwz9+Rau7KdchTjgjlQEZZJzcgGhPak16Osv7jXz1umeVt/Sz
         cJ4bgvswIg842UgBIslU2X4bFFpSqzk3uaI8zjrETOb+xFBGikCmgvR+3AEKu3h7lfCY
         94Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZaZIFaqLAcoIpglIDw+HT+fI3iJImvmhXF5r3MbSWiw=;
        b=ie/3FGokGf57B+/OTt8aLjCMAuk1OWCJUfRwwX9S6DA6RLfQRNhAWctDxMPOeXxey/
         YlNQhglU4d12606CKiy/SzcpltgnNXmXCUbcgPxAgrV5sfgxZJ9uo82SV54u6BhI7eSn
         kbXXjhMW5cbn23UELbRndjTQ0ZL0sb+AUK4W15Hb76/FLD7zUYQf879hQfbvSlp6LeQ0
         WmvOzOHdf+RJ+IuYLnLf+CFcnqN8T18omGNF9SZ5NseA7/haV1TCAep+T2NGWQ1B15GC
         lZ7CTsow9JOPr2E0pt5ikRvAMCpjp1tmUS+M1uVyN+oLE52ZGZaqxJFkkh24wO5hp85E
         2EwQ==
X-Gm-Message-State: AOAM533LsFh8UkF044KC6Bv5cL+ZOtnBNH2oHTn5foGPPaclIQthNMkT
        LxvIu7SEN741E9rzyhurqMc=
X-Google-Smtp-Source: ABdhPJxexwTlBo8F5Q86h3Bq4ujhp8mfPfQAWU5+08zNfmCH6cIM+Af1LMdDkdoBgXrLwIu0X/f8DA==
X-Received: by 2002:a37:bd84:: with SMTP id n126mr17333299qkf.54.1613437691461;
        Mon, 15 Feb 2021 17:08:11 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:11 -0800 (PST)
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
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/5] lan743x speed boost
Date:   Mon, 15 Feb 2021 20:08:01 -0500
Message-Id: <20210216010806.31948-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 9ec5eea5b6ac

v2 -> v3:
- Bryan Whitehead:
    + add Bryan's reviewed-by tag to patch 1/5.
    + Only use FRAME_LENGTH if the LS bit is checked.
        If set use the smaller of FRAME_LENGTH or buffer length.
        If clear use buffer length.
    + Correct typo in cover letter history (swap "packet" <-> "buffer").

v1 -> v2:
- Andrew Lunn:
    + always keep to Reverse Christmas Tree.
    + "changing the cache operations to operate on the received length" should
      go in its own, separate patch, so it can be easily backed out if
      "interesting things" should happen with it.

- Bryan Whitehead:
    + multi-buffer patch concept "looks good".
      As a result, I will squash the intermediate "dma buffer only" patch which
      demonstrated the speed boost using an inflexible solution
      (w/o multi-buffers).
    + Rename lan743x_rx_process_packet() to lan743x_rx_process_buffer()
    + Remove unused RX_PROCESS_RESULT_PACKET_DROPPED
    + Rename RX_PROCESS_RESULT_PACKET_RECEIVED to
      RX_PROCESS_RESULT_BUFFER_RECEIVED
    + Fold "unmap from dma" into lan743x_rx_init_ring_element() to prevent
      use-after-dma-unmap issue
    + ensure that skb allocation issues do not result in the driver sending
      incomplete packets to the OS. E.g. a three-buffer packet, with the
      middle buffer missing

- Willem De Bruyn: skb_hwtstamps(skb) always returns a non-null value, if the
  skb parameter points to a valid skb.

Summary of my tests below.
Suggestions for better tests are very welcome.

Tests with debug logging enabled (add #define DEBUG).

1. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
Ping to chip, verify correct packet size is sent to OS.
Ping large packets to chip (ping -s 1400), verify correct
 packet size is sent to OS.
Ping using packets around the buffer size, verify number of
 buffers is changing, verify correct packet size is sent
 to OS:
 $ ping -s 472
 $ ping -s 473
 $ ping -s 992
 $ ping -s 993
Verify that each packet is followed by extension processing.

2. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
Run iperf3 -s on chip, verify that packets come in 3 buffers
 at a time.
Verify that packet size is equal to mtu.
Verify that each packet is followed by extension processing.

3. Set mtu to 2000 on chip and host.
Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
Run iperf3 -s on chip, verify that packets come in 4 buffers
 at a time.
Verify that packet size is equal to mtu.
Verify that each packet is followed by extension processing.

Tests with debug logging DISabled (remove #define DEBUG).

4. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
Run iperf3 -s on chip, note sustained rx speed.
Set mtu to 2000, so mtu takes 4 buffers.
Run iperf3 -s on chip, note sustained rx speed.
Verify no packets are dropped in both cases.
Verify speeds are roughly comparable.

Tests with DEBUG_KMEMLEAK on:
$ mount -t debugfs nodev /sys/kernel/debug/
$ echo scan > /sys/kernel/debug/kmemleak

5. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
Run the following tests concurrently for at least one hour:
 - iperf3 -s on chip
 - ping -> chip

Monitor reported memory leaks.

6. Set mtu to 2000.
Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
Run the following tests concurrently for at least one hour:
 - iperf3 -s on chip
 - ping -> chip

Monitor reported memory leaks.

7. Simulate low-memory in lan743x_rx_allocate_skb(): fail once every
 100 allocations.
Repeat (5) and (6).
Monitor reported memory leaks.

8. Simulate  low-memory in lan743x_rx_allocate_skb(): fail 10
 allocations in a row in every 100.
Repeat (5) and (6).
Monitor reported memory leaks.

9. Simulate  low-memory in lan743x_rx_trim_skb(): fail 1 allocation
 in every 100.
Repeat (5) and (6).
Monitor reported memory leaks.

Tests with debug logging enabled (add #define DEBUG).

10. Set the chip mtu to 1500, generate lots of network traffic.
Stop all network traffic.
Set the chip and remote mtus to 8000.
Ping remote -> chip: $ ping <chip ip> -s 7000
Verify that the first few received packets are multi-buffer.
Verify no pings are dropped.

Tests with DEBUG_KMEMLEAK on:
$ mount -t debugfs nodev /sys/kernel/debug/
$ echo scan > /sys/kernel/debug/kmemleak

11. Start with chip mtu at 1500, host mtu at 8000.
Run concurrently:
 - iperf3 -s on chip
 - ping -> chip

Cycle the chip mtu between 1500 and 8000 every 10 seconds.

Scan kmemleak periodically to watch for memory leaks.

Verify that the mtu changeover happens smoothly, i.e.
the iperf3 test does not report periods where speed
drops and recovers suddenly.

Note: iperf3 occasionally reports dropped packets on
changeover. This behaviour also occurs on the original
driver, it's not a regression. Possibly related to the
chip's mac rx being disabled when the mtu is changed.

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Sven Van Asbroeck (5):
  lan743x: boost performance on cpu archs w/o dma cache snooping
  lan743x: sync only the received area of an rx ring buffer
  TEST ONLY: lan743x: limit rx ring buffer size to 500 bytes
  TEST ONLY: lan743x: skb_alloc failure test
  TEST ONLY: lan743x: skb_trim failure test

 drivers/net/ethernet/microchip/lan743x_main.c | 352 +++++++++---------
 drivers/net/ethernet/microchip/lan743x_main.h |   5 +-
 2 files changed, 174 insertions(+), 183 deletions(-)

-- 
2.17.1

