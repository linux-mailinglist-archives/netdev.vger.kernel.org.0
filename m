Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275EB24488
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfETXr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:47:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34706 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfETXrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:47:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNiIbv170861;
        Mon, 20 May 2019 23:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=4ftFFqAo1F7U1VytE7tnsxbwCffzarOIOBnr6rEpXT4=;
 b=fjjFVABav6yIZKxMpNJoYrBD6iNF7POidTcgsvLRFuM8Xrkt4ZL4Ut/wN0FQdSiqYwNg
 C2NAt/Q1WViWe+pDMN8ZBP//JA85oeBI8ZbSjE2aeRx4X6HD64kbd9yX05TPwR5/CTIT
 oVCyzZtxsky2LwfUe6sM/eUr2Mr4IcXuVhB5gNKk6AYxPWd0eEHr8d/AXwQGgI1Ct/nN
 lWcAYHZGftRCHWVXV9L5lmNqOk5SSCGNyFpv1dLBH8FEKyDQR18rJwZxL27GgF9NF+kQ
 cg8KhlGPCH13oXyR9CrWSA+EcpQpbyOtEYzn+5RcCrVj9DpedtrcYC+POgkOMJCLoHzf Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj83f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:47:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNjiUc178934;
        Mon, 20 May 2019 23:47:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1xvjd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:47:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNl3Vo180864;
        Mon, 20 May 2019 23:47:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1xvjcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:47:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNl0cs030532;
        Mon, 20 May 2019 23:47:00 GMT
Message-Id: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:46:59 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:47:00 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is also available, applied to bpf-next, at the following URL:

	https://github.com/oracle/dtrace-linux-kernel/tree/dtrace-bpf

The patches in this set are part of an larger effort to re-implement DTrace
based on existing Linux kernel features wherever possible.  This allows
existing DTrace scripts to run without modification on Linux and to write
new scripts using a tracing tool that people may already be familiar with.
This set of patches is posted as an RFC.  I am soliciting feedback on the
patches, especially because they cross boundaries between tracing and BPF.
Some of the features might be combined with existing more specialized forms
of similar functionality, and perhaps some functionality could be moved to
other parts of the code.

This set of patches provides the initial core to make it possible to execute
DTrace BPF programs as probe actions, triggered from existing probes in the
kernel (right now just kprobe, but more will be added in followup patches).
The DTrace BPF programs run in a specific DTrace context that is independent
from the probe-specific BPF program context because DTrace actions are
implemented based on a general probe concept (an abstraction of the various
specific probe types).

It also provides a mechanism to store probe data in output buffers directly
from BPF programs, using direct store instructions.  Finally, it provides a
simple sample userspace tool to load programs, collect data, and print out the
data.  This little tool is currently hardcoded to process a single test case,
to show how the BPF program is to be constructed and to show how to retrieve
data from the output buffers.

The work presented here would not be possible without the effort many people
have put into tracing features on Linux.  Especially BPF is instrumental in
being able to do this project because it provides a safe and fast virtual
execution engine that can be leveraged to execute probe actions in a more
elegant manner.  The perf_event ring-buffer output mechanism has also proven
to be very beneficial to starting a re-implementation of DTrace on Linux,
especially because it avoids needing to add yet another buffer implementation
to the kernel.  It really helped with being able to re-use functionality.

The patch set provides the following patches:

    1. bpf: context casting for tail call

	This patch adds the ability to tail-call into a BPF program of a
	different type than the one initiating the call.  It provides two
	program type specific operations: is_valid_tail_call (to validate
	whether the tail-call between the source type and target type is
	allowed) and convert_ctx (to create a context for the target type
	based on the context of the source type).  It also provides a
	bpf_finalize_context() helper function prototype.  BPF program types
	should implement this helper to perform any final context setup that
	may need to be done within the execution context of the program type.
	This helper is typically invoked as the first statement in an eBPF
	program that can be tail-called from another type.

    2. bpf: add BPF_PROG_TYPE_DTRACE

	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
	actually providing an implementation.  The actual implementation is
	added in patch 4 (see below).  We do it this way because the
	implementation is being added to the tracing subsystem as a component
	that I would be happy to maintain (if merged) whereas the declaration
	of the program type must be in the bpf subsystem.  Since the two
	subsystems are maintained by different people, we split the
	implementing patches across maintainer boundaries while ensuring that
	the kernel remains buildable between patches.

    3. bpf: export proto for bpf_perf_event_output helper

	This patch make a prototype available for the bpf_perf_event_output
	helper so that program types outside of the base tracing eBPF code can
	make use of it.

    4. trace: initial implementation of DTrace based on kernel facilities

	This patch provides the most basic implementation of the DTrace
	execution core based on eBPF and other kernel facilities.  This
	version only supports kprobes.  It makes use of the cross-program-type
	tail-call support adding with patch 1 (see above).

    5. trace: update Kconfig and Makefile to include DTrace

	This patch adds DTrace to the kernel config system and it ensures that
	if CONFIG_DTRACE is set, the implementation of the DTrace core is
	compiled into the kernel.

    6. dtrace: tiny userspace tool to exercise DTrace support features

	This patch provides a tiny userspace DTrace consumer as a
	proof-of-concept and to test the DTrace eBPF program type and its use
	by the DTrace core.

    7. bpf: implement writable buffers in contexts

	This patch adds the ability to specify writable buffers in an eBPF
	program type context.  The public context declaration should provide
	<buf> and <buf>_end members (<buf> can be any valid identifier) for
	each buffer.  The is_valid_access() function for the program type
	should force the register type of read access to <buf> as
	PTR_TO_BUFFER whereas reading <buf>_end should yield register type
	PTR_TO_BUFFER_END.  The functionality is nearly identical to
	PTR_TO_PACKET and PTR_TO_PACKET_END.  Contexts can have multiple
	writable buffers, distinguished from one another by a new buf_id
	member in the bpf_reg_state struct.  For every writable buffer, both
	<buf> and <buf>_end must provide the same buf_id value (using
	offset(context, <buf>) is a good and convenient choice). 

    8. perf: add perf_output_begin_forward_in_page

	This patch introduces a new function to commence the process of
	writing data to a perf_event ring-buffer.  This variant enforces the
	requirement that the data to be written cannot cross a page boundary.
	It will fill the remainder of the current page with zeros and allocate
	space for the data in the next page if the remainder of the current
	page is too small.  This is necessary to allow eBPF program to write
	to the buffer space directly with statements like: buf[offset] = value.

    9. bpf: mark helpers explicitly whether they may change the context

	This patch changes the way BPF determines whether a helper may change
	the content of the context (i.e. if it does, any range information
	related to pointers in the context must be invalidated).  The original
	implementation contained a hard-coded list of helpers that change the
	context.  The new implementation adds a new field to the helper proto
	struct (ctx_update, default false).

    10. bpf: add bpf_buffer_reserve and bpf_buffer_commit helpers

	This patch adds two new helpers: bpf_buffer_reserve (to set up a
	specific buffer in the context as writable space of a given size) and
	bpf_buffer_commit (to finalize the data written to the buffer prepared
	with bpf_buffer_reserve).

    11. dtrace: make use of writable buffers in BPF

	This patch updates the initial implementation of the DTrace core and
	the proof-of-concept utility to make use of the writable-buffer support
	and the bpf_buffer_reserve and bpf_buffer_commit helpers.

(More detailed descriptions can be found in the individual commit messages.)

The road ahead is roughly as follows:

    - Adding support for DTrace specific probe meta data to be available to
      DTrace BPF programs
    - Adding support for other probe types
    - Adding support for probe arguments
    - Adding support for the DTrace probe naming mechanism to map DTrace
      style probe names to the actual defined probes in the kernel
    - Adding support for DTrace features that currently do not exist in
      the kernel as existing functionality
    - Rework the existing dtrace utility to make use of the new implementation
    - Keep adding features to the DTrace system

	Cheers,
	Kris
