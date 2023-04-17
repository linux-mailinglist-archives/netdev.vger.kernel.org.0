Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBE86E3D74
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 04:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDQCaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 22:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDQCaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 22:30:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85D226A8;
        Sun, 16 Apr 2023 19:30:07 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24684839593so738264a91.1;
        Sun, 16 Apr 2023 19:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681698607; x=1684290607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZ9ANqiXxGArgI/ooXWZj/dxaEA1FUGBIVT18kymB6c=;
        b=YyLwC8qyB1alzAgKoeC9epPgWBabuRpySYqcNzhAmQEDx0k1+ylnIwfuCREjEnwAVE
         Z12cAQB2ezsnBlB6lopF8xdrMW89gOKj3xqmeJXVj6mgsREBzcXIiDy1LccMcrRWvwTv
         kx2DlfStMtE1oLGkqrk67v8lakwiCqaCTmKO8MWYbJpYm94dUbtRfIzn8PtYv29evrtx
         /DchWxhoOoJF/Y15ds30AtfvCmljz1Jf+Qenp0P+aAI/8bVE1/eE+y8XB/hz6+rh5W9t
         FMog5p+2SlBy0H59SkPTOL4PWWIh9aj3QPcT0r+l2Zr+2V3aNMHKb3N1i/VdiBoc8PJF
         4rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681698607; x=1684290607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZ9ANqiXxGArgI/ooXWZj/dxaEA1FUGBIVT18kymB6c=;
        b=IVqWmOoxq690FNjRpB6zqhH+yCRShJqzYgETaZysFYgZyPurKvVSwrH0rel88CXfrt
         JrG3+/RudHLxG5n7fwjzJ6HreO3SMA4MJxt88ml52vKCAu0WhA/NG2FNIpgQn4PlGEg6
         +hp4ZX+ZaQ34YmDT5XDaT3r6wrlEB1mIRe44fFtLCX+yMXhH03G/rDRJooK0ZNiguK3I
         yvqAn+ffMeAwBAgGU5uBIz/jg6mGiRwqnjmaBO4hLECOquUll5O2dkQpOmSHzfGwTSia
         O9fmledo+BdgsqHRrZgO8xEve6we+KUupYL922USJ8K/ldvT6vzaaNPPJoNQMsOP6Wkr
         IQdw==
X-Gm-Message-State: AAQBX9fRhWv85rk+M+ZJCZjRoYLGYO8aPiFtg2a6y9aC6Yr0i8eF5dSC
        rrKBp8apHj5nkwu73a30Jk0vJjq3iJKYrKjqPAM=
X-Google-Smtp-Source: AKy350Z8rEDLT2JcLywFey6ecRd0VoD01qyZlwboTAbIze/FE8uhoLQYrC+6oC+56BBOUZR3rLTcfA==
X-Received: by 2002:a17:902:e5cc:b0:1a0:53ba:ff1f with SMTP id u12-20020a170902e5cc00b001a053baff1fmr12265705plf.0.1681698607206;
        Sun, 16 Apr 2023 19:30:07 -0700 (PDT)
Received: from ubuntu.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b001a6ad899eaesm3407306plk.18.2023.04.16.19.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 19:30:06 -0700 (PDT)
From:   Min Li <lm0963hack@gmail.com>
To:     syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, Min Li <lm0963hack@gmail.com>
Subject: [PATCH] Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp
Date:   Mon, 17 Apr 2023 10:27:54 +0800
Message-Id: <20230417022754.4925-1-lm0963hack@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <000000000000894f5f05f95e9f4d@google.com>
References: <000000000000894f5f05f95e9f4d@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

conn->chan_lock isn't acquired before l2cap_get_chan_by_scid,
if l2cap_get_chan_by_scid returns NULL, then 'bad unlock balance'
is triggered.

Reported-by: syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000894f5f05f95e9f4d@google.com/
Signed-off-by: Min Li <lm0963hack@gmail.com>
---
 net/bluetooth/l2cap_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 55a7226233f9..24d075282996 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4694,7 +4694,6 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-- 
2.25.1

