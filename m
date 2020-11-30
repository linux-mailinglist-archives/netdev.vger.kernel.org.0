Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365222C92D1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbgK3Xh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgK3Xh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:37:57 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1667AC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:17 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id w8so13078595ilg.12
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lvd8Uu7EFbx7sQmZLqZeinPKN/f1EeBVJhIhvxXPxbQ=;
        b=JJlgwRA8bfdj0bCBX+rh8DFqrF6nlg4L/Yo0ReowrvyPW2rglkZyZoDz69FOMJir/L
         hXZF53WZ37hZgLyjjiw/g+JRNLm8FoCtmYk4B7KouLUQhpHfpOor+Hh6laJjd1y2zrD6
         idVaSUk0W5dCMrpmr3vucYkzAPt4pSCalVoPLfTS19ZuueRUv8Jzmcfd1GrtnkGuVyZ4
         U+RlrPIS0iQxnmFPYX1lnKP7c5uk2dYocqi/KtMlEI+LeCk7wwmS9f/epoHvOnB6mlxA
         o1pYGhE2GWRIG3jOthnhdiL1QJReSmtWyf1EJpwVySjms9UldtVfzPOPv+1Q5lsoT8sR
         eDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lvd8Uu7EFbx7sQmZLqZeinPKN/f1EeBVJhIhvxXPxbQ=;
        b=f6BcEH/3h2uaHJPtYCM6R3fL0HAPrqzQ/6lPaIsBWKC6sNQRahnMOnkHDYbUyavPcX
         EfA8IsXnRvPHk9Jd/F+xjUzLF7qB86PN4pdmWoLW865OcftjE5dS0ZKqwdWRDFB4EZuk
         D1hywHdESDM5W5agp2o3/auvK9hm7NPsR96Sv/CetYINHic21d+iPS6DRTOz6YsSea/i
         1TYdRzVvQtbq/KpIOgNxFWxvqx0C4iNl8dyYKEFELK9VZhVUDCq8EQ8xu2/4t6ZKvOl3
         PWNIHX5lMuhaQx24HcEcsxiS/DynNfEIEmDb1kWAISfOiT+eie8RIn0Dt8xKqr0VZyVQ
         t4GA==
X-Gm-Message-State: AOAM5308KdqYctCo7qALCYZVenodra25Wubh8TBceO+CF8KVCiebFTqO
        HG7NF8fMRsZ7tsgLdyqBRgfaLQ==
X-Google-Smtp-Source: ABdhPJxeiwWh/CGGvcYRueT8H0rGGqa/OucnmftkAFNDBMFXFkJPWqRpTL2M1Uv6XPwASW2HCU+pOQ==
X-Received: by 2002:a05:6e02:1948:: with SMTP id x8mr96841ilu.225.1606779436403;
        Mon, 30 Nov 2020 15:37:16 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm62574ila.38.2020.11.30.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:37:15 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: ipa: IPA v4.5 aggregation and Qtime
Date:   Mon, 30 Nov 2020 17:37:08 -0600
Message-Id: <20201130233712.29113-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates some IPA register definitions that change in
substantive ways for IPA v4.5.

One register defines parameters used by an endpoint to aggregate
multiple packets into a buffer.  The size and position of most
fields in that register have changed with this new hardware version,
and consequently the function that programs it needs to be done a
bit differently.  The first patch takes care of this.

Second, IPA v4.5 introduces a unified time keeping component to be
used in several places by the IPA hardware.  A main clock divider
provides a fundamental tick rate, and several timestamped features 
now define their granularity based on that.  There is also a set of
"pulse generators" derived from the main tick, and these are used
to implement timers used for aggregation and head-of-line block
avoidance.  The second patch adds IPA register updates to support
Qtime along with its configuration, and the last two patches
configure the timers that use it.

					-Alex

Alex Elder (4):
  net: ipa: update IPA aggregation registers for IPA v4.5
  net: ipa: set up IPA v4.5 Qtime configuration
  net: ipa: use Qtime for IPA v4.5 aggregation time limit
  net: ipa: use Qtime for IPA v4.5 head-of-line time limit

 drivers/net/ipa/ipa_endpoint.c | 174 +++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_main.c     |  67 ++++++++++++-
 drivers/net/ipa/ipa_reg.h      |  68 +++++++++++--
 3 files changed, 260 insertions(+), 49 deletions(-)

-- 
2.20.1

