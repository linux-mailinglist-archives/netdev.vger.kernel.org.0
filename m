Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1558423D3C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbhJFLuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbhJFLtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1472AC06174E;
        Wed,  6 Oct 2021 04:48:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so8692232edv.12;
        Wed, 06 Oct 2021 04:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wI5DiihVmJ+5KuYm6tCIG9ONOUB+LjscGOui43RIXpU=;
        b=EQrLtCJ0BdXOj/yGCvpA/CfMvIrr3XJf+1lcHCpDPnN2XOWaGZ8T9hjQ1PLo5ui2Sp
         TnTHHMlj+/4aSvWfzZdVAV6OHQUfzzLdYpQgUZapmEtJBmcG+/Gl6J8TmcDWLlPITwhj
         d0NgQzF3KJjXiKOnEjX65+k1V9SnsIYhLWqomg/eQa2aAlNhvGd+mMzstOVcqeePv6iC
         mT3te+oCwBuT8wJ0V+uPAs5vPJ2HTNdS7b2fYRcw9ZDP84MVVIUQlZXdUqVPhU8qHYty
         VEas/1XyOXvSghJ8AN3y2KTR+KmxgXPfcN9K095HpP8Z11dGXYegiYGPUqfsEvh5lblS
         vKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wI5DiihVmJ+5KuYm6tCIG9ONOUB+LjscGOui43RIXpU=;
        b=Sz/kcUwjlwnuINKit0RJWcmQSu85sf8mHQjGg+cFIsaquk2mTed8ZjCp9DZ0mUwceL
         4GqX/i8m6aKfsez9M3avjI5RwnMlvLYOzRgw5navPufbcSYC92kwOK0xxkOAtHNsJVga
         epR+rAe6u8S8cJgXTDE6gO1rhJ+2HpkucSP681dggFbFbJx1zsPP3Mjtp8agSrwPeCVc
         t7MWTW9FvHHhDdStsQLJBn91xcgs2IG9yb+BF3SEScA6TW3TelqsQQM+rYDQg9Hd0pud
         vPitvcOwUc9g1MgBv/x6VtItfqZ6DvHZTm0n2ZP82m7dgDWZS+oM4KyCsW5OQtSYzqjw
         sIWA==
X-Gm-Message-State: AOAM532qaZ2JNciUCVzQwJrVpiQ8s3vzb/gVIlh+KITJdGiig8XMjHcE
        NqVDxNxUvqMdM6ct2twu6NY=
X-Google-Smtp-Source: ABdhPJxC1BJosrqzAbmMcTSbLoOUX3jJzDcKGj/BxHfnSm2b9OKM/RU0u1RVFReoDP8vOHQvxkNDfQ==
X-Received: by 2002:a05:6402:1a3a:: with SMTP id be26mr33649619edb.356.1633520878648;
        Wed, 06 Oct 2021 04:47:58 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:58 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] selftests: net/fcnal: Do not capture do_run_cmd in verbose mode
Date:   Wed,  6 Oct 2021 14:47:22 +0300
Message-Id: <b989bb17303518eb149064a6aaaa1c37d2b703c4.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This way running with -v will show interspersed output from both nettest
client and server. This helps to identify the order of events.

It is also required in order to make nettest fork in the background by
itself because shell capturing does not stop if the target forks.

This also fixes SC2166 warning:
Prefer [ p ] && [ q ] as [ p -a q ] is not well defined.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index b7fda51deb3f..09cb35e16219 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -189,21 +189,19 @@ kill_procs()
 	done
 }
 
 do_run_cmd()
 {
-	local cmd="$*"
-	local out
+	local rc cmd="$*"
 
-	if [ "$VERBOSE" = "1" ]; then
+	if [[ "$VERBOSE" = "1" ]]; then
 		echo "COMMAND: ${cmd}"
-	fi
-
-	out=$($cmd 2>&1)
-	rc=$?
-	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
-		echo "$out"
+		$cmd
+		rc=$?
+	else
+		$cmd &> /dev/null
+		rc=$?
 	fi
 
 	return $rc
 }
 
-- 
2.25.1

