Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4075E54ED
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIUVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIUVJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:09:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959A11274C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:09:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so80154pjm.1
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=OkoTVV4SBgTzkQzKszTQfUnVz7OQX0l34N3q+KJMvSw=;
        b=MPYAvwowGMSZPqlWXyQU18X5VI2P59py1Bd9aqHv2Gf+ln8J4H6G/7SbHKoVlvJEF/
         pBCqdtq7ZMFGKWEUFLzEs5a1hYnEnAA6dAI1ymFesbCmmol5o7IlQ6DWx/JSZMj/4Blh
         yj53MfiJxy2ZKyG2Z0rmee/tmHaq0KLLa3YWKYgRHaVjO/iDyjP+4xtXSdR0KVTxEj5X
         27LfrGTDbyWKTLiXkhs5GlySAY0mKCCbY5xVRLyOWLGR0dQ769yMspjn2ym9SXvx/VNc
         4ALJCN5pWjvcfou5wGsmgrpcGMUUK5V9yCxcK1uVmsVeH2WNm3t7kEJyhYUA/lmJRVq1
         FGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=OkoTVV4SBgTzkQzKszTQfUnVz7OQX0l34N3q+KJMvSw=;
        b=8GMcbDKTS4ZhTtX0DzWlUnGciau+In7SRSEovikccpmWA4AHulRUp2WO6wyX/Ch4H6
         HI/uNvXYtMu8NaL3Vw30hDYV0rXqVPELvYzXcwnhFpOMk4FnnIgSh0Rb9J5iAHmqGB/Z
         XDXLdld7YLjKKVw0cUN3Zkur9ANIsDqgohJ+d2PJLK7GLjCfijt+PDqQDyTyt7qSZkkn
         o4u09VFOhxhaN8j/sKjbtJZAwkcBwEl/KfCWnH4mzJ5tXPbdavoi5a4Khs4Lzue8HcGy
         kB6sRtm4Sb1LyL5yGPkSEfO4aqk+L4P5+USQb0qEe7KLsFn7orifsTkOVM32K6yjy+3F
         EVLg==
X-Gm-Message-State: ACrzQf1b5XySeVWd1bi8+tXQ1kyBqrctVABkDIptcMyVgL0yeGDT0+rl
        ZNjwAGI7IyDQ9J659nSpJ8gnK6sY+/hgkQ==
X-Google-Smtp-Source: AMsMyM5BmO04+xD5Q7KpFxPEqCJL3CWGCBwvpDtD4KIQs8+wMd5/79TnTEagwu5h/YLW31sZKSm/vw==
X-Received: by 2002:a17:90b:4d8c:b0:200:7cd8:333e with SMTP id oj12-20020a17090b4d8c00b002007cd8333emr48931pjb.95.1663794579746;
        Wed, 21 Sep 2022 14:09:39 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id q59-20020a17090a4fc100b001fd7fe7d369sm2277742pjh.54.2022.09.21.14.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:09:39 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux_oss@crudebyte.com,
        asmadeus@codewreck.org, lucho@ionkov.net, ericvh@gmail.com,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v1] net/9p/trans_fd: check the return value of parse_opts
Date:   Wed, 21 Sep 2022 14:09:21 -0700
Message-Id: <20220921210921.1654735-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parse_opts() could fail when there is error parsing mount options into
p9_fd_opts structure due to allocation failure. In that case opts will
contain invalid data.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/9p/trans_fd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44be..11ae64c1a24b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1061,7 +1061,9 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
 	int err;
 	struct p9_fd_opts opts;
 
-	parse_opts(args, &opts);
+	err = parse_opts(args, &opts);
+	if (err < 0)
+		return err;
 	client->trans_opts.fd.rfd = opts.rfd;
 	client->trans_opts.fd.wfd = opts.wfd;
 
-- 
2.25.1

