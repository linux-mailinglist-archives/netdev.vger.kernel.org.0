Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303826938CF
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBLQli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 11:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBLQlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 11:41:37 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621A4BBBF
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 08:41:35 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h24so11444140qta.12
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 08:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uOyylaqP+0bBKhU79VTzl6uiSaOXlT8mB8uBbWW30hY=;
        b=WqyNs0lNf7R0GHObDxvyz88Tlhj/xXafaQOfTOIpoP06JYWHRIoGOfz9OAYA4hw4zO
         SicyQ6xe4qeHw18VzJIphPN80DHnL3M8EYLP3NFRAganljmCz9afYFvHP6+kzXvmjdcn
         BKy3v5TYeBAg+BcR056OR/5MLmHuTPAiy5halt7oZBGeRwHbAYp8zEJRlAsh2cfyy7hA
         SxNmgzUYdxNLWtDsVmXaSvg5E04cNIRz3Uq/TU8fJlKvpRSz0M3nc8bdDBUzBFDL5zIb
         ow+kpJJjbGnF+hoIZD2xvl23oEXjDag0Pu15lPXIJjWpw6BXulW9OQTFafVxvUUitcvD
         nH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOyylaqP+0bBKhU79VTzl6uiSaOXlT8mB8uBbWW30hY=;
        b=EU0RT44/SIffpR59N02SeSXJUGCPkE+9/c+8qRId37nNa+3kzG4i51a7S3CGQXLzdl
         n0bAdExwsdrPwg804cRQIWL9AMHkr6IWEdAghpub2Y0+bMHZLl+fqLCDOxGZkp5Gz3QQ
         Zs8WPaN4kPaeNvVWj1mR2uJzk+jbKpvjkwpeVqKZk0rQJckHAPZYyLTo+IjxN26QIu8p
         wCNDGDWEQ6nMF3RTB+0O2HlmMLHUnkJnmV9zcrhszK9CK1ZYJpfBkH7yHCOTkwFY8MJL
         2e62jJTqz7s8dC4+Et7RnaMJSkZgh8k+NtkL8dyHoZrtOilTOKmThGyRke3OSBAU4PSp
         cvAA==
X-Gm-Message-State: AO0yUKUIhVo1Eeys20yBKdJHL/LrLbMfVZSjQq/RyHHot1RMdyLJOv8B
        0b20gj7s4yn/n0dSI16YrRYl4+UVeyyGjg==
X-Google-Smtp-Source: AK7set8llZDphQuLJJ5pwnyCDnsSoolBOcNUeMNqTMSBi19mlxFRrQs+2d18R+AZQHL+dw1FpMCltw==
X-Received: by 2002:ac8:4e46:0:b0:3ae:189c:7455 with SMTP id e6-20020ac84e46000000b003ae189c7455mr37618517qtw.47.1676220094303;
        Sun, 12 Feb 2023 08:41:34 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o73-20020a37414c000000b0072b5242bd0bsm8000533qka.77.2023.02.12.08.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 08:41:33 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCHv2 iproute2-next] tc: m_ct: add support for helper
Date:   Sun, 12 Feb 2023 11:41:32 -0500
Message-Id: <d66f4a45b580f2b0d0b6f549be018ac31b260525.1676220092.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the setup and dump for helper in tc ct action
in userspace, and the support in kernel was added in:

  https://lore.kernel.org/netdev/cover.1667766782.git.lucien.xin@gmail.com/

here is an example for usage:

  # ip link add dummy0 type dummy
  # tc qdisc add dev dummy0 ingress

  # tc filter add dev dummy0 ingress proto ip flower ip_proto \
    tcp dst_port 21 ct_state -trk action ct helper ipv4-tcp-ftp

  # tc filter show dev dummy0 ingress
    filter protocol ip pref 49152 flower chain 0 handle 0x1
      eth_type ipv4
      ip_proto tcp
      dst_port 21
      ct_state -trk
      not_in_hw
        action order 1: ct zone 0 helper ipv4-tcp-ftp pipe
        index 1 ref 1 bind

v1->v2:
  - add dst_port 21 in the example tc flower rule in changelog
    as Marcele noticed.
  - use snprintf to avoid possible string overflows as Stephen
    suggested in ct_print_helper().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 tc/m_ct.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tc/m_ct.c b/tc/m_ct.c
index 54d64867..3e2491b3 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include "utils.h"
 #include "tc_util.h"
+#include "rt_names.h"
 #include <linux/tc_act/tc_ct.h>
 
 static void
@@ -20,10 +21,11 @@ usage(void)
 {
 	fprintf(stderr,
 		"Usage: ct clear\n"
-		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
+		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC] [helper HELPER]\n"
 		"	ct [nat] [zone ZONE]\n"
 		"Where: ZONE is the conntrack zone table number\n"
 		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
+		"	HELPER is family-proto-name such as ipv4-tcp-ftp\n"
 		"\n");
 	exit(-1);
 }
@@ -156,6 +158,30 @@ static int ct_parse_mark(char *str, struct nlmsghdr *n)
 	return ct_parse_u32(str, TCA_CT_MARK, TCA_CT_MARK_MASK, n);
 }
 
+static int ct_parse_helper(char *str, struct nlmsghdr *n)
+{
+	char f[32], p[32], name[32];
+	__u8 family, proto;
+
+	if (strlen(str) >= 32 ||
+	    sscanf(str, "%[^-]-%[^-]-%[^-]", f, p, name) != 3)
+		return -1;
+	if (!strcmp(f, "ipv4"))
+		family = AF_INET;
+	else if (!strcmp(f, "ipv6"))
+		family = AF_INET6;
+	else
+		return -1;
+	proto = inet_proto_a2n(p);
+	if (proto < 0)
+		return -1;
+
+	addattr8(n, MAX_MSG, TCA_CT_HELPER_FAMILY, family);
+	addattr8(n, MAX_MSG, TCA_CT_HELPER_PROTO, proto);
+	addattrstrz(n, MAX_MSG, TCA_CT_HELPER_NAME, name);
+	return 0;
+}
+
 static int ct_parse_labels(char *str, struct nlmsghdr *n)
 {
 #define LABELS_SIZE	16
@@ -283,6 +309,14 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 			}
 		} else if (matches(*argv, "help") == 0) {
 			usage();
+		} else if (matches(*argv, "helper") == 0) {
+			NEXT_ARG();
+
+			ret = ct_parse_helper(*argv, n);
+			if (ret) {
+				fprintf(stderr, "ct: Illegal \"helper\"\n");
+				return -1;
+			}
 		} else {
 			break;
 		}
@@ -436,6 +470,22 @@ static void ct_print_labels(struct rtattr *attr,
 	print_string(PRINT_ANY, "label", " label %s", out);
 }
 
+static void ct_print_helper(struct rtattr *family, struct rtattr *proto, struct rtattr *name)
+{
+	char helper[32], buf[32], *n;
+	int *f, *p;
+
+	if (!family || !proto || !name)
+		return;
+
+	f = RTA_DATA(family);
+	p = RTA_DATA(proto);
+	n = RTA_DATA(name);
+	snprintf(helper, sizeof(helper), "%s-%s-%s", (*f == AF_INET) ? "ipv4" : "ipv6",
+		 inet_proto_n2a(*p, buf, sizeof(buf)), n);
+	print_string(PRINT_ANY, "helper", " helper %s", helper);
+}
+
 static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 {
 	struct rtattr *tb[TCA_CT_MAX + 1];
@@ -468,6 +518,7 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_masked_u32("mark", tb[TCA_CT_MARK], tb[TCA_CT_MARK_MASK], false);
 	print_masked_u16("zone", tb[TCA_CT_ZONE], NULL, false);
 	ct_print_labels(tb[TCA_CT_LABELS], tb[TCA_CT_LABELS_MASK]);
+	ct_print_helper(tb[TCA_CT_HELPER_FAMILY], tb[TCA_CT_HELPER_PROTO], tb[TCA_CT_HELPER_NAME]);
 	ct_print_nat(ct_action, tb);
 
 	print_action_control(f, " ", p->action, "");
-- 
2.31.1

