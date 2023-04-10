Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50A86DC53A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDJJm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDJJmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C7B1FDD;
        Mon, 10 Apr 2023 02:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C5861173;
        Mon, 10 Apr 2023 09:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B68C433EF;
        Mon, 10 Apr 2023 09:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681119772;
        bh=8mrBnTnoB7t/AMZsj2+xBakPM4atwfooXq/n+Cg7RAQ=;
        h=From:Subject:Date:To:Cc:From;
        b=CoX2RYe8cQ2we16K9+P55yWV+r9uxBDPNf0hWTcGUACIfXRRqeDcN1VkZU+6mm+mv
         AoRfKYjoc2F4JbJ23/gZQ/9JjKsClQi3txlYZ6+/f0BrNv0wy5ckQjOe7Aqjcg/pul
         +jHotl140CMH4UQy+wOxj8t14N5Xp1S+zWGcM1mQvxCjqY40tzXn5od0JzuAgHb45A
         /VmOT16YeUmHikK6S1hgYbKnA9SsZDh72reIyMcIg8vloChzQqQE61jjc41sKYfLp2
         ntF0OeY+Fd7XCSlOYd6GeKg4wUydE/SxJHXSEmXcfYwfi4J/pYB4c+iTw79bHeHbTW
         rAvL5dTr6HAmQ==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next 0/4] ipvs: Cleanups for v6.4
Date:   Mon, 10 Apr 2023 11:42:34 +0200
Message-Id: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAraM2QC/x2NSQrDMAwAvxJ0rsBVupB+pfQgu0ojMKqxkhAI+
 XtNjzMwzA4uVcXh0e1QZVXXrzU4nzpIE9tHUN+NgQL14RIG1LI6pixsS8GYBr4S072nG7Qksgv
 GypamFtmSc5Olyqjb//EEG9Fkm+F1HD8K/rUrfAAAAA==
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
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

this series aims to clean up IPVS in several ways without
implementing any functional changes, aside from removing
some debugging output.

Patch 1/4: Update width of source for ip_vs_sync_con_options
           The operation is safe, use an annotation to describe it properly.

Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
           It seems better to use helpers consistently.

Patch 3/4: Remove {Enter,Leave}Function
           These seem to be well past their use-by date.

Patch 4/4: Correct spelling in comments
	   I can't spell. But codespell helps me these days.

All changes: compile tested only!

---
Simon Horman (4):
      ipvs: Update width of source for ip_vs_sync_con_options
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

base-commit: 9b7c68b3911aef84afa4cbfc31bce20f10570d51

