Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700B3E94DC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhHKPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhHKPpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:45:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2650AC061765;
        Wed, 11 Aug 2021 08:45:15 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so5637368pjl.4;
        Wed, 11 Aug 2021 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d1fBSMO8d3WQBBLjvkT0bpn1LKM/iz5SAmDftKeNMB8=;
        b=BmCWO1tbO1zXvuihAf08kdEp8dT0Qux/fVd0UCruxCz8dUUHE3TfxjzSlQo4MK47jC
         7+GH52d+48s23v0pyUQ+KkO5XY11kpWK92ljGFYL9qK3wYHgNgNmZpjhbqaMMNjfqOL9
         ZWlAK/gTOr0wVa0+11EVcOh8P6gEn+UiTJKD3jBgPtRMJbYZIQbGf7zN9EtGhotgphmj
         0UwdSB5yGAK23FHhuDrs69RP1SrPkr/jin68G475l/xlHBZ/RynHJPSzvwc8kbkNQdK1
         c+0JjT4giX3CZQFDwRuQXC2GqUS3Yl+4LboJXemumKSH52wE6hNKhmVMJaovcO+cxBGw
         hRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d1fBSMO8d3WQBBLjvkT0bpn1LKM/iz5SAmDftKeNMB8=;
        b=IDfgNWzmnCJxJPS8QytzgdQE01X+oD2sB+wf4D9DaHPDOS5w1ly4pP588VT16c1ALo
         O3FjKyP0tpytagA/0eOt3rCsyyKp85y/CMvE5nI2gBe4ICWNvKzfRyVQjwvaKhDxkEMc
         IkE/DBB6fbdtSKqk34dhbXYv8Muqghbu6Q2MwcY01pO0oZIyUQg2f20tq/rv1iIRrh2I
         TdCLywtzmXenT/MGlKcza5VDxjEl8CoMl4G+6r0ZEC+aOpLQZ09NRQJ/87VHAoyTG56e
         LYisl0acZxoZ2NSBpv/sJoi45w+MfDBJhe07sT5d7NnVEYa5PuWslqteW2HU/Id7czpW
         yXyw==
X-Gm-Message-State: AOAM530uI9U3B+X5rjdsQzQFV2qQh6nTaZYQHz2GIEIB30B3/aKlk+dJ
        KBjMnZ6PvNphX7stPcfNolV/zkmxbHQmg+Zbcgw=
X-Google-Smtp-Source: ABdhPJxQm+3TEag+gAYWNdFwOL1dg/GDA9UtwuadIugioL+AsOAlnlZlQ45IHkhQgYfG2wSL2uKlxw==
X-Received: by 2002:a63:88c7:: with SMTP id l190mr344415pgd.438.1628696714396;
        Wed, 11 Aug 2021 08:45:14 -0700 (PDT)
Received: from localhost.localdomain ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id q21sm32051273pgk.71.2021.08.11.08.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 08:45:13 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        minhquangbui99@gmail.com, lesedorucalin01@gmail.com
Subject: [PATCH v2 0/2] UDP socket repair
Date:   Wed, 11 Aug 2021 22:44:02 +0700
Message-Id: <20210811154402.6842-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series implement UDP_REPAIR sockoption for dumping the corked packet
in UDP socket's send queue. A new path is added to recvmsg() for dumping
packet's data and msg_name related information of the packet.

Version 2 changes:
- rebase to net-next

Thanks,
Quang Minh.

Bui Quang Minh (2):
  udp: UDP socket send queue repair
  selftests: Add udp_repair test

 include/linux/udp.h                      |   3 +-
 include/net/udp.h                        |   2 +
 include/uapi/linux/udp.h                 |   1 +
 net/ipv4/udp.c                           |  94 +++++++++-
 net/ipv6/udp.c                           |  56 +++++-
 tools/testing/selftests/net/.gitignore   |   1 +
 tools/testing/selftests/net/Makefile     |   1 +
 tools/testing/selftests/net/udp_repair.c | 218 +++++++++++++++++++++++
 8 files changed, 371 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/net/udp_repair.c

-- 
2.17.1

