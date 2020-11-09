Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA9F2ABE02
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgKIN7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730693AbgKIN7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:59:30 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15FDC0613D3;
        Mon,  9 Nov 2020 05:59:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 62so7193278pgg.12;
        Mon, 09 Nov 2020 05:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=93kJl9t+EVyLrim0/kTQzEnaEemTLzaZCzx+b+Buzug=;
        b=Bw6Ot8pKW7jXBYNQJZmNxyTO7AKyegpvZZkNzeDacmsgFR8LMba+nw7zk81bU8xWKf
         ZhzCzEo9gAaM0Ggtt4VF7JxjXCzS8RBUik6ops1tzrKYuET/gL4pB5DVJ+VZDn4Ip67j
         JhOTZf4huX+tL2z3fozXpGGqzL/Tb09OHMDPSKIYOsMjxisE9mTapi+1JlypvIodW+RF
         AHy6vQ5TLx61Yw1EK/EL4OY5vhEXnXsY1Q02HAde1kRIn+HZxoBK2y0a/YOwZOo5mMvP
         avq4u9TsEQxaXzAs1Unm28qFe7tmPgLjTElHvnQFy6WwhZMsZJEzURV0JrpLkSScIFkr
         k5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=93kJl9t+EVyLrim0/kTQzEnaEemTLzaZCzx+b+Buzug=;
        b=kKfZVcsvRmcfUwYyc3OeIet1BpzUQdw3pcd87jBzCrTxwaVrWSHo7lAcPpS24wSRrP
         e6nVBiPfGkr84sVK+d4utLXQly969fQkj/7cyc1lR9RhwZeV75U5yBm0XPj5QeSVGb4y
         WD5Bpe8ieXpuB8BkT9TqWlYRxZdMUacIYrZA2sFcBk1NE/gkbgs56XMOeEFcXeERZsmR
         ClbfHehf2hTxoAG9nVEtWtqw4RWahjHbN5jdjTAdLpquHwe7yfQoL1cx4pWTUND+TlQX
         nNuKtcnJ3OzD9ThGxb07XkMvqn2antBMohl6gF1+vZ3DH2E3VbJMCbjNTO3VL6mLPIKK
         RCDw==
X-Gm-Message-State: AOAM532LtfyiMmzfshMXivhKKhdOPhL88Ysjn/8V2diXIvSO/WMC8OIj
        +mv5neBOumfa3kQPT1t75PM=
X-Google-Smtp-Source: ABdhPJz11P3hEEJWuHvI43uFw4XHQaQ5HjvpGlgOSVarNOXfvfVp8X0w9BxxXKihDjC6JSXEKJpclg==
X-Received: by 2002:a63:6484:: with SMTP id y126mr13274517pgb.320.1604930369505;
        Mon, 09 Nov 2020 05:59:29 -0800 (PST)
Received: from localhost ([209.9.72.213])
        by smtp.gmail.com with ESMTPSA id t9sm11851517pjo.4.2020.11.09.05.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 05:59:28 -0800 (PST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net 0/2] fix static checker warnings in
Date:   Mon,  9 Nov 2020 21:59:20 +0800
Message-Id: <cover.1604930005.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixed static checker warnings in mptcp_pm_add_timer and
mptcp_pm_alloc_anno_list.

Geliang Tang (2):
  mptcp: fix static checker warnings in mptcp_pm_add_timer
  mptcp: cleanup for mptcp_pm_alloc_anno_list

 net/mptcp/pm_netlink.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.26.2

