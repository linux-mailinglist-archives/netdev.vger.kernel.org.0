Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3236BFCBB
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 21:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCRUaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 16:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCRUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 16:30:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC012CFFB
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:30:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eg48so32758912edb.13
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679171407;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoJ8JNTe6wgzO9Cu9r3XRL6EXOxlsCLor10dstEGt+M=;
        b=g40b3H0zZRAvEDmN5gsozoaCZe0pVY4ujMUgn3wY3DyQEOiSq+vLjbllc5GdtmBTFA
         MZsS3K3shYab31Arp5ZYn4DA0annOnjFXni8CTSdVf/nU1oWb1z0x9LfF3o2JxHC6Qpv
         1IfpzXMSyNIp12BQGEu61tKLwNqbdfmlcdTDOCHzlqVpND6baRMTsNHodiskrOE9bM07
         kBwR/HMK8/nVTe16Cz0oETvhhVygtHAXploBmLpGE86bn+I/wC+x5F2tEx8zi5tlxg0k
         WRSW7+shSNFtFLxp4em2qpha18akYK3yjKSmF/51wX9BCYYzG/iv60oNnE3k8/w4e9kT
         IrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679171407;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IoJ8JNTe6wgzO9Cu9r3XRL6EXOxlsCLor10dstEGt+M=;
        b=37mHq7KgEw5wNLY/dZnkx/3BtHdfMfhtyPnBskyjST6PQ5tGCKObNq9JwaBQ36HjB+
         iZFuRLlZ0bjtxSIMc5R1pH8FdIC/ut93gDKY8/tz/rhxSnEES+NpkpDgwqWPY8h16Iwl
         VyK2hxKb2AeLL0J0i5hQco3SXyh5YMJ3DhwL8Bm05QlrWFTDu9neb8MbvZQMfrLpxBds
         NXKh9tkU5cZnjfooDPmEPMQUG0nZ4KJCwFzZNFuPzHovfn8ZldwQDK2MukjmdghivTQd
         rdAVmBrXMlyiSBnCzEy8nJyAWBPMSAz/oKFSuSpz+/+kCqBVkQPY3YH2xOJDbTfl+g4z
         nDEA==
X-Gm-Message-State: AO0yUKWj0kyWkg3gM/pqu6TkR1HrGKD6i4HFBFcc3M+mqlfA7g8FFg3n
        JjLZ0HNF5ruqiZfwSpvSXJ4=
X-Google-Smtp-Source: AK7set8mzwG6ka99OP8sVaSJIO9h9mx6jh7tIi2qCJ2AQYcsP0HbNRYMiw2o2YIYLWA+0Cv4dLCPEg==
X-Received: by 2002:a17:907:b9d0:b0:88a:2e57:9813 with SMTP id xa16-20020a170907b9d000b0088a2e579813mr4915106ejc.33.1679171407449;
        Sat, 18 Mar 2023 13:30:07 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c073:a00:b51a:ddab:12c0:b88a? (dynamic-2a01-0c23-c073-0a00-b51a-ddab-12c0-b88a.c23.pool.telefonica.de. [2a01:c23:c073:a00:b51a:ddab:12c0:b88a])
        by smtp.googlemail.com with ESMTPSA id j30-20020a508a9e000000b004af5968cb3bsm2734039edj.17.2023.03.18.13.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 13:30:06 -0700 (PDT)
Message-ID: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
Date:   Sat, 18 Mar 2023 21:30:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: reuse SMSC PHY driver functionality in
 the meson-gxl PHY driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic Meson internal PHY's have the same register layout as
certain SMSC PHY's (also for non-c22-standard registers). This seems
to be more than just coincidence. Apparently they also need the same
workaround for EDPD mode (energy detect power down). Therefore let's
reuse SMSC PHY driver functionality in the meson-gxl PHY driver.

Heiner Kallweit (2):
  net: phy: smsc: export functions for use by meson-gxl PHY driver
  net: phy: meson-gxl: reuse functionality of the SMSC PHY driver

 drivers/net/phy/Kconfig     |  1 +
 drivers/net/phy/meson-gxl.c | 77 ++++---------------------------------
 drivers/net/phy/smsc.c      | 20 ++++++----
 include/linux/smscphy.h     |  6 +++
 4 files changed, 28 insertions(+), 76 deletions(-)

-- 
2.39.2

