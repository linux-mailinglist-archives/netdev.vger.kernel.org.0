Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFD63FA54
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiLAWMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiLAWMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:12:09 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EFBC460B
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:12:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ud5so7537859ejc.4
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xS2P4l3h67FXA/VaxZNf4GYyU7HMjaYo9LN5Y0vNp+c=;
        b=4j5NUQ9QdJc57qk824L+vXNEARliSp3Y2YM09ia9uXfX+4XV1Y3dOzHw+peBOIsPfw
         oqFKaK35oDA1QKOIS8ON/8sZHuQNyec1tsHa8sjWvizzo7OOA83WPtK8WX3lRt3sU+mv
         4ELV0XJuB3DVbDsmeQAJRkxQKOO5yIUxYThPpQH+kGvkf7wB0MEMrwHthDE1FC38VE14
         pF/cc7T2DxJ34QccGCvIaaJxm4pqWdQTCEguW5j86I1nuF/7AubfyTV0Pa3wMYAkb78+
         adEXWqVpLrlGYlK8fSqehtZLAYHhrrN0LDwzyLZJmgQ3xWT43Jb4/dO0SroCLGoFCtnk
         wLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xS2P4l3h67FXA/VaxZNf4GYyU7HMjaYo9LN5Y0vNp+c=;
        b=kZfTrspX5qE1j6kEyDkXi2A1BhREPW7Dul9xJwiwcZq4i3ZEDMVzf4tDVJNUT72bTI
         V7x0yYSw/goqGSHVJVXZ9ccfc4XZ8taM/7ezIOJkZsS+OPj9Xa5QDuk3BDmMUVI709si
         sSW5SMyeNEoK1CO08ec5SyJMKtBRJeJ0K5n9p+zzF9WvkcpmpREzN+0R416mn0HWs7nM
         +vA9d2pAIL/2Pw8OoGM6ifYK3DvYYuSTX5KPyviPHpEMTwXaCqwm15NfFEBPGhlIxo5h
         kEvw+DB767vpPRJymPk5T6eS43d7PE5jofoA0IHI+Q0hKVDuyVRlMMS+CdhhsF91TnVT
         ooqA==
X-Gm-Message-State: ANoB5pn4dMdUK5UDFnNjS2adTT7TcqOzfCPvhW+2R0K2ckld8qOva3DC
        4dUZK59K8Hven4huyzpEvf6b6g==
X-Google-Smtp-Source: AA0mqf6UzOvVeGPxnQxjxwIH4JOjFC003wnQEu5aMFSrUpWtBcU4R6aGxTPaBPL2zLpN5i1c9/Hk2g==
X-Received: by 2002:a17:906:ce4d:b0:7be:1b8b:21fc with SMTP id se13-20020a170906ce4d00b007be1b8b21fcmr23250111ejb.666.1669932725308;
        Thu, 01 Dec 2022 14:12:05 -0800 (PST)
Received: from localhost.localdomain (46-133-148-166.mobile.vf-ua.net. [46.133.148.166])
        by smtp.gmail.com with ESMTPSA id gf16-20020a170906e21000b007815ca7ae57sm2230726ejb.212.2022.12.01.14.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:12:04 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     devel@daynix.com
Subject: [PATCH v4 0/6] TUN/VirtioNet USO features support.
Date:   Thu,  1 Dec 2022 23:56:38 +0200
Message-Id: <20221201215644.246571-1-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/virtio_net.c        | 24 +++++++++++++++++++++---
 include/linux/virtio_net.h      |  9 +++++++++
 include/uapi/linux/if_tun.h     |  2 ++
 include/uapi/linux/virtio_net.h |  5 +++++
 net/ipv4/udp_offload.c          |  3 ++-
 net/ipv6/udp_offload.c          |  3 ++-
 8 files changed, 56 insertions(+), 8 deletions(-)

-- 
2.38.1

