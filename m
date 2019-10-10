Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22537D309C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfJJSoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfJJSoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 14:44:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 272DE2DD98;
        Thu, 10 Oct 2019 18:44:04 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-138.brq.redhat.com [10.40.204.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7F885D713;
        Thu, 10 Oct 2019 18:44:02 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] net/sched: fix wrong behavior of MPLS push/pop action
Date:   Thu, 10 Oct 2019 20:43:51 +0200
Message-Id: <cover.1570732834.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 10 Oct 2019 18:44:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this series contains two fixes for TC 'act_mpls', that try to address
two problems that can be observed configuring simple 'push' / 'pop'
operations:
- patch 1/2 avoids dropping non-MPLS packets that pass through the MPLS
  'pop' action.
- patch 2/2 fixes corruption of the L2 header that occurs when 'push'
  or 'pop' actions are configured in TC egress path.

Davide Caratti (2):
  net: avoid errors when trying to pop MLPS header on non-MPLS packets
  net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions

 include/linux/skbuff.h    |  5 +++--
 net/core/skbuff.c         | 20 +++++++++++---------
 net/openvswitch/actions.c |  5 +++--
 net/sched/act_mpls.c      | 12 ++++++++----
 4 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.21.0

