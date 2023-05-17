Return-Path: <netdev+bounces-3188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C726705EAD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A271C20AC5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD67E440F;
	Wed, 17 May 2023 04:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B7D440D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:28:44 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471362112
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:43 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-561c1ae21e7so2682127b3.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684297722; x=1686889722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bx0BI8qvRbWgHkfNLXMpKsiKfcxSf/XnzRyDv4r+8iU=;
        b=OG0YygWuXGyxv8xZGMkLmhK+GZ/w4SXYnya4kY6Z/oZWDCKHOKx9eHoaXADCrKn+Xu
         y4PSyL7JuPZBAYqfti24q4NAY3LwY7IR126F1tya3twlzemHEBRGhERViIZ0O6nJSz0A
         zbhbADWlKK7D88oettGqi7Z5Wqlcm6ZvQf7hYze6oejLGUpeRfFrIsC6GIoEPYfDVYyW
         38frf0d9VZzl55KE/SUPSLe+69MriU7Bi8j7tMTJNhz9nVDNSzBbxE5ljPsd5CBWh5bA
         +OceEIPR2P33PCkaqpb2bYmdkjzbgFSoe/DRdBH5yBznbguRKlUnuC/lUhB06Joz3fTW
         mQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684297722; x=1686889722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bx0BI8qvRbWgHkfNLXMpKsiKfcxSf/XnzRyDv4r+8iU=;
        b=LzE5unjjIa6N8IUOXuzjkTHCRbKoo3pNmOrl5I8SEicHM2Ry/tNHtQ05+YrCn7mcnY
         vJVMEKtzxGOq4Raw45S7ZeO439qnqqcEmfMdH0T29z5G3PhoAy8IbMwi/VIcfjb/uhQa
         KA00/C0u0zSgSJvIsR/KKiIZtigKTmCZ5LYuXlYS5TUT+Xdny0AsmXtBJgYQYf+VXYRo
         z4cNGY6Nny1xchwZPwx90tatydIG6LnUf8e9yDYL8FZYHgioN8c1RJZJGcxdNHsiMPzt
         D1mNHm1lPKG2FMm3o1O+M6ZrUuKKEW6xSwzcprZRjVEUFOtV1fO7Qj3Wgh/+oNuOjd7H
         5UjQ==
X-Gm-Message-State: AC+VfDzRoIf1/Q0ElKQIh5tn83SXPsta02YmRLS8qWgnVyn9XOZghaYl
	TEjwQRs/fUTUN9ytH/4uiMaMtB2ZWDsmRg==
X-Google-Smtp-Source: ACHHUZ7DAnvQGEAgBzsR2KH2ejoq1lFEpgChwZZr0C1dv0F1D/k/62u5HjvxMHzCjOHtBOGnKbQ+tA==
X-Received: by 2002:a0d:d58a:0:b0:561:aa98:1a99 with SMTP id x132-20020a0dd58a000000b00561aa981a99mr2466274ywd.45.1684297722051;
        Tue, 16 May 2023 21:28:42 -0700 (PDT)
Received: from kickker.attlocal.net ([2600:1700:6cf8:1240:30e8:b259:6a48:875c])
        by smtp.gmail.com with ESMTPSA id x136-20020a81a08e000000b0054fcbf35b94sm388780ywg.87.2023.05.16.21.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 21:28:41 -0700 (PDT)
From: Kui-Feng Lee <thinker.li@gmail.com>
X-Google-Original-From: Kui-Feng Lee <kuifeng@meta.com>
To: netdev@vger.kernel.org,
	ast@kernel.org,
	martin.lau@linux.dev,
	kernel-team@meta.com
Cc: Kui-Feng Lee <kuifeng@meta.com>
Subject: [RFC PATCH net-next 0/2] Mitigate the Issue of Expired Routes in Linux IPv6 Routing Tables
Date: Tue, 16 May 2023 21:27:55 -0700
Message-Id: <20230517042757.161832-1-kuifeng@meta.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The size of a Linux IPv6 routing table can become a big problem if not
managed appropriately.  Now, Linux has a garbage collector to remove
expired routes periodically.  However, this may lead to a situation in
which the routing path is blocked for a long period due to an
excessive number of routes.

For example, years ago, there is a commit about "ICMPv6 Packet too big
messages".  The root cause is that malicious ICMPv6 packets were sent
back for every small packet sent to them. These packets have to
lookup/insert a new route, putting hosts under high stress due to
contention on a spinlock while one is stuck in fib6_run_gc().

Why Route Expires
=================

Users can add IPv6 routes with an expiration time manually. However,
the Neighbor Discovery protocol may also generate routes that can
expire.  For example, Router Advertisement (RA) messages may create a
default route with an expiration time. [RFC 4861] For IPv4, it is not
possible to set an expiration time for a route, and there is no RA, so
there is no need to worry about such issues.

Create Routes with Expires
==========================

You can create routes with expires with the  command.

For example,

    ip -6 route add 2001:b000:591::3 via fe80::5054:ff:fe12:3457 \ 
        dev enp0s3 expires 30

The route that has been generated will be deleted automatically in 30
seconds.

GC of FIB6
==========

The function called fib6_run_gc() is responsible for performing
garbage collection (GC) for the Linux IPv6 stack. It checks for the
expiration of every route by traversing the tries of routing
tables. The time taken to traverse a routing table increases with its
size. Holding the routing table lock during traversal is particularly
undesirable. Therefore, it is preferable to keep the lock for the
shortest possible duration.

Solution
========

The cause of the issue is keeping the routing table locked during the
traversal of large tries. To address this, the patchset eliminates
garbage collection that does the tries traversal and introduces
individual timers for each route that eventually expires.  Walking
trials are no longer necessary with the timers. Additionally, the time
required to handle a timer is consistent.

If the expiration time is long, the timer becomes less precise. The
drawback is that the longer the expiration time, the less accurate the
timer.

Kui-Feng Lee (2):
  net: Remove expired routes with separated timers.
  net: Remove unused code and variables.

 include/net/ip6_fib.h    |  21 ++---
 include/net/ip6_route.h  |   2 -
 include/net/netns/ipv6.h |   6 --
 net/ipv6/addrconf.c      |   8 +-
 net/ipv6/ip6_fib.c       | 160 ++++++++++++++++++---------------------
 net/ipv6/ndisc.c         |   4 +-
 net/ipv6/route.c         | 119 ++---------------------------
 7 files changed, 95 insertions(+), 225 deletions(-)

-- 
2.34.1


