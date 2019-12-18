Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B97124122
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfLRIMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:13 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46501 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:13 -0500
Received: by mail-pl1-f176.google.com with SMTP id y8so616158pll.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stW6q6o/g8LwEAGpbODuve5PoiwiqkCf9ecn2t3NV1o=;
        b=RDyu9gFi8S7KJ8UhDlPkX8JWgbAb1qMh3cUw8eca+b32IYAqVXd6iBilUystBFIXvv
         AK+n/0NrntoEY8gk5VwbP8wnGSia+2naWpL+qebnxoNIoktWZ2M+S1rDfH+ye4Yb4Yfv
         g69WpWcxYntco27WzMKpC4ozHkhLwWcVF7Jtsm1pCINdOSuy4PX97mha4gOqTnZRwjuH
         XzhF1nVz47tINaFXP3cmt1mZ5LtWyp9Kt8xvIqX8vt2/DY39+ywZrUjdMv1ROV6uJnl2
         pFdZuf5WIy2KwJgDRYE2oREK2T7ZDXjt5JcNz3Tfm0OM5Urv8hnKZAUaWwD+vV6jd0fo
         eYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stW6q6o/g8LwEAGpbODuve5PoiwiqkCf9ecn2t3NV1o=;
        b=G6TX01VLACPL3PbW3TF9A9M9jYUsziAmSf+a8jKPSKMX0ucDB8cAtK3HDpc6GhxrI0
         JJXfdcMN7INIibyr9Gd7UGK7s5hskY+o4Ejg6X/NAln0CGj9Kg0hjZFK3bg9a4Eenb71
         U/4WAeBPPl9BDltPJplptKA1D7YuyPTr7sGMi43qa+yhBWkawoC+zIZxQLMQhr8D9vcm
         ftFHqfQqW12zAyWZUW71R2zStn7hWSOyzeuhMrZfKL0mt7kZmm+c2NDxQ11D39NIaE2a
         jHKjRYMKo9P+ikJOjLRA0ZN7QErzOSHnDpVy85sx0vAY+ZqQSFMSHmFOkmRGr1qLhV3c
         i4UQ==
X-Gm-Message-State: APjAAAVBOIVF4+Bmi0HZu0ff/PeWzcOJ1TTef4v3nWA5Rlr46boI2lIw
        pqByO57BHe1ItzbbWyYFPnQ=
X-Google-Smtp-Source: APXvYqzqiv6Gbzi5IBq7mcxRAvxnniG8CM8760Kx7dy8oy8OnRiWl/a0N2kmwBdjmvDLkUwN9qi5Dw==
X-Received: by 2002:a17:90a:b318:: with SMTP id d24mr1357287pjr.142.1576656732511;
        Wed, 18 Dec 2019 00:12:12 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:12 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 00/14] XDP in tx path
Date:   Wed, 18 Dec 2019 17:10:36 +0900
Message-Id: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This series introduces tx path XDP. RFC also includes usage of the
feature in tun driver. Later both can be posted separately. Another
possible use of this feature can be in veth driver. It can improve
container networking where veth pair links the host and the container.
Host can set ACL by setting tx path XDP to the veth iface.

It was originally a part of Jason Wang's work "XDP offload with
virtio-net" [1]. In order to simplify this work we decided to split
it and introduce tx path XDP separately in this set.

The performance improvment can be seen when an XDP program is attached
to tun tx path opposed to rx path in the guest.

* Case 1: When packets are XDP_REDIRECT'ed towards tun.

                     virtio-net rx XDP      tun tx XDP
  xdp1(XDP_DROP)        2.57 Mpps           12.90 Mpps
  xdp2(XDP_TX)          1.53 Mpps            7.15 Mpps

* Case 2: When packets are pass through bridge towards tun

                     virtio-net rx XDP      tun tx XDP
  xdp1(XDP_DROP)        0.99 Mpps           1.00 Mpps
  xdp2(XDP_TX)          1.19 Mpps           0.97 Mpps

Since this set modifies tun and vhost_net, below are the netperf
performance numbers.

    Netperf_test       Before      After   Difference
  UDP_STREAM 18byte     90.14       88.77    -1.51%
  UDP_STREAM 1472byte   6955        6658     -4.27%
  TCP STREAM            9409        9402     -0.07%
  UDP_RR                12658       13030    +2.93%
  TCP_RR                12711       12831    +0.94%

XDP_REDIRECT will be handled later because we need to come up with
proper way to handle it in tx path.

Patches 1-4 are related to adding tx path XDP support.
Patches 5-14 implement tx path XDP in tun driver.

[1]: https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net


David Ahern (2):
  net: add tx path XDP support
  tun: set tx path XDP program

Jason Wang (2):
  net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
  net: core: export do_xdp_generic_core()

Prashant Bhole (10):
  tools: sync kernel uapi/linux/if_link.h header
  libbpf: API for tx path XDP support
  samples/bpf: xdp1, add XDP tx support
  tuntap: check tun_msg_ctl type at necessary places
  vhost_net: user tap recvmsg api to access ptr ring
  tuntap: remove usage of ptr ring in vhost_net
  tun: run XDP program in tx path
  tun: add a way to inject tx path packet into Rx path
  tun: handle XDP_TX action of tx path XDP program
  tun: run xdp prog when tun is read from file interface

 drivers/net/tap.c                  |  42 +++--
 drivers/net/tun.c                  | 278 +++++++++++++++++++++++++----
 drivers/vhost/net.c                |  77 ++++----
 include/linux/if_tap.h             |   5 -
 include/linux/if_tun.h             |  23 ++-
 include/linux/netdevice.h          |   6 +-
 include/uapi/linux/if_link.h       |   1 +
 net/core/dev.c                     |  39 ++--
 net/core/rtnetlink.c               | 112 +++++++++++-
 samples/bpf/xdp1_user.c            |  28 ++-
 tools/include/uapi/linux/if_link.h |   2 +
 tools/lib/bpf/libbpf.h             |   4 +
 tools/lib/bpf/libbpf.map           |   3 +
 tools/lib/bpf/netlink.c            |  77 +++++++-
 14 files changed, 571 insertions(+), 126 deletions(-)

-- 
2.21.0

