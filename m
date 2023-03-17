Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052D46BEBD9
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjCQOzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCQOzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:55:02 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6C6559C1;
        Fri, 17 Mar 2023 07:54:53 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PdRl72Zggz9xqck;
        Fri, 17 Mar 2023 22:45:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S7;
        Fri, 17 Mar 2023 15:54:29 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        brauner@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ebiederm@xmission.com,
        mcgrof@kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 5/5] doc: Add documentation for the User Mode Driver management library
Date:   Fri, 17 Mar 2023 15:52:40 +0100
Message-Id: <20230317145240.363908-6-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S7
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4Utr4kKFWrKrWrGw18AFb_yoW7AFW8pF
        Z3JrWft3WkJryavr1fJw17uryrZas7Ja15GFn3Kw1rZwn8Zrn0yr1Ut3WFqFyUGryFyrW5
        tr15Jr1UCw1DAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
        C2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
        7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
        kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
        v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
        pf9x07jIPfQUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQATBF1jj4qqgQAAsG
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Add a documentation, to explain the motivation behind the new component, to
describe the software architecture, the API and an example used for
testing.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 Documentation/driver-api/index.rst    |  1 +
 Documentation/driver-api/umd_mgmt.rst | 99 +++++++++++++++++++++++++++
 MAINTAINERS                           |  1 +
 3 files changed, 101 insertions(+)
 create mode 100644 Documentation/driver-api/umd_mgmt.rst

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index ff9aa1afdc6..ad42cd968dc 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -113,6 +113,7 @@ available subsections can be seen below.
    xillybus
    zorro
    hte/index
+   umd_mgmt
 
 .. only::  subproject and html
 
diff --git a/Documentation/driver-api/umd_mgmt.rst b/Documentation/driver-api/umd_mgmt.rst
new file mode 100644
index 00000000000..7dbb50b3643
--- /dev/null
+++ b/Documentation/driver-api/umd_mgmt.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+User Mode Driver Management Library
+===================================
+
+:Author: Roberto Sassu, Huawei Technologies Duesseldorf GmbH
+:Date:   2023-03-16
+
+Introduction
+============
+
+The idea of moving code away from the kernel and running it in user space
+is not new. For example, the User Space I/O driver model allows developers
+to implement most of the driver logic in user space, and keep only a small
+part in a kernel module, for example to handle interrupts.
+
+The User Mode Driver (UMD) is a more specialized solution, primarily used
+by bpfilter, consisting of a user space process running from code embedded
+in a kernel module, communicating only through a pipe with the kernel.
+
+The kernel makes a request, possibly originated by the user of the system,
+and sends it to the user space process. The latter handles the kernel
+request, and sends the response back to the kernel. Finally, the kernel
+eventually forwards the result to the user.
+
+This usage model is particularly interesting for security. The kernel can
+offload to user space workloads that could introduce possible threats, for
+example parsing unknown and possibly malicious data. While the kernel
+already does that, it is important to limit to the minimum the chances of
+an attacker to exploit a vulnerability in the kernel code.
+
+If a user space process becomes corrupted, it can still send malicious data
+to the kernel, but it won't be able to directly corrupt the kernel memory.
+In addition, if the communication protocol between the user space process
+and the kernel is simple enough, malicious data can be effectively
+sanitized.
+
+The purpose of this library is simply to facilitate developers to create
+UMDs and to help them customize the UMDs to their needs.
+
+
+
+Architecture
+============
+
+The architecture of the UMD library is as follows:
+
+::
+
+ +-----------+                    +---------------+
+ |    UMD    | 2. request module  |   UMD Loader  |
+ |  Manager  |------------------->| (kmod +       |
+ |           |------+             |  user binary) |
+ +-----------+      |             +---------------+
+       ^            |                    |                     kernel space
+ --------------------------------------------------------------------------
+       |            | 4. send/           v 3. fork/execve/pipe   user space
+       |            |    receive  +-------------+
+ 1. user request    +------------>| UMD Handler |
+                                  | (exec user  |
+                                  |  binary)    |
+                                  +-------------+
+
+The `UMD Manager` is the frontend interface to any user or
+kernel-originated request. It invokes the `UMD Loader` to start the
+`UMD Handler`, and communicates with the latter to satisfy the request.
+
+The `UMD Loader` is merely responsible to extract the `user binary` from
+the kernel module, copy it to a tmpfs filesystem, fork the current process,
+start the `UMD Handler`, and create a pipe for the communication between
+the `UMD Manager` and the `UMD Handler`.
+
+The `UMD Handler` reads requests from the `UMD Manager`, processes them
+internally, and sends the response to it.
+
+
+API
+===
+
+.. kernel-doc:: include/linux/usermode_driver_mgmt.h
+
+.. kernel-doc:: kernel/usermode_driver_mgmt.c
+
+
+Example
+=======
+
+An example of usage of the UMD management library can be found in
+tools/testing/selftests/umd_mgmt/sample_umd.
+
+sample_mgr.c implements the `UMD Manager`, sample_loader.c implements the
+`UMD Loader` and, finally, sample_handler.c implements the `UMD Handler`.
+
+The `UMD Manager` exposes /sys/kernel/security/sample_umd and accepts a
+number between 0-128K intended as an offset in the response buffer, at
+which the `UMD Handler` sets the byte to 1. The `UMD Manager` verifies
+that. If the byte is not set to 1, the `UMD Manager` rejects the write, so
+that the failure can be reported by the test.
diff --git a/MAINTAINERS b/MAINTAINERS
index a0cd161843e..4b9d251259d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11249,6 +11249,7 @@ KERNEL USERMODE DRIVER MANAGEMENT
 M:	Roberto Sassu <roberto.sassu@huawei.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/driver-api/umd_mgmt.rst
 F:	include/linux/usermode_driver_mgmt.h
 F:	kernel/usermode_driver_mgmt.c
 F:	tools/testing/selftests/umd_mgmt/*
-- 
2.25.1

