Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B220D440CC2
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 06:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhJaFCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 01:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhJaFCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 01:02:40 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E38C061714
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 22:00:09 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f3so21466375lfu.12
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 22:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVy/fH24QPthS6HWBiNCLxZd58wLIhBCTESTMr1diy8=;
        b=GIqiP/e/0airkBt7AVVY9zwAqH+XFDnesnpw99ouddGWsttfIktj4aAfI9gEGXK9Mf
         IjUUcCwzBLka6YrTwoDQwnX+Sv4M5h86v4FbXS4pyxv7OW5d2c0MB+usBFsCg2VKoFFf
         a0IoU76Nm1UoIBaNYnjUN6hBfnNC9DAZldpovLf/WvQ1TPARBxfejVE+ogZJ8DcrCQg/
         ZDqLVhXkzk9SWmyB0eWrxcAqdDpz6iBZ61N1XUkXnDU/vGfpmtIckAaF7GuM8wjoM9US
         3pJLpff//y9JOx4cmV9NlSGe2Hhfu6m6I1h9kulySyK5GLhqixFRduT6YIGeh9+nmYGL
         BTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVy/fH24QPthS6HWBiNCLxZd58wLIhBCTESTMr1diy8=;
        b=WrgDkkFlyLVJTTYlhsgTmeIxkn2J3zeGeZJ+B57fNr1/UPh3hc65EGRDCCxwwZCjAF
         UpxcPimHpenu3Qs/y08/81EaI6va/3EsFJzB9sYYmOI/MdxrhH8D2UpukyI8LYzXXyqO
         5ZUALeLSikyL45iIJrrk0vnR6WuMj0gW4Y6eGJsUH4PRIVQzvUh4aRTNrVwAz7An7aoR
         PqjnBrkq845SE1PbjCg7mgAiK7ufxFi1Xzi0n9b/BE7z7QBAdliteYFm1JScruEAm+Wa
         FgF/TZPpkPPGNZ9UDoP1PacgVe+wLAidcYEh94CM7f6JB6VSB9NvEns17yulFtTfuXMF
         XfSw==
X-Gm-Message-State: AOAM530VMNkXFrwan9KfH/Z09P7lCaJyCeKgYDm/i/zc0G7JZ9+LaEnB
        XZu5mW51ejExUxqT1Tvq7zfjuQ==
X-Google-Smtp-Source: ABdhPJyKTkZQH3l/LPlaLkLV/r+BpuZCIeqJk+kdJFxDS+cI9MUR+ouY31Lbxo7K5bbon3ujFVQhIg==
X-Received: by 2002:a05:6512:260e:: with SMTP id bt14mr20820988lfb.129.1635656407162;
        Sat, 30 Oct 2021 22:00:07 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id v26sm444766lfo.125.2021.10.30.22.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:00:06 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuri.benditovich@daynix.com,
        yan@daynix.com
Subject: [RFC PATCH 0/4] Added RSS support.
Date:   Sun, 31 Oct 2021 06:59:55 +0200
Message-Id: <20211031045959.143001-1-andrew@daynix.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of RFC patches for comments and additional proposals.

Virtio-net supports "hardware" RSS with toeplitz key.
Also, it allows receiving calculated hash in vheader
that may be used with RPS.
Added ethtools callbacks to manipulate RSS.

Technically hash calculation may be set only for
SRC+DST and SRC+DST+PORTSRC+PORTDST hashflows.
The completely disabling hash calculation for TCP or UDP
would disable hash calculation for IP.

RSS/RXHASH is disabled by default.

Changes since rfc:
* code refactored
* patches reformatted
* added feature validation

Andrew Melnychenko (4):
  drivers/net/virtio_net: Fixed vheader to use v1.
  drivers/net/virtio_net: Changed mergeable buffer length calculation.
  drivers/net/virtio_net: Added basic RSS support.
  drivers/net/virtio_net: Added RSS hash report control.

 drivers/net/virtio_net.c | 405 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 390 insertions(+), 15 deletions(-)

-- 
2.33.1

