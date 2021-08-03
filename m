Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3833DEF04
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhHCN0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbhHCN03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 09:26:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96034C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 06:26:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c16so25296229wrp.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=oPYDKoFd/DrU+SRry2jNJAdrvXJpib3esGX1KwnoZhk=;
        b=Fi5rUFnaDR5/wE1qR5mpBYvzNVfVNUs/8rNb4I7L6MfmPvOwvU/45rw3nIV+FytjIC
         HXINxl37f6uBL75nqtPsZrtwcNbkvBkhYO9gF3GQmY6TxXMkGkcS4npsay7V6UZvTrZ0
         DfvmLWvFADtoKfAKPDyI1Txf/A5L/Lnx1HmN+jmYWEOPdDexmiOUGDCec5DlkJTAf3X3
         1BSud/QbgFluwfAbtPb3lfuVhLwHVFjSaG4b+M42BPhCQ8MFWG7UzPfBiGRwIQ1YmkLY
         rhyyfAcD4rb10s8hBc9RTXZQiVtE+E/AXLrnDZtcU9gd5TQtG7YKq2qvSK/fSEsudOk0
         1qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oPYDKoFd/DrU+SRry2jNJAdrvXJpib3esGX1KwnoZhk=;
        b=sQ7LtBsekH23/G9B5wpTFFe/Lok3EcQo8lJczIKOJsi4S3TL6t2J4a9HCw6PIe61GG
         V0YWYIZlkUT8ITlwBzgior6bsvQtFS99XHVywgxk1BLpmXHnSADlGVveQE2eH1yhA2Nd
         tJP/8CnqEDOlcTjr8gC/ZMAgFBLVlsII1LHK6f6Y1bgSY32W95QLBVd+ES0YX6Ab/zsK
         fI3BB7ZGkIDRoKTRXdorrwRa14boVoac4UqYlvTOLfT0wAwaA3L4N5Mn2BuvrW2r0G8X
         2wV7BFzThEXZYyKBWs32hftQKvI7BqPD93dH2gsWxYsnKXNC1jXU3fOpq+KdrBnyOlor
         X7xg==
X-Gm-Message-State: AOAM532nY6Uwz54lQpNR0Rfrlq4poi4x26Rg2G9B66jTzBW8zN5eBY7x
        +MQcAORugLKrWMYutgbitGHCUw==
X-Google-Smtp-Source: ABdhPJyHS7NJrSv8fO7uM3j4W4783wup8IeHgSC1F6u3QNpHdDak5prFLsoO8lLfjIc7n61N1Umm5w==
X-Received: by 2002:a5d:55cb:: with SMTP id i11mr22980386wrw.158.1627997176142;
        Tue, 03 Aug 2021 06:26:16 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id k17sm3162065wmj.0.2021.08.03.06.26.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Aug 2021 06:26:15 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 0/2] net: mhi: move MBIM to WWAN
Date:   Tue,  3 Aug 2021 15:36:27 +0200
Message-Id: <1627997789-7323-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a proper WWAN driver for MBIM network protocol, with multi link
management supported through the WWAN framework (wwan rtnetlink).

Until now, MBIM over MHI was supported directly in the mhi_net driver, via
some protocol rx/tx fixup callbacks, but with only one session supported
(no multilink muxing). We can then remove that part from mhi_net and restore
the driver to a simpler version for 'raw' ip transfer (or QMAP via rmnet link).

Note that a wwan0 link is created by default for session-id 0. Additional links
can be managed via ip tool:

    $ ip link add dev wwan0mms parentdev wwan0 type wwan linkid 1

Changes in v2:
- Fix warnings reported with `make W=1 C=1`
- Add missing rcu_read lock/unlock for mbim links access

Loic Poulain (2):
  net: wwan: Add MHI MBIM network driver
  net: mhi: Remove MBIM protocol

 drivers/net/Kconfig              |   4 +-
 drivers/net/Makefile             |   2 +-
 drivers/net/mhi/Makefile         |   3 -
 drivers/net/mhi/mhi.h            |  41 ---
 drivers/net/mhi/net.c            | 487 -----------------------------
 drivers/net/mhi/proto_mbim.c     | 310 -------------------
 drivers/net/mhi_net.c            | 418 +++++++++++++++++++++++++
 drivers/net/wwan/Kconfig         |  12 +
 drivers/net/wwan/Makefile        |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c | 648 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 1082 insertions(+), 844 deletions(-)
 delete mode 100644 drivers/net/mhi/Makefile
 delete mode 100644 drivers/net/mhi/mhi.h
 delete mode 100644 drivers/net/mhi/net.c
 delete mode 100644 drivers/net/mhi/proto_mbim.c
 create mode 100644 drivers/net/mhi_net.c
 create mode 100644 drivers/net/wwan/mhi_wwan_mbim.c

-- 
2.7.4

