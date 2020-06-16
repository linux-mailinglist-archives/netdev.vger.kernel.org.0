Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6241FBFF8
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgFPUZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:25:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726428AbgFPUZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592339128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=n/DjqMIWjjy3ETi4hEtI89VCu+ofqjlxNZRzFeuPbFs=;
        b=fVZE1T5OqYPCd7NLz3w9xgd0mCTVhD8Jyk4IdiXYyKDB2L6eztAbK3u6VZIcygmvj/Kq81
        HhujQDDT5OKHQxUEoZtZBpRzz5oEjaLI8Z5JMm2i2TF1HcQNPWePs7P/6D3lBEju2Izsgy
        LBv+tFxQ54f/OCKPwusD5ZdMtIL84hA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414--_k5d8NnPYyhCqMfMV77nQ-1; Tue, 16 Jun 2020 16:25:26 -0400
X-MC-Unique: -_k5d8NnPYyhCqMfMV77nQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E8C1E919;
        Tue, 16 Jun 2020 20:25:25 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBDB410013D6;
        Tue, 16 Jun 2020 20:25:23 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v3 0/2] two fixes for 'act_gate' control plane
Date:   Tue, 16 Jun 2020 22:25:19 +0200
Message-Id: <cover.1592338450.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 attempts to fix the error path of tcf_gate_init() when users
  try to configure 'act_gate' rules with wrong parameters
- patch 2/2 is a follow-up of a recent fix for NULL dereference in
  the error path of tcf_gate_init()

further work will introduce a tdc test for 'act_gate'.

changes since v2:
  - fix undefined behavior in patch 1/2
  - improve comment in patch 2/2
changes since v1:
  coding style fixes in patch 1/2 and 2/2

Davide Caratti (2):
  net/sched: act_gate: fix NULL dereference in tcf_gate_init()
  net/sched: act_gate: fix configuration of the periodic timer

 net/sched/act_gate.c | 126 +++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 58 deletions(-)

-- 
2.26.2

