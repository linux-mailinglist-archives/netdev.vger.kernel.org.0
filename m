Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEB672E99
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjASCFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjASCEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:04:42 -0500
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655E29E3B;
        Wed, 18 Jan 2023 18:04:36 -0800 (PST)
Received: by mail-io1-f50.google.com with SMTP id i70so356328ioa.12;
        Wed, 18 Jan 2023 18:04:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MM+Dhy8E31duBDrBRfUCSOTn9Cy8FOge7XCfAeSm4uQ=;
        b=ctsGKNNmPFc3fGuYsqN64vsOZeNb8Zq/DvK2XCcd8EXnH5WuhNOV0tRdId9newnG2T
         T/ivxBo3H4NAvDzy7GMEZHRhVLqdMg4s+BxzaQpZF2DgzzfLQvN3+e4CzxVOeCuxByFR
         rVW6avg4JOrdyqiXT5gbTzFPs/fLNSKhVhA931xy+jp1u0wAJkIGdchoUH+Ka/d1niUe
         Q/D0PKImbZoFg3sOjHVEBDggGXn5UWAkkQ7Ib+A2PbSyGIxtx1NW1/AXYgFUPCAlDVGq
         KGjIWx/T+Cyol+23Ej5IRf8U4EzSNzDszJMlQLTgTpCrwgrJRIeH7Zs0MxCJV+2fRL/c
         FU1g==
X-Gm-Message-State: AFqh2kppE/43pJP2InjRpZa90ne4dk92wbCK+6fWv2bx9wmDNBF26DRu
        Yic6nfGQXz4apJGEF5Zut60=
X-Google-Smtp-Source: AMrXdXsBfNz2Ma45dlU+sOA80H4I1bfauU80Tz34bDdys5gY4Zzh1WjTmTkmVsuUkAYHFrzRnx3gpg==
X-Received: by 2002:a5d:9f0c:0:b0:6e2:d23a:6296 with SMTP id q12-20020a5d9f0c000000b006e2d23a6296mr6257857iot.20.1674093875324;
        Wed, 18 Jan 2023 18:04:35 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id e5-20020a056602158500b006ff6e8b3b8csm372247iow.41.2023.01.18.18.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 18:04:34 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        edumazet@google.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wuruoyu@me.com
Subject: [PATCH] L2CAP: Fix null-ptr-deref in l2cap_sock_set_shutdown_cb
Date:   Wed, 18 Jan 2023 21:04:07 -0500
Message-Id: <20230119020406.3900747-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119014057.3879476-1-iam@sung-woo.kim>
References: <20230119014057.3879476-1-iam@sung-woo.kim>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a critical typo on the prev patch - Sorry!

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_sock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ca8f07f35..b9381d45d 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1681,9 +1681,11 @@ static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
 {
 	struct sock *sk = chan->data;
 
-	lock_sock(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
-	release_sock(sk);
+	if (sk) {
+		lock_sock(sk);
+		sk->sk_shutdown = SHUTDOWN_MASK;
+		release_sock(sk);
+	}
 }
 
 static long l2cap_sock_get_sndtimeo_cb(struct l2cap_chan *chan)
-- 
2.25.1

