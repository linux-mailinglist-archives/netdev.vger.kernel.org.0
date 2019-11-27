Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAA910A9E6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfK0FVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:21:10 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:44927 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0FVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:21:09 -0500
Received: by mail-pl1-f202.google.com with SMTP id h8so8690706plr.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=C/TVoo93MPM5c2I3qKzanVOFsx7+ScBM7yNe3k9aIsc=;
        b=MieML6aLpgouiJYECyVX6hV+c5LVq0OConpwjvsUo7hcAdbglhON6zkgc+whPtnXXS
         xGgjOXXE5mZ90sJWd3ythxQqftDGyTzFf0x8KWAAZe6nSxmKOv5k4/LwVdOcSuqalwq4
         pAeDQevZ9KdUQbiZbZSovK1A8UEGwGqFjGLXYqSvzoVkuTdXD7FXqFfHFiRaIaj3Dbgf
         W8u9id0F3aiNkB4kv9cm4zXzGaXMkztoD94iDRHLOZpHukk3mNGT0SMbHgZzc9yAcgc7
         MF8PfOSIt9VZ5JmAL9YKKaSDcSidr/ZdJ0aUe/h8XOkll+w364C2ZHMnBg7sEDcebuDA
         l/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=C/TVoo93MPM5c2I3qKzanVOFsx7+ScBM7yNe3k9aIsc=;
        b=AJ6MHl8/J0uxSBp6QbRntDYgMElIFGYrGb2NzNvT4sSFUzMpKRsB3zvA0JTgz7TKI5
         pjxETReeieJIWqWcgpoRpliGAIQrp6VZ0IyOq7DVbEwFjFAV3g6NrfgfGRx8whBkSOvB
         /hnzdyyvalBgbd0p0YnHUSAnu5Nm+qk/aGjZHwmJWoyvEMN9I8tF9/8YxUDmphUTLRdX
         ymOkG2vRnS4CHNGgPtfehEYVFj9LkoBCqJ4uthJq0VYZfrG9fcIUtyBjfiG1voNoE7KY
         iMZvxEqvCdu4/k2JFRlewayOVKXxUk7mwsxW5+89reKlS6Ed2uFeO1hzbdRllpT91o/Z
         9iJQ==
X-Gm-Message-State: APjAAAVCIzgSNfhVfS9RKFOFFS4+a1D7rHLDbCvi53H1RMZPFx+FB6UK
        Zs3pwzhe4DR+jU+fZ9UnvUVWGqJHxpzw
X-Google-Smtp-Source: APXvYqwiLERqNHSj9UzaziY6JNGoWRFSrXraahUVEh1rc+uRL+jT452Kqq9gXwE/cXTTRmyQs7b6avugzGYp
X-Received: by 2002:a63:4c14:: with SMTP id z20mr2729467pga.10.1574832067572;
 Tue, 26 Nov 2019 21:21:07 -0800 (PST)
Date:   Tue, 26 Nov 2019 21:20:59 -0800
Message-Id: <20191127052059.162120-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH iproute2] tc: fix warning in q_pie.c
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Warning was:
q_pie.c:202:22: error: implicit conversion from 'unsigned long' to
'double'

Fixes: 492ec9558b30 ("tc: pie: change maximum integer value of tc_pie_xstats->prob")
Cc: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tc/q_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_pie.c b/tc/q_pie.c
index 40982f96..52ba7256 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -199,7 +199,7 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 	st = RTA_DATA(xstats);
 	/*prob is returned as a fracion of maximum integer value */
 	fprintf(f, "prob %f delay %uus avg_dq_rate %u\n",
-		(double)st->prob / UINT64_MAX, st->delay,
+		(double)st->prob / (double)UINT64_MAX, st->delay,
 		st->avg_dq_rate);
 	fprintf(f, "pkts_in %u overlimit %u dropped %u maxq %u ecn_mark %u\n",
 		st->packets_in, st->overlimit, st->dropped, st->maxq,
-- 
2.24.0.432.g9d3f5f5b63-goog

