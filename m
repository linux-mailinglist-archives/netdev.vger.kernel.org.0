Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CB445D496
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346868AbhKYGOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:14:04 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:57932 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347399AbhKYGMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:12:02 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 545B22029A; Thu, 25 Nov 2021 14:08:50 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH net-next v2 3/3] mctp: serial: remove unnecessary ldisc data check
Date:   Thu, 25 Nov 2021 14:07:39 +0800
Message-Id: <20211125060739.3023442-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211125060739.3023442-1-jk@codeconstruct.com.au>
References: <20211125060739.3023442-1-jk@codeconstruct.com.au>
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
index b0e14a63b10d..eaa6fb3224bc 100644
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
2.30.2

