Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017A9196862
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgC1SZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:25:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45053 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgC1SZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:25:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so15679878wrw.11
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 11:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pe/RAsawLcL9HQBkvixQb3dgq0ymGasOUygAwRKRm/M=;
        b=cbxn411SozMaWO9zGVzjSHEnU0qKHnoV387TgQXoGgHklRHBsLVbxT8NNBHH39+dsn
         ChceYSLGt//Yx9F0oPkloHGk6HbJbFxz8CmDQrKQnsprAeQdEQEs9/97oP2JKVSmiv2u
         BW1sxCUvJhmgiNHmldIHolLEmSfaeyhOWMQ6WoPpNzydDygZvKoLdcpAuL4HoEIUTuj/
         g02B2C3q7Xlf8yOxT5uPTkz+LSEs1cAQPIoRH9+Ii2B1vcA4l4cko4ocWWJv4vS+5jSE
         CnT3tOsYyDS5FNtOec9qApaLCzGGGAcl4cncFwZKGh7b26H2zB3McYSLQBGD6CGPt3ia
         XmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pe/RAsawLcL9HQBkvixQb3dgq0ymGasOUygAwRKRm/M=;
        b=DPmnxZUU8WtQjknRLm0C9x48z0LymqJ9kCDpdhcrnqlUUm7UAmzs3YzuRCSyXI7Xoe
         nC9ncJdEjlAb8SqcqJsZYKiiSCmNbVNPnHusbN2Q8KuqDf/9TWpno5dANR/W8NwwAkCf
         Rg9A8aPmkDEtJqntJlszjo38BmHsmHXNxsnjDOVTeB9qTtsdJzM1L3GIKFU7Vl/KU55L
         lIs4KQaJcNXhLH5oNpFfwAj+hpQIav4XaA1rZIllCI6VgH8NmqVSLiN1Oit5us4qExye
         y5l2uwkKs4FIWbPSyoF4PlcC7rw0joBKgxEN4+jexPz7IUm3lBlvSoinwkL/2C18Rt1U
         ZbYg==
X-Gm-Message-State: ANhLgQ0+ihL5hgWkUltHsM5L0aIrZVApfP1ejPlykYL+PNqwAYEykpaZ
        3TgnREh05OpozmvyRSiiISjlVhNQZ+8=
X-Google-Smtp-Source: ADFU+vshbPPsgPTHx9yqFJiQ4lZt1edLPTx5uzJClsMiRTnL8VUsP9UKNeHPZRpmSuXYtyE83hywNQ==
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr5884096wrs.61.1585419932001;
        Sat, 28 Mar 2020 11:25:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b15sm13576527wru.70.2020.03.28.11.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:25:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com
Subject: [patch net-next] net: devlink: use NL_SET_ERR_MSG_MOD instead of NL_SET_ERR_MSG
Date:   Sat, 28 Mar 2020 19:25:29 +0100
Message-Id: <20200328182529.12041-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The rest of the devlink code sets the extack message using
NL_SET_ERR_MSG_MOD. Change the existing appearances of NL_SET_ERR_MSG
to NL_SET_ERR_MSG_MOD.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d20efdc8cc73..5b968d2040a5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2709,7 +2709,7 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
 	struct net *net;
 
 	if (!!netns_pid_attr + !!netns_fd_attr + !!netns_id_attr > 1) {
-		NL_SET_ERR_MSG(info->extack, "multiple netns identifying attributes specified");
+		NL_SET_ERR_MSG_MOD(info->extack, "multiple netns identifying attributes specified");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2727,7 +2727,7 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
 		net = ERR_PTR(-EINVAL);
 	}
 	if (IS_ERR(net)) {
-		NL_SET_ERR_MSG(info->extack, "Unknown network namespace");
+		NL_SET_ERR_MSG_MOD(info->extack, "Unknown network namespace");
 		return ERR_PTR(-EINVAL);
 	}
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
-- 
2.21.1

