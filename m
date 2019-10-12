Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4CD4F78
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfJLL51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbfJLLz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 07:55:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F319718C8910;
        Sat, 12 Oct 2019 11:55:26 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-41.brq.redhat.com [10.40.204.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30DC16017E;
        Sat, 12 Oct 2019 11:55:23 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     lkp@intel.com
Cc:     davem@davemloft.net, dcaratti@redhat.com,
        john.hurley@netronome.com, kbuild-all@01.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net v2 0/2] net/sched: fix wrong behavior of MPLS push/pop action
Date:   Sat, 12 Oct 2019 13:55:05 +0200
Message-Id: <cover.1570878412.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Sat, 12 Oct 2019 11:55:27 +0000 (UTC)
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

v2: - change commit message in patch 1/2 to better describe that the
      patch impacts only TC, thanks to Simon Horman
    - fix missing documentation of 'mac_len' in patch 2/2


Davide Caratti (2):
  net: avoid errors when trying to pop MLPS header on non-MPLS packets
  net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions

 include/linux/skbuff.h    |  5 +++--
 net/core/skbuff.c         | 21 ++++++++++++---------
 net/openvswitch/actions.c |  5 +++--
 net/sched/act_mpls.c      | 12 ++++++++----
 4 files changed, 26 insertions(+), 17 deletions(-)

-- 
2.21.0

