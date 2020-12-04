Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF8C2CF44E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgLDSuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:50:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgLDSuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:50:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Id7aZ080569;
        Fri, 4 Dec 2020 18:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Ht4XSMFgIFxAizqaagPUCiggLuikqi6eY1y/ipcl3Pw=;
 b=kzpr9a0E9L044Glmer2EF9HOE2WGnbBl8g3M3nrqtYigFjHmyrxFIdgl0ino/8OqR+it
 j1H6G8apA2uUKaw3quWR2xtmzMMLJbupyfrUTZcRqe22Ir54OPFCjRic92QNxIyGj/Ra
 iEQESH55S+1x2xio1rE5zHvAxrZVZ3u3FmfLg/dDW7fTf8j4jIhs6gt59vEYzxTolsDq
 uOwFKD0lW4hAgpZpjX3cUvhgmzzmOdSeqIakx6K6KwrPfbEGkcvo2xzc8F9pHX3dWQXW
 eLmfBb1v+IcHCrGas65qq0oy37IuegWXm0UsK4IYXNN0H4IPmewYQZ35qQrWTLtr6U8C GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2bcpu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 18:48:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4IYRgd082193;
        Fri, 4 Dec 2020 18:48:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540ayfr25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 18:48:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4ImmFS025392;
        Fri, 4 Dec 2020 18:48:48 GMT
Received: from localhost.uk.oracle.com (/10.175.205.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 10:48:48 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, shuah@kernel.org, lmb@cloudflare.com,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display helpers
Date:   Fri,  4 Dec 2020 18:48:33 +0000
Message-Id: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to add support to bpf_snprintf_btf() and
bpf_seq_printf_btf() allowing them to store string representations
of module-specific types, as well as the kernel-specific ones
they currently support.

Patch 1 removes the btf_module_mutex, as since we will need to
look up module BTF during BPF program execution, we don't want
to risk sleeping in the various contexts in which BPF can run.
The access patterns to the btf module list seem to conform to
classic list RCU usage so with a few minor tweaks this seems
workable.

Patch 2 replaces the unused flags field in struct btf_ptr with
an obj_id field,  allowing the specification of the id of a
BTF module.  If the value is 0, the core kernel vmlinux is
assumed to contain the type's BTF information.  Otherwise the
module with that id is used to identify the type.  If the
object-id based lookup fails, we again fall back to vmlinux
BTF.

Patch 3 is a selftest that uses veth (when built as a
module) and a kprobe to display both a module-specific
and kernel-specific type; both are arguments to veth_stats_rx().
Currently it looks up the module-specific type and object ids
using libbpf; in future, these lookups will likely be supported
directly in the BPF program via __builtin_btf_type_id(); but
I need to determine a good test to determine if that builtin
supports object ids.

Changes since RFC

- add patch to remove module mutex
- modify to use obj_id instead of module name as identifier
  in "struct btf_ptr" (Andrii)

Alan Maguire (3):
  bpf: eliminate btf_module_mutex as RCU synchronization can be used
  bpf: add module support to btf display helpers
  selftests/bpf: verify module-specific types can be shown via
    bpf_snprintf_btf

 include/linux/btf.h                                |  12 ++
 include/uapi/linux/bpf.h                           |  13 ++-
 kernel/bpf/btf.c                                   |  49 +++++---
 kernel/trace/bpf_trace.c                           |  44 ++++++--
 tools/include/uapi/linux/bpf.h                     |  13 ++-
 .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 124 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   2 +-
 tools/testing/selftests/bpf/progs/btf_ptr.h        |   2 +-
 tools/testing/selftests/bpf/progs/veth_stats_rx.c  |  72 ++++++++++++
 9 files changed, 292 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
 create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c

-- 
1.8.3.1

