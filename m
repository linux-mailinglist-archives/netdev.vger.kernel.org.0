Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09C2DD527
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgLQQ0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgLQQ0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 11:26:05 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 0/4] net-sysfs: fix race conditions in the xps code
Date:   Thu, 17 Dec 2020 17:25:17 +0100
Message-Id: <20201217162521.1134496-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

This series fixes two similar issues, one with xps_cpus and one with
xps_rxqs, where a race condition can occur between accesses to the
xps_cpus and xps_rxqs maps and the update of dev->num_tc. Those races
lead to accesses outside of the map and oops being triggered. An
explanation is given in each of the commit logs.

Thanks!
Antoine

Antoine Tenart (4):
  net-sysfs: take the rtnl lock when storing xps_cpus
  net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
  net-sysfs: take the rtnl lock when storing xps_rxqs
  net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

 net/core/net-sysfs.c | 65 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

-- 
2.29.2

