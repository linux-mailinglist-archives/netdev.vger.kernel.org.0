Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6D43D05B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhJ0SOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:14:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42000 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhJ0SOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:14:31 -0400
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635358324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bZq50NGW7pNSxgKgyC0BBGjwP3JBXqVxKADzPg21XhU=;
        b=f6PJR+ktHP9hNNaPk1+sDEu4KTCxtdUGzK0Qe7/7Z4o7d5K2R6ChIAE+M1xgbdAXkj2p0s
        xz+IOvc9YfxE+rNQxfs60Smbsl9ZvGjGD3nqo3wxqlxxwvhZHOE0GhMXjognzaBBQETc9E
        182diFQIWxhWB5bsWGM72SNk5PSV9PHPNZd0x0tMNvqrgwaDSMKP+HxducAAPXQlCYTfw0
        3q1RTvk/ewtNyhkewz0Rd1JU7RvsWDrCIa3KTFinUiHM2dEm93iHj31FZnEOhLh8LCR1qc
        6PMKpGpgrltKEhEGx9Gsa5W/RLqGnudSnWtMrOrsIdWODGRFhOcbU6KhAycXPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635358324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bZq50NGW7pNSxgKgyC0BBGjwP3JBXqVxKADzPg21XhU=;
        b=gyPSkegxczE02nULdiSCUTR+InNTLBTBDyCuScVS34aZP1d819nC/gNq0zBQCrSlv413nS
        AEMHgBvL/7qIe9CQ==
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Bastian Germann <bage@linutronix.de>
Subject: [PATCH ethtool 0/2] Fix condition for showing MDI-X status
Date:   Wed, 27 Oct 2021 20:11:38 +0200
Message-Id: <20211027181140.46971-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

Currently there is a filter for showing the MDI-X info. It is only
presented for twisted pair ports, which suppresses the info, e.g., for MII.
I found that issue running ethtool on a br53 switch port.

Despite the enum names, I cannot find documentation on the MDIX fields only
being valid for twisted pair ports -- if they are present, they should be
valid. But maybe I am mistaken.

Additionally, fix a duplicate condition.

Bastian Germann (2):
  netlink: settings: Correct duplicate condition
  netlink: settings: Drop port filter for MDI-X

 netlink/settings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.30.2

