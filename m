Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA353C21B4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhGIJni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhGIJni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 05:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625823653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qA+SyewCNYf5OXjx1Nxx9GJAJJQcJhSl6I24mynK1xU=;
        b=fMD092xEGSvPlySdMNWRAuufWazbU3XSXLsz7xdlnwqIUP/e2+NDgBustKgsJjyJMc4guq
        9Eg9m7kq48HxpUZxh6uhqw0F2nMpaKHlPeaBXdhrwDFB3tb4cQ3+N+P7N+kzTRL74NwU20
        41ieaUVr/sHvIDRW9x9UA/e0Z3Q00tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-APfBYMZEO9CSfuHL88tUbg-1; Fri, 09 Jul 2021 05:40:52 -0400
X-MC-Unique: APfBYMZEO9CSfuHL88tUbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C436B10C1ADC;
        Fri,  9 Jul 2021 09:40:50 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-68.ams2.redhat.com [10.36.113.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65D43369A;
        Fri,  9 Jul 2021 09:40:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, toke@redhat.com
Subject: [RFC PATCH 0/3] veth: more flexible channels number configuration
Date:   Fri,  9 Jul 2021 11:39:47 +0200
Message-Id: <cover.1625823139.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP setups can benefit from multiple veth RX/TX queues. Currently
veth allow setting such number only at creation time via the 
'numrxqueues' and 'numtxqueues' parameters.

This series introduces support for the ethtool set_channel operation
and allows configuring the queue number via a new module parameter.

The veth default configuration is not changed.

Finally self-tests are updated to check the new features, with both
valid and invalid arguments.

Paolo Abeni (3):
  veth: implement support for set_channel ethtool op
  veth: make queues nr configurable via kernel module params
  selftests: net: veth: add tests for set_channel

 drivers/net/veth.c                  | 83 +++++++++++++++++++++++++++--
 tools/testing/selftests/net/veth.sh | 65 ++++++++++++++++++++++
 2 files changed, 144 insertions(+), 4 deletions(-)

-- 
2.26.3

