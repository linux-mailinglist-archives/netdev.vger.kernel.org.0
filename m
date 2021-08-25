Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4533F73D6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhHYK6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbhHYK6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:58:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB802C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fs6so2823211pjb.4
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XypFBlEFNCfy6Tcc/Jb5jCelKY7W0GzhNlzhL4l6Pa8=;
        b=hPYUpIrkOKRi4dRVe6LJbhQxkZtvBjhWfU7HiHHNjjm7hNMlFLPfUoBpOlN5mSLnNb
         YJ0Ts3lzqoOoFOFC1dXqdUfsNhzZC+tMK7Zl1H0wYe1IcSYoQ8HgZR1/ZjnBzi6RJj9J
         IBV9aZ/fyas/keVsli9LTRd0n6uuzL59oNpGP9J8RsrSRujS1GWnXAGKgq52cmK0WNdn
         caPf5seV1BXwxPE5DUuSfNa3C7cFVkxyfWL9v0YiYn8uXGymb0yVqHVHRKLAM4eBK6mL
         fHCph/kOaU6tdt/ZPOTLWZQ3b7k9Jfk14Q/flfltuFSbl9dfYdgHAVrhIkvbvKtnJvfj
         46rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XypFBlEFNCfy6Tcc/Jb5jCelKY7W0GzhNlzhL4l6Pa8=;
        b=qWWVXbD/XWTy9zORxPuorpYSQ6Um4dtnbtEJuCToMQxnRwrFYtiY/srpoBP5VxZzAl
         QgZWfaqgL8o7S13W0C4aQ0Cs8hS9mGJVlFtUQRzHSXEMI3v3KgNJjJZI4281rPC/lfMU
         M1O3y2DAx2sbYCW1HTbt5XMHNUqB14KMG9eXHuF/AHMrbvKl3TGUV1lBihQVcimE0GAR
         S9l2AVxIllRpWw2s5/KT3XN45+oclz4nRnoQoNtmc1fZRBHCDbmzyMBdAtGYW6c1LRPr
         HKM3zyDnI8InCPjcC5FEsX4gIk3ES1b5M7CayjjMXRkoEoSuNVpMo+RgYeczQWbEqksi
         qMoA==
X-Gm-Message-State: AOAM530qc/G64jvWzKlHes/Fu4BHtIWGAMwzHl3VtzWb3FDWmG2u1u63
        MlT4/Ckut0FTNRLd0Ucnj4M=
X-Google-Smtp-Source: ABdhPJzHTs3m6KpqeZ85p0QYb6/siXEt8TsjmkT1axRxa5ZTu0H5i8k7MnXKI+fYi4gP93qGGSHJrQ==
X-Received: by 2002:a17:902:b594:b0:132:479d:2108 with SMTP id a20-20020a170902b59400b00132479d2108mr19654366pls.10.1629889046184;
        Wed, 25 Aug 2021 03:57:26 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 6sm5606191pjz.8.2021.08.25.03.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 03:57:25 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, davem@davemloft.net, toke@toke.dk
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] samples: pktgen: fix to print when terminated normally
Date:   Wed, 25 Aug 2021 19:57:15 +0900
Message-Id: <20210825105717.43195-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825105717.43195-1-claudiajkang@gmail.com>
References: <20210825105717.43195-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, most pktgen samples print the execution result when the
program is terminated normally. However, sample03 doesn't work
appropriately.

This is results of samples:

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample04_many_flows.sh -n 1
    Running... ctrl^C to stop
    Device: eth0@0
    Result: OK: 19(c5+d13) usec, 1 (60byte,0frags)
    51762pps 24Mb/sec (24845760bps) errors: 0

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample03_burst_single_flow.sh -n 1
    Running... ctrl^C to stop

The reason why it doesn't print the execution result when the program is
terminated usually is that sample03 doesn't call the function which
prints the result, unlike other samples.

So, this commit solves this issue by calling the function before
termination. Also, this commit changes control_c function to
print_result to maintain consistency with other samples.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 samples/pktgen/pktgen_sample03_burst_single_flow.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index ab87de440277..8bf2fdffba16 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -85,7 +85,7 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 done

 # Run if user hits control-c
-function control_c() {
+function print_result() {
     # Print results
     for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	dev=${DEV}@${thread}
@@ -94,11 +94,13 @@ function control_c() {
     done
 }
 # trap keyboard interrupt (Ctrl-C)
-trap control_c SIGINT
+trap true SIGINT

 if [ -z "$APPEND" ]; then
     echo "Running... ctrl^C to stop" >&2
     pg_ctrl "start"
+
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
--
2.30.2

