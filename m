Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0445A34B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhKWMyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:54:19 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55740 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbhKWMyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:54:17 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id E53C92029B; Tue, 23 Nov 2021 20:51:07 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] mctp: serial: remove unnecessary ldisc data check
Date:   Tue, 23 Nov 2021 20:50:42 +0800
Message-Id: <20211123125042.2564114-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123125042.2564114-1-jk@codeconstruct.com.au>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri assures me that a ldisc->open with tty->disc_data set should never
happen, so this check doesn't do anything.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-serial.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 5687ad3220cd..9919a4734ed9 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -439,9 +439,6 @@ static int mctp_serial_open(struct tty_struct *tty)
 	if (!tty->ops->write)
 		return -EOPNOTSUPP;
 
-	if (tty->disc_data)
-		return -EEXIST;
-
 	idx = ida_alloc(&mctp_serial_ida, GFP_KERNEL);
 	if (idx < 0)
 		return idx;
-- 
2.33.0

