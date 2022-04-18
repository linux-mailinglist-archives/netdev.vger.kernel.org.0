Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62E504BC0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 06:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiDREqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 00:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiDREqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 00:46:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B33B17AA6
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so16332568pjb.2
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 21:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RIQ1bJgmr5fli73A9rUhbMjYKa6uyAioOx8tjIaRpE0=;
        b=IeEqEMc97Rl+tRpUmgW+iH+PZyo8rCY37FwzQ4f74T6VeqFp5VDHGKg11MFXXXqhRp
         OZrVPKManNBTNKabpyYaBgn+oeH1Rx+x+0RqPUVmvxAAKJelqWn1uoUGxm8wCqraoxMo
         lMZ4dIwv8150JEWcUjpE0p1vmJyV05yJAurahrekdXCMQMg8LWHsln7/hqNHAhyX24JK
         dOkC8Zs5g7hbYJY3OMMBfJVdugykap/iJMqqyeIXMpBPZZYd5JNbkZUa5v0rJ8d08o9p
         CFjWPw/bcBHhbb4SZ2SNMF4KmMOM2FhEkwx3MrA2r4HiDtwy1lbvEbq8Ivlqjh2cl1ZL
         g1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RIQ1bJgmr5fli73A9rUhbMjYKa6uyAioOx8tjIaRpE0=;
        b=kDN3Vv8g0iBCsZtr+QIVQIkBUdPWlJ3ti9ZwwchTgT9CvZREo7Ev/6rAt6su62TDYS
         o+MVNv5rpZTkjnrjARLyTNavPnINQbF3Aklz87DtmAsn+0hOpdELhshI5Gy7zIz+wT9S
         JipQmY4vHGsC3w9NLKSFZQORYrpix7tsr1L53iuE6nJQCLcBVZsm54LAs/GBU4z07LAG
         kV946G8Nbs4NUM+u8VgDnHDEu1s1w9pvbia39XsvwOvLsXdSSdI7pC6lLR5BW54Luhfu
         oLFFVsTcgTPDaqSk0hnZKKjeEVc4XOzkiDzbxZ0UDmNJSvym2+/7lYGASREL8M3UUkC3
         KksA==
X-Gm-Message-State: AOAM531SrYhT/Ai37Lkv4Lz/gq21cPlqTLQqc8M58mW/vAHGGUahBsKA
        M8SnGChVm2dObDymGci5y0682VFJhCw=
X-Google-Smtp-Source: ABdhPJx9k7SOIiv2cwhcIoQtQyI6hz4co0oftY3x5qMWtNg8uu5dwXrkXFQHg3jcq1CoHzoJNzrOTA==
X-Received: by 2002:a17:90b:19d7:b0:1c7:3413:87e0 with SMTP id nm23-20020a17090b19d700b001c7341387e0mr11264246pjb.132.1650257040518;
        Sun, 17 Apr 2022 21:44:00 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050a63adbb32sm3948110pfq.112.2022.04.17.21.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 21:43:59 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mailmpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] net: fix kernel dropping GSO tagged packets
Date:   Mon, 18 Apr 2022 12:43:37 +0800
Message-Id: <20220418044339.127545-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flavio reported that the kernel drops GSO VLAN tagged packet if it's
created with socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.

The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. And in virtio_net_hdr_to_skb() it also checks skb->protocol
blindly and not take care of VLAN tags.

The first patch adjust the network header position for AF_PACKET VLAN
tagged packets. The second patch fixes the VLAN protocol checking in
virtio_net_hdr_to_skb().

Hangbin Liu (2):
  net/af_packet: adjust network header position for VLAN tagged packets
  virtio_net: check L3 protocol for VLAN packets

 include/linux/virtio_net.h | 26 +++++++++++++++++++-------
 net/packet/af_packet.c     | 18 +++++++++++++-----
 2 files changed, 32 insertions(+), 12 deletions(-)

-- 
2.35.1

