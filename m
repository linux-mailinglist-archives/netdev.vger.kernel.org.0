Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAC5E870E
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiIXBxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiIXBxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:44 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBDF106F45;
        Fri, 23 Sep 2022 18:53:43 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q11so1155272qkc.12;
        Fri, 23 Sep 2022 18:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=/oRwLC7FHOemWzoqeif26ioyvFSvS3lvtQTXdIA2m2g=;
        b=S1kR5nIIy53QQZ9FbFh1NLPLScYNfv3BI7sEeCLIElBFmwIMDtOc/54jUFm1aCyxtH
         ptCVy6vOQvtgWuqKdoe/P5BLxynHTWIUbbIgAPPLn3aewqDVoum92/oABQuecvuE71r7
         226y/XpUBpftwVRt/L3mDqT5XigRnPTvoUmYsowBC8fEGURTh3SkuNs33G+vFy83anKh
         XEc0NiL6JWjNZnMOkEV/xo0oVTgMtTyk9yE63DqPL5qrrDChaQvNAy9fVcughvq8fXf9
         ic68gnK3js/Xxig138SPK1eDKaBA9asRH5YF3iH9nCiBBHHJcx7ybkESAYH4I5SgwaRW
         fStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=/oRwLC7FHOemWzoqeif26ioyvFSvS3lvtQTXdIA2m2g=;
        b=BuzKB44CiraaRlttidK6bUk0DagrnheNRTXFOWrHV+I3X5hXIFIr0GrqSVNMkjkznr
         61qTxIyyanXud/LleT3SIThuq22ZPhEQz+rTbS85vpQwumM6YIQLU8BYxfkkHthZ+mcR
         0lxab73AAGQAXxAIyyKCl2CfozekVwaw42e3Iv6yDwdAEec3yBxE431/flb8l9LnhBEq
         kubfVCPFUME6JmDWP2AxK6lO9toBwZQm1/teqvQ26SKMOL/gpNPJwBQ46/trY2HCfg90
         gow0Dv/KgWhdnMtEiJ2VtasCFc+oIGNHrJxNitdRMXWUX6Ir/t25sdjW6iCExQnJeKkO
         nomw==
X-Gm-Message-State: ACrzQf0jlpq/dUXanDfaxWVtu26ND83+NCvKk2osNzR9ncdcIS9kF5Tu
        VJacnWQIpqo0VqjiuwijHDB67Apr/jCLNw==
X-Google-Smtp-Source: AMsMyM5Rd03jIH8TutldOZ7kjUfXJbFeO/d6F0uAyb4WrWVzENsY/rKZf8fsat7mlIUSvDxgAOP4Sw==
X-Received: by 2002:a05:620a:472b:b0:6ce:6189:74f5 with SMTP id bs43-20020a05620a472b00b006ce618974f5mr7708571qkb.455.1663984422554;
        Fri, 23 Sep 2022 18:53:42 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id d18-20020ac851d2000000b00342fa1f4a10sm6395573qtn.61.2022.09.23.18.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:41 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 00/13] net: sunhme: Cleanups and logging improvements
Date:   Fri, 23 Sep 2022 21:53:26 -0400
Message-Id: <20220924015339.1816744-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
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

This series is a continuation of [1] with a focus on logging improvements (in
the style of commit b11e5f6a3a5c ("net: sunhme: output link status with a single
print.")). I have included several of Rolf's patches in the series where
appropriate (with slight modifications). After this series is applied, many more
messages from this driver will come with driver/device information.
Additionally, most messages (especially debug messages) have been condensed onto
one line (as KERN_CONT messages get split).

[1] https://lore.kernel.org/netdev/4686583.GXAFRqVoOG@eto.sf-tec.de/

Changes in v2:
- Remove space after pci_enable_device
- Use memset to clear p->happy_meals
- Set err inside error branches
- sumhme -> sunhme
- Remove repeated newline
- Remove another excess debug

Rolf Eike Beer (3):
  sunhme: remove unused tx_dump_ring()
  sunhme: forward the error code from pci_enable_device()
  sunhme: switch to devres

Sean Anderson (10):
  sunhme: Remove version
  sunhme: Return an ERR_PTR from quattro_pci_find
  sunhme: Regularize probe errors
  sunhme: Convert FOO((...)) to FOO(...)
  sunhme: Clean up debug infrastructure
  sunhme: Convert printk(KERN_FOO ...) to pr_foo(...)
  sunhme: Use (net)dev_foo wherever possible
  sunhme: Combine continued messages
  sunhme: Use vdbg for spam-y prints
  sunhme: Add myself as a maintainer

 MAINTAINERS                       |   5 +
 drivers/net/ethernet/sun/sunhme.c | 661 ++++++++++++------------------
 2 files changed, 264 insertions(+), 402 deletions(-)

-- 
2.37.1

