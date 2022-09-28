Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CEE5EE1A4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiI1QTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiI1QRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:17:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C16D62D8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:17:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 88so624883pjz.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=LQ10POWj0cCCBLMI2b+lJId+PkMKUj+beDmXXmAzidE=;
        b=S7LDlspSHIsZg5kPxitx8flMKG0TP6lKyuD0YJNo7xKfsMTksPBMWa82Wngz8A0JwW
         htaAWhjqB2LDCB26/j+A4V+dMiYIMNH36j88QoTTUZajWVntR1rWLTDp6otbr8frY7cC
         i0AkeaKW45kVquQPB5vKUdj6Pe/gPBqbpQXseysam8dIcgEuFCwVCYEUTmhJiwbZkjmk
         4t8dr3jk5SSA/mLFiCo9Ye4VcB+788VVRdEWyzLMp1ltX3Unh1SeOcZVMl+hzrOSKj3e
         N4B30+3uSnqaPP3gvQ7gab2xXcdDF8BmEg6eMHtPLqnUs0I7Gb+4yw1yypi2gjIbTATB
         VDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=LQ10POWj0cCCBLMI2b+lJId+PkMKUj+beDmXXmAzidE=;
        b=GSITK94RC04bsfbc8tL47jENQiINN13pgvcyldgJ0okV6279UngIsAiiTI3vKfnrgJ
         x7pVcxmJBAufV2q+U87UbDlgleOFHOXKa/34WlOJPUQDRbQTrhnIt7/DtXHJxHmNk/AL
         Ci7EjPnDbyVvpLhZ4uVPPPm4X/W3f2ERICAy6vH+R0lemdAgiXsSAXLv0lpRHcADoEju
         crmPNTVyxQvhYHbvrd66vibuTr8+UAuUBVY7ufvsbobKWpLONfVGCtAdc/0A0o0KG2zu
         zhzuXc1POUGCP8+LJmwYLK+nT49auyifs0Y1MWzZOVCf5JnFIGJ3BzOYfbbfsOLNAyqa
         Cxlw==
X-Gm-Message-State: ACrzQf1SqkNEcUMZCvS7R2YQTMR3XMQz4JWeCVGMK99HOS81TQsOb9Da
        RC+oYaUmuUhIdcNetRWaAbGcUIzvobQQsA65
X-Google-Smtp-Source: AMsMyM7jpAo09DNZNFHTrpCxLEANyvfEkchZJbqpXRusEDKRP5HFoZsjQNMdWISU3SRl8RwVfFgv3w==
X-Received: by 2002:a17:902:d588:b0:17a:487:ff99 with SMTP id k8-20020a170902d58800b0017a0487ff99mr600907plh.44.1664381868193;
        Wed, 28 Sep 2022 09:17:48 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902f64500b001769cfa5cd4sm3912010plg.49.2022.09.28.09.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:17:47 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     skhan@linuxfoundation.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next v2] net: remove unused netdev_unregistering()
Date:   Thu, 29 Sep 2022 01:17:40 +0900
Message-Id: <20220928161740.1267-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
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

A helper function which is netdev_unregistering on nedevice.h is 
no loger used. Thus, netdev_unregistering removes from netdevice.h.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
v2:                                                                             
 - v1 link : https://lore.kernel.org/netdev/20220923160937.1912-1-claudiajkang@gmail.com/
 - Remove netdev_unregistering(). 

 include/linux/netdevice.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..66d10bcaa6f8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5100,11 +5100,6 @@ static inline const char *netdev_name(const struct net_device *dev)
 	return dev->name;
 }
 
-static inline bool netdev_unregistering(const struct net_device *dev)
-{
-	return dev->reg_state == NETREG_UNREGISTERING;
-}
-
 static inline const char *netdev_reg_state(const struct net_device *dev)
 {
 	switch (dev->reg_state) {
-- 
2.34.1

