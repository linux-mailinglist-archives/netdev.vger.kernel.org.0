Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8C188DF5
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCQT04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:26:56 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37637 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgCQT0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:55 -0400
Received: by mail-pf1-f179.google.com with SMTP id 3so4644885pff.4
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2reD+WzuFntenfuCZSYCGTYO1H0IaVOzbA7ZHt1jCvs=;
        b=txwINJA5/Gtj5AiUcMjOeQ47u5jLmZOBHggVlyiIC5h88UwBlHmYEHKgHA0EsTrOyP
         SqMMRBdFEX1QCv8qPG8CLGFY3SuF/ACOgVWOTeE4iXJl/MrV35360ybvoKaUXwBoX5fq
         2WPB6uu0s+tWBZ/CHq8N9cEFVHlxH29DeLYMSS3vyIotdtxSJ4rbGzLuXuEK2esnKTLx
         iSiRiGV09VviRgHEAGakc7O/Ig2Tsg3dX38xoGefkbkzysJBZk2vy1Vl7NJ3OqF5e5r1
         aOtM6EXKwYSBKG1OEvNtg4PSSUOI+NPeJJ9Jh5L9D/f4ott+SRNpIwJFHLf+57751o5f
         ZMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2reD+WzuFntenfuCZSYCGTYO1H0IaVOzbA7ZHt1jCvs=;
        b=XS+Ny+2We3Y83d8ND63NuJ6Y/3wvIcv3MV50ziIfUio46gOSD/vhByIJAeMhGN9oJY
         gT0yr7zJxT4oER9nvWY665FWaHucC8597aQ5R0XOlWoa04cKBhrLQ4IAB43kpMqx+yUg
         KHfias3sEEUdd4kIfszARxSd5bavsbrseAIOjxUyir3eQmDJam3Iw5PfYdddXwLTNZKM
         8Hqyeu+22puSnZGhEW4wUpLdu3Qj4tsdE+YvUXy9C/hVpSqx1NuBC2MWgmPOuB6mocI1
         GnPohjdRRYPHOzVy7KbZcnAd+WYKbao772e9jQLD/iWu31q7KpqdfcZPDOWkoRXrQeQ1
         HRRQ==
X-Gm-Message-State: ANhLgQ0L4+69RBS6NkpGyeLMt77Aad3T6G0e1sSq2rFMyfwqA1edEpue
        rG4dgDvyE/A3q5bL1DZXhVMIdx9U
X-Google-Smtp-Source: ADFU+vvoKOtwjB8qCx89cDd7lZIQZoFsNvJBI3Ex+7m500KXqSiyrMjcUQcQy2VbUTqSZnVhEhOpqg==
X-Received: by 2002:a62:1dd0:: with SMTP id d199mr334393pfd.9.1584473214361;
        Tue, 17 Mar 2020 12:26:54 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:54 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 1/5] selftests: txtimestamp: allow individual txtimestamp tests.
Date:   Tue, 17 Mar 2020 12:25:05 -0700
Message-Id: <20200317192509.150725-2-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

The wrapper script txtimestamp.sh executes a pre-defined list of testcases
sequentially without configuration options available.

Add an option (-r/--run) to setup the test namespace and pass remaining
arguments to txtimestamp binary. The script still runs all tests when no
argument is passed.

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 .../networking/timestamping/txtimestamp.sh    | 31 +++++++++++++++++--
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.sh b/tools/testing/selftests/networking/timestamping/txtimestamp.sh
index df0d86ca72b7..70a8cda7fd53 100755
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.sh
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.sh
@@ -43,15 +43,40 @@ run_test_tcpudpraw() {
 }
 
 run_test_all() {
+	setup
 	run_test_tcpudpraw		# setsockopt
 	run_test_tcpudpraw -C		# cmsg
 	run_test_tcpudpraw -n		# timestamp w/o data
+	echo "OK. All tests passed"
+}
+
+run_test_one() {
+	setup
+	./txtimestamp $@
+}
+
+usage() {
+	echo "Usage: $0 [ -r | --run ] <txtimestamp args> | [ -h | --help ]"
+	echo "  (no args)  Run all tests"
+	echo "  -r|--run  Run an individual test with arguments"
+	echo "  -h|--help Help"
+}
+
+main() {
+	if [[ $# -eq 0 ]]; then
+		run_test_all
+	else
+		if [[ "$1" = "-r" || "$1" == "--run" ]]; then
+			shift
+			run_test_one $@
+		else
+			usage
+		fi
+	fi
 }
 
 if [[ "$(ip netns identify)" == "root" ]]; then
 	../../net/in_netns.sh $0 $@
 else
-	setup
-	run_test_all
-	echo "OK. All tests passed"
+	main $@
 fi
-- 
2.25.1.481.gfbce0eb801-goog

