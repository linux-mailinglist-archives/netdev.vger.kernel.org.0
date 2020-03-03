Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE44C176E56
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgCCFFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgCCFFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:43 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7FAA24677;
        Tue,  3 Mar 2020 05:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211943;
        bh=YKuFkA8JhBWYv/JqO9oERMYAqNIi/rWMpSE9Gvuhm14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0NAKLJTcp+rEXL8L60u4xYpcknERPDYXkhq6E1FMEQN+fVjiLe8o5SbCEK25oi9r
         giDcFnJrm3U90enqJvDWZ0gIVz4eN3QLT9gtchVRdYP02JxSG3TPKSxvuMwTq3ZEaq
         dRYlDdb2JAGR8drJ7YJs4uVceDxthv1RMQyPT/Oo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org
Subject: [PATCH net 06/16] can: add missing attribute validation for termination
Date:   Mon,  2 Mar 2020 21:05:16 -0800
Message-Id: <20200303050526.4088735-7-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for IFLA_CAN_TERMINATION
to the netlink policy.

Fixes: 12a6075cabc0 ("can: dev: add CAN interface termination API")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Wolfgang Grandegger <wg@grandegger.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Oliver Hartkopp <socketcan@hartkopp.net>
CC: linux-can@vger.kernel.org
---
 drivers/net/can/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 6ee06a49fb4c..68834a2853c9 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -883,6 +883,7 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 				= { .len = sizeof(struct can_bittiming) },
 	[IFLA_CAN_DATA_BITTIMING_CONST]
 				= { .len = sizeof(struct can_bittiming_const) },
+	[IFLA_CAN_TERMINATION]	= { .type = NLA_U16 },
 };
 
 static int can_validate(struct nlattr *tb[], struct nlattr *data[],
-- 
2.24.1

