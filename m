Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291FA6BA987
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCOHlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCOHla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:41:30 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DA82A6DF
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=eY/LXrA5gjdPh1os2CR8OKcWcNR
        B8xmkakVZh6vboNk=; b=Jc7llXM/ddsMMNPSVTq91M0nWa/YJEvoIbApFgtPv9C
        8/blkz3c6PTuokJHIAYW4vlgfNCJnTnq1DVzmgxfbjg3MZL/PEzivAf/ShKqr5hX
        YrI37M4JcndXjdJtBfakAZpzUybH2AscrnVoEr53WmSOpzzi+mAMgFlGKCzJPdk0
        =
Received: (qmail 3360657 invoked from network); 15 Mar 2023 08:41:16 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 Mar 2023 08:41:16 +0100
X-UD-Smtp-Session: l3s3148p1@f1EfeOv2HI0ujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH net v2 0/2] net: renesas: set 'mac_managed_pm' at probe time
Date:   Wed, 15 Mar 2023 08:41:13 +0100
Message-Id: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When suspending/resuming an interface which was not up, we saw mdiobus
related PM handling despite 'mac_managed_pm' being set for RAVB/SH_ETH.
Heiner kindly suggested the fix to set this flag at probe time, not at
init/open time. I implemented his suggestion and it works fine on these
two Renesas drivers.

Changes since v1:
* added tag from Michal (thanks!)
* split out patches which are for 'net' only (Thanks, Simon!)


Wolfram Sang (2):
  ravb: avoid PHY being resumed when interface is not up
  sh_eth: avoid PHY being resumed when interface is not up

 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
 drivers/net/ethernet/renesas/sh_eth.c    | 12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

-- 
2.30.2

