Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8280B23
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfHDNYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 09:24:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8241 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfHDNYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 09:24:11 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 047A741107;
        Sun,  4 Aug 2019 21:24:02 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jakub.kicinski@netronome.com, jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v6 0/6] flow_offload: add indr-block in nf_table_offload
Date:   Sun,  4 Aug 2019 21:23:55 +0800
Message-Id: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSEtCQkJCQk9JTExCTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjY6OBw4Sjg0Ok4RPhoLKxoP
        Pz4wCk1VSlVKTk1PQklOS09JS0xIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSUw3Bg++
X-HM-Tid: 0a6c5ccd1d772086kuqy047a741107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series patch make nftables offload support the vlan and
tunnel device offload through indr-block architecture.

The first four patches mv tc indr block to flow offload and
rename to flow-indr-block.
Because the new flow-indr-block can't get the tcf_block
directly. The fifth patch provide a callback list to get 
flow_block of each subsystem immediately when the device
register and contain a block.
The last patch make nf_tables_offload support flow-indr-block.

wenxu (6):
  cls_api: modify the tc_indr_block_ing_cmd parameters.
  cls_api: remove the tcf_block cache
  cls_api: add flow_indr_block_call function
  flow_offload: move tc indirect block to flow offload
  flow_offload: support get multi-subsystem block
  netfilter: nf_tables_offload: support indr block call

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  11 +-
 include/net/flow_offload.h                         |  37 +++
 include/net/netfilter/nf_tables_offload.h          |   4 +
 include/net/pkt_cls.h                              |  35 ---
 include/net/sch_generic.h                          |   3 -
 net/core/flow_offload.c                            | 236 +++++++++++++++++++
 net/netfilter/nf_tables_api.c                      |   7 +
 net/netfilter/nf_tables_offload.c                  | 148 ++++++++++--
 net/sched/cls_api.c                                | 254 ++++-----------------
 10 files changed, 460 insertions(+), 285 deletions(-)

-- 
1.8.3.1

