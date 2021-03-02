Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8132A340
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378698AbhCBIyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:54:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:39638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835865AbhCBGX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:23:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 114EDAFDC;
        Tue,  2 Mar 2021 06:22:18 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 15/44] net: nfc: nci: remove memset of nci_uart_drivers
Date:   Tue,  2 Mar 2021 07:21:45 +0100
Message-Id: <20210302062214.29627-15-jslaby@suse.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302062214.29627-1-jslaby@suse.cz>
References: <20210302062214.29627-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nci_uart_drivers is a global definition, so there is no need to
initialize its memory to zero during module load.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 net/nfc/nci/uart.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 16d009c9b6a0..c9987d1cccdf 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -468,7 +468,6 @@ static struct tty_ldisc_ops nci_uart_ldisc = {
 
 static int __init nci_uart_init(void)
 {
-	memset(nci_uart_drivers, 0, sizeof(nci_uart_drivers));
 	return tty_register_ldisc(N_NCI, &nci_uart_ldisc);
 }
 
-- 
2.30.1

