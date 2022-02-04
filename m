Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FC4AA06A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiBDTuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiBDTuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:50:54 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A26C06173D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 11:50:49 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id r144so8675943iod.9
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 11:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxtfVI7KgoxN9MF1SpdHVpgmrFjcw8vxtvnlV5FrFuE=;
        b=NiD0q3wT+xkpMP6TDkOOqpU7H+ZR/irEDLfQ7ixuXR1K/2tAqFaHtFl1UfLN+ii2hl
         sffwSCM/7LmpxGuH0PuKmzF9fHEajjbGS001rDHCbQpOb2i1ijU6hfoOUqn/uGu+Q8HD
         mC/ZtXQDrM5c2sK8q5IaLE1Da7NtZRQq0am8fz5aqmx3GztO3YVWHgiBtsPEINnDrB6L
         NNHrJpX98MWuMU7a5IOkJWvKLQ9wT36Ee8L9/kf2Q8Tf7gmsRdEzelvcctV5OeP1QOwP
         jh2c0xvTgipGj5n7XKDwJaKkag0ngVn5BsHmz3sU7dK98U4zfJOlzjMWpQTgl0fL/pD4
         QssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxtfVI7KgoxN9MF1SpdHVpgmrFjcw8vxtvnlV5FrFuE=;
        b=zMleTWvVOTn5fnWkU3EbOplFXa3uPiUkj5N5JCpvUCzLXaxzxEJG36KUGjCltnBQwk
         Co9rCpotCu+rSFI0sKFn3TCuUiydIfYSh3Z4w5dAAx62KMRLuQ2WgCBRpYh2O09i9P1l
         6E/UHUX6iCnqEXXmDJ60iuYWlQ+eAFvVttw/tGnuYV8e2eogRFMe7DsJEJ34eFTaX+jp
         HF+UHDZGAxCT0WcvLcXtUxPparjCsI+sP3+ceTyyP29D65OAqPUckMM70B7dCaJ/UB7E
         +yYeY7LUmDUwkSxZh3d23ZkSGW8N/cOlaP+6wryDeArc5WRNVEpA00yX+VYX4n0GYBlo
         ZPuw==
X-Gm-Message-State: AOAM5322U2dKlBygoN7YjRHW5lZ/DK/4z6JrhWLpYzGbyB9hYVBwTWnm
        ro6b6cMBiv5rYg6KzGjmlnGc+KWisDzTbaMw
X-Google-Smtp-Source: ABdhPJzftx1Oesx2QJ6Qo+x81hXij1Ey8oZmAnObEMe9yf19iwRqAQmfUlqCkxP+oKkN6TyY7KbisA==
X-Received: by 2002:a05:6638:1501:: with SMTP id b1mr338974jat.251.1644004249035;
        Fri, 04 Feb 2022 11:50:49 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k13sm1417564ili.22.2022.02.04.11.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:50:48 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: use bulk interconnect interfaces
Date:   Fri,  4 Feb 2022 13:50:37 -0600
Message-Id: <20220204195044.1082026-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA code currently enables and disables interconnects by setting
the bandwidth of each to a non-zero value, or to zero.  The
interconnect API now supports enable/disable functions, so we can
use those instead.  In addition, the interconnect API provides bulk
interfaces that allow all interconnects to be operated on at once.

This series converts the IPA driver to use the bulk enable and
disable interfaces.  In the process it uses some existing data
structures rather than defining new ones.

					-Alex

Alex Elder (7):
  net: ipa: kill struct ipa_interconnect
  net: ipa: use icc_enable() and icc_disable()
  net: ipa: use interconnect bulk enable/disable operations
  net: ipa: use bulk operations to set up interconnects
  net: ipa: use bulk interconnect initialization
  net: ipa: embed interconnect array in the power structure
  net: ipa: use IPA power device pointer

 drivers/net/ipa/ipa_power.c | 178 +++++++++---------------------------
 1 file changed, 42 insertions(+), 136 deletions(-)

-- 
2.32.0

