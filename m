Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B170644509
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiLFNzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiLFNzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:55:31 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1642B1A8
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:55:28 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id j1-20020a4ad181000000b0049e6e8c13b4so2171849oor.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=Imfzn9TM+P2Q7uBpSsaLnkDWfjYU5FnSGRtGc5cfVNIbwrwXYi36BXMZTws75IaJTI
         k32xX88UgKBk+5B0FdnORAvzsPHLjfyqwuuwxdh8QGtOeo5Y9LhHx1/yx2N3l9j4iS96
         WkHUPn12gpfrdDrfM2RsE2y2QEnFYCSi7S7MJy/mnFUa7iLoSIZ/iRFPYyRMGiZwlJdi
         NxnLnvls+PCYj0BIGIXZGo5/278oBGqLPbwAzzQU9k8ZOo61dQFyajwJiplsF0q7B0PX
         5sNUoUg7z2sH7y9AMd0MyWd+jyzQRqSu/k+b0nGEwr1A6g6Rg3Dz2MiO4qWNt7Vd2/Ew
         0J/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=JlsppSonmrBQZQHELna/DBJvvPLdKJDsT8bttdjrwt8ieMdLf6lo+99f1KhBjAUwel
         NRVmQGBf4XvIOhcHMvTIKaWB2nfFpY+NQ49d8pw6NnLKXQvYG8lIQx8jRBnfXmPMVttr
         +uvgVH7gZbjgJBS+CexeP82oWpWWwWSB+2+l0VT/EycjpDLY9rm34iwUZn1HJjYLRMuV
         hbLVpzSrpeFxN7YUWGWu0KbAvJ/qrZrl7R5UeKZ1iK0L57iNNWjIGgGkHtzm22/QYiY4
         KJBg2iMTU7nc6OLx4KzVA3cKQKONb5tCsjoFU8M1hy7a9XwvLbRmMaE1J4u0TMBissCz
         uSEg==
X-Gm-Message-State: ANoB5pniBMdOoWG+ghNfj9v9xKIF4SdXyVHdCeR2r4eOA7lPuPtP1yL/
        Azlxx85MzrPwH38BxSRy1wB3K3ALY7K5KWYq
X-Google-Smtp-Source: AA0mqf7l4lZQC9o1rEsM2rHjvCvNqJHR1o3dU41bL4txMmYs4dTPLY0QRQVZ8IdwlGeyFcXWgV9zxA==
X-Received: by 2002:a4a:e145:0:b0:480:81e3:c884 with SMTP id p5-20020a4ae145000000b0048081e3c884mr28700385oot.18.1670334928087;
        Tue, 06 Dec 2022 05:55:28 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6544:c4a9:5a4c:3545])
        by smtp.gmail.com with ESMTPSA id h5-20020a056830164500b00667ff6b7e9esm9319792otr.40.2022.12.06.05.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:55:27 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v6 1/4] net/sched: move struct action_ops definition out of ifdef
Date:   Tue,  6 Dec 2022 10:55:10 -0300
Message-Id: <20221206135513.1904815-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206135513.1904815-1-pctammela@mojatatu.com>
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type definition should be visible even in configurations not using
CONFIG_NET_CLS_ACT.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/act_api.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c94ea1a306e0..2a6f443f0ef6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -101,11 +101,6 @@ static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-#ifdef CONFIG_NET_CLS_ACT
-
-#define ACT_P_CREATED 1
-#define ACT_P_DELETED 1
-
 typedef void (*tc_action_priv_destructor)(void *priv);
 
 struct tc_action_ops {
@@ -140,6 +135,11 @@ struct tc_action_ops {
 				     struct netlink_ext_ack *extack);
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+
+#define ACT_P_CREATED 1
+#define ACT_P_DELETED 1
+
 struct tc_action_net {
 	struct tcf_idrinfo *idrinfo;
 	const struct tc_action_ops *ops;
-- 
2.34.1

