Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871E93101CC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhBEAr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:47:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:37936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhBEArZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:47:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 376E8B06A;
        Fri,  5 Feb 2021 00:46:43 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>
Date:   Fri, 05 Feb 2021 11:36:30 +1100
Subject: [PATCH 0/3] Fix some seq_file users that were recently broken
Cc:     Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <161248518659.21478.2484341937387294998.stgit@noble1>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change to seq_file broke some users which were using seq_file
in a non-"standard" way ...  though the "standard" isn't documented, so
they can be excused.  The result is a possible leak - of memory in one
case, of references to a 'transport' in the other.

These three patches:
 1/ document and explain the problem
 2/ fix the problem user in x86
 3/ fix the problem user in net/sctp

I suspect the patches should each go through the relevant subsystems,
but I'm including akpm as the original went through him.

Thanks,
NeilBrown

---

NeilBrown (3):
      seq_file: document how per-entry resources are managed.
      x86: fix seq_file iteration for pat/memtype.c
      net: fix iteration for sctp transport seq_files

 Documentation/filesystems/seq_file.rst |  6 ++++++
 arch/x86/mm/pat/memtype.c              |  4 ++--
 net/sctp/proc.c                        | 16 ++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

--
Signature

