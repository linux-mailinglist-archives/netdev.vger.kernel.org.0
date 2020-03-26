Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE0194B4C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgCZWK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgCZWK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 18:10:29 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF0C20714;
        Thu, 26 Mar 2020 22:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585260628;
        bh=jdoORF7MHGg1UQMX0mZSEMcvmkGGA49Fg0v2JIj+TTo=;
        h=From:To:Cc:Subject:Date:From;
        b=Dn1RHiuyyXWav1B+ofdIVYz+eROBqSGg9v5L9VcoQF/zV3fcrjsjh6ZNMmSzPZctk
         cdR/rYfVHuDP8z2o+CM/xEf8ypWEH57OqPNEOW1H5tlWLt+cZO5s95sYFa2GupqFwF
         RmAO/F70Y3BoBYeva0MmqfkDrkdLIWJc8fjoTsiE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH v2 net-next 0/2] move ndo_xdp_xmit stats to peer veth_rq
Date:   Thu, 26 Mar 2020 23:10:18 +0100
Message-Id: <cover.1585260407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ndo_xdp_xmit ethtool stats accounting to peer veth_rq.
Move XDP_TX accounting to veth_xdp_flush_bq routine.

Changes since v1:
- rename xdp_xmit[_err] counters to peer_tq_xdp_xmit[_err]

Lorenzo Bianconi (2):
  veth: rely on veth_rq in veth_xdp_flush_bq signature
  veth: rely on peer veth_rq for ndo_xdp_xmit accounting

 drivers/net/veth.c | 159 +++++++++++++++++++++++++++------------------
 1 file changed, 97 insertions(+), 62 deletions(-)

-- 
2.25.1

