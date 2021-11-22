Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF21459328
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbhKVQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:39:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236124AbhKVQjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637598972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xOj6PkANhb6frdrg6dV7v39rxknergSrEgBUTsnCA3U=;
        b=flBrNc5HyuVHQ9cKn7TqKN43iA5+BJGLD9bvMSprU0RTq6Piwb7NjMVVF1GP3hDdaCdVm/
        VoRXl7+anOKKN8YGbdmSJsMMIHnjqS0OSZhebIUT+WIm0oG4gOYg7NaYYAHzal31pnE9wW
        MoB9J0+9sILkbfQnUtqGPzdjcs9uQ/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-s8WjydtlOVmkHHoVEWKNiA-1; Mon, 22 Nov 2021 11:36:09 -0500
X-MC-Unique: s8WjydtlOVmkHHoVEWKNiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A771023F4F;
        Mon, 22 Nov 2021 16:36:07 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6D1D60C7F;
        Mon, 22 Nov 2021 16:35:26 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/2] vhost/vsock: fix used length and cleanup in vhost_vsock_handle_tx_kick()
Date:   Mon, 22 Nov 2021 17:35:23 +0100
Message-Id: <20211122163525.294024-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up to Micheal's patch [1] and the discussion with Halil and
Jason [2].

I made two patches, one to fix the problem and one for cleanup. This should
simplify the backport of the fix because we've had the problem since
vhost-vsock was introduced (v4.8) and that part has been touched a bit
recently.

Thanks,
Stefano

[1] https://lore.kernel.org/virtualization/20211122105822.onarsa4sydzxqynu@steredhat/T/#t
[2] https://lore.kernel.org/virtualization/20211027022107.14357-1-jasowang@redhat.com/T/#t

Stefano Garzarella (2):
  vhost/vsock: fix incorrect used length reported to the guest
  vhost/vsock: cleanup removing `len` variable

 drivers/vhost/vsock.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
2.31.1

