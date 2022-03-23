Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630294E4A25
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 01:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237254AbiCWAn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 20:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiCWAn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 20:43:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D16F490
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:41:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p17so110692plo.9
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/p0PBNg4dEvZZdMOPc8ADEFCTxd+e0LJg9ienvfqRQ=;
        b=R2XAJRIElru74UMX8bGPkvfxkFznzwzVbv4KUM6qCrVR3y1lCaxa9U+SM2zNkjYJSJ
         q3L/RZBa6iVlL4r8znaXf2DtdqFSJGCJsoYKVqEbGB/1jSuHc0MSTTZjCA7Y+AW1VpJT
         G3UcjyxamHCly9Cg+4SbqlzvWM0Au9wxDLgdmTLHhQbakmLKgNjbphsbsKfGM/FuOyZO
         d5CoYWdDzfk8PDXI6sJrEwYhQeAEcxHsIhi7aVkpOTbmWIKjWpN8Mv0ssujbRwgUFGge
         CnTCjorl9G7h+R6Ji2IjjaMAX/vFbdS9vsaa/PFI3fl8kveVqjOFV/2LWYvMCSKoeFVZ
         aMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/p0PBNg4dEvZZdMOPc8ADEFCTxd+e0LJg9ienvfqRQ=;
        b=kWuqf+38VSa8gbUBYQPVhYmmZhaZURYrnGCaaR0JsQbDzU1G/ruTuPBhbW0tS2+VDm
         fXXpORyyYkCcVDk37is5SBraxZnRD/9I85bcVl+Z+U2b4cVckz/K3il4Buv9oFW6eohU
         9bPmSWvS8PUztzhjNGqI7xIW4h5xSWDcOkg/0HgiUU09GzHaxXkSG3+nloKeevFBj54Y
         9q54pEUihRKsHJLk0TyA31ijqD2WD9ZPxAv8SeEp9a0jmQfK+z9X66AbR+lXgJrFth5p
         OsP1sckMf6cVzRpqMqhov8He7F+XI8HQEuwaAgaWPJaoQZgXO+Hlaf8MHoT7ZbroUu/o
         7BDQ==
X-Gm-Message-State: AOAM530qL31YH1WD20+7pa8aD3MyRADKGAhNEDGVKlafN2XHOuIi6gHc
        QxLMIUM2YFzyVoCJY2Jv8qI=
X-Google-Smtp-Source: ABdhPJwiStIKbVRgeVTsQ+tRYFjKIb2n+jskZ6pQPvY91atmRaljBS/nLr1paqoZ6h5VSDwHDMDk7w==
X-Received: by 2002:a17:902:ecca:b0:154:8802:7cc2 with SMTP id a10-20020a170902ecca00b0015488027cc2mr5895413plh.37.1647996112077;
        Tue, 22 Mar 2022 17:41:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3cb4:8c88:992d:f1b2])
        by smtp.gmail.com with ESMTPSA id u15-20020a056a00098f00b004faa58d44eesm8262170pfg.145.2022.03.22.17.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 17:41:51 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?=E8=B5=B5=E5=AD=90=E8=BD=A9?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: [PATCH net-next] llc: fix netdevice reference leaks in llc_ui_bind()
Date:   Tue, 22 Mar 2022 17:41:47 -0700
Message-Id: <20220323004147.1990845-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

Whenever llc_ui_bind() and/or llc_ui_autobind()
took a reference on a netdevice but subsequently fail,
they must properly release their reference
or risk the infamous message from unregister_netdevice()
at device dismantle.

unregister_netdevice: waiting for eth0 to become free. Usage count = 3

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: 赵子轩 <beraphin@gmail.com>
Reported-by: Stoyan Manolov <smanolov@suse.de>
---

This can be applied on net tree, depending on how network maintainers
plan to push the fix to Linus, this is obviously a stable candidate.

 net/llc/af_llc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 26c00ebf4fbae4d7dc1c27d180385470fa252be0..c86256064743523f0621f21d5d023956cf1df9a0 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -311,6 +311,10 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc = 0;
 out:
+	if (rc) {
+		dev_put_track(llc->dev, &llc->dev_tracker);
+		llc->dev = NULL;
+	}
 	return rc;
 }
 
@@ -408,6 +412,10 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 out_put:
 	llc_sap_put(sap);
 out:
+	if (rc) {
+		dev_put_track(llc->dev, &llc->dev_tracker);
+		llc->dev = NULL;
+	}
 	release_sock(sk);
 	return rc;
 }
-- 
2.35.1.894.gb6a874cedc-goog

