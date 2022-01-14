Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1837A48F09E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbiANTpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:45:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244145AbiANTp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:45:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642189527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w81NuT0Y/p/jPnM6I442o7/MwnIeoaEhe7NUqOX9sBY=;
        b=dxYHfWOzVcfYf9hGQ+Z0wZtd1SlXRn7HaTP0tcdziQU0Gj87mPbL1bTun8w7/io2XQ0qPz
        TzJa28TgA1FxhxYkLFDceoZkHu9GCoQnxL+B3N7WlaWjuSp8HwnvvLblx9PW7THGSsaxzu
        JNtobIZty/Ggw7ZNoPaoXqrQTwI0BEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-i0DC8TI4Pm-bft9orILLAQ-1; Fri, 14 Jan 2022 14:45:23 -0500
X-MC-Unique: i0DC8TI4Pm-bft9orILLAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3664C1898292;
        Fri, 14 Jan 2022 19:45:22 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0364C4D706;
        Fri, 14 Jan 2022 19:45:22 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 84A44A80ED6; Fri, 14 Jan 2022 20:45:20 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 0/2 net-next v4] igb/igc: fix XDP registration
Date:   Fri, 14 Jan 2022 20:45:18 +0100
Message-Id: <20220114194520.1092894-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the kernel warning "Missing unregister, handled but fix driver"
when running, e.g.,

  $ ethtool -G eth0 rx 1024

on igc.  Remove memset hack from igb and align igb code to igc. 

v3: use dev_err rather than netdev_err, just as in error case.
v4: fix a return copy/pasted from original igc code into the correct
    `goto err', improve commit message.

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 12 +++++++++---
 drivers/net/ethernet/intel/igc/igc_main.c    | 20 +++++++++++---------
 3 files changed, 20 insertions(+), 16 deletions(-)

-- 
2.27.0

