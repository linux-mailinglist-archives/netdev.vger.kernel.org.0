Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772B1B6D4B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDXFfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:35:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726543AbgDXFfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:35:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O5ULRg021268
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7Yg2cWsib16r7vjCAxUwpxnhjocXXR69iDoBQhcLDEI=;
 b=XGs2fgfjJQSjSWOnrXNw5Y4gEHnmIXbtkpRz+618y5zw3EknZbfLilVRrDvBk016/qrh
 Iql5phsXy5f3YRk0gQHqkWFh0brmanqKvi8VuqgoFGvKod4AzNPopKM/3xVoOjcjp4+F
 W35kADjcOIDUR+4htDB+sQ2QmPcS8x375fI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jwey1k70-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:33 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 22:35:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2B1592EC31CF; Thu, 23 Apr 2020 22:35:30 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 09/10] bpftool: add bpftool-link manpage
Date:   Thu, 23 Apr 2020 22:35:04 -0700
Message-ID: <20200424053505.4111226-10-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424053505.4111226-1-andriin@fb.com>
References: <20200424053505.4111226-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpftool-link manpage with information and examples of link-related
commands.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpftool/Documentation/bpftool-link.rst    | 119 ++++++++++++++++++
 1 file changed, 119 insertions(+)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-link.rst

diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf=
/bpftool/Documentation/bpftool-link.rst
new file mode 100644
index 000000000000..2866128cd6b2
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -0,0 +1,119 @@
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+bpftool-link
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+------------------------------------------------------------------------=
-------
+tool for inspection and simple manipulation of eBPF links
+------------------------------------------------------------------------=
-------
+
+:Manual section: 8
+
+SYNOPSIS
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+	**bpftool** [*OPTIONS*] **link *COMMAND*
+
+	*OPTIONS* :=3D { { **-j** | **--json** } [{ **-p** | **--pretty** }] | =
{ **-f** | **--bpffs** } }
+
+	*COMMANDS* :=3D { **show** | **list** | **pin** | **help** }
+
+LINK COMMANDS
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+|	**bpftool** **link { show | list }** [*LINK*]
+|	**bpftool** **link pin** *LINK* *FILE*
+|	**bpftool** **link help**
+|
+|	*LINK* :=3D { **id** *LINK_ID* | **pinned** *FILE* }
+
+
+DESCRIPTION
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	**bpftool link { show | list }** [*LINK*]
+		  Show information about active links. If *LINK* is
+		  specified show information only about given link,
+		  otherwise list all links currently active on the system.
+
+		  Output will start with link ID followed by link type and
+		  zero or more named attributes, some of which depend on type
+                  of link.
+
+	**bpftool link pin** *LINK* *FILE*
+		  Pin link *LINK* as *FILE*.
+
+		  Note: *FILE* must be located in *bpffs* mount. It must not
+		  contain a dot character ('.'), which is reserved for future
+		  extensions of *bpffs*.
+
+	**bpftool link help**
+		  Print short help message.
+
+OPTIONS
+=3D=3D=3D=3D=3D=3D=3D
+	-h, --help
+		  Print short generic help message (similar to **bpftool help**).
+
+	-V, --version
+		  Print version number (similar to **bpftool version**).
+
+	-j, --json
+		  Generate JSON output. For commands that cannot produce JSON, this
+		  option has no effect.
+
+	-p, --pretty
+		  Generate human-readable JSON output. Implies **-j**.
+
+	-f, --bpffs
+		  When showing BPF links, show file names of pinned
+		  links.
+
+	-n, --nomount
+		  Do not automatically attempt to mount any virtual file system
+		  (such as tracefs or BPF virtual file system) when necessary.
+
+	-d, --debug
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf.
+
+EXAMPLES
+=3D=3D=3D=3D=3D=3D=3D=3D
+**# bpftool link show**
+
+::
+
+    10: cgroup  prog 25
+            cgroup_id 614  attach_type egress
+
+**# bpftool --json --pretty link show**
+
+::
+
+    [{
+            "type": "cgroup",
+            "prog_id": 25,
+            "cgroup_id": 614,
+            "attach_type": "egress"
+        }
+    ]
+
+|
+| **# mount -t bpf none /sys/fs/bpf/**
+| **# bpftool link pin id 10 /sys/fs/bpf/link**
+| **# ls -l /sys/fs/bpf/**
+
+::
+
+    -rw------- 1 root root 0 Apr 23 21:39 link
+
+
+SEE ALSO
+=3D=3D=3D=3D=3D=3D=3D=3D
+	**bpf**\ (2),
+	**bpf-helpers**\ (7),
+	**bpftool**\ (8),
+	**bpftool-prog\ (8),
+	**bpftool-map**\ (8),
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
--=20
2.24.1

