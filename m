Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4439F6A346D
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 23:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBZWKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 17:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBZWKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 17:10:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D9E16892;
        Sun, 26 Feb 2023 14:10:37 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da10so18565916edb.3;
        Sun, 26 Feb 2023 14:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rHoPP53Y/Pi5WL05efEjpsEenZQ8FxyUdpZTPPjZFU4=;
        b=UhmVfkHM8BSLxD/Dng9nZ07uDhfsWXgmWpyMWDkC2G6fMcj1bOuvpB6eMTcdGm/zc9
         AnnTxOMv+zap/378meBFe0UTxE6DF4MHASgZdrdz8JyEPtdFTPpBmBmH8THOyPxhyHje
         +VYhpDnHmDOh8bcdUZSmoSrCLQqYvoB0wKv6rbLieSIqkvU4g85O2QcbHIZUP1OEW5E8
         em/Vn5eawcYCPK4C/gf03sVo0KJ2lkYpXVcMdKcDupBNomnQIsuIbd9nzyy9CsK7iLYA
         HXhvzeoALHtLvcLmJwXdA+EvnkgX6aiXFZm3EpGS8cA6ewtcDLKJ0XkcvyoShoB2GLT0
         l/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rHoPP53Y/Pi5WL05efEjpsEenZQ8FxyUdpZTPPjZFU4=;
        b=x2edYb9Y4OI2ghn5kdoMF6M2FljWN+kMBjS+jhHOG+AOcCKyBN3RcTuR1mX6vrZbVv
         UMVSYg6u9JwBjsGX9Sm7V6pXW0xG/nb9lDUfIrYYApU0z/oFWKTG2N3LmGDbECxY0Rvs
         bYpcMX7q931tOeOcAE5KZGH4QMZEwKp6+UL3QqAAQHdmNLlxKY6Y+cuNvvaLtHNFB1aV
         1RWCUfeRDAze0Uj//osS++3f/lQqVdcUqK9bsvOe+ILnphUIZ653JtBDKMqzQkx8Sn2N
         u6VWgcPLrGERZrJXRo5CLCNaZPchdhwuBKziatx62tWquhXZU82UDUclkhKZ92PFHIkY
         IZTQ==
X-Gm-Message-State: AO0yUKUrWKXMrywNKTcC9miQMDxnMZuaqt+l6PURCKxzZ5JcbaEVuSLF
        gXnUzy5zMKtnxu97KhyewZKL3JA0Qbc=
X-Google-Smtp-Source: AK7set/ehXrgUfVE5SZ26PSCOOxmymDdEnQuCPhT/N7C9hS2fg3dwxALopeX9QP7sJGUCYR2zwcPBg==
X-Received: by 2002:aa7:c3cb:0:b0:4ac:b760:f07a with SMTP id l11-20020aa7c3cb000000b004acb760f07amr22121111edr.19.1677449435281;
        Sun, 26 Feb 2023 14:10:35 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-9483-fd00-0000-0000-0000-0e63.310.pool.telefonica.de. [2a02:3100:9483:fd00::e63])
        by smtp.googlemail.com with ESMTPSA id 26-20020a50875a000000b004a21c9facd5sm2390752edv.67.2023.02.26.14.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:10:34 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@kernel.org, tony0620emma@gmail.com,
        Ping-Ke Shih <pkshih@realtek.com>, Neo Jou <neojou@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 wireless-next 0/2] wifi: rtw88: two small error propagation fixes
Date:   Sun, 26 Feb 2023 23:10:02 +0100
Message-Id: <20230226221004.138331-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
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

While updating the rtw88 sdio patches I found two more improvements for
the existing code. This series targets wireless-next and is meant to be
applied on top of my previous series v2 "rtw88: Add additional SDIO
support bits" from [0]. I decide to target wireless-next because these
patches are not fixing any issues visible to the end user. Worst case
is that the code is shadowing some error codes.

The next series that I'll send after this is the addition of the rtw88
SDIO HCI and adding the first driver(s) to utilize this code.


[0] https://lore.kernel.org/lkml/20230218152944.48842-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (2):
  wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
  wifi: rtw88: mac: Return the original error from
    rtw_mac_power_switch()

 drivers/net/wireless/realtek/rtw88/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
2.39.2

