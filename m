Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4633038F7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 10:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbhAZJZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 04:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390921AbhAZJWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:22:23 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A52EC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:21:42 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id by1so21990767ejc.0
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XdLi2k7bp5m2hq3pEkkJKOTLNg7Dpyy+GJx91gunEG8=;
        b=RAQdfDKfGB5XehyNiAe7lCmK/wr+jWCKZgZCPxq8MlVuEH6vVEzbcnYBvKZhUbl4In
         lLLXCtzwYSN3eleiegfCjn1mBDa0lqHdczqrKTlWJuLbW6HsEDvYvdsgPKmkfMJgE9CP
         oCUz8WD7umQ7Bq+tM9jdH5bdFc/+ID2KeYOWQdfbJ+oWV+brDLytO5heWlM36JM0MYi1
         1iCJhT4JpWLTgCwwBit2B9CXHiK7Tc9NFeLZ0KpStjry7XuzcZX6dmORHQRJSkl/sU1u
         MjkSwARjz1LtZk0+AwfWaVyjv8dN6nlvgQ9FefSbUac1in9WkdfDDR2NlJkaLksjLAL3
         l82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XdLi2k7bp5m2hq3pEkkJKOTLNg7Dpyy+GJx91gunEG8=;
        b=fkD3flEjdPWaCWOGa0b70eVIz4wnpiS4ugb1ZJXETGVTIkbJjCP4OhzOUtT2txsso8
         rNBmqy0W8moe6M2n4aeqpFP+RUCZIu/G9KAwAM9HF7Dqx8yJOAxKfc5uBz0aUf1fJOd1
         Kjtp/ABLXN+Bg7eyfKYbHM+jawm+RfT1I3yJWyBSeSdXEm9f4t+tMiGdVX2xo7fRaD8e
         1mZXlLu1C+jkVHC4zpP1zQwre6n46d+ra7Cuxn2AO0r0SbXGnB+5YA20WIWpMpmcUkDZ
         +/8LwhRNrl4UeBTv7kEj12fSH+yJKL0x/mDh/S8cZ9INNyKAZj0dZDl+vgMYjA+KsbxQ
         UxHA==
X-Gm-Message-State: AOAM5337NVxGgqHpstuWPIBv9eIOJA6tBTW89qoFO5+yV4+T/R5Y5vIM
        raGZXtJa4tRYddVuLTrxTRXPLIhOzLiCwsus3cs=
X-Google-Smtp-Source: ABdhPJw/PzTYZ1qkLgDURIxHfYWD6i4N2xfrg2GJxNgol2HYKD5eRSyN+/37pEX2tAUv+yx+m5LsYQ==
X-Received: by 2002:a17:906:c410:: with SMTP id u16mr2777136ejz.159.1611652900833;
        Tue, 26 Jan 2021 01:21:40 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u9sm1195274edv.32.2021.01.26.01.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 01:21:40 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/2] net: bridge: multicast: per-port EHT hosts limit
Date:   Tue, 26 Jan 2021 11:21:30 +0200
Message-Id: <20210126092132.407355-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds a simple configurable per-port EHT tracked hosts limit.
Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
changes are still only in net-next that shouldn't be a problem. Then
patch 02 adds the ability to configure and retrieve the hosts limit
and to retrieve the current number of tracked hosts per port.

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: multicast: add per-port EHT hosts limit
  net: bridge: multicast: make tracked EHT hosts limit configurable

 include/uapi/linux/if_link.h      |  2 ++
 net/bridge/br_multicast.c         | 16 ++++++++++++++++
 net/bridge/br_multicast_eht.c     |  7 +++++++
 net/bridge/br_netlink.c           | 19 ++++++++++++++++++-
 net/bridge/br_private.h           |  2 ++
 net/bridge/br_private_mcast_eht.h | 28 ++++++++++++++++++++++++++++
 net/bridge/br_sysfs_if.c          | 26 ++++++++++++++++++++++++++
 net/core/rtnetlink.c              |  2 +-
 8 files changed, 100 insertions(+), 2 deletions(-)

-- 
2.29.2

