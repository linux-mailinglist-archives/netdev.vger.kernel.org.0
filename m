Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A96B54D4CA
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350452AbiFOWvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349840AbiFOWvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:51:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213E45640D
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:51:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w27so18215110edl.7
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tPsP8lL9NuXNrNI5NEN8Nvv2AZwUgDAprPUJsytkX4Q=;
        b=NcSgiVPdPKjLcBoPu9yqS5k5D/0TkxyvnlV4DWpuVcmi/omtnGP4bwkaF5leTdeyEw
         rIxlHryw5qgyoPRsUeIy/0cv1c4bQpKgg2KbZc3x7L7EqBIF8Rvsf5BRtn5UFm5GXCHH
         iMU2yO+bNsOq4fWQ6kg4PX2qMRJk+Z9wChrdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tPsP8lL9NuXNrNI5NEN8Nvv2AZwUgDAprPUJsytkX4Q=;
        b=I/0woQjxfuWkWA4lsY/5mfPBU/FH43mjRk2rJeXW4hmwCjTIjuK4ff/sEAMlW20J7B
         HB8ANvFWHFKop6PUFE5QFl4KiUSk52gjygpTWRvprjmNzp9ZINiqSNvWFqMk2FMYhoVc
         cBzHXh+p7JzZt3GnX6c3ACI1L+KVs7MfU3ddvA5bD6Qy4gidO0O6NJ5b0bDakIkXlLWO
         ZVNfbwWis1BiIoPX/l7Fh05bil1BNfdKzA+dPOu0JdmlbboF3L/IKPOMSbSZZTNlqqsR
         FLg2G1EH97knMEuaHOci5G/I3nXbSvZZ9j/ne8yzSopV0xG/GwG9GPyB5vHOfI/iIfwB
         4RfA==
X-Gm-Message-State: AJIora94pkFWWEttn3/yBYS7FPbbHU98vGw6XQMR9ps5RCO4kJLewYEr
        ks90Ba5kbLiAbBvqplJJDCPwdw==
X-Google-Smtp-Source: AGRyM1uI8mzkAgmDLu3URMLN1Jch/JNWM4zKs9Nweb9iNAe3IEGO0BL+83LBx/9MsNAeOthHpP2uJg==
X-Received: by 2002:a05:6402:2381:b0:42d:c8fe:d7fe with SMTP id j1-20020a056402238100b0042dc8fed7femr2695591eda.248.1655333486710;
        Wed, 15 Jun 2022 15:51:26 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h23-20020aa7c617000000b0042e21f8c412sm371506edq.42.2022.06.15.15.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:51:25 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/5] net: dsa: realtek: rtl8365mb: improve handling of PHY modes
Date:   Thu, 16 Jun 2022 00:51:10 +0200
Message-Id: <20220615225116.432283-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This series introduces some minor cleanup of the driver and improves the
handling of PHY interface modes to break the assumption that CPU ports
are always over an external interface, and the assumption that user
ports are always using an internal PHY.

Changes v2 -> v3:

 - rebased on net-next

 - no code change

 - patch 5: reworded the last paragraph based on Russel's feedback;
   hopefully it is clear now that my intent is just to fix the
   semantics, and that the new "feature" of treating ports with external
   interfaces as user ports, or ports with internal PHY as CPU ports, is
   just a side-effect of this fix - I make no claim as to the utility of
   such configurations and just note that they are permissible as far as
   the hardware is concerned

 - patch 5: added Luiz and Russel's Acked-by

Changes v1 -> v2:

 - patches 1-4: no code change

 - add Luiz' reviewed-by to some of the patches

 - patch 5: put the chip_infos into a static array and get rid of the
   switch in the detect function; also remove the macros for various
   chip ID/versions and embed them directly into the array

 - patch 5: use array of size 3 rather than flexible array for extints
   in the chip_info struct; gcc complained about initialization of
   flexible array members in a nested context, and anyway, we know that
   the max number of external interfaces is 3


Alvin Šipraga (5):
  net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
  net: dsa: realtek: rtl8365mb: remove port_mask private data member
  net: dsa: realtek: rtl8365mb: correct the max number of ports
  net: dsa: realtek: rtl8365mb: remove learn_limit_max private data
    member
  net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly

 drivers/net/dsa/realtek/rtl8365mb.c | 299 ++++++++++++++++------------
 1 file changed, 177 insertions(+), 122 deletions(-)

-- 
2.36.1

