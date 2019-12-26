Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05A512A9C7
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLZCdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:14 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51449 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:13 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so2764204pjs.1
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gucOzDjkuZ3oags9bX18BFLi1k/XY+J3K3Vj91DSbAk=;
        b=O0dkJJiz2rUwn8VQCbiDBatNh+uV9HvGUg5yHDSI/G+S3MZiLwzWBmvTNKljkyJWNc
         xfckGWXKZr5OTxd/INIoOesrXn2MWKS9S/NtwUkieSoNjCO9BAo0vIHR0EE00D2CIjIM
         ytJLfCbGeahZwTJ4EaXFBZIj8gpwJo1uJUdFpB2tjxT8LM9KBZBXwTzgSs2AeL/XTa8+
         U46BFhwWBA7rXXGwTS/Izk7Mx8QRL6Htw5yaHBXVRXxRbbfIIBSxafyhHkFK5C9GxOPX
         bukkP92b/uJ6DDSXM107ml+t1HhI8X4D6UOpSzg0eQv43x/9D2nDTdz5JNmJnPNC/3Y8
         kRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gucOzDjkuZ3oags9bX18BFLi1k/XY+J3K3Vj91DSbAk=;
        b=Ykr17QxEO7pENbb49gfVXtuHmbL4JJ6vsIutOH1dYtBTw6C5bGPa/IafWMb9L2ibUC
         lP5j3bBIoD1Rf2uibxUTy8+1bHaCpMpk6vFcEznYcMsLrZMwvZSNFjbCImaQlRc3/Taj
         cdUfBSArM+bUpw9XMcgaylcDha2BPcy9j8+5Y8MvI3PUAUoxyr4XwcZbJMzv/nTpENDX
         llRMpmsySBuUX1YDJPhMKfvj+zCqrg9foZ9fzsEjkQUy3X9oCCITQsY0PvTUN/v+d6g9
         lD+vTcGGdpjbkY9KZNfJVJGVlR4cNQh5XaL9VHL2CdXo4iTqqcmk5/sNlBhImo3Mc//Z
         /YCw==
X-Gm-Message-State: APjAAAVY62Ftxc57nVyFn9Cao+kGE3429Q99v6Ud/l7UzJMPIov5Rsvr
        Ut7bVOSlCarVsXSuK4VE6i4=
X-Google-Smtp-Source: APXvYqyetp6QHYucshwRx90F1o3StjMA8gHU5LCFxuCIUwLoBGZrA8mv/x1W+VMOwLNC7LUGt43s6g==
X-Received: by 2002:a17:90a:ab86:: with SMTP id n6mr16694031pjq.53.1577327592697;
        Wed, 25 Dec 2019 18:33:12 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:12 -0800 (PST)
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
Subject: [RFC v2 net-next 00/12] XDP in tx path
Date:   Thu, 26 Dec 2019 11:31:48 +0900
Message-Id: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- New XDP attachment type: Jesper, Toke and Alexei discussed whether
  to introduce a new program type. Since this set adds a way to attach
  regular XDP program to the tx path, as per Alexei's suggestion, a
  new attachment type BPF_XDP_EGRESS is introduced.

- libbpf API changes:
  Alexei had suggested _opts() style of API extension. Considering it
  two new libbpf APIs are introduced which are equivalent to existing
  APIs. New ones can be extended easily. Please see individual patches
  for details. xdp1 sample program is modified to use new APIs.

- tun: Some patches from previous set are removed as they are
  irrelevant in this series. They will in introduced later.


This series introduces new XDP attachment type BPF_XDP_EGRESS to run
an XDP program in tx path. The idea is to emulate RX path XDP of the
peer interface. Such program will not have access to rxq info.

RFC also includes its usage in tun driver.
Later it can be posted separately. Another possible use of this
feature can be in veth driver. It can improve container networking
where veth pair links the host and the container. Host can set ACL by
setting tx path XDP to the veth interface.

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

Patches 1-5 are related to adding tx path XDP support.
Patches 6-12 implement tx path XDP in tun driver.

[1]: https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net



David Ahern (2):
  net: introduce BPF_XDP_EGRESS attach type for XDP
  tun: set tx path XDP program

Jason Wang (2):
  net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
  net: core: export do_xdp_generic_core()

Prashant Bhole (8):
  tools: sync kernel uapi/linux/if_link.h header
  libbpf: api for getting/setting link xdp options
  libbpf: set xdp program in tx path
  samples/bpf: xdp1, add XDP tx support
  tuntap: check tun_msg_ctl type at necessary places
  vhost_net: user tap recvmsg api to access ptr ring
  tuntap: remove usage of ptr ring in vhost_net
  tun: run XDP program in tx path

 drivers/net/tap.c                  |  42 +++---
 drivers/net/tun.c                  | 220 ++++++++++++++++++++++++++---
 drivers/vhost/net.c                |  77 +++++-----
 include/linux/if_tap.h             |   5 -
 include/linux/if_tun.h             |  23 ++-
 include/linux/netdevice.h          |   6 +-
 include/uapi/linux/bpf.h           |   1 +
 include/uapi/linux/if_link.h       |   1 +
 net/core/dev.c                     |  42 ++++--
 net/core/filter.c                  |   8 ++
 net/core/rtnetlink.c               | 112 ++++++++++++++-
 samples/bpf/xdp1_user.c            |  42 ++++--
 tools/include/uapi/linux/bpf.h     |   1 +
 tools/include/uapi/linux/if_link.h |   2 +
 tools/lib/bpf/libbpf.h             |  40 ++++++
 tools/lib/bpf/libbpf.map           |   2 +
 tools/lib/bpf/netlink.c            | 113 +++++++++++++--
 17 files changed, 613 insertions(+), 124 deletions(-)

-- 
2.21.0

