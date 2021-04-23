Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550EE368A5B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhDWBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:24:23 -0400
Received: from mail.loongson.cn ([114.242.206.163]:46838 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229888AbhDWBYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 21:24:23 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx3+2TIYJgBqgMAA--.4792S2;
        Fri, 23 Apr 2021 09:23:32 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next] bpf: Document the pahole release info related to libbpf in bpf_devel_QA.rst
Date:   Fri, 23 Apr 2021 09:23:30 +0800
Message-Id: <1619141010-12521-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx3+2TIYJgBqgMAA--.4792S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw43WF1DtrWDWFy5KFy7Awb_yoW8uryxpF
        4j9r4fKrs8K3WFqrWkAw1xXFWS9FZ5Gr4fua1Yyr17Xr4kXayYvF1avr4YgFs8WFn3Ga15
        WF1Ikr1rur1UZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
        WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
        xVA2Y2ka0xkIwI1lc2xSY4AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUChFxUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pahole starts to use libbpf definitions and APIs since v1.13 after the
commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
It works well with the git repository because the libbpf submodule will
use "git submodule update --init --recursive" to update.

Unfortunately, the default github release source code does not contain
libbpf submodule source code and this will cause build issues, the tarball
from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
github, you can get the source tarball with corresponding libbpf submodule
codes from

https://fedorapeople.org/~acme/dwarves

This change documents the above issues to give more information so that
we can get the tarball from the right place, early discussion is here:

https://lore.kernel.org/bpf/2de4aad5-fa9e-1c39-3c92-9bb9229d0966@loongson.cn/

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 Documentation/bpf/bpf_devel_QA.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index d05e67e..253496a 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -449,6 +449,19 @@ from source at
 
 https://github.com/acmel/dwarves
 
+pahole starts to use libbpf definitions and APIs since v1.13 after the
+commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
+It works well with the git repository because the libbpf submodule will
+use "git submodule update --init --recursive" to update.
+
+Unfortunately, the default github release source code does not contain
+libbpf submodule source code and this will cause build issues, the tarball
+from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
+github, you can get the source tarball with corresponding libbpf submodule
+codes from
+
+https://fedorapeople.org/~acme/dwarves
+
 Some distros have pahole version 1.16 packaged already, e.g.
 Fedora, Gentoo.
 
-- 
2.1.0

