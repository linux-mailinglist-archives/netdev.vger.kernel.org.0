Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B2421B74E
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGJN5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:57:54 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:55921 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbgGJN5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:57:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4AFAE58046E;
        Fri, 10 Jul 2020 09:57:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tMF/O+LkZBc+5FK9q
        f9jw+1coazYe/zl8qfCicpT7X4=; b=HJe9qg1cpwsCdTOdUsh5/hcgzgroqBEkE
        ycfICYcyjqkauCOgK9iyIUqCrrywfYjbsPXTet3oPr37pWmZUwM3wbD9nb8AD4Rb
        8mFHcBlsmPLi/+uy4qXadiHcrH60qqEhhUSVQyr+dgiqGxS2k5Rf5rjxeMDJmGiF
        /IkDMxgotN2nARnqO2i5DMD3Qrtl1iycNSr470vGWrXRSREbeqIszipU30ys0EI1
        iRTcj3tpXSzjpr20vux2sPZLtrGfLhv5Z91hWchVm6b+lyzJ6So2C9sEU/YP9dcT
        k+wp+cKOGPfebQgioxyOOvblNjUussLwvKnW2IktV/JDxBX/Fk+oA==
X-ME-Sender: <xms:4HMIX6_3RA7D-DIM9lViGxfGmeRWTqexqR5qn0ckNzrm0mRiQug9Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieeirdduledrudeffeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4HMIX6vLLmmrcJQKu0rcsfO8mlF_4b1CslWbI6AGx1Q2S5MA3JKEyg>
    <xmx:4HMIXwCy7NYFrQ2nrNfnehqL9BCatQXA7PmprUw4pyNEXyhm_Zs2AA>
    <xmx:4HMIXyc2l4dxaTTE8rsfIi3WKkGADic1me7tjlGzlCEFRoZ7HM_3zg>
    <xmx:4XMIX8kYeWPlfEHyrVYOsui1PWxxNSeQ0wvlZCQPRezlsbFLFmf-ZQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5371F328005D;
        Fri, 10 Jul 2020 09:57:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/13] mlxsw: Add support for buffer drops mirroring
Date:   Fri, 10 Jul 2020 16:56:53 +0300
Message-Id: <20200710135706.601409-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

This set offloads the recently introduced qevent infrastructure in TC and
allows mlxsw to support mirroring of packets that were dropped due to
buffer related reasons (e.g., early drops) during forwarding.

Up until now mlxsw only supported mirroring that was either triggered by
per-port triggers (i.e., via matchall) or by the policy engine (i.e.,
via flower). Packets that are dropped due to buffer related reasons are
mirrored using a third type of trigger, a global trigger.

Global triggers are bound once to a mirroring (SPAN) agent and enabled
on a per-{port, TC} basis. This allows users, for example, to request
that only packets that were early dropped on a specific netdev to be
mirrored.

Patch set overview:

Patch #1 extends flow_block_offload and indirect offload structure to pass
a scheduler instead of a netdevice. That is necessary, because binding type
and netdevice are not a unique identifier of the block anymore.

Patches #2-#3 add the required registers to support above mentioned
functionality.

Patches #4-#6 gradually add support for global mirroring triggers.

Patch #7 adds support for enablement of global mirroring triggers.

Patches #8-#11 are cleanups in the flow offload code and shuffle some
code around to make the qevent offload easier.

Patch #12 implements offload of RED early_drop qevent.

Patch #13 extends the RED selftest for offloaded datapath to cover
early_drop qevent.

Amit Cohen (2):
  mlxsw: reg: Add Monitoring Mirror Trigger Enable Register
  mlxsw: reg: Add Monitoring Port Analyzer Global Register

Ido Schimmel (4):
  mlxsw: spectrum_span: Move SPAN operations out of global file
  mlxsw: spectrum_span: Prepare for global mirroring triggers
  mlxsw: spectrum_span: Add support for global mirroring triggers
  mlxsw: spectrum_span: Add APIs to enable / disable global mirroring
    triggers

Petr Machata (7):
  net: sched: Pass qdisc reference in struct flow_block_offload
  mlxsw: spectrum_flow: Convert a goto to a return
  mlxsw: spectrum_flow: Drop an unused field
  mlxsw: spectrum_matchall: Publish matchall data structures
  mlxsw: spectrum_flow: Promote binder-type dispatch to spectrum.c
  mlxsw: spectrum_qdisc: Offload mirroring on RED qevent early_drop
  selftests: mlxsw: RED: Test offload of mirror on RED early_drop qevent

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  11 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 102 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  65 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  33 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |  18 +-
 .../mellanox/mlxsw/spectrum_matchall.c        |  23 -
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 472 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 397 ++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  16 +
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  11 +-
 include/net/flow_offload.h                    |   9 +-
 net/core/flow_offload.c                       |  12 +-
 net/netfilter/nf_flow_table_offload.c         |  17 +-
 net/netfilter/nf_tables_offload.c             |  20 +-
 net/sched/cls_api.c                           |  21 +-
 .../drivers/net/mlxsw/sch_red_core.sh         | 106 +++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 +
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 +
 20 files changed, 1204 insertions(+), 161 deletions(-)

-- 
2.26.2

