Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6428159E5F3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242936AbiHWP0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242977AbiHWP0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:26:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E08B0B33
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:02:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t5so17515769edc.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=wEV4a23LcuQgLkfvwoVqRTSnOTkcDQpJiVnddGQ+rt0=;
        b=khASXZn7n0ZFnheyw16kqBWhgjt+5KBCsaBALhowJSHl3ypTulEK2z6efBhxe4lhc9
         gFIAfN5jxKSFi7MVxIhmWpRaPIGs5gUbC0H9XpXsXtsAw4LykgzNAQKe0Ob9b/IsY1Sf
         Gz1V7WSKHpwHFoaoumESn66E/WLb27dyldY24AJ7kPbN0Efd/NcJ+p1J/WkP58BRk/dF
         HDvQUfTaTbRniiWze59zYi9n57PJoaNVQuYPdY9GMe0mjwHexP+RnWOINADMBWNq7qVI
         hxPdk3J+VskVqe/I2hlGM2bi+AAXIZnpijiPLWH+6HiGD3lJD/XAcwVdYEdDJK7shxKt
         fEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=wEV4a23LcuQgLkfvwoVqRTSnOTkcDQpJiVnddGQ+rt0=;
        b=eoZ+hpmmiMNeId/6RSntm4LqnU4eE5ynUEEy/Rg7bhf3FRKj01iJ9TCc142At1CGLf
         DiJVx9CPrRzpuc9Qac50vxYenUHG9neAlV9ywtMMJ0KVkHRRV8DCcQKVh2qfrAIghsbt
         OzHyME7FXIcAIoV//nBExHuXnb4Hk07uRFPb7b0bH2YAajuOFADiSmnQZ8Im8Q+T0yRv
         wFe/gey0oZyPkM14vNfs9lcy/Ht7EPUh7jq9MZfXTVhRVaJZVaKWE5ALdCo7N69FmO1I
         OB4AZ1sCjhi9qCAYDCD2KBEVvE+tSjvJBPZ0o6JbLmUmpnzcX7ziwOAN0b4Ib9zQi/jP
         s3Dw==
X-Gm-Message-State: ACgBeo3rIJNbJzhr/ecn9u4H9ITxmgUl74ZmjSbmoCuoLzVKBuevh04W
        OidsYK5g0Pk+dzmy5ArBtw0=
X-Google-Smtp-Source: AA6agR7ESewxyjpWjL4YuT0AElP8P09vHxMopRpl1d27A+A7cmlyf5U5Mhfgzxfawfq3clMc7M3ouA==
X-Received: by 2002:a05:6402:538b:b0:446:34f:2232 with SMTP id ew11-20020a056402538b00b00446034f2232mr3102689edb.4.1661252521945;
        Tue, 23 Aug 2022 04:02:01 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id d6-20020a50fb06000000b0043a5bcf80a2sm1221615edq.60.2022.08.23.04.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:02:01 -0700 (PDT)
Message-ID: <ceb7b283-a41a-6c7d-1b63-7909da2c8a7a@gmail.com>
Date:   Tue, 23 Aug 2022 13:01:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/5] r8169: remove support for few unused chip
 versions
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of chip versions that apparently never made it to the
mass market. Detection of these chip versions has been disabled for
few kernel versions now and nobody complained. Therefore remove
support for these chip versions.

Heiner Kallweit (5):
  r8169: remove support for chip version 41
  r8169: remove support for chip versions 45 and 47
  r8169: remove support for chip version 49
  r8169: remove support for chip version 50
  r8169: remove support for chip version 60

v2:
- fix a typo in patch 3

 drivers/net/ethernet/realtek/r8169.h          |  12 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 124 ++---------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 130 ------------------
 3 files changed, 18 insertions(+), 248 deletions(-)

-- 
2.37.2

