Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38BD3BFA15
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhGHMah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:30:37 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44986 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229659AbhGHMaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 08:30:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 04C1349E3D;
        Thu,  8 Jul 2021 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1625747271; x=
        1627561672; bh=bO6Qk1sZMJQVSInPZGyfZf+bln/u5E6eqcOxjG61nAI=; b=i
        Uam7raNvzYwN4+UwSq3eZuNlTjP5MUUCB9cggKvAaJV3IMfiTp3tTfoELDGyU78C
        PEE4y+++SLQ0O3+dxaPq0eYaGylne3oLUUs+TL6Z2B4I/Chyowea68IdB0NX7JDE
        mkuJZZKICAA9p5ywlFHaQo0psLvNEQekFsKFZ4KTos=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wb_Ks_nfBjDz; Thu,  8 Jul 2021 15:27:51 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0320949F4C;
        Thu,  8 Jul 2021 15:18:25 +0300 (MSK)
Received: from fedora.mshome.net (10.199.0.196) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 8 Jul
 2021 15:18:25 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH v2 0/3] net/ncsi: Add NCSI Intel OEM command to keep PHY link up
Date:   Thu, 8 Jul 2021 15:27:51 +0300
Message-ID: <20210708122754.555846-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.196]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NCSI Intel OEM command to keep PHY link up and prevents any channel
resets during the host load on i210. Also includes dummy response handler for
Intel manufacturer id.

Changes from v1:
 1. sparse fixes about casts
 2. put it after ncsi_dev_state_probe_cis instead of
    ncsi_dev_state_probe_channel because sometimes channel is not ready
    after it
 3. inl -> intel

Ivan Mikhaylov (3):
  net/ncsi: fix restricted cast warning of sparse
  net/ncsi: add NCSI Intel OEM command to keep PHY up
  net/ncsi: add dummy response handler for Intel boards

 net/ncsi/Kconfig       |  6 +++++
 net/ncsi/internal.h    |  5 +++++
 net/ncsi/ncsi-manage.c | 51 +++++++++++++++++++++++++++++++++++++++---
 net/ncsi/ncsi-rsp.c    | 11 +++++++--
 4 files changed, 68 insertions(+), 5 deletions(-)

-- 
2.31.1

