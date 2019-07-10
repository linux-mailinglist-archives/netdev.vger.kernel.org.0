Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CD3649D4
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfGJPi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:38:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfGJPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:38:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AFXpjV140644;
        Wed, 10 Jul 2019 15:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=RoOPOjQgj2XYASbiBhpR/1oApLKROklq3dcoMH9Dp4M=;
 b=lsDAwrPmHqsQB+Iaaw5ADhMtvebDrQoFVAS1sBi13MaorrlgkynlYaVcm2iwBodPz3s4
 q2kMQ+Bg6wSRPVnmPEoQL6mbarYBOSptxvQ4ONVAAcHnlhEpCJwbGXWklNeRgByFHDyX
 nN5zW2KhsyRjrWnuqITsJ/3Q9l7MQ173HVfZCli9T8wTj4hL8QNw+xl3h8a595OyYJ57
 K8CEwpP8wjYlxD0Zs9PtZNSMBR23m10B8NQLMlvKvx5bRC8oimxJC2V+YRGIKS9tu2fC
 G5CrVL6oYOWOzdB/OlsgtMC/pAhp+g4z3CMpfvILq4tWtMtMuLxnk+MKisQBAhifkPLc ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9qtwwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 15:37:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AFWjX3056498;
        Wed, 10 Jul 2019 15:37:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tmwgxjj8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jul 2019 15:37:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6AFbvkv069541;
        Wed, 10 Jul 2019 15:37:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tmwgxjj88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 15:37:57 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6AFboMR015946;
        Wed, 10 Jul 2019 15:37:50 GMT
Message-Id: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
Received: from localhost (/10.159.211.102) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 10 Jul 2019 08:37:49 -0700
MIME-Version: 1.0
Date:   Wed, 10 Jul 2019 08:37:50 -0700 (PDT)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>
Subject: [PATCH V2 0/1] tools/dtrace: initial implementation of DTrace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is version 2 of the patch, incorporating feedback from Peter Zijlstra and
Arnaldo Carvalho de Melo.

Changes in Makefile:
	- Remove -I$(srctree)/tools/perf from KBUILD_HOSTCFLAGS since it
	  is not actually used.

Changes in dt_bpf.c:
	- Remove unnecessary PERF_EVENT_IOC_ENABLE.

Changes in dt_buffer.c:
	- Use ring_buffer_read_head() and ring_buffer_write_tail() to
	  avoid use of volatile.
	- Handle perf events that wrap around the ring buffer boundary.
	- Remove unnecessary PERF_EVENT_IOC_ENABLE.

Changes in bpf_sample.c:
	- Use PT_REGS_PARM1(x), etc instead of my own macros.  Adding
	  PT_REGS_PARM6(x) in bpf_sample.c because we need to be able to
	  support up to 6 arguments passed by registers.

This patch is also available, applied to bpf-next, at the following URL:

	https://github.com/oracle/dtrace-linux-kernel/tree/dtrace-bpf

As suggested in feedback to my earlier patch submissions, this code takes an
approach to avoid kernel code changes as much as possible.  The current patch
does not involve any kernel code changes.  Further development of this code
will continue with this approach, incrementally adding features to this first
minimal implementation.  The goal is a fully featured and functional DTrace
implementation involving kernel changes only when strictly necessary.

The code presented here supports two very basic functions:

1. Listing probes that are used in BPF programs

   # dtrace -l -s bpf_sample.o
      ID   PROVIDER            MODULE                          FUNCTION NAME
   18876        fbt           vmlinux                        ksys_write entry
   70423    syscall           vmlinux                             write entry

2. Loading BPF tracing programs and collecting data that they generate

   # dtrace -s bpf_sample.o
   CPU     ID
    15  70423 0xffff8c0968bf8ec0 0x00000000000001 0x0055e019eb3f60 0x0000000000002c
    15  18876 0xffff8c0968bf8ec0 0x00000000000001 0x0055e019eb3f60 0x0000000000002c
   ...

Only kprobes and syscall tracepoints are supported since this is an initial
patch.  It does show the use of a generic BPF function to implement the actual
probe action, called from two distinct probe types.  Follow-up patches will
add more probe types, add more tracing features from the D language, add
support for D script compilation to BPF, etc.

The implementation makes use of libbpf for handling BPF ELF objects, and uses
the perf event output ring buffer (supported through BPF) to retrieve the
tracing data.  The next step in development will be adding support to libbpf
for programs using shared functions from a collection of functions included in
the BPF ELF object (as suggested by Alexei).  

The code is structured as follows:
 tools/dtrace/dtrace.c      = command line utility
 tools/dtrace/dt_bpf.c      = interface to libbpf
 tools/dtrace/dt_buffer.c   = perf event output buffer handling
 tools/dtrace/dt_fbt.c      = kprobes probe provider
 tools/dtrace/dt_syscall.c  = syscall tracepoint probe provider
 tools/dtrace/dt_probe.c    = generic probe and probe provider handling code
                              This implements a generic interface to the actual
                              probe providers (dt_fbt and dt_syscall).
 tools/dtrace/dt_hash.c     = general probe hashing implementation
 tools/dtrace/dt_utils.c    = support code (manage list of online CPUs)
 tools/dtrace/dtrace.h      = API header file (used by BPF program source code)
 tools/dtrace/dtrace_impl.h = implementation header file
 tools/dtrace/bpf_sample.c  = sample BPF program using two probe types

I included an entry for the MAINTAINERS file.  I offer to actively maintain
this code, and to keep advancing its development.

	Cheers,
	Kris Van Hees
