Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735DA3AF8C8
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhFUWxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhFUWxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:22 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D203C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:06 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id u11so16483003ljh.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jeejMsKW9UQN9WCPYZXH+gS0TzaawNt7l97KCDEXWBI=;
        b=ulFwH32PvBOQHTUxR14HKK1iAiYw3eTjX7qe0WllV8t0mzE2W7+uQL5TkPDQZv3aly
         zeszfMGJpwHWKT2zgoYBpiB6Z6AhnlnkM2ndOgid0HyotnTSvdWzkKMKw3IhhN5S1DyS
         Wr/uzcbhOADN8wzbPhc6STZiINutgldvgcQWJ/9ckHfuPH8T/uFspnKTxNzGXYru/129
         AyUdRQ8NLjsvKK4Ruev5lF7SuDQl+iwEtiSw12jPH3+F1jIdUXPdLuC7y7gK3VVE2lWQ
         BO7BKa1x+H3ze3krghTzOIx0GRMBNobd/WZW4MyeHfahlvZL7kDT/ZGF3LmY6uLR+MB2
         rtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jeejMsKW9UQN9WCPYZXH+gS0TzaawNt7l97KCDEXWBI=;
        b=TEMGWpKX1w1YPwOfZk3ib9Xpnd2cplfjVEaIUlKSwMSfsj4Gcc/i4Ql1IhWoLItMvC
         F2B9wn/0dGFkl4e+NNGvNAdFXerbuX7jO8phZ9TIasV0u3dbQVMl3zRgy+hELRdV2+W/
         x1efrSPBfJUHik7WhuNuT/3Yd/7+ElGa0vqJXuD2lVES46DCCUIzhMa5uUJ2qhfgyAbR
         iS0Fj8XkWhZNI9omXfzpwBqdD4VZ/Crs9kpXuXTY3/XDJrhb5RBCg0yS6UK/i/0AVs6J
         V0SZdFGczMXudozyyJPMqX7DE71DG3DzPOURrsWa8FEUtyyMqwIUv5NKRhbq33NL0ecp
         RPiA==
X-Gm-Message-State: AOAM532G+gi2m7fL2+mROG+6m9jbcTz0rn+qdAt/BxgkjS9WfGd0G0Jo
        r1zIXW24Czp2dthAIX+9+qI=
X-Google-Smtp-Source: ABdhPJyKVFZD8Ape51/1Frii+WDaizb7/svrZMD++dqcg8oRHvTjcWItXZXSH7+JCboeVIMSFm+vSg==
X-Received: by 2002:a2e:58c:: with SMTP id 134mr407429ljf.441.1624315864520;
        Mon, 21 Jun 2021 15:51:04 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:04 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 00/10] net: WWAN link creation improvements
Date:   Tue, 22 Jun 2021 01:50:50 +0300
Message-Id: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is intended to make the WWAN network links management easier
for WWAN device drivers.

The series begins with adding support for network links creation to the
WWAN HW simulator to facilitate code testing. Then there are a couple of
changes that prepe the WWAN core code for further modifications. The
following patches (4-6) simplify driver unregistering procedures by
performing the created links cleanup in the WWAN core. 7th patch is to
avoid the odd hold of a driver module. Next patches (8th and 9th) make
it easier for drivers to create a network interface for a default data
channel. Finally, 10th patch adds support for reporting of data link
(aka channel aka context) id to make user aware which network
interface is bound to which WWAN device data channel.

All core changes have been tested with the HW simulator. The MHI and
IOSM drivers were only compile tested as I have no access to this
hardware. So the coresponding patches require ACK from the driver
authors.

Changelog:
  v1 -> v2:
    * rebased on top of latest net-next
    * patch that reworks the creation of mhi_net default netdev was
      dropped; as Loic explained, this network device has different
      purpose depending on a driver mode; Loic has a plan to rework the
      mhi_net driver, so we will defer the default netdev creation
      reworkings
    * add a new patch that creates a default network interface for IOSM
      modems
    * 7th, 8th, 10th patches have a minor updates (see the patches for
      details)

Sergey Ryazanov (10):
  wwan_hwsim: support network interface creation
  wwan: core: relocate ops registering code
  wwan: core: require WWAN netdev setup callback existence
  wwan: core: multiple netdevs deletion support
  wwan: core: remove all netdevs on ops unregistering
  net: iosm: drop custom netdev(s) removing
  wwan: core: no more hold netdev ops owning module
  wwan: core: support default netdev creation
  net: iosm: create default link via WWAN core
  wwan: core: add WWAN common private data for netdev

 drivers/net/mhi/net.c                     |  18 +-
 drivers/net/mhi/proto_mbim.c              |   5 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |   3 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.c     |  31 +--
 drivers/net/wwan/wwan_core.c              | 258 ++++++++++++++++------
 drivers/net/wwan/wwan_hwsim.c             |  47 ++++
 include/linux/wwan.h                      |  28 ++-
 7 files changed, 282 insertions(+), 108 deletions(-)

-- 
2.26.3

