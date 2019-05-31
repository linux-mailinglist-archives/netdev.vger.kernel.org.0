Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4906530E68
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfEaMyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaMyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:54:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBD8B8666C;
        Fri, 31 May 2019 12:54:15 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE9675DE88;
        Fri, 31 May 2019 12:54:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 0/3] net/mlx5: use indirect call wrappers
Date:   Fri, 31 May 2019 14:53:32 +0200
Message-Id: <cover.1559304330.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 31 May 2019 12:54:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5_core driver uses several indirect calls in fast-path, some of them
are invoked on each ingress packet, even for the XDP-only traffic.

This series leverage the indirect call wrappers infrastructure the avoid
the expansive RETPOLINE overhead for 2 indirect calls in fast-path.

Each call is addressed on a different patch, plus we need to introduce a couple
of additional helpers to cope with the higher number of possible direct-call
alternatives.

Paolo Abeni (3):
  net/mlx5e: use indirect calls wrapper for skb allocation
  indirect call wrappers: add helpers for 3 and 4 ways switch
  net/mlx5e: use indirect calls wrapper for the rx packet handler

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 26 ++++++++++++++-----
 include/linux/indirect_call_wrapper.h         | 12 +++++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

-- 
2.20.1

