Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323DB3B25F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389079AbfFJJn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 05:43:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59655 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387977AbfFJJn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 05:43:57 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190610094355euoutp02e82b30e75f5aa3fffdaae6fefad98898~mzRqpn9tS1954419544euoutp02E;
        Mon, 10 Jun 2019 09:43:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190610094355euoutp02e82b30e75f5aa3fffdaae6fefad98898~mzRqpn9tS1954419544euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560159835;
        bh=Y1ZXF7rmnfRbME/cb81cN8sIoD0cHKznAAQ0GsESofo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fLO9wqfaXu3TP/r4Rw2Jh08kaqn0VaTctQtZyZPWjiSb94A+uwfR79bY9XxmZL2I8
         4+/a7M63X+/kNYVNGWoBezHhcj+aolGr93ML3fEBPVFUiGn7vwnPHEJJvnbq6MjwuQ
         xsyT8Buw4Q3swRZbv2TApXUgvifdSN+SemFJ20T4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190610094354eucas1p2d8b84ee3fb2055fc6cf64a85bfb76d20~mzRp0a9xd1188611886eucas1p2w;
        Mon, 10 Jun 2019 09:43:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7B.F3.04377.9562EFC5; Mon, 10
        Jun 2019 10:43:54 +0100 (BST)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190610094353eucas1p29eb71e82aa621c1e387513571a78710b~mzRo9dhJj1925319253eucas1p2V;
        Mon, 10 Jun 2019 09:43:53 +0000 (GMT)
X-AuditID: cbfec7f4-113ff70000001119-aa-5cfe26597785
Received: from eusync4.samsung.com ( [203.254.199.214]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 4B.CD.04140.9562EFC5; Mon, 10
        Jun 2019 10:43:53 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PSV00FBRN12MD10@eusync4.samsung.com>;
        Mon, 10 Jun 2019 10:43:53 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v4] extensions: libxt_owner: Add supplementary groups option
Date:   Mon, 10 Jun 2019 11:42:38 +0200
Message-id: <20190610094238.24904-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWy7djPc7pRav9iDDbvYLH4u7Od2WLO+RYW
        i229qxkt/r/WsbjcN43Z4sykhUwWl3fNYbM4tkDMYsK6UywW099cZXbg8jjdtJHFY8vKm0we
        O2fdZfd4+/sEk0ffllWMHoe+L2D1+LxJLoA9issmJTUnsyy1SN8ugSvjwZa5TAUnVCvmbr7L
        2sDYLdfFyMEhIWAi8fClWhcjJ4eQwApGiWsTErsYuYDsz4wSD47dZAVJgNR87P3MApFYxijx
        +NMzNgjnP6PE9nl7warYBAwkvl/YywySEBGYziSxpuEVI0iCWSBU4tyj9cwgtrCAj8S9pr/s
        IDaLgKpE57MGNhCbV8BGYsnmncwQ6+QlzveuY4eIC0r8mHyPBWKOvMTBK8/BzpAQWMMmsffZ
        Lqj7XCQeTVsD1SwjcXlyNwvEb9USJ89UQNR3MEpsfDGbEaLGWuLzpC3MEEP5JCZtm84MUc8r
        0dEmBFHiITFpx0UWSLjESnxZc5xtAqPkLCQnzUJy0gJGplWM4qmlxbnpqcVGeanlesWJucWl
        eel6yfm5mxiBsX363/EvOxh3/Uk6xCjAwajEw3vA/m+MEGtiWXFl7iFGCQ5mJRHeFVL/YoR4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzVjM8iBYSSE8sSc1OTS1ILYLJMnFwSjUwimyfmFe6o2lR
        8i1Ddz3+OxyrllnP2do/zUVSbNK+cLcbNy/oWddfvdVgeXrXvqKYXzInZZtZf7kZxdgeOD9t
        xcfXdz8sqFQSarywQ6yj9uzqk35O2op1Mx3Osu/d/VGNc87SjTfm3eHeP+t22Pxdt+JiNp70
        71mxosODwdxXWKGO57KecF/neyWW4oxEQy3mouJEADSeGGTpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xa7qRav9iDC7s47H4u7Od2WLO+RYW
        i229qxkt/r/WsbjcN43Z4sykhUwWl3fNYbM4tkDMYsK6UywW099cZXbg8jjdtJHFY8vKm0we
        O2fdZfd4+/sEk0ffllWMHoe+L2D1+LxJLoA9issmJTUnsyy1SN8ugSvjwZa5TAUnVCvmbr7L
        2sDYLdfFyMkhIWAi8bH3M0sXIxeHkMASRombN+9COY1MEmfXN7OBVLEJGEh8v7CXGcQWEZjO
        JPFnljCIzSwQKnFtxnSwuLCAj8S9pr/sIDaLgKpE57MGsF5eARuJJZt3MkNsk5c437uOHSIu
        KPFj8j0WiDnyEgevPGeZwMgzC0lqFpLUAkamVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIGh
        ue3Yzy07GLveBR9iFOBgVOLhPWD/N0aINbGsuDL3EKMEB7OSCO8KqX8xQrwpiZVVqUX58UWl
        OanFhxilOViUxHk7BA7GCAmkJ5akZqemFqQWwWSZODilGhgPv7u6UT+8TdL30d1dYta7Ax7m
        x0teKZJsivPcNGXTrS11zf3Tim7N8VFOvOn5XcGQYXfnAdGJYuHrqjYxr18izjlLuzuqn4fJ
        880iW62p3u8jd5dOkFTj3vLg2AQbx31SFuWL3ydaVH35EWwb3tb6IrXW5OxU3Ykp7ncDvvjN
        UrafJvv3GYMSS3FGoqEWc1FxIgDVVQ9iSQIAAA==
X-CMS-MailID: 20190610094353eucas1p29eb71e82aa621c1e387513571a78710b
CMS-TYPE: 201P
X-CMS-RootMailID: 20190610094353eucas1p29eb71e82aa621c1e387513571a78710b
References: <CGME20190610094353eucas1p29eb71e82aa621c1e387513571a78710b@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --suppl-groups option causes GIDs specified with --gid-owner to be
also checked in the supplementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---

Changes from v3:
 - removed XTOPT_INVERT from O_SUPPL_GROUPS,
   it wasn't meant to be invertable
    
Changes from v2:
 - XT_SUPPL_GROUPS -> XT_OWNER_SUPPL_GROUPS
    
Changes from v1:
 - complementary -> supplementary
 - manual (iptables-extensions)

 extensions/libxt_owner.c           | 24 +++++++++++++++++-------
 extensions/libxt_owner.man         |  4 ++++
 include/linux/netfilter/xt_owner.h |  7 ++++---
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 87e4df31..1702b478 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -56,6 +56,7 @@ enum {
 	O_PROCESS,
 	O_SESSION,
 	O_COMM,
+	O_SUPPL_GROUPS,
 };
 
 static void owner_mt_help_v0(void)
@@ -87,7 +88,8 @@ static void owner_mt_help(void)
 "owner match options:\n"
 "[!] --uid-owner userid[-userid]      Match local UID\n"
 "[!] --gid-owner groupid[-groupid]    Match local GID\n"
-"[!] --socket-exists                  Match if socket exists\n");
+"[!] --socket-exists                  Match if socket exists\n"
+"    --suppl-groups                   Also match supplementary groups set with --gid-owner\n");
 }
 
 #define s struct ipt_owner_info
@@ -131,6 +133,7 @@ static const struct xt_option_entry owner_mt_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE,
 	 .flags = XTOPT_INVERT},
+	{.name = "suppl-groups", .id = O_SUPPL_GROUPS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
@@ -275,6 +278,11 @@ static void owner_mt_parse(struct xt_option_call *cb)
 			info->invert |= XT_OWNER_SOCKET;
 		info->match |= XT_OWNER_SOCKET;
 		break;
+	case O_SUPPL_GROUPS:
+		if (!(info->match & XT_OWNER_GID))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--suppl-groups", "you need to use --gid-owner first");
+		info->match |= XT_OWNER_SUPPL_GROUPS;
+		break;
 	}
 }
 
@@ -455,9 +463,10 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
-	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
-	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
+	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET,       numeric);
+	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,          numeric);
+	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,          numeric);
+	owner_mt_print_item(info, "incl. suppl. groups", XT_OWNER_SUPPL_GROUPS, numeric);
 }
 
 static void
@@ -487,9 +496,10 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
-	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
-	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
+	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET,       true);
+	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,          true);
+	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,          true);
+	owner_mt_print_item(info, "--suppl-groups",   XT_OWNER_SUPPL_GROUPS, true);
 }
 
 static int
diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index 49b58cee..e2479865 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -15,5 +15,9 @@ given user. You may also specify a numerical UID, or an UID range.
 Matches if the packet socket's file structure is owned by the given group.
 You may also specify a numerical GID, or a GID range.
 .TP
+\fB\-\-suppl\-groups\fP
+Causes group(s) specified with \fB\-\-gid-owner\fP to be also checked in the
+supplementary groups of a process.
+.TP
 [\fB!\fP] \fB\-\-socket\-exists\fP
 Matches if the packet is associated with a socket.
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index 20817617..e7731dcc 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -4,9 +4,10 @@
 #include <linux/types.h>
 
 enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
+	XT_OWNER_UID          = 1 << 0,
+	XT_OWNER_GID          = 1 << 1,
+	XT_OWNER_SOCKET       = 1 << 2,
+	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
-- 
2.20.1

