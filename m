Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D736348EEBA
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbiANQvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:51:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243612AbiANQvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642179073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mz0McVmz0c/y6E0RRwfclZT7znKsFbTVCd8UTGZGhtE=;
        b=MMLzgXcujKuhwDREneVbC2Y0vAQRixLuIVhaxc3RdDSsNiUaY/gAEpFW5lFchKtMa8swHG
        H0t87+lWVvAemJHQh708oSjOdwy5NatyOLv6P7Sa9zZY37ROyCvOhWvK7kKXJXQgpBajJY
        SZYmeDLP389rtsux1Hd89Wt7b2Z3QWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-OY6n0IEJMUeq1_63EygUXA-1; Fri, 14 Jan 2022 11:51:10 -0500
X-MC-Unique: OY6n0IEJMUeq1_63EygUXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13165184C5E5;
        Fri, 14 Jan 2022 16:51:09 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DE6C7D3D8;
        Fri, 14 Jan 2022 16:51:08 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id E3D59A80ED6; Fri, 14 Jan 2022 17:51:06 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 0/2 net-next v3] igb/igc: fix XDP registration
Date:   Fri, 14 Jan 2022 17:51:04 +0100
Message-Id: <20220114165106.1085474-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the kernel warning "Missing unregister, handled but fix driver"
when running, e.g.,

  $ ethtool -G eth0 rx 1024

on igc.  Remove memset hack from igb and align igb code to igc. 

v3: use dev_err rather than netdev_err, just as in error case.

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 14 ++++++++++----
 drivers/net/ethernet/intel/igc/igc_main.c    | 20 +++++++++++---------
 3 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.27.0

