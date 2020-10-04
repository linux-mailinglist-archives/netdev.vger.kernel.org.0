Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFA2282E63
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 01:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgJDXpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 19:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgJDXpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 19:45:10 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED8EC0613CE;
        Sun,  4 Oct 2020 16:45:10 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id w11so8728521lfn.2;
        Sun, 04 Oct 2020 16:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Q5kzbneIP8pxYxdZcgTlZu9ncoJluCKwWZqmAJDjQc=;
        b=UQ7FEv3LT4ZBJMzjZbQUgX5WYgFu+Zr2LGxGMn9mi0h3NPloFg6d+cB6/eE/Q4sPj1
         WSvsQUuJv8yUGn3fLDE9I5yhjX5c6qPVlCScM3bEHgt27mfj6JIQ5RgOr/tv8IBfMZjL
         TFkKHBwUVNE6ecGMWxlGAyw3jppJVsjE2TcWz2ppMM5uPThnzVLtpTXclaxxKtxZJZM3
         2DreokShqupjRtj2rGeWvv3E/m2qvfO2Ba7+mv50nU5q/kxl2wmu3TyZ6bvcB9ynYT1C
         uCtMpJBlU7ZkIBIwne/B9n56PDyEZh4acNHuJtC8b0bwRF0LCCWjXxjHgpPxAWimOuyd
         Blhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Q5kzbneIP8pxYxdZcgTlZu9ncoJluCKwWZqmAJDjQc=;
        b=VCrU+2Qru9qgrOnimwvAiuQmM88fiLwLJswsK3c98UgrebQ4DRramHN2xXy69kEMnC
         HEH8MsNx3RNWYQywqPzkuOQxytDsudpLgjfAJeCjl6f9pOp5p9OHpsJHuY3SAqVO+umg
         nJlWmLYapmXnC3BmrudzTPfd4lWWCRHjgIhOuzj0RoMtXWQw4O9lCDZ6QKb7Hzjw/AMD
         99KRZR+69k73u/YTN3yHjzq/b50EhSs1S2oV58lrh8OSlLCPpdbDRZGBv7mLnqFJ/tKz
         /taBwIYZfnMzzclu7ZjLb5tVMkAjdgMoxhhTrdTwIAAZVV0K+iTV2t4oxSrzEHSrwqJ7
         LOow==
X-Gm-Message-State: AOAM5330Ae53fjUhpChqBpQrQL06MV1nhiizgS62j+78KxhlByUKqORt
        GmAtSH4WPMFeEMSEb6pLNu0=
X-Google-Smtp-Source: ABdhPJxY2cs919Tq9qeMPO9EKcIvXJ16qKdv6DDIJwzISlCkrKE2EE2JM5MZ4H/nvZkkEQK3eV/65A==
X-Received: by 2002:a19:c786:: with SMTP id x128mr814091lff.478.1601855108840;
        Sun, 04 Oct 2020 16:45:08 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id y3sm159866ljc.131.2020.10.04.16.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 16:45:08 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org
Subject: [PATCH net-next v2 0/2] net: Constify struct genl_small_ops
Date:   Mon,  5 Oct 2020 01:44:15 +0200
Message-Id: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make a couple of static struct genl_small_ops const to allow the compiler
to put them in read-only memory. Patches are independent.

v2: Rebase on net-next, genl_ops -> genl_small_ops

Rikard Falkeborn (2):
  mptcp: Constify mptcp_pm_ops
  net: openvswitch: Constify static struct genl_small_ops

 net/mptcp/pm_netlink.c      | 2 +-
 net/openvswitch/conntrack.c | 2 +-
 net/openvswitch/meter.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.28.0

