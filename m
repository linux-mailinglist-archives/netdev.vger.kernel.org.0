Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182CF462BB0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhK3EdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbhK3EdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:33:22 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E921C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:04 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id m15so18386381pgu.11
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dBl5CjzlUqkydAB+e28yQUZ+shpz4C0a/NspY83mplI=;
        b=GUsVDaGk6AKH2O5E9NR5tjzOtY4+dCcdsv3FzKBEY3Juru8g3WgUOxCFl1iroT+oE9
         WLFvY6WXHlSZkPL3aK2S51aAvrJFJDfR+M/xnA8JVzlVxC0Ibj/3gDiX0eJO1R7OoiCD
         8sgBXUalUjCCvAs6la0cX7a5Pjk2Zm93LQJvLpl+8QCqJ3/a/SRoUuMwHWpUSQU4lrt9
         w/KzRM9fgFxOG0kcgwsyXt+stNM+mZU/SNRZ43DSlLTAqyFHhbYnJVgohCMIXqpnOYDX
         fus9RrYOWv7/3l7B245EWM+OUEaurseGtJz4Cl3gfkW/yiLQr8egaVaE54r5Dk5YOGLt
         ZEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dBl5CjzlUqkydAB+e28yQUZ+shpz4C0a/NspY83mplI=;
        b=aBLm7NCjUxSHB4U7XxSaUWJ1R81UOWzIEp2WZ6Oa9zmJYt4PUvrpsF+1tXc4JaGDKN
         PMtGLm2/H9btcwa+OQsIfIs3uikCdWF2OBllSMHkWGu2TdU7+2RJ8OWnHnnyF4CraZmg
         MHEiBTuQ92egftiDmQOMeOaKqNGhLH4wQDOFDeTu4GPUk+yU2bRnRdB9TMqT06RyJbIQ
         mMNIjP7Ct58MEgsgurVEVbAeSHpTcZlbk8vmcA5VL8HFgn2qFGXg6FV/kVLCeJO5TGk6
         Z1t1Iw2zht2zk6W8iyq4aU8yn+X+Dmeb3TqG1Mxtsg38kH66xs9YBi+PRVLS1xEHZClB
         sUTA==
X-Gm-Message-State: AOAM5308PPBupqJEHqrozNx0O1NEO9OxLFETNQSx+VibygWFS7n1g5Er
        wK+R3FMD1/U0BHA9qGNKa0ssgl1usNk=
X-Google-Smtp-Source: ABdhPJyOk9TaLxVqC2c4bkOgADW9Dv/7wG09Lj6LNHf+Zk6HRN8hMwpyirWadk+cvus38t+mTzQvxw==
X-Received: by 2002:a05:6a00:230d:b0:49f:b8ad:ae23 with SMTP id h13-20020a056a00230d00b0049fb8adae23mr44281510pfh.80.1638246603540;
        Mon, 29 Nov 2021 20:30:03 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q9sm11697014pfj.9.2021.11.29.20.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:30:03 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 iproute2-next] bond: add arp_missed_max option
Date:   Tue, 30 Nov 2021 12:29:48 +0800
Message-Id: <20211130042948.1629239-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130042948.1629239-1-liuhangbin@gmail.com>
References: <20211130042948.1629239-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bond arp_missed_max is the maximum number of arp_interval monitor cycle
for missed ARP replies. If this number is exceeded, link is reported as
down.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: use u8 for missed_max
v3: rename the option name to arp_missed_max
v4: no update, only kernel patch changed
---
 ip/iplink_bond.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 59c9e36d..2bfdf82f 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -153,6 +153,7 @@ static void print_explain(FILE *f)
 		"                [ ad_user_port_key PORTKEY ]\n"
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
 		"                [ ad_actor_system LLADDR ]\n"
+		"                [ arp_missed_max MISSED_MAX ]\n"
 		"\n"
 		"BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb\n"
 		"ARP_VALIDATE := none|active|backup|all|filter|filter_active|filter_backup\n"
@@ -181,6 +182,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
 	__u32 packets_per_slave;
+	__u8 missed_max;
 	unsigned int ifindex;
 
 	while (argc > 0) {
@@ -258,6 +260,12 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid arp_all_targets", *argv);
 			arp_all_targets = get_index(arp_all_targets_tbl, *argv);
 			addattr32(n, 1024, IFLA_BOND_ARP_ALL_TARGETS, arp_all_targets);
+		} else if (strcmp(*argv, "arp_missed_max") == 0) {
+			NEXT_ARG();
+			if (get_u8(&missed_max, *argv, 0))
+				invarg("invalid arp_missed_max", *argv);
+
+			addattr8(n, 1024, IFLA_BOND_MISSED_MAX, missed_max);
 		} else if (matches(*argv, "primary") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
@@ -453,6 +461,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "arp_interval %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_ARP_INTERVAL]));
 
+	if (tb[IFLA_BOND_MISSED_MAX])
+		print_uint(PRINT_ANY,
+			   "arp_missed_max",
+			   "arp_missed_max %u ",
+			   rta_getattr_u8(tb[IFLA_BOND_MISSED_MAX]));
+
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
 		int i;
-- 
2.31.1

