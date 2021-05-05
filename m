Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8D373EA0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhEEPhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:37:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231995AbhEEPhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620228971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8kL+nRSL6e/pwTnH20Ar2gTEfXlly1Y2vU8SDj3uNh8=;
        b=eBpRyjl31K6wjheGwnVtL1GWu6FeQBCq+bbm4AtA1ABInyfzeU6a9lcR4KA5tFHtOugjQZ
        +3qWNtvojY+o7XQYq2TH5cwimrCBbo2mQ4g6IMbYQsJkzFcW5K9ZdC7DOOqiy5++FZn1Yu
        nhsYPT637Wgti1AoN4ejW1Kis0UWN4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-U6hv7OZAPsCpjL3VqjXlmQ-1; Wed, 05 May 2021 11:36:09 -0400
X-MC-Unique: U6hv7OZAPsCpjL3VqjXlmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F7DD8042B4;
        Wed,  5 May 2021 15:36:08 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA3FC5C1A3;
        Wed,  5 May 2021 15:36:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net 0/4] udp: more FRAGLIST fixes
Date:   Wed,  5 May 2021 17:35:00 +0200
Message-Id: <cover.1620223174.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes a bunch of fixes for SKB_GSO_FRAGLIST
packets, popped out while enabling the mentioned GRO type
in non trivial forwarding scenarios.

The last patch extends the existing UDP GRO self-tests to
cover the currently bugged cases.

Paolo Abeni (4):
  net: fix double-free on fraglist GSO skbs
  udp: fix out-of-bound at segmentation time
  udp: fix outer header csum for SKB_GSO_FRAGLIST over UDP tunnel
  selftests: more UDP GRO tests

 net/core/skbuff.c                             |  6 +++
 net/ipv4/udp.c                                |  2 +-
 net/ipv4/udp_offload.c                        | 45 +++++++++++-----
 tools/testing/selftests/net/set_sysfs_attr.sh | 15 ++++++
 tools/testing/selftests/net/udpgro_fwd.sh     | 54 +++++++++++++++++++
 5 files changed, 107 insertions(+), 15 deletions(-)
 create mode 100755 tools/testing/selftests/net/set_sysfs_attr.sh

-- 
2.26.2

