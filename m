Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B810AA1B9B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfH2Niq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:38:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41804 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfH2Nip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 09:38:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so3455092wrr.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 06:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuKzrjlRZLc5/qB+MEqy4sHi8/PSyHJWQg7S6Knb+1Y=;
        b=SWaeknoQTKjqw4m5P8V9AC71BBglnDyIN1QuscoywGIWgY8r1h7y38mIqVbq8elLuM
         /YH1WWW1X2xSWIPnmnmzzGZZpzmb73FAjlJAYdnCSOlleft9lB51LAhcH+ABTMyY624S
         V53xEvxOJv7UKrac1Ws3LoEFKpbZqb+2OVzn2V0POKvN4s0e4NAIHCM6Q7e4skJqj5xt
         k7XYABlxru1cpP/VVJRbY8rF1q+2AuzFzsnqXw+9gEYTRnJ013B2nj14AMTMcwelIVUZ
         zdCB7u0Lb2B7g6MWFFuJmByPEAr/X7VMWl6p6d6CcfjTPDibMFFXS6DpaImmNZAxYi/x
         r8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuKzrjlRZLc5/qB+MEqy4sHi8/PSyHJWQg7S6Knb+1Y=;
        b=D9NpW80Wu44xzleC5LQPrvowClQuUhveb/TT5SNSsG4lNzdpGWdxcAwfwWBEJDJw1O
         92atuxMwAhc/mmdFSKYBsP5VejMF147MW6gIcV8Z0AhA+7warixeImZfgLKeoIfZUwdR
         YJKKFq/OROWM1nDLYQO/VZ+ZLC7BPUqXjvjzprKKP66jtpsAXEsNjbF+5l5vL8DIewha
         JmdF2qG3nc8cB1Qe19Iyvkiav8z9ip3mZAVLLUF+nqHr2Hn7JjzwuYIfaasbXyirJ/L3
         9ish1G1KHynaJEXYN5OdR+y3j0H/pdcOhUS3oa78eA4yCybcXvJpwfpkNd+tTFzU4uWi
         o4sQ==
X-Gm-Message-State: APjAAAW74CFWBnSxIVTuQ6YzUTwjKd833e4c/MADGHR2pWJHm6bZauwd
        n1mf9pvApRCwIRuheCyrkGNCrOPIsCw=
X-Google-Smtp-Source: APXvYqzR80qM8+xrffHLNyJ362QgNNzrgEHfgPt1LfHcthpEr/lB0SmeGz9+wMNiEibOwbfEXXfPMA==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr11403318wru.339.1567085923274;
        Thu, 29 Aug 2019 06:38:43 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id w7sm3096206wrn.11.2019.08.29.06.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 06:38:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com, pengfeil@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: [patch net-next] sched: act_vlan: implement stats_update callback
Date:   Thu, 29 Aug 2019 15:38:42 +0200
Message-Id: <20190829133842.13958-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement this callback in order to get the offloaded stats added to the
kernel stats.

Reported-by: Pengfei Liu <pengfeil@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/act_vlan.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a3c9eea1ee8a..216b75709875 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -301,6 +301,19 @@ static int tcf_vlan_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
+static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u32 packets,
+				  u64 lastuse, bool hw)
+{
+	struct tcf_vlan *v = to_vlan(a);
+	struct tcf_t *tm = &v->tcf_tm;
+
+	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+	if (hw)
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+				   bytes, packets);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
 static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
 {
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
@@ -325,6 +338,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.init		=	tcf_vlan_init,
 	.cleanup	=	tcf_vlan_cleanup,
 	.walk		=	tcf_vlan_walker,
+	.stats_update	=	tcf_vlan_stats_update,
 	.get_fill_size	=	tcf_vlan_get_fill_size,
 	.lookup		=	tcf_vlan_search,
 	.size		=	sizeof(struct tcf_vlan),
-- 
2.20.1

