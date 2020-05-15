Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8851F1D5A57
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOTtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgEOTtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:49:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A52B520709;
        Fri, 15 May 2020 19:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589572147;
        bh=RZFO3RDxeq+k6RcP5Uk+u+NTu2qRyUvDt6Tftceva2g=;
        h=From:To:Cc:Subject:Date:From;
        b=CLWR1azuyoKsrb9fZwrB1u6a0n1Xm1+H9QaQ5ElUNtTJLFt4IIdfFGIXzreGA2KNN
         3Wv7djpimynLr39wbHkXEKDsxRKHM2AcfCWl1tT+B0FMEC/ZDf5ZyY1CXmPIzLCeud
         boHDv225Z8CbYD+Znku/5npQ4dCq1CTjt+DyOmNQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] ethtool: set_channels: add a few more checks
Date:   Fri, 15 May 2020 12:48:59 -0700
Message-Id: <20200515194902.3103469-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There seems to be a few more things we can check in the core before
we call drivers' ethtool_ops->set_channels. Adding the checks to
the core simplifies the drivers. This set only includes changes
to the NFP driver as an example.

There is a small risk in the first patch that someone actually
purposefully accepts a strange configuration without RX or TX
channels, but I couldn't find such a driver in the tree.

Jakub Kicinski (3):
  ethtool: check if there is at least one channel for TX/RX in the core
  nfp: don't check lack of RX/TX channels
  ethtool: don't call set_channels in drivers if config didn't change

 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  3 +--
 net/ethtool/channels.c                        | 20 +++++++++++++++++--
 net/ethtool/ioctl.c                           | 11 ++++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.25.4

