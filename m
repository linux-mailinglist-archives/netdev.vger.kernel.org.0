Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA504508F6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfFXKcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:32:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46189 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726716AbfFXKcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:32:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A329822400;
        Mon, 24 Jun 2019 06:32:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Jun 2019 06:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9VvoBlKcAdMXQpWQ7
        ZAfZaVwtAHvKPomomi4EVmFQ9Q=; b=Hau0UU78DXgMMuj28ZhyGrH66TAiqQIv+
        vK4KQz4iEgJ2Ab7wnDf+3iY/pHAuPcGexHvvP2I9d+Lz7MYXJ9isxkqcNTODlVTS
        1BbVO3JURZdoTYObU9HqPS78hySaX5tQ+PzAtkLH7viiKEawZZhoK3jMVahGIYdN
        8Ro02Nsr+EExf9v5fKRsFlKtet5MsT6Prbjj89F9AnnOFz6bY2pGB5RS1mIVvgVR
        zs0PRJeWpwBjIMORUUBRDEEkx521clSPrXb9TCVQ4zxQ8zuOfEvvWM3Kc8qwxkAi
        qLGs/FoYckIKe4c8nGBcFFkcYSYpmN+L/wDoR0J1uGA7ARNZq7mnA==
X-ME-Sender: <xms:0aYQXceUGWMi4tMVZbCFqlktgIjMO5JnDBa0ZQAgEF68TZRM-zDipg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduleefrdegje
    drudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:0aYQXfs-yqjK0L2KhH85GzzyIjBlkSxIz8EXiv1g_gS8iBbvUSiaQQ>
    <xmx:0aYQXWLhLgEbXYOAl1NrsRkJLBF-zceNHWRcxf9NpaPpkxmNlWAjGA>
    <xmx:0aYQXT8VJafIDHfzbEnq8p-l_XqfHcTPGtF86IijMqVLPBKGkIV2Sw>
    <xmx:06YQXRlivLojAAYi9_AEBrLUGTPA8jNrDWKJMveGJ8TQA1DDeEFapQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C4458006C;
        Mon, 24 Jun 2019 06:32:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/3] mlxsw: Thermal and hwmon extensions
Date:   Mon, 24 Jun 2019 13:32:00 +0300
Message-Id: <20190624103203.22090-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset from Vadim includes various enhancements to thermal and
hwmon code in mlxsw.

Patch #1 adds a thermal zone for each inter-connect device (gearbox).
These devices are present in SN3800 systems and code to expose their
temperature via hwmon was added in commit 2e265a8b6c09 ("mlxsw: core:
Extend hwmon interface with inter-connect temperature attributes").

Currently, there are multiple thermal zones in mlxsw and only a few
cooling devices. Patch #2 detects the hottest thermal zone and the
cooling devices are switched to follow its trends. RFC was sent last
month [1].

Patch #3 allows to read and report negative temperature of the sensors
mlxsw exposes via hwmon and thermal subsystems.

v2 (Andrew Lunn):
* In patch #3, replace '%u' with '%d' in mlxsw_hwmon_module_temp_show()

[1] https://patchwork.ozlabs.org/patch/1107161/

Vadim Pasternak (3):
  mlxsw: core: Extend thermal core with per inter-connect device thermal
    zones
  mlxsw: core: Add the hottest thermal zone detection
  mlxsw: core: Add support for negative temperature readout

 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  14 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 208 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  12 +-
 3 files changed, 209 insertions(+), 25 deletions(-)

-- 
2.20.1

