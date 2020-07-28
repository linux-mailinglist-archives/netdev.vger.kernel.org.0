Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27130231561
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgG1WMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgG1WMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:16 -0400
IronPort-SDR: 9IXd2/Bm9ssIt33R2GH2ZhZt6HimbMANv0pDimfItPomgV0TDL9DyBirZ5qhM5JQ4VWmFi4R10
 tvYDwclBIVnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342675"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342675"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:13 -0700
IronPort-SDR: RRpYTsSZUigz8UGdKA7rhUEBfxycoOW+rMYBWQOPKhc+6UD2/woF1+8ya8zqLu515jy97mA1gV
 60I2HwsEqoEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468881"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 03/12] mptcp: Remove outdated and incorrect comment
Date:   Tue, 28 Jul 2020 15:12:01 -0700
Message-Id: <20200728221210.92841-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_close() acquires the msk lock, so it clearly should not be held
before the function is called.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b3c3dbc89b3f..7d7e0fa17219 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1421,7 +1421,6 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how,
 	release_sock(ssk);
 }
 
-/* Called with msk lock held, releases such lock before returning */
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
-- 
2.28.0

