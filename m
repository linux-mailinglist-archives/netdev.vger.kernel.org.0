Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445BF470DDE
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 23:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbhLJWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 17:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241249AbhLJWfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 17:35:03 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365EC0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 14:31:27 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k21so12017892ioh.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 14:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NPD1Zw6ZNAuGQd1G+SeMeKiCsCemvNOea9eSjBJ+k0=;
        b=a5WSFO9eanrGrpr9rwbCbczisSWc+lP401zK7OFY4DRiQE/7wuN+XtRgD/Nup2i6tz
         zc0NxFKoEtEolNCxUjpC3zfATWmlPnT8YtQWdYdRWLEnDq8k2v/u7TTG6CfjnZVqykMj
         bYyWhTYLbxZ2mnzZv+9+SpBNQFxkxRp+Ut7eAAvtLfVuXPN+8UbgwpZoOUnsbU52c7Rr
         lUE9Dm/hmijm/sdtkhXLn7uzZvPH8/IS11+0vuzjUznxKhPu9UvkyRUsYn8Zoc32Y+83
         qzIgiKRE0J+/ygMakVgNw4J0OhGy+vrSvOd8wpFTcijdg4b+8VpeVB//+g8AjsZdzJ5o
         oxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NPD1Zw6ZNAuGQd1G+SeMeKiCsCemvNOea9eSjBJ+k0=;
        b=zz5+Tx/+JZNlN2hUufbFPBuKzfE8bwTJ58qzdr8/XK9ifBbHvlyOyO5g12Q2SkIzJL
         dMmxxJ5tDQZliZ+17fU8VeYyHAMwQBZUpsC+9Pqh/MJsGznNC37r1XYyESRgF0BmlG+T
         IphbU5h0/ASekmha/ScnUIhVu6LViWwRozCGRZX9w90XnZalD+2BAn8Cje6f1I7MDblC
         rvkBwQK2ocNd4XJDuS6qEdOyUXVobywQOe+vYz2r/AcuT95wlP45LLips/95HqKsU2HF
         ztNj2IMqgbh2E1Fnm1x/joEBg9KMMtVa7ZswBfnft3dk+oYK3f4f2jTYyrR8Zh/iwTL5
         h1KQ==
X-Gm-Message-State: AOAM533kXUGinRLfMqj4SDzFkNtwXlQZ051ub0u7Zu4mTWe1DQYLwyDz
        0f0nvIsCcBXvZkSnL/GpmKiQAA==
X-Google-Smtp-Source: ABdhPJy5Z0hX3gbDQziYbdilkb/xnTi6ktGSHta5/VzJsqqEiDyqvbd5YkWRj/gIchPUUilkhEVjFQ==
X-Received: by 2002:a05:6638:238b:: with SMTP id q11mr20201917jat.43.1639175487172;
        Fri, 10 Dec 2021 14:31:27 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q4sm1279879ilv.56.2021.12.10.14.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 14:31:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     david@ixit.cz, manivannan.sadhasivam@linaro.org,
        jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, mka@chromium.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net: ipa: fix SDX55 interconnects
Date:   Fri, 10 Dec 2021 16:31:21 -0600
Message-Id: <20211210223123.98586-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SDX55 SoC has IPA v4.5.  It currently represents the path
between IPA and main memory using two consecutive interconnects.
This was an optimization--not required for correct operation--and
complicates things unnecessarily.  It also does not conform to the
IPA binding (as pointed out by David Heidelberg).

This series fixes this by combining the two interconnects into one.

Version 2 simply adds a few missed e-mail addressees; there is no
change to the patch content.

					-Alex
Alex Elder (2):
  ARM: dts: qcom: sdx55: fix IPA interconnect definitions
  net: ipa: fix IPA v4.5 interconnect data

 arch/arm/boot/dts/qcom-sdx55.dtsi | 6 ++----
 drivers/net/ipa/ipa_data-v4.5.c   | 7 +------
 2 files changed, 3 insertions(+), 10 deletions(-)

-- 
2.32.0

