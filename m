Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668CE2FEB3D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbhAUNNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:13:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47213 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731628AbhAUNMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:12:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BD3F25C0070;
        Thu, 21 Jan 2021 08:11:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 21 Jan 2021 08:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RuvE8+BS5f0IXZL0q
        qYDisBeK67D9E1EKo+IQ4J3RKE=; b=IkHfUUseZmk5bhOuRtJ5I4U3B/Q0KFD8l
        EF9WbzMWWwcN4jTW3Idg5fWp1scEyEHW5F+OJLKOf1VITLC291JwR2rrnNUYpNxm
        d5M5ElxGS7SNocFTc/c0H4Uxey/RIrZ5KMbmIjVzaxdKQO/XPjxgJ/byvJyyaTKW
        vKGhPsphdVNWi7Ck6fjT2ePYAUQJl5OZtsid0cq83bol4fH1/fQlriG24I4nqlcc
        JmfMf7LpOqvtffYazOyRlq485zAYA7Js8tIGkspLfyYDL5qXtfjkSoJ35D0HeOgQ
        1mtACCbjc7K5jUs08axYbSLDKaUp3gPrxVdn6osXyqyVvUV7b+NBA==
X-ME-Sender: <xms:Z30JYCaANCrQZnDGpx-AoRyt83Q16XzwAQG45ZKq0AJ2XO3ds31lSw>
    <xme:Z30JYFbQeoLIp9-_TkIPomXCMVDnNS9QfiIeFhIsymS-UYFim8OXbAZR1FD_FusGz
    y_w0-4Im8vWr-o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Z30JYM9QIICDHwxOZMmRWyKj1W-KXXlsrnkIltpUav8Jc6Mz0NMHFA>
    <xmx:Z30JYErOE9wq7j2VCgwEC2w1Bf2V2CPxK-Y7cPqvqnbbUq86hS_cFA>
    <xmx:Z30JYNoVQRS2X3-K7Cqp99xR_Y0g0w9eReA6wvDvJeZQBU0ikak_bg>
    <xmx:Z30JYEVM_BulSSjbQz0kaHdns99fhW0xHKAgxRZUTt29PP0TMmGozg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C35B4240062;
        Thu, 21 Jan 2021 08:11:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 0/2] mlxsw: Expose number of physical ports
Date:   Thu, 21 Jan 2021 15:10:22 +0200
Message-Id: <20210121131024.2656154-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The switch ASIC has a limited capacity of physical ports that it can
support. While each system is brought up with a different number of
ports, this number can be increased via splitting up to the ASIC's
limit.

Expose physical ports as a devlink resource so that user space will have
visibility into the maximum number of ports that can be supported and
the current occupancy. With this resource it is possible, for example,
to write generic (i.e., not platform dependent) tests for port
splitting.

Patch #1 adds the new resource and patch #2 adds a selftest.

v2:
* Add the physical ports resource as a generic devlink resource so that
  it could be re-used by other device drivers

Danielle Ratson (2):
  mlxsw: Register physical ports as a devlink resource
  selftests: mlxsw: Add a scale test for physical ports

 .../networking/devlink/devlink-resource.rst   | 14 ++++
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 77 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 include/net/devlink.h                         |  2 +
 net/core/devlink.c                            |  4 +
 .../selftests/drivers/net/mlxsw/port_scale.sh | 64 +++++++++++++++
 .../net/mlxsw/spectrum-2/port_scale.sh        | 16 ++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../drivers/net/mlxsw/spectrum/port_scale.sh  | 16 ++++
 .../net/mlxsw/spectrum/resource_scale.sh      |  2 +-
 11 files changed, 191 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh

-- 
2.29.2

