Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09777F60D1
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfKISCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 13:02:32 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:54930 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfKISCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 13:02:32 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Nov 2019 13:02:31 EST
Received: from localhost.localdomain (unknown [185.216.33.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id 0CD5C1F56B;
        Sat,  9 Nov 2019 18:54:38 +0100 (CET)
From:   Matthias Schiffer <mschiffer@universe-factory.net>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH net-next 0/2] Implement get_link_ksettings for VXLAN and bridge
Date:   Sat,  9 Nov 2019 18:54:12 +0100
Message-Id: <cover.1573321597.git.mschiffer@universe-factory.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mesh routing protocol batman-adv (in particular the new BATMAN_V algorithm)
uses the link speed reported by get_link_ksettings to determine a path
metric for wired links. In the mesh framework Gluon [1], we layer VXLAN
and sometimes bridge interfaces on our Ethernet links.

These patches implement get_link_ksettings for these two interface types.
While this is obviously not accurate for bridges with multiple active
ports, it's much better than having no estimate at all (and in the
particular setup of Gluon, bridges with a single port aren't completely
uncommon).


[1] https://github.com/freifunk-gluon/gluon

Matthias Schiffer (2):
  vxlan: implement get_link_ksettings ethtool method
  bridge: implement get_link_ksettings ethtool method

 drivers/net/vxlan.c    | 24 ++++++++++++++++++++++--
 net/bridge/br_device.c | 37 +++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 4 deletions(-)

-- 
2.24.0

