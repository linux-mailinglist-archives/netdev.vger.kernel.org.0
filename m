Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0998A3A72FF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFOAco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFOAcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881C0C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id h4so9095222lfu.8
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WRK1KM0OJQzVHuy+taUdiE7uganTmcRUsx82cLtTFc0=;
        b=oJP69FMGbZOfvpfbIRdGUwKPbiEvbcMlC0OZyBRpBeqAeEoUHS1ev+X9Tnmga8sdsm
         LRklalA2IBjCU+aTK8mkOY7K1AA7dRpGKnQTLgTVkVBXnUYT/zxh7FFPKEJ/vm0ttOqr
         wjMUb64MdllNSdvYtqFZX61eXXybGD3O1TMkYOZ9JtTwvmQqd6EPd5+5AUCTlrl3Uv4O
         5paIYpkRYxv9HKHatBiHNzAdmekpQjdwrYU4c19H+L4IDOoKrpLE26fQWLezZyRoNA26
         0LruGtJEUz3tJbjSr16tsuQ9ThpByFtcCNV3Q93xaTkyyji5q30R4wA73egDL35hy4d7
         9/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WRK1KM0OJQzVHuy+taUdiE7uganTmcRUsx82cLtTFc0=;
        b=H/zs76xeibG6CV0emoSisV4n1tHoceYnUlqHkJPINce3jRL8zu5OXLfDJ1TMFL73Dt
         ppREptUhyS+VCYT23x677CXE6/rRJFVOe+Sp0fOvp+3qLqkCj9V71qtp3cxuPQWwubaC
         5r3BJiFiLbnlsDiOF3HsfM4M4vlgFJrOriPTlZRcJi5/7Xp4Zn0QDXy9ZOPTnyXPlqUO
         CTOCN13NWmX43twFK02389xxWhdxEi0VC3GLEK83rwmgfI9vARw4aboZtw1tZROysXKv
         VgPBesur2wsdeCUUrs80yvDCwcce+0bSClmQKAtAbQEiy+VE12/IzTx6XMeij35012Ny
         MJJw==
X-Gm-Message-State: AOAM531gilSQpgXBeVqkIrQb5V09yXJbG82TaYbYqWRIW1OUqbEVZFjT
        SPKDZtmfcKQ6p+soO/MkERuvmeN7Jx4=
X-Google-Smtp-Source: ABdhPJyn0Mjd0wkTxp4iSx6a1u2IW29gSGowEK/3OA+8qEvIPLevo5iBew9bifTQOlfGFRoJWYFdtg==
X-Received: by 2002:a05:6512:556:: with SMTP id h22mr13533180lfl.601.1623717020022;
        Mon, 14 Jun 2021 17:30:20 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:19 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/10] net: WWAN link creation improvements
Date:   Tue, 15 Jun 2021 03:30:06 +0300
Message-Id: <20210615003016.477-1-ryazanov.s.a@gmail.com>
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
interface is binded to which WWAN device data channel.

I have a quite busy last week, and I am sorry publishing these changes
so too late, after all frameworks and drivers have been merged to the
net-next tree. On the other hand, it may be good that we have all
drivers in the tree, so we have a more complete picture.

All core changes have been tested with the HW simulator. The MHI and
IOSM drivers were only compile tested as I have no access to this
hardware. So the coresponding patches require ACK from the driver
authors.

Sergey Ryazanov (10):
  wwan_hwsim: support network interface creation
  wwan: core: relocate ops registering code
  wwan: core: require WWAN netdev setup callback existence
  wwan: core: multiple netdevs deletion support
  wwan: core: remove all netdevs on ops unregistering
  net: iosm: drop custom netdev(s) removing
  wwan: core: no more hold netdev ops owning module
  wwan: core: support default netdev creation
  net: mhi_net: create default link via WWAN core
  wwan: core: add WWAN common private data for netdev

 drivers/net/mhi/net.c                 |  66 ++-----
 drivers/net/mhi/proto_mbim.c          |   5 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c |  30 +--
 drivers/net/wwan/wwan_core.c          | 258 ++++++++++++++++++--------
 drivers/net/wwan/wwan_hwsim.c         |  47 +++++
 include/linux/wwan.h                  |  28 ++-
 6 files changed, 281 insertions(+), 153 deletions(-)

-- 
2.26.3

