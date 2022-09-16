Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A301C5BAF8C
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIPOnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiIPOnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:43:39 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468EE5F221;
        Fri, 16 Sep 2022 07:43:38 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u9so49998846ejy.5;
        Fri, 16 Sep 2022 07:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gllMF7rEKjn2stwt8zy38QVQBQaalDndHDH9GUJ9KbI=;
        b=aGU63eF0ffZjrabeXppQR6A07Z1vdKgRsAOOfVWaru5FTK02mInfQTd44/O915hd3v
         rnktJEUalIXx5b3WTn7/cUUCvVHv+JQloN0hjM6k5BmUzgF9VDGdCTDAmlYq3wqs4mPx
         BGIhOJb1lfE8DwyHwPeX7SP7rqqK0mvzzdbc9nwZR9hW2zRbJeN8glg5yVfK7oanoI/Q
         4tIHkmohMyhvbcoHh+1ayDXsgyJC2o3OwP2nKl0Ng6zCKq1Aut95LS3hCVewHy+ximsl
         8pdqrxCkwOHJmOQzFnr9MKVVFUM+O+6wxuFJMfHup92GBMyrZD1v5yHLGTrEYInFzGiF
         QG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gllMF7rEKjn2stwt8zy38QVQBQaalDndHDH9GUJ9KbI=;
        b=nIx0LT3o3mlNZLv4R9Qf3Q93FY9QSqQ0zKMABNt9N9bAdCBjVnlfC4mcCubsAhpkNQ
         zcRatA92kQE+NNXqg4Ps/cjIlURMbgxlRqaZJbOIZ+ZpT4yOSto4QXyxHERJPOTsmrKH
         u+3jMBW0mf6w37ddHtHRnWYXtUqvcUFNoz1ifJqDFGGvqjIA4lgIpQbDNFLTbI5QHaBa
         MpcwwvpWUDBSnVEj4KwvtJLy55FqAajgJirWTX7ShCZ1EVXQFALx7lMDhIDRPEjTbxV6
         Jp9UN56X472muhkBmkK4l7RVtYIdglSYDIhH8fqUJcxND+ptI+JnfYLEizoWIq3ONr1u
         o7bA==
X-Gm-Message-State: ACrzQf0SR8cmoVPjRmT2dGAZr4sr+azyfWtLL40Lt8vsiTnRdSUmm7Ii
        43zqGuIxzyLpfXpe7dl36QkQzxzbhDEePg==
X-Google-Smtp-Source: AMsMyM6yuNIBAzryvbRBESypYb/cWw5mw3gBg1Qyg6kFhU6B+DCAix0l11fB0Esz6fJ+QP+eEiwhow==
X-Received: by 2002:a17:907:d91:b0:770:86d3:36e4 with SMTP id go17-20020a1709070d9100b0077086d336e4mr3591670ejc.687.1663339416784;
        Fri, 16 Sep 2022 07:43:36 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7cd0f000000b004527eb874ebsm6273792edw.40.2022.09.16.07.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 07:43:35 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     dnlplm@gmail.com
Subject: [PATCH 1/2] net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
Date:   Fri, 16 Sep 2022 16:43:28 +0200
Message-Id: <20220916144329.243368-2-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916144329.243368-1-fabio.porcedda@gmail.com>
References: <20220916144329.243368-1-fabio.porcedda@gmail.com>
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

In order to have a secondary AT port add "DUN2".

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/net/wwan/mhi_wwan_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index e4d0f696687f..f7ca52353f40 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -258,6 +258,7 @@ static void mhi_wwan_ctrl_remove(struct mhi_device *mhi_dev)
 
 static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
 	{ .chan = "DUN", .driver_data = WWAN_PORT_AT },
+	{ .chan = "DUN2", .driver_data = WWAN_PORT_AT },
 	{ .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
 	{ .chan = "QMI", .driver_data = WWAN_PORT_QMI },
 	{ .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
-- 
2.37.3

