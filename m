Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F090430E2E
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhJRDcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:32:23 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:39884 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhJRDcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:32:22 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 55E0C20224; Mon, 18 Oct 2021 11:30:06 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH net 2/2] mctp: Be explicit about struct sockaddr_mctp padding
Date:   Mon, 18 Oct 2021 11:29:35 +0800
Message-Id: <20211018032935.2092613-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018032935.2092613-1-jk@codeconstruct.com.au>
References: <20211018032935.2092613-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have some implicit padding in struct sockaddr_mctp. This
patch makes this padding explicit, and ensures we have consistent
layout on platforms with <32bit alignmnent.

Fixes: 60fc63981693 ("mctp: Add sockaddr_mctp to uapi")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/uapi/linux/mctp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index f384962d8ff2..6acd4ccafbf7 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -20,10 +20,12 @@ struct mctp_addr {
 
 struct sockaddr_mctp {
 	__kernel_sa_family_t	smctp_family;
+	__u16			__smctp_pad0;
 	unsigned int		smctp_network;
 	struct mctp_addr	smctp_addr;
 	__u8			smctp_type;
 	__u8			smctp_tag;
+	__u8			__smctp_pad1;
 };
 
 #define MCTP_NET_ANY		0x0
-- 
2.30.2

