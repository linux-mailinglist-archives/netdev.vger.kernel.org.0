Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781F177E54
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 08:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfG1Gwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 02:52:54 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:1495 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfG1Gwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 02:52:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CF0DD4116F;
        Sun, 28 Jul 2019 14:52:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 0/3] flow_offload: add indr-block in nf_table_offload
Date:   Sun, 28 Jul 2019 14:52:46 +0800
Message-Id: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPTUpCQkJDQkhKQ0NPQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MSI6NDo5PDg4DEoTFBVRKxkW
        QyhPCgxVSlVKTk1PSUJNTE1CQ0JIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCQ083Bg++
X-HM-Tid: 0a6c375a714c2086kuqycf0dd4116f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series patch make nftables offload support the vlan and
tunnel device offload through indr-block architecture.

The first patch mv tc indr block to flow offload and rename
to flow-indr-block.
Because the new flow-indr-block can't get the tcf_block
directly. The second patch provide a callback to get tcf_block
immediately when the device register and contain a ingress block.
The third patch make nf_tables_offload support flow-indr-block.

wenxu (3):
  flow_offload: move tc indirect block to flow offload
  flow_offload: Support get default block from tc immediately
  netfilter: nf_tables_offload: support indr block call

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  10 +-
 include/net/flow_offload.h                         |  39 ++++
 include/net/pkt_cls.h                              |  42 +---
 include/net/sch_generic.h                          |   3 -
 net/core/flow_offload.c                            | 181 +++++++++++++++
 net/netfilter/nf_tables_offload.c                  | 131 +++++++++--
 net/sched/cls_api.c                                | 246 ++++-----------------
 8 files changed, 385 insertions(+), 277 deletions(-)

-- 
1.8.3.1

