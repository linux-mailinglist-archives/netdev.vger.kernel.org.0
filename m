Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E5E5D3A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJZNgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfJZNQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B72921897;
        Sat, 26 Oct 2019 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095816;
        bh=2Zr63LfHAD3BEw5wTukfWSw3Tffj2QuG/1gRpsOupMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY5Zm3IrybDhV81b8mQoRi4LNvyrBsg/2m8Pu0N5/7bSiZ3qPRNEVGxNx1a8ji6FT
         Bh6aSXANeN7+RZYsg8PpTZRGIyq9R834/WHmX02oSLKNANPlhgdRAy3Fuw65Zj5JRJ
         /cJL02CLyA6LfgQz5I1bALA0x7rPFvYCrP2SNZVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 30/99] selftests/bpf: More compatible nc options in test_lwt_ip_encap
Date:   Sat, 26 Oct 2019 09:14:51 -0400
Message-Id: <20191026131600.2507-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 106c35dda32f8b63f88cad7433f1b8bb0056958a ]

Out of the three nc implementations widely in use, at least two (BSD netcat
and nmap-ncat) do not support -l combined with -s. Modify the nc invocation
to be accepted by all of them.

Fixes: 17a90a788473 ("selftests/bpf: test that GSO works in lwt_ip_encap")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/9f177682c387f3f943bb64d849e6c6774df3c5b4.1570539863.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index acf7a74f97cd9..59ea56945e6cd 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -314,15 +314,15 @@ test_gso()
 	command -v nc >/dev/null 2>&1 || \
 		{ echo >&2 "nc is not available: skipping TSO tests"; return; }
 
-	# listen on IPv*_DST, capture TCP into $TMPFILE
+	# listen on port 9000, capture TCP into $TMPFILE
 	if [ "${PROTO}" == "IPv4" ] ; then
 		IP_DST=${IPv4_DST}
 		ip netns exec ${NS3} bash -c \
-			"nc -4 -l -s ${IPv4_DST} -p 9000 > ${TMPFILE} &"
+			"nc -4 -l -p 9000 > ${TMPFILE} &"
 	elif [ "${PROTO}" == "IPv6" ] ; then
 		IP_DST=${IPv6_DST}
 		ip netns exec ${NS3} bash -c \
-			"nc -6 -l -s ${IPv6_DST} -p 9000 > ${TMPFILE} &"
+			"nc -6 -l -p 9000 > ${TMPFILE} &"
 		RET=$?
 	else
 		echo "    test_gso: unknown PROTO: ${PROTO}"
-- 
2.20.1

