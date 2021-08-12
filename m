Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383463EA728
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhHLPIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbhHLPIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:08:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28C3C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f3so7687080plg.3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eI+1Gi3tygC8R88SAAyvbOaVXcrKCPR0ycNoBn4sLbc=;
        b=fFiphyJ0gcmi/5F8ixcDMYBwZrTq66J8Ln4XXtdCfm0EtWrK7YwK+JYd15Q+TsKI9S
         tEaKK6YpsN6cv0DmMWV9ekhOYGvbeF2VYfgNFqFkA4d6KB2Lw64A3zzEY/qFZqjrrSfl
         UxUsSCFAOm8gyW6UT44DA1dT9AxBMwUl7EQbONFIbNQqA5IBrcZLUs3wVUSa8PeuvamQ
         nmevyhz5b3jOoyAt/nXPKTUuXd2IPnMcrlGEOYUBH4OvNE4WHj4oGFLBzmxPiZWLAMyn
         V9s4kUBm00p3SX3qd7Gw82vd+wwBSg0HkEJYcWIZo1u1YtHDDkBvZ+q4kNpwOurPJZ6X
         h3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eI+1Gi3tygC8R88SAAyvbOaVXcrKCPR0ycNoBn4sLbc=;
        b=jvHbLyFZP2Odq4h7RSuU+fMUAdGUtvZQZSEgYjdEYZbmstK0GxKUkTxnX75ZXA0rYI
         mq0moagRn+a5lc/b1sRWy4Go60PoqLJkY5dQUpkkvb6kWxL3irBIHB1xr1TJC2rVG04Z
         vJlwpjY8osGjQFVmZl0G1oGo3pcHsVOyRSae07qigrALVpGRKcp6y5qqm97Cq9xuZqNv
         y/3tN/0xe0Yk0W41sr2InMBH96HyCZTpsp2XE1iL3txgius911PJxCbXpU86UyAxXFHe
         VEs6BAPYVh+whm2GEgsluYuWSNu9oh1AhTtOg/4I6BW6OOCoebRsj0CPIRgIKoFJa+5P
         Bs3A==
X-Gm-Message-State: AOAM532OIfvnlA7tS/Md/N21UgpOhAcw10VDXTeGD5vIFLgl+GZ/ccXL
        +CRlpaxSnJtAzzm9Glwrd9c=
X-Google-Smtp-Source: ABdhPJyBczaZB7T2ahW2c63PJ5xEojmJmLvJ7XfO89MRR619tWpd3/Z0+6Qzi06mPscJ0iXNkfyxnw==
X-Received: by 2002:a17:90a:ce88:: with SMTP id g8mr4287248pju.116.1628780906285;
        Thu, 12 Aug 2021 08:08:26 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id w130sm3914261pfd.118.2021.08.12.08.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:08:26 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, brouer@redhat.com, davem@davemloft.net,
        toke@redhat.com, toke@toke.dk
Cc:     netdev@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 1/2] samples: pktgen: pass the environment variable of normal user to sudo
Date:   Fri, 13 Aug 2021 00:08:12 +0900
Message-Id: <20210812150813.53124-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812150813.53124-1-claudiajkang@gmail.com>
References: <20210812150813.53124-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All pktgen samples can use the environment variable instead of option
parameters(eg. $DEV is able to use instead of '-i' option).

This is results of running sample as root and user:

    // running as root
    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -v -n 1
    Running... ctrl^C to stop

    // running as normal user
    $ DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -v -n 1
    [...]
    ERROR: Please specify output device

This results show the sample doesn't work properly when the sample runs
as normal user. Because the sample is restarted by the function
(root_check_run_with_sudo) to run with sudo. In this process, the
environment variable of normal user doesn't propagate to sudo.

It can be solved by using "-E"(--preserve-env) option of "sudo", which
preserve normal user's existing environment variables. So this commit
adds "-E" option in the function (root_check_run_with_sudo).

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 samples/pktgen/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index a335393157eb..933194257a24 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -123,7 +123,7 @@ function root_check_run_with_sudo() {
     if [ "$EUID" -ne 0 ]; then
 	if [ -x $0 ]; then # Directly executable use sudo
 	    info "Not root, running with sudo"
-            sudo "$0" "$@"
+            sudo -E "$0" "$@"
             exit $?
 	fi
 	err 4 "cannot perform sudo run of $0"
--
2.30.2

