Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A32D3DD5EE
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhHBMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbhHBMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:45:35 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871AFC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 05:45:25 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t9so20497780lfc.6
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 05:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=OdgD23PaqsoW659em7xd+2DVC0rE7RCfEMqcX8xA7n4=;
        b=XD/+T3Q52qxGJH6pBV0NlSJgZvMm6VdFa2KS+DC77O390Y95T7VbQsko1sCbqcwmWI
         mJB8O79jL8CctItgjSPZGGPni7W17R8iJWTdDE+yHm0FUzo7CMZ2tP9m+jJm87x5HTV4
         cw0jqHgT71MnIDlOI5MbXLR9vIfJDcyPR2reoCKiHvbyQv2CT9zimR9/+3g3wEN2mO4a
         y0U4Sga8fT6QuTkJ312soGa58KO+YWVKeTLQXhu8x5SABoduP+eDoHSmFM3TboB6jbgE
         fH8qpqT3VFVu1HCWrEiu+GKRMxoUTeJWzCYHK2Mq+KZuD2Je3wooLLCw2RicPtI0mwDV
         jBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=OdgD23PaqsoW659em7xd+2DVC0rE7RCfEMqcX8xA7n4=;
        b=rX9cDWQXONukZec+53DwK7jaNXFSAmaq2L+ptsQqd9XS4LoCdtC+7FtBFSLZF1Jby4
         EaSPnvrO/gTsTqHx/+IS4dpSkMlAuKXFzyuWn0mGYJMaBjFfA60VxRHxCAjJ39bjnvLw
         el2KE7NBFh8uJItbe8jsQIsvHz8JZWoJEBSaBzXusAYeXfR8zHitMXjffwUQlwlyY/XP
         QgtgDaH6KVC7j5j+CGkIm250hVvKhb7HQllzTBmdheeJQkEJFmCCd9WR177fnSfruJJT
         O+RSNdEsjhRwSsm3cmDzGCkmHSZ0HWIKA5vNryU9Wj7eiL/5kphzmn1Vbv+HsoWsXVvq
         6bXQ==
X-Gm-Message-State: AOAM530U1cO3ewi8oZFfv0Vn3aIMU9FIotH5HVJ+kCxtqQNbh/EF9GX6
        Qu9ruKblFFjQxXN/V8eV4rH/peb0B0aJgrm5Od4=
X-Google-Smtp-Source: ABdhPJx8Z4PzWsY0IYF9OAx/7xE4g2xlxZRK+42MR7pBveFBcdNwp+GuW9uWCjLlgqUaZUukm+9MY19HRt/WG02yyrU=
X-Received: by 2002:a05:6512:1288:: with SMTP id u8mr5276278lfs.530.1627908323906;
 Mon, 02 Aug 2021 05:45:23 -0700 (PDT)
MIME-Version: 1.0
From:   Andreas Hilse <andreas.hilse@googlemail.com>
Date:   Mon, 2 Aug 2021 14:45:12 +0200
Message-ID: <CANabuZeqrpk-gsZnCz-CYZKo5pRfWW0MGSY2DAWqz1060bReGw@mail.gmail.com>
Subject: lan743x driver fails to map DMA during initialization on Raspberry CM4IO
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To whom it may concern,

I encountered this error when trying to get an EVB-LAN7430 evaluation
board to work with the PCIe interface on a Raspberry CM4IO board.
There was already someone on the raspberrypi/linux github who
encountered the same problem and also provided a possible fix here:
https://github.com/raspberrypi/linux/issues/4117

Please refer to the github link for a detailed error description.

The fix was tested successfully by some people who commented on the
github issue and by myself.
It seems the issue occurred on both 32 and 64 Bit builds on this system.
If I understand it correctly, this might not a universal fix.


diff --git a/drivers/net/ethernet/microchip/lan743x_main.c
b/drivers/net/ethernet/microchip/lan743x_main.c
index 8947c3a62810..96673017d6d9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2318,6 +2318,13 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
                ret = -EINVAL;
                goto cleanup;
        }
+
+       if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
DMA_BIT_MASK(64))) {
+               dev_warn(&rx->adapter->pdev->dev, "lan743x_: No
suitable DMA available\n");
+               ret = -ENOMEM;
+               goto cleanup;
+       }
+
        ring_allocation_size = ALIGN(rx->ring_size *
                                     sizeof(struct lan743x_rx_descriptor),
                                     PAGE_SIZE);

--
Best regards
Andreas Hilse
