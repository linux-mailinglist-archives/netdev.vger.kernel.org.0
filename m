Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9F92EB81D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 03:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbhAFCjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 21:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFCjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 21:39:09 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E8DC06134D
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 18:38:16 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id t8so1396328iov.8
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 18:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FprZVVjHWClp4VohDC7RbHGxUkIy86bNYcrNdkcWEq8=;
        b=zueZzXDY6pjPDUB3+sujDQ5uZGOiDuLJpxMkfjcSJ/iX0tSJjxU63hioGWp+S/dcHN
         1ZNaTrJERtbv1xFZDuKvblHoB5E2BWGntK84/VZzPvWnMTJqVRtC4+Gk7j1sEQ7pNeJR
         kawtI8pME6V8vkjetmHSYKBaX5/5l4vw+xoSf0eaeKuEwJYAxWzmDyJsXKOUVOhMvkwt
         nHqFuz9CazeHTFUcB1q3UmpmKMniUzimhUm1nFANP7fuARC10Ho47YiTvc1n7Qb1qkLK
         nByXp0fv5baQIs91agseAPCEfSnkB1Qp9YJ/puLcsT3lSKSYx76RsE1qlPMdnVBUc/Gy
         V4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FprZVVjHWClp4VohDC7RbHGxUkIy86bNYcrNdkcWEq8=;
        b=KTvUcLrnoP9ryWfkjeLouR5DVlJbTHBcTIMW/O47fDdXY7SSUen3tckaur4Q6ft4lL
         GdQwMSXr1X8BA9qJHh7COGuW1aBjcxSMLVfPTaJ2OsqgdCz0UpMIrHPUIJXEoMSCF2y5
         4/cpcd33P2dTF7snPX5JkNIL8YRQ413bzmD6z3EWcDswBQvYOC+VDMDTFUdzVjyNMdY5
         xq+OoXPZ8dCdBY0lRmFfsUH/pjlMjb/+eSqz+DWJdpPojxOPAyysYt4BSoIw28ki3LU/
         MJCEKzvFTUpyGZqM9Od+uhVDNeLk+AQsKvjZOxShTwMjvvu2M4z8mOXhjJLK3yt52Ti1
         lqHw==
X-Gm-Message-State: AOAM531xTwoAGom6eoEkV6oQD/MOU+ffv3hriB14/PCkgSyFo5t0HBVW
        Tju2BFLfF91i9VPaefLoVYF4CA==
X-Google-Smtp-Source: ABdhPJxVKl1PVA4lvMThTDUj6ztVYEAs4ympo6aqd7rVbQrKTcxfDjebXjzflktSAlazPE9RRyYOSQ==
X-Received: by 2002:a05:6602:59e:: with SMTP id v30mr1528894iox.37.1609900695619;
        Tue, 05 Jan 2021 18:38:15 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm631755ior.42.2021.01.05.18.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 18:38:14 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        agross@kernel.org, ohad@wizery.com
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: support COMPILE_TEST
Date:   Tue,  5 Jan 2021 20:38:09 -0600
Message-Id: <20210106023812.2542-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the IPA driver as a possible target when
the COMPILE_TEST configuration is enabled.  Two small changes to
dependent subsystems needed to be made for this to work.

David/Jakub, it would be best to take all three of these patches
through the same tree.  I have discussed this with Bjorn and he
agreed to ack them, and I request that you take them through
net-next.

Thanks.

					-Alex

Alex Elder (3):
  remoteproc: qcom: expose types for COMPILE_TEST
  soc: qcom: mdt_loader: define stubs for COMPILE_TEST
  net: ipa: support COMPILE_TEST

 drivers/net/ipa/Kconfig               | 10 +++++---
 include/linux/remoteproc/qcom_rproc.h |  4 +--
 include/linux/soc/qcom/mdt_loader.h   | 35 +++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 6 deletions(-)

-- 
2.20.1

