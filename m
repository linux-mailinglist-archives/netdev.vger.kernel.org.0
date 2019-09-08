Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD63AD0A0
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfIHUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 16:41:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34870 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfIHUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 16:41:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so7866794pfw.2
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 13:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4k6lBtMvpk5x4muUJCMEb/n4xMYmGxAkfxZ8Np8rDFI=;
        b=ZwSTXW9eXG6CTAjAlD7xBR97VC+VnVxQh5uN9kKPE/eQkKbnMv4AeyTLJsYPOaYBlO
         tIcOPqi38/JDYXp9wBrJt98GwXNxvC7YA8rUAv5ONRlDlleVnjlo5uOf3QDuYKXyRSEW
         Mup6GBGpkQWxXJL09j5VLK3pk4x8EDDQ1lj1fvBLA7jI2lbcp8dkrMFV2325CG4fwY+Y
         09DuaqlOuG4I0emV5qFe1bIgV4hh4xmFQ5uKEMnz/zceM0KBvi6BcOiyMQjcw7zzVZKu
         XMfzR1JOUxwkmdpl4l6U9hvTBHPecFnXDZN4V//T4/Thf9X/6m4ZizpuFycraFvJmBSZ
         v2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4k6lBtMvpk5x4muUJCMEb/n4xMYmGxAkfxZ8Np8rDFI=;
        b=nygT7c/kUMA7wfpr/vbJ3ljHyxuVNj5/XFo5LcnwXXxosr/7W7gK6Q6eOdEGGINXIG
         e9+6WhXMixBWJTihHgWsVJfsPnz1hGrlY7PECDBHMXAApTIa40IGWQkESuV40DYbS6Ct
         jQQKkiaD8YPFJUx6DdpiQStZZvlxc9cabF5GrusYqJ+fLCB0LFt9ITZ1y3G2m2L6jTsM
         qAk3d3b1aC5vF7s8SrEgvUzuq/87Ds8s61R/5ebkJKk6YSmJXwyq1JNx8Pn4PvkdTMog
         7tjIxPBIo2rSB8ZeRcg1xK7yZg7+q6oVJK7WqjQ8mBLFUqr51F9Fg8hmsmMQuof2oRfb
         4nbA==
X-Gm-Message-State: APjAAAVyo7qO4RfPGxtiYgjWqExRDtGlJi+Da3d1Ivee6F8lFMRJ7bzs
        Sru8ShDWp3kdiBoSYAG+4DL2SQOk
X-Google-Smtp-Source: APXvYqz9GUp22eZizXvRrjp7j45lGgYaXskjQJq0wO9vfEYIc55teiK/1BGuS68TOkqH8m9FE58l/Q==
X-Received: by 2002:a65:60d2:: with SMTP id r18mr17966475pgv.71.1567975274189;
        Sun, 08 Sep 2019 13:41:14 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d10sm14246281pfh.8.2019.09.08.13.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 13:41:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com,
        syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com,
        syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Terry Lam <vtlam@google.com>
Subject: [Patch net] sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
Date:   Sun,  8 Sep 2019 13:40:51 -0700
Message-Id: <20190908204051.760-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of TCA_HHF_NON_HH_WEIGHT or TCA_HHF_QUANTUM is zero,
it would make no progress inside the loop in hhf_dequeue() thus
kernel would get stuck.

Fix this by checking this corner case in hhf_change().

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Reported-by: syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com
Reported-by: syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com
Reported-by: syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Terry Lam <vtlam@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_hhf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index cee6971c1c82..23cd1c873a2c 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -531,7 +531,7 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 		new_hhf_non_hh_weight = nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
 
 	non_hh_quantum = (u64)new_quantum * new_hhf_non_hh_weight;
-	if (non_hh_quantum > INT_MAX)
+	if (non_hh_quantum == 0 || non_hh_quantum > INT_MAX)
 		return -EINVAL;
 
 	sch_tree_lock(sch);
-- 
2.21.0

