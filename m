Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A4211B13
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfEBOPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:15:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51418 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbfEBOPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 10:15:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6FF9AE47;
        Thu,  2 May 2019 14:15:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CA511E0117; Thu,  2 May 2019 16:15:10 +0200 (CEST)
Message-Id: <cover.1556806084.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 0/3] netlink: strict attribute checking follow-up
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date:   Thu,  2 May 2019 16:15:10 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three follow-up patches for recent strict netlink validation series.

Patch 1 fixes dump handling for genetlink families which validate and parse
messages themselves (e.g. because they need different policies for diferent
commands).

Patch 2 sets bad_attr in extack in one place where this was omitted.

Patch 3 adds new NL_VALIDATE_NESTED flags for strict validation to enable
checking that NLA_F_NESTED value in received messages matches expectations
and includes this flag in NL_VALIDATE_STRICT. This would change userspace
visible behavior but the previous switching to NL_VALIDATE_STRICT for new
code is still only in net-next at the moment.

v2: change error messages to mention NLA_F_NESTED explicitly

Michal Kubecek (3):
  genetlink: do not validate dump requests if there is no policy
  netlink: set bad attribute also on maxtype check
  netlink: add validation of NLA_F_NESTED flag

 include/net/netlink.h   | 11 ++++++++++-
 lib/nlattr.c            | 18 +++++++++++++++++-
 net/netlink/genetlink.c | 24 ++++++++++++++----------
 3 files changed, 41 insertions(+), 12 deletions(-)

-- 
2.21.0

