Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA9A109BBF
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfKZKIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:08:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34683 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfKZKIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:08:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so8952396pff.1;
        Tue, 26 Nov 2019 02:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dgd0qtYqKPxWRq61gIy+YSZx4uaumU6Lw6yTRUkuKx0=;
        b=gs+0EL6DS1qVd1mMjn03U+2SDg6BSsQVIyn0+mx8IIpB8UAx3DnmpfJFTBT/AEWeNz
         Ua6Xppf1hn8qdJYs1a1lKJWj7IrM6R/D7Y05mrE/xLQFhPQoD2vH9unk/hkT0nP9+4tA
         ihI7ZBBam46tspN95Zi/BG+/QrzMr1t1sXiWMn5xDcGmxqUNnxIoQJB/vpF53VhuXPLt
         VNUXFTzR9umKDYl3w7bCn7avJVtoJiZcj3D8hr5vO9YiT3TxNoDTV7oqKGFRtJvxLQx+
         wx5M+gVfwYgXnpQzBwQyqul0jNyDUNn018vPemJHcyNqaSdT0vbhgrPCHJnJKnSwFOy6
         bDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dgd0qtYqKPxWRq61gIy+YSZx4uaumU6Lw6yTRUkuKx0=;
        b=rBhRmKhEfrgPOGqREGfglMbO2mjiHH5SgleObTxq1YpistWCvv7ggqj5dk0PDd3iWi
         xYuJh8lO8byWm6Zq0yas0KFUezLIkqZqUuY4N4EqavnFm+C6zaR5afgr/VmxvFNgm14T
         f2KCqxUmUeccLE04sEEAELUZ/LvNagD7vUPrv91JSK5l2Mlc7nbh24VQoEeWjej4bqeM
         I7pgI+zavB/J81EYfFmXefZ3Y8TZyCNxR0sOwd5IAlE4CSHoPf+/pbAK4vwokT0Q7eD6
         Z/cKwnsjhx35cWfb+VemK1IsgDadFfbfXT0cdGzU6mxmMncElMeAUMNdju6k+pymwjM9
         oxOA==
X-Gm-Message-State: APjAAAWxA0rOVuk4BJ33+QY0FT4aKiuHtooceJUvVGldbGUXlIVDP2KV
        a9sUQJDpq20sJ5j717qQ58A=
X-Google-Smtp-Source: APXvYqxqGp3aRO3lANC9+LKjj3icpyAXEIh7gRlveUqd4Gk4vqKsYBQHP2rU8rGQsQy92j3SmhTT4Q==
X-Received: by 2002:a63:9d41:: with SMTP id i62mr38895730pgd.310.1574762921848;
        Tue, 26 Nov 2019 02:08:41 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:08:41 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 00/18] virtio_net XDP offload
Date:   Tue, 26 Nov 2019 19:07:26 +0900
Message-Id: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: This RFC has been sent to netdev as well as qemu-devel lists

This series introduces XDP offloading from virtio_net. It is based on
the following work by Jason Wang:
https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net

Current XDP performance in virtio-net is far from what we can achieve
on host. Several major factors cause the difference:
- Cost of virtualization
- Cost of virtio (populating virtqueue and context switching)
- Cost of vhost, it needs more optimization
- Cost of data copy
Because of above reasons there is a need of offloading XDP program to
host. This set is an attempt to implement XDP offload from the guest.


* High level design:

virtio_net exposes itself as offload capable device and works as a
transport of commands to load the program on the host. When offload is
requested, it sends the program to Qemu. Qemu then loads the program
and attaches to corresponding tap device. Similarly virtio_net sends
control commands to create and control maps. tap device runs the XDP
prog in its Tx path. The fast datapath remains on host whereas slow
path in which user program reads/updates map values remains in the
guest.

When offloading to actual hardware the program needs to be translated
and JITed for the target hardware. In case of offloading from guest
we pass almost raw program to the host. The verifier on the host
verifies the offloaded program.


* Implementation in Kernel


virtio_net
==========
Creates bpf offload device and registers as offload capable device.
It also implements bpf_map_dev_ops to handle the offloaded map. A new
command structure is defined to communicate with qemu.

Map offload:
- In offload sequence maps are always offloaded before the program. In
  map offloading stage, virtio_net sends control commands to qemu to
  create a map and return a map fd which is valid on host. This fd is
  stored in driver specific map structure. A list of such maps is
  maintained.

- Currently BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH are supported.
  Offloading a per cpu array from guest to host doesn't make sense.

Program offload:
- In general the verifier in the guest replaces map fds in the user
  submitted programs with map pointers then bpf_prog_offload_ops
  callbacks are called.

- This set introduces new program offload callback 'setup()' which
  verifier calls before replacing map fds with map pointers. This way
  virtio_net can create a copy of the program with guest map fds. It
  was needed because virtio_net wants to derive driver specific map
  data from guest map fd. Then guest map fd will be replaced with
  host map fd in the copy of the program, hence the copy of the
  program which will be submitted to the host will have valid host map
  fds.

- Alternatively if we can move the prep() call in the verifier before
  map fd replacement happens, there is not need to introduce 'setup()'
  callback.

- As per current implementation of 'setup()' callback in virtio_net,
  it verifies full program for allowed helper functions and performs
  above mentioned map fd replacement.

- A list of allowed helper function is maintained and it is currently
  experimental, it will be updated later as per need. Using this
  list we can filter out most non-XDP type programs to some extent.
  Also we prevent the guest from collecting host specific information
  by not allowing some helper calls.

- XDP_PROG_SETUP_HW is called after successful program verification.
  In this call a control buffer is prepared, program instructions are
  appended to the buffer and it is sent to qemu.

tun
===
This set makes changes in tun to run XDP prog in Tx path. It will be
the offloaded program from the guest. This program can be set using
tun ioctl interface. There were multiple places where this program can
be executed.
- tun_net_xmit
- tun_xdp_xmit
- tun_recvmsg
tun_recvmsg was chosen because it runs in process context. The other
two run in bh context. Running in process context helps in setting up
service chaining using XDP redirect.

XDP_REDIRECT action of offloaded program isn't handled. It is because
target interface's ndo_xdp_xmit is called when we redirect a packet.
In offload case the target interface will be some tap interface. Any
packet redirected towards it will sent back to the guest, which is not
what we expect. Such redirect will need special handling in the kernel

XDP_TX action of offloaded program is handled. Packet is injected into
the Rx path in this case. Care is taken such that the tap's native Rx
path XDP will be executed in such case.


* Implementation in Qemu

Qemu is modified to handle handle control commands from the guest.
When program offload command is received, it loads the program in the
host OS and attaches program fd to tap device. All the program and map
operations are performed using libbpf APIs.


* Performance numbers

Single flow tests were performed. The diagram below shows the setup.
xdp1 and xdp2 sample programs were modified to use BPF_MAP_TYPE_ARRAY
instead of per cpu array and xdp1_user.c was modified to have hardware
offload parameter.

                     (Rx path XDP to drop      (Tx path XDP.
                      XDP_TX'ed pkts from       Program offloaded
                      tun Tx path XDP)          from virtio_net)
                          XDP_DROP ----------.  XDP_DROP/XDP_TX
                                              \   |
                                    (Case 2)   \  |   XDP_DROP/XDP_TX
 pktgen ---> 10G-NIC === 10G-NIC --- bridge --- tun --- virtio-net
|<------ netns ------>|    |                     ^   |<----guest---->|
                           v                     |
                           '---- XDP_REDIRECT----'
                                  (Case 1)

Case 1: Packets XDP_REDIRECT'ed towards tun.
                        Non-offload        Offload
  xdp1 (XDP_DROP)        2.46 Mpps        12.90 Mpps
  xdp2 (XDP_TX)          1.50 Mpps         7.26 Mpps

Case 2: Packets are not redirected. They pass through the bridge.
                        Non-offload        Offload
  xdp1 (XDP_DROP)        1.03 Mpps         1.01 Mpps
  xdp2 (XDP_TX)          1.10 Mpps         0.99 Mpps

  In case 2, the offload performance is low. In this case the
  producer function is tun_net_xmit. It puts single packet in ptr ring
  and spends most of the time in waking up vhost thread. On the other
  hand, each time when vhost thread wakes up, it calls tun_recvmsg.
  Since Tx path XDP runs in tun_recvmsg, vhost doesn't see any packet.
  It sleeps frequently and producer function most spends more time in
  waking it up. vhost polling improves these numbers but in that case
  non-offload performance also improves and remains higher than the
  offload case. Performance in this case can be improved later in a
  separate work.

Since this set makes changes in virtio_net, tun and vhost_net, it was
necessary to measure the performance difference after applying this
set. Performance numbers are in table below:

   Netperf Test         Before      After      Difference
  UDP_STREAM 18byte     89.43       90.74       +1.46%
  UDP_STREAM 1472byte    6882        7026       +2.09%
  TCP_STREAM             9403        9407       +0.04%
  UDP_RR                13520       13478       -0.31%
  TCP_RR                13120       12918       -1.53%


* Points for improvement (TODO)

- In current implementation, qemu passes host map fd to the guest,
  which means guest is poking host information. It can be avoided by
  moving the map fd replacement task from guest to qemu.

- Currently there is no way on the host side to show whether a tap
  interface has offloaded XDP program attached.

- When sending program and map related control commands from guest to
  host, it will be better if we pass metadata about the program, map.
  For example BTF data.

- In future virtio can have feature bit for offloading capability

- TUNGETFEATURES should have a flag to notify about offloading
  capability

- Submit virtio spec patch to describe XDP offloading feature

- When offloading is enabled, it should be a migration blocker.

- DoS: Offloaded map uses host's memory which is other than what has
  been allocated for the guest. Offloading many maps of large size can
  be one of the DoS strategy. Hence qemu should have parameter to
  limit how many maps guest can offload or how much memory offloaded
  maps use.


* Other dependencies

- Loading a bpf program requires CAP_SYS_ADMIN capability. We tested
  this set by running qemu as root OR adding CAP_SYS_ADMIN to the
  qemu binary. In other cases Qemu doesn't have this capability.
  Alexei's recent work CAP_BPF can be a solution to this problem.
  The CAP_BPF work is still being discussed in the mailing list.

Jason Wang (9):
  bpf: introduce bpf_prog_offload_verifier_setup()
  net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
  net: core: export do_xdp_generic_core()
  tun: set offloaded xdp program
  virtio-net: store xdp_prog in device
  virtio_net: add XDP prog offload infrastructure
  virtio_net: implement XDP prog offload functionality
  bpf: export function __bpf_map_get
  virtio_net: implment XDP map offload functionality

Prashant Bhole (9):
  tuntap: check tun_msg_ctl type at necessary places
  vhost_net: user tap recvmsg api to access ptr ring
  tuntap: remove usage of ptr ring in vhost_net
  tun: run offloaded XDP program in Tx path
  tun: add a way to inject Tx path packet into Rx path
  tun: handle XDP_TX action of offloaded program
  tun: run xdp prog when tun is read from file interface
  virtio_net: use XDP attachment helpers
  virtio_net: restrict bpf helper calls from offloaded program

 drivers/net/tap.c               |  42 ++-
 drivers/net/tun.c               | 257 +++++++++++++--
 drivers/net/virtio_net.c        | 552 +++++++++++++++++++++++++++++---
 drivers/vhost/net.c             |  77 ++---
 include/linux/bpf.h             |   1 +
 include/linux/bpf_verifier.h    |   1 +
 include/linux/if_tap.h          |   5 -
 include/linux/if_tun.h          |  23 +-
 include/linux/netdevice.h       |   2 +
 include/uapi/linux/if_tun.h     |   1 +
 include/uapi/linux/virtio_net.h |  50 +++
 kernel/bpf/offload.c            |  14 +
 kernel/bpf/syscall.c            |   1 +
 kernel/bpf/verifier.c           |   6 +
 net/core/dev.c                  |   8 +-
 15 files changed, 901 insertions(+), 139 deletions(-)

-- 
2.20.1

