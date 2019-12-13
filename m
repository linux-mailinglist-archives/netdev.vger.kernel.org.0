Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012F011EAAF
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfLMSsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:48:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22282 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728544AbfLMSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576262889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=deTmsk0BQdQEPhCCzmHgYqMaF0cfRBrvO3lqwb43CWA=;
        b=ibaVLrghPB2eFq31ccfq0+S4rrTYuYsgvzdrl1waoUZfg5yquePzktywl4d7j1mQU/0utV
        ZUVF6QJXBWcqzaIsz6zTZ5kbD5EjaA0WGT/WrHAkpXcPL0OqqIztEEID+14mmBQQhX7JHV
        Tps23HvBwJOrP6JvOcgrExhEgBKUfhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-HA1EV8o7OLOXy-TFUmvD3g-1; Fri, 13 Dec 2019 13:48:08 -0500
X-MC-Unique: HA1EV8o7OLOXy-TFUmvD3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36A0D911EA;
        Fri, 13 Dec 2019 18:48:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-123.ams2.redhat.com [10.36.117.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F183B60BB3;
        Fri, 13 Dec 2019 18:48:02 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net 0/2] vsock/virtio: fix null-pointer dereference and related precautions
Date:   Fri, 13 Dec 2019 19:47:59 +0100
Message-Id: <20191213184801.486675-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series mainly solves a possible null-pointer dereference in
virtio_transport_recv_listen() introduced with the multi-transport
support [PATCH 1].

PATCH 2 adds a WARN_ON check for the same potential issue
and a returned error in the virtio_transport_send_pkt_info() function
to avoid crashing the kernel.

Stefano Garzarella (2):
  vsock/virtio: fix null-pointer dereference in
    virtio_transport_recv_listen()
  vsock/virtio: add WARN_ON check on virtio_transport_get_ops()

 net/vmw_vsock/virtio_transport_common.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--=20
2.23.0

