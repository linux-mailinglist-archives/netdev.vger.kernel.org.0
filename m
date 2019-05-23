Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51ADF27C5A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfEWMC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:02:26 -0400
Received: from first.geanix.com ([116.203.34.67]:60894 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbfEWMCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:02:25 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 9A6DE10F8;
        Thu, 23 May 2019 12:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558612893; bh=HrgnYYnHur/QLHWQbAmloKtt+lKZPpX++QwH57NdTfI=;
        h=From:To:Cc:Subject:Date;
        b=fjaoAzU0+IDDhfO5SOuOsLZnHkxr+4kKq3ehop+3Kauko16FBvtoTsEQWBinbT+P8
         +CYrLnpiQH7TYim20uSgfMmCW/Hb2sUGzCpyclE+7CjPu495j42tsSIHbgiBvlZ5/A
         tTX3zPB9xccknptd6tAn9baC67Grzabh88wqWVVBuoKqEp7qZaCwpqfNKILMwzbLb8
         zwV9F208VPbwaXXMzVyIFTDpquTINyjbpHyyJApieOLNm1s/+3ODEKDgAwQiGr6Yoo
         1/rWJ/ztr73+47S3UsLm9VQ4B+DhHpPwzBUnVFBOZPy+MPm94tfSU5W1aDHss8sI9j
         fTmqZKanHN0Hg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] net: ll_temac: Fix and enable multicast support
Date:   Thu, 23 May 2019 14:02:18 +0200
Message-Id: <20190523120222.3807-1-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series makes the necessary fixes to ll_temac driver to make
multicast work, and enables support for it.so that multicast support can

The main change is the change from mutex to spinlock of the lock used to
synchronize access to the shared indirect register access.

Esben Haabendal (4):
  net: ll_temac: Do not make promiscuous mode sticky on multicast
  net: ll_temac: Prepare indirect register access for multicast support
  net: ll_temac: Cleanup multicast filter on change
  net: ll_temac: Enable multicast support

 drivers/net/ethernet/xilinx/ll_temac.h        |   5 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 255 +++++++++++++++++---------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   |  20 +-
 include/linux/platform_data/xilinx-ll-temac.h |   3 +-
 4 files changed, 184 insertions(+), 99 deletions(-)

-- 
2.4.11

