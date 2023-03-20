Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773616C0D11
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjCTJVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjCTJVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:21:06 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F184123DA5
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=wHYsXvK6uoJ9eQZQ74HzrijgpuT
        y5EsMMcmd3JB2YQg=; b=F3Y/A1Sd9IsF9wCcZT0tv03+I3XVhNumsH++/Go7/vk
        eYjTxPv9zrf6bijAte0WODKTAMFPV7IN0W/VVgoe5f3BNqbcdobWgxESMxumevyi
        rae3Vh89ms8thX4Q1aeLr9tfDVeBmZ0RIwRtbxuDwBD8Kp1h/LafF0TTarzfbBps
        =
Received: (qmail 860414 invoked from network); 20 Mar 2023 10:20:47 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Mar 2023 10:20:47 +0100
X-UD-Smtp-Session: l3s3148p1@ChP+cFH3Xtwujnuq
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] smsc911x: fix issues when interface is not up yet
Date:   Mon, 20 Mar 2023 10:20:39 +0100
Message-Id: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to upstream commit 7f5ebf5dae42 ("ravb: avoid PHY being resumed
when interface is not up"), here is the fix for SMSC911x (patch 2).
Also, I saw a splat running 'ifconfig' when interface was not up. Patch
1 fixes it. Thank to Geert for a comment on this one.

Patches are based on v6.2-rc3 and tested on a Renesas APE6-EK.

Changes since v1:
* patch 1 is not a revert but a proper fix this time


Wolfram Sang (2):
  smsc911x: only update stats when interface is up
  smsc911x: avoid PHY being resumed when interface is not up

 drivers/net/ethernet/smsc/smsc911x.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

-- 
2.30.2

