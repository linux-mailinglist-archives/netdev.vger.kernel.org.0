Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB61EF55E
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgFEKa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:30:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:57119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgFEKa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:30:56 -0400
IronPort-SDR: HgTTl5rFinaru+pbSwF02zgyHaVdHfYMXjjn49YOUmQ+dfDQECEPALgZn13V0PspPGIFP35E0c
 lC8/tccTpqaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:30:56 -0700
IronPort-SDR: f0WJCG+GZdUy4Koqo1sSzDk+cHeA6vF5M5kG1b6BlzQ4AajHHlbMjNeO6wofs1ElSQw9XHE6dI
 /i9r6KU9wbRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="305024833"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 03:30:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 0/5] vDPA:config interrupt support and IRQ improvements
Date:   Fri,  5 Jun 2020 18:27:10 +0800
Message-Id: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series intends to introduce:
(1) config interrupt in vhost_vdpa and IFCVF.
(2) handle datapath and IRQ managent in the status handler,
so that it would comply to virtio spec, and more reliable

Most patches already got ACKed, excepted for 
ifcvf: ignore continuous setting same staus value

Please help review

Zhu Lingshan (5):
  ifcvf: move IRQ request/free to status change handlers
  ifcvf: ignore continuous setting same staus value
  vhost_vdpa: Support config interrupt in vhost_vdpa
  vhost: replace -1 with VHOST_FILE_UNBIND in iotcls
  ifcvf: implement config interrupt in IFCVF

 drivers/vdpa/ifcvf/ifcvf_base.c |   3 +
 drivers/vdpa/ifcvf/ifcvf_base.h |   4 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 146 +++++++++++++++++++++++++++-------------
 drivers/vhost/vdpa.c            |  47 +++++++++++++
 drivers/vhost/vhost.c           |   8 +--
 include/uapi/linux/vhost.h      |   4 ++
 6 files changed, 160 insertions(+), 52 deletions(-)

-- 
1.8.3.1

