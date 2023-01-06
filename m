Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C12660289
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjAFOvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbjAFOu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:50:57 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F1392CB
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:50:55 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3712888wma.1
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vepYtZXzp7aRECpGzg/nEn+Axa+nIi9nnNK/g6d7/Tw=;
        b=VQYaQlWk9a8Zn8WFcCsr4+rwsRAYMIf4ZQqdSC1Ky4pDqHa7ClIROZ8md4xGBORKc7
         sC7Z4iwm6LF5IeGO1k2lnR7bU7iFEcLeXd5irS9wyUN1vqgzCWmrqQ82pxbwB4hCoQPt
         mw1MZfAY1Lq9LvyLpfR7vfmMBM9a63XLVC75ubWSiSqg3FzVkEFH4Euz7FKZqKrs5BpQ
         VUXiUg0tibkE4VRgcjcPrN9GA3GVJnPIzkp0UOiS+HFpUM2SGCuIqrX+K9I12++R9QPY
         bITXEWXyMECemBH3iWcd8I+vUjJ9dxTRYgrlr/AghbN4wNfPvKOtjAnmQO3pkiv2d1lb
         jjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vepYtZXzp7aRECpGzg/nEn+Axa+nIi9nnNK/g6d7/Tw=;
        b=qOelCkpu+PE/1FXJ6aFr6MLxQFBQTSJVrXt4nYpiAPtUILYmNiSee3Iv1w6oj9aivp
         yr/escwQyhrehKG2Rv4nw5fwSBAC0W3p9RLvuhX6iBr5C5gDXlenCIFJ13rhm7nupnNY
         yZcGVq4ZCGzVEJ9dIVGojGBLHqLVoNTBJ3hsrhw/JE6hbxk5WI9Wt4ORReNvP3GYTD6a
         8WVxa0LW9b93EQxpXHFvV3RT57PfWpAVm8UtZmhszeuBnipS63XG6q2oLIe+2kkiCOn+
         tnBFDCWRg+M5jb59ZyK57l8WPWBXQc7O5iqsYwtsAcHobbwTmsxI73jtWOHy+EwdXQPe
         0u3Q==
X-Gm-Message-State: AFqh2kqpIDe7lxD8m77z6QyYn2aeP5Xe0Cnn+XKDF/eZwEFfWlUMnmD1
        /OjhUCHQ00noOT5sKXS/6nm2+/6f0bhVzQ==
X-Google-Smtp-Source: AMrXdXsxfEDgGFq6sn9Hyi+adepQ/oMakMKJ20iDNU0nRPKaA0Rc7i1T71h3O3Zv5HZ5/LmFtiE6zA==
X-Received: by 2002:a05:600c:6020:b0:3d1:f0b4:8827 with SMTP id az32-20020a05600c602000b003d1f0b48827mr39099544wmb.25.1673016653966;
        Fri, 06 Jan 2023 06:50:53 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003d9dee823a3sm1135331wmq.5.2023.01.06.06.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 06:50:53 -0800 (PST)
Date:   Fri, 6 Jan 2023 17:50:50 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sanjay Hortikar <horti@google.com>
Subject: [bug report] net-forcedeth: Add internal loopback support for
 forcedeth NICs.
Message-ID: <Y7g1Skvt3d0YDHmf@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ This bug is 11 years old now but it's pretty obviously buggy so maybe
  someone wants to take a look.  I have no idea why this warning is
  only showing up now.  - dan ]

The patch e19df76a1113: "net-forcedeth: Add internal loopback support
for forcedeth NICs." from Nov 11, 2011, leads to the following Smatch
static checker warning:

drivers/net/ethernet/nvidia/forcedeth.c:4889 nv_set_loopback() warn: sleeping in atomic context
drivers/net/ethernet/nvidia/forcedeth.c:4915 nv_set_loopback() warn: sleeping in atomic context

drivers/net/ethernet/nvidia/forcedeth.c
    4874 static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
    4875 {
    4876         struct fe_priv *np = netdev_priv(dev);
    4877         unsigned long flags;
    4878         u32 miicontrol;
    4879         int err, retval = 0;
    4880 
    4881         spin_lock_irqsave(&np->lock, flags);
                 ^^^^^^^^^^^^^^^^^
Holding a spin lock.

    4882         miicontrol = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
    4883         if (features & NETIF_F_LOOPBACK) {
    4884                 if (miicontrol & BMCR_LOOPBACK) {
    4885                         spin_unlock_irqrestore(&np->lock, flags);
    4886                         netdev_info(dev, "Loopback already enabled\n");
    4887                         return 0;
    4888                 }
--> 4889                 nv_disable_irq(dev);

You can't call disable_irq() with preempt disabled.

    4890                 /* Turn on loopback mode */
    4891                 miicontrol |= BMCR_LOOPBACK | BMCR_FULLDPLX | BMCR_SPEED1000;
    4892                 err = mii_rw(dev, np->phyaddr, MII_BMCR, miicontrol);
    4893                 if (err) {
    4894                         retval = PHY_ERROR;
    4895                         spin_unlock_irqrestore(&np->lock, flags);
    4896                         phy_init(dev);
    4897                 } else {
    4898                         if (netif_running(dev)) {
    4899                                 /* Force 1000 Mbps full-duplex */
    4900                                 nv_force_linkspeed(dev, NVREG_LINKSPEED_1000,
    4901                                                                          1);
    4902                                 /* Force link up */
    4903                                 netif_carrier_on(dev);
    4904                         }
    4905                         spin_unlock_irqrestore(&np->lock, flags);
    4906                         netdev_info(dev,
    4907                                 "Internal PHY loopback mode enabled.\n");
    4908                 }
    4909         } else {
    4910                 if (!(miicontrol & BMCR_LOOPBACK)) {
    4911                         spin_unlock_irqrestore(&np->lock, flags);
    4912                         netdev_info(dev, "Loopback already disabled\n");
    4913                         return 0;
    4914                 }
    4915                 nv_disable_irq(dev);

Same.

    4916                 /* Turn off loopback */
    4917                 spin_unlock_irqrestore(&np->lock, flags);
    4918                 netdev_info(dev, "Internal PHY loopback mode disabled.\n");
    4919                 phy_init(dev);
    4920         }
    4921         msleep(500);
    4922         spin_lock_irqsave(&np->lock, flags);
    4923         nv_enable_irq(dev);
    4924         spin_unlock_irqrestore(&np->lock, flags);
    4925 
    4926         return retval;
    4927 }

regards,
dan carpenter
