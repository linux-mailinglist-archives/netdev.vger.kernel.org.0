Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BBD6AF82F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjCGWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCGWDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:03:43 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D231CA42FE;
        Tue,  7 Mar 2023 14:03:41 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r18so13612708wrx.1;
        Tue, 07 Mar 2023 14:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678226620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LstyUSK2ksGKfcMC7HuMLK2ujqvPm5YfOXdsGasYESo=;
        b=JTznxaDSIZk/x2YXBJnolwCPMu+BmF5gjJWvb5/X+6iDfQzlLsf1n87VYDLy5f0UBL
         6oviJe1ukzqEdTg27I/xG1Wj5dM1N1aTMXRMXJTOxp0+fb8eL8nu840BAtMwYHaGkGFM
         vuaayvTA8HSuyDZ4L0/2WkuLk62rHpzePfwk9nr0p6GS0zq9PHUKPfqoO4ZAfAZ5sjFI
         GGQab32uW0JQLe0TCpCDmrr36ZmGjaUJgqh5OTlJNjptHQHZq6dhP23wf7iWm1+H5xj5
         SFIPeQoIKFi8jdjw0tSNKP4k8qf+ZvaVCevsPoKPkM6Lm7Rw6tcXKUkQbFSN3VNtCAbl
         Iocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678226620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LstyUSK2ksGKfcMC7HuMLK2ujqvPm5YfOXdsGasYESo=;
        b=R+KmC9WtPQ7KIGH1LB+jslf9CgZk9wmzDu31ERz1X1tE49w4TNEgRmWZrnc5IfMa80
         jd/pAJuIoIMYgEQsqTT5/l0Dhl4xuHwtL6HDwqm7GMAEYGuYzXAoMfGbX9+CtQ1JY4wW
         XADP5CPwgbDWF7/0SwD7W7F7j4H6pVUQXhbXOp8VHfdqdAA0HrunM1DpRTWuDyflUSnT
         QUHoEByCYNmkWyDXB9toU20PfAuqyz/3/8jxj8BQLtUVgfmK9VgSx0H/k/vn26jh2TYH
         CThyhqn5VEICgOA/+qcCViMQuAk0jiDxzk3kOnXHmVnOB0ixUeaprW0Vk71vJe0IqMyP
         XCfw==
X-Gm-Message-State: AO0yUKXvR0PUwTYdna8spaLnjJR/BSeuzY9R2kuh92BxpUzjSBWl7oyQ
        7wrHT2YDFJufI5j2UYjblE4=
X-Google-Smtp-Source: AK7set/r47niW5a/bUBb91PhT58/HqcU2MPuw7GZiPGUzn4bRzA0eCB9/J35AJ/YB+PF1LEk9IzelA==
X-Received: by 2002:adf:f048:0:b0:2c7:1757:3a8e with SMTP id t8-20020adff048000000b002c717573a8emr10746733wro.34.1678226619878;
        Tue, 07 Mar 2023 14:03:39 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d670d000000b002c8476dde7asm13556735wru.114.2023.03.07.14.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:03:39 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 2/2] net: dsa: mt7530: set PLL frequency only when trgmii is used
Date:   Wed,  8 Mar 2023 01:03:28 +0300
Message-Id: <20230307220328.11186-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230307220328.11186-1-arinc.unal@arinc9.com>
References: <20230307220328.11186-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

As my testing on the MCM MT7530 switch on MT7621 SoC shows, setting the PLL
frequency does not affect MII modes other than trgmii on port 5 and port 6.
So the assumption is that the operation here called "setting the PLL
frequency" actually sets the frequency of the TRGMII TX clock.

Make it so that it is set only when the trgmii mode is used.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b1a79460df0e..961306c1ac14 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
-		/* PLL frequency: 125MHz */
-		ncpo1 = 0x0c80;
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
-- 
2.37.2

