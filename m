Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC498228529
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgGUQRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:17:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58809 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGUQRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:17:15 -0400
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jxux4-0003gj-EU; Tue, 21 Jul 2020 16:17:10 +0000
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftest: txtimestamp: fix net ns entry logic
Date:   Tue, 21 Jul 2020 18:17:10 +0200
Message-Id: <20200721161710.80797-1-paolo.pisati@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
References: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to 'man 8 ip-netns', if `ip netns identify` returns an empty string,
there's no net namespace associated with current PID: fix the net ns entrance
logic.

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/net/txtimestamp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/txtimestamp.sh b/tools/testing/selftests/net/txtimestamp.sh
index eea6f5193693..31637769f59f 100755
--- a/tools/testing/selftests/net/txtimestamp.sh
+++ b/tools/testing/selftests/net/txtimestamp.sh
@@ -75,7 +75,7 @@ main() {
 	fi
 }
 
-if [[ "$(ip netns identify)" == "root" ]]; then
+if [[ -z "$(ip netns identify)" ]]; then
 	./in_netns.sh $0 $@
 else
 	main $@
-- 
2.27.0

