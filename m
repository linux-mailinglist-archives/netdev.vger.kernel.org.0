Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDE12B85E7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgKRUpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:45:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbgKRUpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605732332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NPj+PRVtUq3cXUy+/thTdIOLrqlIwqbFhtAI7DsTmpY=;
        b=ILOKIMNtLFCWVCkxEsZ6OsY0MjqOZtVgpDq9zDoTWky2ifE558dxyUXNUjdkj+LG3/rnmy
        F5m9XBY0ov4blR6eSXE0qV5z/skTtNaOFefX/tWpDLPoDKA3Fvb3ZJK/3BVYfErpGh4vHr
        t7dcp30L+GIkGkaAxCul/S536EIV+rU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-eDNWLQTBOzW8q9NhHZiOGQ-1; Wed, 18 Nov 2020 15:45:27 -0500
X-MC-Unique: eDNWLQTBOzW8q9NhHZiOGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 515A38144E1;
        Wed, 18 Nov 2020 20:45:26 +0000 (UTC)
Received: from yoda.redhat.com (unknown [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A361A19481;
        Wed, 18 Nov 2020 20:45:24 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 0/6] netdevsim: add ethtool coalesce and ring settings
Date:   Wed, 18 Nov 2020 21:45:16 +0100
Message-Id: <20201118204522.5660-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output of ethtool-ring.sh and ethtool-coalesce.sh selftests:

# ./ethtool-ring.sh
PASSED all 4 checks
# ./ethtool-coalesce.sh
PASSED all 22 checks
# ./ethtool-pause.sh
PASSED all 7 checks

Changelog v5 -> v6
- moved some bits from patch 3, they
  were part of a refactoring made in patch 2

Antonio Cardace (6):
  ethtool: add ETHTOOL_COALESCE_ALL_PARAMS define
  netdevsim: move ethtool pause params in separate struct
  netdevsim: support ethtool ring and coalesce settings
  selftests: extract common functions in ethtool-common.sh
  selftests: refactor get_netdev_name function
  selftests: add ring and coalesce selftests

 drivers/net/netdevsim/ethtool.c               |  82 +++++++++--
 drivers/net/netdevsim/netdevsim.h             |   9 +-
 include/linux/ethtool.h                       |   1 +
 .../drivers/net/netdevsim/ethtool-coalesce.sh | 132 ++++++++++++++++++
 .../drivers/net/netdevsim/ethtool-common.sh   |  53 +++++++
 .../drivers/net/netdevsim/ethtool-pause.sh    |  63 +--------
 .../drivers/net/netdevsim/ethtool-ring.sh     |  85 +++++++++++
 7 files changed, 352 insertions(+), 73 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh

--
2.28.0

