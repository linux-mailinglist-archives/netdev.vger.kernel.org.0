Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D9B45CDEF
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhKXU2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhKXU20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:26 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64884C061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:16 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id f9so4762859ioo.11
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/24RdqQK4olp30g1fq+RkJeuTupUnUuToZErCalg8ms=;
        b=Qbaui6nh345Bua671A3FADSw6FQq88O4Bx2o31dRKhVx0+mOzrYnlakuuISHk5fizf
         WGbHUasVp3/UPp0tbU9UhY+rLQzP9kod2U9oPA7T6d5GQ213UDTVtxR8h4LNlLKPsL54
         sP0lu+d9xjDaChHxSOCaK3knJ36M6Rb2wLORQCwDEP4anboHZJWUBSb8LU+Taz0B4q/c
         7TjLStgeJ02j4W1WHTblh5JUEmxzbOq0tqrpGgWec8u2R3ktrHsIXF6RkgOmK3HeSMUv
         OJKaoo+pge88n9dQfOkyh0BA/mjAPclOhyu1nkAchPUFVrj+2DWUtE8ltYi7hLVqd3vj
         Z5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/24RdqQK4olp30g1fq+RkJeuTupUnUuToZErCalg8ms=;
        b=Ccg0+e5hKbkvomo+zdYkQBaiXzfOfaeU6GBjvZVNcgSGZ6t9fH0IjdcN0kc7NXxO8w
         6xpB9rhWZTsX6Z2REI5oQtDwbiW6R8p1H06drwhh7NE9MVcBaxrnMGagAy3Csj1GTxCc
         YXIQ5C9stERFRCsza76+1sONiKLH9c79sMgukKqdb8vajX+MuthsHeBRCoCuAyIqfV/N
         7QUvZ/oiXZhyOHmNiH6afLow4PZSCGsnSIRsHRxSsFJAZjZJQWX2rci5B1HIfWDBiR8v
         +xNuV/zbwwIxj1cM8TSWu7/gUXeaGHaead8ojEPlFsRMPklQU4DYOD+FRv/IbtKE87wV
         dwew==
X-Gm-Message-State: AOAM530BGyHlb8HviAwHQaKhduqc8zyArC4yrO0F7HS1wxTKl2B6Wm4/
        rTfjBTnq4ZyrA5vnQ7BHNINSbw==
X-Google-Smtp-Source: ABdhPJwGXo95cfr3SFikYIZh/uOEy5eDjzFOETJZCPMr/PvgzrgXck9aDpcMKG+yccwRitflnpQUlA==
X-Received: by 2002:a05:6638:252:: with SMTP id w18mr20008947jaq.54.1637785515512;
        Wed, 24 Nov 2021 12:25:15 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:14 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: small collected improvements
Date:   Wed, 24 Nov 2021 14:25:04 -0600
Message-Id: <20211124202511.862588-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a somewhat unrelated set of changes, some
inspired by some recent work posted for back-port.  For the most
part they're meant to improve the code without changing it's
functionality.  Each basically stands on its own.

					-Alex

Alex Elder (7):
  net: ipa: kill ipa_modem_init()
  net: ipa: zero unused portions of filter table memory
  net: ipa: rework how HOL_BLOCK handling is specified
  net: ipa: explicitly disable HOLB drop during setup
  net: ipa: skip SKB copy if no netdev
  net: ipa: GSI only needs one completion
  net: ipa: rearrange GSI structure fields

 drivers/net/ipa/gsi.c          | 44 ++++++++-----------------------
 drivers/net/ipa/gsi.h          | 11 +++-----
 drivers/net/ipa/ipa_endpoint.c | 43 ++++++++++++++++++++----------
 drivers/net/ipa/ipa_main.c     |  7 ++---
 drivers/net/ipa/ipa_modem.c    | 10 -------
 drivers/net/ipa/ipa_modem.h    |  3 ---
 drivers/net/ipa/ipa_table.c    | 48 +++++++++++++++++++++++++++++-----
 7 files changed, 89 insertions(+), 77 deletions(-)

-- 
2.32.0

