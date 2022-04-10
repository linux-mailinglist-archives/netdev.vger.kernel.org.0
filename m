Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8874FAD4D
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiDJKss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiDJKsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:48:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AE64D273
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:46:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so18923283wrg.12
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZv4SoiVBPqkJ4eqcXUczG9IvaqJVuybUzUbBs8pwz4=;
        b=gvDwEjiUKlgr2MTUmFsUukas8sXSTcqVwqII4lh+Gh1ATw9msUrNdIUqcUrdP7l5Uw
         o0fAtgcwKb78z48yBEgyyO9lt/3qLjiTdh7SZ8qXx6k++GwTeXlmwdzwun6ySfD6P5lN
         0tPwr7VxaEDuwcfZbds5qRh7T+dmq61rgn39nDvdX5Gx13GvhZ/dJAA8HoIHyv3EM5BD
         exCkowhNw+aZ3nQLf4kwVaetbPJEZvSblMmTye3lLqp5Wp4X9lBuP3OSt29PjafWHsyj
         +eysPzn+jhKsvMWuiF9vxKqHxLEga5Usb+xbDW0CD7jFDwcz4jnRHXcczKnkWqHPoY5t
         mstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZv4SoiVBPqkJ4eqcXUczG9IvaqJVuybUzUbBs8pwz4=;
        b=ZaXYt8pR6dFtz9Y/JPMMDTA1Gl406t0xvzP/P7Sb0dezaenNKP4uaPggDzwNclnrkH
         EAd7HbJHWM4eF3e4eRuvFQ23Nv1oCxJrogESaFt7hwdi4hmhBpbYmZc49T1AS2iWH6x8
         ZoHpstbKdReAHPFaaR3MMmhqyKQZ0Ayv0h34Q4AVxn7v+6U3XVioNuEN0x7Rc3DYEGH9
         QQAO51KOk8lCqhd3q4ENFPGNnjm0bD9oK4ygkrcKMNFAWYh8TUQg2tsGyhiUUD/qrxFM
         WkBDLJFKJPjOnHjVO1xeGzkm6DdQD4VSXfguA/SGqZ+QVK3LPM/w8jJq9gNi4++K+XRg
         1vnw==
X-Gm-Message-State: AOAM533tEqP1yQ8xxtEaXEZRViwGW1qq+Asyaia8q/v+UXZa7dZV344C
        FwUgZ9EudxXD7c73bKyQWzZpwrffdD0gGd1iNWs=
X-Google-Smtp-Source: ABdhPJwm5GDuawhJhcIyhSApqv+Ny2tEx0JZ6xmKGGHf/XE0mMp8OpCZ67fPY/MiZNCkipeYeg+HAg==
X-Received: by 2002:a05:6000:1b01:b0:207:98bc:5d3c with SMTP id f1-20020a0560001b0100b0020798bc5d3cmr8521689wrz.427.1649587595934;
        Sun, 10 Apr 2022 03:46:35 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020784359295sm12839196wri.54.2022.04.10.03.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 03:46:35 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>
Subject: [PATCH 0/3] adin: add support for 125MHz clk-out
Date:   Sun, 10 Apr 2022 13:46:23 +0300
Message-Id: <20220410104626.11517-1-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for enabling a 125MHz reference clock output
to the adin 1300 driver.
Finally this clock output is used to add support for SolidRun i.MX6 SoMs
revision 1.9 and later, which have replaced the original ethernet phy with an
adin 1300.

Josua Mayer (3):
  dt: adin: document clk-out property
  net: phy: adin: add support for 125MHz clk-out
  ARM: dts: imx6qdl-sr-som: update phy configuration for som revision
    1.9

 .../devicetree/bindings/net/adi,adin.yaml     |  5 ++++
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         |  6 ++++
 drivers/net/phy/adin.c                        | 30 +++++++++++++++++++
 3 files changed, 41 insertions(+)

-- 
2.34.1

