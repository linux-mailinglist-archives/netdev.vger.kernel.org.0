Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7109E1F5DC7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgFJVng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 17:43:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgFJVng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 17:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591825415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EOMRCKTn4Cd3m8NbO22/XggcyOaKS9TbIVqVmA96gZE=;
        b=XRcQ9dbSfnP9YaGDPPoMVgCFKDmtiwfSZV8RC6pnxX+bjFbyEQ13rk2QEdgPMm4VJTSl9z
        hSKBKSD6WxUCQAYX/9AJqpXxWIZT7L9+/zz/LvlBtPmvYl3ZzBQVP8K2J+DVGXmTPZGjir
        USiVer/LkxToW2cJytKbdZLmKXY8wDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-KDUT5N1ON3KIhFWozUgDOA-1; Wed, 10 Jun 2020 17:43:33 -0400
X-MC-Unique: KDUT5N1ON3KIhFWozUgDOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 137CC8014D4;
        Wed, 10 Jun 2020 21:43:32 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7C5710013D0;
        Wed, 10 Jun 2020 21:43:30 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 0/2]  two fixes for 'act_gate' control plane
Date:   Wed, 10 Jun 2020 23:42:45 +0200
Message-Id: <cover.1591824863.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 attempts to fix the error path of tcf_gate_init() when users
  try to configure 'act_gate' rules with wrong parameters.
- patch 2/2 is a follow-up of a recent fix for NULL dereference in
  the error path of tcf_gate_init()

further work will introduce a tdc test for 'act_gate'.

Davide Caratti (2):
  net/sched: act_gate: fix NULL dereference in tcf_gate_init()
  net/sched: act_gate: fix configuration of the periodic timer

 net/sched/act_gate.c | 130 ++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 58 deletions(-)

-- 
2.26.2

