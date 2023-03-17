Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2806BF28F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCQUar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCQUaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:30:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5ABC9CAB;
        Fri, 17 Mar 2023 13:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DB0616C1;
        Fri, 17 Mar 2023 20:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C2DC433EF;
        Fri, 17 Mar 2023 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679084963;
        bh=9we5fWO8cVkhd7UCyIsMxQQuZI93G3p6+v2TY2SerNM=;
        h=From:To:Cc:Subject:Date:From;
        b=HIDL2SEC7HCM/VPvRg2iEAvLYHl8r9S57w+6l2+Qcbp4ediC1ZvDTKCeeHIAvWrdZ
         3xOtZVXqaQUeX5KVs0CoGH4+ZsfN3xk1FTV0rHK8XL7B+etX+iWIh8/6b1lrrG1nn1
         +Fs166iYeBAO+RNT8FqGmIfxw92G0qUXl29SDQ/0NzJ407InA9RmadJtgbATmFZTVc
         Kr0WwWZu4wuBi88jieuAsRNV54ab1SlufA6QSs8VQ0ltd8Oqg9AxIbUaasJ2rvvYxa
         K2g6oDSmPOFFj762kPA4/E1lyb5UVPbPJneAk6Dw3pYzgAlc9iDWBsgVT92zj8F62W
         yuZtp0WyzFTRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL v2] Networking for v6.3-rc3
Date:   Fri, 17 Mar 2023 13:29:22 -0700
Message-Id: <20230317202922.2240017-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Here we go again..

A little more changes than usual, but it's pretty normal for us
that the rc3/rc4 PRs are oversized as people start testing in
earnest. Possibly an extra boost from people deploying the 6.1 LTS
but that's more of an unscientific hunch.

The following changes since commit f5e305e63b035a1782a666a6535765f80bb2dca3:

  Merge branch 'bonding-fixes' (2023-03-17 07:56:41 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3

for you to fetch changes up to f5e305e63b035a1782a666a6535765f80bb2dca3:

  Merge branch 'bonding-fixes' (2023-03-17 07:56:41 +0000)

----------------------------------------------------------------
Including fixes from netfilter, wifi and ipsec.

Current release - regressions:

 - phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()

 - virtio: vsock: don't use skbuff state to account credit

 - virtio: vsock: don't drop skbuff on copy failure

 - virtio_net: fix page_to_skb() miscalculating the memory size

Current release - new code bugs:

 - eth: correct xdp_features after device reconfig

 - wifi: nl80211: fix the puncturing bitmap policy

 - net/mlx5e: flower:
   - fix raw counter initialization
   - fix missing error code
   - fix cloned flow attribute

 - ipa:
   - fix some register validity checks
   - fix a surprising number of bad offsets
   - kill FILT_ROUT_CACHE_CFG IPA register

Previous releases - regressions:

 - tcp: fix bind() conflict check for dual-stack wildcard address

 - veth: fix use after free in XDP_REDIRECT when skb headroom is small

 - ipv4: fix incorrect table ID in IOCTL path

 - ipvlan: make skb->skb_iif track skb->dev for l3s mode

 - mptcp:
  - fix possible deadlock in subflow_error_report
  - fix UaFs when destroying unaccepted and listening sockets

 - dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Previous releases - always broken:

 - tcp: tcp_make_synack() can be called from process context,
   don't assume preemption is disabled when updating stats

 - netfilter: correct length for loading protocol registers

 - virtio_net: add checking sq is full inside xdp xmit

 - bonding: restore IFF_MASTER/SLAVE flags on bond enslave
   Ethertype change

 - phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit number

 - eth: i40e: fix crash during reboot when adapter is in recovery mode

 - eth: ice: avoid deadlock on rtnl lock when auxiliary device
   plug/unplug meets bonding

 - dsa: mt7530:
   - remove now incorrect comment regarding port 5
   - set PLL frequency and trgmii only when trgmii is used

 - eth: mtk_eth_soc: reset PCS state when changing interface types

Misc:

 - ynl: another license adjustment

 - move the TCA_EXT_WARN_MSG attribute for tc action

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
