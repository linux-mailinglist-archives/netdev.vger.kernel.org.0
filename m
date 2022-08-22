Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF759BC56
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiHVJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiHVJKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:10:32 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CE219C06;
        Mon, 22 Aug 2022 02:10:31 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id b2so7657032qvp.1;
        Mon, 22 Aug 2022 02:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wjrH7CkWFBaGclBblrE7HFL002i1VDYL9JXtkvBlksY=;
        b=m9Eo8OodVq1Ets/OEiRoWJrWFhfn0xRM++GAXhZxITlqyA6MRrqB7PExQKR81BqoMd
         3OOLgss+leeXQWJHXQTYBgXPN43Kk3H4s0SIfBeP7UDdI6AFj1JMbFxzr5rsNz1tBPdE
         Iv1VKq0X0XEs8Ff5FzfIuStRtbAlMk+CfHruqHibJIINFwKVRjgmYjmrSfhrY0o2AAGX
         3RnZFMzTzPbjj6It6Z7AtISosQrg2T+H5v/CINVs7+rHRhdVXOLdF64GuJ+Sv8IWUjku
         ocK/gD5hezM0DCBxWrhwDB6vj7fPo8bdqadR+oH6EAXbsbaOLqG16LkJ0vbK8np0Vgtg
         Zejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wjrH7CkWFBaGclBblrE7HFL002i1VDYL9JXtkvBlksY=;
        b=1u/MkqwwBD1wTIedTEDb64YZVUpumM2wELjlyGYQ8+cTlSfx+fax/IVn/GTpJ8crSc
         S6uGCz9C0xSQ3DmbMjuqB76DWXa/KQlWw/C3/fkorIQ/2/moA/j99thnj8cvurpJj7KE
         HQ5pLW8YDoYWM9nonvEiAEJ94ytZuvNCe4PuqbPPW99pOqsaorx0WulGqmDj5bBbETf9
         XkGHVgyTgBI6EoquXE5o4WPQmU4RMt77GKGYZNJQwkJi59KKdaL4rWGXA+dFsQFUuWuv
         67aOMJgx21rQsNwP60zwaPQ9d5hBJvu8IVgX5wGBozoVWsAPJrU3a77Lbg2e0b80fCb8
         kWHA==
X-Gm-Message-State: ACgBeo1c1yQaL1jcJ/giqL8QQPyvKMDK1sFC/ns4TZPprBnVmfvIktPT
        sC73Es2Ca0JAQzuLpgGOXfZMgOLrCQ==
X-Google-Smtp-Source: AA6agR7wPzemjT6q2f5TdY9MG6eTw4P2dNhfct8chm1wIQ0lDkA2XQMVyUa58/ZjoALrmj5p72eA/w==
X-Received: by 2002:a05:6214:27cb:b0:496:ac94:723d with SMTP id ge11-20020a05621427cb00b00496ac94723dmr14805024qvb.6.1661159430322;
        Mon, 22 Aug 2022 02:10:30 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id t201-20020a37aad2000000b006b9264191b5sm11046904qke.32.2022.08.22.02.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:10:29 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure infrastructure
Date:   Mon, 22 Aug 2022 02:10:17 -0700
Message-Id: <cover.1661158173.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Hi all,

Currently sockets (especially UDP ones) can drop a lot of packets at TC
egress when rate limited by shaper Qdiscs like HTB.  This patchset series
tries to solve this by introducing a Qdisc backpressure mechanism.

RFC v1 [1] used a throttle & unthrottle approach, which introduced several
issues, including a thundering herd problem and a socket reference count
issue [2].  This RFC v2 uses a different approach to avoid those issues:

  1. When a shaper Qdisc drops a packet that belongs to a local socket due
     to TC egress congestion, we make part of the socket's sndbuf
     temporarily unavailable, so it sends slower.
  
  2. Later, when TC egress becomes idle again, we gradually recover the
     socket's sndbuf back to normal.  Patch 2 implements this step using a
     timer for UDP sockets.

The thundering herd problem is avoided, since we no longer wake up all
throttled sockets at the same time in qdisc_watchdog().  The socket
reference count issue is also avoided, since we no longer maintain socket
list on Qdisc.

Performance is better than RFC v1.  There is one concern about fairness
between flows for TBF Qdisc, which could be solved by using a SFQ inner
Qdisc.

Please see the individual patches for details and numbers.  Any comments,
suggestions would be much appreciated.  Thanks!

[1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
[2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/

Peilin Ye (5):
  net: Introduce Qdisc backpressure infrastructure
  net/udp: Implement Qdisc backpressure algorithm
  net/sched: sch_tbf: Use Qdisc backpressure infrastructure
  net/sched: sch_htb: Use Qdisc backpressure infrastructure
  net/sched: sch_cbq: Use Qdisc backpressure infrastructure

 Documentation/networking/ip-sysctl.rst | 11 ++++
 include/linux/udp.h                    |  3 ++
 include/net/netns/ipv4.h               |  1 +
 include/net/sch_generic.h              | 11 ++++
 include/net/sock.h                     | 21 ++++++++
 include/net/udp.h                      |  1 +
 net/core/sock.c                        |  5 +-
 net/ipv4/sysctl_net_ipv4.c             |  7 +++
 net/ipv4/udp.c                         | 69 +++++++++++++++++++++++++-
 net/ipv6/udp.c                         |  2 +-
 net/sched/sch_cbq.c                    |  1 +
 net/sched/sch_htb.c                    |  2 +
 net/sched/sch_tbf.c                    |  2 +
 13 files changed, 132 insertions(+), 4 deletions(-)

-- 
2.20.1

