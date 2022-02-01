Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE64A5ECB
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbiBAPCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbiBAPCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:02:10 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC4C06173E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:02:09 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w5so14522443ilo.2
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=60gQPScJR3F303GKBNMY8mtN9axjs8XpxQhhJU+IfXI=;
        b=BeHoCfQFH13Y7FrzpMVBH4Hp1elpnOhRVdRJ7eNs4HOmOfNybE78UTbsbJZDpjgx8n
         bHNK1qh7ZNhXF1JkFzWjABXasSl6PnQHMyxuYiAxdJrVeKeJTkWkeJJaBMm+X6SjltGw
         5ieiqByBaC52N8ZUseDBjTr7v3kdacx9+dam1D0oChEyLJjgfenBGkCDLC3r+ZisdAJE
         kEDCumgHNMRUP7Gy7dqOXpsz/rcInOP9CvDrOoaYKsK5k2hmi50TSdDYKK6RdGgY5wIU
         Z2wvFdX81+bYeeBemAWtUQDfpk+tW+duVuzyFXVpYkO+1GH/1R7QKxTTlHnNDdqvO/VE
         iGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=60gQPScJR3F303GKBNMY8mtN9axjs8XpxQhhJU+IfXI=;
        b=vVAZiS2ID5CFk54+H5c6OKo18xCenCX/iJ0OGU7ZxIVY+ZsEi+hi+DNMSJTMpEjjCp
         J89X0ZzW91GCWuZO4qtBYM/XMVbtAHERi0JZpNz/c3zk3I/g/+wxwX0jY6Zqzqgd6NMP
         SIQfb/urOdh894j/VwsHWYoTvBS55TUIFIYR+sBswQlA2sC34yhGzjr/rEpw1Oyvxv16
         Oweb6wCW65/9tcdoSSaVgXbB0fv/mbZFMmQp9JFmlufFWhbeYt2aiAbVJ/ua4PvBrbt1
         HrZrkuacw3ynvtgrV0e6srCcCfN4Fite1+DB2T9mXTmoZ+Yq0XJ2Q5mprNRMHmDhBx/D
         LH8A==
X-Gm-Message-State: AOAM530wZnf8UG46MCib0NEvzW9y78MS42+EruIMFMgUyDW3CAHVHkX0
        Vpk4RFIyAkc2bptaKfKBgRwNFg==
X-Google-Smtp-Source: ABdhPJypuovSNprWPJ4ZfTl29TUgR71NXnWLIVyDddhhtr4F/46MzzD+HZ0yqoYQRPLnrfq1tQzi4A==
X-Received: by 2002:a05:6e02:20c9:: with SMTP id 9mr11694728ilq.267.1643727729279;
        Tue, 01 Feb 2022 07:02:09 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm19141307ilm.67.2022.02.01.07.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:02:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] net: ipa: enable register retention
Date:   Tue,  1 Feb 2022 09:02:03 -0600
Message-Id: <20220201150205.468403-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With runtime power management in place, we sometimes need to issue
a command to enable retention of IPA register values before power
collapse.  This requires a new Device Tree property, whose presence
will also be used to signal that the command is required.

Version 2 is exactly the same as version 1, but this version is
also being sent to the devicetree mailing list.

					-Alex

Alex Elder (2):
  dt-bindings: net: qcom,ipa: add optional qcom,qmp property
  net: ipa: request IPA register values be retained

 .../devicetree/bindings/net/qcom,ipa.yaml     |  6 +++
 drivers/net/ipa/ipa_power.c                   | 52 +++++++++++++++++++
 drivers/net/ipa/ipa_power.h                   |  7 +++
 drivers/net/ipa/ipa_uc.c                      |  5 ++
 4 files changed, 70 insertions(+)

-- 
2.32.0

