Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9261322BC
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgAGJm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:42:29 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:47187 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgAGJm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:42:29 -0500
Received: by mail-pl1-f202.google.com with SMTP id g16so3191395plo.14
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SXoDe/k8aiSVjnD1sy0eKxdpitDDrivUkflvobi24MY=;
        b=dW+lSPgff/g6IQxxSRbl8kqiKWy6UKb2nB5t2PxivOhiOjT3CsygXUD0T6fRrLaLIV
         elF8joAFTMoVE6whXW8ui23d/261sAYqSk5D1xCUQnI6XGqJnqwMc12XTLFbVCjGyGKY
         jvGjS5zH51rVpxj9V5PXhcJIbz74+iVAo7yvu9H0vTlKSvf86dNtQeZw5EEhF5BxxFsc
         FrpTiZsFN0aKaugr2aUFXne3m7bhZgY+qFwf/A6D0QOJZI4+BEPq9eWgumRgZbKwP07J
         CkADGorvFHYa2St2gnB1J+V8+dC5D1/8BYh8uFG30s44lrt9phq5cCcXxEhoaeLl1C80
         WLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SXoDe/k8aiSVjnD1sy0eKxdpitDDrivUkflvobi24MY=;
        b=nWLNTdySb64tInA5eLq68EOgTPGtdWJPwxIex52XSNGkYxv5LhxxxMF1gsPdiPrW+H
         XdlsurA+ea3QO8aRqJA6gAYGBw9jZj/Bpvq7oCJKBktcj7Vm2Jdvsl/Xu/TRJH4VgqTb
         w1Lxqjp7mGA3EgXJXBpW4WqY0gpAJXjoDwbIPXLwndPjzFVL3qha6QDc5s5wZhWq+E9B
         PUTc2LHOnGe5dbcOzs6qRd8wgIn6sjvZiR10tLtq5jXtYBk7CuWz0ahU3C/dovui/pIU
         dw9EXq5sSu+hXsojn5Bqdg8e8LK7m0ZiumNzLGJUgGEqk2GRmd8ZpC7vke3Rb39l41ok
         VWKg==
X-Gm-Message-State: APjAAAWrIE2ynkO2gSEFYfn80jhOZrcbDCXcmSfMIDaqRYbjynpqwHoq
        fumJTcczxCX+zBbHQX+CpD/ApdSIEGqrCw==
X-Google-Smtp-Source: APXvYqw/fMW+uljm/x111gZz0BAxOC95HmDrHrmqqcBDai6F8nS0vOVr6PKockxy7Flp+7r9mWyeug3nUzJ/xg==
X-Received: by 2002:a63:9d07:: with SMTP id i7mr120984524pgd.344.1578390148597;
 Tue, 07 Jan 2020 01:42:28 -0800 (PST)
Date:   Tue,  7 Jan 2020 01:42:23 -0800
Message-Id: <20200107094225.21243-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 0/2] vlan: rtnetlink newlink fixes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch fixes a potential memory leak found by syzbot

Second patch makes vlan_changelink() aware of errors
and report them to user.

Eric Dumazet (2):
  vlan: fix memory leak in vlan_dev_set_egress_priority
  vlan: vlan_changelink() should propagate errors

 net/8021q/vlan.h         |  1 +
 net/8021q/vlan_dev.c     |  3 ++-
 net/8021q/vlan_netlink.c | 19 ++++++++++++-------
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.24.1.735.g03f4e72817-goog

