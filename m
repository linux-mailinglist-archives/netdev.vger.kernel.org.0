Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DED5F1BE8
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJAK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 06:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJAK5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 06:57:22 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B451FE0B
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 03:57:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id sd10so13771766ejc.2
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 03:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Dv3nH3BcBCs0ykNI472gOzF7Cz2mnKNGWzzpIQZlWPk=;
        b=P2nyEkAKnM0n7AV32wacJXwlrtktXZ2fwyBsHDjEn8nOet3o2FrN7f7tpaW2wlPUja
         mKWEv0B7cv1ejPsR7MwuGV7S+5dfu6yDWeZFcH07u0jQy7LxMdHzpP2vNczaYI9t7wBB
         S2rk8RWXjZA2XIAU/nQ/fy/18UgRHdCfpwDg8cdroUOn9QyIwjLLGgpWBY/p9R16ReFW
         0AgakbTfVtFZVxjP6nH536zYBFJjvtHA0f9LX3CmzJ2PEiNKt+USTFL4u9k0s5rnWPRv
         PNCE6iIXq9EXsGVSdu8XwqsiDlsl0w7SyBQY6FMa1wXnAipNUl+Nr5xla+2pWJx7Dc1N
         e9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Dv3nH3BcBCs0ykNI472gOzF7Cz2mnKNGWzzpIQZlWPk=;
        b=SFizjMdf0bqFan+lE452UoP1xSVXRC+1cxulyYZkZGGI8DXb/3jnvl6g1OcZyDHfau
         HpS55B+DT5bdm3MTJVkzN2r7VnsB7PsqpTfCafLS5yi8jviyRMUwUODdRNpI+nZLpQte
         gkk9jJo711iJlurR/fVou1T+CT36S9Y1pkDEjRKTmz5GaKqKl77lhphn7TDl+9J/AWzp
         mlnpdqOvJbzeywHD7aAr87rzr88Kj4Ysto9+YUovpRMV1V8EqFVVKTD0T2gi1j2VWCiR
         7mEOD2bqoJmkaCBA61w/5/OKbn/PQw0HYkl+i1S1sf+EY54K9MowBKzUUyRNCSlMBzxm
         /FmQ==
X-Gm-Message-State: ACrzQf2fRNQsrmBtuyHDCBI6yx4ecAYudPPsQjhOyBZOKOS+Lka40+Ot
        +iMGmVTzCUaqdjWaHLjglgs=
X-Google-Smtp-Source: AMsMyM4lGkghEdyNrEvWnHapL3zuQj725eZLxThV+/b9PTYRgizJttqb/oH83CWXXu/CFR7YXksyFg==
X-Received: by 2002:a17:906:fe46:b0:730:ca2b:cb7b with SMTP id wz6-20020a170906fe4600b00730ca2bcb7bmr9668235ejb.703.1664621840124;
        Sat, 01 Oct 2022 03:57:20 -0700 (PDT)
Received: from satellite.lan ([2001:470:70b8:1337:82ac:8598:1a68:da6b])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906329a00b0077f5e96129fsm2522059ejw.158.2022.10.01.03.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 03:57:19 -0700 (PDT)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net] net: wwan: iosm: Call mutex_init before locking it
Date:   Sat,  1 Oct 2022 13:57:13 +0300
Message-Id: <20221001105713.160666-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wwan_register_ops calls wwan_create_default_link, which ends up in the
ipc_wwan_newlink callback that locks ipc_wwan->if_mutex. However, this
mutex is not yet initialized by that point. Fix it by moving mutex_init
above the wwan_register_ops call. This also makes the order of
operations in ipc_wwan_init symmetric to ipc_wwan_deinit.

Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 27151148c782..4712f01a7e33 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -323,15 +323,16 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
+	mutex_init(&ipc_wwan->if_mutex);
+
 	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
 			      IP_MUX_SESSION_DEFAULT)) {
+		mutex_destroy(&ipc_wwan->if_mutex);
 		kfree(ipc_wwan);
 		return NULL;
 	}
 
-	mutex_init(&ipc_wwan->if_mutex);
-
 	return ipc_wwan;
 }
 
-- 
2.37.3

