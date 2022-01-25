Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D01349AF48
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455922AbiAYJHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455318AbiAYJEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:04:07 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A0AC0613AA
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:23 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id z7so11378602ljj.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oUbvyNj5dnaM8qXXPaaN3calf58RmDrlF6ofRRGF5q8=;
        b=30zRHP3cawR9fo/gEqHpAmA2Q78/yKunsBnxe6QD4YYv2dV+ZUH16nD9lEUozhnFLi
         nHYLbBGOmgFfFBCvtZJX7kuVEvBu4m2+9ms9+7pTOTgRtfMzxt9YVEANSGx/w7I4cGpC
         jw3p/2FY/utquahuDCkPXVf9cP3dMXh1ALo00N0iSNlmm5xLEruBjkjf+/iYCKkWgFNS
         nstYMxpGvhRqCzKyuj3KxC4h/xGy312OnG1vehytswq716BF3P9bMbZeGDgSYjV9wyX6
         cy63f40FQeAPdxgeXgEgCLnSMUkFb/BH97zBfi7vKsVuAPm6i8bghcJniZYkJcjOpML/
         5gnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oUbvyNj5dnaM8qXXPaaN3calf58RmDrlF6ofRRGF5q8=;
        b=JupDp0dXbs+8gasv2sh6MnUNLV/vfkx1VO24uHlMvx2f4F+1T6de9y0joU7sRbefsb
         d3I/4vllvM8dPXDfmhfXr0A0/8chnpeCN+PTaIDgbzklnru2P2Oe1fvc/qgE0VlvNrzS
         PVHEYTLJ7gXP9wNGJBO1DYFdx7Zt4ime3f/MdWoh/UCdxhYdS/Q00ACdQyHObtITZARY
         FtpnfKPVnLittFTJRfl+UttjEL+MHnHoCXV+P6RrIAR3KK7fSebvUyko8nem7qrXNYS0
         5cRHoocH/sX0YbupF0cG6d1hM8dCi7tClQoY24H5P8502WMHtZ/wS6mE6RnsvLJwqQqZ
         siiw==
X-Gm-Message-State: AOAM532kM12pRBe2q870DeFRyAn8z6kMWfaKsyR39ykXjY3Mg/3QHtPL
        +XNQX0aEvAUAJn/+XXlyj21VD9BAgZmGOvrFWao=
X-Google-Smtp-Source: ABdhPJxmuLUFKp9der5dVvy/11NTxMaDlAPxrJvNLiMLIAlXxg1yxjfnkjVt3mTw9T6dl7CBTLbrbA==
X-Received: by 2002:a05:651c:b2a:: with SMTP id b42mr13381928ljr.168.1643100440664;
        Tue, 25 Jan 2022 00:47:20 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id q5sm1418944lfe.279.2022.01.25.00.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:47:20 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
Subject: [RFC PATCH 0/5] TUN/VirtioNet USO features support.
Date:   Tue, 25 Jan 2022 10:46:57 +0200
Message-Id: <20220125084702.3636253-1-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
Technically they enable NETIF_F_GSO_UDP_L4
(and only if USO4 & USO6 are set simultaneously).
It allows to transmission of large UDP packets.

Different features USO4 and USO6 are required for qemu where Windows guests can
enable disable USO receives for IPv4 and IPv6 separately.
On the other side, Linux can't really differentiate USO4 and USO6, for now.
For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
In the future, there would be a mechanism to control UDP_L4 GSO separately.

Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2

New types for VirtioNet already on mailing:
https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html

Also, there is a known issue with transmitting packages between two guests.
Without hacks with skb's GSO - packages are still segmented on the host's postrouting.

Andrew Melnychenko (5):
  uapi/linux/if_tun.h: Added new ioctl for tun/tap.
  driver/net/tun: Added features for USO.
  uapi/linux/virtio_net.h: Added USO types.
  linux/virtio_net.h: Added Support for GSO_UDP_L4 offload.
  drivers/net/virtio_net.c: Added USO support.

 drivers/net/tap.c               | 18 ++++++++++++++++--
 drivers/net/tun.c               | 15 ++++++++++++++-
 drivers/net/virtio_net.c        | 22 ++++++++++++++++++----
 include/linux/virtio_net.h      | 11 +++++++++++
 include/uapi/linux/if_tun.h     |  3 +++
 include/uapi/linux/virtio_net.h |  4 ++++
 6 files changed, 66 insertions(+), 7 deletions(-)

-- 
2.34.1

