Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A3D3603CC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhDOIAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOIAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:00:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A5EC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:00:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id h20so11615719plr.4
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tn7BRobDa2elAneXnvWf0uE/nkrZTEhR9GgCT2DORY8=;
        b=hAYwLvOJMDm8IlHgHl+ZhyQYvVQ1uY9i+SEIImrnmxvIZHQiTMWwPqzEyCcW60uDrR
         Hvs7LkC5oCim1H+/N1HsnHktN/45KBv5oEts5on/Y9aM3FH3YPpFQDewA6hj+iVAJ/u7
         wRYGpL0vhhZibQr4vYpb9fRycAD6rO79XsfWhKT9D8pxChqgscTV6pnrn9LvnsDolzXS
         EFAJOo1WB8axt74eIb7IyQotPq2YJJv6G9hDj4VPblBb5dY6UDXtqZyA/lCa4vC1/yQU
         gLyG4ON344LvLjRs1yucG+FweA9GvJ6YdZXnl1Fb0S9y4TF1fIrnjrEKUVsgX7vmTBml
         wdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tn7BRobDa2elAneXnvWf0uE/nkrZTEhR9GgCT2DORY8=;
        b=JS0d4dJBKwNp4BZvYWZ7REeKORAn+FMzETR2mlU9ReEXAU5BquEVDcmjxzQR5VrP/B
         cHSC1nss8FiCnsPo92D9DImibBfYtNkS4UiN02iGozn5J7SxRmVHYsCizlbGzwYefcFh
         njSTg1obW5ZXrGkyIuzK1Vk5AbSPTMKQNnCDJIWBOHIGgFEdCtxdh9kikI6rFTzBBCWX
         W58Ig/gzlbrdZC/U6g4LSqSh/H1eyFC0Iy/AK9hsaIu9NNMB2ikhuDYUXBMlJbfS6P8x
         e5KwvHYTBzNfTSANlIhSyVFPDfTuw33oXsSV027lrGiXgtXmfKWzmK+iIL8K90Ez0Ig8
         ezmA==
X-Gm-Message-State: AOAM5331v5nUoPoY4Rj/fGaC3OsTWpvcLyXz+etlNQy4fhV4ZsRUg4bV
        1XSMWX4o7UMMALqs1YIlL+k=
X-Google-Smtp-Source: ABdhPJwPidLDHNo0CFsT3Cl01r/bQqGFa+Jl7H9NsHlyzJVEPJOyOGIQFoOgfX5hFOfpWOxhvlwvrg==
X-Received: by 2002:a17:902:c408:b029:e7:3242:5690 with SMTP id k8-20020a170902c408b02900e732425690mr2575706plk.85.1618473609629;
        Thu, 15 Apr 2021 01:00:09 -0700 (PDT)
Received: from nuc.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id 184sm1424387pfx.156.2021.04.15.01.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:00:09 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com, Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: [PATCH v2] net: sched: tapr: remove WARN_ON() in taprio_get_start_time
Date:   Thu, 15 Apr 2021 15:59:53 +0800
Message-Id: <20210415075953.83508-2-ducheng2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415075953.83508-1-ducheng2@gmail.com>
References: <20210415063914.66144-1-ducheng2@gmail.com>
 <20210415075953.83508-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
userland-initiated syscalls.

Reported as bug on syzkaller:
https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c

Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
changelog:
v1: Discussion https://lore.kernel.org/netdev/YHfwUmFODUHx8G5W@carbon/T/
v2: fix typo


 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..33a829c1ba9b 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	 * something went really wrong. In that case, we should warn about this
 	 * inconsistent state and return error.
 	 */
-	if (WARN_ON(!cycle))
+	if (!cycle)
 		return -EFAULT;
 
 	/* Schedule the start time for the beginning of the next
-- 
2.30.2

