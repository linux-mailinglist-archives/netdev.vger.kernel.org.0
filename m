Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF861FA040
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgFOT3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:29:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22220 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbgFOT3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592249380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x6QQn40MSW2Lkgfq7luEOkg74Yj2zlFB1OhbL0SDLFY=;
        b=H/qIKgrDl0TqnPSZg04NRwxoJGxUGcznKQvjbWvCNKMCiPaMy3NcGTcBgT0LF8v2H3Utjg
        Rtz8Ym/sT7rrcpZG0erewMNi4wbcPyTxK4GFiZo5X8CgoToFRVeBXCWQE20HEBdHDdqM2L
        t2k2GGvAMw4YdmHdtWYVr7VXWPEdqMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-3Jy1E_6aOZiO71QmncUuhw-1; Mon, 15 Jun 2020 15:29:37 -0400
X-MC-Unique: 3Jy1E_6aOZiO71QmncUuhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C124994B21;
        Mon, 15 Jun 2020 19:29:36 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8790B6ED96;
        Mon, 15 Jun 2020 19:29:35 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2 0/2] two fixes for 'act_gate' control plane
Date:   Mon, 15 Jun 2020 21:28:25 +0200
Message-Id: <cover.1592247564.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 attempts to fix the error path of tcf_gate_init() when users
  try to configure 'act_gate' rules with wrong parameters
- patch 2/2 is a follow-up of a recent fix for NULL dereference in
  the error path of tcf_gate_init()

further work will introduce a tdc test for 'act_gate'.


changes since v1:
  coding style fixes in patch 1/2 and 2/2

Davide Caratti (2):
  net/sched: act_gate: fix NULL dereference in tcf_gate_init()
  net/sched: act_gate: fix configuration of the periodic timer

 net/sched/act_gate.c | 124 +++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 58 deletions(-)

-- 
2.26.2

