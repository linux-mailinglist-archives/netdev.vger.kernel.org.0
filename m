Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2371E52E0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgE1BXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE1BXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 21:23:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1DCC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:23:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 17so26068697ilj.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=tJ6UIC/aF0vZ31Q0kdiLPWPQVGsAWr9ApToCpUMojvg=;
        b=esvsGECFXuxce+Lg+Ml377e8tPUW+xOKSy1ZSTzaEdNIAbdXYDt4k8GcCMWtXUxJd6
         Bwa2RC8HKjy3P5C94O+a/LOBfbYTP9Rcm0Ww5XRUx+bceuQIv+lbS1GgPhFvW9bRZkl1
         6IOeDLFo79T+pD+W03O7DhBIpU4izTyA3VxiJlbwEtiOMdicSrqzRIlJV/TRoXp6mPM3
         0b8RAtcvVR3KU06MK8dgr7gkp8URqonJ2D9GGaTjI5GBMiLY8TM6oo//pxAVzmRuINR0
         keapS+JfTNjjns7FrQowZu/9v9GbqLrJk8igf0CQWRVHWDQI2s6GIuWKWYoPsU2YAkiI
         bqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tJ6UIC/aF0vZ31Q0kdiLPWPQVGsAWr9ApToCpUMojvg=;
        b=CiVn3/NEZG3VZnOoH+w5+B3QiB+gC2zazYLaQefMgAVXA+mRivp+lXtpP1rbPduvp1
         Ls8DBTIU9vj6YkXJkpeawV5MrsBlSEVNGn5dpopKOyrqi5Xtbd4jpcSmpB7FDoZQphgp
         e3CEq9kgqQKmIpb2tshJPZXA+4SgSmNN4vykFCSqs18176nJzkb0whQKi8+ia4kjgcUM
         f5iW6bLfKb4qSh4aX3loFybflGeMkNlL8P6C2YKDVxdunnBisGfcrXACwzjzpKMvo2nI
         XP8c3lfVogYwE4U9PdpM0VJJLqmH5w4OrzNr7aqQC6IhbVhptVDICjVKEFfSL0ycg02V
         YBGg==
X-Gm-Message-State: AOAM532vP/Ud2I99z3TdXcazcLOTzqYr0BWkIBpO5dBPcWQum/9X1G2u
        QZpDofVCjy1ThZCRiTyp2gtcdA==
X-Google-Smtp-Source: ABdhPJyZ6RZkFiel77aIrHCX4AUAyF8ZZbDUu9P4BIHWZ2kDJS1GNjcMLFIUUlfqU0ThGZBpNc8v9A==
X-Received: by 2002:a92:8f18:: with SMTP id j24mr887216ild.135.1590629021656;
        Wed, 27 May 2020 18:23:41 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id f9sm2037762iow.47.2020.05.27.18.23.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2020 18:23:40 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH v2 iproute2-next 1/1] tc: report time an action was first used
Date:   Wed, 27 May 2020 21:22:47 -0400
Message-Id: <1590628967-4158-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have print_tm() dump firstuse value along with install, lastuse
and expires.

v2: Resubmit after 'master' merged into next

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/tc_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index fd5fcb242b64..b7ff911b63ed 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -758,6 +758,10 @@ void print_tm(FILE *f, const struct tcf_t *tm)
 		print_uint(PRINT_ANY, "last_used", " used %u sec",
 			   tm->lastuse / hz);

+	if (tm->firstuse != 0)
+		print_uint(PRINT_ANY, "first_used", " firstused %u sec",
+			   tm->firstuse / hz);
+
 	if (tm->expires != 0)
 		print_uint(PRINT_ANY, "expires", " expires %u sec",
 			   tm->expires / hz);
--
2.7.4

