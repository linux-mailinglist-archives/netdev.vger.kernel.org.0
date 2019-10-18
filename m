Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5CDBC94
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436465AbfJRFHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:07:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33919 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405128AbfJRFHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:07:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so3106022pfa.1;
        Thu, 17 Oct 2019 22:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RGvBGcXjMUEtLOONS2cYJkFqbyDRfWGjUI0FogoxSzs=;
        b=krRZll5KQoL5+5eD8ZgXAkv8ihwuZQAffi9pEy+0tcni3ngWqEG+obdg4XY0nrxBd3
         +DxXG0Gy2hjUE+P6/LU9f7DsxMf+Hqo/ziFFrmnxZ6roy+CHcoE2VPz6SNSIBcKeYITj
         pZeF4cRS+5mrqA8pRHqZRqdgAl8LEZTQA6SeHObD9KlO0iZ7N+yc+zAujx2VeqduFuh2
         IGLKLTv1lpiooCsisaFFZcPKFgol+gqMpYRTbTYUaKPDuDtoR6C9L7eOMfnfz9YZQ020
         92uA07+miXMBRhhyBFzAM+vhXWyZRjWCaeFGmwy0Rz7NewcxRJA/3W0kUyRMvzIpfVJE
         vlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RGvBGcXjMUEtLOONS2cYJkFqbyDRfWGjUI0FogoxSzs=;
        b=MSyOyqUp8OgLtRbCGIBgHjJm264WnFpr3b5/Zx8Mw3AV4csYpJA59VtubXMhZnm6z0
         lAS7/b00ECCNIGLeb4UiYKWc4MThbR4OlCf5PzLLz92z/KOUY7jHBvk+U20R4D/ti7Qa
         La9yvnW/LMgjtLbYVQEKrWNM0fQbWxixxiqDBZJqdOXg3KY7q9IELKGVOjQab07Zq0CC
         Cl+5nhjvvwguujoivcH7OlKDHmX+eXBFzIf5Tw4lA3LpC4qlG6o/DPGCXOrPO8E96Efb
         YX/hwtNwObK31+49JH4yfAuc6ab3+LUmqoDtXSmvfCxuzjUgHuyerUF/GtW54+VeWPZc
         vs4w==
X-Gm-Message-State: APjAAAVaqUHJlREU/uu5ScaV/Y2UEnWv9gZWBYtiX7FsR2v/A0EJpo1Z
        UquBZAypBQsA1KrQ4HJcb7aLbfYz
X-Google-Smtp-Source: APXvYqxM9Dp5gJwneAZC+qiE9h7YeLI4GkUxxqwjJHH66dmugw3bLMzybZIrG+B0uPCWVo6J7gvLiA==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr8077975pgm.421.1571371703823;
        Thu, 17 Oct 2019 21:08:23 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:08:23 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Date:   Fri, 18 Oct 2019 13:07:33 +0900
Message-Id: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
to XDP.

* Motivation

The purpose is to speed up flow based network features like TC flower and
nftables by making use of XDP.

I chose flow feature because my current interest is in OVS. OVS uses TC
flower to offload flow tables to hardware, so if TC can offload flows to
XDP, OVS also can be offloaded to XDP.

When TC flower filter is offloaded to XDP, the received packets are
handled by XDP first, and if their protocol or something is not
supported by the eBPF program, the program returns XDP_PASS and packets
are passed to upper layer TC.

The packet processing flow will be like this when this mechanism,
xdp_flow, is used with OVS.

 +-------------+
 | openvswitch |
 |    kmod     |
 +-------------+
        ^
        | if not match in filters (flow key or action not supported by TC)
 +-------------+
 |  TC flower  |
 +-------------+
        ^
        | if not match in flow tables (flow key or action not supported by XDP)
 +-------------+
 |  XDP prog   |
 +-------------+
        ^
        | incoming packets

Of course we can directly use TC flower without OVS to speed up TC.

This is useful especially when the device does not support HW-offload.
Such interfaces include virtual interfaces like veth.


* How to use

It only supports ingress flow block at this point.
Enable the feature via ethtool before binding a device to a flow block.

 $ ethtool -K eth0 flow-offload-xdp on

Then bind a device to a flow block using TC or nftables. An example
commands for TC would be like this.

 $ tc qdisc add dev eth0 clsact
 $ tc filter add dev eth0 ingress protocol ip flower ...

Alternatively, when using OVS, adding qdisc and filters will be
automatically done by setting hw-offload.

 $ ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
 $ systemctl stop openvswitch
 $ tc qdisc del dev eth0 ingress # or reboot
 $ ethtool -K eth0 flow-offload-xdp on
 $ systemctl start openvswitch

NOTE: I have not tested nftables offload. Theoretically it should work.

* Performance

I measured drop rate at veth interface with redirect action from physical
interface (i40e 25G NIC, XXV 710) to veth. The CPU is Xeon Silver 4114
(2.20 GHz).
                                                                 XDP_DROP
                    +------+                        +-------+    +-------+
 pktgen -- wire --> | eth0 | -- TC/OVS redirect --> | veth0 |----| veth1 |
                    +------+   (offloaded to XDP)   +-------+    +-------+

The setup for redirect is done by OVS like this.

 $ ovs-vsctl add-br ovsbr0
 $ ovs-vsctl add-port ovsbr0 eth0
 $ ovs-vsctl add-port ovsbr0 veth0
 $ ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
 $ systemctl stop openvswitch
 $ tc qdisc del dev eth0 ingress
 $ tc qdisc del dev veth0 ingress
 $ ethtool -K eth0 flow-offload-xdp on
 $ ethtool -K veth0 flow-offload-xdp on
 $ systemctl start openvswitch

Tested single core/single flow with 3 kinds of configurations.
(spectre_v2 disabled)
- xdp_flow: hw-offload=true, flow-offload-xdp on
- TC:       hw-offload=true, flow-offload-xdp off (software TC)
- ovs kmod: hw-offload=false

 xdp_flow  TC        ovs kmod
 --------  --------  --------
 5.2 Mpps  1.2 Mpps  1.1 Mpps

So xdp_flow drop rate is roughly 4x-5x faster than software TC or ovs kmod.

OTOH the time to add a flow increases with xdp_flow.

ping latency of first packet when veth1 does XDP_PASS instead of DROP:

 xdp_flow  TC        ovs kmod
 --------  --------  --------
 22ms      6ms       0.6ms

xdp_flow does a lot of work to emulate TC behavior including UMH
transaction and multiple bpf map update from UMH which I think increases
the latency.


* Implementation

xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
bpfilter. The difference is that xdp_flow does not generate the eBPF
program dynamically but a prebuilt program is embedded in UMH. This is
mainly because flow insertion is considerably frequent. If we generate
and load an eBPF program on each insertion of a flow, the latency of the
first packet of ping in above test will incease, which I want to avoid.

                         +----------------------+
                         |    xdp_flow_umh      | load eBPF prog for XDP
                         | (eBPF prog embedded) | update maps for flow tables
                         +----------------------+
                                   ^ |
                           request | v eBPF prog id
 +-----------+  offload  +-----------------------+
 | TC flower | --------> |    xdp_flow kmod      | attach the prog to XDP
 +-----------+           | (flow offload driver) |
                         +-----------------------+

- When ingress/clsact qdisc is created, i.e. a device is bound to a flow
  block, xdp_flow kmod requests xdp_flow_umh to load eBPF prog.
  xdp_flow_umh returns prog id and xdp_flow kmod attach the prog to XDP
  (the reason of attaching XDP from kmod is that rtnl_lock is held here).

- When flower filter is added, xdp_flow kmod requests xdp_flow_umh to
  update maps for flow tables.


* Patches

- patch 1
 Basic framework for xdp_flow kmod and UMH.

- patch 2
 Add prebuilt eBPF program embedded in UMH.

- patch 3, 4, 5
 Attach the prog to XDP in kmod after using the prog id returned from
 UMH.

- patch 6, 7
 Add maps for flow tables and flow table manipulation logic in UMH.

- patch 8
 Implement flow lookup and basic actions in eBPF prog.

- patch 9
 Implement flow manipulation logic, serialize flow key and actions from
 TC flower and make requests to UMH in kmod.

- patch 10
 Add flow-offload-xdp netdev feature and register indr flow block to call
 xdp_flow kmod.

- patch 11, 12
 Add example actions, redirect and vlan_push.

- patch 13
 Add a testcase for xdp_flow.

- patch 14, 15
 These are unrelated patches. They just improve XDP program's
 performance. They are included to demonstrate to what extent xdp_flow
 performance can increase. Without them, drop rate goes down from 5.2Mpps
 to 4.2Mpps. The plan is to send these patches separately before
 drooping RFC tag.


* About OVS AF_XDP netdev

Recently OVS has added AF_XDP netdev type support. This also makes use
of XDP, but in some ways different from this patch set.

- AF_XDP work originally started in order to bring BPF's flexibility to
  OVS, which enables us to upgrade datapath without updating kernel.
  AF_XDP solution uses userland datapath so it achieved its goal.
  xdp_flow will not replace OVS datapath completely, but offload it
  partially just for speed up.

- OVS AF_XDP requires PMD for the best performance so consumes 100% CPU
  as well as using another core for softirq.

- OVS AF_XDP needs packet copy when forwarding packets.

- xdp_flow can be used not only for OVS. It works for direct use of TC
  flower and nftables.


* About alternative userland (ovs-vswitchd etc.) implementation

Maybe a similar logic can be implemented in ovs-vswitchd offload
mechanism, instead of adding code to kernel. I just thought offloading
TC is more generic and allows wider usage with direct TC command.

For example, considering that OVS inserts a flow to kernel only when
flow miss happens in kernel, we can in advance add offloaded flows via
tc filter to avoid flow insertion latency for certain sensitive flows.
TC flower usage without using OVS is also possible.

Also as written above nftables can be offloaded to XDP with this
mechanism as well.

Another way to achieve this from userland is to add notifications in
flow_offload kernel code to inform userspace of flow addition and
deletion events, and listen them by a deamon which in turn loads eBPF
programs, attach them to XDP, and modify eBPF maps. Although this may
open up more use cases, I'm not thinking this is the best solution
because it requires emulation of kernel behavior as an offload engine
but flow related code is heavily changing which is difficult to follow
from out of tree.

* Note

This patch set is based on top of commit 5bc60de50dfe ("selftests: bpf:
Don't try to read files without read permission") on bpf-next, but need
to backport commit 98beb3edeb97 ("samples/bpf: Add a workaround for
asm_inline") from bpf tree to successfully build the module.

* Changes

RFC v2:
 - Use indr block instead of modifying TC core, feedback from Jakub
   Kicinski.
 - Rename tc-offload-xdp to flow-offload-xdp since this works not only
   for TC but also for nftables, as now I use indr flow block.
 - Factor out XDP program validation code in net/core and use it to
   attach a program to XDP from xdp_flow.
 - Use /dev/kmsg instead of syslog.

Any feedback is welcome.
Thanks!

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (15):
  xdp_flow: Add skeleton of XDP based flow offload driver
  xdp_flow: Add skeleton bpf program for XDP
  bpf: Add API to get program from id
  xdp: Export dev_check_xdp and dev_change_xdp
  xdp_flow: Attach bpf prog to XDP in kernel after UMH loaded program
  xdp_flow: Prepare flow tables in bpf
  xdp_flow: Add flow entry insertion/deletion logic in UMH
  xdp_flow: Add flow handling and basic actions in bpf prog
  xdp_flow: Implement flow replacement/deletion logic in xdp_flow kmod
  xdp_flow: Add netdev feature for enabling flow offload to XDP
  xdp_flow: Implement redirect action
  xdp_flow: Implement vlan_push action
  bpf, selftest: Add test for xdp_flow
  i40e: prefetch xdp->data before running XDP prog
  bpf, hashtab: Compare keys in long

 drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +
 include/linux/bpf.h                          |    8 +
 include/linux/netdev_features.h              |    2 +
 include/linux/netdevice.h                    |    4 +
 kernel/bpf/hashtab.c                         |   27 +-
 kernel/bpf/syscall.c                         |   42 +-
 net/Kconfig                                  |    1 +
 net/Makefile                                 |    1 +
 net/core/dev.c                               |  113 ++-
 net/core/ethtool.c                           |    1 +
 net/xdp_flow/.gitignore                      |    1 +
 net/xdp_flow/Kconfig                         |   16 +
 net/xdp_flow/Makefile                        |  112 +++
 net/xdp_flow/msgfmt.h                        |  102 +++
 net/xdp_flow/umh_bpf.h                       |   34 +
 net/xdp_flow/xdp_flow.h                      |   28 +
 net/xdp_flow/xdp_flow_core.c                 |  180 +++++
 net/xdp_flow/xdp_flow_kern_bpf.c             |  358 +++++++++
 net/xdp_flow/xdp_flow_kern_bpf_blob.S        |    7 +
 net/xdp_flow/xdp_flow_kern_mod.c             |  699 +++++++++++++++++
 net/xdp_flow/xdp_flow_umh.c                  | 1043 ++++++++++++++++++++++++++
 net/xdp_flow/xdp_flow_umh_blob.S             |    7 +
 tools/testing/selftests/bpf/Makefile         |    1 +
 tools/testing/selftests/bpf/test_xdp_flow.sh |  106 +++
 24 files changed, 2864 insertions(+), 30 deletions(-)
 create mode 100644 net/xdp_flow/.gitignore
 create mode 100644 net/xdp_flow/Kconfig
 create mode 100644 net/xdp_flow/Makefile
 create mode 100644 net/xdp_flow/msgfmt.h
 create mode 100644 net/xdp_flow/umh_bpf.h
 create mode 100644 net/xdp_flow/xdp_flow.h
 create mode 100644 net/xdp_flow/xdp_flow_core.c
 create mode 100644 net/xdp_flow/xdp_flow_kern_bpf.c
 create mode 100644 net/xdp_flow/xdp_flow_kern_bpf_blob.S
 create mode 100644 net/xdp_flow/xdp_flow_kern_mod.c
 create mode 100644 net/xdp_flow/xdp_flow_umh.c
 create mode 100644 net/xdp_flow/xdp_flow_umh_blob.S
 create mode 100755 tools/testing/selftests/bpf/test_xdp_flow.sh

-- 
1.8.3.1

