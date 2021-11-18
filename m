Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4DE455AA1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344212AbhKRLkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344263AbhKRLjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:39:19 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E30BC061226;
        Thu, 18 Nov 2021 03:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=3qPb/kuMpBeJCwng87X0Eo8wE0IVCGJu3uFW57LRXkY=; b=VST2QYzk/z+mP
        J+yEvXpptTQauJq0ZBm11EBktMrJap4D91g2DwhMeQJtT3njE5ui2DEl1ay5CXVx
        wRjsxwmhBc/2MobsWQPbo2R1fEjKxVoj2oSlKS/XBqHFtPoB+yV/2T0k8tzxzqQc
        G/xYHzG9isb2SUjI3rU7FpkKqcSB+8=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnLsxMOpZhi51cAQ--.6032S2;
        Thu, 18 Nov 2021 19:34:36 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:21:30 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "=?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?=" <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 0/12] riscv: switch to relative extable and other
 improvements
Message-ID: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygBnLsxMOpZhi51cAQ--.6032S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyftryDWFWkJF13tw1rtFb_yoW8Kw17pF
        sxCF9xCFZ5Gr97uw4akr109F1rGa1rW345tr1xWr18Aw42vF48twn5t397CFyDJayYqF1I
        9F1Skr1Fkw1UAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkmb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2fMaUUUUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Similar as other architectures such as arm64, x86 and so on, use
offsets relative to the exception table entry values rather than
absolute addresses for both the exception locationand the fixup.
And recently, arm64 and x86 remove anonymous out-of-line fixups, we
want to acchieve the same result.

patch1 remove unused macro.

patch2 consolidates the __ex_table construction, it's a great code
clean up even w/o the 2nd patch.

patch3 swith to relative extable.

The remaining patches are inspired by arm64 version. They remove
the anonymous out-of-line fixups for risv.

Since v3:
  - collect Reviewed-by tag for patch2 and patch3
  - add patch1 to remove unused macro
  - add patches to remove anonymous out-of-line fixups

Since v2:
  - directly check R_RISCV_SUB32 in __ex_table instead of adding
    addend_riscv_rela()

Since v1:
  - fix build error for NOMMU case, thank lkp@intel.com


Jisheng Zhang (12):
  riscv: remove unused __cmpxchg_user() macro
  riscv: consolidate __ex_table construction
  riscv: switch to relative exception tables
  riscv: bpf: move rv_bpf_fixup_exception signature to extable.h
  riscv: extable: make fixup_exception() return bool
  riscv: extable: use `ex` for `exception_table_entry`
  riscv: lib: uaccess: fold fixups into body
  riscv: extable: consolidate definitions
  riscv: extable: add `type` and `data` fields
  riscv: add gpr-num.h
  riscv: extable: add a dedicated uaccess handler
  riscv: vmlinux.lds.S|vmlinux-xip.lds.S: remove `.fixup` section

 arch/riscv/include/asm/Kbuild        |   1 -
 arch/riscv/include/asm/asm-extable.h |  65 +++++++++++
 arch/riscv/include/asm/extable.h     |  48 ++++++++
 arch/riscv/include/asm/futex.h       |  30 ++---
 arch/riscv/include/asm/gpr-num.h     |  77 +++++++++++++
 arch/riscv/include/asm/uaccess.h     | 162 ++++-----------------------
 arch/riscv/kernel/vmlinux-xip.lds.S  |   1 -
 arch/riscv/kernel/vmlinux.lds.S      |   3 +-
 arch/riscv/lib/uaccess.S             |  28 +++--
 arch/riscv/mm/extable.c              |  66 ++++++++---
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 scripts/mod/modpost.c                |  15 +++
 scripts/sorttable.c                  |   4 +-
 13 files changed, 308 insertions(+), 201 deletions(-)
 create mode 100644 arch/riscv/include/asm/asm-extable.h
 create mode 100644 arch/riscv/include/asm/extable.h
 create mode 100644 arch/riscv/include/asm/gpr-num.h

-- 
2.33.0


