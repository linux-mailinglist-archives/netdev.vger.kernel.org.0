Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C17252436
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHYXcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHYXcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:32:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73416C061756
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d80so378699ybh.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=mTR23obn3++N19RG/EtHRUQ3yC7sF+wMDpRoTOlZX0k=;
        b=ILiabPYE0me1HApwqMZ2+3BMmFww6n1ALOpdSBbDFbzKlr8HpfRhnjA+ISbcuuCAQR
         9T01Gt5pqwAn+LaofE7+YcT/A8YfaoOaSm1n03/ZcmKrAq4bY8iQ3M5U1xY70qywVrOD
         /cvdd25kfRWSFfgRbHhF4e+h85P2hLdeSwto5EXMHXa8Fqk3Hkwai09/435nJcz7/Wxz
         9oO+z1NaMwqw3BEs1OEnxEY05fEMo4zXU6l/2iQLtpIr1W0KYbfx7WWk8sLHtkoJF6mx
         Lyn4XwjPSRbR2cL2swtxooPGCKUbsCemeyS7KjzH8jazjYlc/M/euZDEP39GlCSuEHAu
         Si3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=mTR23obn3++N19RG/EtHRUQ3yC7sF+wMDpRoTOlZX0k=;
        b=M1GqIiN3Zsme7DaJmBGinRj/v2QHRw6PK0G0xJeaYPIEulKxvk+32DKYp0LcLIb1Q2
         ETk8k2FHvmVtHI2Nt5UsPplm02oHZBvckjU9o0/Xuvdgp7O5Nd2h9hyvmxik5FKK11VU
         jTzgGPa3DOB9Ki5DffKeapkaKSmcO4jBrORZyT89/CXmu/cZ4mM99nS/e8OQYp3ZP4ph
         Xgr9pc9LCpv2V9DZPtc4OPJIAd9mm5KoKNx9pXS1QjnMxjN/tH8iqfdt2XOZf/2dGZlp
         hZqaE20kymfmN81t3fL/pvX2ZGO5S8yNm1SHR/oVE1ZUHp+Z7vuSyOxzgeddH4JZHa0Q
         G06g==
X-Gm-Message-State: AOAM532Sbc1IwnD8gWrHpaTdm4Qe2uj50JqtWv5f9HjVnJKEEbKl1WuO
        yGAeHeN8V0sX1hxcKo7flzgr6DlaDNKepJ2oP7yV
X-Google-Smtp-Source: ABdhPJwwLjoeH289Grt/z9y7LeTjH6etNBMtETY13Iy6KtTX8eH2Poc0k3x27Uzj1hmt6b9xngXhpGRYYx+hu4S5cLCO
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:c68b:: with SMTP id
 k133mr18907196ybf.491.1598398320460; Tue, 25 Aug 2020 16:32:00 -0700 (PDT)
Date:   Tue, 25 Aug 2020 16:31:49 -0700
Message-Id: <20200825233151.1580920-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH 0/2] Bluetooth: Report extended adv capabilities to userspace
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Maintainers,

This series improves the kernel/controller support that is reported
to userspace for the following extended advertising features:

1. If extended advertising is available, the number of hardware slots
is used and reported, rather than the fixed default of 5. If no hardware
support is available, default is used as before for software rotation.

2. New flags indicating general hardware offloading and ability to
set tx power level. These are kept as two separate flags because in
the future vendor commands may allow tx power to be set without
hardware offloading support.


Daniel Winkler (2):
  bluetooth: Report num supported adv instances for hw offloading
  bluetooth: Add MGMT capability flags for tx power and ext advertising

 include/net/bluetooth/mgmt.h | 2 ++
 net/bluetooth/hci_core.c     | 2 +-
 net/bluetooth/mgmt.c         | 8 +++++---
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.28.0.297.g1956fa8f8d-goog

