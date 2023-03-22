Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3186C43F2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCVHUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCVHUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:20:08 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAFA241CA
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 00:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=xKynfpVzCuekaiV7RxtxMztZKWl
        PwE9VXEtc+B6VrOo=; b=DrwXmzBtMCfptDuvA5XW6NFWMFMBQ5gFiNNWNt1EEWw
        nDI8SsxAbPxqrRoXKj7qRJxPIt4OIksjOJRB9YZ5dV5HCBvwbkndQmf9k+2Eotay
        dUKBZfpVPvWVTzORDKLhJiHGZsVC4IG5BWgppajF4GMagmD4xMSsQL518HBB7o/Y
        =
Received: (qmail 1526146 invoked from network); 22 Mar 2023 08:20:00 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 22 Mar 2023 08:20:00 +0100
X-UD-Smtp-Session: l3s3148p1@bQzz/Hf3EJsujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH net v3 0/2] smsc911x: fix issues when interface is not up yet
Date:   Wed, 22 Mar 2023 08:19:57 +0100
Message-Id: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to upstream commit 7f5ebf5dae42 ("ravb: avoid PHY being resumed
when interface is not up"), here is the fix for SMSC911x (patch 2).
Also, I saw a splat running 'ifconfig' when interface was not up. Patch
1 fixes it.

Patches are based on v6.2-rc3 and tested on a Renesas APE6-EK.

Changes since v2:
* added tags for patch 1
* patch 2 has been refactored to be less intrusive for easier
  backporting

Wolfram Sang (2):
  smsc911x: only update stats when interface is up
  smsc911x: avoid PHY being resumed when interface is not up

 drivers/net/ethernet/smsc/smsc911x.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
2.30.2

