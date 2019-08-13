Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7D8C11D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfHMSzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:55:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726427AbfHMSzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:55:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7DIrt2L030678
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3c2Ua5+S0Z3FB1UcQlEYW5ZytGOoLBuCm5i+Qo1rcMU=;
 b=gcMPXmFKu6nK2/yiL88ZwCBfF5womhXKTahX6RgyEOi+IMJ+Bo5iXWThLF97QdBPzAji
 /sPdqzLp/FnEk1tJl/9TLa2I3FL9bKYjaVkGMA4QesWEtwfExPtX5FMOE6NUmOJ2s6Qx
 nlMO6zE9n4B8a5vPcpa/RDCifcbOQvIlO9E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uc2tg00yd-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:21 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 13 Aug 2019 11:55:20 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id AC86B861677; Tue, 13 Aug 2019 11:55:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <acme@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/2] btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux
Date:   Tue, 13 Aug 2019 11:54:42 -0700
Message-ID: <20190813185443.437829-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813185443.437829-1-andriin@fb.com>
References: <20190813185443.437829-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose kernel's BTF under the name vmlinux to be more uniform with using
kernel module names as file names in the future.

Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 Documentation/ABI/testing/sysfs-kernel-btf |  2 +-
 kernel/bpf/sysfs_btf.c                     | 30 +++++++++++-----------
 scripts/link-vmlinux.sh                    | 18 ++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-btf b/Documentation/ABI/testing/sysfs-kernel-btf
index 5390f8001f96..2c9744b2cd59 100644
--- a/Documentation/ABI/testing/sysfs-kernel-btf
+++ b/Documentation/ABI/testing/sysfs-kernel-btf
@@ -6,7 +6,7 @@ Description:
 		Contains BTF type information and related data for kernel and
 		kernel modules.
 
-What:		/sys/kernel/btf/kernel
+What:		/sys/kernel/btf/vmlinux
 Date:		Aug 2019
 KernelVersion:	5.5
 Contact:	bpf@vger.kernel.org
diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 092e63b9758b..4659349fc795 100644
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -9,30 +9,30 @@
 #include <linux/sysfs.h>
 
 /* See scripts/link-vmlinux.sh, gen_btf() func for details */
-extern char __weak _binary__btf_kernel_bin_start[];
-extern char __weak _binary__btf_kernel_bin_end[];
+extern char __weak _binary__btf_vmlinux_bin_start[];
+extern char __weak _binary__btf_vmlinux_bin_end[];
 
 static ssize_t
-btf_kernel_read(struct file *file, struct kobject *kobj,
-		struct bin_attribute *bin_attr,
-		char *buf, loff_t off, size_t len)
+btf_vmlinux_read(struct file *file, struct kobject *kobj,
+		 struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t len)
 {
-	memcpy(buf, _binary__btf_kernel_bin_start + off, len);
+	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
 	return len;
 }
 
-static struct bin_attribute bin_attr_btf_kernel __ro_after_init = {
-	.attr = { .name = "kernel", .mode = 0444, },
-	.read = btf_kernel_read,
+static struct bin_attribute bin_attr_btf_vmlinux __ro_after_init = {
+	.attr = { .name = "vmlinux", .mode = 0444, },
+	.read = btf_vmlinux_read,
 };
 
 static struct kobject *btf_kobj;
 
-static int __init btf_kernel_init(void)
+static int __init btf_vmlinux_init(void)
 {
 	int err;
 
-	if (!_binary__btf_kernel_bin_start)
+	if (!_binary__btf_vmlinux_bin_start)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
@@ -42,10 +42,10 @@ static int __init btf_kernel_init(void)
 		return err;
 	}
 
-	bin_attr_btf_kernel.size = _binary__btf_kernel_bin_end -
-				   _binary__btf_kernel_bin_start;
+	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
+				    _binary__btf_vmlinux_bin_start;
 
-	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_kernel);
+	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
 }
 
-subsys_initcall(btf_kernel_init);
+subsys_initcall(btf_vmlinux_init);
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index cb93832c6ad7..f7933c606f27 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -117,9 +117,9 @@ gen_btf()
 	# dump .BTF section into raw binary file to link with final vmlinux
 	bin_arch=$(${OBJDUMP} -f ${1} | grep architecture | \
 		cut -d, -f1 | cut -d' ' -f2)
-	${OBJCOPY} --dump-section .BTF=.btf.kernel.bin ${1} 2>/dev/null
+	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
 	${OBJCOPY} -I binary -O ${CONFIG_OUTPUT_FORMAT} -B ${bin_arch} \
-		--rename-section .data=.BTF .btf.kernel.bin ${2}
+		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
 }
 
 # Create ${2} .o file with all symbols from the ${1} object file
@@ -227,10 +227,10 @@ ${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
 info MODINFO modules.builtin.modinfo
 ${OBJCOPY} -j .modinfo -O binary vmlinux.o modules.builtin.modinfo
 
-btf_kernel_bin_o=""
+btf_vmlinux_bin_o=""
 if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
-	if gen_btf .tmp_vmlinux.btf .btf.kernel.bin.o ; then
-		btf_kernel_bin_o=.btf.kernel.bin.o
+	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
+		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
 	fi
 fi
 
@@ -265,11 +265,11 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	kallsyms_vmlinux=.tmp_vmlinux2
 
 	# step 1
-	vmlinux_link .tmp_vmlinux1 ${btf_kernel_bin_o}
+	vmlinux_link .tmp_vmlinux1 ${btf_vmlinux_bin_o}
 	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
 
 	# step 2
-	vmlinux_link .tmp_vmlinux2 .tmp_kallsyms1.o ${btf_kernel_bin_o}
+	vmlinux_link .tmp_vmlinux2 .tmp_kallsyms1.o ${btf_vmlinux_bin_o}
 	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
 
 	# step 3
@@ -280,13 +280,13 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 		kallsymso=.tmp_kallsyms3.o
 		kallsyms_vmlinux=.tmp_vmlinux3
 
-		vmlinux_link .tmp_vmlinux3 .tmp_kallsyms2.o ${btf_kernel_bin_o}
+		vmlinux_link .tmp_vmlinux3 .tmp_kallsyms2.o ${btf_vmlinux_bin_o}
 		kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
 	fi
 fi
 
 info LD vmlinux
-vmlinux_link vmlinux "${kallsymso}" "${btf_kernel_bin_o}"
+vmlinux_link vmlinux "${kallsymso}" "${btf_vmlinux_bin_o}"
 
 if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
 	info SORTEX vmlinux
-- 
2.17.1

