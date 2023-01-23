Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8272A677633
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjAWIUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjAWIT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:19:58 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EF21A947;
        Mon, 23 Jan 2023 00:19:55 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 333D31024B98;
        Mon, 23 Jan 2023 11:19:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 333D31024B98
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1674461991; bh=UYNvFu2ftjGj1CHXawVAguz9o1/cVkuIuyh3pOYpg2I=;
        h=From:To:CC:Subject:Date:From;
        b=InXeXHydVPLRaKk1T4TlO/mNi9rAChZhaC3nlv5bkKz/JFD9Rp95fXBinAyhTAOjr
         KqWHB0JvgeXY4b/lfYTPb9KCLBZFAWQcburvkjp5FynnVGx4Gvyjm+XkD44hNcjgSF
         76AFRDW10C3A/aKD3Bb8Hz+AZXuVlvFMg0ncPHQ8=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id 2F0EE316973F;
        Mon, 23 Jan 2023 11:19:51 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Joe Perches" <joe@perches.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Topic: [PATCH] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Index: AQHZLwN2IudSa+yU30iWUXYGCT8Rrg==
Date:   Mon, 23 Jan 2023 08:19:50 +0000
Message-ID: <20230123081957.1380790-1-Ilia.Gavrilov@infotecs.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174913 [Jan 23 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/23 07:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/23 00:37:00 #20794104
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The static 'seq_print_acct' function always returns 0.

Change the return value to 'void' and remove unnecessary checks.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 1ca9e41770cb ("netfilter: Remove uses of seq_<foo> return values")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
 net/netfilter/nf_conntrack_standalone.c | 26 ++++++++++---------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_con=
ntrack_standalone.c
index 0250725e38a4..bee99d4bcf36 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -275,22 +275,18 @@ static const char* l4proto_name(u16 proto)
 	return "unknown";
 }
=20
-static unsigned int
+static void
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
 {
-	struct nf_conn_acct *acct;
-	struct nf_conn_counter *counter;
+	struct nf_conn_acct *acct =3D nf_conn_acct_find(ct);
=20
-	acct =3D nf_conn_acct_find(ct);
-	if (!acct)
-		return 0;
-
-	counter =3D acct->counter;
-	seq_printf(s, "packets=3D%llu bytes=3D%llu ",
-		   (unsigned long long)atomic64_read(&counter[dir].packets),
-		   (unsigned long long)atomic64_read(&counter[dir].bytes));
+	if (acct) {
+		struct nf_conn_counter *counter =3D acct->counter;
=20
-	return 0;
+		seq_printf(s, "packets=3D%llu bytes=3D%llu ",
+			   (unsigned long long)atomic64_read(&counter[dir].packets),
+			   (unsigned long long)atomic64_read(&counter[dir].bytes));
+	}
 }
=20
 /* return 0 on success, 1 in case of error */
@@ -342,8 +338,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_has_overflowed(s))
 		goto release;
=20
-	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL);
=20
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
 		seq_puts(s, "[UNREPLIED] ");
@@ -352,8 +347,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
=20
 	ct_show_zone(s, ct, NF_CT_ZONE_DIR_REPL);
=20
-	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_REPLY);
=20
 	if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
 		seq_puts(s, "[HW_OFFLOAD] ");
--=20
2.30.2
