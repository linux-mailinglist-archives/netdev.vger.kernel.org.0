Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18223B8B9B
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395112AbfITHgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393025AbfITHgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:05 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB1F20882;
        Fri, 20 Sep 2019 07:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964964;
        bh=dQUsk/o5uMV+npK42FSh05eASaLn3Oc+vghpMuoEMr0=;
        h=From:To:Cc:Subject:Date:From;
        b=GWmw57ogbmy7HVdCnKA/A9p4TLYQ20hJtV5AsjwD4DRvnaWtBoSRg7RgEgjHAxqRr
         zMPMxs94U9tsjhItituuVTL8p9gVNwh8URjHd11lQKcSXnI5+UEn8Nh9y21oH9Xaby
         pXe3Ny2iLVghuEs7UhpFCh3+FBXm81SdgZxv7g98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/5] Raw socket cleanups
Date:   Fri, 20 Sep 2019 09:35:44 +0200
Message-Id: <20190920073549.517481-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ori Nimron pointed out that there are a number of places in the kernel
where you can create a raw socket, without having to have the
CAP_NET_RAW permission.

To resolve this, here's a short patch series to test these odd and old
protocols for this permission before allowing the creation to succeed

All patches are currently against the net tree.

thanks,

greg k-h

Ori Nimron (5):
  mISDN: enforce CAP_NET_RAW for raw sockets
  appletalk: enforce CAP_NET_RAW for raw sockets
  ax25: enforce CAP_NET_RAW for raw sockets
  ieee802154: enforce CAP_NET_RAW for raw sockets
  nfc: enforce CAP_NET_RAW for raw sockets

 drivers/isdn/mISDN/socket.c | 2 ++
 net/appletalk/ddp.c         | 5 +++++
 net/ax25/af_ax25.c          | 2 ++
 net/ieee802154/socket.c     | 3 +++
 net/nfc/llcp_sock.c         | 7 +++++--
 5 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.23.0

