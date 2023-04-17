Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FBD6E3F02
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDQFfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjDQFfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:35:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975863AB3;
        Sun, 16 Apr 2023 22:35:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f09b9ac51dso31291085e9.0;
        Sun, 16 Apr 2023 22:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681709713; x=1684301713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FadWt38WGO4vXm/W7f5aEcrISxPNQCco0eon5sbunr0=;
        b=ozx3sXmqzkUb4Er7YXFYEhhyOFgs6z298J3dgVIc7eGJV5EXRtW7aS0Vm3QRHWkfq9
         qAjUAYXQ2W+GJJb3ps69heR9Aiw+OuqgRHWMOM/gMBHuGVEDUVoS9LNDRX+icxN/TyGl
         sbL7vBADzK8cNY1knOolsMF9Zy9uFUgf927jE/EQm7lGobqqy/6G3dnxut76p+V67hyb
         hIaqeAm/on4WFE93AytPaZ9KrS7o4z2mvWFJgV5afU5xQ9HnBJPw40DWYMJdqZpTJTwr
         Pa1zts6qtY+nvCFQnuDlMu3aF6CFSIAQDIry5Wx86uik5MEuYizhy0JBClsVb6xZz34K
         1gbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709713; x=1684301713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FadWt38WGO4vXm/W7f5aEcrISxPNQCco0eon5sbunr0=;
        b=Aii5JGhSeZ7C+G4f2aTAMxCjgnofugaVkYnHly4iLA8/n5eztvMEaZM1XKsoHpcO0r
         tFdSB4Sh+O6pwIwJxZ13bmdZ+4sQJG9xtATaCtCOEzmz87DRdYCwt9puSRwwSumwu7Wf
         wZFTORk89Bs294ubRj8e4C/Pz2GvTRrP1cFsnPVnBgcff8hAEcgR4gqEK62iD19L6imY
         PEw+bpopq0eEQ7hqqUjE2+wscMkKMT+F+encXgEeQa65/L5hdVrs0T76/74oR6ykMOjv
         NuIBoVbi30wo3QLCS6keaJkUWpDS0W7BnQTWeXPodk39JnIFy127z16YZttayn6LkJnS
         gRjg==
X-Gm-Message-State: AAQBX9fznaBMGQ2l4uhll3emyC9NK2vEi2V+yOPJMI9DbW/M6QiOoAFk
        pe0OOgwSA55rfsvKyiBMhDA=
X-Google-Smtp-Source: AKy350aaZQjKKe/3vjhnyqB0H91U3ThoF9tZhKLwrqPfl1kyAAXIP597JUCAKbDfrVFbO+pEeDIhMw==
X-Received: by 2002:a5d:4d8b:0:b0:2f1:b74:5d8a with SMTP id b11-20020a5d4d8b000000b002f10b745d8amr4388937wru.5.1681709712882;
        Sun, 16 Apr 2023 22:35:12 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d6810000000b002e5ff05765esm9632493wru.73.2023.04.16.22.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 22:35:12 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 0/2] ath9k: of_init: add endian check
Date:   Mon, 17 Apr 2023 07:35:07 +0200
Message-Id: <20230417053509.4808-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Add new endian check flag to allow checking the endianness of EEPROM and swap
its values if needed.
This flag was already present on ath9k_platform_data as "endian_check".

For compatibility with current devices the AH_NO_EEP_SWAP flag will be
activated only when qca,endian-check isn't present in the device tree.
This is because some devices have the magic values swapped but not the actual
EEPROM data, so activating the flag for those devices will break them.

Álvaro Fernández Rojas (2):
  dt-bindings: net: wireless: ath9k: document endian check
  ath9k: fix calibration data endianness

 .../devicetree/bindings/net/wireless/qca,ath9k.yaml          | 5 +++++
 drivers/net/wireless/ath/ath9k/init.c                        | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.30.2

