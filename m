Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C215BA967
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiIPJ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIPJ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AAF36858;
        Fri, 16 Sep 2022 02:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A33B824A7;
        Fri, 16 Sep 2022 09:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E3EC433C1;
        Fri, 16 Sep 2022 09:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320584;
        bh=0U5YViGBB6Yo2AvYpAm1lBjcmVlrXEpFBkVeUeXArhc=;
        h=From:To:Cc:Subject:Date:From;
        b=e5sqA1//mgCsqLijXJnoUjRGiSttC5RMXVMIwNw6NqxIKRXJA1egjkQBS1VM+tqp3
         WTyIqDGmjkrWd+rdpKzcjiME4cm7bLBNPyg0k7kz3kGLDTkFlZ59yh7sJzAl4XKS6l
         llXNbr34jPz8Jnd3hk8hZE9hnk00pLR8ipgy5gfUal8R69EdElNx5o0WOKVoQz6UE7
         OrcfTrATUk0fJfqJpyLB4B9wXSJeiA+VDLZ7tJd9K6xHnEWIfghivH/f8AX7FGKZtm
         TKeffz9rk3Kp6cKhkbN9xzIIL+S9jGP8G4fPPMsbml/ZaqbLpv8Vl5nE0Nd3Qik5ZE
         Oovs5rOAdQJFQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     Antoine Tenart <atenart@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf 0/2] netfilter: conntrack: fix the gc rescheduling delay
Date:   Fri, 16 Sep 2022 11:29:39 +0200
Message-Id: <20220916092941.39121-1-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The first patch fixes how the conntrack gc rescheduling delay is
computed to avoid bias depending on the order of entries in the set. But
this change has a side effect, making the logic not to be triggered
until very large sets are used. This is fixed in patch 2, which changes
the initial conntrack gc rescheduling bias.

Thanks,
Antoine

Antoine Tenart (2):
  netfilter: conntrack: fix the gc rescheduling delay
  netfilter: conntrack: revisit the gc initial rescheduling bias

 net/netfilter/nf_conntrack_core.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
2.37.3

