Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3296545988D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 00:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhKVXzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 18:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232059AbhKVXzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 18:55:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E868E60FED;
        Mon, 22 Nov 2021 23:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637625118;
        bh=FgkPWo9xVRtaRbbwhJl2W4zLIKWprXNLNUeHcBuMlzg=;
        h=From:To:Cc:Subject:Date:From;
        b=n8icZnNoDOjquWFfDf1Q219yO85FIC7ejs+NRrc0gbGPd4u8YiJvHnc1ExJaX3Ac2
         bBh/CCubSGnQZzl/pcwIjFMwClcyUFZCI83MkWnZCYF4qSaOe1f+GvRJl5XpzwFOSF
         5tfEOs3tf2M9n0pvu7Zrn2CnANJjHE8jMvCFfbBRwuDUcwYMNNoi9U4+DWhjf1H4Ii
         ++qVIqDa0TDmbFESkuxe2W109CDm5VxHyZpM8iSxSafyoGMI7LVafyLZn7aU3DQGCI
         D//MwV4Dl1lshP4supgmaKKhkoe24NkTOQawtFmH+pd6CfrHg9ZrNCUr3GeizZzkyA
         k6t8f8LbR5lOA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 0/2] 
Date:   Tue, 23 Nov 2021 00:51:52 +0100
Message-Id: <20211122235154.6392-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With information from me and my nagging, Russell has produced two fixes
for phylink, which add code that triggers another phylink_resolve() from
phylink_resolve(), if certain conditions are met:
  interface is being changed
or
  link is down and previous link was up
These are needed because sometimes the PCS callbacks may provide stale
values if link / speed / ...

Marek Behún (2):
  net: phylink: Force link down and retrigger resolve on interface
    change
  net: phylink: Force retrigger in case of latched link-fail indicator

 drivers/net/phy/phylink.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

-- 
2.32.0

