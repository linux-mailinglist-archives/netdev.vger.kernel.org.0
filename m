Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E43696F05
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBNVPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjBNVPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:04 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22DE2CFC8;
        Tue, 14 Feb 2023 13:14:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hx15so43256014ejc.11;
        Tue, 14 Feb 2023 13:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KDFmcui8ALu43VCBPtA1q2U2Of2qag4CSkzmx6HWSA4=;
        b=flgHzDpYulGbiUGC7ZBvYRpNkA+crAorXSPnHkYw1guErjiv33o7Ceeq0hlq3uhLLO
         Ak4i54QTFiJX9Xl4HkGoKILoQIsXM3uyjDInoPcLY7QVpozaxv3HmPvtmLUu3LN766dY
         vJ66Q0H+HGarenCbzD46u7ipXtcVQvihb1QsTrLkjiu7bvPJoir93lfykT53n3RUZHGN
         0HVUvuCrKHL6wn0BsmPBE9cCfapDPivoUeK+2oI5GqkpePWjdMiwjWnIywJmEmOWQmza
         j+vBEChNsLkkM5V9xiTSX82avDz0ovL1+vwx/ikAwkOv7SLZGAwLTThtp1RzYmYo+p00
         Pkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KDFmcui8ALu43VCBPtA1q2U2Of2qag4CSkzmx6HWSA4=;
        b=K8kDTfSpsLiGVjER0Xe5rb/jAA7H+pC0qvvYvv1MDyifLK4rHwF10xndwzKldZ5HN6
         InZnf8hiOBC/3aqbLdUPLzSixLoFMqu06JtAANjG45MLwpTdQxpENau/+I1GeVATCLvp
         dDwdj0kKqfDAhSPu4XCgHQkQ42nXiOjXeERVi8keWjt8hlYX6VYgXVa3V21INxZn5J/L
         CPbM5ybjZFkh+hOqp38jhmP/UYvKaQR2Amv2+mmg1fON+M1IL98xkvqXJ8TL0sggf6Vu
         OZYcFwwTVs5CnP+4u9CkzJZGPJbfaEOlC2DTh8Xk72IN12iLdFbCO487bD0IG5aO5NBW
         GouQ==
X-Gm-Message-State: AO0yUKVTgW/sRi48kHih956wRb3d5TxY1RGH/M7Gm6oYEhzzi9gbvnJF
        Z8BsA0vxpiwZJGTKnkfW1PQPepqae2Y=
X-Google-Smtp-Source: AK7set8ylAUPLXPuJEYf2pYXrU98lQN/z9azLO8/pHLkWLYD5UxXmjJ+cuk4ilGziqwKiFfUdYKyEA==
X-Received: by 2002:a17:906:c313:b0:8af:2bb3:80d7 with SMTP id s19-20020a170906c31300b008af2bb380d7mr995591ejz.31.1676409263655;
        Tue, 14 Feb 2023 13:14:23 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:23 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 0/5] rtw88: Add additional SDIO support bits
Date:   Tue, 14 Feb 2023 22:14:16 +0100
Message-Id: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.1
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

These patches are split from my big RFC series called "rtw88: Add
SDIO support" from [0].
The goal of this smaller series is to make it easier to review the
patches and already upstream support bits which are mostly
independent.

For patches 3-5 I got feedback from Ping-Ke in the RFC version where
he suggested to add __packed to various structs. This resulted in
discussions around that whole topic in [1] and [2]. Since I'm new
to that topic I sent an RFC patch [3] based on the suggestions from
Ping-Ke and David. That patch has not been reviewed yet. My
suggestion is to take the patches from this series first, then
come to a conclusion on the RFC patch which I'll then re-spin as
a normal patch with the required changes that will come up in the
discussion (if any).


[0] https://lore.kernel.org/lkml/20221227233020.284266-1-martin.blumenstingl@googlemail.com/
[1] https://lore.kernel.org/linux-wireless/20221228133547.633797-2-martin.blumenstingl@googlemail.com/
[2] https://lore.kernel.org/linux-wireless/4c4551c787ee4fc9ac40b34707d7365a@AcuMS.aculab.com/
[3] https://lore.kernel.org/lkml/20230108213114.547135-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (5):
  wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
  wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
  wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
  wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
  wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing

 drivers/net/wireless/realtek/rtw88/mac.c      |  9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |  6 ++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 10 ++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h |  6 ++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  6 ++++++
 7 files changed, 55 insertions(+)

-- 
2.39.1

