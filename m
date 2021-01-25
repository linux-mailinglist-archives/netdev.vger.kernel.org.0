Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B302302FF1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732824AbhAYXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:16:50 -0500
Received: from conuserg-11.nifty.com ([210.131.2.78]:51616 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732742AbhAYXQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:16:18 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 10PNER1P006161;
        Tue, 26 Jan 2021 08:14:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 10PNER1P006161
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616468;
        bh=CwE75ME7uJsRI4mtEmQNnvEMhOfnR7D/V+gFnqtkhCg=;
        h=From:To:Cc:Subject:Date:From;
        b=wt30kCivec810+13ZdZ4Z4F2E8q6BegWppL4oQlRvc2b36X+4xHWgOvp18gh0XIIR
         rVvtn/Qi2kNLelstVDPSGNpo+uHX1fHRhNgCkJpMsDKBbBs6eAjLIXzkw1qJtvZOA1
         ZKbtGBXNRgUpPGVPGl2eVu0BPvgI8H1rUCbZlbAUm9tbSYACefhEEqBilI7CGZx0jL
         rYYjOsblwPD0kUxtVO+WZ3911a4h4X9FBw4wVMm66CHk8MXpXbNnEfSMFXV0G1UMgJ
         dWHJ6smIOV6hHkOgdpOXyBiVP8OF/6kmpbY7oy+QJPGzsBP9Ey9mzHH4Bedhh/AUTg
         6BNa4pnO2kUnA==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrey Ignatov <rdna@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sysctl: remove redundant #ifdef CONFIG_NET
Date:   Tue, 26 Jan 2021 08:14:21 +0900
Message-Id: <20210125231421.105936-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_NET is a bool option, and this file is compiled only when
CONFIG_NET=y.

Remove #ifdef CONFIG_NET, which we know it is always met.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/core/sysctl_net_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d86d8d11cfe4..4567de519603 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -309,7 +309,6 @@ proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 #endif
 
 static struct ctl_table net_core_table[] = {
-#ifdef CONFIG_NET
 	{
 		.procname	= "wmem_max",
 		.data		= &sysctl_wmem_max,
@@ -507,7 +506,6 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= set_default_qdisc
 	},
 #endif
-#endif /* CONFIG_NET */
 	{
 		.procname	= "netdev_budget",
 		.data		= &netdev_budget,
-- 
2.27.0

