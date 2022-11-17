Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9DF62DA19
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiKQMBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiKQMBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:01:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC621248E2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668686440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hGfznxLdTqHvriWwWPC6t7xIxiQJbtuQttgGqcBYOwg=;
        b=NZsG3KeCGJLQaxr9FnUg/cklPWfdPfYYGHb9J/xeGSGgx5RD4/s22lDWiJOHYouJ+tcDX7
        ytS7uwskHXNsRTpyjvaIVPrZOmrK8/CdYtVVEaWFqE2ZOBmZWMbEP2OmiV1lWV/iKjTO7k
        l/17IVTi7mvpClCydHFfGx/ESC11oDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-E9U6GZoUOM2z8yVV90MJMQ-1; Thu, 17 Nov 2022 07:00:37 -0500
X-MC-Unique: E9U6GZoUOM2z8yVV90MJMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0183D833AED;
        Thu, 17 Nov 2022 12:00:37 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A47040C6EC3;
        Thu, 17 Nov 2022 12:00:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.1-rc6
Date:   Thu, 17 Nov 2022 13:00:17 +0100
Message-Id: <20221117120017.26184-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

This is mostly NIC drivers related, with a notable tcp change that
introduces a new int config knob. It asks for the user input at
config-time but it's guarded by EXPERT, so I hope it's ok.

No new known outstanding regressions.

The following changes since commit 4bbf3422df78029f03161640dcb1e9d1ed64d1ea:

  Merge tag 'net-6.1-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-11-10 17:31:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc6

for you to fetch changes up to 58e0be1ef6118c5352b56a4d06e974c5599993a5:

  net: use struct_group to copy ip/ipv6 header addresses (2022-11-17 10:42:45 +0100)

----------------------------------------------------------------
Networking fixes for 6.1-rc6, including fixes from bpf

Current release - regressions:

  - tls: fix memory leak in tls_enc_skb() and tls_sw_fallback_init()

Previous releases - regressions:

  - bridge: fix memory leaks when changing VLAN protocol

  - dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims

  - dsa: don't leak tagger-owned storage on switch driver unbind

  - eth: mlxsw: avoid warnings when not offloaded FDB entry with IPv6 is removed

  - eth: stmmac: ensure tx function is not running in stmmac_xdp_release()

  - eth: hns3: fix return value check bug of rx copybreak

Previous releases - always broken:

  - kcm: close race conditions on sk_receive_queue

  - bpf: fix alignment problem in bpf_prog_test_run_skb()

  - bpf: fix writing offset in case of fault in strncpy_from_kernel_nofault

  - eth: macvlan: use built-in RCU list checking

  - eth: marvell: add sleep time after enabling the loopback bit

  - eth: octeon_ep: fix potential memory leak in octep_device_setup()

Misc:

  - tcp: configurable source port perturb table size

  - bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alban Crequy (2):
      maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()
      selftests: bpf: Add a test when bpf_probe_read_kernel_str() returns EFAULT

Alexandru Tachici (1):
      net: usb: smsc95xx: fix external PHY reset

Aminuddin Jamaluddin (1):
      net: phy: marvell: add sleep time after enabling the loopback bit

Amit Cohen (1):
      mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed

Andrii Nakryiko (1):
      Merge branch 'Fix offset when fault occurs in strncpy_from_kernel_nofault()'

Baisong Zhong (1):
      bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Chuang Wang (1):
      net: macvlan: Use built-in RCU list checking

Cong Wang (1):
      kcm: close race conditions on sk_receive_queue

David S. Miller (2):
      Merge branch 'octeon_ep-fixes'
      Merge branch 'microchip-fixes'

Enrico Sau (1):
      net: usb: qmi_wwan: add Telit 0x103a composition

Gaosheng Cui (1):
      bnxt_en: Remove debugfs when pci_register_driver failed

Gleb Mazovetskiy (1):
      tcp: configurable source port perturb table size

Guangbin Huang (1):
      net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process

Hangbin Liu (1):
      net: use struct_group to copy ip/ipv6 header addresses

Ido Schimmel (1):
      bridge: switchdev: Fix memory leaks when changing VLAN protocol

Jaco Coetzee (1):
      nfp: change eeprom length to max length enumerators

Jakub Kicinski (1):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jakub Sitnicki (1):
      l2tp: Serialize access to sk_user_data with sk_callback_lock

Jeremy Kerr (1):
      mctp i2c: don't count unused / invalid keys for flow release

Jian Shen (1):
      net: hns3: fix incorrect hw rss hash type of rx packet

Jie Wang (1):
      net: hns3: fix return value check bug of rx copybreak

Liu Jian (1):
      net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()

Michael Sit Wei Hong (1):
      net: phy: dp83867: Fix SGMII FIFO depth for non OF devices

Mohd Faizal Abdul Rahim (1):
      net: stmmac: ensure tx function is not running in stmmac_xdp_release()

Nathan Chancellor (1):
      bpf: Add explicit cast to 'void *' for __BPF_DISPATCHER_UPDATE()

Paolo Abeni (1):
      Merge branch 'net-hns3-this-series-bugfix-for-the-hns3-ethernet-driver'

Peter Zijlstra (2):
      bpf: Revert ("Fix dispatcher patchable function entry to 5 bytes nop")
      bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

Pu Lehui (1):
      selftests/bpf: Fix casting error when cross-compiling test_verifier for 32-bit platforms

Shang XiaoJing (2):
      net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
      net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()

Vladimir Oltean (2):
      net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
      net: dsa: don't leak tagger-owned storage on switch driver unbind

Wang ShaoBo (1):
      mISDN: fix misuse of put_device() in mISDN_register_device()

Wang Yufen (2):
      bpf: Fix memory leaks in __check_func_call
      netdevsim: Fix memory leak of nsim_dev->fa_cookie

Wei Yongjun (3):
      net: bgmac: Drop free_netdev() from bgmac_enet_remove()
      net: mhi: Fix memory leak in mhi_net_dellink()
      net/x25: Fix skb leak in x25_lapb_receive_frame()

Xu Kuohai (2):
      bpf: Initialize same number of free nodes for each pcpu_freelist
      bpf: Fix offset calculation error in __copy_map_value and zero_map_value

Yang Jihong (1):
      selftests/bpf: Fix test_progs compilation failure in 32-bit arch

Yang Yingliang (1):
      mISDN: fix possible memory leak in mISDN_dsp_element_register()

Yu Liao (1):
      net/tls: Fix memory leak in tls_enc_skb() and tls_sw_fallback_init()

Yuan Can (4):
      net: hinic: Fix error handling in hinic_module_init()
      net: ionic: Fix error handling in ionic_init_module()
      net: ena: Fix error handling in ena_init()
      net: thunderbolt: Fix error handling in tbnet_init()

Zhengchao Shao (2):
      net: liquidio: release resources when liquidio driver open failed
      net: caif: fix double disconnect client in chnl_net_open()

Ziyang Xuan (4):
      octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()
      octeon_ep: ensure octep_get_link_status() successfully before octep_link_up()
      octeon_ep: fix potential memory leak in octep_device_setup()
      octeon_ep: ensure get mac address successfully before eth_hw_addr_set()

 arch/x86/net/bpf_jit_comp.c                        |  13 --
 drivers/isdn/mISDN/core.c                          |   2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   8 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  34 ++++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 -
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.c    |  20 ---
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.h    |   2 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 167 ++++++++++++---------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  11 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   9 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   2 +
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   3 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   6 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
 drivers/net/macvlan.c                              |   4 +-
 drivers/net/mctp/mctp-i2c.c                        |  47 ++++--
 drivers/net/mhi_net.c                              |   2 +
 drivers/net/netdevsim/dev.c                        |   1 +
 drivers/net/phy/dp83867.c                          |   7 +
 drivers/net/phy/marvell.c                          |  16 +-
 drivers/net/thunderbolt.c                          |  19 ++-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/smsc95xx.c                         |  46 +++++-
 include/linux/bpf.h                                |  60 +++++---
 include/net/ip.h                                   |   2 +-
 include/net/ipv6.h                                 |   2 +-
 include/net/sock.h                                 |   2 +-
 include/uapi/linux/ip.h                            |   6 +-
 include/uapi/linux/ipv6.h                          |   6 +-
 kernel/bpf/dispatcher.c                            |  28 +---
 kernel/bpf/percpu_freelist.c                       |  23 ++-
 kernel/bpf/verifier.c                              |  14 +-
 mm/maccess.c                                       |   2 +-
 net/bpf/test_run.c                                 |   1 +
 net/bridge/br_vlan.c                               |  17 ++-
 net/caif/chnl_net.c                                |   3 -
 net/dsa/dsa2.c                                     |  10 ++
 net/dsa/dsa_priv.h                                 |   1 +
 net/dsa/master.c                                   |   3 +-
 net/dsa/port.c                                     |  16 ++
 net/ipv4/Kconfig                                   |  10 ++
 net/ipv4/inet_hashtables.c                         |  10 +-
 net/kcm/kcmsock.c                                  |  58 +------
 net/l2tp/l2tp_core.c                               |  19 ++-
 net/tls/tls_device_fallback.c                      |   5 +-
 net/x25/x25_dev.c                                  |   2 +-
 tools/testing/selftests/bpf/prog_tests/varlen.c    |   7 +
 tools/testing/selftests/bpf/progs/test_varlen.c    |   5 +
 tools/testing/selftests/bpf/test_progs.c           |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 59 files changed, 477 insertions(+), 311 deletions(-)

