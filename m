Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3072EE9CA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbhAGXet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbhAGXes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:34:48 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618EAC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 15:34:08 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y13so513831ilm.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 15:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiZ/f0eHV5aQFZa+Y8E8w0anBR8YlRAd0P5p11hd21Q=;
        b=bi3iyF594n09MDCSVSCiyjO+ne3h666WZxMh8k5ozUoKAFfkzQSlJO+FVULBXEhnKQ
         DWrLKTOF8SpB5jFeJRr1gJYpfh+wE4Azs8o3phz8oVAdLPK4Gvg5gf+olk6iEuygy2MQ
         KPS4JWhZ/2doj1g3CJTmD7x8mBZcHw+0ifkGbe/wyrPWZLKPsgQsH/BmjrXC7JVaCSle
         vIwey3oJzIBVDPDWZKxRpBrqjtfEgAAG7oIV1lWSd7s9Q/TeNnurLrIDUqRfFTXLlMRK
         8k/qGboO8sFuWJUfst1Vhxt2ZZQWcbgILUjaBWlXyo8a38IRRaVFBxr56dGmyr2LDdVj
         XqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiZ/f0eHV5aQFZa+Y8E8w0anBR8YlRAd0P5p11hd21Q=;
        b=EF5lgMgnWVvRXG/p0QtsBlDUG6Q8rzzpYxROs/1gFvMU7fc3G1bgZZqqUqQbuI7C6O
         /yrwWZh0SzQC7eZR8m9l8ZCgoYNINOummgb/fZRdsx3B9yHWNNqFXWsLIjGbEqFrqxv7
         4MxJlm5+SYMRggoe0mL1uh64jkYUQw132CGGbNKlRJJ951g1zD6WTNKq98soLdwwq28L
         cM9W+RISQk4Q0Tjiey48kTFXlL2pCC9873NfOTt/kfsb7MrNkoLKUT7kT5l8THRryqsZ
         UBnpHR/OtfLeluL8PE45Raink4uLADRwC+bT9HpJwYlqyA52P0r2N+troZT/vJGpDf7a
         +mmA==
X-Gm-Message-State: AOAM530aC9oYefAjLzWxZ8wpNhrrvhoEgauSE6is8z3RhpwHf91mxlgP
        M4PnfZ+MPfuy1jukCrpC3sY+UQ==
X-Google-Smtp-Source: ABdhPJxn7aD4n6NGnZR2YanSnANfePYBUaScug0tpdv9ckw4F2oMe0QIzJmRZiToQH06QxVoMbaKow==
X-Received: by 2002:a92:6403:: with SMTP id y3mr1248404ilb.72.1610062447746;
        Thu, 07 Jan 2021 15:34:07 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm5648521ila.38.2021.01.07.15.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 15:34:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        agross@kernel.org, ohad@wizery.com
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: ipa: support COMPILE_TEST
Date:   Thu,  7 Jan 2021 17:34:00 -0600
Message-Id: <20210107233404.17030-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the IPA driver as a possible target when
the COMPILE_TEST configuration is enabled.  Two small changes to
dependent subsystems needed to be made for this to work.

Version 2 of this series adds one more patch, which adds the
declation of struct page to "gsi_trans.h".  The Intel kernel test
robot reported that this was a problem for the alpha build.

David/Jakub, please take all four of these patches through the
net-next tree if you find them acceptable.

Thanks.

					-Alex

Alex Elder (4):
  remoteproc: qcom: expose types for COMPILE_TEST
  soc: qcom: mdt_loader: define stubs for COMPILE_TEST
  net: ipa: declare the page pointer type in "gsi_trans.h"
  net: ipa: support COMPILE_TEST

 drivers/net/ipa/Kconfig               | 10 +++++---
 drivers/net/ipa/gsi_trans.h           |  1 +
 include/linux/remoteproc/qcom_rproc.h |  4 +--
 include/linux/soc/qcom/mdt_loader.h   | 35 +++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 6 deletions(-)

-- 
2.20.1

