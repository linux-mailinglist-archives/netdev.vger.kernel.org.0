Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDD615ED7C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394727AbgBNReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:34:17 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52863 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394697AbgBNReQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 12:34:16 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 51a57f32;
        Fri, 14 Feb 2020 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=r+9Dc6KpauMGpugKq1+cuJokNQ4=; b=E9GPISP4+1mbVAMOZa0+
        2QDG3TLwtxM+wBQ1E2HaiNA3ryy1/6ITsDRfHe8L9jczIRkMQyrUU6UOaEpE8nmz
        VOOUok0c0lGfKlk5apOPSeuvn+VQtTzpb99b3v5oy7/w+yUQJ2G4m79NfNM5R61F
        SM7LlRTSvBBXD51nGqddrGfSMC3CHzt6X3D3+lmxqKNbRV4syArh8kCW4kDp3Mqx
        ITsPvAEB2Ld0SrLu/v9qAwaGNoutI40ulZL4x99qoK7a2KKCWDBmrm/pl62sKd/1
        N3OvkI5dQgfdR2WtYceTI8f5P/OufVsQCGGRCRlYwvh+bj/gWtT50ICcK91vNJKb
        Ag==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f59bdb91 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 17:32:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 net 0/3] wireguard fixes for 5.6-rc2
Date:   Fri, 14 Feb 2020 18:34:04 +0100
Message-Id: <20200214173407.52521-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are three fixes for wireguard collected since rc1:

1) Some small cleanups to the test suite to help massively parallel
   builds.

2) A change in how we reset our load calculation to avoid a more
   expensive comparison, suggested by Matt Dunwoodie.

3) I've been loading more and more of wireguard's surface into
   syzkaller, trying to get our coverage as complete as possible,
   leading in this case to a fix for mtu=0 devices.

v2 fixes a logical problem in the patch for (3) pointed out by Eric
Dumazet.

Jason A. Donenfeld (3):
  wireguard: selftests: reduce complexity and fix make races
  wireguard: receive: reset last_under_load to zero
  wireguard: send: account for mtu=0 devices

 drivers/net/wireguard/device.c                |  7 ++--
 drivers/net/wireguard/receive.c               |  7 +++-
 drivers/net/wireguard/send.c                  | 16 +++++---
 .../testing/selftests/wireguard/qemu/Makefile | 38 +++++++------------
 4 files changed, 34 insertions(+), 34 deletions(-)

-- 
2.25.0

