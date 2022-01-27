Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F6349EA77
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 19:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiA0SnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 13:43:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51306 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiA0SnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 13:43:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20E86CE2260;
        Thu, 27 Jan 2022 18:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35538C340E4;
        Thu, 27 Jan 2022 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643308986;
        bh=FY9zgRxYtEro/TgZiffTeXcSzhxSduXelVGXjXLsfCk=;
        h=From:To:Cc:Subject:Date:From;
        b=WOxwMiFM3EZGNpGvfOPL8Bfzgk/nXQ6FMDq9dBsZVABzUVN9QUoqAt8DVCxANVooa
         nx3qE8mpf3dW0/m+I3UFjCvvFP2iuExSwJZ6CNjThBb4+xIImNNOY6dH+KKCiZaGEh
         O9dkVXa51/ubLy8q14zH1gdD1A1+zAqVI3GsdgF0c/SQFK+Vy0kwSGgYzotFsxazLD
         SKMa4+68HEZaiQ7OD84esTNaALorDOZ+Mt0D2XnxyikcgsXLo7mZFTNaWWH8a53krR
         7mvUCE5UZwMJ2sRLIyemM708ULMnnR7GVaXFr3LMfu8TfLEz8csmHZiHW6eJgHxR6N
         pUHIBYj/rTBrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        idosch@nvidia.com, corbet@lwn.net, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] ethtool: add header/data split indication
Date:   Thu, 27 Jan 2022 10:42:58 -0800
Message-Id: <20220127184300.490747-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP ZC Rx requires data to be placed neatly into pages, separate
from the networking headers. This is not supported by most devices
so to make deployment easy this set adds a way for the driver to
report support for this feature thru ethtool.

The larger scope of configuring splitting headers and data, or DMA
scatter seems dauntingly broad, so this set focuses specifically
on the question "is this device usable with TCP ZC Rx?".

The aim is to avoid a litany of conditions on HW platforms, features,
and firmware versions in orchestration systems when the drivers can
easily tell their SG config.

Jakub Kicinski (2):
  ethtool: add header/data split indication
  bnxt: report header-data split state

 Documentation/networking/ethtool-netlink.rst      |  8 ++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  3 +++
 include/linux/ethtool.h                           |  2 ++
 include/uapi/linux/ethtool_netlink.h              |  7 +++++++
 net/ethtool/rings.c                               | 15 ++++++++++-----
 5 files changed, 30 insertions(+), 5 deletions(-)

-- 
2.34.1

