Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A952305E66
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhA0OeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:34:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46339 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234277AbhA0Odm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:33:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@nvidia.com)
        with SMTP; 27 Jan 2021 16:32:49 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10REWnmp010762;
        Wed, 27 Jan 2021 16:32:49 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 0/3] net/sched: cls_flower: Add support for matching on ct_state reply flag
Date:   Wed, 27 Jan 2021 16:32:44 +0200
Message-Id: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds software match support and offload of flower
match ct_state reply flag (+/-rpl).

The first patch adds the definition for the flag and match to flower.

Second patch gives the direction of the connection to the offloading drivers via
ct_metadata flow offload action.

The last patch does offload of this new ct_state by using the supplied
connection's direction.

Paul Blakey (3):
  net/sched: cls_flower: Add match on the ct_state reply flag
  net: flow_offload: Add original direction flag to ct_metadata
  net/mlx5: CT: Add support for matching on ct_state reply flag

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 13 ++++++++++---
 include/net/flow_offload.h                         |  1 +
 include/uapi/linux/pkt_cls.h                       |  1 +
 net/sched/act_ct.c                                 |  1 +
 net/sched/cls_flower.c                             |  6 ++++--
 5 files changed, 17 insertions(+), 5 deletions(-)

-- 
1.8.3.1

