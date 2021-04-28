Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2736D838
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhD1NZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239634AbhD1NZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 09:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619616277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7lMGZ8yO2dxvEL9CMp1+/UD19dmbYYtHYVrb2uEZ/I=;
        b=OOZSKF1fgDj+OwQeAw16FQkwrRe9nox/LySx9NlPdfVrr2AxfQ/pdi/uendfDTw4Pr1lto
        ud0h6C3ylRBAvTcETd4qmzfKfqQ5XpmwCBlTD2cmkmDQK6wRAICN3jXaksdAs592qv8DWt
        DRq7e5ol1myxAy68f0GvculhNQxELbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-HmVuaiAgPQ6FkA9zVK_EHw-1; Wed, 28 Apr 2021 09:24:35 -0400
X-MC-Unique: HmVuaiAgPQ6FkA9zVK_EHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E5221007381;
        Wed, 28 Apr 2021 13:24:34 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.192.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AE3D19C59;
        Wed, 28 Apr 2021 13:24:32 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net resend 0/2] fix stack OOB read while fragmenting IPv4 packets
Date:   Wed, 28 Apr 2021 15:23:00 +0200
Message-Id: <cover.1619615320.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

