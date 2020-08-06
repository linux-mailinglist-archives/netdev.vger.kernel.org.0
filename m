Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF01A23DF50
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgHFR3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729889AbgHFRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:00:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1802C034600
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 05:32:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a26so24316742ejc.2
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 05:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBUeg6ZgfiBHlBkgCw/YPENtqIybhDV/THXpJy1l8Ak=;
        b=E5ZH4bpBOUNIObWXCgJBPo0fRnChPgetEBnLT1TtXjqiV+wGDSaMnkFJ3f9qcXcv5C
         /xtMPo552QhFx2AbPNwgFuiWczZs671hm+Y3fIx50EZHhk+C8+tueK+lc5LggNith+WZ
         cbEd48HrUUD29sjHcORxdcSp/AJy+c2/lJQU0frs2bzofLtPulrC9FCMgdx5kT8NeQvm
         aJfWEOXfbLTcn5h5+XMjyGWFp7S2i9LQ5Fbg2GDaVGpjvuxPL7eedVVIEEjrMjzAlbGI
         ykpo+LgjwzrhCjwWnHtVog37xoaLj+uks00l99NHcpHg/m+VN8EDwtlJFKd3uXUduf//
         K0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBUeg6ZgfiBHlBkgCw/YPENtqIybhDV/THXpJy1l8Ak=;
        b=YSTfZ88EaUaEF06LIIiDBW6iadGK4AO3z+qAQJJZuCMYiyvQtisTqiOqtKi5ccfe50
         l0sema5C2aNc4uYiWajN1YIAO3Tvl2Z0H4DRFqUFwaWtoo4eYLs8BemD2CaedGZY9VFl
         NPHXhVlkGbthFDborZ12eNc9n2Hjc2O2CXN2SIbCBxlHsd4VHqo6Dkl9l1gBywiCc9ov
         /Hsv96KmNnQLFBMY4WiXrdgCElsVaApc0UWr/pkG4Gu8IjwZOn1iVjZtObNVzZXSoTRL
         7P2FWYu5Ok82Wul/5zffmb5rIRbD3m4svpl1pjHNytflYXIZGDO1J5PCndtd+1I+y/Jf
         91rw==
X-Gm-Message-State: AOAM530Ac6h045k6N4fYzePSVVb9cB+oVulwjVmdlI4puLZ5PVei4juA
        MV/Lunj0+HFlP5BzGzcXg9mVHw==
X-Google-Smtp-Source: ABdhPJyhhBpJwzxhDnBKBjHz1AevD4rapS/DwSsy6qNYU48uAH6pkx9QlBz57JKuB5fl8Su5P+B/ZQ==
X-Received: by 2002:a17:906:3685:: with SMTP id a5mr3915681ejc.298.1596717124401;
        Thu, 06 Aug 2020 05:32:04 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id c5sm3695778ejb.103.2020.08.06.05.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 05:32:03 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        KOVACS Krisztian <hidden@balabit.hu>
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 0/2] net: initialize fastreuse on inet_inherit_port
Date:   Thu,  6 Aug 2020 14:30:21 +0200
Message-Id: <20200806123024.585212-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
behaviour or in the incorrect reuse of a bind.

the kernel keeps track for each bind_bucket if all sockets in the
bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
These flags allow skipping the costly bind_conflict check when possible
(meaning when all sockets have the proper SO_REUSE option).

For every socket added to a bind_bucket, these flags need to be updated.
As soon as a socket that does not support reuse is added, the flag is
set to false and will never go back to true, unless the bind_bucket is
deleted.

Note that there is no mechanism to re-evaluate these flags when a socket
is removed (this might make sense when removing a socket that would not
allow reuse; this leaves room for a future patch).

For this optimization to work, it is mandatory that these flags are
properly initialized and updated.

When a child socket is created from a listen socket in
__inet_inherit_port, the TPROXY case could create a new bind bucket
without properly initializing these flags, thus preventing the
optimization to work. Alternatively, a socket not allowing reuse could
be added to an existing bind bucket without updating the flags, causing
bind_conflict to never be called as it should.

Patch 1/2 refactors the fastreuse update code in inet_csk_get_port into a
small helper function, making the actual fix tiny and easier to understand. 

Patch 2/2 calls this new helper when __inet_inherit_port decides to create
a new bind_bucket or use a different bind_bucket than the one of the listen
socket.

v3: - remove company disclaimer from automatic signature
v2: - remove unnecessary cast 

Tim Froidcoeur (2):
  net: refactor bind_bucket fastreuse into helper
  net: initialize fastreuse on inet_inherit_port

 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 97 ++++++++++++++++--------------
 net/ipv4/inet_hashtables.c         |  1 +
 3 files changed, 58 insertions(+), 44 deletions(-)

-- 
2.25.1

