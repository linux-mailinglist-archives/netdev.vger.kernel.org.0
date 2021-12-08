Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B884B46D631
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhLHO6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhLHO6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:58:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AD5C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:55:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso2289344pjb.2
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqjspLz6U3eZyTiAYtbUC7kquTjaijspSXUx2C+qFF8=;
        b=Lf2Rr9EH1RbODyTfOCwjYJElvwEmepRMoakDWIXN8wY+6YsvpLrsFiXgxC3MP4cTqU
         JRX9ZCchAjtrtLS0RpzZECm+ZS+j2uoHI7rWtHBUU3fBFRaEEfVfBhwBH+e9UL7qEvre
         8mfIupeEVq8iljqj6mmXPtBIti2CDu8RjXzPhDtZFb+pC5gLFFR/2cQ3vxo2zWj2EDLz
         8pHep5YeJplMhBQ67CxT2SKauV/Jc9sfAXz4pmiy9cVUgObxmzXAeizRtFWJxevGYpE0
         Shoocdi34zpGm2FG2cZgQ+Et4hrrCv2oZ4TITduLglkgFzWYLDFjfNIEbwwwflEuHSVZ
         A83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqjspLz6U3eZyTiAYtbUC7kquTjaijspSXUx2C+qFF8=;
        b=f2ZWP12/B7LLKiu2O/EWR46vUN3yRPtylhyyAlJCqzn7rkRc58NE5oudwc03LYo4Tr
         lTiAI9a+6g/9aEk7T6EZ/Gd+AWKHnLgIl4fySIEXSCQomfvl+Y8FLszYTRue2W3Fcugv
         iqCw6OuWq8/Alg1VqvqWkSrErIgfCzENz5c1tHs0DRxPwKY/sXfNrXKbHDE1syOeLXkv
         uKwyy/To33u5UtSIMPa7lQReKWFgpIYfVV3KiBE+FqG70SMKqa4AV6TwrZVubil8TiDr
         h5PRkcBfgOgG4BcWWWBq+1/sIFA24d/RFXUtfDlSfUSc4syTRBJTARCMroRHzaTzzpJ/
         pUvw==
X-Gm-Message-State: AOAM531QRu5sKEzi3xKyuUNqwhgCMy/48zhCsh4nIPkrcGmI9IfaQ5cC
        fRMcYry5EpXMFDYwqqjR4Sd9mUWhzXqNEQ==
X-Google-Smtp-Source: ABdhPJxjWBbdMu81LeHxTUqR7v5ETJFUlTI+T4uN6dgYIg/s9yX2fxvbdVOUU8JvuEG52zWO5gmMdw==
X-Received: by 2002:a17:902:c245:b0:141:f279:1c72 with SMTP id 5-20020a170902c24500b00141f2791c72mr59598522plg.18.1638975307970;
        Wed, 08 Dec 2021 06:55:07 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id kk7sm7562763pjb.19.2021.12.08.06.55.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:55:07 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net v5 0/3] fix bpf_redirect to ifb netdev
Date:   Wed,  8 Dec 2021 22:54:56 +0800
Message-Id: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patchset try to fix bpf_redirect to ifb netdev.
Prevent packets loopback and perfromance drop, add check
in sch egress.

Tonghao Zhang (3):
  net: core: set skb useful vars in __bpf_tx_skb
  net: sched: add check tc_skip_classify in sch egress
  selftests: bpf: add bpf_redirect to ifb

 net/core/dev.c                                |  3 +
 net/core/filter.c                             | 12 ++-
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
 create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh

-- 
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

