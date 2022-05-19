Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AF952CF57
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 11:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiESJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 05:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiESJ0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 05:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BB9726DA
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 02:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652952369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cvEJEFOGq7FC5QM0XFGViek7pYFIKfsja2wlygVxYgI=;
        b=VJTbopv/z/5NmdpgC/95R0+SCnxpRuGGXMP2NaFOk6Om+crkj2AbWd3oYvHTimWNvVjMWN
        hNQMg3up4rj1RMsOK/YBYei+28Vdp9MzIjdbZngAP66uinqaQSQIAo3cGv9sWiayJIsCNo
        hnXBSkGYutlXwl8F1vRy5htfV5uop9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-FgRjF2yYM-aDVCJ5MFyuRw-1; Thu, 19 May 2022 05:26:06 -0400
X-MC-Unique: FgRjF2yYM-aDVCJ5MFyuRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 093A81C0514D;
        Thu, 19 May 2022 09:26:06 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7A7B7AE4;
        Thu, 19 May 2022 09:26:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc8
Date:   Thu, 19 May 2022 11:25:32 +0200
Message-Id: <20220519092532.17746-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit f3f19f939c11925dadd3f4776f99f8c278a7017b:

  Merge tag 'net-5.18-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-12 11:51:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc8

for you to fetch changes up to fbb3abdf2223cd0dfc07de85fe5a43ba7f435bdf:

  net: bridge: Clear offload_fwd_mark when passing frame up bridge interface. (2022-05-19 09:20:44 +0200)

----------------------------------------------------------------
Networking fixes for 5.18-rc8, including fixes from can, xfrm and
netfilter subtrees.

Notably this reverts a recent TCP/DCCP netns-related change
to address a possible UaF.

Current release - regressions:
  - tcp: revert "tcp/dccp: get rid of inet_twsk_purge()"

  - xfrm: set dst dev to blackhole_netdev instead of loopback_dev in ifdown

Previous releases - regressions:
  - netfilter: flowtable: fix TCP flow teardown

  - can: revert "can: m_can: pci: use custom bit timings for Elkhart Lake"

  - xfrm: check encryption module availability consistency

  - eth: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()

  - eth: mlx5: initialize flow steering during driver probe

  - eth: ice: fix crash when writing timestamp on RX rings

Previous releases - always broken:
  - mptcp: fix checksum byte order

  - eth: lan966x: fix assignment of the MAC address

  - eth: mlx5: remove HW-GRO from reported features

  - eth: ftgmac100: disable hardware checksum on AST2600

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alex Elder (3):
      net: ipa: certain dropped packets aren't accounted for
      net: ipa: record proper RX transaction count
      net: ipa: get rid of a duplicate initialization

Andrew Lunn (1):
      net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Arkadiusz Kubalewski (1):
      ice: fix crash when writing timestamp on RX rings

Aya Levin (1):
      net/mlx5e: Block rx-gro-hw feature in switchdev mode

Christophe JAILLET (2):
      net: systemport: Fix an error handling path in bcm_sysport_probe()
      net/qla3xxx: Fix a test in ql_reset_work()

David S. Miller (6):
      Merge branch 'ipa-fixes'
      Merge tag 'linux-can-fixes-for-5.18-20220514' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'mlx5-fixes-2022-05-17' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mptcp-checksums'

Duoming Zhou (1):
      NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Eric Dumazet (1):
      Revert "tcp/dccp: get rid of inet_twsk_purge()"

Eyal Birger (1):
      xfrm: fix "disable_policy" flag use when arriving from different devices

Felix Fietkau (4):
      netfilter: flowtable: fix excessive hw offload attempts after failure
      netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
      net: fix dev_fill_forward_path with pppoe + bridge
      netfilter: nft_flow_offload: fix offload with pppoe + vlan

Gal Pressman (1):
      net/mlx5e: Remove HW-GRO from reported features

Harini Katakam (1):
      net: macb: Increment rx bd head after allocating skb and buffer

Horatiu Vultur (1):
      net: lan966x: Fix assignment of the MAC address

Jakub Kicinski (2):
      Merge branch 'mptcp-subflow-accounting-fix'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jarkko Nikula (2):
      Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
      can: m_can: remove support for custom bit timing, take #2

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Joachim Wiberg (1):
      selftests: forwarding: fix missing backslash

Joel Stanley (1):
      net: ftgmac100: Disable hardware checksum on AST2600

Jonathan Lemon (2):
      ptp: ocp: have adjtime handle negative delta_ns correctly
      ptp: ocp: change sysfs attr group handling

Kevin Mitchell (1):
      igb: skip phy status check where unavailable

Lin Ma (1):
      nfc: pn533: Fix buggy cleanup order

Maor Dickman (1):
      net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table

Mat Martineau (1):
      mptcp: Do TCP fallback on early DSS checksum failure

Maxim Mikityanskiy (3):
      net/mlx5e: Wrap mlx5e_trap_napi_poll into rcu_read_lock
      net/mlx5e: Properly block LRO when XDP is enabled
      net/mlx5e: Properly block HW GRO when XDP is enabled

Michal Wilczynski (1):
      ice: Fix interrupt moderation settings getting cleared

Pablo Neira Ayuso (2):
      netfilter: flowtable: fix TCP flow teardown
      netfilter: nf_tables: disable expression reduction infra

Paolo Abeni (4):
      mptcp: fix subflow accounting on close
      selftests: mptcp: add subflow limits test-cases
      net/sched: act_pedit: sanitize shift argument before usage
      mptcp: fix checksum byte order

Paul Blakey (2):
      net/mlx5e: CT: Fix support for GRE tuples
      net/mlx5e: CT: Fix setting flow_source for smfs ct tuples

Paul Greenwalt (1):
      ice: fix possible under reporting of ethtool Tx and Rx statistics

Ritaro Takenaka (1):
      netfilter: flowtable: move dst_check to packet path

Shay Drory (2):
      net/mlx5: Initialize flow steering during driver probe
      net/mlx5: Drain fw_reset when removing device

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

Xin Long (1):
      xfrm: set dst dev to blackhole_netdev instead of loopback_dev in ifdown

Yevgeny Kliteynik (1):
      net/mlx5: DR, Ignore modify TTL on RX if device doesn't support it

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

 drivers/net/can/m_can/m_can.c                      |  24 +---
 drivers/net/can/m_can/m_can.h                      |   3 -
 drivers/net/can/m_can/m_can_pci.c                  |  48 +-------
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   5 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  16 +--
 drivers/net/ethernet/intel/ice/ice_main.c          |   7 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  19 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  11 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c |  58 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 131 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  25 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  19 ++-
 .../mellanox/mlx5/core/steering/dr_action.c        |  71 +++++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   4 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  28 +++++
 drivers/net/ethernet/qlogic/qla3xxx.c              |   3 +-
 drivers/net/ipa/gsi.c                              |   6 +-
 drivers/net/ipa/ipa_endpoint.c                     |  13 +-
 drivers/net/ipa/ipa_qmi.c                          |   2 +-
 drivers/net/ppp/pppoe.c                            |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +
 drivers/nfc/pn533/pn533.c                          |   5 +-
 drivers/ptp/ptp_ocp.c                              |  62 +++++++---
 include/linux/netdevice.h                          |   2 +-
 include/net/inet_timewait_sock.h                   |   3 +-
 include/net/ip.h                                   |   1 +
 include/net/xfrm.h                                 |  14 ++-
 net/bridge/br_input.c                              |   7 ++
 net/core/dev.c                                     |   2 +-
 net/dccp/ipv4.c                                    |   6 +
 net/dccp/ipv6.c                                    |   6 +
 net/ipv4/inet_timewait_sock.c                      |  58 +++++++--
 net/ipv4/route.c                                   |  23 +++-
 net/ipv4/tcp_ipv4.c                                |   2 +
 net/ipv6/tcp_ipv6.c                                |   6 +
 net/key/af_key.c                                   |  12 +-
 net/mptcp/options.c                                |  36 ++++--
 net/mptcp/pm.c                                     |   5 +-
 net/mptcp/protocol.h                               |  19 ++-
 net/mptcp/subflow.c                                |  35 ++++--
 net/netfilter/nf_flow_table_core.c                 |  60 ++--------
 net/netfilter/nf_flow_table_ip.c                   |  19 +++
 net/netfilter/nf_tables_api.c                      |  11 +-
 net/netfilter/nft_flow_offload.c                   |  28 +++--
 net/nfc/nci/data.c                                 |   2 +-
 net/nfc/nci/hci.c                                  |   4 +-
 net/sched/act_pedit.c                              |   4 +
 net/xfrm/xfrm_policy.c                             |   2 +-
 tools/testing/selftests/net/forwarding/Makefile    |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  48 +++++++-
 61 files changed, 694 insertions(+), 362 deletions(-)

