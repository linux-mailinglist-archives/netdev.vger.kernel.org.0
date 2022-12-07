Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23D1645949
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiLGLvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiLGLve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:34 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17D550D6D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:51:33 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x22so13319169ejs.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DBe07ljlXyo0ttSKiN3zuuVFa38DRlnL73q8otf9TSw=;
        b=sjDaCL945dy0KcUZ8thrIDPspuRtiTokb0ndoNkAROQMdpLe5kMaQco70Ip0SL3yhD
         7PD1oSoL17ZZUdVzTXnFnHOWz9hUuz21ekmtxXYzBHtlmzJXF5BjucnyQG9B/DdTlsNt
         gqTlvABiJZ+dlrySl6mlcJ9+GWrsOX0BbV2rEU+LvA4vDIJ26EtsDlf7j5gotdw8YfiX
         FEO5/sdlYCxNGFZzz7Oti/QwHYFV59i0zH5Bplb7HByhNljHrAFNN+D4uuTSwSmlwOA/
         dDO/UYXL0m9/gPb9u2YI+cs8tGZzEsKNMAFeAuNEGkT1NPSXnHqZ0BYl8Vx52d55Tygk
         CKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBe07ljlXyo0ttSKiN3zuuVFa38DRlnL73q8otf9TSw=;
        b=SstTi+IwJ6CNTl1/3bPBdvtL0VFAGtKzXUcGrKuW84mExKMZvxFMmsOLmJthnXAZid
         ioJOGDlNIBuHLfKr+5ORhLOKfUJHAwiO5pDTx8Wu7j7TcGmTkhyPSvub/owKHuZTvuTC
         olKN0UBZjsGyg3eqWNcbdRyZgM+Z6oyqsq4uxfs4tahPvXSQaVoI99KOqiPZ0pRU8vh6
         9GVu2qOqbFKC+C8NkdzEoYOZNRlBN2XkoxoiDM2c+IfXFJRWFhF8dQDivk0OIPLmtSX+
         E/U8O8kAV84kDs2cMDOlwc+BCY/rBcrrhA4vo7pFjGocgngKl+PmXx6cHntUsJMVgi76
         COHA==
X-Gm-Message-State: ANoB5pkzp3K3PU3Zm1gnVdBcJmL18Oelofk0NVs11VLFeJqISmEhfDT2
        x3CzI24yARiyfJP/y2wEnDyzgQ==
X-Google-Smtp-Source: AA0mqf6UUiqke0lAkj898uNbfcI3c5cF0JtWZI1v2Dvi3QmAvQKNzuh5e1iZoSYanD5Cnu+m/mTkyQ==
X-Received: by 2002:a17:906:f281:b0:7ae:3b9e:1d8a with SMTP id gu1-20020a170906f28100b007ae3b9e1d8amr73129171ejb.581.1670413884373;
        Wed, 07 Dec 2022 03:51:24 -0800 (PST)
Received: from localhost.localdomain ([193.33.38.48])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm2132816edy.36.2022.12.07.03.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:51:23 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 0/6] TUN/VirtioNet USO features support.
Date:   Wed,  7 Dec 2022 13:35:52 +0200
Message-Id: <20221207113558.19003-1-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
Technically they enable NETIF_F_GSO_UDP_L4
(and only if USO4 & USO6 are set simultaneously).
It allows the transmission of large UDP packets.

UDP Segmentation Offload (USO/GSO_UDP_L4) - ability to split UDP packets
into several segments. It's similar to UFO, except it doesn't use IP
fragmentation. The drivers may push big packets and the NIC will split
them(or assemble them in case of receive), but in the case of VirtioNet
we just pass big UDP to the host. So we are freeing the driver from doing
the unnecessary job of splitting. The same thing for several guests
on one host, we can pass big packets between guests.

Different features USO4 and USO6 are required for qemu where Windows
guests can enable disable USO receives for IPv4 and IPv6 separately.
On the other side, Linux can't really differentiate USO4 and USO6, for now.
For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
In the future, there would be a mechanism to control UDP_L4 GSO separately.

New types for virtio-net already in virtio-net specification:
https://github.com/oasis-tcs/virtio-spec/issues/120

Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3

Changes since v4 & RFC:
 * Fixed typo and refactored.
 * Tun USO offload refactored.
 * Add support for guest-to-guest segmentation offload (thx Jason).

Andrew Melnychenko (6):
  udp: allow header check for dodgy GSO_UDP_L4 packets.
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
 net/ipv4/udp_offload.c          |  3 ++-
 net/ipv6/udp_offload.c          |  3 ++-
 8 files changed, 49 insertions(+), 9 deletions(-)

-- 
2.38.1

