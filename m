Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8C6D73C7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 07:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbjDEFcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 01:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDEFcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 01:32:00 -0400
X-Greylist: delayed 337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 22:31:55 PDT
Received: from scadrial.mjdsystems.ca (scadrial.mjdsystems.ca [192.99.73.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1F74224;
        Tue,  4 Apr 2023 22:31:55 -0700 (PDT)
Received: from cwmtaff.localnet (107-190-58-99.cpe.teksavvy.com [107.190.58.99])
        by scadrial.mjdsystems.ca (Postfix) with ESMTPSA id 93FD789917E4;
        Wed,  5 Apr 2023 01:26:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed; d=mjdsystems.ca;
        s=202010; t=1680672377;
        bh=omZ1DvLLEcKZSl6Ky5Bzl01ptknCiOUywQxqAjHSKto=;
        h=From:To:Subject:Date:From;
        b=TxjEQS1nca75C4+zuQ03eBJ2NiEJBI47IiQewhqDnBvSM3T6j9HXdjLpFLhkE1K9l
         U6ehG+0zbOQ1SJCtrIjpSWmylun+tNu7p4FI7Qz6Hd+K4Gd20I1SEXy83mYTlRhmtP
         sFSfK+zFvnweHppE0YJb7bHEArdL42ieKCfT8uqneLPb2FYyEXGYcvkwl7X0q0kw1p
         ACrCf1XSRd/VCnmRUW8YbvFbHYN2H2z1pMcb6A5A0T1oKyPPpJdzQiDoosf/jZuyiy
         qR1F5hyrJQ4Cl7c52jZcQ97OzzHM6QvlZSomkEbR3xUoWTx0Vp/0owCKaF5MZbSxlM
         ghoSJvkig7bj0uwKYA7tB6F7/qAH/XlI9+9TCgXURwbWqjNt9KSG+hVJEAyZhB8kJC
         e4Igsywrfupx1UZB8+RC+A1tD5PGQNdGD4p6Mu8HaydfUe4Ia17p9qCgXwFXo0SpXg
         7F0YqntSYmJEtsJAebYVoI1rzYR8UX7pNFkTWo26hkX7BvqGcOcZ0WGGhTusCjCP1U
         3ra+zjbd3Ik9qSjruKk13Dy+1fVPTkDl/lkFN+HgWJ/iWPUCwuDvEwcN52zgl9epj3
         m0/vzEjDSeKUGo8WPIhaut+SbqLt3ngQ1z7Mnl81jsRAoqQ/prY8ityLnBvl+v2Igl
         nZITJJU08ip9k/VxZ2n9nRCo=
From:   Matthew Dawson <matthew@mjdsystems.ca>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] r8152: Advertise support for software timestamping
Date:   Wed, 05 Apr 2023 01:26:17 -0400
Message-ID: <3218086.lGaqSPkdTl@cwmtaff>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this drivers initial merge, the necessary support for software
based timestamping has been available.  Advertise support for this
feature enables the linuxptp project to work with it.

Signed-off-by: Matthew Dawson <matthew@mjdsystems.ca>
Tested-by: Mostafa Ayesh <mostafaayesh@outlook.com>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index decb5ba56a259..44f64fd765a7d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9132,6 +9132,7 @@ static const struct ethtool_ops ops = {
 	.set_ringparam = rtl8152_set_ringparam,
 	.get_pauseparam = rtl8152_get_pauseparam,
 	.set_pauseparam = rtl8152_set_pauseparam,
+	.get_ts_info = ethtool_op_get_ts_info,
 };
 
 static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int 
cmd)
-- 
2.39.2




