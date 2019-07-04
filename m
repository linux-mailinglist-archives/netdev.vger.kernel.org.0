Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5F5F1BC
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 05:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGDDOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 23:14:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfGDDOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 23:14:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6434PWP193276;
        Thu, 4 Jul 2019 03:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=pNCu0QyzDiiTDwZZZKKayKgr5kYJuplRGSbV94S6ShA=;
 b=HuMdgSIOPHRfop6AhhMizUBhYrNRwFbNZP3xDXJk3ndC4o7mMZV4REy+dkuq0Kl36Mdz
 hIo5HVGOhUfrdvriwr31vxpwRZ7H7xrGkfY/PVs0wFvBVsQWvR/4Y2iDXJanD7KI9Efy
 +ORXCVcmVy4h7JKLvCCXN4mHW6RRY+WMUJb+I8K+uVUY+xWqLfIMnWdSwMg3PlKMbjr2
 fDFK/GM6QBawJEumMR3ht8lBlj7qe+SpNqEM+esk75MLFlXzX7NRZQF7lZWCvFE/yUNz
 Gzd/0ET6UcUkkuI42C2bV38vPkL//c4Cp1FKQewzwiwq8oT6ZFXI104R0qUY0T8TSM4C LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tbvebx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 03:13:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6433LU4087344;
        Thu, 4 Jul 2019 03:13:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2tebbkpsbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 04 Jul 2019 03:13:11 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x643DBUV104313;
        Thu, 4 Jul 2019 03:13:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tebbkpsbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 03:13:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x643D8Pg025951;
        Thu, 4 Jul 2019 03:13:08 GMT
Message-Id: <201907040313.x643D8Pg025951@userv0121.oracle.com>
Received: from localhost (/10.159.211.102) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 03 Jul 2019 20:13:08 -0700
MIME-Version: 1.0
Date:   Wed, 3 Jul 2019 20:13:08 -0700 (PDT)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>
Subject: [PATCH 0/1] tools/dtrace: initial implementation of DTrace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040040
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
