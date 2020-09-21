Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0BA2727BB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgIUOhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbgIUOhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:01 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D44C0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:00 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b79so12972658wmb.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8pcZTN+i/7Fb4vyTfG/UopYgDCcumlDoCD0Nm0/ODM=;
        b=BuWNVkVr+wdx6IkSh0we8UYHMffxew16ocu/iGlVvYfgUg4rEdJVZkztwR2qvUWYjb
         lDc1zsfBltXWC/+nWZ+9wHihwIGvCc/Q6Wq9NOKrL3vZHrzzjpPOPlyTHZjB6x+wFY6o
         f1CGSkr4HoW1CwUGvfjIjxF4VhJbuo01ipe7SbBU4fbK/1k2diIlFUUjVDNfxkTN1koc
         5sXZk8Bkgawx9re+wKExncSEd750J/1+bCIneEXYBOm72sId9diP9GdgKobiWhtlxNVA
         NhNdNxERkEbKiF8DVGGnDBLJdA86/ST/PkCdSmwz6SloR33+7bOPaik7waYy7BJwdhSu
         io+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8pcZTN+i/7Fb4vyTfG/UopYgDCcumlDoCD0Nm0/ODM=;
        b=SHTVOXitedgsF+WAgsw3U3BGtEpZBt6sJnWE9CoO/LORkMNwBuu/+fLaGT0U56k/M5
         hea3fajQCRMnwNBV9EZ/39K0/Btq9v8hhe790eqjq4S6qt+inYHYgMbxxZ5gwEqzpgnZ
         ZjmuGdkjL/cilDdWakyZXZFbotfcegWiMSccoyVeTzaBJDGnxh4r/V097EyY4TX4SFYl
         Vg9ya+4qoqlU3XL9H1TtPFDZ2iQQZTS1GdtyE0rGE6SEwGWtfMvUup6UY/LPes0f5ak3
         mDkDf7mcrJh5hx5mYw1GCZL9H1xQr7I6Klomc1lESdacPnd2TrPSWWbeDTjObcg6tbQC
         j9mQ==
X-Gm-Message-State: AOAM53106TEMEOX4u68JIqB3vBodM4C5M+vqbj+gIxZ8lUWm60KMgwIA
        7YIc/cQmdXZLncUDPOf37mBySA==
X-Google-Smtp-Source: ABdhPJyUhXBQD62+KY+Pt4EzYAFVHYmRbhAVbXQ3qfCQzil0ho1EGOP5684hLHI3efWhFKAYI1JaUg==
X-Received: by 2002:a1c:f20b:: with SMTP id s11mr203831wmc.144.1600699019590;
        Mon, 21 Sep 2020 07:36:59 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:36:58 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v3 0/7] xfrm: Add compat layer
Date:   Mon, 21 Sep 2020 15:36:50 +0100
Message-Id: <20200921143657.604020-1-dima@arista.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v2:
- added struct xfrm_translator as API to register xfrm_compat.ko with
  xfrm_state.ko. This allows compilation of translator as a loadable
  module
- fixed indention and collected reviewed-by (Johannes Berg)
- moved boilerplate from commit messages into cover-letter (Steffen
  Klassert)
- found on KASAN build and fixed non-initialised stack variable usage
  in the translator

The resulting v2/v3 diff can be found here:
https://gist.github.com/0x7f454c46/8f68311dfa1f240959fdbe7c77ed2259

Patches as a .git branch:
https://github.com/0x7f454c46/linux/tree/xfrm-compat-v3

Changes since v1:
- reworked patches set to use translator
- separated the compat layer into xfrm_compat.c,
  compiled under XFRM_USER_COMPAT config
- 32-bit messages now being sent in frag_list (like wext-core does)
- instead of __packed add compat_u64 members in compat structures
- selftest reworked to kselftest lib API
- added netlink dump testing to the selftest

XFRM is disabled for compatible users because of the UABI difference.
The difference is in structures paddings and in the result the size
of netlink messages differ.

Possibility for compatible application to manage xfrm tunnels was
disabled by: the commmit 19d7df69fdb2 ("xfrm: Refuse to insert 32 bit
userspace socket policies on 64 bit systems") and the commit 74005991b78a
("xfrm: Do not parse 32bits compiled xfrm netlink msg on 64bits host").

This is my second attempt to resolve the xfrm/compat problem by adding
the 64=>32 and 32=>64 bit translators those non-visibly to a user
provide translation between compatible user and kernel.
Previous attempt was to interrupt the message ABI according to a syscall
by xfrm_user, which resulted in over-complicated code [1].

Florian Westphal provided the idea of translator and some draft patches
in the discussion. In these patches, his idea is reused and some of his
initial code is also present.

There were a couple of attempts to solve xfrm compat problem:
https://lkml.org/lkml/2017/1/20/733
https://patchwork.ozlabs.org/patch/44600/
http://netdev.vger.kernel.narkive.com/2Gesykj6/patch-net-next-xfrm-correctly-parse-netlink-msg-from-32bits-ip-command-on-64bits-host

All the discussions end in the conclusion that xfrm should have a full
compatible layer to correctly work with 32-bit applications on 64-bit
kernels:
https://lkml.org/lkml/2017/1/23/413
https://patchwork.ozlabs.org/patch/433279/

In some recent lkml discussion, Linus said that it's worth to fix this
problem and not giving people an excuse to stay on 32-bit kernel:
https://lkml.org/lkml/2018/2/13/752

There is also an selftest for ipsec tunnels.
It doesn't depend on any library and compat version can be easy
build with: make CFLAGS=-m32 net/ipsec

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org

Dmitry Safonov (7):
  xfrm: Provide API to register translator module
  xfrm/compat: Add 64=>32-bit messages translator
  xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
  netlink/compat: Append NLMSG_DONE/extack to frag_list
  xfrm/compat: Add 32=>64-bit messages translator
  xfrm/compat: Translate 32-bit user_policy from sockptr
  selftest/net/xfrm: Add test for ipsec tunnel

 MAINTAINERS                            |    1 +
 include/net/xfrm.h                     |   33 +
 net/netlink/af_netlink.c               |   47 +-
 net/xfrm/Kconfig                       |   11 +
 net/xfrm/Makefile                      |    1 +
 net/xfrm/xfrm_compat.c                 |  625 +++++++
 net/xfrm/xfrm_state.c                  |   77 +-
 net/xfrm/xfrm_user.c                   |  110 +-
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    1 +
 tools/testing/selftests/net/ipsec.c    | 2195 ++++++++++++++++++++++++
 11 files changed, 3066 insertions(+), 36 deletions(-)
 create mode 100644 net/xfrm/xfrm_compat.c
 create mode 100644 tools/testing/selftests/net/ipsec.c


base-commit: ba4f184e126b751d1bffad5897f263108befc780
-- 
2.28.0

