Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6494BAFF9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiBRDDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiBRDDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E32459A4E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153400; x=1676689400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XNSbF2ralo2Cs3IT9LvtSwn9jScnNXYztNFwwiSYUqQ=;
  b=inB//s+pk4zz0ZrkRsnAGYWj8SsuV6p+nQ7vl5QLoYAseZ0PGp8jYQFe
   GI7U498DXxN552jJUJzo2a7RwFsiFmFG3PE1TsDVZTwQZuktDFrPMf1Lv
   e0BHY169Rkh+osbdgenUbQNsbqQreTNi3POky2X9JN+weiu9RTS70vWaX
   xvgEmMnNjv/pUR7vEZbdVVsi56vrQgm9vXNGUW8OO2zuZAy074X5/0XfZ
   6pNXecuOAlK+ks7w8L7a5dLVW9r3JSXvP4AG/ed2WskPDLjktN8ghJhno
   CLm6LOYD9kKfOK3/NXKqAkHcQKkiHY0Ye3iUb9kDmPd/c04oXkIqPISgf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794595"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794595"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431904"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/7] selftests: mptcp: join: exit after usage()
Date:   Thu, 17 Feb 2022 19:03:07 -0800
Message-Id: <20220218030311.367536-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

With an error if it is an unknown option.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index bbcacaaf81ce..1a881a21e7ef 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2077,8 +2077,14 @@ all_tests()
 	fullmesh_tests
 }
 
+# [$1: error message]
 usage()
 {
+	if [ -n "${1}" ]; then
+		echo "${1}"
+		ret=1
+	fi
+
 	echo "mptcp_join usage:"
 	echo "  -f subflows_tests"
 	echo "  -e subflows_error_tests"
@@ -2099,6 +2105,8 @@ usage()
 	echo "  -C enable data checksum"
 	echo "  -i use ip mptcp"
 	echo "  -h help"
+
+	exit ${ret}
 }
 
 sin=$(mktemp)
@@ -2187,9 +2195,12 @@ while getopts 'fesltra64bpkdmchCSi' opt; do
 			;;
 		i)
 			;;
-		h | *)
+		h)
 			usage
 			;;
+		*)
+			usage "Unknown option: -${opt}"
+			;;
 	esac
 done
 
-- 
2.35.1

