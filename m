Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E262669DD
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgIKVHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgIKVHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:07:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD92C0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so8271921pfc.7
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jgFgQZn5QUo1XXE/gnomBtbR6UbPde/+9+WpoRrQOPw=;
        b=Q4u5rcfPt7QTOe1vp5gVHput9CRbaDUMGiQLJKMd3JvvKLhJd/6okyvWJ+Y87FeDgD
         61cHLgCITFeG4q7KdUqlzC1VCy7kPPEKuphbwB9zz+WvBD2BRCLVH8yCVxTXvYxC7f2J
         +Koa3GNxLfZaGRyAzkTafgMeDasWx9LGxrE4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jgFgQZn5QUo1XXE/gnomBtbR6UbPde/+9+WpoRrQOPw=;
        b=rLIThpbcz7GtVRbDNuO2ECNFj6f6iaESoDDJNc6cFEUZh/2073IiJnvx7Xp0UoYDlk
         6NwSQW05ubd5gUF7EyDFBpkeeAiTsqomejeThajCnp0cRyKLKcy9Ttn5LiK8w8d6T+rc
         Wqfoq4B/HvHBaZQDkt0tBEsr7qwLou4RhTc9xrMCog+RVZuUFTDHfbWqyVLbbRJVVyCD
         H3HWU0gDngXnCC8gxPls7Xo+zW3QiZl7xSbuVecrmmZUV0cigUYpwxpKiK2yjg5RXXY1
         FGkYk0Swbx0NB23uAu4BSdD/q9ISHbnseE3tt2yJtVFtmURc2GMAnMblxGApoLkG2UGv
         qJGg==
X-Gm-Message-State: AOAM5328zhghrLvLdWKn80rXCzt3m+QFPyIzJtN+E0xTrIGSiCwPduxC
        GyL2inHcClpEGb3FbNx3dlleDA==
X-Google-Smtp-Source: ABdhPJxRjwcNmLDTUlVLFGgGCsT6fXlVuUlJYNls9NwgRdY9arpE0quJZbmaUT8ai2G7WqhKVwnAHw==
X-Received: by 2002:a62:e90b:0:b029:13e:b622:3241 with SMTP id j11-20020a62e90b0000b029013eb6223241mr3834613pfh.12.1599858442536;
        Fri, 11 Sep 2020 14:07:22 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id c128sm3308764pfb.126.2020.09.11.14.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:07:22 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/3] Bluetooth: Emit events for suspend/resume
Date:   Fri, 11 Sep 2020 14:07:10 -0700
Message-Id: <20200911210713.4066465-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

This series adds the suspend/resume events suggested in
https://patchwork.kernel.org/patch/11771001/.

I have tested it with some userspace changes that monitors the
controller resumed event to trigger audio device reconnection and
verified that the events are correctly emitted.

Patch for btmon changes: https://patchwork.kernel.org/patch/11743863/

Please take a look.
Abhishek

Changes in v2:
- Added suspend/resume events to list of mgmt events

Abhishek Pandit-Subedi (3):
  Bluetooth: Add mgmt suspend and resume events
  Bluetooth: Add suspend reason for device disconnect
  Bluetooth: Emit controller suspend and resume events

 include/net/bluetooth/hci_core.h |  6 +++
 include/net/bluetooth/mgmt.h     | 16 +++++++
 net/bluetooth/hci_core.c         | 26 +++++++++++-
 net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 30 +++++++++++++
 5 files changed, 150 insertions(+), 1 deletion(-)

-- 
2.28.0.618.gf4bc123cb7-goog

