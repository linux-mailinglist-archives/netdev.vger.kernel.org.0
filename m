Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05205280D3B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJBFuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgJBFt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:49:59 -0400
Received: from mail.kernel.org (ip5f5ad59f.dynamic.kabel-deutschland.de [95.90.213.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FA720719;
        Fri,  2 Oct 2020 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601617798;
        bh=d9jAg3Nj6JZLFhzRqkSiYIiTdyrjfTNgd8OfBC8Nm6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0Ro11/CcD0alduc+ONpMk906bG5pFT+6qM5O7ZlF1B9LD0HDhtNtQy+qLsFy+H9w
         AO+sLiQEJZismTALlCG/Djke1Rrbe1OGjF3p2W5lGvow4V6nIwgJVHEgrE9JyIR6J3
         WKJ4q2F2gEm7/9KuhqBKzlUPmZ/XDWVz18FvW9is=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kODx6-006hil-8a; Fri, 02 Oct 2020 07:49:56 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/6] net: core: document two new elements of struct net_device
Date:   Fri,  2 Oct 2020 07:49:45 +0200
Message-Id: <1c6293ffd174d0301c0acb85f0e60e9edf5e4a27.1601616399.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601616399.git.mchehab+huawei@kernel.org>
References: <cover.1601616399.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As warned by "make htmldocs", there are two new struct elements
that aren't documented:

	../include/linux/netdevice.h:2159: warning: Function parameter or member 'unlink_list' not described in 'net_device'
	../include/linux/netdevice.h:2159: warning: Function parameter or member 'nested_level' not described in 'net_device'

Fixes: 1fc70edb7d7b ("net: core: add nested_level variable in net_device")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/netdevice.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78880047907e..7852921480da 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1843,6 +1843,11 @@ enum netdev_priv_flags {
  *	@udp_tunnel_nic:	UDP tunnel offload state
  *	@xdp_state:		stores info on attached XDP BPF programs
  *
+ *	@nested_level:	Used as as a parameter of spin_lock_nested() of
+ *			dev->addr_list_lock.
+ *	@unlink_list:	As netif_addr_lock() can be called recursively,
+ *			keep a list of interfaces to be deleted.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
-- 
2.26.2

