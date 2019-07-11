Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD422652F3
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfGKIOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:14:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37062 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727829AbfGKIOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:14:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Jul 2019 11:14:31 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6B8EVkV026708;
        Thu, 11 Jul 2019 11:14:31 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next iproute2 v2 1/3] tc: add NLA_F_NESTED flag to all actions options nested block
Date:   Thu, 11 Jul 2019 11:14:25 +0300
Message-Id: <1562832867-32347-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
References: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Strict netlink validation now requires this flag on all nested
attributes, add it for action options.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 tc/m_action.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index ab6bc0a..2d36a69 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -214,7 +214,8 @@ done0:
 			tail = addattr_nest(n, MAX_MSG, ++prio);
 			addattr_l(n, MAX_MSG, TCA_ACT_KIND, k, strlen(k) + 1);
 
-			ret = a->parse_aopt(a, &argc, &argv, TCA_ACT_OPTIONS,
+			ret = a->parse_aopt(a, &argc, &argv,
+					    TCA_ACT_OPTIONS | NLA_F_NESTED,
 					    n);
 
 			if (ret < 0) {
-- 
1.8.3.1

