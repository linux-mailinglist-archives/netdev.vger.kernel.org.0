Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F34A6DDA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245485AbiBBJeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:34:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233545AbiBBJeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:34:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643794442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rXtEWN+8Jy8SR9rZCROL6oOyXk7lp4ziOlhOKvOOn1s=;
        b=MRS/N9EV7PAgwY6yU6m3vZLN3O8hDTWMKyoLZs56DxkyTL+QsHPnAQgEhZ917cTSvJ/sia
        lM0THVWMuYbQOIk6WTWbl6rVX/ghc6Z4/21EJvKbGGrk0V0Z0O3FTlH1rOqjWu9N0vxuHg
        StTKYX64TqSHCXldJSoill8ZGWdjNr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-VA3e2N1qOz6z5AAwiV7Ovg-1; Wed, 02 Feb 2022 04:34:01 -0500
X-MC-Unique: VA3e2N1qOz6z5AAwiV7Ovg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D1583DD22
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:34:00 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A11E2C1;
        Wed,  2 Feb 2022 09:33:59 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv2 net-next 0/4] Virtual PTP clock improvements and fix
Date:   Wed,  2 Feb 2022 10:33:54 +0100
Message-Id: <20220202093358.1341391-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- dropped patch changing initial time of virtual clocks

The first patch fixes an oops when unloading a driver with PTP clock and
enabled virtual clocks.

The other patches add missing features to make synchronization with
virtual clocks work as well as with the physical clock.

Miroslav Lichvar (4):
  ptp: unregister virtual clocks when unregistering physical clock.
  ptp: increase maximum adjustment of virtual clocks.
  ptp: add gettimex64() to virtual clocks.
  ptp: add getcrosststamp() to virtual clocks.

 drivers/ptp/ptp_clock.c  | 11 ++++++--
 drivers/ptp/ptp_vclock.c | 56 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 62 insertions(+), 5 deletions(-)

-- 
2.34.1

