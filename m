Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C435249FE02
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiA1Q04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiA1Q04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:26:56 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F65AC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:55 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id x11so12862553lfa.2
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=R3r+zULllOaZ3qRdy3ZtqLqgF7qqBzT1vJanhLdkLwQ=;
        b=097PzTBYOsQLzlfjJxuN+JE88QK8oN9RD8d/5rAFy8oaGksJXcr3aI5CV/uSN2FBXB
         Ng+Z7hYhYwzsveqjCp/zkGDMkE8lEORQq6P6Ojayxyh1LWqkLSFLuH6QYp52x1aShWpb
         mU7zKwJXlZimvpEge+lqpbSz3O+eplvOe93XrqfTvLPeWFUy04TVyiec8ZHZw5blzp0s
         BAiV+ymXkRRJnPKFW5cRknFEDkoBoA4OmDX38g2MxloqUmAZ1AJK1E6QuxYSyHdvV1AC
         10tKV0QaB6fIdMwa+yX6y976+CalX+BmvuXa+l4IhGrkGakLBjFActvirwu4ZRZL4EYO
         0Ofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=R3r+zULllOaZ3qRdy3ZtqLqgF7qqBzT1vJanhLdkLwQ=;
        b=olRv9NTdIq6j8oDsXU7Ot8v1RogJEQqQFG9GEZysl6oSA1LEUTw3+3Og2c0T8sivGN
         u6i0z73lvdqmmaBAXJ0R9/aNsVtwuUg2j7nyAYK/GeFW9UhCqDqjqDagUlUPlXTL/nXD
         flsXPwJlePImkHHFoKq1e9Um7yc/GD1xfCuEbrGf7QHojIfUmvWaGwGxs0H6LJKS18tN
         YIZvjM+NVkzjiwDT23Jon4+9s4uhmfHhn3vY1SZaqkM4he+cqB6n5+wNej+EWEXQ95Lx
         gKj1hdEI9lSvzIpA9RUXKKLEn9JSo1ak8oYZ75hIlLENC0O1ESYlZJiH8jsAtSf0q7nZ
         rA5A==
X-Gm-Message-State: AOAM532nyID9//qNh2NpqEYrljf8K3TLGGCNDgmEbVDYO+Nc9H5mFJtO
        FWx45kQRzaK4jhxNmA0KLaY47w==
X-Google-Smtp-Source: ABdhPJxP3mbHiRx4vR7DyUhK9UIA4pL/oJwe5x5bAnCvsT5Nddfb/EGHrldjpPLPLjQ9w4YaXZ9gLQ==
X-Received: by 2002:ac2:5190:: with SMTP id u16mr5111095lfi.257.1643387213998;
        Fri, 28 Jan 2022 08:26:53 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v17sm1954968ljh.5.2022.01.28.08.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 08:26:53 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, David.Laight@ACULAB.COM
Subject: [PATCH v3 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
Date:   Fri, 28 Jan 2022 17:26:48 +0100
Message-Id: <20220128162650.2510062-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The individual patches have all the details. This work was triggered
by recent work on a platform that took 16s (sic) to load the mv88e6xxx
module.

The first patch gets rid of most of that time by replacing a very long
delay with a tighter poll loop to wait for the busy bit to clear.

The second patch shaves off some more time by avoiding redundant
busy-bit-checks, saving 1 out of 4 MDIO operations for every register
read/write in the optimal case.

v1 -> v2:
- Make sure that we always poll the busy bit at least twice, in the
  unlikely event that the first one is quick to query the hardware,
  but is then scheduled out for a long time before the timeout is
  checked.

v2 -> v3:
- Fallback to the longer sleeps after the initial two poll attempts.

Tobias Waldekranz (2):
  net: dsa: mv88e6xxx: Improve performance of busy bit polling
  net: dsa: mv88e6xxx: Improve indirect addressing performance

 drivers/net/dsa/mv88e6xxx/chip.c | 13 +++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/smi.c  | 35 +++++++++++++++++++++-----------
 3 files changed, 34 insertions(+), 15 deletions(-)

-- 
2.25.1

