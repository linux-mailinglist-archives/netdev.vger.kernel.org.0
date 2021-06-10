Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F843A2B0E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFJMIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFJMIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:08:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4FCC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 05:06:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrJSI-0000Wo-OZ; Thu, 10 Jun 2021 14:06:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 0/5] xfrm: ipv6: remove hdr_off indirection
Date:   Thu, 10 Jun 2021 14:06:24 +0200
Message-Id: <20210610120629.23088-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPV6 xfrm moves mutable extension headers to make space for the
encapsulation header.

For Mobile ipv6 sake this uses an indirect call (ipv6 can be built
as module).

These patches remove those indirections by placing a
small parsing function in the xfrm core.

While at it, the merged dstopt/rt hdroff function is
realigned with ip6_find_1stfragopt (where they were copied from).

ip6_find_1stfragopt received bug fixes that were missing from the
cloned ones.

Florian Westphal (5):
  xfrm: ipv6: add xfrm6_hdr_offset helper
  xfrm: ipv6: move mip6_destopt_offset into xfrm core
  xfrm: ipv6: move mip6_rthdr_offset into xfrm core
  xfrm: remove hdr_offset indirection
  xfrm: merge dstopt and routing hdroff functions

 include/net/xfrm.h      |  3 --
 net/ipv6/ah6.c          |  1 -
 net/ipv6/esp6.c         |  1 -
 net/ipv6/ipcomp6.c      |  1 -
 net/ipv6/mip6.c         | 97 -----------------------------------------
 net/ipv6/xfrm6_output.c |  7 ---
 net/xfrm/xfrm_output.c  | 78 ++++++++++++++++++++++++++++++++-
 7 files changed, 76 insertions(+), 112 deletions(-)

-- 
2.31.1

