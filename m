Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E21D5543
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgEOP5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgEOP5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:57:00 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FAEC05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:57:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u188so3224113wmu.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=krFaMC2lrT1K+Syr+4jZzZaXrSNEEbWrNktPCbVpWWo=;
        b=n+0DB1yDdrPo3rONQX55pP3UNCh19cfqvwxzJbGBzQBQG4oSwLqaKdYgFVhrJS0ojP
         nK1Ls+rQumWp1kuyW9ghf3tPuMvN5sVKeZryhy5ksdnf6e1DsoUm863fY9yYk7TNZfBm
         tbwwdTsazS4dOvLQQ/oMBOB+6rF3mFkRn7w8m1pD+kuN+QegIsc4J2MsBMFbj09QyAzV
         MZ0jcChuPjMm5+5nKSWN233VzdEY36sl9mgqAEjUeoyjr7EL1nAk88DWwI1gqgDICwNo
         c7yvxiREo4o0ZlZ8dqzzytIkyJqWLpOdQjiSgPVnYbNlzujvbV29TMisrHuENn/Na2uy
         I4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=krFaMC2lrT1K+Syr+4jZzZaXrSNEEbWrNktPCbVpWWo=;
        b=A88QKN9eQ5ww6xu8chzl7Fws4ejL8HXcNyOKP6hcpKWSRA8lDOuc+jAwIQR/N8eTGA
         KogSktXoFOjO5ZiQoYtcNyC7CBXB51cZK8BCwBJPICXX7/nvU5UCG1V/W4WTWvZhmksk
         2iTheolyErAsJPIUDum+9bh8rhoM/NXgkFNNFDHGUCmHn/a+DCM4fJbY0z6Osm/ul7+P
         lO5RldwCgd0aZyrm8hPX7q4XFFyEbIbpDAoapgi0vEjIoJXd1D7RUvqi1h/thlQR1jcd
         yeWWjXopH2BzL3e2uUYpAAbbvEiPBTzW+21iH07+7VVaT5yDrjU4DLvYs407zjWwVzRz
         Myfw==
X-Gm-Message-State: AOAM531CHH33jV4K+RagL0rjT2LHSpug1dspwTkpbvJb6PNk6G4eQqCL
        913pzlXk/iAw524OR++m2qsuKJblG1Ez0A==
X-Google-Smtp-Source: ABdhPJzo3onjocej9ABk9/r+VRRJsPU2Cpyk/e6mUFDGMEYA0ncCB8AXxGth8wlFlL1R3sLC2BicBA==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr4610992wmk.168.1589558218375;
        Fri, 15 May 2020 08:56:58 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id w15sm4006033wmi.35.2020.05.15.08.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:56:57 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        mptcp@lists.01.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] selftests:mptcp:pm: rm the right tmp file
Date:   Fri, 15 May 2020 17:54:41 +0200
Message-Id: <20200515155442.1910397-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"$err" is a variable pointing to a temp file. "$out" is not: only used
as a local variable in "check()" and representing the output of a
command line.

Fixes: eedbc685321b (selftests: add PM netlink functional tests)
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 9172746b6cf0..15f4f46ca3a9 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -30,7 +30,7 @@ ret=0
 
 cleanup()
 {
-	rm -f $out
+	rm -f $err
 	ip netns del $ns1
 }
 
-- 
2.25.1

