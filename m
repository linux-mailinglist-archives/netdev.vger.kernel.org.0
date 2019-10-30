Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A13E993A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfJ3JfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:35:04 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50225 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfJ3JfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:35:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5463D21E5B;
        Wed, 30 Oct 2019 05:35:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=whu+Krgh+FAsYJhf5
        eLnu8VVGVyY6ANdMKYZYHI3AfE=; b=YUHRgTrGmsU+fFL7zd+2TasgwQK0IPPG7
        DqZa3CzJmAYkbIyVofi9kcwJiBoyF8JtutqQb0gAbMe/AlELJa82otMbYH1agskf
        UUtIEoGNopTF5xJ7v4WFRZ3gWiP9f9MCTDrvsGpmEhjga6LGAE/Xs8pUrV/j7DC0
        RG3qLdghYBPLgUpyxoNlTc95A4GVSblQEy0uH62TE0bC6oVp6sJyHxyAaLYkjYLu
        vg5umKYXa8bn7hB7yXgZaxf+5PrQfm9fNGwWuBGhiObNR5EmztLmfD9v5Y12vaxV
        UWaXXP1s/YkDZQACW1YIlmUq0B49GwC/FckQkIGtSNBvipKcSvk6g==
X-ME-Sender: <xms:R1m5XXAI_tGUT3M8fpLXizPY6Bxh3j2xWghTc3fF2GQD24jgjNvhwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:R1m5XbxncmNqSn5SBOuK5dsn1ZCPgYIipV2v0Mecs42BUhUItV-xNw>
    <xmx:R1m5XbsKAmn2TbqkbXx6dmrTRE3Xn37V0G8kE_WA81Yu8b2K_jfl8Q>
    <xmx:R1m5Xa-9eydioGGtdJgy9d22ny5E4m5JxWPCySFRQZt46lUupakxUg>
    <xmx:R1m5XZNcn5aAKPoGFlsurtmypYbTsn2ZooaBi4F803SBk80u73STFQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1ADC6306005B;
        Wed, 30 Oct 2019 05:35:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/4] mlxsw: Update firmware version
Date:   Wed, 30 Oct 2019 11:34:47 +0200
Message-Id: <20191030093451.26325-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set updates the firmware version for Spectrum-1 and enforces
a firmware version for Spectrum-2.

The version adds support for querying port module type. It will be used
by a followup patch set from Jiri to make port split code more generic.

Patch #1 increases the size of an existing register in order to be
compatible with the new firmware version. In the future the firmware
will assign default values to fields not specified by the driver.

Patch #2 temporarily increases the PCI reset timeout for SN3800 systems.
Note that in normal cases the driver will need to wait no longer than 5
seconds for the device to become ready following reset command.

Patch #3 bumps the firmware version for Spectrum-1.

Patch #4 enforces a minimum firmware version for Spectrum-2.

v2:
* Added patch #2

Ido Schimmel (4):
  mlxsw: reg: Increase size of MPAR register
  mlxsw: pci: Increase PCI reset timeout for SN3800 systems
  mlxsw: Bump firmware version to 13.2000.2308
  mlxsw: Enforce firmware version for Spectrum-2

 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 20 ++++++++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.21.0

