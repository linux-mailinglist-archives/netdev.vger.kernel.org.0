Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FF23D6EF
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHFGln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgHFGlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:41:17 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF5C061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 23:41:16 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id m22so5973808eje.10
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 23:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=hA5JCTqaCCREAuEoCIHIc9jLTAOEK7qQNsr7rDO2FA0=;
        b=znsX4TBfyR5p6MWtCGhXPPD+DRyjOvaJE1NVfd8TuaurE/zcGlPGJrBhwa4gq9QOCl
         yR8WY3AZGrKKdYiIaV0mxgadgXt0TvJjTrr0C0cxrvaM5vT9ODEsfpbZkeEfofFzkZM5
         AZ560eyEC4kzBTm8RAon7PesCtCASvRuSvhE/1lJ4clbb1FUimJBWmzzwEBX6xXmXsn2
         Bp/pRIeNTIH3K83zLWOrMn09spoRLlZ/DQZe+NaL50MiCQmtk5drjVKLlIPXd4TbuiGZ
         sczMaCU9T2GPtL4xpFka18bvECRuBM8Pkq/lOeH+SgXi6gP5jHjelfJ/K46eeN2swKRd
         wUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=hA5JCTqaCCREAuEoCIHIc9jLTAOEK7qQNsr7rDO2FA0=;
        b=egpJUSbBddfaF8TM9x+hD2CAD11amq8ZElnM2ik1tC9vI5dRUyKQJWKHPo/MGrSJrO
         EYcE6uszk1oewytjCSwcnvPovn2bl57DlVvUviP1n20S1y8JiKkq217OXBP5XyOXlEnz
         lEXc0DK3ZPDzfRHC7AGMdpuvxXthEb0w0cmw1zp/NUo8AI0zuskBgOUglK7/CbuQ/mKt
         ysTVM+92qrDiNTNzPZz9x+C1wQiUQJhEHXYdI/gunuYuLRzlEpALRCUAjhyaTvObjN4d
         w5Wh4fNbabEWEwrKIzz1uVDcTLmNYi7guCbM6XWuLceq79F0DGlG/RCZ1O/FyieLtrZ7
         u/aw==
X-Gm-Message-State: AOAM532zFAmMPFzqQ1lKs8cGUuIMrWq3VTFIPfNKT839Ft9klBP0yK3y
        SQGZmN/I+rz7kbi1ILKgtJpmCVDNoleCbznUdm0IMFgVY1FBFiNh36bi2SXzG64T8nTbEun46jK
        bdLdSSf8KB/rSTpY=
X-Google-Smtp-Source: ABdhPJx36tiST5AcBE4fms9ytZlygeNek5jU38om01yv8EofclOiCTv1Z38KD4nfsreMho4H3f96jw==
X-Received: by 2002:a17:906:7253:: with SMTP id n19mr3006802ejk.387.1596696073363;
        Wed, 05 Aug 2020 23:41:13 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id h18sm2880984edw.56.2020.08.05.23.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 23:41:12 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        KOVACS Krisztian <hidden@balabit.hu>,
        Patrick McHardy <kaber@trash.net>
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: initialize fastreuse on inet_inherit_port
Date:   Thu,  6 Aug 2020 08:41:06 +0200
Message-Id: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
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

Tim Froidcoeur (2):
  net: refactor bind_bucket fastreuse into helper
  net: initialize fastreuse on inet_inherit_port

 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 99 ++++++++++++++++--------------
 net/ipv4/inet_hashtables.c         |  1 +
 3 files changed, 59 insertions(+), 45 deletions(-)

-- 
2.25.1


-- 


Disclaimer: https://www.tessares.net/mail-disclaimer/ 
<https://www.tessares.net/mail-disclaimer/>


