Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5927C205203
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgFWMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732473AbgFWMKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC6aww158298;
        Tue, 23 Jun 2020 12:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=f/xsUQECiXjvf0CYPN7o31bK0V0CX4KDVbZLm1R4vcs=;
 b=0QkDyB4rJvkT8aS7uU6kkERC8iR3+Zb76luCKJytZHci8kYiVv24lnBs3JpRPzyHvuIV
 ntgbUGGEfXiwqfXU5c0FnpmmHjWVlEkHuOau1WfLWhuYToyDrCxteQR2DbJn2sc4isy0
 UavF3cVAl/9tRSJc/sca/z7ex/ph8nvRGv0SNkk1Nh0sqTVm1dZQqBHIh1mdHGHRg0Zb
 IJnfxDjvaL3hgq67OyyGfbpd1fOr7pRQSp3M39CBvXbxzBRCSKtFQtJuwU05j0X/NIv5
 EUDFMq3QYKM4NSqn46I1EI0JXoB87ZL8KIstIz8EGtM6HX8E+gAx6gzxjsgcLidiD1u6 SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31sebbmtxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC892R185957;
        Tue, 23 Jun 2020 12:09:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31sv7rq683-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05NC90VB022208;
        Tue, 23 Jun 2020 12:09:00 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:08:59 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 0/8] bpf, printk: add BTF-based type printing
Date:   Tue, 23 Jun 2020 13:07:03 +0100
Message-Id: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=1011
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The printk family of functions support printing specific pointer types
using %p format specifiers (MAC addresses, IP addresses, etc).  For
full details see Documentation/core-api/printk-formats.rst.

This patchset proposes introducing a "print typed pointer" format
specifier "%pT"; the argument associated with the specifier is of
form "struct btf_ptr *" which consists of a .ptr value and a .type
value specifying a stringified type (e.g. "struct sk_buff") or
an .id value specifying a BPF Type Format (BTF) id identifying
the appropriate type it points to.

There is already support in kernel/bpf/btf.c for "show" functionality;
the changes here generalize that support from seq-file specific
verifier display to the more generic case and add another specific
use case; snprintf()-style rendering of type information to a
provided buffer.  This support is then used to support printk
rendering of types, but the intent is to provide a function
that might be useful in other in-kernel scenarios; for example:

- ftrace could possibly utilize the function to support typed
  display of function arguments by cross-referencing BTF function
  information to derive the types of arguments
- oops/panic messaging could extend the information displayed to
  dig into data structures associated with failing functions

The above potential use cases hint at a potential reply to
a reasonable objection that such typed display should be
solved by tracing programs, where the in kernel tracing records
data and the userspace program prints it out.  While this
is certainly the recommended approach for most cases, I
believe having an in-kernel mechanism would be valuable
also.

The function the printk() family of functions rely on
could potentially be used directly for other use cases
like ftrace where we might have the BTF ids of the
pointers we wish to display; its signature is as follows:

int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
                           char *buf, int len, u64 flags);

So if ftrace say had the BTF ids of the types of arguments,
we see that the above would allow us to convert the
pointer data into displayable form.

To give a flavour for what the printed-out data looks like,
here we use pr_info() to display a struct sk_buff *.

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);

  pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));

...gives us:

(struct sk_buff){
 .transport_header = (__u16)65535,
 .mac_header = (__u16)65535,
 .end = (sk_buff_data_t)192,
 .head = (unsigned char *)000000007524fd8b,
 .data = (unsigned char *)000000007524fd8b,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
}

For bpf_trace_printk() a "struct __btf_ptr *" is used as
argument; see tools/testing/selftests/bpf/progs/netif_receive_skb.c
for example usage.

The hope is that this functionality will be useful for debugging,
and possibly help facilitate the cases mentioned above in the future.

Changes since v2:

- Alexei and Yonghong suggested it would be good to use
  probe_kernel_read() on to-be-shown data to ensure safety
  during operation.  Safe copy via probe_kernel_read() to a
  buffer object in "struct btf_show" is used to support
  this.  A few different approaches were explored
  including dynamic allocation and per-cpu buffers. The
  downside of dynamic allocation is that it would be done
  during BPF program execution for bpf_trace_printk()s using
  %pT format specifiers. The problem with per-cpu buffers
  is we'd have to manage preemption and since the display
  of an object occurs over an extended period and in printk
  context where we'd rather not change preemption status,
  it seemed tricky to manage buffer safety while considering
  preemption.  The approach of utilizing stack buffer space
  via the "struct btf_show" seemed like the simplest approach.
  The stack size of the associated functions which have a
  "struct btf_show" on their stack to support show operation
  (btf_type_snprintf_show() and btf_type_seq_show()) stays
  under 500 bytes. The compromise here is the safe buffer we
  use is small - 256 bytes - and as a result multiple
  probe_kernel_read()s are needed for larger objects. Most
  objects of interest are smaller than this (e.g.
  "struct sk_buff" is 224 bytes), and while task_struct is a
  notable exception at ~8K, performance is not the priority for
  BTF-based display. (Alexei and Yonghong, patch 2).
- safe buffer use is the default behaviour (and is mandatory
  for BPF) but unsafe display - meaning no safe copy is done
  and we operate on the object itself - is supported via a
  'u' option.
- pointers are prefixed with 0x for clarity (Alexei, patch 2)
- added additional comments and explanations around BTF show
  code, especially around determining whether objects such
  zeroed. Also tried to comment safe object scheme used. (Yonghong,
  patch 2)
- added late_initcall() to initialize vmlinux BTF so that it would
  not have to be initialized during printk operation (Alexei,
  patch 5)
- removed CONFIG_BTF_PRINTF config option as it is not needed;
  CONFIG_DEBUG_INFO_BTF can be used to gate test behaviour and
  determining behaviour of type-based printk can be done via
  retrieval of BTF data; if it's not there BTF was unavailable
  or broken (Alexei, patches 4,6)
- fix bpf_trace_printk test to use vmlinux.h and globals via
  skeleton infrastructure, removing need for perf events
  (Andrii, patch 8)

Changes since v1:

- changed format to be more drgn-like, rendering indented type info
  along with type names by default (Alexei)
- zeroed values are omitted (Arnaldo) by default unless the '0'
  modifier is specified (Alexei)
- added an option to print pointer values without obfuscation.
  The reason to do this is the sysctls controlling pointer display
  are likely to be irrelevant in many if not most tracing contexts.
  Some questions on this in the outstanding questions section below...
- reworked printk format specifer so that we no longer rely on format
  %pT<type> but instead use a struct * which contains type information
  (Rasmus). This simplifies the printk parsing, makes use more dynamic
  and also allows specification by BTF id as well as name.
- removed incorrect patch which tried to fix dereferencing of resolved
  BTF info for vmlinux; instead we skip modifiers for the relevant
  case (array element type determination) (Alexei).
- fixed issues with negative snprintf format length (Rasmus)
- added test cases for various data structure formats; base types,
  typedefs, structs, etc.
- tests now iterate through all typedef, enum, struct and unions
  defined for vmlinux BTF and render a version of the target dummy
  value which is either all zeros or all 0xff values; the idea is this
  exercises the "skip if zero" and "print everything" cases.
- added support in BPF for using the %pT format specifier in
  bpf_trace_printk()
- added BPF tests which ensure %pT format specifier use works (Alexei).

Important note: if running test_printf.ko - the version in the bpf-next
tree will induce a panic when running the fwnode_pointer() tests due
to a kobject issue; applying the patch in

https://lkml.org/lkml/2020/4/17/389

...resolved this issue for me.

Alan Maguire (8):
  bpf: provide function to get vmlinux BTF information
  bpf: move to generic BTF show support, apply it to seq files/strings
  checkpatch: add new BTF pointer format specifier
  printk: add type-printing %pT format specifier which uses BTF
  printk: initialize vmlinux BTF outside of printk in late_initcall()
  printk: extend test_printf to test %pT BTF-based format specifier
  bpf: add support for %pT format specifier for bpf_trace_printk()
    helper
  bpf/selftests: add tests for %pT format specifier

 Documentation/core-api/printk-formats.rst          |  17 +
 include/linux/bpf.h                                |   2 +
 include/linux/btf.h                                |  42 +-
 include/linux/printk.h                             |  16 +
 include/uapi/linux/bpf.h                           |  27 +-
 kernel/bpf/btf.c                                   | 999 ++++++++++++++++++---
 kernel/bpf/verifier.c                              |  18 +-
 kernel/trace/bpf_trace.c                           |  24 +-
 lib/test_printf.c                                  | 316 +++++++
 lib/vsprintf.c                                     | 110 +++
 scripts/checkpatch.pl                              |   2 +-
 tools/include/uapi/linux/bpf.h                     |  27 +-
 .../selftests/bpf/prog_tests/trace_printk_btf.c    |  45 +
 .../selftests/bpf/progs/netif_receive_skb.c        |  47 +
 14 files changed, 1570 insertions(+), 122 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

-- 
1.8.3.1

