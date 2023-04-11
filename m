Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B06DD3B0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjDKHKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKHKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:10:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5BA1711;
        Tue, 11 Apr 2023 00:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1C362235;
        Tue, 11 Apr 2023 07:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA817C433D2;
        Tue, 11 Apr 2023 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681197047;
        bh=dWECYEnu3oSCzd3j0bJdz30hiF397lT4p1HM1cffhk4=;
        h=From:Subject:Date:To:Cc:From;
        b=mrLKW7G77IM1tlEKMJKXk5w4goTgr0LSR7dIQ1yCqF9Tqv9/E4InSF5W21Rla74DR
         7IppkMo6KqOOa+PDjx+sA6BxyODf2QZmzOlIrPaO+LK5Pkg9xdljjeGMe+yKf9Wpw5
         xHp0ivhjK7fMueiTcxAa15w+/Rhaksp6IRLE/r1XpyP/TrgY0qoIMa6/6bi5cFaYR1
         G9AN8EOpnRPM47JBqw32QmIH14SQhJOoq8bkba5VnjuTuJoYdv0gzLBxFZEIAz2odo
         COSE6I1hJeeqr2NcakWE4nr7/wJWjDcP56ijMzSr/3qgMpKHnRKmLLSvMXzTHgwkzI
         PMxTKawpm9W6w==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next v2 0/4] ipvs: Cleanups for v6.4
Date:   Tue, 11 Apr 2023 09:10:38 +0200
Message-Id: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO4HNWQC/22NywqDMBBFf6XMulPiaB921f8oLpI4amgYJdFgE
 f+9wXWX514OZ4PIwXGE52mDwMlFN0oGOp/ADlp6RtdmBlJUqkrV6KYU0XrWskxobK2vpOle0g2
 yYnRkNEGLHbIki/d5nAJ3bj0ab5AOhdcZmnwMLs5j+B7tVBz3/0wqUGH9sK2lijo26vXhIOwvY
 +ih2ff9BzXbgKrHAAAA
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

this series aims to clean up IPVS in several ways without
implementing any functional changes, aside from removing
some debugging output.

Patch 1/4: Update width of source for ip_vs_sync_conn_options
           The operation is safe, use an annotation to describe it properly.

Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
           It seems better to use helpers consistently.

Patch 3/4: Remove {Enter,Leave}Function
           These seem to be well past their use-by date.

Patch 4/4: Correct spelling in comments
	   I can't spell. But codespell helps me these days.

All changes: compile tested only!

---
Changes in v2:
- Patch 1/4: Correct spelling of 'conn' in subject

---
Simon Horman (4):
      ipvs: Update width of source for ip_vs_sync_conn_options
      ipvs: Consistently use array_size() in ip_vs_conn_init()
      ipvs: Remove {Enter,Leave}Function
      ipvs: Correct spelling in comments

 include/net/ip_vs.h             | 32 +++++----------------
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++----
 net/netfilter/ipvs/ip_vs_core.c |  8 ------
 net/netfilter/ipvs/ip_vs_ctl.c  | 26 +----------------
 net/netfilter/ipvs/ip_vs_sync.c |  7 +----
 net/netfilter/ipvs/ip_vs_xmit.c | 62 ++++++-----------------------------------
 6 files changed, 23 insertions(+), 124 deletions(-)

base-commit: 9bc11460bea751b5c805ac793de35a55629adb9b

