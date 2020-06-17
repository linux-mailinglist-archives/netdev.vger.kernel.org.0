Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2491FC4E7
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgFQEAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgFQEAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 00:00:36 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CBBC061755
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so320115plo.7
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SB6NyllJ5c5QB2g83Rjs0/yw2ziAGwA5U5ta98dnIWI=;
        b=l8NTvh6NB0BN6VPtWGd2MQ+oChxu/lYfMhCaPIFk3rpRmFXKlI/bxKFlggLgyXTa3x
         /ZPad1Y3c/G2emO3S+dkCprNZ+AuF9POHsuUGhGQKJL3ddt6bkjC5MTaU83zGeL5vSrX
         3dmvSZ9XiCrlE3jjBwACVs/mrgnE7ha9wjMDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SB6NyllJ5c5QB2g83Rjs0/yw2ziAGwA5U5ta98dnIWI=;
        b=FpZD6ZQUXjL4TtAQyCAsMt28wiuqLXRk8khPhg7fluPhQr3kFyiwQoWUnbMjHvk5yS
         hasjytH5iHc0kavXk51t67T8PVxEI/4lrMqd8hVas8rh5cMGZssfJt1z1LmDildV32r0
         FxETfrvqZCm/Jt/E7H5L+PvaDjpSlCT7d+3POaipRPHcl7LBrR70XshOJ3WB32X2FNrr
         QijfzSHITBl5qjIngsYN7wMetkePaQDUsmxnTtnq7dil5Lm6cjv/VDqCcNAle/wxDybU
         u/nsSMsV8vs5c+xb//saduFtFDSiGbSzkrT7Lfus2cLGkJxkwzZCCOkIxMVAp86O0bHP
         fCrA==
X-Gm-Message-State: AOAM533abaUh9EXrMGbYtl99NLCxykifKlLTCQy+Pz1iDeoHNHBdQxaI
        0kacw0bWGrQ/7n8UD8mc0UmAKg==
X-Google-Smtp-Source: ABdhPJyTI/VLL17J/OWOTs8c/3WLZNCAlQ/tnQ6y8hYmbQqn2Rmvw+OvZRZajSEcKcD6/Ttyxi4QyA==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr5967423pjh.10.1592366435399;
        Tue, 16 Jun 2020 21:00:35 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id q1sm20013089pfk.132.2020.06.16.21.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 21:00:34 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/4] Bluetooth: Implement get/set device flags and device flags changed
Date:   Tue, 16 Jun 2020 21:00:18 -0700
Message-Id: <20200617040022.174448-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi linux-bluetooth,

This series adds support for configuring the Remote Wakeup flag on
devices by implementing Get Device Flags, Set Device Flags and Device
Flags Changed.

This was tested with some userspace changes to update the Remote Wakeup
flag (these changes will be upstreamed as Bluez patches once they're
cleaned up). I verified that Add Device generates the Device Flags
changed on all mgmt interfaces and Set Device Flags skips the one that
requested it.

This was tested on a Chromebook running kernel 5.4.

Abhishek



Abhishek Pandit-Subedi (4):
  Bluetooth: Add bdaddr_list_with_flags for classic whitelist
  Bluetooth: Replace wakeable list with flag
  Bluetooth: Replace wakeable in hci_conn_params
  Bluetooth: Add get/set device flags mgmt op

 include/net/bluetooth/hci.h      |   1 +
 include/net/bluetooth/hci_core.h |  31 ++++++-
 include/net/bluetooth/mgmt.h     |  28 +++++++
 net/bluetooth/hci_core.c         |  59 ++++++++++++-
 net/bluetooth/hci_event.c        |   8 +-
 net/bluetooth/hci_request.c      |  15 ++--
 net/bluetooth/hci_sock.c         |   1 +
 net/bluetooth/mgmt.c             | 139 ++++++++++++++++++++++++++++++-
 8 files changed, 266 insertions(+), 16 deletions(-)

-- 
2.27.0.290.gba653c62da-goog

