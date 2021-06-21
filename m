Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA393AE45F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFUHxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:53:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45135 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhFUHxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:53:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 904AD5C00D8;
        Mon, 21 Jun 2021 03:51:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 03:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XltbRsrFCj2oWqGcR
        ZvKzXwy1qC0uwFNLsIAVJOQ7do=; b=GujKx8KOuN4hZ01vIFkCJpTPSk3tHzNzT
        ReLjL9xzcS2Ji05+7OGW51XQ0UzP99eJrAKsbSAND5WPBvInJVk++hTgYPqpLXnw
        UDiKarkyjP3b0FL+3Na55OJtwn9U1LQIMKDNRGrgKRb79KFpXlmg8cow5/yLJ9Hc
        2Jp/mI777tAiI4bKGObtLjMIQvKsb/QiOhQN2BF4nS9m5UAYtG588wchMZlmjXgD
        ESYUf9y9zpoTCsJNNz0NLdLVKWfc3pAC6R1I85TJNb3bkyizfftOej8pVPMnPGSx
        rlmVT10yrf4CJONvC00jVlAjMIg6mkRA/Eq/aITWqtwNBv24Uyh3g==
X-ME-Sender: <xms:BUXQYH678s9pPR5HMirHYdtQLgu51FZno0yYpaCSBYKfe6avxlBInQ>
    <xme:BUXQYM4k6wJKUYSiMB-OUB0cquEnPwonjhPQEe88zX5gSi1QGZjHOABTkH5WLiOkr
    QVKW8eIz0lGvCU>
X-ME-Received: <xmr:BUXQYOcXeArGoLNjXvDtgCaW8DZdZzGrMq1aK6UFeCCSUGpLHW4BXT_9LrysTMXizGIrnmzU0OfunQdeyW9ZZDKQZSJidjwAIfbcM41LD7hYWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefkedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BUXQYIIjc_p1Ab-n3pS4IjiyDW0TQDnyAZYYYdvFfLwTHqetyCIuyw>
    <xmx:BUXQYLKuCMkkiF6SD-9jsF75XUrHmLPXlzRJ_2nVVCa3QFzmzq-NbQ>
    <xmx:BUXQYBzqpE5xDcO11MrsqJgiGAJwrjIyUHhyvFmOj9yD3DGH98z6BQ>
    <xmx:BUXQYIGy8i4pTrFLlCSOFS-IBHyWPj6kYy_2txwwCPhOIm7hCFVSqw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 03:51:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Add support for module EEPROM read by page
Date:   Mon, 21 Jun 2021 10:50:38 +0300
Message-Id: <20210621075041.2502416-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for ethtool_ops::get_module_eeprom_by_page() operation.

Patch #1 adds necessary field in device register.

Patch #2 documents possible MCIA status values so that more meaningful
error messages could be returned to user space via extack.

Patch #3 adds the actual implementation.

Ido Schimmel (3):
  mlxsw: reg: Add bank number to MCIA register
  mlxsw: reg: Document possible MCIA status values
  mlxsw: core: Add support for module EEPROM read by page

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 74 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  7 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 13 ++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 20 +++++
 .../mellanox/mlxsw/spectrum_ethtool.c         | 14 ++++
 5 files changed, 128 insertions(+)

-- 
2.31.1

