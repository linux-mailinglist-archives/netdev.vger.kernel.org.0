Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9376015D6CE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgBNLsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:48:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:33341 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgBNLsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 06:48:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 03:48:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="228468478"
Received: from dsitkin-mobl.ccr.corp.intel.com (HELO localhost.localdomain) ([10.252.24.179])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 03:48:23 -0800
From:   Sebastien Boeuf <sebastien.boeuf@intel.com>
To:     netdev@vger.kernel.org
Cc:     sgarzare@redhat.com, stefanha@redhat.com, davem@davemloft.net,
        Sebastien Boeuf <sebastien.boeuf@intel.com>
Subject: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Date:   Fri, 14 Feb 2020 12:48:00 +0100
Message-Id: <20200214114802.23638-1-sebastien.boeuf@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves the semantics behind the way virtio-vsock server
accepts connections coming from the client. Whenever the server
receives a connection request from the client, if it is bound to the
socket but not yet listening, it will answer with a RST packet. The
point is to ensure each request from the client is quickly processed
so that the client can decide about the strategy of retrying or not.

The series includes along with the improvement patch a new test to
ensure the behavior is consistent across all hypervisors drivers.

Sebastien Boeuf (2):
  net: virtio_vsock: Enhance connection semantics
  tools: testing: vsock: Test when server is bound but not listening

 net/vmw_vsock/virtio_transport_common.c |  1 +
 tools/testing/vsock/vsock_test.c        | 77 +++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

-- 
2.20.1

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

