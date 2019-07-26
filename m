Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8353D76793
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfGZNeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:34:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41567 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZNeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:34:11 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E119441720;
        Fri, 26 Jul 2019 21:34:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] flow_offload: add indr-block in nf_table_offload
Date:   Fri, 26 Jul 2019 21:34:04 +0800
Message-Id: <1564148047-6428-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VLT09LS0tKT0NMTEhKQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MS46Lhw6ODg5NksiN082CzAy
        CjoaCk9VSlVKTk1PSk9DS09MQkxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCS0M3Bg++
X-HM-Tid: 0a6c2e7d20472086kuqye119441720
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
  flow_offload: support get tcf block immediately
  netfilter: nf_tables_offload: support indr block call

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  10 +-
 include/net/flow_offload.h                         |  43 ++++
 include/net/pkt_cls.h                              |  35 ---
 include/net/sch_generic.h                          |   3 -
 net/core/flow_offload.c                            | 191 ++++++++++++++++
 net/netfilter/nf_tables_offload.c                  | 128 +++++++++--
 net/sched/cls_api.c                                | 245 ++++-----------------
 8 files changed, 389 insertions(+), 276 deletions(-)

-- 
1.8.3.1

