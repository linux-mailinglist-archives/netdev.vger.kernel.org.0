Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF584C58A3
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 00:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiBZXDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 18:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBZXDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 18:03:06 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EE322B31;
        Sat, 26 Feb 2022 15:02:31 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id k22-20020a9d4b96000000b005ad5211bd5aso6519228otf.8;
        Sat, 26 Feb 2022 15:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCmj61XXqml999fOdO7ZMvBWtcj+BnqQt8dDb4EFymQ=;
        b=Bql9JCAVSVOwMVN/qbly7HBkx7/4M4l6ZfuPvOgG5blyuFV1+Kp7ALapqIObnPGHPJ
         6Kgr35JfBZSv8QRoioWOvei6ewmZG/CJH3YuDJ64YfHsH0ay9yp3Zti1QKJ0fXjAOTFR
         5lcOtBT5mL6kx1RDmLpo4sTTgCuG1vv84+CU77qc9v1L88A7/rr9ieR9WhwG0xj/jYP8
         CWaMzjLVFrhpuAWHHrJHq4LsUhu/o9k+dXFEDahy+dX0vCL+c3Zx5tQXz3MQk/0X2rGg
         sxXXK+Xg2ME6EYoGpcnyESO34enXEFcruoDgpN+IwMllXEuEctj/DXqN/INi4qjjyvj0
         N3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCmj61XXqml999fOdO7ZMvBWtcj+BnqQt8dDb4EFymQ=;
        b=fkWvB67M1HUk5zSQgSQYXf0bVtzk06JXBiInoMaSVp3D0lIvLu5GMmqN5CtfrG3Czw
         ABnDiIashqawrrfoxSBNXFYbHULrDA4HnND9a1d5AiujYEx5JTYRq58a7z0fd7YGm8k7
         W3+zl2flGYQiqtmv+dv86Hy6TfTj8NUPl5LgSk7xYUnjtSm9INJAGVHb5Zb2DDhO3Au3
         nhyz30jahkjUZPXHzhaRPJBGjbk0vXd17d1bfab078bDaAKcOr44ssodWO0CW75C71Ty
         6hIak8a5Zgjf1SCFgZjav9b7AEwYnrBJGvB7RjLHhfLqm3guV4CBh5owZmgK8oAIDImD
         5ZUA==
X-Gm-Message-State: AOAM530TT2cluOuUsslrzRDaXKJ3zBUhEjQLDIwNYRGzD0djtE2CqKXv
        XNwXF4x9Ck77Ha9Pm3Wso0IjncgxYVEdVyLc
X-Google-Smtp-Source: ABdhPJw0OwQ3n3/Hh6ame3GTxvLoLg+0x4RpcNhR9UjVe+CdmyAUSWnq2AABrKZz+p/z919w9RNKFw==
X-Received: by 2002:a9d:22ea:0:b0:59f:e225:f5bd with SMTP id y97-20020a9d22ea000000b0059fe225f5bdmr5692775ota.378.1645916550235;
        Sat, 26 Feb 2022 15:02:30 -0800 (PST)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:ad81:d746:9fbb:b1f1])
        by smtp.googlemail.com with ESMTPSA id i3-20020a056820138300b0031c0d227905sm2821606oow.19.2022.02.26.15.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 15:02:29 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH] iwlwifi: iwlmvm: add rfkill dependency
Date:   Sat, 26 Feb 2022 15:02:19 -0800
Message-Id: <20220226230219.1869205-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IWLMVM uses symbol rfkill_soft_blocked, thus RFKILL should be a
dependency

In file included from drivers/net/wireless/intel/iwlwifi/mvm/fw.c:19:
drivers/net/wireless/intel/iwlwifi/mvm/mvm.h: In function ‘iwl_mvm_mei_set_sw_rfkill_state’:
drivers/net/wireless/intel/iwlwifi/mvm/mvm.h:2215:24: error: implicit declaration of function ‘rfkill_soft_blocked’; did you mean ‘rfkill_blocked’? [-Werror=implicit-function-declaration]
 2215 |   mvm->hw_registered ? rfkill_soft_blocked(mvm->hw->wiphy->rfkill) : false;
      |                        ^~~~~~~~~~~~~~~~~~~
      |                        rfkill_blocked
cc1: some warnings being treated as errors

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 85e704283755..64eaf8f943c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -65,6 +65,7 @@ config IWLDVM
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	select WANT_DEV_COREDUMP
+	depends on RFKILL
 	depends on MAC80211
 	help
 	  This is the driver that supports the MVM firmware. The list
-- 
2.25.1

