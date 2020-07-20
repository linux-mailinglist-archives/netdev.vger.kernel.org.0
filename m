Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B7226DAF
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbgGTR4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgGTR4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:56:08 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B35C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:08 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n22so16072222ejy.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1+ONI06sDVEop+bKiI2Kcolr1W4hbV4YPWe5i46V0fg=;
        b=mPDH27lf2v2J0AuqNOL7MuC8fjP4fUnh4ff/VloBuG10bFDKQJzinnj4k822pl2alY
         0D8FgsoBcqV1iv5I7jj5XHMDfQPG3Kax/2B1BVc/V96uDvGwJeVib9f0oYt9NBsoedoD
         tAa6Kn2/qwHzJ8dCMXAeUDztfyiM0526ZHZR3XQxaPfSB2pIYH9tzKdaBtnJkEMoMakx
         05J87P09vsoqnescvtulqFotzPB7hwjtBBKMZ1Wom+uMWGOVNLtzQcD2uBw7Ynsep9Zb
         XFxZwZbgaomA/wyXqmW3ilT4nM4/cP782TKalDNuAGdi3/ne4T4FP+j0NXuWoZQMadbB
         ksrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1+ONI06sDVEop+bKiI2Kcolr1W4hbV4YPWe5i46V0fg=;
        b=ZPESVQ3Wc/CaLcvblvUA7rxQVqAXu5vlp6UpDOewIL0Wb7fILw9f7zgVFUC6cH7bip
         eC9tuOUww2CYKJalsbsi4TxwdidyMqLeZjtOysSk+i8VWq5MEUEleaf+AKlQpdb6R0rq
         ZBnxW0T3Lr6foMXSTQgKPH70IZUM8Zbma8dgw2CVY/2WFRsRa7qZOBUS1Yd3Icv9pq0h
         lNRRWhyxwxLMAB18vtthITZbnWVAT0LwEh4CXTvFEX2L0cH+CpoCfhgFJ3BCanVQv/S/
         CVrGlihxmwQICg50QaWFtg6S9tHhwWv0hBdyfOOLFzXUbVW6W8Q6wUSf5sShVYE2IZVz
         5lVQ==
X-Gm-Message-State: AOAM5328z+XryiJ8Ikq8TbVsCqKEiioMHpN10KVWHuQNE3s0hb8PNX26
        +Egj8hnICVo3qYZTypNdPHk=
X-Google-Smtp-Source: ABdhPJxGMQmm8LBzErl7TlDF56uu1+fqHrumH6Gwv+mHIMiGSTGb2L8GPRpHn1BUvueUqzFyTY73BA==
X-Received: by 2002:a17:906:1151:: with SMTP id i17mr22640765eja.535.1595267767046;
        Mon, 20 Jul 2020 10:56:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id t2sm15750442eds.60.2020.07.20.10.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 10:56:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/2] testptp: promote 'perout' variable to int64_t
Date:   Mon, 20 Jul 2020 20:55:58 +0300
Message-Id: <20200720175559.1234818-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720175559.1234818-1-olteanv@gmail.com>
References: <20200720175559.1234818-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 'perout' holds the nanosecond value of the signal's period, it
should be a 64-bit value. Current assumption is that it cannot be larger
than 1 second.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index da7a9dda9490..edc1e50768c2 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -35,6 +35,8 @@
 #define CLOCK_INVALID -1
 #endif
 
+#define NSEC_PER_SEC 1000000000LL
+
 /* clock_adjtime is not available in GLIBC < 2.14 */
 #if !__GLIBC_PREREQ(2, 14)
 #include <sys/syscall.h>
@@ -169,7 +171,6 @@ int main(int argc, char *argv[])
 	int list_pins = 0;
 	int pct_offset = 0;
 	int n_samples = 0;
-	int perout = -1;
 	int pin_index = -1, pin_func;
 	int pps = -1;
 	int seconds = 0;
@@ -177,6 +178,7 @@ int main(int argc, char *argv[])
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
+	int64_t perout = -1;
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
@@ -215,7 +217,7 @@ int main(int argc, char *argv[])
 			}
 			break;
 		case 'p':
-			perout = atoi(optarg);
+			perout = atoll(optarg);
 			break;
 		case 'P':
 			pps = atoi(optarg);
@@ -400,8 +402,8 @@ int main(int argc, char *argv[])
 		perout_request.index = index;
 		perout_request.start.sec = ts.tv_sec + 2;
 		perout_request.start.nsec = 0;
-		perout_request.period.sec = 0;
-		perout_request.period.nsec = perout;
+		perout_request.period.sec = perout / NSEC_PER_SEC;
+		perout_request.period.nsec = perout % NSEC_PER_SEC;
 		if (ioctl(fd, PTP_PEROUT_REQUEST, &perout_request)) {
 			perror("PTP_PEROUT_REQUEST");
 		} else {
-- 
2.25.1

