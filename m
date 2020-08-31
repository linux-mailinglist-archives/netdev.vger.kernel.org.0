Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5148725769D
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgHaJhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:37:14 -0400
Received: from correo.us.es ([193.147.175.20]:40448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgHaJhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 05:37:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A7C715AEA3
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDCB2DA78A
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3587DA730; Mon, 31 Aug 2020 11:36:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE709DA78B;
        Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A3B4F42EF4E0;
        Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 7/8] selftests: netfilter: add command usage
Date:   Mon, 31 Aug 2020 11:36:47 +0200
Message-Id: <20200831093648.20765-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Avoid bad command arguments.
Based on tools/power/cpupower/bench/cpufreq-bench_plot.sh

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 44a879826236..431296c0f91c 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -86,12 +86,23 @@ omtu=9000
 lmtu=1500
 rmtu=2000
 
+usage(){
+	echo "nft_flowtable.sh [OPTIONS]"
+	echo
+	echo "MTU options"
+	echo "   -o originator"
+	echo "   -l link"
+	echo "   -r responder"
+	exit 1
+}
+
 while getopts "o:l:r:" o
 do
 	case $o in
 		o) omtu=$OPTARG;;
 		l) lmtu=$OPTARG;;
 		r) rmtu=$OPTARG;;
+		*) usage;;
 	esac
 done
 
-- 
2.20.1

