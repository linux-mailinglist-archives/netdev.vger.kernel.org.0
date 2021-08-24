Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B081E3F5EA3
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhHXNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58407 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237158AbhHXNGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:19 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id E6FB9580B1E;
        Tue, 24 Aug 2021 09:05:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 24 Aug 2021 09:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4ZTXSdqmI6SNWgKRs
        jS3QaMxl9cnr+43pp92411Vl9Q=; b=rbjQIkdbnqCo4NuiBgcIHzSB+0XiUKEmA
        p27FnIQKDyZtw7Q89BKPH4KvxqSl50jA8xdw3hB/qvxZHrIdikU6UPjp02XEkPZr
        26VNOvdOpTnXeCR1I3lzILitgOw1Yd32loUhwJX3ruazbpwJOuni8nHKn0xeleRu
        DQZfjWNjbDhDe5+nntoks3+pNW5pZ6Hw2MRVHXH8HZsY3uNtBREJPBeM6jl1tDYX
        OjgMgkgUcL8m6wVLibYVvz7WS6v42EAHZvb8tBLH+/Skl91n+6NharzNgrUr3GvC
        RLTpDkbRL6Rdz9BkYUltngRR2ZnE0ZNTynPKJJ+Z9u240laKDap5g==
X-ME-Sender: <xms:ne4kYVEGx2ngN5wKe1synTsiwlUf4U0qJEmihDMUMdJKX5GKIoX2vw>
    <xme:ne4kYaWSDDLN8NQkm_LuDapK835PC76QTReU0q_lQC68uT-WYq-p1qVVKsSMwbCS3
    OGIQ4DyBu7TI0A>
X-ME-Received: <xmr:ne4kYXIGl9jsdmEhmesrjMd2jK24pEicFgqTwH1MDYhAYElUzaXjbt-LW2J1J3CgoxPCeYgd9LzsJ2CpweunFg5MZ5U2yNYLOunocnWge48lXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ne4kYbGWE_pgEAN8fPPH3ZsAwzcIwFA_hA4QTBkGll_W_1Anlltv9g>
    <xmx:ne4kYbXzKblEf__FrOUpn1DdwBJogaqfxIu3dJxYo-1eh_Q0gcP5SQ>
    <xmx:ne4kYWP-k6k-41LFQDbd6dwRn5M8OyDeKV29MgxQ06Cu50AqzIfxXQ>
    <xmx:nu4kYXpvvA8l-PqVr7GQNJmUMfw1HH5yJAZ9N-4HzW1TqB_-LCAGLg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 0/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Tue, 24 Aug 2021 16:05:09 +0300
Message-Id: <20210824130515.1828270-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 updates the UAPI headers.

Patch #2 adds the actual implementation that allows user space to
control transceiver modules' power mode. See the commit message for
example output.

Patches #3-#5 parse more fields from SFF-8636 and CMIS EEPROMs to
provide better observability regarding the power mode of the modules.

Patch #6 adds support for two new extended link states in order to allow
user space to troubleshoot link down issues related to transceiver
modules. See the commit message for example output.

Ido Schimmel (6):
  Update UAPI header copies
  ethtool: Add ability to control transceiver modules' power mode
  ethtool: Print CMIS Module State
  ethtool: Print CMIS Module-Level Controls
  ethtool: Print SFF-8636 Power set and Power override bits
  ethtool: Add transceiver module extended states

 Makefile.am                   |   2 +-
 cmis.c                        |  87 +++++++++++++++++
 cmis.h                        |  20 ++++
 ethtool.8.in                  |  25 +++++
 ethtool.c                     |  11 +++
 netlink/desc-ethtool.c        |  11 +++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 179 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 netlink/settings.c            |  12 +++
 qsfp.c                        |   6 ++
 qsfp.h                        |   2 +-
 shell-completion/bash/ethtool |  23 +++++
 uapi/linux/ethtool.h          |  36 ++++++-
 uapi/linux/ethtool_netlink.h  |  34 ++++++-
 uapi/linux/if_link.h          |  21 ++++
 uapi/linux/net_tstamp.h       |  17 +++-
 uapi/linux/netlink.h          |   5 +-
 19 files changed, 491 insertions(+), 9 deletions(-)
 create mode 100644 netlink/module.c

-- 
2.31.1

