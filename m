Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6038F856
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhEYCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhEYCu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:50:57 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D154FC061574;
        Mon, 24 May 2021 19:49:26 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id a7so10985088qvf.11;
        Mon, 24 May 2021 19:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yp9ChnDXX/a3Eqfo821VCr0TE1yp4/AXDeNsmgE7SOU=;
        b=QWHa1P4+BVNkITZzO1c/XYMv8PQmZ8/751QDrpw52IdzdZ4pXP8uAVGxZkD6lSqgwn
         YxBWOWegkTtJBx/dK7zX7JO8cG226I+kuYn7fTfJ5AjVO162KJdzAVRw6G82RnxFNCvE
         MDYudEdiEC5GbsScb43WMcctQyNmK+/QnNDIve+cvm2ENqm3w/OPIdAvXDBMZh9sqr0O
         Zp0kCWcssU1IxyfqbzgePXaR8JrmEw7Ft+8bR3IrXJiK+4Kwc3e0axX8HdmndKdvkP7G
         SHZgWfN712+u5cr7BCQsgsW+KHhNhvVf2Gvnq8uSIUtv63o1At2UbCw4B5yFGGwpQK9F
         lVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yp9ChnDXX/a3Eqfo821VCr0TE1yp4/AXDeNsmgE7SOU=;
        b=Y+7N3vbANCuNlCTJ2uAS5naXjS0zdtxBjkaC1ZMHHTC033gfKFKN8wjJ1WaE1VTOuW
         YoxwQX7aV25j/WEB0lc3riwv+7SLO8QKr+w7J05rVoHYva469ve13RsrJU4bad+iFNYy
         M1EjUIuwsE5bvAqTji5Mrzfk2ouQ0IIUGUHAIGdlB9x8lUunK+T9xtCOkjEFRxLKaIn1
         291k3UJ67PIzxUQ2bYEl/LI9gPka+lYjFmgUHQFY1KEC6HrAO5PEpqLspGtnT3/oMz5E
         MtbXHA0oDCQQZ05zTTMtkbNMwlUXJ1/C5POWV0adDNMS1m6+TjDgwda1MxmBU+UYwyU0
         FAOQ==
X-Gm-Message-State: AOAM532nkMKa34ZQC9nYzXgQTHtzGhnYgFLeZx4w1PmlQdWMv7eOfc+n
        njWAbwfNRmZnMmq8BhGY72wT3Y5SWuw=
X-Google-Smtp-Source: ABdhPJxVc57QylPVJLN8cHbXrV4CLYIEQFn1ywNWkVpyueV0ZgZsABgPorXLZdisw8azLxrM9jgBDg==
X-Received: by 2002:a05:6214:4d:: with SMTP id c13mr33044449qvr.15.1621910965926;
        Mon, 24 May 2021 19:49:25 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d24sm11878366qtm.70.2021.05.24.19.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 19:49:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: add the missing setting for asoc encap_port
Date:   Mon, 24 May 2021 22:49:24 -0400
Message-Id: <6bd2663c371f783d4668de217d0fbf3b0e85cca8.1621910964.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the missing setting back for asoc encap_port.

Fixes: 8dba29603b5c ("sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 40f9f6c4a0a1..a79d193ff872 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4473,6 +4473,7 @@ static int sctp_setsockopt_encap_port(struct sock *sk,
 				    transports)
 			t->encap_port = encap_port;
 
+		asoc->encap_port = encap_port;
 		return 0;
 	}
 
-- 
2.27.0

