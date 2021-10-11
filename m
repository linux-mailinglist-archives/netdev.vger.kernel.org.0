Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CF429386
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbhJKPi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239178AbhJKPiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:38:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E22C061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bt5-20020a17090af00500b001a070233029so3914731pjb.4
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=za2ykkJfooS6Ns88+lmE4SX4Wdg8SdyMH4NyEwrbUXc=;
        b=WiwciKmzL3bOx1vRxyblfUg4mSpR9Mhd9LZb6x39pLshALplEXI5Vl0pOvUTP8Jg1Y
         cHsPNzYenOW8V4tRSnWqAVCEayFOZ9QkwXcQWdrMcXuBa40Mkso/k+L1Oi0VCGDlt1FJ
         ClPxiZGgCRvMdiTUr/Xe/VrFETQ1ssZLTP/XBCQJLD/YylZhbaFvF0dVICN5HYr8AO6E
         jHzt8TXIxNMtWdGHJGn5d5OUfQxRDVdDaFo+gp2n05A1AO5VENBizLpLaZFbmwoVt3C4
         +lm7UmIRB2PxgupSw7L1U80u9hHMMm4WmmCbVtzem3xZuqINlal7xFw7sddDdg24/wyd
         g8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=za2ykkJfooS6Ns88+lmE4SX4Wdg8SdyMH4NyEwrbUXc=;
        b=SudV9V8PYB6r4290xdvXMyCrOhTw22mIYOW/tR+F9f/frUF/y918qBafwnhJtdp3zI
         ja7su3J6rK40jBa/i9RnRQp/2jNWNuNpvZQXYdwykRxlfGrT1P4nlSXuyjUKIXt/orti
         D10S5pGkX/21+8BhFmijoyhu5PSTnjrytoL4iKLLP5HG1xTK+RWHFCnM5JwxpvGZk7ME
         wdiZu7ZxUPKWf20dx02LtKI+sT+v/xvLqKMnViJU9I7ULR8IW+TT6d7x1HTII8F52//e
         h4suoMwm4eE4PrqNy1/ewXMyZbT2JkutupDROD71qxb16eYZPxe+U1HaH1K28GrQLWEy
         MJeA==
X-Gm-Message-State: AOAM5314rpQmxB6X61nT8oHa7BbHSa7LKmK6fUn6/rea9Wvj0D5xktwf
        D7vCLbQjuOexQSVHeO0XvD48w5h+jSVPn5LFThwoKeQ2FY6YH5ad7w4Xh1skGfjrUIY+LJYQHdg
        Tu4H4CFMcmJCsvL5kB+Pd5JTFf0bp01gDjt1V8CaD6P+HLAGIELfda1ql9QAp7EucSS8=
X-Google-Smtp-Source: ABdhPJwcTvyXWcEbxzoNjeOOaJJbtD+FWaz+nxqhqCeT+HGxYgbDhbOxkIiJ8EdkDTkvwOaRV2E4DgETWgM17g==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:a085:: with SMTP id
 r5mr2930740pjp.8.1633966614382; Mon, 11 Oct 2021 08:36:54 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:43 -0700
Message-Id: <20211011153650.1982904-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 0/7] gve: minor code and performance improvements
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains a number of independent minor code and performance
improvements.

Catherine Sullivan (3):
  gve: Add rx buffer pagecnt bias
  gve: Add netif_set_xps_queue call
  gve: Track RX buffer allocation failures

John Fraker (1):
  gve: Recover from queue stall due to missed IRQ

Jordan Kim (1):
  gve: Allow pageflips on larger pages

Tao Liu (1):
  gve: Do lazy cleanup in TX path

Yangchun Fu (1):
  gve: Switch to use napi_complete_done

 drivers/net/ethernet/google/gve/gve.h         | 18 ++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  1 +
 drivers/net/ethernet/google/gve/gve_ethtool.c |  3 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 86 ++++++++++++----
 drivers/net/ethernet/google/gve/gve_rx.c      | 98 ++++++++++++-------
 drivers/net/ethernet/google/gve/gve_tx.c      | 94 ++++++++++--------
 drivers/net/ethernet/google/gve/gve_utils.c   |  4 +
 7 files changed, 201 insertions(+), 103 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

v2: Added this cover letter

