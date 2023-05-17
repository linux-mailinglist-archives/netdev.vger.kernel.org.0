Return-Path: <netdev+bounces-3420-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC227070CB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A154C28144F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB95DC8F2;
	Wed, 17 May 2023 18:33:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E44420
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:33:57 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8F05FC4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:33:54 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-561bb2be5f8so12460317b3.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684348433; x=1686940433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CDJHMBERVnjQuye+QQOIvL08eJhHXrcb7IYM9pjnxeI=;
        b=AXm7Q/gY6ZZmlCVqi0NupEBKY37WXbEx4nbM2Oj9Ar8DRG7SFtf52M8bKh3OeNd8wH
         Vw97+0kYETKKFOxX9ZdGT2oVZeX2HROhs7QXOpwHUBgE4ujT0ET00JOKiVa1ErsNUW18
         7Uwnt/fs5W8t067w4fbJraT6lajj75LvZK618YBTulAU3hJ7Ij1AaINDOGOyaDKNDgr5
         2cvIcs9SroetaJimoGOnaAq+cPqwkI4+B2Rdq/pGaE2KVLb52ATcwyfnMp5kJkk8Kwds
         SYJkc0x1/j7ZoDYcGWntsvlwjS0+hYwOdesyhDnliKBK+LY2CRqt/Hkohd6zRJ+WSIrP
         iQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684348433; x=1686940433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDJHMBERVnjQuye+QQOIvL08eJhHXrcb7IYM9pjnxeI=;
        b=Qp4sjAVN6dOtRQh7cjsBpFSDhnmrID+ILBJM6PqlKVM7AwNQ7fOC9ByHvT/kXya8uy
         PEmzF++S1PW8Ox09vDa4hD6+cMLHT0kVyvq19JX+1PwL0Y9oAnwm4nx4c5IhicXUIvKm
         5DRfHtKDgkgf1f2RvmCvN0P1sBT6iJWA6r2nKiHgm7ond9cTC0JB1TgvudNIGp+ICTYf
         bnlRszadLzanetParUUJaJgWYkFA0jBHVOwvI5VsxSI1PHyNWvd3QNrAmp3YIfdNEK60
         pvCDCb+mVgzDk/S4PTvjMam0cBV7viBLsiETigyM8gxsnBhg4jpuHe2TB10ms7dJTLAL
         gYQw==
X-Gm-Message-State: AC+VfDyGHJkF70+sV4THcp6nHfXre9b2aeDT1mNLPXSaaht7U64C7Flb
	SmaCvkwy+XMYs7tVly6NSQvQbibAASnrxw==
X-Google-Smtp-Source: ACHHUZ4dZyxqDU02SoKeI4h5Yj6Deef6YOk6ZYZmv1wboj8Jvj89n2SC6QEoe/IWjd9vlX7WygEnKg==
X-Received: by 2002:a81:5b02:0:b0:559:eae4:9671 with SMTP id p2-20020a815b02000000b00559eae49671mr41203445ywb.14.1684348433591;
        Wed, 17 May 2023 11:33:53 -0700 (PDT)
Received: from kickker.attlocal.net ([2600:1700:6cf8:1240:d976:e286:fb8b:a4e3])
        by smtp.gmail.com with ESMTPSA id p6-20020a0dcd06000000b0055a72f6a462sm853521ywd.19.2023.05.17.11.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:33:52 -0700 (PDT)
From: Kui-Feng Lee <thinker.li@gmail.com>
X-Google-Original-From: Kui-Feng Lee <kuifeng@meta.com>
To: netdev@vger.kernel.org,
	ast@kernel.org,
	martin.lau@linux.dev,
	kernel-team@meta.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>
Subject: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired Routes in Linux IPv6 Routing Tables
Date: Wed, 17 May 2023 11:33:35 -0700
Message-Id: <20230517183337.190591-1-kuifeng@meta.com>
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

This RFC is resent to ensure maintainers getting awared.  Also remove
some forward declarations that we don't use anymore.

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
 net/ipv6/ip6_fib.c       | 162 ++++++++++++++++++---------------------
 net/ipv6/ndisc.c         |   4 +-
 net/ipv6/route.c         | 120 ++---------------------------
 7 files changed, 95 insertions(+), 228 deletions(-)

-- 
2.34.1


