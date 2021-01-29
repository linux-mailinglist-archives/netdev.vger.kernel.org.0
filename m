Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2E308C6C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhA2SZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbhA2SXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:23:39 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1A9C0613D6
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:23:15 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e9so5699830plh.3
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=++BOmUqhZF+EhwdLS4FoO6UUfmwvgumWwQrA+ZGOUe8=;
        b=dg4nqHzR0VqxGIFyfz054pibRjE+QWkPWHjcZzbQyw2H+AHi9RaMgWkrCnNutC0cTj
         NyHalZDU992U+/DqOQRS84RH93sBgiyhz3OzPqFhsil1QpXXEJV0WOx7rYZ02mmwYyfV
         jd97KFE+Bxc5Ib4gbSJ1piJx7Vnly1FKJd+rgLkpw7pFbMxiT0IwugELHZfDJzoaywHy
         P1icsWfVZC9hSbdQqbjBiY4lmrCD52ATrH0tHQ35QXPt5Jmv2U14edxugwFktOAG7EzP
         q2sLWugABZ5jclQ5Cc01SUEHgmn65zUJWzkNMneQmBL9IbLYhjpJnBF4YKuqY9VjqdSG
         TNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=++BOmUqhZF+EhwdLS4FoO6UUfmwvgumWwQrA+ZGOUe8=;
        b=YcMf58VrgX0alk9fu13Ne3OR1erj2S1gv2zEdBW0KjajDJBUOz4y5bZwFrn6XEPsGk
         RNTxJztnpO0MOyU+3jqNw4DRcRmy3JNxhnq3WnGMnKGWCvrKLiil9oVl0aEoq+vPIAiR
         XHR9B0seFJ7l/xIsl+l6kFYCEer4JRz+wXAKwKP5w60k6184+d6qaER7cm/mhgBMxV4t
         PtrvRSBnMXB9WgZ8Puvh2eYwtj+OBAZopKlRr5PCrK0+b7mol7XTmIvfCsZWAHyZg7Nj
         QZBa+mPq8qaWhdvX+os5B9tpK/k757ejvbnFTIt7AR/80raSWJ/1nEG9Pp1roFN7IfA0
         tJ5Q==
X-Gm-Message-State: AOAM531IXucSZR60nDKPoV/+6Kc8QzuHi9ai/pk0MmlcqDK+FBAjf+1K
        P01g50Drpw7Q16ySfvzPza4JvlT9o1maBQ==
X-Google-Smtp-Source: ABdhPJxqxw6t65vRPZ+zgqcv+xd4RI3xdkv14JbIZ/DgcFaObWbDVxbWw3nDOOVuP1Dyvzpwy+g9Mg==
X-Received: by 2002:a17:902:7596:b029:da:b7a3:cdd0 with SMTP id j22-20020a1709027596b02900dab7a3cdd0mr5433668pll.14.1611944594843;
        Fri, 29 Jan 2021 10:23:14 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id br21sm8789513pjb.9.2021.01.29.10.23.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 10:23:14 -0800 (PST)
Date:   Fri, 29 Jan 2021 10:23:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 211375] New: Memory leak about TCP slab which have too big
 used sockets
Message-ID: <20210129102304.7e013cf6@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a quite old kernel version, probably already fixed...

Begin forwarded message:

Date: Wed, 27 Jan 2021 01:48:33 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 211375] New: Memory leak about TCP slab which have too big used sockets


https://bugzilla.kernel.org/show_bug.cgi?id=211375

            Bug ID: 211375
           Summary: Memory leak about TCP slab which have too big used
                    sockets
           Product: Networking
           Version: 2.5
    Kernel Version: 4.18.16
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: 390231410@qq.com
        Regression: No

Memory leak occurred in linux of 4.18.16, we use nginx as a server, I found
some problems related to TCP as following:
1. slabtop a:
OBJS ACTIVE USE OBJ SIZE SLABS OBJ/SLAB CACHE SIZE NAME
14081971 13980986 99% 2.06K 938799 15 30041568K TCP

2. cat /proc/meminfo
SUnreclaim: 31405028 kB

3. cat /proc/net/sockstat
sockets: used 13976123
TCP: inuse 18 orphan 0 tw 44 alloc 18 mem 1
UDP: inuse 54 mem 45
UDPLITE: inuse 0 RAW: inuse 9
FRAG: inuse 0 memory 0

4. lsof
there are 19000 line, it seems like ok.

As above, it seems that tcp sk memory leak, "sockets: used 13976123" illustrate
that "net->core.sock_inuse" is too big, which increase in inet_create(socket
create) or sk_clone_lock(child socket create) and decrease in __sk_free, I kill
almost all of application layer program, but the "sockets: used" almostly not
reduce.

Do you have any suggestions for this problem, Thanks.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
