Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C439E366537
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbhDUGMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhDUGMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 02:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F65661420;
        Wed, 21 Apr 2021 06:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618985497;
        bh=YhPOHuGJ/c29KhIGdQUtJ/biKTM/tPQx+TdNyvwGiJ8=;
        h=From:To:Cc:Subject:Date:From;
        b=VtD+/yB1oLQwLgsb+e9qbA5z47LcOQckXo0SDV/pEz0+sEJEArmwhncjlEnc2AgdM
         lnLMn9wFn9RgtD5sLjVJGyPriC3VIccLZIgpxxPHLAGTQPSj9dEDEqncfR91faE6tE
         R8iMlVFIp3++aD+rEmQ/GRuGULNUWRaC6ke8cORTWi2z/Q2MT4PrnOGNTLIl43rA2L
         YzkyplhIpZ4ecEmPUrRU11rM09KJxnnx0FKKqDlR0fXviPVPIyUvUgORZpsgTUUrHL
         qHkSNzkWvo8zl7L4VrPdPLmKVjZra5M4GgGBLboGl1eEeNcy0Y8onTLIaGmTNrQlgR
         cE1EwTSCIcEzg==
From:   Mike Rapoport <rppt@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: [PATCH v3] docs: proc.rst: meminfo: briefly describe gaps in memory accounting
Date:   Wed, 21 Apr 2021 09:11:27 +0300
Message-Id: <20210421061127.1182723-1-rppt@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Add a paragraph that explains that it may happen that the counters in
/proc/meminfo do not add up to the overall memory usage.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
v3:
* Add sentense about counters overlap
* Use wording suggested by Matthew

v2: Link: https://lore.kernel.org/lkml/20210420121354.1160437-1-rppt@kernel.org
* Add brief changelog
* Fix typo
* Update example about network memory usage according to Eric's comment at

https://lore.kernel.org/lkml/CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com

v1: Link: https://lore.kernel.org/lkml/20210420085105.1156640-1-rppt@kernel.org
 Documentation/filesystems/proc.rst | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 48fbfc336ebf..0a07a5025571 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -929,8 +929,15 @@ meminfo
 ~~~~~~~
 
 Provides information about distribution and utilization of memory.  This
-varies by architecture and compile options.  The following is from a
-16GB PIII, which has highmem enabled.  You may not have all of these fields.
+varies by architecture and compile options.  Some of the counters reported
+here overlap.  The memory reported by the non overlapping counters may not
+add up to the overall memory usage and the difference for some workloads
+can be substantial.  In many cases there are other means to find out
+additional memory using subsystem specific interfaces, for instance
+/proc/net/sockstat for TCP memory allocations.
+
+The following is from a 16GB PIII, which has highmem enabled.
+You may not have all of these fields.
 
 ::
 
-- 
2.29.2

