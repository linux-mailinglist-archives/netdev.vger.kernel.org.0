Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229B3288F6D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390033AbgJIRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390000AbgJIRBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602262901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G5OXsjeY3xYWxMbZi9rQ8DoHBXeUWpbjG4fS2AvqBOE=;
        b=F39TY6D4mkuR0IwGo6KQhWDknzqH46bTySZpg/l6tsjN1EVTWv2xc4le+ptKSK7Mgk9jg/
        LAc/avuxSIGYQguQCyC66l4Ow3oe16f/9EQzqXKay7KAVszB6yURjdeA0Z+aWiT61TaQDr
        DxJoqTUTuPoPAi+KKQf/o4yAYVj7MLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-SOhXqkl1NdWEdwDHg4rVBQ-1; Fri, 09 Oct 2020 13:01:36 -0400
X-MC-Unique: SOhXqkl1NdWEdwDHg4rVBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C06941029D58;
        Fri,  9 Oct 2020 17:01:15 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-111.ams2.redhat.com [10.36.114.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3781476650;
        Fri,  9 Oct 2020 17:01:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 0/2] mptcp: some fallback fixes
Date:   Fri,  9 Oct 2020 18:59:59 +0200
Message-Id: <cover.1602262630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pktdrill pointed-out we currently don't handle properly some
fallback scenario for MP_JOIN subflows

The first patch addresses such issue.

Patch 2/2 fixes a related pre-existing issue that is more
evident after 1/2: we could keep using for MPTCP signaling
closed subflows.

Paolo Abeni (2):
  mptcp: fix fallback for MP_JOIN subflows
  mptcp: subflows garbage collection

 net/mptcp/options.c  | 32 +++++++++++++++++++++++++-------
 net/mptcp/protocol.c | 17 +++++++++++++++++
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 16 ++++++++++++++--
 4 files changed, 58 insertions(+), 9 deletions(-)

-- 
2.26.2

