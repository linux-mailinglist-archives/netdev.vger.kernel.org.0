Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A54F2B82F1
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgKRRSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:18:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbgKRRSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kJb3feyPTImfowO8iHpgcySqT14nNDyBBUYlrp7JniM=;
        b=Kav4HMmUjFUeknwlpy4oKYGR1pb4x1QzFLKr6JJTs/HX9qocOOAInruhLEBKXI3hGMf0Tn
        igSO5drEt6xJ7HueMP2bH4abfdb2GLC9UUQxBhWs+rs8uEhRKJhNVnlzUtPjpizWQdiHYb
        U7bLE1JOyxOAitfdHZirCjr18CJs+7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-p3O7V1zyNP-zEB--A_kBGQ-1; Wed, 18 Nov 2020 12:18:34 -0500
X-MC-Unique: p3O7V1zyNP-zEB--A_kBGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64ACA64156;
        Wed, 18 Nov 2020 17:18:33 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2320F60843;
        Wed, 18 Nov 2020 17:18:31 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v5 0/6] netdevsim: add ethtool coalesce and ring settings
Date:   Wed, 18 Nov 2020 18:18:21 +0100
Message-Id: <20201118171827.48143-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Changelog v4 -> v5
- in ethtool-common.sh selftests changed
  echo '$(ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/)'
  to just 'ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/'

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

