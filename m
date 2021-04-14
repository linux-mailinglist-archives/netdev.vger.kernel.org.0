Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE77435F8CA
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351574AbhDNQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351520AbhDNQN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:13:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84448C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:13:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lWi8U-0005rD-Cx; Wed, 14 Apr 2021 18:13:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 0/3] xfrm: minor cleanup and synchronize_rcu removal
Date:   Wed, 14 Apr 2021 18:12:50 +0200
Message-Id: <20210414161253.27586-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch gets rid of SPI key from flowi struct.
xfrm_policy populates this but there are no consumers.

This is part of a different patch (not part of this) to replace
xfrm_decode_session internals with the flow dissector.

Second patch removes a synchronize_rcu/initialisation in the init path.
Third patch avoids a synchronize_rcu during netns destruction.

Florian Westphal (3):
  flow: remove spi key from flowi struct
  xfrm: remove stray synchronize_rcu from xfrm_init
  xfrm: avoid synchronize_rcu during netns destruction

 include/net/flow.h     |  3 ---
 net/xfrm/xfrm_policy.c | 42 ------------------------------------------
 net/xfrm/xfrm_user.c   | 10 +++++++---
 3 files changed, 7 insertions(+), 48 deletions(-)

-- 
2.26.3

