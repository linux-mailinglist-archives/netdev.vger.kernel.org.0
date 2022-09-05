Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434F85ACF82
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiIEKKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbiIEKJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:09:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63314BB6;
        Mon,  5 Sep 2022 03:09:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oV935-0003ho-Tq; Mon, 05 Sep 2022 12:09:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/2] netlink: add range checks for network byte integers
Date:   Mon,  5 Sep 2022 12:09:35 +0200
Message-Id: <20220905100937.11459-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NLA_POLICY_MAX() can be used to let netlink core validate that the given
integer attribute is within the given min-max interval.

Add NLA_POLICY_MAX_BE to allow similar range check on unsigned integers
when those are in network byte order (big endian).

First patch adds the netlink change, second patch adds one user.

Florian Westphal (2):
  netlink: introduce NLA_POLICY_MAX_BE
  netfilter: nft_payload: reject out-of-range attributes via policy

 include/net/netlink.h       |  9 +++++++++
 lib/nlattr.c                | 31 +++++++++++++++++++++++++++----
 net/netfilter/nft_payload.c |  6 +++---
 3 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.35.1

