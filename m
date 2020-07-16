Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39881222EB5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGPXKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgGPXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4026C08C5F3
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so8451197ejd.13
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BGxClFT8+p+SKxsICXW82xZrNVPLLcDakBK8DHRn9vU=;
        b=agHI7OdmLSjoA8e+umhb3QEfFGIV8v6lwcgIT+dtXa76Ejp6Icbq/dMaCMGBQvk9qb
         rojtRczsEPr9SDmrDgPq22ZYrAVGFhqOXhejkOqufuMcK8iyH5GvH4kVgPxZBO8pjcfH
         lvu+3WdIyhFjVNUI5qGCHXVe+w+9FbOj2pmgMC5noeF2NwHJfLSisM4rqGmwc8960ZnT
         Twm5up3rwEgNIG5urX0zBTopnwN9AjRDyEwe/bAzJcuX2eNAQqYy4C/PggQx1vM32F8Z
         AEaNwNuHFl8RH6Qazuqs2p7c/RvCkMQqVzPUPQb54ALB7D1nD6xB+U8l1+kGT3MtUOfu
         dR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BGxClFT8+p+SKxsICXW82xZrNVPLLcDakBK8DHRn9vU=;
        b=tzyp2Iu2L3CmFQWMUe2u+CYUBVKTJIR0kJjYlgxSSYOc2Cq3UFLQNr6BDif/4qAE2D
         5wtOImjuLZse3gFJ2Zpfng68Nr8H27Ks4Rzzgw2cODOjViVDnq5LWvT5gSsfDl0Bve3p
         vCB2/qfXlwH1bMUkqfBGn28+4mzzlAgKl6bUHETDYJ3VykVfv9OwcVXut9I8+RlElsf7
         X26VaL/pepNQYMPh41g0TiWoegFlDDzZQipp6ZfH5B/7UUDCHI9XifOvykcrSz2PXmLp
         Lp147xN2uiJhOBos7aJHa2qJzVE83l2kfYXxNuMk/bLxryH/O1nzexwRqLqAWqqt/Ttm
         E/Mg==
X-Gm-Message-State: AOAM5304FQKgWJbr6Up0efRBSPn7oDxxZgRhozUGUbVptDvzgISSSrN7
        AtNLvw2+IWG40NElk3DilCs=
X-Google-Smtp-Source: ABdhPJx//1UstaOLjPB48KFHEj0orcyRUM3danCyOOpCC2e1bY0hSIe5w4XpdNnIUAoXdlqNBma9Pw==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr6206755ejd.404.1594939663293;
        Thu, 16 Jul 2020 15:47:43 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ce15sm6285512ejc.86.2020.07.16.15.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:47:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/3] Fully describe the waveform for PTP periodic output
Date:   Fri, 17 Jul 2020 01:45:28 +0300
Message-Id: <20200716224531.1040140-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While using the ancillary pin functionality of PTP hardware clocks to
synchronize multiple DSA switches on a board, a need arised to be able
to configure the duty cycle of the master of this PPS hierarchy.

Also, the PPS master is not able to emit PPS starting from arbitrary
absolute times, so a new flag is introduced to support such hardware
without making guesses.

With these patches, struct ptp_perout_request now basically describes a
general-purpose square wave.

Changes in v2:
Made sure this applies to net-next.

Vladimir Oltean (3):
  ptp: add ability to configure duty cycle for periodic output
  ptp: introduce a phase offset in the periodic output request
  net: mscc: ocelot: add support for PTP waveform configuration

 drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
 drivers/ptp/ptp_chardev.c              | 33 +++++++++---
 include/uapi/linux/ptp_clock.h         | 34 ++++++++++--
 3 files changed, 107 insertions(+), 34 deletions(-)

-- 
2.25.1

