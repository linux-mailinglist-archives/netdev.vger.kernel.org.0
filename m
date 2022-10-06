Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE36D5F6E24
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiJFTVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiJFTU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:20:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F218F956
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:20:57 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h10so2595259plb.2
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bhbYN1/ws6y+dvibVWQIhc2niyZnNj0uIem726dovow=;
        b=nfkPVlGQxxm0gH2aJgFsIJGQT1ZrA2aYg20i6S6j1e0pj9rutxyhA6DNlE+ldLGfB8
         z3TH67MlNuDOm4QRNmE2nSaSvdwPZQkP+iQhx69iDFKze/TLzlT/zx3k7dfa9cdSCnpb
         /bWQeCrx2pqX1KL0u5cltFMJyhI0roiByl8cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bhbYN1/ws6y+dvibVWQIhc2niyZnNj0uIem726dovow=;
        b=z/2UU+gQW71n55oVlPu2GmkcMISSYZzOEMmIuwmZaBEhplm/XBTz/Ex94Ydgs2C9Zj
         qFpg6lHEn4pKfb+NGWN4HiBtwf5VFGZqXEhnUNC0WNI9m8/QOAqmpKVAHnHTjZkvsXPi
         qVNkeYShnD29CMqv6uZNL+p7+rKvHUqjhmlUxZJdiv0l+//wxHuR34kaIW1Je2YsYLW2
         /ou8OwZqi9KtMJgQOy8fxNvBx3EIObW+vfPIHpj9NYAWLHSbKP2Bg55pKXbICrNkBuoD
         Hils01ocMzWUjalDLqj6aqW6Z1XZAoI2cz9hgucWgl+WOWzkL5uBjuvHvjbytYd0nR5O
         gSTQ==
X-Gm-Message-State: ACrzQf1av7XYOaEmMUhzmr62EyyteW/jf44t3fCU1Ujmhjjz53Yj2gPd
        kTXTRc8id6IOqKWY5y1jQ4wkDA==
X-Google-Smtp-Source: AMsMyM7xbIJakV+zr+CrMGNTwjFGTBB9I9gY4Yexu9BF+gqKocdMGxlTu6JuPlg58XON0QY5nDXoeg==
X-Received: by 2002:a17:90a:a40a:b0:20a:882a:7ed8 with SMTP id y10-20020a17090aa40a00b0020a882a7ed8mr1222841pjp.129.1665084057317;
        Thu, 06 Oct 2022 12:20:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pc14-20020a17090b3b8e00b0020a28156e11sm1814611pjb.26.2022.10.06.12.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:20:56 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Kees Cook <keescook@chromium.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] ath9k: Remove -Warray-bounds exception
Date:   Thu,  6 Oct 2022 12:20:54 -0700
Message-Id: <20221006192054.1742982-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC-12 emits false positive -Warray-bounds warnings with
CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
and there is top-level Makefile logic to remove -Warray-bounds for
known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
'-Warray-bounds' universally for now").

Remove the local work-around.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath9k/Makefile |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 9bdfcee2f448..eff94bcd1f0a 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -45,11 +45,6 @@ ath9k_hw-y:=	\
 		ar9003_eeprom.o \
 		ar9003_paprd.o
 
-# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
-ifndef KBUILD_EXTRA_WARN
-CFLAGS_mac.o += -Wno-array-bounds
-endif
-
 ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \

