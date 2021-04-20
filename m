Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDCD3658BE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhDTMOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhDTMOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 08:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 009ED613BF;
        Tue, 20 Apr 2021 12:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618920844;
        bh=L7f/Gd26ZNsxEmOWfRaBX+6S4MgGX4ZRI+QwZTF83kY=;
        h=From:To:Cc:Subject:Date:From;
        b=YAOW8mxenTWUNH8njZ7HYm0J2ny0f+JeEiq6RxZXCKJGjI+h+hCrw6hnHFCVkxfyo
         ksWQkGwoE9CjlOOgngDgRXzfMnPM6MQMHNExAG2zH/Wk8ZUmcaF4xysD3SR3/brk0A
         CkzVrwmi28DAUUYu31KOOaU172+NDkc/0TZlkDDn7rfGln25ccfYWiDd0PdFS5xd1f
         Yvwtsgf063Jf/FjUcD4eazthTSPEPuaCp7XPmB1QTo3rcm5xRL4vhyC7c7U2P2A8rt
         WudBYSV0fCgJK+qO7HKPokijKRnLAbNeVOinIUHuBwK7+2LfD6K1Ir298XH0X2HNgH
         Xo4xXeU67j7Jw==
From:   Mike Rapoport <rppt@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in memory accounting
Date:   Tue, 20 Apr 2021 15:13:54 +0300
Message-Id: <20210420121354.1160437-1-rppt@kernel.org>
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
v2:
* Add brief changelog
* Fix typo
* Update example about network memory usage according to Eric's comment at

https://lore.kernel.org/lkml/CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com

v1: Link: https://lore.kernel.org/lkml/20210420085105.1156640-1-rppt@kernel.org

 Documentation/filesystems/proc.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 48fbfc336ebf..8c77a491c436 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -929,8 +929,14 @@ meminfo
 ~~~~~~~
 
 Provides information about distribution and utilization of memory.  This
-varies by architecture and compile options.  The following is from a
-16GB PIII, which has highmem enabled.  You may not have all of these fields.
+varies by architecture and compile options. Please note that it may happen
+that the memory accounted here does not add up to the overall memory usage
+and the difference for some workloads can be substantial. In many cases there
+are other means to find out additional memory using subsystem specific
+interfaces, for instance /proc/net/sockstat for TCP memory allocations.
+
+The following is from a 16GB PIII, which has highmem enabled.
+You may not have all of these fields.
 
 ::
 
-- 
2.29.2

