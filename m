Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F4A360289
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhDOGjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhDOGjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:39:41 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76644C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:39:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y32so16208778pga.11
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZaNczCNj/whqV92/YbB7eSVD6u1kYqbD4pRy+8DQAv4=;
        b=Fzei49EGpMXZInk1RGlpJ38fsIDagIJhHKI0NpneXhjdmsmJlY9vQm4x7VBPuPpFHI
         GdhaGlePAasowt5aZs+pbiJWlMNWmStAGxDlPhl+Wi3SRoKjNWXHuCNPg270jYowO06r
         ejToP8D0vVzSJ0C70j8A6vqIbdCFWPDzt/OHjQocpPyP3IddaQFgrpiI09s63220+oWS
         SK6MFIBAAKBFQk73gf7IRC4is6/H8NsooD1Fc5Xm4MUTIESOCgwO2519U0yjmRh721VO
         p9yebOdb7L93LccGYovA1fxHhugss+AZYV2WrfsRhB1X7KuB5xdLwuVu63x4jqguvSJK
         x0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZaNczCNj/whqV92/YbB7eSVD6u1kYqbD4pRy+8DQAv4=;
        b=IabczETi41TejsKkWOjQDu1wUwqzzwltliyw1XASOsLWA2JyZAeMcB4HVPVg10BylS
         7zpzDFY+dISfuf1O9ogvqLTlfVWkkyiuhfKT5mjPQBgTkGJ2jHAT0HIC8HgsvLtLVgWC
         rayonGFDqsFBb+s6HI09ptZT2SCoQqGXpiai99xb7CuAeLxDigwLchZC4GuNHLbqrfYQ
         A8RZ4ju8rT1GrDvgRE2BmLEl0WLT7SjcWBhj5VNCDE/j+y+prLTghKVsE6hV87b+Fmmi
         DCQs8lKqQ2/86fGG5nS7RgwnecbZES1gbSvLEPslKNhSBsznERl+lautBwUv5FeMFq40
         TlGw==
X-Gm-Message-State: AOAM532BaYhqacyxYLotceWOlqp2J9bzET7Qbl6gNuYUxtjf7KVi4VN5
        sLpbP9MNXqzZGNH+Doj6n+0=
X-Google-Smtp-Source: ABdhPJzlhrwsPyPbG9Wq4W1IL9dD4TZ9oSHBJyOjLhur8ywqOFCPsCqS8NoNhlmORXLTjbuiOhiMkg==
X-Received: by 2002:a65:5bc4:: with SMTP id o4mr2089917pgr.137.1618468759001;
        Wed, 14 Apr 2021 23:39:19 -0700 (PDT)
Received: from nuc.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id x30sm1330359pgl.39.2021.04.14.23.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 23:39:18 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: [PATCH] net: sched: tapr: remove WARN_ON() in taprio_get_start_time()
Date:   Thu, 15 Apr 2021 14:39:14 +0800
Message-Id: <20210415063914.66144-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.30.2
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
Detailed explanation:

In net/sched/sched_taprio.c:999
The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).

sched->cycle_time is accumulated within `parse_taprio_schedule()` during
`taprio_init()`, in the following 2 ways:

1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);

note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:

If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).

Reliable reproducable steps:
1. add net device team0 
2. add team_slave_0, team_slave_1
3. sendmsg(struct msghdr {
	.iov = struct nlmsghdr {
		.type = RTM_NEWQDISC,
	}
	struct tcmsg {
		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
		.nlattr[] = {
			TCA_KIND: "taprio",
			TCA_OPTIONS: {
				.nlattr = {
					TCA_TAPRIO_ATTR_PRIOMAP: ...,
					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
				}
			}
		}
	}
}

Callstack:

parse_taprio_schedule()
taprio_change()
taprio_init()
qdisc_create()
tc_modify_qdisc()
rtnetlink_rcv_msg()
...
sendmsg()

These steps are extracted from syzkaller reproducer:
https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000

 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..5f2ff0f15d5c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	 * something went really wrong. In that case, we should warn about this
 	 * inconsistent state and return error.
 	 */
-	if (WARN_ON(!cycle))
+	if (!cycle) {
 		return -EFAULT;
 
 	/* Schedule the start time for the beginning of the next
-- 
2.30.2

