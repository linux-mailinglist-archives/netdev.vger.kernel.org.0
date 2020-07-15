Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03410221465
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGOSl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgGOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:25 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214B0C08C5DB;
        Wed, 15 Jul 2020 11:41:24 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfHQs016674
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838478; bh=XO4cHZWyZMEn/b68HAWj2tkmcP8C5MGEAPzztaFclIA=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=GeIgA4jvbQ2um49AnyFSyNGUdmFkhMpKUx+RW9xEPEDnLhT936CzemKxiNKC4k6wI
         udnhvwmCubDqrKzEB3Uezxu5obsSQHAlL1QH3cYisXfBUSmrLgJOjgfWuvhQ+Pwbee
         wZH5aYYVt/5Rqc5LzhAdWYLBPpUNfzoqorA0FRp8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLF-000SSQ-39; Wed, 15 Jul 2020 20:41:17 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 0/5] usbnet: multicast filter support for cdc ncm devices
Date:   Wed, 15 Jul 2020 20:40:55 +0200
Message-Id: <20200715184100.109349-1-bjorn@mork.no>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This revives a 2 year old patch set from Miguel Rodríguez
Pérez, which appears to have been lost somewhere along the
way.  I've based it on the last version I found (v4), and
added one patch which I believe must have been missing in
the original.

I kept Oliver's ack on one of the patches, since both the patch and
the motivation still is the same.  Hope this is OK..

Thanks to the anonymous user <wxcafe@wxcafe.net> for bringing up this
problem in https://bugs.debian.org/965074

This is only build and load tested by me.  I don't have any device
where I can test the actual functionality.


Changes v5:
 - added missing symbol export
 - formatted patch subjects with subsystem


Bjørn Mork (1):
  net: usbnet: export usbnet_set_rx_mode()

Miguel Rodríguez Pérez (4):
  net: cdc_ether: use dev->intf to get interface information
  net: cdc_ether: export usbnet_cdc_update_filter
  net: cdc_ncm: add .ndo_set_rx_mode to cdc_ncm_netdev_ops
  net: cdc_ncm: hook into set_rx_mode to admit multicast traffic

 drivers/net/usb/cdc_ether.c | 7 +++----
 drivers/net/usb/cdc_ncm.c   | 4 ++++
 drivers/net/usb/usbnet.c    | 3 ++-
 include/linux/usb/usbnet.h  | 2 ++
 4 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.27.0

