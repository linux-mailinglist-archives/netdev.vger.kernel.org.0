Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E84226DB0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389180AbgGTR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389174AbgGTR4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:56:09 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090FC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:09 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a21so18981197ejj.10
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWmV/mhyyAlU4ZM567YwiLXb+4Qa3RMXQSnmE99syA8=;
        b=Rrf31IAKiBvIPtSGyZPbyFUsoD+d3YtyHGY89tmGLoT3QRoKQb0F4Gh/mInCfCmejE
         stdeh3d49353J7l13Nyk2Tqt87Kd317teDQFBUKVdojztwzbrsBBLcF8+DyVhimJlxjU
         bt6zzjGpDG5+fjQ8Xq/P4DX2tN+p9IkSCUYdGdr2E+rIKgOSx+Iz4HZYxKIqbwThnaYU
         fsE7lz4vipVW+KO25HfV3nn4h29/2h59Jxhpk02xWXbv4ejxh7EFpFsIO68jEqOimPEE
         IVX40VS6edtbRno3lgQA24I32Jfeut3rwI7TpeHVnxmqo4d1NmQikuTj5r45VeAT+5it
         Z37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWmV/mhyyAlU4ZM567YwiLXb+4Qa3RMXQSnmE99syA8=;
        b=R1pmy7CY2XLpGa9ciqeH2tttW5eR60rjlzIq0H7qtkvQd2i8cxRJDrY1UKILlVXDZR
         6klwM2DNaMJ1m4qh1fp5J4UYo1Bxi7jTbTj7ZiMYuffXq108v4rXkX06rNk31z1RoKOf
         smV6giI7dB0VB8XhLHyrl8sDw1DSKeIjMPQQ8J+63mJ+CEuxMt+DDYE7mOtlWmTq85HO
         2Jv/7DfRQgxoAcr2aKD5zMjxUa6zaMrx0OLI2PRVnz7xNntDhy3ORB190Ys+VtSMOndQ
         HGMLfnPkOAYMLOTJnZO3IGRyZccPcIYVlkGlRGGBzj28k6qeje+liBOne3dGdkbBdQFw
         trFQ==
X-Gm-Message-State: AOAM5300lRrw3i8IqLulT0+RcKdwVMYAeUPGDZwOOOYdoHwXuKDurp/n
        WDwab91Tl/2X7JrqwcJo8UI=
X-Google-Smtp-Source: ABdhPJyw1veqA+Ew1Y31dfMboTtnLaaFHDorbGvnZ8oMdjGDPm00ObbcYTuRgfOTi0X33QQ5GXvJQQ==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr22233205eja.537.1595267768098;
        Mon, 20 Jul 2020 10:56:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id t2sm15750442eds.60.2020.07.20.10.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 10:56:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/2] testptp: add new options for perout phase and pulse width
Date:   Mon, 20 Jul 2020 20:55:59 +0300
Message-Id: <20200720175559.1234818-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720175559.1234818-1-olteanv@gmail.com>
References: <20200720175559.1234818-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the example program for PTP ancillary functionality with the
ability to configure not only the periodic output's period (frequency),
but also the phase and duty cycle (pulse width) which were newly
introduced.

The ioctl level also needs to be updated to the new PTP_PEROUT_REQUEST2,
since the original PTP_PEROUT_REQUEST doesn't support this
functionality. For an in-tree testing program, not having explicit
backwards compatibility is fine, as it should always be tested with the
current kernel headers and sources.

Tested with an oscilloscope on the felix switch PHC:

echo '2 0' > /sys/class/ptp/ptp1/pins/switch_1588_dat0
./testptp -d /dev/ptp1 -p 1000000000 -w 100000000 -H 1000 -i 0

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 41 ++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index edc1e50768c2..f7911aaeb007 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -134,6 +134,8 @@ static void usage(char *progname)
 		"            1 - external time stamp\n"
 		"            2 - periodic output\n"
 		" -p val     enable output with a period of 'val' nanoseconds\n"
+		" -H val     set output phase to 'val' nanoseconds (requires -p)\n"
+		" -w val     set output pulse width to 'val' nanoseconds (requires -p)\n"
 		" -P val     enable or disable (val=1|0) the system clock PPS\n"
 		" -s         set the ptp clock time from the system time\n"
 		" -S         set the system time from the ptp clock time\n"
@@ -178,11 +180,13 @@ int main(int argc, char *argv[])
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
+	int64_t perout_phase = -1;
+	int64_t pulsewidth = -1;
 	int64_t perout = -1;
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghi:k:lL:p:P:sSt:T:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:p:P:sSt:T:w:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -199,6 +203,9 @@ int main(int argc, char *argv[])
 		case 'g':
 			gettime = 1;
 			break;
+		case 'H':
+			perout_phase = atoll(optarg);
+			break;
 		case 'i':
 			index = atoi(optarg);
 			break;
@@ -235,6 +242,9 @@ int main(int argc, char *argv[])
 			settime = 3;
 			seconds = atoi(optarg);
 			break;
+		case 'w':
+			pulsewidth = atoi(optarg);
+			break;
 		case 'z':
 			flagtest = 1;
 			break;
@@ -393,6 +403,16 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (pulsewidth >= 0 && perout < 0) {
+		puts("-w can only be specified together with -p");
+		return -1;
+	}
+
+	if (perout_phase >= 0 && perout < 0) {
+		puts("-H can only be specified together with -p");
+		return -1;
+	}
+
 	if (perout >= 0) {
 		if (clock_gettime(clkid, &ts)) {
 			perror("clock_gettime");
@@ -400,11 +420,24 @@ int main(int argc, char *argv[])
 		}
 		memset(&perout_request, 0, sizeof(perout_request));
 		perout_request.index = index;
-		perout_request.start.sec = ts.tv_sec + 2;
-		perout_request.start.nsec = 0;
 		perout_request.period.sec = perout / NSEC_PER_SEC;
 		perout_request.period.nsec = perout % NSEC_PER_SEC;
-		if (ioctl(fd, PTP_PEROUT_REQUEST, &perout_request)) {
+		perout_request.flags = 0;
+		if (pulsewidth >= 0) {
+			perout_request.flags |= PTP_PEROUT_DUTY_CYCLE;
+			perout_request.on.sec = pulsewidth / NSEC_PER_SEC;
+			perout_request.on.nsec = pulsewidth % NSEC_PER_SEC;
+		}
+		if (perout_phase >= 0) {
+			perout_request.flags |= PTP_PEROUT_PHASE;
+			perout_request.phase.sec = perout_phase / NSEC_PER_SEC;
+			perout_request.phase.nsec = perout_phase % NSEC_PER_SEC;
+		} else {
+			perout_request.start.sec = ts.tv_sec + 2;
+			perout_request.start.nsec = 0;
+		}
+
+		if (ioctl(fd, PTP_PEROUT_REQUEST2, &perout_request)) {
 			perror("PTP_PEROUT_REQUEST");
 		} else {
 			puts("periodic output request okay");
-- 
2.25.1

