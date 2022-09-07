Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132FA5B0444
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 14:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiIGMvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 08:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiIGMvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 08:51:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9403B75CD3
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 05:51:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j26so8713494wms.0
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Eixd0LQlH9rFcFjWqY+uzWCg74XW8uX92B343SAZfdI=;
        b=Ua/cyoxQXRqo0RqGtbjFqvKgM9vCY0kNMhEbEbPQnYmskVEQSSAs2UjliwH+aDY92z
         Dm0deZY0cQBo7YmcaodkWAg4uwigGImN3kqL5BRQ0Cdv59fRCz/630LrjITA2g3MBcTJ
         Orqz3NW40BVAgBUkcsjP+R42xeriW2nsEMBC61s+eqWcqcWxK4b8D06d0FAC7g0B/nua
         RsgHocu5HNwvpRdN1fkrZCQfJLwtmv9sv0x0Aq2Lggd6uRsqyXpjbVC2g8YFusAHVSew
         y0bUUr/rvmnvu3T7f8Um+fYaVTLUZWPczhNY0OYatwtsUBocMr07kWIT/zy7yKyTAe4/
         7h7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Eixd0LQlH9rFcFjWqY+uzWCg74XW8uX92B343SAZfdI=;
        b=vPChJIcAZNMlsdjhX4MaFMM6db5CbPvBEzkqau8V6lWkT8UUXVLUFCJcpulk6XDQvH
         2pXu1Hu9b1GklSt7SEGbCtrm1kY0l3m3yRFxTYGM+5C2k6kw6K+oWEYJDHD+3aDSIkQp
         DOfb+nDU/KAL7GExXgcKOOs+HvwZDsNx+az5erIZvQVQdd1on0wrTpb53Sg7MuKC0T9s
         4Lm/CmxEDVLmlfhOry4vBuBmVa0KWqEP3zpZVYHps3+dcEhqlwXH8Amss/B8hk9suZef
         /teDK/1zVoloVaAAlPn/vzc7M5MiebQBhcC0iEaHtdJIJsH3LyH4Ppm93idff6CEF4UT
         0Dgg==
X-Gm-Message-State: ACgBeo3lsPsmCWnyVJqQHvvA9IoFf4PZI8sNbsNbgwVVmwQMvJ2+iyRc
        7AW7XV2r+uF12kH/2qQ3Z/qcpw==
X-Google-Smtp-Source: AA6agR5nqbud/xqJWh1gRcFJdSIwxrCkx4UG/dfRBJj0MMjTrVl4a1rLD1tnDU/z+D4K1HRYzI57Tw==
X-Received: by 2002:a05:600c:22cd:b0:3a6:7b62:3778 with SMTP id 13-20020a05600c22cd00b003a67b623778mr1937379wmg.45.1662555072169;
        Wed, 07 Sep 2022 05:51:12 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id e27-20020adf9bdb000000b0021f0ff1bc6csm11480001wrc.41.2022.09.07.05.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 05:51:11 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 0/6] TUN/VirtioNet USO features support.
Date:   Wed,  7 Sep 2022 15:50:42 +0300
Message-Id: <20220907125048.396126-1-andrew@daynix.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
Technically they enable NETIF_F_GSO_UDP_L4
(and only if USO4 & USO6 are set simultaneously).
It allows the transmission of large UDP packets. 

Different features USO4 and USO6 are required for qemu where Windows guests can
enable disable USO receives for IPv4 and IPv6 separately.
On the other side, Linux can't really differentiate USO4 and USO6, for now.
For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
In the future, there would be a mechanism to control UDP_L4 GSO separately.

New types for virtio-net already in virtio-net specification:
https://github.com/oasis-tcs/virtio-spec/issues/120

Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3

Andrew (5):
  uapi/linux/if_tun.h: Added new offload types for USO4/6.
  driver/net/tun: Added features for USO.
  uapi/linux/virtio_net.h: Added USO types.
  linux/virtio_net.h: Support USO offload in vnet header.
  drivers/net/virtio_net.c: Added USO support.

Andrew Melnychenko (1):
  udp: allow header check for dodgy GSO_UDP_L4 packets.

 drivers/net/tap.c               | 10 ++++++++--
 drivers/net/tun.c               |  8 +++++++-
 drivers/net/virtio_net.c        | 19 +++++++++++++++----
 include/linux/virtio_net.h      |  9 +++++++++
 include/uapi/linux/if_tun.h     |  2 ++
 include/uapi/linux/virtio_net.h |  5 +++++
 net/ipv4/udp_offload.c          |  2 +-
 7 files changed, 47 insertions(+), 8 deletions(-)

-- 
2.37.2

