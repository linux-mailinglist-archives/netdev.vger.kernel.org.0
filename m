Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E33252537
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHZBt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHZBtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC4C061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o21so208338wmc.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FSqpiVb2VHbicFs91NoR7CGMW6s7gPW0OnsX8hYxTdk=;
        b=OR7jYTnnl/7sfX3AWTgCn4ixomtkfiZbj9dmPl59jLvYB4wAxvvAQYP9KwBCCr0PZk
         jhYD8aHRPiVu/DvukwWmIbdCMZqLYcIkdS+nS5kfsoH/bNkhV2MoWoATWWK9VJG3DgRP
         vQE6g3IBDMOdgAXtgs+LUzJocokrARZoJOPkh9iZDZKXc4Ajo+F984BG34yLGmoLwXtr
         lVLW36hRIx5lgf3awKaV90QtJi+o8gImOq4Hfnw+G4557klA7+MibaQU0k506N4D/nSU
         RLYWeBerdZs8aRymiT32FFpDrmATQCszSfD0t7SImQc+/1hIg28l4HkChBzjGSZkCJYV
         c8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FSqpiVb2VHbicFs91NoR7CGMW6s7gPW0OnsX8hYxTdk=;
        b=hRv4OzaFPhl4GiZT209yj1PErWF2FjmLYhnxA2ZIF36+61gNAJkhBnMSGkqMYdHWe0
         GwsphwcVEWm3xKEHZFrkKLY02Oi8tswezKzTtptn83CnXXtKNsnWi3K22jMNmvPNKniy
         /GukbgrD2IK0C8A4tL8tNDhsIyHnoTlgI8GBr+TrxhCcZ9hbfXL0VqPGmHh/TOV4iHD5
         r2h4X81A9R3F+FMdgypwnNmYThiDk0js2DaILXd/wJHV6SCXdyP3bMlWiQR9r5c+V061
         vRrgJ1sc0cY8YHjUpcAWs/Cx2XXCgU8nT0seImMMFk/oywfvAfrEao9ZorfaDhyY2+pN
         m2CQ==
X-Gm-Message-State: AOAM531K41gp//UmuY6tEJj+yLNtoi9vRAhnIIy9IqShDeRXr59ypvds
        9Bdpr4QKtBWs2y4P0FvHOqfJEw==
X-Google-Smtp-Source: ABdhPJwNMNkrni4rBF7mJl0ZgMtnGn8jDQ5Kr9MAaUf7fQSiMZ34ZwUojW/wTvT0Oe3KXMiZbzqt9w==
X-Received: by 2002:a7b:cc95:: with SMTP id p21mr4321648wma.167.1598406590787;
        Tue, 25 Aug 2020 18:49:50 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:50 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/6] xfrm: Add compat layer
Date:   Wed, 26 Aug 2020 02:49:43 +0100
Message-Id: <20200826014949.644441-1-dima@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Patches as a .git branch:
https://github.com/0x7f454c46/linux/tree/xfrm-compat-v2

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org

Dmitry Safonov (6):
  xfrm/compat: Add 64=>32-bit messages translator
  xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
  netlink/compat: Append NLMSG_DONE/extack to frag_list
  xfrm/compat: Add 32=>64-bit messages translator
  xfrm/compat: Translate 32-bit user_policy from sockptr
  selftest/net/xfrm: Add test for ipsec tunnel

 MAINTAINERS                            |    1 +
 include/net/xfrm.h                     |   32 +
 net/netlink/af_netlink.c               |   48 +-
 net/xfrm/Kconfig                       |   11 +
 net/xfrm/Makefile                      |    1 +
 net/xfrm/xfrm_compat.c                 |  609 +++++++
 net/xfrm/xfrm_state.c                  |   11 +-
 net/xfrm/xfrm_user.c                   |   79 +-
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    1 +
 tools/testing/selftests/net/ipsec.c    | 2195 ++++++++++++++++++++++++
 11 files changed, 2953 insertions(+), 36 deletions(-)
 create mode 100644 net/xfrm/xfrm_compat.c
 create mode 100644 tools/testing/selftests/net/ipsec.c

-- 
2.27.0

