Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADA73007D7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbhAVPxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbhAVPsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:25 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7013C061352;
        Fri, 22 Jan 2021 07:47:39 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id q12so8114699lfo.12;
        Fri, 22 Jan 2021 07:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6gzMRNx7yyDeNli7agXjpdBucvRsuco8IoAFpUqw3Xw=;
        b=Cfke9vgCLDD/eJ36xIxqJem3XAQ8gaSFnbsXXDTycg9LS1OVVl15rYGtuvjrHXquKR
         5sHlYWSYU7YqzVdos/RIqNobzU/V5F8cB+E468MwF7c3q7VIOqig7wUaei5yom26bCZc
         tv64+tMoJFmTKlimLown196yl98eKfiIqG7aqdu5XGyfozZMitm8nxYAVmlC00heQijr
         5htf5pOzySgxluu03AduhYGewS5hmlMZ0WMtaXWv5bTYLAHeWHbyVUbKGl45LATMFgHF
         2UxeR/dxfVeHQrRyUbsd8jj5N4l8RIwpcQwXTL9njD0BRg4W9O+AiIVkwfdwu1pIriis
         0zXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6gzMRNx7yyDeNli7agXjpdBucvRsuco8IoAFpUqw3Xw=;
        b=K4Da2XEfHmdBis3QNATHdiG7c6z1wAC9HZkoEPLX6Kfi+QZj+rty61cKdM7IoytLAM
         V1glBZL27zBu0suRBMWj0AE1Gp3jLORdfadEUJ0+tvAFdibwlLFGOfRkg3uFHqv3zNHL
         yAGgsAyiL26FWnR+od5ap7MJgXG5+IJxsW2YaTZ1Cp/xFQkwx75BsGihDlw/aBeKC1WL
         /gPpnHL4eyL/vg2tT2I+/cZOcWf4GZq0wNWe2nQg8bFJY+t5RBwJY+J+zHiloU5EJUNl
         eFWmYzCCvC2hALwbuREJDi0Ls4Vegs6eFewr+Po8OSZ7ogPXd2I/3yWJsO+0ekHvHL8R
         RlKg==
X-Gm-Message-State: AOAM533TAvZchfGgE1cmkqQ2EPzDUL8SfL+HnZzBU4NOXtkspShBFr1L
        tRi01OtLf0wBRLhY67dAeb8=
X-Google-Smtp-Source: ABdhPJy2OQ8ke3/QFkMFbBfzUcJ3vLegqgoe9JfY9PgXw188pBrYiK6tlZdjL409PPIBh12l73Dm9Q==
X-Received: by 2002:a19:40c7:: with SMTP id n190mr2353133lfa.635.1611330458320;
        Fri, 22 Jan 2021 07:47:38 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:37 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 06/12] selftests/bpf: remove casting by introduce local variable
Date:   Fri, 22 Jan 2021 16:47:19 +0100
Message-Id: <20210122154725.22140-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Let us use a local variable in nsswitchthread(), so we can remove a
lot of casting for better readability.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index ab2ed7b85f9e..bea006ad8e17 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -382,21 +382,19 @@ static bool switch_namespace(int idx)
 
 static void *nsswitchthread(void *args)
 {
-	if (switch_namespace(((struct targs *)args)->idx)) {
-		ifdict[((struct targs *)args)->idx]->ifindex =
-		    if_nametoindex(ifdict[((struct targs *)args)->idx]->ifname);
-		if (!ifdict[((struct targs *)args)->idx]->ifindex) {
-			ksft_test_result_fail
-			    ("ERROR: [%s] interface \"%s\" does not exist\n",
-			     __func__, ifdict[((struct targs *)args)->idx]->ifname);
-			((struct targs *)args)->retptr = false;
+	struct targs *targs = args;
+
+	targs->retptr = false;
+
+	if (switch_namespace(targs->idx)) {
+		ifdict[targs->idx]->ifindex = if_nametoindex(ifdict[targs->idx]->ifname);
+		if (!ifdict[targs->idx]->ifindex) {
+			ksft_test_result_fail("ERROR: [%s] interface \"%s\" does not exist\n",
+					      __func__, ifdict[targs->idx]->ifname);
 		} else {
-			ksft_print_msg("Interface found: %s\n",
-				       ifdict[((struct targs *)args)->idx]->ifname);
-			((struct targs *)args)->retptr = true;
+			ksft_print_msg("Interface found: %s\n", ifdict[targs->idx]->ifname);
+			targs->retptr = true;
 		}
-	} else {
-		((struct targs *)args)->retptr = false;
 	}
 	pthread_exit(NULL);
 }
-- 
2.27.0

