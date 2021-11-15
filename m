Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74085450116
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhKOJX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:23:57 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:12298 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237544AbhKOJXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968021; x=1668504021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mTBUnMaN2CwH+4/F0vBfQFDpL5MOx60vPr71EBqcjFM=;
  b=YXXeVdRYbFpJRkoHUBi0G3E0osuhT9BtZeX+U1f11Sjml+y3Nh1xkvRp
   qK9DgeVazofVJvlu6S/Ai6qL3/jAKxr8V4XySswoKlom7LyjPrv5+Md4a
   epOTjEO/9u66q0s/qxkLAUtrUf8bkcC3/l4Bz/fvsyv5nxE8gu2hUOoeh
   DH6QqJC7keNyiZOLT3eP4qVAaB7vR4L0lOEQTK321Ju17/b8wlBrzpEub
   kwzCtaHWA4NKaYtpzalTcvxzOOAIoYDHapVVkuFgBv/yjXkIdTl1u9XFf
   NDWMsTpZdYOxhmg40xM+5lO5sxrB+nRpMPK+UWKJUKkWA7vhSHTAjhUKk
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459390"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 15 Nov 2021 10:20:19 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 15 Nov 2021 10:20:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968019; x=1668504019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mTBUnMaN2CwH+4/F0vBfQFDpL5MOx60vPr71EBqcjFM=;
  b=H22jx6mUIVt1bJCEgO5syVpxx8LxEvP3lDuNBnFtzXmxjcdkNZMyOc4G
   9DnUIBiuepZsQ6UneOlTlQa2WoYSHhBWbJdX46w/cWaSc7JTW9A5rzqm/
   cgNU8/x/OaQqLszm/E2r3M84l3DVfUyzK7S3E7f0flpvzAP838ZtqH5n5
   Miw9rQ8AgFDMukrMAUH03kh+k82hUAMGJgyCG41lcjiL+5r5SdHqMJinH
   cEdMqiDeBbXCPKdbCZIdp9t6m64PUCGfXJpq/mrdNFSd4WGqg0lHv/Nfn
   mwQ3SDBqgvaBN5N3sM4sR8VWR9eUn8eBYkfWT7cIR74o8cb/wiKxko5Jn
   A==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459389"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Nov 2021 10:20:18 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id B0E83280065;
        Mon, 15 Nov 2021 10:20:18 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net 0/4] Fix bit timings for m_can_pci (Elkhart Lake)
Date:   Mon, 15 Nov 2021 10:18:48 +0100
Message-Id: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes two issues we found with the setup of the CAN
controller of Intel Elkhart Lake CPUs:

- Patch 1 fixes an incorrect reference clock rate, which caused the
  configured and the actual bitrate always to differ by a factor of 2.
- Patches 2-4 fix a deviation between the driver and the documentation.
  We did not actually see issues without these patches, however we did
  only superficial testing and may just not have hit the specific
  bittiming values that violate the documented limits.


Matthias Schiffer (4):
  can: m_can: pci: fix incorrect reference clock rate
  Revert "can: m_can: remove support for custom bit timing"
  can: m_can: make custom bittiming fields const
  can: m_can: pci: use custom bit timings for Elkhart Lake

 drivers/net/can/m_can/m_can.c     | 24 ++++++++++++----
 drivers/net/can/m_can/m_can.h     |  3 ++
 drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 10 deletions(-)

-- 
2.17.1

