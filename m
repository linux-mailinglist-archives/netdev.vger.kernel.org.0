Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF803374B4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhCKNxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:53:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233773AbhCKNxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 08:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615470787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=59EuosthGHx5pcdxoFo5VSdTfTOx4fAiPVEz1PyRq70=;
        b=YxklYQR3NslwfBa5OB1XodkEKBWEeu2NBDqLxmoF/4WBl4M05Op5KaxXzPwT1TTHOqONnS
        /zZ7gCcrxBSNBg0YjS3KFMfsgfv2U/8Jc9YRqNE8023eYGS68GOjhg3zY2tky94XQQ0bMc
        CJeU/k/mO0iTVRsUoQ2ugTCGX1mmwho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326--AguXVqBONyBY1GEZFmkUw-1; Thu, 11 Mar 2021 08:53:04 -0500
X-MC-Unique: -AguXVqBONyBY1GEZFmkUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B554C100C618;
        Thu, 11 Mar 2021 13:53:03 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D748A196E3;
        Thu, 11 Mar 2021 13:52:58 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/2] vhost-vdpa: fix issues around v->config_ctx handling
Date:   Thu, 11 Mar 2021 14:52:55 +0100
Message-Id: <20210311135257.109460-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While writing a test for a Rust library [1] to handle vhost-vdpa devices,
I experienced the 'use-after-free' issue fixed in patch 1, then I
discovered the potential issue when eventfd_ctx_fdget() fails fixed in
patch 2.

Do you think it might be useful to write a vdpa test suite, perhaps using
this Rust library [2] ?
Could we put it in the kernel tree in tool/testing?

Thanks,
Stefano

[1] https://github.com/stefano-garzarella/vhost/tree/vdpa
[2] https://github.com/rust-vmm/vhost

Stefano Garzarella (2):
  vhost-vdpa: fix use-after-free of v->config_ctx
  vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails

 drivers/vhost/vdpa.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.29.2

