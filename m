Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8D1524BB7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353280AbiELLd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353254AbiELLdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:25 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095791CEEE2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:21 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q130so6096735ljb.5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tAEF+dbAnD48BnBbAU0BUAa+dO/2WAcVo20DYQ9S6dE=;
        b=UECWek238lb5RAmbHwzkIpgTNSdQ11Yfb8ASl/tP0D+HQl0Nqfix/MsfOtRNoHmEoS
         pYBiTFYwqDnkFF343Jlt3myrxbowelTAS5vAFp0X7RR2jW5QCI2kbGW96q+UKMSumJNJ
         PEJfOawrzMY/t1idHbgtWH70hLVne5s81XWksgpHJcGY3C9FjeD67VdEw6HQFbr+WXH0
         xSf6hh+TNj7Dn0ymg9FSV7zWtFdX4X4bqBplo0p+zej1/q35zQV5l9nrAfOLPIslbS8J
         XNFEy2vMChSbY1nrUdDWMiOuZ/0wXzvOBejBKQ9CHEY++XqhZiqizqEV4u8BCPclfeW+
         beMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tAEF+dbAnD48BnBbAU0BUAa+dO/2WAcVo20DYQ9S6dE=;
        b=zJaNxSgculUjkiZHRCsrpYxXVbdUFUPpAqFPmVp+KwFJEzITAObfN81qTFTpKa5tL/
         gre+zjM2zQTlTKYiBQUdyEg/hHzAeBdEyna72Tq1iAOs/1Mi4YUZkUjW5dlQqG6VyRLH
         aoOTTzd3rGxFr/uKIUHIW8UWugBSWWTCjnkzcl0jVmfwnxcb/V/L2zmVcWXZNgdEDPTG
         hq9Yt2tRN2lYkNYsNYryqe1IRRcesGwte9+t1+Q/CREaLvQK7FvPAFV0LFIoits0fChQ
         wxCsTZluRPAbTdLWoIcUMF+kf2b+aMZOHUI+kGC78WF133DN8gBOPWHYFNU7Oh9dd70l
         5dgg==
X-Gm-Message-State: AOAM533Vtp+hLRiPM1/Afi8LdTj1UpMkiebNBC8LLRgvsvT7CnDw7EgR
        IGK6lDLvzuyky66Fy+QeJeh+Og==
X-Google-Smtp-Source: ABdhPJxbMhTJ/x3wO6IIZjV3v1LV5Xd7J4V3uaASWzpb6lVcAwwLrn2oTVIUr8sq/9IvOQe5/iJWbQ==
X-Received: by 2002:a2e:9645:0:b0:24f:2e6f:f931 with SMTP id z5-20020a2e9645000000b0024f2e6ff931mr20426742ljh.466.1652355198391;
        Thu, 12 May 2022 04:33:18 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:17 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 0/5] TUN/VirtioNet USO features support.
Date:   Thu, 12 May 2022 14:23:42 +0300
Message-Id: <20220512112347.18717-1-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Andrew (5):
  uapi/linux/if_tun.h: Added new offload types for USO4/6.
  driver/net/tun: Added features for USO.
  uapi/linux/virtio_net.h: Added USO types.
  linux/virtio_net.h: Support USO offload in vnet header.
  drivers/net/virtio_net.c: Added USO support.

 drivers/net/tap.c               | 10 ++++++++--
 drivers/net/tun.c               |  8 +++++++-
 drivers/net/virtio_net.c        | 19 +++++++++++++++----
 include/linux/virtio_net.h      |  9 +++++++++
 include/uapi/linux/if_tun.h     |  2 ++
 include/uapi/linux/virtio_net.h |  4 ++++
 6 files changed, 45 insertions(+), 7 deletions(-)

-- 
2.35.1

