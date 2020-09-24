Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBF3276572
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgIXAyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:54:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17DBC0613CE;
        Wed, 23 Sep 2020 17:54:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so650795pjr.3;
        Wed, 23 Sep 2020 17:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=h+H677fkWThjqWv2k9jNPc3lZ9kp0KrAb1xLKLcz9BA=;
        b=nogsSSOCdMjFc+PToVlsGPxrG2nVDj10fZT+0VlxtD5cG8yHeHti53rneht0xkgFXG
         wv5fFgsDEXCs8eJbe8zvFowZe/2oGnz6Vq7+FmBIPA6ysZyRLlr6yADru/LdVJcjZnW3
         X516h6RfP6YOJwn5v1X4dVqucD5u2SUNbgib3JlGQ4W2RjPKayAdlMeRoZo/PPfg0aqR
         JR74cnFn2On2ZbpYx2/9yzO828uFMOmm5mR1DFiSzLKZk6/Y8YWPZd5NEZbpyhf5b1Pw
         YbQaQdSoQt9rSV59chUmWRHZK2TDbPXE3U5HI32ZDOSQUwdF0cs9BgDpipBmbxBVbn8d
         f+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=h+H677fkWThjqWv2k9jNPc3lZ9kp0KrAb1xLKLcz9BA=;
        b=hkaypzBLdmVWUJcVS49RLXLb2WXbtkxSUVSN9dqa5MfpORJNkrdSgl6f/df3Y3nyFh
         8gJC6iM5Lm5oL8U6Ah4bYZcDIA0eQdcUEWuilBRZtkJFxcSvXS+eXY0kaCEFJKWZixNn
         AlH8IWa6N1ws/7KKbJNLQRzU6AJAZ93xbtMCptHn79VR2KS6F7A4CzUHkf1yIB/BY8+a
         Hh1dTgJXh8sgwdCwujbIVRS3uvvMWmU9+uMIVuKLJY4IlsupbNyg1qXOkUOEiFwytXiI
         bfCQbXEI/re1qZQGwp+cSBVckqvQdle0nlYnMluSYIAw8YaeE+5HXBWs8PbPk6Hv1Vhx
         agYg==
X-Gm-Message-State: AOAM533YXvl1HuT4ipNuxWCl8QKFnU79aNcIpiqpODiy1PFFi97L40qz
        Leoa1SrSpIpPrM+kLRo4rTQ=
X-Google-Smtp-Source: ABdhPJzwTqKFjG9yq7G0NjnVK48XB1bjfHCLpowt1E9AvBVyhNuDgX3eXiWUDAYYkJMMTN9h7zd3+Q==
X-Received: by 2002:a17:90b:905:: with SMTP id bo5mr1599772pjb.73.1600908885602;
        Wed, 23 Sep 2020 17:54:45 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id r1sm876431pgl.66.2020.09.23.17.54.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:54:44 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 10/16] mptcp: add RM_ADDR related mibs
Date:   Thu, 24 Sep 2020 08:29:56 +0800
Message-Id: <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com> <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com> <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com> <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added two new mibs for RM_ADDR, named MPTCP_MIB_RMADDR and
MPTCP_MIB_RMSUBFLOW, when the RM_ADDR suboption is received, increase
the first mib counter, when the local subflow is removed, increase the
second mib counter.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/mib.c        | 2 ++
 net/mptcp/mib.h        | 2 ++
 net/mptcp/pm_netlink.c | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index a33bf719ce6f..84d119436b22 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -29,6 +29,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("DuplicateData", MPTCP_MIB_DUPDATA),
 	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
+	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
+	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index cdeea3732ddf..47bcecce1106 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -22,6 +22,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_DUPDATA,		/* Segments discarded due to duplicate DSS */
 	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
+	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
+	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9064c8098521..b33aebd85bd5 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/mptcp.h>
 
 #include "protocol.h"
+#include "mib.h"
 
 /* forward declaration */
 static struct genl_family mptcp_genl_family;
@@ -346,6 +347,8 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 		msk->pm.subflows--;
 		WRITE_ONCE(msk->pm.accept_addr, true);
 
+		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
+
 		break;
 	}
 }
@@ -379,6 +382,8 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 		msk->pm.local_addr_used--;
 		msk->pm.subflows--;
 
+		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMSUBFLOW);
+
 		break;
 	}
 }
-- 
2.17.1

