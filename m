Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A381E22B09
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 07:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfETFPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 01:15:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37004 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfETFPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 01:15:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id n27so3574116pgm.4
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 22:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HzL4EyOvvdAOPDBdCRgULRea3DqdKZIZmr9R7koarEs=;
        b=oyDWvGfmgGWsmw0cwmnaOhFC8vcu/5jd29kQxu8XGX/VXfn9IqnbYS5Y+bBWfy+4QL
         uninZohNPeSVI8yNDAobVIicjz6ee3wu02Kz+RX0rGy/RVbEEjJhf9tnrzQnDOsG/Kmh
         1myZiX0xVnG2Ve+LTDlGGpb3BFVJW0/X5wIzOIFq3iz+hX5cNNi9tYtchJg524lpRxb6
         8KJj5kwXwlbzTTCji8/4wgkB10t61Ol5U3ISyjSGr3Hifi12LrylzEFHZqbPRHBzZb+R
         VVQbel0wjKEs9qjHKVrVJzxY8L3wrLTF6UhWQsDI/UVIFe3jJ00UL5dqNnh99f0fKmLq
         ERFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HzL4EyOvvdAOPDBdCRgULRea3DqdKZIZmr9R7koarEs=;
        b=FzEJ8meO5jLqNNMstpwyWPxvYB58xhMyTcur6qPvvfdTURlhTuSoeYA6E48dnZLFj0
         gljweVkIJ8A6ooWk8d5rQSPLIL+RcdgH6gvDVoVt8M9giUrVE+F92pgZxiAdMxq3GKvq
         eCcJlOhQpngIfJbyDPj/08i5U+OHT/yIZJZOuRwv6ePNuMZdzzudRHmuAjMLFdE82Etz
         ZvNH4CR788H6DJk1msJNLAxJvF6E+nAkHbLVcxS71A6O+0uXG/ajewvvNuftJdzsZeHg
         fEGWJ2TCldCP6O2oY0IJiJ/iuXrWU/TMEsafd4VCfV/ejNhcV6jtANabkGRzZWzf46J+
         agDw==
X-Gm-Message-State: APjAAAV3CMV4PkuIK0GQ1HJujl3H2h0LZB2azJN9NWnXUXULwg+0+P8F
        bmQrP3eQoMUlSbos0Bjop4a+TswL
X-Google-Smtp-Source: APXvYqxckZIDJACs4UGeqrNKX8hKjYon3UYgVA75GlNzfRaPly29wtyu3h43f4vmzJqDkyPQUn81Qg==
X-Received: by 2002:a63:7141:: with SMTP id b1mr72665553pgn.331.1558329307395;
        Sun, 19 May 2019 22:15:07 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r9sm28349546pfc.173.2019.05.19.22.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 22:15:06 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next] ptp: Fix example program to match kernel.
Date:   Sun, 19 May 2019 22:15:05 -0700
Message-Id: <20190520051505.17412-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since commit 3a06c7ac24f9 ("posix-clocks: Remove interval timer
facility and mmap/fasync callbacks") the possibility of PHC based
posix timers has been removed.  In addition it will probably never
make sense to implement this functionality.

This patch removes the misleading example code which seems to suggest
that posix timers for PHC devices will ever be a thing.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 85 +----------------------------------
 1 file changed, 1 insertion(+), 84 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index a5d8f0ab0da0..6216375cb544 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -63,30 +63,6 @@ static clockid_t get_clockid(int fd)
 	return (((unsigned int) ~fd) << 3) | CLOCKFD;
 }
 
-static void handle_alarm(int s)
-{
-	printf("received signal %d\n", s);
-}
-
-static int install_handler(int signum, void (*handler)(int))
-{
-	struct sigaction action;
-	sigset_t mask;
-
-	/* Unblock the signal. */
-	sigemptyset(&mask);
-	sigaddset(&mask, signum);
-	sigprocmask(SIG_UNBLOCK, &mask, NULL);
-
-	/* Install the signal handler. */
-	action.sa_handler = handler;
-	action.sa_flags = 0;
-	sigemptyset(&action.sa_mask);
-	sigaction(signum, &action, NULL);
-
-	return 0;
-}
-
 static long ppb_to_scaled_ppm(int ppb)
 {
 	/*
@@ -112,8 +88,6 @@ static void usage(char *progname)
 {
 	fprintf(stderr,
 		"usage: %s [options]\n"
-		" -a val     request a one-shot alarm after 'val' seconds\n"
-		" -A val     request a periodic alarm every 'val' seconds\n"
 		" -c         query the ptp clock's capabilities\n"
 		" -d name    device to open\n"
 		" -e val     read 'val' external time stamp events\n"
@@ -148,15 +122,9 @@ int main(int argc, char *argv[])
 	struct ptp_pin_desc desc;
 	struct timespec ts;
 	struct timex tx;
-
-	static timer_t timerid;
-	struct itimerspec timeout;
-	struct sigevent sigevent;
-
 	struct ptp_clock_time *pct;
 	struct ptp_sys_offset *sysoff;
 
-
 	char *progname;
 	unsigned int i;
 	int c, cnt, fd;
@@ -170,10 +138,8 @@ int main(int argc, char *argv[])
 	int gettime = 0;
 	int index = 0;
 	int list_pins = 0;
-	int oneshot = 0;
 	int pct_offset = 0;
 	int n_samples = 0;
-	int periodic = 0;
 	int perout = -1;
 	int pin_index = -1, pin_func;
 	int pps = -1;
@@ -185,14 +151,8 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "a:A:cd:e:f:ghi:k:lL:p:P:sSt:T:v"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghi:k:lL:p:P:sSt:T:v"))) {
 		switch (c) {
-		case 'a':
-			oneshot = atoi(optarg);
-			break;
-		case 'A':
-			periodic = atoi(optarg);
-			break;
 		case 'c':
 			capabilities = 1;
 			break;
@@ -393,49 +353,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (oneshot) {
-		install_handler(SIGALRM, handle_alarm);
-		/* Create a timer. */
-		sigevent.sigev_notify = SIGEV_SIGNAL;
-		sigevent.sigev_signo = SIGALRM;
-		if (timer_create(clkid, &sigevent, &timerid)) {
-			perror("timer_create");
-			return -1;
-		}
-		/* Start the timer. */
-		memset(&timeout, 0, sizeof(timeout));
-		timeout.it_value.tv_sec = oneshot;
-		if (timer_settime(timerid, 0, &timeout, NULL)) {
-			perror("timer_settime");
-			return -1;
-		}
-		pause();
-		timer_delete(timerid);
-	}
-
-	if (periodic) {
-		install_handler(SIGALRM, handle_alarm);
-		/* Create a timer. */
-		sigevent.sigev_notify = SIGEV_SIGNAL;
-		sigevent.sigev_signo = SIGALRM;
-		if (timer_create(clkid, &sigevent, &timerid)) {
-			perror("timer_create");
-			return -1;
-		}
-		/* Start the timer. */
-		memset(&timeout, 0, sizeof(timeout));
-		timeout.it_interval.tv_sec = periodic;
-		timeout.it_value.tv_sec = periodic;
-		if (timer_settime(timerid, 0, &timeout, NULL)) {
-			perror("timer_settime");
-			return -1;
-		}
-		while (1) {
-			pause();
-		}
-		timer_delete(timerid);
-	}
-
 	if (perout >= 0) {
 		if (clock_gettime(clkid, &ts)) {
 			perror("clock_gettime");
-- 
2.11.0

