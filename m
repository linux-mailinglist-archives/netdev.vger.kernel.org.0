Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8320F6BEBC7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjCQOx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCQOxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:53:54 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83133D0AA;
        Fri, 17 Mar 2023 07:53:52 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PdRjy46Pnz9v7gg;
        Fri, 17 Mar 2023 22:44:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S2;
        Fri, 17 Mar 2023 15:53:29 +0100 (CET)
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
Subject: [PATCH 0/5] usermode_driver: Add management library and API
Date:   Fri, 17 Mar 2023 15:52:35 +0100
Message-Id: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF13Wr4xXw18KFyxZry3twb_yoW7JF18pa
        yrJry3GrnYqF12yFZ3JF17ua4rXan7JF4Ykr1SqrWUZw1IvrySvr1xtr13GFZxKrWftFnI
        yrn3K3W5Cws8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
        n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
        ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280
        aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0x
        ZFpf9x07jxCztUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4asxgABsJ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

A User Mode Driver (UMD) is a specialization of a User Mode Helper (UMH),
which runs a user space process from a binary blob, and creates a
bidirectional pipe, so that the kernel can make a request to that process,
and the latter provides its response. It is currently used by bpfilter,
although it does not seem to do any useful work.

The problem is, if other users would like to implement a UMD similar to
bpfilter, they would have to duplicate the code. Instead, make an UMD
management library and API from the existing bpfilter and sockopt code,
and move it to common kernel code.

Also, define the software architecture and the main components of the
library: the UMD Manager, running in the kernel, acting as the frontend
interface to any user or kernel-originated request; the UMD Loader, also
running in the kernel, responsible to load the UMD Handler; the UMD
Handler, running in user space, responsible to handle requests from the UMD
Manager and to send to it the response.

I have two use cases, but for sake of brevity I will propose one.

I would like to add support for PGP keys and signatures in the kernel, so
that I can extend secure boot to applications, and allow/deny code
execution based on the signed file digests included in RPM headers.

While I proposed a patch set a while ago (based on a previous work of David
Howells), the main objection was that the PGP packet parser should not run
in the kernel.

That makes a perfect example for using a UMD. If the PGP parser is moved to
user space (UMD Handler), and the kernel (UMD Manager) just instantiates
the key and verifies the signature on already parsed data, this would
address the concern.

Patch 1 moves the function bpfilter_send_req() to usermode_driver.c and
makes the pipe between the kernel and the user space process suitable for
larger quantity of data (> 64K).

Patch 2 introduces the management library and API.

Patch 3 replaces the existing bpfilter and sockopt code with calls
to the management API. To use the new mechanism, sockopt itself (acts as
UMD Manager) now sends/receives messages to/from bpfilter_umh (acts as UMD
Handler), instead of bpfilter (acts as UMD Loader).

Patch 4 introduces a sample UMD, useful for other implementors, and uses it
for testing.

Patch 5 introduces the documentation of the new management library and API.

Roberto Sassu (5):
  usermode_driver: Introduce umd_send_recv() from bpfilter
  usermode_driver_mgmt: Introduce management of user mode drivers
  bpfilter: Port to user mode driver management API
  selftests/umd_mgmt: Add selftests for UMD management library
  doc: Add documentation for the User Mode Driver management library

 Documentation/driver-api/index.rst            |   1 +
 Documentation/driver-api/umd_mgmt.rst         |  99 +++++++++++++
 MAINTAINERS                                   |   9 ++
 include/linux/bpfilter.h                      |  12 +-
 include/linux/usermode_driver.h               |   2 +
 include/linux/usermode_driver_mgmt.h          |  35 +++++
 kernel/Makefile                               |   2 +-
 kernel/usermode_driver.c                      |  47 +++++-
 kernel/usermode_driver_mgmt.c                 | 137 ++++++++++++++++++
 net/bpfilter/bpfilter_kern.c                  | 120 +--------------
 net/ipv4/bpfilter/sockopt.c                   |  67 +++++----
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/umd_mgmt/.gitignore   |   1 +
 tools/testing/selftests/umd_mgmt/Makefile     |  14 ++
 tools/testing/selftests/umd_mgmt/config       |   1 +
 .../selftests/umd_mgmt/sample_umd/Makefile    |  22 +++
 .../selftests/umd_mgmt/sample_umd/msgfmt.h    |  13 ++
 .../umd_mgmt/sample_umd/sample_binary_blob.S  |   7 +
 .../umd_mgmt/sample_umd/sample_handler.c      |  81 +++++++++++
 .../umd_mgmt/sample_umd/sample_loader.c       |  28 ++++
 .../umd_mgmt/sample_umd/sample_mgr.c          | 124 ++++++++++++++++
 tools/testing/selftests/umd_mgmt/umd_mgmt.sh  |  40 +++++
 22 files changed, 707 insertions(+), 156 deletions(-)
 create mode 100644 Documentation/driver-api/umd_mgmt.rst
 create mode 100644 include/linux/usermode_driver_mgmt.h
 create mode 100644 kernel/usermode_driver_mgmt.c
 create mode 100644 tools/testing/selftests/umd_mgmt/.gitignore
 create mode 100644 tools/testing/selftests/umd_mgmt/Makefile
 create mode 100644 tools/testing/selftests/umd_mgmt/config
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/Makefile
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/msgfmt.h
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_binary_blob.S
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_handler.c
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_loader.c
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_mgr.c
 create mode 100755 tools/testing/selftests/umd_mgmt/umd_mgmt.sh

-- 
2.25.1

