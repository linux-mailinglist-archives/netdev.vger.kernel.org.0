Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5397521F3C1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgGNOVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48579 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgGNOVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BFB55C00EA;
        Tue, 14 Jul 2020 10:21:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+5Zots4RGA7CKW97r
        QJPZSnFF5NSfAFtsVgBkoMkPdM=; b=JG6UyVRIbmrgW5eCwk8pffOvNIhWT3JSF
        wRRZj334lIqtFm3hEuYLsMD+EH6yM1622jIgh10teGBSZbAkmTK6asB9g+Zy0Ik9
        BtjYOoVKIxvOY3nE9AuOq5pPyp4Si3ulLixFYPIXkPUBXoO3/8rrQolY8S6VmiCL
        PrIFO1nVCCq5VV8GKFum0Bj94rddCPKOLn3bBkuul10HfNCcFJSqeRupFCvl/kgD
        +K57CXdjnuw2mayh+ESCGE84j+UXzGO5TRdxXmOaLmoNocvybj8FHnJASvJsONQL
        9+lQWhHH61y95K6AQAHLGtAUNex+DQwDv4Pz9Lzalys6nrbN4phYQ==
X-ME-Sender: <xms:bL8NX5BJKMpVzcG31SBPbX-iuULouJ8rIMguKYbeMExP0JJXqdOUXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieeirdduledrudeffeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bL8NX3jO9D3ltaL4AS0wufs75nCq1rDM4JvMmf-8CEG7sV2l-g2Ahw>
    <xmx:bL8NX0kRvLD4oITHQAPEfE-yttcrjZtSif-3LM56SntjOVCR_7SoTw>
    <xmx:bL8NXzxeyrkdhpz77uDf6efFhd7wK_PRCgfejvIJZux5iEmrrqW63Q>
    <xmx:bb8NX8eQQSTDZmtRlNQpVj0TTO7bJQ9k2AZkQPyE25U0ixTZFW7ICw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAC3D30653ED;
        Tue, 14 Jul 2020 10:21:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/13] mlxsw: Mirror to CPU preparations
Date:   Tue, 14 Jul 2020 17:20:53 +0300
Message-Id: <20200714142106.386354-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

A future patch set will add the ability to trap packets that were
dropped due to buffer related reasons (e.g., early drop). Internally
this is implemented by mirroring these packets towards the CPU port.
This patch set adds the required infrastructure to enable such
mirroring.

Patches #1-#2 extend two registers needed for above mentioned
functionality.

Patches #3-#6 gradually add support for setting the mirroring target of
a SPAN (mirroring) agent as the CPU port. This is only supported from
Spectrum-2 onwards, so an error is returned for Spectrum-1.

Patches #7-#8 add the ability to set a policer on a SPAN agent. This is
required because unlike regularly trapped packets, a policer cannot be
set on the trap group with which the mirroring trap is associated.

Patches #9-#12 parse the mirror reason field from the Completion Queue
Element (CQE). Unlike other trapped packets, the trap identifier of
mirrored packets only indicates that the packet was mirrored, but not
why. The reason (e.g., tail drop) is encoded in the mirror reason field.

Patch #13 utilizes the mirror reason field in order to lookup the
matching Rx listener. This allows us to maintain the abstraction that an
Rx listener is mapped to a single trap reason. Without taking the mirror
reason into account we would need to register a single Rx listener for
all mirrored packets.

Amit Cohen (3):
  mlxsw: reg: Add session_id and pid to MPAT register
  mlxsw: reg: add mirroring_pid_base to MOGCR register
  mlxsw: reg: Increase trap identifier to 10 bits

Ido Schimmel (10):
  mlxsw: spectrum_span: Add per-ASIC SPAN agent operations
  mlxsw: spectrum_span: Add driver private info to parms_set() callback
  mlxsw: spectrum_span: Do not dereference destination netdev
  mlxsw: spectrum_span: Add support for mirroring towards CPU port
  mlxsw: spectrum_span: Allow passing parameters to SPAN agents
  mlxsw: spectrum_span: Allow setting policer on a SPAN agent
  mlxsw: trap: Add trap identifiers for mirrored packets
  mlxsw: pci: Add mirror reason field to CQEv2
  mlxsw: pci: Retrieve mirror reason from CQE during receive
  mlxsw: core: Use mirror reason during Rx listener lookup

 drivers/net/ethernet/mellanox/mlxsw/core.c    |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  29 +-
 .../mlxsw/spectrum_acl_flex_actions.c         |   4 +-
 .../mellanox/mlxsw/spectrum_matchall.c        |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 257 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  17 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  10 +-
 11 files changed, 318 insertions(+), 31 deletions(-)

-- 
2.26.2

