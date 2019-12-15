Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6229F11FB5E
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOVIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:08:09 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48739 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOVIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:08:09 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9abc7cfe;
        Sun, 15 Dec 2019 20:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=WKsaotYA98AJXI7dmXmM1xgGBlg=; b=1CXkSfZZsVJ8WusP2T0n
        Jd3wU6XxcIj7rUqTci+hsALkD59uMyzqUQlRkLk3+TY0nEUKuYI1f7ZAdyNHhpB7
        TOkPMdQPDSNk/Hs5PzLc616i4LfZ90IwkbmMbhCqHQxMuo0zuqNHdblaKcRQV6jF
        ueAXK+b9xQ5veOtKdE+P8CT01yhOHd2wW5ISWx2VG3iP3IYnJrS3xUCDYgAHViiZ
        GEnXG1dLt+j/+hVKwc6oRgCFa3KnNBJk3S6j9Vs+Ogmr/XAzUmr45MT8YlDXl1J1
        saJIFbV48EH79gUe2sIq+ZkU1fhM63HiDNC9gX1JAw9gmC3T9uexcFK0QBEYTa7g
        Zg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c8fddc43 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 15 Dec 2019 20:11:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 0/5] WireGuard CI and housekeeping
Date:   Sun, 15 Dec 2019 22:07:59 +0100
Message-Id: <20191215210804.143919-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This is a collection of commits gathered during the last 1.5 weeks since
merging WireGuard. If you'd prefer, I can send tree pull requests
instead, but I figure it might be best for now to just send things as
full patch sets to netdev. 

The first part of this adds in the CI test harness that we've been using
for quite some time with success. You can type `make` and get the
selftests running in a fresh VM immediately. This has been an
instrumental tool in developing WireGuard, and I think it'd benefit most
from being in-tree alongside the selftests that are already there. Once
this lands, I plan to get build.wireguard.com building wireguard-
linux.git and net-next.git on every single commit pushed, and do so on a
bunch of different architectures. As this migrates into Linus' tree
eventually and then into net.git, I'll get net.git building there too on
every commit. Future work with this involves generalizing it to include
more networking subsystem tests beyond just WireGuard, but one step at a
time. In the process of porting this to the tree, the builder uncovered
a mistake in the config menu file, which the second commit fixes.

The last three commits are small housekeeping things, fixing spelling
mistakes, replacing call_rcu with kfree_rcu, and removing an unused
include.

Thanks,
Jason

Jason A. Donenfeld (2):
  wireguard: selftests: import harness makefile for test suite
  wireguard: Kconfig: select parent dependency for crypto

Josh Soref (1):
  wireguard: global: fix spelling mistakes in comments

Wei Yongjun (1):
  wireguard: allowedips: use kfree_rcu() instead of call_rcu()

YueHaibing (1):
  wireguard: main: remove unused include <linux/version.h>

-- 
2.24.1

