Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C4364702
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbhDSPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233733AbhDSPXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618845783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7lMGZ8yO2dxvEL9CMp1+/UD19dmbYYtHYVrb2uEZ/I=;
        b=G/MQlgD3psyFjkUcmKyf9rbWmMUyTMeaYNg15Rp2bCMLU30rNwGmHJ66uMpW5It4OgRve+
        J3bNXP37nzNeQuY7aEV7yri+jWLmDfaYLen3BV/POviGh2S+0n+fVDR9zj5f18ixWXq2Jb
        pN0AufFO8i2P0ILUy+pT4LCmrGwDEWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-aBLCvqqZMO-C571eNnmjag-1; Mon, 19 Apr 2021 11:23:01 -0400
X-MC-Unique: aBLCvqqZMO-C571eNnmjag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 480BA8030B5;
        Mon, 19 Apr 2021 15:23:00 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AFF55C1C4;
        Mon, 19 Apr 2021 15:22:58 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] fix stack OOB read while fragmenting IPv4 packets
Date:   Mon, 19 Apr 2021 17:22:50 +0200
Message-Id: <cover.1618844973.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 fixes openvswitch IPv4 fragmentation, that does a stack OOB
read after commit d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received
PMTU < net.ipv4.route.min_pmt")
- patch 2/2 fixes the same issue in TC 'sch_frag' code

Davide Caratti (2):
  openvswitch: fix stack OOB read while fragmenting IPv4 packets
  net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets

 net/openvswitch/actions.c | 8 ++++----
 net/sched/sch_frag.c      | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.30.2

