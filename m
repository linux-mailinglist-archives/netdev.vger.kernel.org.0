Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D638E3B6BB8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhF2AcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhF2AcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:32:02 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF9BC061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id o11so19894123ejd.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9yY9rUOeHTAfNAX7TPdrQx7lohfVPDcglIE/cAbjlR4=;
        b=YpljY6p8G+g5HySYKJf+rGtAoR5ShrcGRod5zaeEkMeU6+N6lODIe9gVfzIFzbgXgD
         /ed/HrzQvLXZnDOX7P+YuXk6SagHxjtxcTCN9dg1XsCCvhHxNjYEW3MoqSUd8eKwjbUK
         5iHcguDX15MT51eHBjF0iq8wM5JEixwDvw/0SuacqpsyMqEQt2pljzON5q6ut08uXLf0
         GRPLU0KsWC+ZNGInnuEvF5W/nGaa0lzrCL7OtF1hxmo41r9kQQuI8qvJZgIPuHksiFSn
         UZU5E8ov3Gs4SCeBLRTw8+JG4bdOHw68oXVRau9npifCcjinf1BFPfDKb/l75Hc9nk8f
         gGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9yY9rUOeHTAfNAX7TPdrQx7lohfVPDcglIE/cAbjlR4=;
        b=E8xbdzmy6DHrZ05xj3pzEFvc1Rw2kW8dr5U1fflQr5uqsJFVKfrSiHpxe1tVtRiwwh
         l6FrGDIh0pmeXxiNN9q0TJ4f70y4UAvkSxv7j6ZEY9aE+Yukt1MiG3INQuYrKboUY31r
         uyvUNs1vSCR93P9HVEbJZ+/kndoSE1G+WRqUCfg8W5IghFqNEc1fVRnVksNpdQOYevII
         s7crNZf4oHxMwIwx4fnoYqOmM380MyI+pt+EwanSAckmOmiVJaheCv1YieggHSHoYtdW
         6c9jdEi2e69hA6anwZaV+wu7XpEkv1hd2S+RWXF6MvETcjDCeC8rJyO+flW6j3l5lsgc
         vj+g==
X-Gm-Message-State: AOAM533MIUf6qALnpGLci0vP9BhKZyf6zHpdyt3umnBOczJ1GAkTPv6u
        aLqGgp19u5ekv14Y0yUNxzgOY5oIe3g=
X-Google-Smtp-Source: ABdhPJwuDaoKUzIl2oUsn17R9rtzS7JVJjr9/iq3NDaH/H3ERGl2FcHqAJy7PnRLdg5qQrc7UdPyjA==
X-Received: by 2002:a17:906:7212:: with SMTP id m18mr26831241ejk.351.1624926574891;
        Mon, 28 Jun 2021 17:29:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s7sm7749913ejd.88.2021.06.28.17.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 17:29:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: say "local" instead of "static" addresses in ndo_dflt_fdb_{add,del}
Date:   Tue, 29 Jun 2021 03:29:26 +0300
Message-Id: <20210629002926.1961539-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629002926.1961539-1-olteanv@gmail.com>
References: <20210629002926.1961539-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

"Static" is a loaded word, and probably not what the author meant when
the code was written.

In particular, this looks weird:
$ bridge fdb add dev swp0 00:01:02:03:04:05 local        # totally fine, but
$ bridge fdb add dev swp0 00:01:02:03:04:05 static
[ 2020.708298] swp0: FDB only supports static addresses  # hmm what?

By looking at the implementation which uses dev_uc_add/dev_uc_del it is
absolutely clear that only local addresses are supported, and the proper
Network Unreachability Detection state is being used for this purpose
(user space indeed sets NUD_PERMANENT when local addresses are meant).
So it is just the message that is wrong, fix it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ab11c9d5002b..f6af3e74fc44 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3947,7 +3947,7 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
 	 * implement its own handler for this.
 	 */
 	if (ndm->ndm_state && !(ndm->ndm_state & NUD_PERMANENT)) {
-		netdev_info(dev, "FDB only supports static addresses\n");
+		netdev_info(dev, "default FDB implementation only supports local addresses\n");
 		return err;
 	}
 
@@ -4086,7 +4086,7 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
 	 * implement its own handler for this.
 	 */
 	if (!(ndm->ndm_state & NUD_PERMANENT)) {
-		netdev_info(dev, "FDB only supports static addresses\n");
+		netdev_info(dev, "default FDB implementation only supports local addresses\n");
 		return err;
 	}
 
-- 
2.25.1

