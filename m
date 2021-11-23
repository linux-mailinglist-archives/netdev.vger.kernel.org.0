Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B8A45A6BD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhKWPrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236148AbhKWPrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 10:47:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4560260E54;
        Tue, 23 Nov 2021 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637682248;
        bh=tp/slqvdmPi2FebVHoL4t4VkbO2brAsEfdU464cgMlw=;
        h=From:To:Cc:Subject:Date:From;
        b=fcQzjH4EhAgghdCq1uo/iCEbXWabSq1V8a5GYhH+rcQnopxqiN1fKLiUuwFCCtUaM
         dmPhchiDI1+4tXLCJPFFbDQeDUCBPJqOKd7gC0Kz35c4esCIIcdKA/pAjM+bzqNe6V
         Xl3kJUVMK2zuTTYw1UYMkiinLPULSCf7QzUV223qf7x+ycHw1+NsElZqbTBAYfFCNj
         xR2EJPHsZJ+B5qZt3NUlF8GkZ391S4YktLS/APmykST3Q+Am5aBYe7M3JOdZ6KPwC2
         WAI0KLPLyehUHHD2TcXkW/eZld1gvqrgo3Iz0I/51rE0L/YqvRs2fz1zOEtPZYCsQs
         /WLWwKNEuHJcg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 0/2] phylink resolve fixes
Date:   Tue, 23 Nov 2021 16:44:01 +0100
Message-Id: <20211123154403.32051-1-kabel@kernel.org>
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

Changes from v1:
- set Russell as author of the commits, since I only wrote the commit
  messages
- updated the second patch according to Russell's comment (and updated
  commit message)

Russell King (Oracle) (2):
  net: phylink: Force link down and retrigger resolve on interface
    change
  net: phylink: Force retrigger in case of latched link-fail indicator

 drivers/net/phy/phylink.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

-- 
2.32.0

