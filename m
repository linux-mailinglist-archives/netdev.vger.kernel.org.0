Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC17578E8C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiGRX6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiGRX6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:58:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C7533A08;
        Mon, 18 Jul 2022 16:58:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v21so10465543plo.0;
        Mon, 18 Jul 2022 16:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=lfpfAO950vgc6CgyzR59wbYpjmqhhPVTm3S2sKHzRUo=;
        b=nq6QbMxVzbmww2sacGmcRULlkzvOtSuXiXIufH9MXO6LY8hiWre8JfBLGTFDkU6r4W
         WdMePx8zkpHLaMmeGypAzClMDGVYDAFxun3cNvMl/afSnRgIUiZX02GcjcuPBhiFN2XQ
         9LesUOLElqOseyJo3CR+ok4cQQNhKZJnLuTeXdWFB/uRsYOZHBbf9AxU7szRPD7Axq2K
         4aXgfRhUBn9vWxHlf5HujiMMx0BDzmuGVasVppkt3cJUth8m5emsUoxP7LDFh0XuVGnx
         5L/Zv9bPbVV3kOT7OBpEsMTG++H060Dy4vlRYOzHT7Urw/bqMxDi4wO5B33f2T1OEe0G
         X15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lfpfAO950vgc6CgyzR59wbYpjmqhhPVTm3S2sKHzRUo=;
        b=j9OWJjNAfxaj87w7shFRBGDL5imD7KWgThPtxZocahND4K6b1EjsXMoXnDmmCllsu5
         yrrHiyb2tlrq6O6iGMLLagN09JqW382KN1Gbix3LIKiBEEHODE88ygQPLntHciP8KzGl
         O94EQcsvwj1qxBc65WC55CsQUWWh36T4ce/ZLl4BRsx06y7eI9zQAVQQ4wWP32i7MDWO
         uFkzh+PwzseEWqukXFYzJngN/Ohc8WdJfZ6VqALnKIpb1aA7/PS8zHbbjoZpiYzrI/qy
         ARPaGEHTPJJuQsCqtq36SRanL5supitkFKs3VCQZe3eoN9vIEfjMhgt8isE4ma4bYQYG
         WTdA==
X-Gm-Message-State: AJIora9vPiAFhQCEUuDAnhMkiioZXK5dqo8iInvfn8S+5OHVqSrN1eyq
        ZNvgNKIp1MeZbxxldjm1nqb/BiOpNGk=
X-Google-Smtp-Source: AGRyM1t7sS8bLgNN0ioTMtghhHyFNQsdnmwFnkUEgJa/6OcIKiZWnchkLsf76GTtl6Wb/SNu258Sbw==
X-Received: by 2002:a17:902:d2d1:b0:16c:223e:a3db with SMTP id n17-20020a170902d2d100b0016c223ea3dbmr30914234plc.37.1658188700052;
        Mon, 18 Jul 2022 16:58:20 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm10027067pll.300.2022.07.18.16.58.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 16:58:19 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, jannh@google.com, jackychou@asix.com.tw,
        jesionowskigreg@gmail.com, joalonsof@gmail.com,
        justinpopo6@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     justin.chen@broadcom.com
Subject: [PATCH 0/5] net: usb: ax88179_178a: improvements and bug fixes
Date:   Mon, 18 Jul 2022 16:58:04 -0700
Message-Id: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

Power management was partially broken. There were two issues when dropping
into a sleep state.
1. Resume was not doing a fully HW restore. Only a partial restore. This
lead to a couple things being broken on resume. One of them being tcp rx.
2. wolopt was not being restored properly on resume.

Also did some general improvements and clean up to make it easier to fix
the issues mentioned above.

Justin Chen (5):
  net: usb: ax88179_178a: remove redundant init code
  net: usb: ax88179_178a: clean up pm calls
  net: usb: ax88179_178a: restore state on resume
  net: usb: ax88179_178a: move priv to driver_priv
  net: usb: ax88179_178a: wol optimizations

 drivers/net/usb/ax88179_178a.c | 314 +++++++++++++----------------------------
 1 file changed, 100 insertions(+), 214 deletions(-)

-- 
2.7.4

