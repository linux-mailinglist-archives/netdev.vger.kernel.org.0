Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE53449C035
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiAZAiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiAZAiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77AA9B81074
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E334BC340E5;
        Wed, 26 Jan 2022 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157485;
        bh=h9tANEFAs00mZzAcZuJ1aYuTA3hbnFGpPQ6vnyjY/o8=;
        h=From:To:Cc:Subject:Date:From;
        b=bXSkPQMe4UrAE6FaZFKdzhriHEFNUG2zvos6RM0szuz3rBRpsAGGMj9mmJA9t3W4Y
         9U54uPlBgBi3wVuD4sVQClquNxH0N3/wwcyhkDJ7DB184IZdcRqZTr0n58tbsE0/Bq
         LDdJczOqWHgzLmkmYE88sOOWK69UEJatDHyjEI7E1L2aaWXDJupxKz7z2FHaMETx0g
         k2+l0xmsg5gCdUd0derAvA2ZnvU9INIJ63d5IpVS1meK5IvXnoSoXmI5bpnoGt47KY
         byzS8zu247BfNOMO+gOso7U/O/U24lVPriEXCqTKpMAQgxj/Pd1acJwDT5dHfdjJTb
         SMMoXc+2aD5UQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/6] ethernet: fix some esoteric drivers after netdev->dev_addr constification
Date:   Tue, 25 Jan 2022 16:37:55 -0800
Message-Id: <20220126003801.1736586-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at recent fixes for drivers which don't get included with
allmodconfig builds I thought it's worth grepping for more instances of:

  dev->dev_addr\[.*\] = 

This set contains the fixes.

v2: add last 3 patches which fix drivers for the RiscPC ARM platform.
Thanks to Arnd Bergmann for explaining how to build test that.

Jakub Kicinski (6):
  ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
  ethernet: tundra: don't write directly to netdev->dev_addr
  ethernet: broadcom/sb1250-mac: don't write directly to
    netdev->dev_addr
  ethernet: i825xx: don't write directly to netdev->dev_addr
  ethernet: 8390/etherh: don't write directly to netdev->dev_addr
  ethernet: seeq/ether3: don't write directly to netdev->dev_addr

 drivers/net/ethernet/3com/typhoon.c        |  6 ++--
 drivers/net/ethernet/8390/etherh.c         |  6 ++--
 drivers/net/ethernet/broadcom/sb1250-mac.c |  4 +--
 drivers/net/ethernet/i825xx/ether1.c       |  4 ++-
 drivers/net/ethernet/seeq/ether3.c         |  4 ++-
 drivers/net/ethernet/tundra/tsi108_eth.c   | 35 +++++++++++-----------
 6 files changed, 33 insertions(+), 26 deletions(-)

-- 
2.34.1

