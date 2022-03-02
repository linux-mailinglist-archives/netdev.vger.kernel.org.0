Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0254CA25E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbiCBKkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbiCBKkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:40:43 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E9BECE9
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:39:58 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id s11so1526442pfu.13
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 02:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hSSYyjIeCQj/Yk471H+t4be62lPbXH733Ozer3TJP4=;
        b=JyG9DV8skFLWA/Riameo1pOnfP0U20+Dvh30cSsaSMOpc+vhdzlg5CjfLqN629EYdQ
         tX3v6gfw8yy7ZQTErKAB7PtNlyeOaYSPB5hx0vSqLuNBhbQ+ut0olipDjzD3O6JgKWBO
         5W4JiSd5xc4FTX/EyK9BGNwwOjXzzeKccQr7fZXSu8nlO+bqMCmZNX6QUHzkSCNmB63x
         fyJcbuFogdBqTAAYWk1XzfB6rHQPpwnYjy3kX9AyFmwp/0hRgHZoLFWTOLevuz6CNhi0
         d4wRBAN1gzG6/iJkMYYHGUFNsDy/Cxd0k5H09Z17+90EV93R3KXfEBIUnbGzKOlLFnGT
         6fQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hSSYyjIeCQj/Yk471H+t4be62lPbXH733Ozer3TJP4=;
        b=NJw90prRcBK0C0Ag+mu1EMaB5M9j+tQFg3aw/k1Ra0LRWJBoUpJGwI0gSjemAdWIKM
         /yo56YPSO/QjomrXzZQKS8kgCqAxpR/fY8RJj8Y5qQsWda/r8CRVQbuOvshaS6ZO5624
         0QIMB06h3M2ZmmY+EcWTWXlttSdQlm7Oe89ls2U0kgunbIYoCReo4UH9VkcreLXlgcsB
         QNFzPzGb9DEcCsu92KzA+ztUCM8pkrP9GKywnWFymI3IdaS9geM/JpO9fLHxu/t9P0a2
         whbiUYgh88WB5SZaeKA2Xxu5DiJoBfE31w3qW7Ur/7j+r1MvhdK88jK38cuejuP6Rwna
         jFBw==
X-Gm-Message-State: AOAM532U4HC7uPofSlgV6kyl1Y+UOswIBcx+jaObsDsD/FxWok1jVmkc
        zE2Bhh6TBca9gZLrGo4XiOXPR49LxCwa0A==
X-Google-Smtp-Source: ABdhPJzUgJ792DPF3EApiJ3GaQ2Zj69A9UDb+Cj0BKYL2QF0NZYAbbkDZrH7d7ME28LWmmtZzJdK0g==
X-Received: by 2002:a05:6a00:1694:b0:4e1:5931:b040 with SMTP id k20-20020a056a00169400b004e15931b040mr31936664pfc.7.1646217598082;
        Wed, 02 Mar 2022 02:39:58 -0800 (PST)
Received: from localhost.localdomain ([171.50.175.145])
        by smtp.gmail.com with ESMTPSA id m20-20020a634c54000000b003739af127c9sm15612308pgl.70.2022.03.02.02.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 02:39:57 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     netdev@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        vkoul@kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: [PATCH v2 0/2 net-next] net: stmmac: Enable support for Qualcomm SA8155p-ADP board
Date:   Wed,  2 Mar 2022 16:09:48 +0530
Message-Id: <20220302103950.30356-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
-----------------
- v1 can be seen here: https://lore.kernel.org/netdev/20220126221725.710167-1-bhupesh.sharma@linaro.org/t/
- Fixed review comments from Bjorn - broke the v1 series into two
  separate series - one each for 'net' tree and 'arm clock/dts' tree
  - so as to ease review of the same from the respective maintainers.
- This series is intended for the 'net' tree.

The SA8155p-ADP board supports on-board ethernet (Gibabit Interface),
with support for both RGMII and RMII buses.

This patchset adds the support for the same.

Note that this patchset is based on an earlier sent patchset
for adding PDC controller support on SM8150 (see [1]).

[1]. https://lore.kernel.org/linux-arm-msm/20220226184028.111566-1-bhupesh.sharma@linaro.org/T/

Cc: David S. Miller <davem@davemloft.net>

Bjorn Andersson (1):
  net: stmmac: dwmac-qcom-ethqos: Adjust rgmii loopback_en per platform

Vinod Koul (1):
  net: stmmac: Add support for SM8150

 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 37 +++++++++++++++++--
 1 file changed, 33 insertions(+), 4 deletions(-)

-- 
2.35.1

