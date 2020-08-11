Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A43241929
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 11:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgHKJzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 05:55:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728423AbgHKJzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 05:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597139721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ARUSqSkquuJlHefVM/we7tLn6Y34P6IHwTWPXDZ/fcc=;
        b=Vek8bieFTN0kMDtYi4Z5vUYw7J5+Xy7EVZao0lxF32Uluzd4YGMkiONY8w//WwRgHeqyWg
        VefF/0InmbkuVXIQtyYqB4Wqpnb7mh6IGrUlQOX9qcjyfESd4E+i2ZmEcHnQ9T9vjbyeGd
        4Km3ZC70iOU8BOiK4d8ArgXPDhFpeZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-QD2RIGNDOhCl7Iw_ou2VIg-1; Tue, 11 Aug 2020 05:55:19 -0400
X-MC-Unique: QD2RIGNDOhCl7Iw_ou2VIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BB4857;
        Tue, 11 Aug 2020 09:55:18 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-182.ams2.redhat.com [10.36.113.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04F3F5D9FC;
        Tue, 11 Aug 2020 09:55:05 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net 0/2] vsock: fix null pointer dereference and cleanup in
 vsock_poll()
Date:   Tue, 11 Aug 2020 11:55:02 +0200
Message-Id: <20200811095504.25051-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes a potential null pointer dereference in vsock_poll()
reported by syzbot.
The second patch is a simple cleanup in the same block code. I put this later,
to make it easier to backport the first patch in the stable branches.

Thanks,
Stefano

Stefano Garzarella (2):
  vsock: fix potential null pointer dereference in vsock_poll()
  vsock: small cleanup in vsock_poll()

 net/vmw_vsock/af_vsock.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

-- 
2.26.2

