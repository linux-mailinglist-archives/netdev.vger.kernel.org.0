Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4FD4091
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfJKNIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13287 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbfJKNIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:08:07 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B6553082128;
        Fri, 11 Oct 2019 13:08:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-54.ams2.redhat.com [10.36.117.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD59C60600;
        Fri, 11 Oct 2019 13:07:59 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] vsock: don't allow half-closed socket in the host transports
Date:   Fri, 11 Oct 2019 15:07:56 +0200
Message-Id: <20191011130758.22134-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 11 Oct 2019 13:08:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are implementing a test suite for the VSOCK sockets and we discovered
that vmci_transport never allowed half-closed socket on the host side.

As Jorgen explained [1] this is due to the implementation of VMCI.

Since we want to have the same behaviour across all transports, this
series adds a section in the "Implementation notes" to exaplain this
behaviour, and changes the vhost_transport to behave the same way.

[1] https://patchwork.ozlabs.org/cover/847998/#1831400

Stefano Garzarella (2):
  vsock: add half-closed socket details in the implementation notes
  vhost/vsock: don't allow half-closed socket in the host

 drivers/vhost/vsock.c    | 17 ++++++++++++++++-
 net/vmw_vsock/af_vsock.c |  4 ++++
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.21.0

