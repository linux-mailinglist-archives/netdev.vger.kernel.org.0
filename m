Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9741FCA84
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFQKKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 06:10:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFQKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592388609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fF8WOiks96Tvs1Yx3/hXfL5XENkNy0/tdV29WDAO1rM=;
        b=U09YGgec6PI6H2GDLuWaa4k6IPqU60biBbfPJaeR8a4+akpLX5ML2HZki10TcZoufCKm8p
        kIyy0isZZ1hZYATONwL0FXSVJHxirVo9dg7LqlezXMO/xapAjL0Bcsf/LIJSghz1CoPBls
        eN9rQukG8ubJG1cn54OdJvmsFcg8vKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-6LnQYX34PtWVqY75JXKipQ-1; Wed, 17 Jun 2020 06:10:05 -0400
X-MC-Unique: 6LnQYX34PtWVqY75JXKipQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 449DC10AEA0E;
        Wed, 17 Jun 2020 10:10:02 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-237.ams2.redhat.com [10.36.112.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66C57512FE;
        Wed, 17 Jun 2020 10:10:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 0/2] mptcp: cope with syncookie on MP_JOINs
Date:   Wed, 17 Jun 2020 12:08:55 +0200
Message-Id: <cover.1592388398.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently syncookies on MP_JOIN connections are not handled correctly: the
connections fallback to TCP and are kept alive instead of resetting them at
fallback time.

The first patch propagates the required information up to syn_recv_sock time,
and the 2nd patch addresses the unifying the error path for all MP_JOIN
requests.

Paolo Abeni (2):
  mptcp: cache msk on MP_JOIN init_req
  mptcp: drop MP_JOIN request sock on syn cookies

 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 57 +++++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 30 deletions(-)

-- 
2.26.2

