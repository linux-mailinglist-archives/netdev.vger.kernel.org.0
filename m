Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CAC6B27B3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjCIOsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjCIOro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:47:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FEBB7D99
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678373075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A52NVJlZDCRq2l5D8bTwwGFD4O5qB9sY2IceZIxy6cc=;
        b=dO1zm72IEsjUmmiG1Nq+ob6l+Xa1KcRK8JqvsMTMvxAAubP2FXva0WBqBmaBBTcO/53gc8
        Ccp+SJzeHKmsy/9DKwi2URor3Y5VHHdPcROIzLy52U/ji02RXkBVvzb6BEeX7t7HqkIG5B
        Uzi4Ym6WKfk0Z9p5mAIOkWFfxGow5f8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-Ny80rhRvNmqXDhQU1h_QkA-1; Thu, 09 Mar 2023 09:44:23 -0500
X-MC-Unique: Ny80rhRvNmqXDhQU1h_QkA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 382791C189A9;
        Thu,  9 Mar 2023 14:44:03 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 039B1492C3E;
        Thu,  9 Mar 2023 14:44:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.3-rc2
Date:   Thu,  9 Mar 2023 15:43:49 +0100
Message-Id: <20230309144349.52317-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

The following changes since commit 5ca26d6039a6b42341f7f5cc8d10d30ca1561a7b:

  Merge tag 'net-6.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-27 14:05:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc2

for you to fetch changes up to 67eeadf2f95326f6344adacb70c880bf2ccff57b:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2023-03-09 11:45:08 +0100)

----------------------------------------------------------------
Networking fixes for 6.3-rc2, including fixes from netfilter, bpf

Current release - regressions:

  - core: avoid skb end_offset change in __skb_unclone_keeptruesize()

  - sched:
    - act_connmark: handle errno on tcf_idr_check_alloc
    - flower: fix fl_change() error recovery path

  - ieee802154: prevent user from crashing the host

Current release - new code bugs:

  - eth: bnxt_en: fix the double free during device removal

  - tools: ynl:
    - fix enum-as-flags in the generic CLI
    - fully inherit attrs in subsets
    - re-license uniformly under GPL-2.0 or BSD-3-clause

Previous releases - regressions:

  - core: use indirect calls helpers for sk_exit_memory_pressure()

  - tls:
    - fix return value for async crypto
    - avoid hanging tasks on the tx_lock

  - eth: ice: copy last block omitted in ice_get_module_eeprom()

Previous releases - always broken:

  - core: avoid double iput when sock_alloc_file fails

  - af_unix: fix struct pid leaks in OOB support

  - tls:
    - fix possible race condition
    - fix device-offloaded sendpage straddling records

  - bpf:
    - sockmap: fix an infinite loop error
    - test_run: fix &xdp_frame misplacement for LIVE_FRAMES
    - fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

  - netfilter: tproxy: fix deadlock due to missing BH disable

  - phylib: get rid of unnecessary locking

  - eth: bgmac: fix *initial* chip reset to support BCM5358

  - eth: nfp: fix csum for ipsec offload

  - eth: mtk_eth_soc: fix RX data corruption issue

Misc:

  - usb: qmi_wwan: add telit 0x1080 composition

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (1):
      bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Arnd Bergmann (1):
      ethernet: ice: avoid gcc-9 integer overflow warning

Bagas Sanjaya (3):
      bpf, docs: Fix link to BTF doc
      bpf, doc: Do not link to docs.kernel.org for kselftest link
      bpf, doc: Link to submitting-patches.rst for general patch submission info

Brian Vazquez (1):
      net: use indirect calls helpers for sk_exit_memory_pressure()

D. Wythe (1):
      net/smc: fix fallback failed while sendmsg with fastopen

Dan Carpenter (1):
      net: phy: unlock on error in phy_probe()

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix RX data corruption issue

Daniel Machon (1):
      net: microchip: sparx5: fix deletion of existing DSCP mappings

Dave Ertman (1):
      ice: Fix DSCP PFC TLV creation

David S. Miller (2):
      Merge branch 'net-tools-ynl-fixes'
      Merge branch 'nfp-ipsec-csum'

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Dumazet (5):
      net: avoid skb end_offset change in __skb_unclone_keeptruesize()
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
      net/sched: flower: fix fl_change() error recovery path
      netfilter: conntrack: adopt safer max chain length
      af_unix: fix struct pid leaks in OOB support

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Hangyu Hua (1):
      net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Heiner Kallweit (1):
      net: phy: smsc: fix link up detection in forced irq mode

Horatiu Vultur (1):
      net: lan966x: Fix port police support using tc-matchall

Huanhuan Wang (3):
      nfp: fix incorrectly set csum flag for nfd3 path
      nfp: fix incorrectly set csum flag for nfdk path
      nfp: fix esp-tx-csum-offload doesn't take effect

Ivan Delalande (1):
      netfilter: ctnetlink: revert to dumping mark regardless of event type

Jakub Kicinski (15):
      Merge branch 'freescale-t1040rdb-dts-updates'
      tls: rx: fix return value for async crypto
      net: tls: avoid hanging tasks on the tx_lock
      Merge tag 'ieee802154-for-net-2023-03-02' of git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan
      tools: ynl: fully inherit attrs in subsets
      tools: ynl: use 1 as the default for first entry in attrs/ops
      netlink: specs: update for codegen enumerating from 1
      net: tls: fix device-offloaded sendpage straddling records
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      mailmap: add entry for Maxim Mikityanskiy
      ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause
      eth: fealnx: bring back this old driver
      tools: ynl: move the enum classes to shared code
      tools: ynl: fix enum-as-flags in the generic CLI
      Merge branch 'tools-ynl-fix-enum-as-flags-in-the-generic-cli'

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Liu Jian (1):
      bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Lorenz Bauer (2):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR
      selftests/bpf: check that modifier resolves after pointer

Martin KaFai Lau (1):
      Merge branch 'fix resolving VAR after DATASEC'

Michael Chan (1):
      bnxt_en: Avoid order-5 memory allocation for TPA data

Michal Swiatkowski (1):
      ice: don't ignore return codes in VSI related code

Miquel Raynal (1):
      ieee802154: Prevent user from crashing the host

Pablo Neira Ayuso (2):
      netfilter: nft_last: copy content when cloning expression
      netfilter: nft_quota: copy content when cloning expression

Paolo Abeni (3):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Pedro Tammela (1):
      net/sched: act_connmark: handle errno on tcf_idr_check_alloc

Petr Oros (1):
      ice: copy last block omitted in ice_get_module_eeprom()

Rafał Miłecki (1):
      bgmac: fix *initial* chip reset to support BCM5358

Randy Dunlap (1):
      riscv, bpf: Fix patch_text implicit declaration

Rongguang Wei (1):
      net: stmmac: add to set device wake up flag when stmmac init phy

Russell King (Oracle) (1):
      net: phylib: get rid of unnecessary locking

Selvin Xavier (1):
      bnxt_en: Fix the double free during device removal

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Stephen Hemminger (1):
      mailmap: update entries for Stephen Hemminger

Suman Ghosh (1):
      octeontx2-af: Unlock contexts in the queue context cache in case of fault detection

Thadeu Lima de Souza Cascardo (1):
      net: avoid double iput when sock_alloc_file fails

Vladimir Oltean (3):
      powerpc: dts: t1040rdb: fix compatible string for Rev A boards
      powerpc: dts: t1040rdb: enable both CPU ports
      net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC

Yuiko Oshino (1):
      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

 .mailmap                                           |    7 +-
 Documentation/bpf/bpf_devel_QA.rst                 |   14 +-
 Documentation/netlink/genetlink-c.yaml             |    2 +-
 Documentation/netlink/genetlink-legacy.yaml        |    2 +-
 Documentation/netlink/genetlink.yaml               |    2 +-
 Documentation/netlink/specs/ethtool.yaml           |   17 +-
 Documentation/netlink/specs/fou.yaml               |    4 +
 Documentation/netlink/specs/netdev.yaml            |    4 +-
 Documentation/userspace-api/netlink/specs.rst      |   13 +-
 arch/mips/configs/mtx1_defconfig                   |    1 +
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts       |    1 -
 arch/powerpc/boot/dts/fsl/t1040rdb.dts             |    5 +-
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi        |    2 +
 arch/powerpc/configs/ppc6xx_defconfig              |    1 +
 arch/riscv/net/bpf_jit_comp64.c                    |    1 +
 drivers/net/dsa/mt7530.c                           |   35 +-
 drivers/net/ethernet/Kconfig                       |   10 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/broadcom/bgmac.c              |    8 +-
 drivers/net/ethernet/broadcom/bgmac.h              |    2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   25 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |    2 +
 drivers/net/ethernet/fealnx.c                      | 1953 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb.c           |    2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |    6 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   17 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |    8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    7 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |   58 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |    3 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |    1 +
 .../ethernet/microchip/lan966x/lan966x_police.c    |    2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c |   32 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       |    7 +-
 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c    |   25 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |    6 +-
 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c    |    8 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    1 +
 drivers/net/ieee802154/ca8210.c                    |    2 +
 drivers/net/phy/microchip.c                        |   32 +
 drivers/net/phy/phy_device.c                       |   10 +-
 drivers/net/phy/smsc.c                             |   14 +-
 drivers/net/usb/cdc_mbim.c                         |    5 +
 drivers/net/usb/lan78xx.c                          |   27 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/nfc/fdp/i2c.c                              |    4 +
 include/net/netfilter/nf_tproxy.h                  |    7 +
 include/uapi/linux/fou.h                           |    2 +-
 include/uapi/linux/netdev.h                        |    2 +-
 kernel/bpf/btf.c                                   |    1 +
 net/bpf/test_run.c                                 |   19 +-
 net/caif/caif_usb.c                                |    3 +
 net/core/netdev-genl-gen.c                         |    2 +-
 net/core/netdev-genl-gen.h                         |    2 +-
 net/core/skbuff.c                                  |   31 +-
 net/core/sock.c                                    |    3 +-
 net/ieee802154/nl802154.c                          |    2 +-
 net/ipv4/fou_nl.c                                  |    2 +-
 net/ipv4/fou_nl.h                                  |    2 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |    2 +-
 net/ipv4/tcp_bpf.c                                 |    6 +
 net/ipv4/udp_bpf.c                                 |    3 +
 net/ipv6/ila/ila_xlat.c                            |    1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |    2 +-
 net/netfilter/nf_conntrack_core.c                  |    4 +-
 net/netfilter/nf_conntrack_netlink.c               |   14 +-
 net/netfilter/nft_last.c                           |    4 +
 net/netfilter/nft_quota.c                          |    6 +-
 net/nfc/netlink.c                                  |    2 +-
 net/sched/act_connmark.c                           |    3 +
 net/sched/cls_flower.c                             |   10 +-
 net/smc/af_smc.c                                   |   13 +-
 net/socket.c                                       |   11 +-
 net/tls/tls_device.c                               |    2 +
 net/tls/tls_main.c                                 |   23 +-
 net/tls/tls_sw.c                                   |   28 +-
 net/unix/af_unix.c                                 |   10 +-
 net/unix/unix_bpf.c                                |    3 +
 tools/include/uapi/linux/netdev.h                  |    2 +-
 tools/net/ynl/cli.py                               |    2 +-
 tools/net/ynl/lib/__init__.py                      |    9 +-
 tools/net/ynl/lib/nlspec.py                        |  128 +-
 tools/net/ynl/lib/ynl.py                           |   11 +-
 tools/net/ynl/ynl-gen-c.py                         |  121 +-
 tools/net/ynl/ynl-regen.sh                         |    2 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   28 +
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    7 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |    2 +
 92 files changed, 2599 insertions(+), 356 deletions(-)
 create mode 100644 drivers/net/ethernet/fealnx.c

