Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A802B6883
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgKQPUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:20:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728430AbgKQPUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605626424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oe1R+9TAtJh1pbiakoPV0XjYm5UahVb5N61wrSAyF8E=;
        b=fBP//91Yfy3D1vASsDT0xQvZBFy0GfNd1KSAOjuTnVDzi9YiPSdVDQc0RiJ7MrJkOetDAN
        ZwhKRpfRzjUW2BUiNZTYJkARmlaM1m47h5AqwqkA6efV0vhwF4nY5FvmUSSWaFw4GkS3/L
        7vrr0JUtoYEpBbqr4g/QJzMtwznFpws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-21fgRis4PwOIqnUOWdu7sQ-1; Tue, 17 Nov 2020 10:20:22 -0500
X-MC-Unique: 21fgRis4PwOIqnUOWdu7sQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78451009608;
        Tue, 17 Nov 2020 15:20:20 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A59E41841D;
        Tue, 17 Nov 2020 15:20:19 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v4 0/6] netdevsim: add ethtool coalesce and ring settings
Date:   Tue, 17 Nov 2020 16:20:09 +0100
Message-Id: <20201117152015.142089-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output of ethtool-ring.sh and ethtool-coalesce.sh selftests:

# ./ethtool-ring.sh
PASSED all 4 checks
# ./ethtool-coalesce.sh
PASSED all 22 checks

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

