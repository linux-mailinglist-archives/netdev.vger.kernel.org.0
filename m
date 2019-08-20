Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3665395C8D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbfHTKs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:48:27 -0400
Received: from correo.us.es ([193.147.175.20]:38108 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfHTKs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:48:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90869F278A
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:48:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84B35B8019
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:48:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77BF5B8007; Tue, 20 Aug 2019 12:48:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 593A2B7FF2;
        Tue, 20 Aug 2019 12:48:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 12:48:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.43.0])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 375D64265A2F;
        Tue, 20 Aug 2019 12:48:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us, vladbu@mellanox.com
Subject: [PATCH net-next 0/2] netfilter: payload mangling offload support
Date:   Tue, 20 Aug 2019 12:48:05 +0200
Message-Id: <20190820104807.13843-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset adds payload mangling offload support for Netfilter:

1) Adapt existing drivers to allow for mangling up to four 32-bit words
   with one single flow_rule action. Hence, once single action can be
   used to mangle an IPv6 address.

2) Add support for netfilter packet mangling.

Please, apply.

Pablo Neira Ayuso (2):
  net: flow_offload: mangle 128-bit packet field with one action
  netfilter: nft_payload: packet mangling offload support

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 44 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 50 +++++++++----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 69 ++++++++++++------
 include/net/flow_offload.h                         |  9 ++-
 net/netfilter/nft_payload.c                        | 82 ++++++++++++++++++++++
 net/sched/cls_api.c                                |  7 +-
 6 files changed, 207 insertions(+), 54 deletions(-)

-- 
2.11.0


