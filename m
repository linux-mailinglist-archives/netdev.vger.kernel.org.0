Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A329115D88C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgBNNeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:34:15 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:42097 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbgBNNeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 08:34:14 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 88bc116c;
        Fri, 14 Feb 2020 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=GwyJ9mBidVKv40BKohqeVmc6f2M=; b=QMCsr9bMXB7qIR+ZbFOu
        RA0/k3iNXl7Tc58ZlDf1LCT+08iYylTH1GE743TVkddZIvVyKaWEVcKiHRIVC9vD
        +zlzb9FXFkBj3zcanQvkOiTR2ZER9FJJqi2Gx8Y1wpaH38wnsRFViOy6gutJxrwi
        mfsTXsf/n8j6FmcE3c7jXMV7L+wB0D8NGzHTu8HqmC7oin5MDYCnYCszPmQVguLL
        8qQmGq/jytW9gknw4p+cWa+R8Qp9pSByF5KGZKVTaDPyiUtHN3mOnx2HKrQus3GG
        ewVaj3v0GFpgiGfkzDud3uvjfRvVWWkq2oXRPomZUZrTEgSeYfKq0rPqJS9q56g7
        Og==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 771086ac (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 13:32:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/3] wireguard fixes for 5.6-rc2
Date:   Fri, 14 Feb 2020 14:34:01 +0100
Message-Id: <20200214133404.30643-1-Jason@zx2c4.com>
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

Jason A. Donenfeld (3):
  wireguard: selftests: reduce complexity and fix make races
  wireguard: receive: reset last_under_load to zero
  wireguard: send: account for mtu=0 devices

 drivers/net/wireguard/device.c                |  7 ++--
 drivers/net/wireguard/receive.c               |  7 +++-
 drivers/net/wireguard/send.c                  |  3 +-
 .../testing/selftests/wireguard/qemu/Makefile | 38 +++++++------------
 4 files changed, 25 insertions(+), 30 deletions(-)

-- 
2.25.0

