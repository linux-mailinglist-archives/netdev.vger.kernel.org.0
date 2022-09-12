Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781A75B62F1
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiILVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiILVpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:45:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF3219C15
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:45:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f5960500bso85251617b3.14
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=svnXtkM3VxepqSEU29BlbteQjSXrw1OiHP05DgD2OTE=;
        b=cSiuqTmx400s/KFfx8exUIDTtsSBF+4IoXHY0dMeGOxNtYmvK0kzE1KPHnzi1YYKA1
         okKa3qgpeddDmz1cICme6A9JcDEvAwoCsC4erOmWQyMpNwMB4pKO9PssQfwiPHCykzpm
         ihBhYOrA5sG4HyiD9ZhcEwUmbBG1JGhAQ4kO7oUgXb39cgBGAnnsLinrnepILLOJuKy2
         LuwDcZE7s7+2HTUrSvIZusmZVRtRW7jfYDc5b40sc8kjzhdHD0W4oWxrvrbf6IKCZeXz
         mKic6hXSnNr9CBS221E7UTg834Psm6IgXL08SoLydXhKfqps3X0kwsP1fKqmitFeYi+W
         MWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=svnXtkM3VxepqSEU29BlbteQjSXrw1OiHP05DgD2OTE=;
        b=gdm3tFDI5xEYk2eztl/AHWALiZ2kQGmoJ8wTjRDTAUAJc6L+OGX1L7LWA/dCG205D/
         TQidMyGmB+e4qxB3GYhwxnrLULDacPWWYSR7k51msnxvZHFs8Z5L/eSOx7lwKpX6Q2Sk
         u9wY2vTn/HRrAzBxbZ54oJ0BmN2kE3/JSohuVW0ALZdcpEPGZaxiwMftqUyX727J08ZP
         AWVa/dl1sruzWbIY4DiXNX2GV/1toWl6OP0O2FhGvhD8RoTjLIkaovdC13p2PtS3xPEM
         GQNv3wie4tz0KJMZs3TS70nV78uEfBPzLxbbQUajVJ0aCtPkMmT8bUEbaNeZ1YHfIWY8
         AkPw==
X-Gm-Message-State: ACgBeo1Db705bsEoZr04dVA7OnfnjAI4ujwZ9fenjqKm9DFjxcPf5720
        fayTR2NUi6HMmqzae4rD+2a+kL5mzA==
X-Google-Smtp-Source: AA6agR5AYHR/zt+Sj+LJE5nbkcAXQKcEzulFFGGAMAeZPz0T1K1BgaaPGpIgNiOXaGvh7yOVBAvnuYB8zw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a0d:d84b:0:b0:345:342:2c57 with SMTP id
 a72-20020a0dd84b000000b0034503422c57mr23200506ywe.168.1663019107314; Mon, 12
 Sep 2022 14:45:07 -0700 (PDT)
Date:   Mon, 12 Sep 2022 14:44:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912214455.929028-1-nhuck@google.com>
Subject: [PATCH] net: wwan: iosm: Fix return type of ipc_wwan_link_transmit
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of ipc_wwan_link_transmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 27151148c782..03757ad21d51 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -103,8 +103,8 @@ static int ipc_wwan_link_stop(struct net_device *netdev)
 }
 
 /* Transmit a packet */
-static int ipc_wwan_link_transmit(struct sk_buff *skb,
-				  struct net_device *netdev)
+static netdev_tx_t ipc_wwan_link_transmit(struct sk_buff *skb,
+					  struct net_device *netdev)
 {
 	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
-- 
2.37.2.789.g6183377224-goog

