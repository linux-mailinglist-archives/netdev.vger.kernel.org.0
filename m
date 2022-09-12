Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911AE5B55B6
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiILIIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 04:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiILIIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 04:08:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF628E29
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 01:08:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 9so7809767plj.11
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 01:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=pY3PEbiyJD1wlLqK+op8vAenQPbd+RIV3Kd0VGnjuCU=;
        b=P8rll1ZPT+Q40bFf1VxNzBBShtQCugewK26J/ynPtXQx2CC9MuEcxf2g5UTc8H8m2j
         Vok1rknEXcsHc88hvhFR5xaLy5H9LjwLzYgEF2/6oGgHLu8kdc7PGjW81PvpkCjqz/b+
         nVpce6ZD1xm2nfSbeRGIbR/DyxUl1meu1LCsVxqXLCnhpCTVQLXAZjAdoJnNqee4QB1E
         anNZ76zVLwN3E9C+WM8wuevM10+unVPxyltjHvlFmVdoQhofrsvxaTVzU1BlD5LC7IgR
         rT79xYqXq2JTGaB59bqy+wVtGlCbRfc2UZ7RQ1IkPXdoBJmVdbiG3pgglvXg6rJkWZnJ
         UF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=pY3PEbiyJD1wlLqK+op8vAenQPbd+RIV3Kd0VGnjuCU=;
        b=0KRnYh+UzDm3nqEQfN8orBfKxOxk6rVGrpamgn55gWR9MZBSFMdFSO7X8UYNMKTDtV
         Bazfnwzeg0cyzD3fdjx4FMXPuIdPASO0nWsRLq0oaMa/uLMIyfOAOejfblHKXXE6UKW8
         dm8hXRkhqUOlXY/WutzcvjfvCXn4G2OfRkbnipEkUPcuEwoi/bYXiaBYon4oDFKeEVVg
         1ZsBZqV+b5uJi9lcaRKmhAG/fXOMEoFUFZAe4eVHsBjNX52akNWKYO9ly3sdh2OqclnL
         3VjqKiUDOMDs/UmEf2n4oTrFtTT+zqx8PiSrp9pSKRfw/O1VVXiAZayjbtffx2U8UONz
         ZQ/g==
X-Gm-Message-State: ACgBeo16n8GyvX8TjtPLbSAFaF7P/pUgudvT0xViv+2McuDYkhVKioLc
        m7j4EpNjp8WN6GSFxBgq2dE=
X-Google-Smtp-Source: AA6agR4bZnF2C75Z+BS+J3pT04ibQ4MEHDk2oiLbYGP9BAz/Gi1BD+CioLSFT72D8voFfzLwFKVirA==
X-Received: by 2002:a17:90b:4b43:b0:202:e09c:664d with SMTP id mi3-20020a17090b4b4300b00202e09c664dmr1650360pjb.120.1662970084974;
        Mon, 12 Sep 2022 01:08:04 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t14-20020aa7946e000000b00540dbae6272sm4668903pfq.213.2022.09.12.01.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 01:08:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.panda@zte.com.cn
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2 linux-next] net: dsa: microchip: remove the unneeded result variable
Date:   Mon, 12 Sep 2022 08:07:41 +0000
Message-Id: <20220912080740.17542-1-xu.panda@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Xu Panda <xu.panda@zte.com.cn>

Return the value ksz_get_xmii() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
---
 drivers/net/dsa/microchip/ksz9477.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 42d7e4c12459..ab7245b24493 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -884,7 +884,6 @@ void ksz9477_port_mirror_del(struct ksz_device *dev, int port,

 static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 {
-       phy_interface_t interface;
        bool gbit;

        if (dev->info->internal_phy[port])
@@ -892,9 +891,7 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)

        gbit = ksz_get_gbit(dev, port);

-       interface = ksz_get_xmii(dev, port, gbit);
-
-       return interface;
+       return ksz_get_xmii(dev, port, gbit);
 }

 static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
-- 
2.15.2

