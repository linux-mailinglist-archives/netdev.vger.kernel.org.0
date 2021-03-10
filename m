Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252AD333283
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCJAiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:38:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:43776 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCJAi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:38:29 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJmrs-0008uO-CS; Wed, 10 Mar 2021 01:38:28 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        willemb@google.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net 0/2] Fix ip6ip6 crash for collect_md skbs
Date:   Wed, 10 Mar 2021 01:38:08 +0100
Message-Id: <cover.1615331093.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26103/Tue Mar  9 13:03:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a NULL pointer deref panic I ran into for regular ip6ip6 tunnel devices
when collect_md populated skbs were redirected to them for xmit. See patches
for further details, thanks!

Daniel Borkmann (2):
  net: Consolidate common blackhole dst ops
  net, bpf: Fix ip6ip6 crash with collect_md populated skbs

 include/net/dst.h | 11 +++++++++
 net/core/dst.c    | 59 +++++++++++++++++++++++++++++++++--------------
 net/ipv4/route.c  | 45 +++++++-----------------------------
 net/ipv6/route.c  | 36 ++++++++---------------------
 4 files changed, 70 insertions(+), 81 deletions(-)

-- 
2.21.0

