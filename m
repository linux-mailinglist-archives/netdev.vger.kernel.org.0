Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9547A62D1D9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiKQDsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiKQDr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:47:59 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14EF6443
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:47:58 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id k22so559701pfd.3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=95URDCT2lDefEfxFaVoJRtX62WLacL7D+5K3Cyu98Jc=;
        b=X9zElDDV3y7nK9fqSmtJMXmlfj60pW0dGEPPsFGiBdzi+H0osoovNbKhHg4/9CAdVV
         J1tEL77jotYUOWgOpA7wVm7DkiElTovf+T/pKkj77f4JQxC2Ss/UVl5qx3cWI4OgoX3j
         0rPys2wDKdJzeoLn1iRzZxWwU8sHEW35puA8Tiyl13ZvDgsNsaQ4g4RfS1WeHyQxyy6L
         5hXQlPsHpFqboGqOmtsHaCaM42E8Yx9JPV6bJoQ1ZflWmFyfm0tJcRe7kwowWD59iA5o
         0eHIg9ngQEJcsnqecDDjyE1MMmjeS+O5FvNg+DDmwp3TEd0J+6hhBIkrqza46OBEY0Yc
         T+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=95URDCT2lDefEfxFaVoJRtX62WLacL7D+5K3Cyu98Jc=;
        b=GCC2WG3Q+Fooy3gjwRNRZUL5RzzQI10I4whWLIB9ggRs96103tKZh449YvyAL+nvPz
         Iv/rbwEsq5cr+gJWYrZsXjMLAe1h/EaZI2AGq8kB2O3w9g08Qh6Iyeek1glWR5jlv50O
         55JJcatOmoeBxe6VW/x3MYmzcPLT3CEW1VAZbotX4QLUWaOT/m8j32pI3jmZzUBfKKTi
         OeSPjS+tOKti6RRnMPOwOM06stQOl5Glkh1slq4fof43/HsnLf53e85g9qF5kZeDu6rR
         TaTT0vPWVoncvETXq/GQZajhRc8kjxGT+cOSzv1gmjZyKAd5EFs4Ha2us8wCOswrmknY
         iSVw==
X-Gm-Message-State: ANoB5plrCxMM2O0mlCj/Wq/QA9jRqrtX3A9VPg85SGAChhGDR/FfzJ4S
        TZua8X0wmTrbaxFuaCzZb8XHaL+7BC/4omdC
X-Google-Smtp-Source: AA0mqf45ZcoHgF4WpjFiGeCB2xs37Y0wkNJ+WItebNQ28OYbpBa+wiAM7jxfj0J3mwuHt7ilmLtUPA==
X-Received: by 2002:a63:2443:0:b0:43c:e6cd:a9e4 with SMTP id k64-20020a632443000000b0043ce6cda9e4mr346241pgk.546.1668656878223;
        Wed, 16 Nov 2022 19:47:58 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b00187197c499asm13016723plb.164.2022.11.16.19.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:47:57 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v4 net-next 0/3] net: axienet: Use a DT property to configure frequency of the MDIO bus
Date:   Thu, 17 Nov 2022 11:47:48 +0800
Message-Id: <20221117034751.1347105-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
MHz. Thus, we use a DT property, which is "clock-frequency", to work
with it at boot time. The default 2.5 MHz would be set if the property
is not pressent. Also, factor out mdio enable/disable functions due to
the api change since 253761a0e61b7.

Changelog:
--- v4 ---
1. change MAX_MDIO_FREQ to DEFAULT_MDIO_FREQ as suggested by Andrew.
--- v3 RESEND ---
1. Repost the exact same patch again
--- v3 ---
1. Fix coding style, and make probing of the driver fail if MDC overflow
--- v2 ---
1. Use clock-frequency, as defined in mdio.yaml, to configure MDIO
   clock.
2. Only print out frequency if it is set to a non-standard value.
3. Reduce the scope of axienet_mdio_enable and remove
   axienet_mdio_disable because no one really uses it anymore.

Andy Chiu (3):
  net: axienet: Unexport and remove unused mdio functions
  net: axienet: set mdio clock according to bus-frequency
  dt-bindings: describe the support of "clock-frequency" in mdio

 .../bindings/net/xilinx_axienet.txt           |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 -
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 59 +++++++++++--------
 3 files changed, 35 insertions(+), 28 deletions(-)

-- 
2.36.0

