Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80C33DF6D2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhHCVX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:23:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhHCVX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:23:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173LGRHm025546;
        Tue, 3 Aug 2021 21:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UviFRwAs014Ax/E5mGKnODWtJt2RyfSGUqYM5YDF7i0=;
 b=fyjTmk/GbPSjH/vmVlaH6g4r71WJ4OOtBJgywwudL7v4WqlxyILMziDsHXG+j6iF0/dH
 gj7R3tOHIYOIAax+eEl1kRMDLO+6yfxba2Zyn7cgX2q/cwJOkEMRgrjO49IQueU+CVVf
 YSvYXnDwAi5/gnyFiOS5oXm2rAd32UpkeRmj3zWsIX3meahOqYVLgh262XVGCvqPtLHe
 fR/hUiKsA/ApV3verQNYkLG9KnSIfn6Tbc4oZc3qL8IVOeYVpj2zZm7+7AukN1HvpXin
 Y6GC0QTSeWBvIbheVAcSLyK9WgAvTAKhT4tj/AdkmSbT4iDE9JHBJG2mFE7LRJw7pCle cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UviFRwAs014Ax/E5mGKnODWtJt2RyfSGUqYM5YDF7i0=;
 b=W8d7hy4itC7l6a9r31IpwHvTTKfezERq7o4cvB+Z3ivDnj+A0JrOpLVp9n1yHI11YzMp
 TpGVq3HNEyRpd+8E8f9RElbGTIfZd9NHeVRFdQWGkgsIrIke54sG6XWWOni6UaqGmQsu
 1/R5eix/tS8bKe6uKxIcj9lVKmORAb4YIPPwpGdqdrGfS8/qMLX9S6Vz52pIK4Nv5UlN
 hfp/TpgYreFAHRV3EjzZvTpgG9o1ZAzZvWPSoruZ9juf+mdWjFWMmaQ9qFGVrT93MW5S
 nrBTu8mUKCuQvBG6iff5eO9tTS0KGKrJuunHGo8RBnRffayCMc7NuG9meRKkYdczTXOs pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqdc9r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173LFths170291;
        Tue, 3 Aug 2021 21:23:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3a4xb7denj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JazTR3QFAAwnFUceemen5kQmx5aht61Yn01zNJ/qJ49Q3r5Wr+MokFI+dqI90HffI36mM5xTY/Uvly/oYNaYy2GRz4YQNzcuUqFa/e++6NW6lD2dQvs7Bh4rOqNzumoKSXITeiiwT5WeDAyJwr92BmcFt0VUEa93OdzB0ioZi4oouX9q0SVNK37Ewl61ox6jYCJPVYoeG4XEF9B3IcqXmYJbOWOmzXf19BPqGATej05iB2qFPJlXXiaaaYbFSUlyGbiPUB/RBuLSJScyOmBI/uP/QMBvnW0QYEjMKvGWv4NyXcRhpbt5E1Tx0vhdsS0+8TZCjm35YBTWpG+2t5CmRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UviFRwAs014Ax/E5mGKnODWtJt2RyfSGUqYM5YDF7i0=;
 b=I7tHwgRl+c6cxcIFjDXmM0n1+cJq19Slyxyb1dmFu0AN8wqHn6oYbu71Ltk6ehu9sTf3IiwpCJpQoBDFx1zQg7x2/p8T38hd+FICzxdrtiw05/yyMtEoRDwz3n3Ng1sDxFSLxPd8i+DwF2vnem6onoCYUBrvd8Tz+vwTQBNCnP/eNl0MFix/jb/94LKS597OPh1tm7VL5b5N7R1AxUeKqh9Qbci/AuswgY1GL0zjhPmyqbNkUTjNy+6SfbeRXHnTIQQsmG1WCdGl0cj7NTTGEoNU7sCiOw7ZYgnCMlr5JTx/h/dFZDDEtyX+kacw+lS/VcjNDTKoLfOnJBhuM/ZxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UviFRwAs014Ax/E5mGKnODWtJt2RyfSGUqYM5YDF7i0=;
 b=dquViP7CzeqxX4m+o495UKLFCVf+wsfFkHmEOb3oni2+4yzI/b+eqSn1f3iSp5vpkHgy8ZuIgjU9lGn5THDkZjI6Gw9zmP474Qfh90helsY8etUx14Uz77osRTvhKk5YM+U8W7CcmOYQk8kkpkknL938jg6ZL6whoSgtRctemZA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 21:23:26 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 21:23:26 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/3] tools: ksnoop: document ksnoop tracing of entry/return with value display
Date:   Tue,  3 Aug 2021 22:23:15 +0100
Message-Id: <1628025796-29533-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37)
 To BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 21:23:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8508b8e-3388-4b6f-05d4-08d956c4ee13
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB49486C21FD4CA61B5E1131A3EFF09@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrqjoXdRYwd7cys9GseJSeNasPnJkousCflJi0dq/5aP5GfX5h23Gkl9rpCAQgqCz5bzNQfI9MVqm8F5I2hA+VCD5/3Dstj9c1R+jGymOoXvekBHIZT7VvrbR9yBJnU6sb2oLunPgMLixPEQ4xWdC0tSNJUtgKN6MCBy7rFMx1JsPGb6B1HWKyQOCgI+39yVW/wMHGD4SprwcY6LOdWIz4rZrnzP9YN3PkRykc7uwe9S2cNBlPH1I7y68B+1rOHvB+9MFm3uCw6yzz1tSiLCaEZmQgwjtSeT7aDZCYQJTfwJ0ew2GM32dk8GMN2BODr/kHVvAElXc0tSZtAK1NRKLpzFrKEsfhPL1+MV1I/sBSagO8wNvL4p8yaHWayKa9mlbDiFedrlq6K4sqXz1PdurdJ9e+sI9AbIxCacVzB3hX4mpNP9U3AG3uQBv30CrteqXlXpZm4HtW/A2eFFA+7Kmu1fpbETlN3+hq5uoVTkECDSUY+b1ESRG9S/hLm93p0+3P40FvKnt4gJlSnf9mT8lvCQs5veYHTp9UzwWnoS2Ybxr07alZTHGdgd/5q1hjMbMToJ75YmXlsqs24RtH1qZt+dSCGjNMFM4MkSoRJEB5y93kxHdsKEmcIjPL89d++h5nKA9cgG316BwP3LGXRn/tnV2MUK5Z9HXqzY5jqO4ebb65ZhqB2Z/zgw6ZwO0PbSu9hUun04bUNVNg/22kGiQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(86362001)(6486002)(8676002)(4326008)(8936002)(36756003)(6666004)(478600001)(83380400001)(956004)(5660300002)(44832011)(2616005)(7416002)(38350700002)(38100700002)(107886003)(316002)(2906002)(26005)(7696005)(52116002)(66476007)(66556008)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCFl8zUcHNEwy3v3mHKIRXLovmCKjDkIzVU/fzHzUl75Au7mwm47nxKT1co3?=
 =?us-ascii?Q?Uvf3DR4pKhNW3BqHFXAJqpPLYOlNbV/yNv9LzmwISDuSQ4snWxHXgzFGrW5i?=
 =?us-ascii?Q?b2PUtOrVm+W0EizXVf+3DmZGTFmWR94RhQlAmBRK/QjOp1dyeeYxcVg33ZTq?=
 =?us-ascii?Q?yoErJ/WDbX6L+P25Z7RYJov3p0fDJREwLJqEK+TS/BULSCQvTxL9d5q+iF/N?=
 =?us-ascii?Q?Mlqoxva4bBxbAZnrWhxa1+WP11lp+cEplrPdZU2D3kC0rKRxQHgAyfAiMuZT?=
 =?us-ascii?Q?qXcX5uXi47fJTCnC+97VXwugeOH2O9R7uKUxcqROg8w8NrWZe/rIy2bthve6?=
 =?us-ascii?Q?o62MUydUZMLFbUp3bAKYC6T66nlwzHEbDBTSToZLmF6TDGVU5CVvKO8Ebg4m?=
 =?us-ascii?Q?RhQaS7dKyFG5VTEjxOQVLeWXW5VnCRVhzZlrBIGjCNIlEV3zmDkoKfoywTFE?=
 =?us-ascii?Q?3mXrMEqQPDCqvfhiaYsSwQZcpTvY3wbSiF6WhaPpDRZdXkL/Wg3z5x4pXT6T?=
 =?us-ascii?Q?e2pR2Iabr0xj/xSUs15lGWyoPcgMsrZdAwtFfmWqpNEQgS7MUsoxNRzJDQkJ?=
 =?us-ascii?Q?3IGdsU2Tf1UvJJCpIuaJM8iTMfgX2hV6IBexcy7WOIX4VYjx30iTE09Iyano?=
 =?us-ascii?Q?IJ/sjyrYd1VIezCRRC3x3Hs6SDadtF5w2WuREDkusrye/5NwxqqSDa2QSm6v?=
 =?us-ascii?Q?9rCReGt2u8nKOrKZHT3eZT4QUT+MmMCUf8XOzpZzPeVISZ5sj/rGDhTjJl9h?=
 =?us-ascii?Q?tCP3XYMPfwAC7EFHDOH2CWQ/7cE+94ahROUwUqNVSD/fM1OJBm1qXfbdU5Wp?=
 =?us-ascii?Q?WeKc2M5CT8I84Kj4EBnah/h1oWkAeDqCg6e3VrPtnXHbtc3nr62It6i5ZW3C?=
 =?us-ascii?Q?IkKyBmYWlellCK+q79c1P9rDNunNs/UAlHhVju4YSCVej1vHDs/5NQM2z6+i?=
 =?us-ascii?Q?Ay++ooYBbcxHYcqHrYfo9/0er/k0n/97RcopbIbq9GEs66g/WGkZw4cjDnVS?=
 =?us-ascii?Q?WOxGD/MU2RsTUH8JXqtl2icctj6YBlajsl66S2mzy4ClqOU7DafU5XOLiZwH?=
 =?us-ascii?Q?VCrc58pbWEa/MyIptp0EOM0SRBKLSkjkO6+OMc1JAq6i8zjNQEd1DwIA4Cl9?=
 =?us-ascii?Q?r43ZpKWuGLetyGY/ck60Ok09CJZD2y/KrTerj4mTYPTVWN3s6V9ILdsulAWk?=
 =?us-ascii?Q?zGyklR4ASGYf3/70inIQ+SLMGazROR2VXmzmg7HIc/youMhbgpVDiT82Zm7s?=
 =?us-ascii?Q?6BUxCtwsGzkQ0xDwvuLkZQfazH5H8TrdlwGxHDLVUNXYF481Ep+TbqsPzUgT?=
 =?us-ascii?Q?TDWxyXT1Hluscmoh1wUGS3Dx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8508b8e-3388-4b6f-05d4-08d956c4ee13
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 21:23:25.9370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwwmMix+wDpxbQpDmMCybPzQMg2Ms3doZwn1lTfJvB3+OLo2++l+qQVyWcXtIZNOTYh5JZt5y9joT4QJr1uUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030134
X-Proofpoint-ORIG-GUID: 6GVIx5HrYAi7ZI5xgX6vfSINGHEczx-p
X-Proofpoint-GUID: 6GVIx5HrYAi7ZI5xgX6vfSINGHEczx-p
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ksnoop.8 describing options for tracing function entry/return
with full argument/return value display.  Include example use
cases with output to demonstrate functionality.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/ksnoop/Documentation/Makefile   |  58 ++++++++++
 tools/bpf/ksnoop/Documentation/ksnoop.rst | 173 ++++++++++++++++++++++++++++++
 tools/bpf/ksnoop/Makefile                 |  17 ++-
 3 files changed, 244 insertions(+), 4 deletions(-)
 create mode 100644 tools/bpf/ksnoop/Documentation/Makefile
 create mode 100644 tools/bpf/ksnoop/Documentation/ksnoop.rst

diff --git a/tools/bpf/ksnoop/Documentation/Makefile b/tools/bpf/ksnoop/Documentation/Makefile
new file mode 100644
index 0000000..7c2331b9
--- /dev/null
+++ b/tools/bpf/ksnoop/Documentation/Makefile
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: GPL-2.0-only
+include ../../../scripts/Makefile.include
+include ../../../scripts/utilities.mak
+
+INSTALL ?= install
+RM ?= rm -f
+RMDIR ?= rmdir --ignore-fail-on-non-empty
+
+ifeq ($(V),1)
+  Q =
+else
+  Q = @
+endif
+
+prefix ?= /usr/local
+mandir ?= $(prefix)/man
+man8dir = $(mandir)/man8
+
+MAN8_RST = ksnoop.rst
+
+_DOC_MAN8 = $(patsubst %.rst,%.8,$(MAN8_RST))
+DOC_MAN8 = $(addprefix $(OUTPUT),$(_DOC_MAN8))
+
+man: man8
+man8: $(DOC_MAN8)
+
+RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
+RST2MAN_OPTS += --verbose
+
+list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
+see_also = $(subst " ",, \
+	"\n" \
+	"SEE ALSO\n" \
+	"========\n" \
+	"\t**bpf**\ (2),\n")
+
+$(OUTPUT)%.8: %.rst
+ifndef RST2MAN_DEP
+	$(error "rst2man not found, but required to generate man pages")
+endif
+	$(QUIET_GEN)( cat $< ; printf "%b" $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
+
+clean:
+	$(call QUIET_CLEAN, Documentation)
+	$(Q)$(RM) $(DOC_MAN8)
+
+install: man
+	$(call QUIET_INSTALL, Documentation-man)
+	$(Q)$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
+	$(Q)$(INSTALL) -m 644 $(DOC_MAN8) $(DESTDIR)$(man8dir)
+
+uninstall:
+	$(call QUIET_UNINST, Documentation-man)
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man8dir)/,$(_DOC_MAN8))
+	$(Q)$(RMDIR) $(DESTDIR)$(man8dir)
+
+.PHONY: man man8 clean install uninstall
+.DEFAULT_GOAL := man
diff --git a/tools/bpf/ksnoop/Documentation/ksnoop.rst b/tools/bpf/ksnoop/Documentation/ksnoop.rst
new file mode 100644
index 0000000..31161c4
--- /dev/null
+++ b/tools/bpf/ksnoop/Documentation/ksnoop.rst
@@ -0,0 +1,173 @@
+================
+KSNOOP
+================
+-------------------------------------------------------------------------------
+tool for tracing kernel function entry/return showing arguments/return values
+-------------------------------------------------------------------------------
+
+:Manual section: 8
+
+SYNOPSIS
+========
+
+	**ksnoop** [*OPTIONS*] { *COMMAND*  *FUNC* | **help** }
+
+	*OPTIONS* := { { **-V** | **--version** } | { **-h** | **--help** }
+	| { [**-P** | **--pages**] nr_pages} | { [**-p** | **--pid**] pid} |
+        [{ **-s** | **--stack** }] | [{ **-d** | **--debug** }] }
+
+	*COMMAND* := { **trace** | **info** }
+
+        *FUNC* := { **name** | **name**\(**arg**\[,**arg\]) }
+
+DESCRIPTION
+===========
+	*ksnoop* allows for inspection of arguments and return values
+        associated with function entry/return.
+
+        **ksnoop info** *FUNC*
+                Show function description, arguments and return value types.
+        **ksnoop trace** *FUNC* [*FUNC*]
+                Trace function entry and return, showing arguments and
+                return values.  A function name can simply be specified,
+                or a function name along with named arguments, return values.
+                **return** is used to specify the return value.
+
+        *ksnoop* requires the kernel to provide BTF for itself, and if
+        tracing of module data is required, module BTF must be present also.
+        Check /sys/kernel/btf to see if BTF is present.
+
+        **ksnoop** requires *CAP_BPF* and *CAP_TRACING* capabilities.
+
+OPTIONS
+=======
+        -h, --help
+                  Show help information
+        -V, --version
+                  Show version.
+        -d, --debug
+                  Show debug output.
+        -p, --pid
+                  Filter events by pid.
+        -P, --pages
+                  Specify number of pages used per-CPU for perf event
+                  collection.  Default is 8.
+        -s, --stack
+                  Specified set of functions are traced if and only
+                  if they are encountered in the order specified.
+
+EXAMPLES
+========
+**# ksnoop info ip_send_skb** ::
+
+  int  ip_send_skb(struct net  * net, struct sk_buff  * skb);
+
+Show function description.
+
+**# ksnoop trace ip_send_skb** ::
+
+            TIME  CPU      PID FUNCTION/ARGS
+  78101668506811    1     2813 ip_send_skb(
+                                   net = *(0xffffffffb5959840)
+                                    (struct net){
+                                     .passive = (refcount_t){
+                                      .refs = (atomic_t){
+                                       .counter = (int)0x2,
+                                      },
+                                     },
+                                     .dev_base_seq = (unsigned int)0x18,
+                                     .ifindex = (int)0xf,
+                                     .list = (struct list_head){
+                                      .next = (struct list_head *)0xffff9895440dc120,
+                                      .prev = (struct list_head *)0xffffffffb595a8d0,
+                                     },
+                                   ...
+
+  79561322965250    1     2813 ip_send_skb(
+                                   return =
+                                    (int)0x0
+                               );
+
+Show entry/return for ip_send_skb() with arguments, return values.
+
+**# ksnoop trace "ip_send_skb(skb)"** ::
+
+
+           TIME  CPU      PID FUNCTION/ARGS
+  78142420834537    1     2813 ip_send_skb(
+                                   skb = *(0xffff989750797c00)
+                                    (struct sk_buff){
+                                     (union){
+                                      .sk = (struct sock *)0xffff98966ce19200,
+                                      .ip_defrag_offset = (int)0x6ce19200,
+                                     },
+                                     (union){
+                                      (struct){
+                                       ._skb_refdst = (long unsigned int)0xffff98981dde2d80,
+                                       .destructor = (void (*)(struct sk_buff *))0xffffffffb3e1beb0,
+                                      },
+                                  ...
+
+Show entry argument **skb**.
+
+**# ksnoop trace "ip_send_skb(return)"** ::
+
+           TIME  CPU      PID FUNCTION/ARGS
+  78178228354796    1     2813 ip_send_skb(
+                                   return =
+                                    (int)0x0
+                               );
+
+Show return value from ip_send_skb().
+
+**# ksnoop trace "ip_send_skb(skb->sk)"** ::
+
+            TIME  CPU      PID FUNCTION/ARGS
+  78207649138829    2     2813 ip_send_skb(
+                                   skb->sk = *(0xffff98966ce19200)
+                                    (struct sock){
+                                     .__sk_common = (struct sock_common){
+                                      (union){
+                                       .skc_addrpair = (__addrpair)0x1701a8c017d38f8d,
+                                       (struct){
+                                        .skc_daddr = (__be32)0x17d38f8d,
+                                        .skc_rcv_saddr = (__be32)0x1701a8c0,
+                                       },
+                                      },
+                                    ...
+
+Trace meber information associated with argument.  Only one level of
+membership is supported.
+
+**# ksnoop -p 2813 "ip_rcv(dev)"** ::
+
+            TIME  CPU      PID FUNCTION/ARGS
+  78254803164920    1     2813 ip_rcv(
+                                   dev = *(0xffff9895414cb000)
+                                    (struct net_device){
+                                     .name = (char[16])[
+                                      'l',
+                                      'o',
+                                     ],
+                                     .name_node = (struct netdev_name_node *)0xffff989541515ec0,
+                                     .state = (long unsigned int)0x3,
+                                   ...
+
+Trace **dev** argument of **ip_rcv()**.  Specify process id 2813 for events
+for that process only.
+
+**# ksnoop -s tcp_sendmsg __tcp_transmit_skb  ip_output** ::
+
+           TIME  CPU      PID FUNCTION/ARGS
+  71827770952903    1     4777 __tcp_transmit_skb(
+                                   sk = *(0xffff9852460a2300)
+                                    (struct sock){
+                                     .__sk_common = (struct sock_common){
+                                      (union){
+                                       .skc_addrpair = (__addrpair)0x61b2af0a35cbfe0a,
+
+Trace entry/return of tcp_sendmsg, __tcp_transmit_skb and ip_output when
+tcp_sendmsg leads to a call to __tcp_transmit_skb and that in turn
+leads to a call to ip_output; i.e. with a call graph matching the order
+specified.  The order does not have to be direct calls, i.e. function A
+can call another function that calls function B.
diff --git a/tools/bpf/ksnoop/Makefile b/tools/bpf/ksnoop/Makefile
index 0a1420e..149e4be 100644
--- a/tools/bpf/ksnoop/Makefile
+++ b/tools/bpf/ksnoop/Makefile
@@ -42,12 +42,12 @@ endif
 
 .DELETE_ON_ERROR:
 
-.PHONY: all clean ksnoop
+.PHONY: all clean ksnoop doc doc-clean doc-install
 all: ksnoop
 
-ksnoop: $(OUTPUT)/ksnoop
+ksnoop: $(OUTPUT)/ksnoop doc
 
-clean:
+clean: doc-clean
 	$(call QUIET_CLEAN, ksnoop)
 	$(Q)$(RM) -r $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT)
 	$(Q)$(RM) $(OUTPUT)*.o $(OUTPUT)*.d
@@ -55,11 +55,20 @@ clean:
 	$(Q)$(RM) $(OUTPUT)ksnoop
 	$(Q)$(RM) -r .output
 
-install: ksnoop
+install: ksnoop doc-install
 	$(call QUIET_INSTALL, ksnoop)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
 	$(Q)$(INSTALL) $(OUTPUT)/ksnoop $(DESTDIR)$(prefix)/sbin/ksnoop
 
+doc:
+	$(call descend,Documentation)
+
+doc-clean:
+	$(call descend,Documentation,clean)
+
+doc-install:
+	$(call descend,Documentation,install)
+
 $(OUTPUT)/ksnoop: $(OUTPUT)/ksnoop.o $(BPFOBJ)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
 
-- 
1.8.3.1

