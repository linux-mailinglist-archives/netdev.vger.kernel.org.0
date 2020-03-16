Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F89118617B
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgCPCOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40400 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgCPCOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so9038460pfl.7
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DClFRd7BWxve2DUdHfD0ILgpLsF9E3MwcetaXkuiukY=;
        b=sUJfH6DhkOMzxeuANQCd33zevj9xYdWaMvNuMhCQBvOL37jjW4cTYwpqSuPLBBX88D
         Pn2xiFc8vBPYK9m+jEzQsloJtwqW8LtcT/IKI82R6zXcKikKDQTpJwKWLAxVMJdAa9Hf
         a3ZODEPup1A8DDsE/54qHuHSgrypHwmT2vTkW/BgSXVDG++icrbW3aI2N3ZWg0A4Kpem
         A0EW4Cwpwc+FsNdFYk4ixNkj9VFTj7iijt0ts20YWJSOsWiZn1vbFkY+zvg9ej9YO74C
         163ksMn5TqJOXZwPm7Cd4ZqbhbvILz8gdCubDsw3ULNl2IyoZzK6rmcUk7N0mPOlM57J
         QWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DClFRd7BWxve2DUdHfD0ILgpLsF9E3MwcetaXkuiukY=;
        b=oZAgtUYtlht65N+fMhmgZ5v6UBmJSzDSwPzJEWdpLLefJEJiExtDdBZjNEaW7CdAp8
         H3tqE6eBWj+zl2ktmoIXlRP4G2oSxttELjMAx21RoMiTIklXV8tNtyW7hs6pTXVvJ5Fo
         WG8OLahLBoJq99UVq7tU5GtgikpWYw3co9Sg+zH3vGYnzrNI2lESKMVT210lDC17K95A
         u5QWKVUCkwx+vCBQsLZNJFpaoCHW8Q936ao1c2dh53b8UYuWwY+A2OHvQKkG5b2QKphl
         G9F5nTjZjz8wYkA56lXLKT7NnOTCtP1lUIL3FzyrbJScIXpYV/IinX/CEnvj9QWHzh78
         gF0w==
X-Gm-Message-State: ANhLgQ2oHdu6m560ihNpr2W6R8HPVAIdPQ/Jd08QUgtZZakZqn0aGnQp
        r+TdyWKjEpEt605fxqVRPFuoxOaYJNc=
X-Google-Smtp-Source: ADFU+vuOxOQQPjSTVPZOhF0HSuaXoixlLhMfh/UlIF7Gxe89gsFr2Ar3dfkQ0EI/Ksc+HmFjUhJHPA==
X-Received: by 2002:a63:87c1:: with SMTP id i184mr24017731pge.287.1584324881018;
        Sun, 15 Mar 2020 19:14:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:40 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/5] ionic: add decode for IONIC_RC_ENOSUPP
Date:   Sun, 15 Mar 2020 19:14:28 -0700
Message-Id: <20200316021428.48919-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316021428.48919-1-snelson@pensando.io>
References: <20200316021428.48919-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index e4a76e66f542..c5e3d7639f7e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -58,6 +58,8 @@ static const char *ionic_error_to_str(enum ionic_status_code code)
 		return "IONIC_RC_BAD_ADDR";
 	case IONIC_RC_DEV_CMD:
 		return "IONIC_RC_DEV_CMD";
+	case IONIC_RC_ENOSUPP:
+		return "IONIC_RC_ENOSUPP";
 	case IONIC_RC_ERROR:
 		return "IONIC_RC_ERROR";
 	case IONIC_RC_ERDMA:
@@ -76,6 +78,7 @@ static int ionic_error_to_errno(enum ionic_status_code code)
 	case IONIC_RC_EQTYPE:
 	case IONIC_RC_EQID:
 	case IONIC_RC_EINVAL:
+	case IONIC_RC_ENOSUPP:
 		return -EINVAL;
 	case IONIC_RC_EPERM:
 		return -EPERM;
-- 
2.17.1

