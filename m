Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D2C318FC9
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBKQWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhBKQTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:19:15 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533D4C06178C;
        Thu, 11 Feb 2021 08:18:35 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id z18so5544427ile.9;
        Thu, 11 Feb 2021 08:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/YPJMG+J8mvf1l9NlynHZri/sbjLUM1j/GbRuISke9M=;
        b=aZSAJmlpUanLpjYIU0T23IsPGLYrPW4gbUv9zhr0MfYnDh5ktLjdlg8WfIJGqdDzFk
         Zoq/HBS+SL/wEBnKY/rR3vWCVrOdnzztK+LEpqTNOjmZ8eruiRlyouxFN8QhF0sn3s9T
         GYGVe1fPFF6ZObQUie4ZZVy2+djK+3HC53joedV8wWJqEsO5jItEZCgx/c0Jo4dfLLlV
         M5dCNsGILh1/bfbP7qYQJsDwxoMu5a/6IIAXY9JgGExbp3EI9cjS5T6jGXkz8SM38jhF
         ZR3jXnv+AqN3aNQ787qOcsezbXT8PpchZBhcrCBdL6ueIRw13V58ZsEsgWsoRg9VHumV
         g3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/YPJMG+J8mvf1l9NlynHZri/sbjLUM1j/GbRuISke9M=;
        b=KRz/YA+2sdGa04/NXiAGljKUVnjNOpm/Lz1ZTtNPTfEb+lFhlpfzA0M+BRXgt+cQRl
         ErqGrlUY61/FG9LqIlKDrEB2sr9nGlv1Fb24SHCzmqX6qxmB5/MsZj4HTA/cOIPKxp4B
         +3LTT39/nWozsFjOWc8hGKLPhgXxOYQENYBm2fdR+7aYFukD81GBeTI/kPvWvTkgYrQd
         0gotwqLzuMr85Wn79fwccwxpCV8i99aISNUUSpzC6xohWFHF66gWvrlwQ5vCRaJoVXYX
         wyZIBisOb5Z/CYtRNwlqGm3OmSz8Ud6wWdckqerKU+By6EdJTEiga8UYZHb1ETeOneK4
         GHvA==
X-Gm-Message-State: AOAM531DsBPFASC/IQcyNmxVIh1D/gq5Njt89I65btVbZl/KJwKkN//k
        BBOwZjwB7HUxd7PIoXX5CG0=
X-Google-Smtp-Source: ABdhPJyAIXkBNqJe8aLI3ZfaREo5kadOc1C12IGBKAi/+cIE0/photS1ANJgsvgrWdz2lLqFniLxQQ==
X-Received: by 2002:a05:6e02:85:: with SMTP id l5mr6596891ilm.213.1613060314473;
        Thu, 11 Feb 2021 08:18:34 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d135sm2729913iog.35.2021.02.11.08.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:18:34 -0800 (PST)
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
Subject: [PATCH net-next v2 0/5] lan743x speed boost
Date:   Thu, 11 Feb 2021 11:18:25 -0500
Message-Id: <20210211161830.17366-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # e4b62cf7559f

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
    + Rename lan743x_rx_process_buffer() to lan743x_rx_process_packet()
    + Remove unused RX_PROCESS_RESULT_PACKET_DROPPED
    + Rename RX_PROCESS_RESULT_BUFFER_RECEIVED to
      RX_PROCESS_RESULT_PACKET_RECEIVED
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

 drivers/net/ethernet/microchip/lan743x_main.c | 350 +++++++++---------
 drivers/net/ethernet/microchip/lan743x_main.h |   5 +-
 2 files changed, 172 insertions(+), 183 deletions(-)

-- 
2.17.1

