Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA371D21A1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgEMV7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:59:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730414AbgEMV7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:59:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DLrPKQ170998;
        Wed, 13 May 2020 21:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=MIOUoTqcQUgrlx1KMhta17dyffmdwHF4RCDdIQ3vt6w=;
 b=dMZuD+zTiq8PkBDJeZRFc0eXvOrlWeuxfSFnxxXiDStK0eUH+8o5rIPtYICQUlSroJxV
 piLvE4roOaWE0U6LDYJXQlDLmVBU4byJ1LWe+8mNbbPppUCRjZPA5YsigOfitdaOh3J0
 WBKorlSE+0j9dTvbHSuoX00QukdpoW6lTeRhiVaveL9M0KZIzODEOT5Dc5OKtKqWAoa0
 pmyEcQwqD393ZeLnM2pi8ASrFWU2CzRz2X5iTGZ59Lq0NNuUlkt0F9GOTEzhne2+A/DM
 grraipbUTWIL5z1KpkNJ3deNKb6wzoaTvN/cvrD+NC1+ntZZToLuOhLzpUdcMQYVRakZ sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwf13k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 21:58:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DLvwjq079173;
        Wed, 13 May 2020 21:58:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100ybct0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 21:58:38 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04DLwaeY013298;
        Wed, 13 May 2020 21:58:36 GMT
Received: from dhcp-10-175-168-15.vpn.oracle.com (/10.175.168.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 14:58:35 -0700
Date:   Wed, 13 May 2020 22:58:26 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andriin@fb.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
In-Reply-To: <20200513192532.4058934-2-andriin@fb.com>
Message-ID: <alpine.LRH.2.21.2005132231450.1535@localhost>
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1011 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Andrii Nakryiko wrote:

> This commits adds a new MPSC ring buffer implementation into BPF ecosystem,
> which allows multiple CPUs to submit data to a single shared ring buffer. On
> the consumption side, only single consumer is assumed.
> 
> Motivation
> ----------
> There are two distinctive motivators for this work, which are not satisfied by
> existing perf buffer, which prompted creation of a new ring buffer
> implementation.
>   - more efficient memory utilization by sharing ring buffer across CPUs;
>   - preserving ordering of events that happen sequentially in time, even
>   across multiple CPUs (e.g., fork/exec/exit events for a task).
> 
> These two problems are independent, but perf buffer fails to satisfy both.
> Both are a result of a choice to have per-CPU perf ring buffer.  Both can be
> also solved by having an MPSC implementation of ring buffer. The ordering
> problem could technically be solved for perf buffer with some in-kernel
> counting, but given the first one requires an MPSC buffer, the same solution
> would solve the second problem automatically.
> 

This looks great Andrii! One potentially interesting side-effect of
the way this is implemented is that it could (I think) support speculative 
tracing.

Say I want to record some tracing info when I enter function foo(), but 
I only care about cases where that function later returns an error value.
I _think_ your implementation could support that via a scheme like 
this:

- attach a kprobe program to record the data via bpf_ringbuf_reserve(),
  and store the reserved pointer value in a per-task keyed hashmap.
  Then record the values of interest in the reserved space. This is our
  speculative data as we don't know whether we want to commit it yet.

- attach a kretprobe program that picks up our reserved pointer and
  commit()s or discard()s the associated data based on the return value.

- the consumer should (I think) then only read the committed data, so in
  this case just the data of interest associated with the failure case.

I'm curious if that sort of ringbuf access pattern across multiple 
programs would work? Thanks!

Alan

> Semantics and APIs
> ------------------
> Single ring buffer is presented to BPF programs as an instance of BPF map of
> type BPF_MAP_TYPE_RINGBUF. Two other alternatives considered, but ultimately
> rejected.
> 
> One way would be to, similar to BPF_MAP_TYPE_PERF_EVENT_ARRAY, make
> BPF_MAP_TYPE_RINGBUF could represent an array of ring buffers, but not enforce
> "same CPU only" rule. This would be more familiar interface compatible with
> existing perf buffer use in BPF, but would fail if application needed more
> advanced logic to lookup ring buffer by arbitrary key. HASH_OF_MAPS addresses
> this with current approach. Additionally, given the performance of BPF
> ringbuf, many use cases would just opt into a simple single ring buffer shared
> among all CPUs, for which current approach would be an overkill.
> 
> Another approach could introduce a new concept, alongside BPF map, to
> represent generic "container" object, which doesn't necessarily have key/value
> interface with lookup/update/delete operations. This approach would add a lot
> of extra infrastructure that has to be built for observability and verifier
> support. It would also add another concept that BPF developers would have to
> familiarize themselves with, new syntax in libbpf, etc. But then would really
> provide no additional benefits over the approach of using a map.
> BPF_MAP_TYPE_RINGBUF doesn't support lookup/update/delete operations, but so
> doesn't few other map types (e.g., queue and stack; array doesn't support
> delete, etc).
> 
> The approach chosen has an advantage of re-using existing BPF map
> infrastructure (introspection APIs in kernel, libbpf support, etc), being
> familiar concept (no need to teach users a new type of object in BPF program),
> and utilizing existing tooling (bpftool). For common scenario of using
> a single ring buffer for all CPUs, it's as simple and straightforward, as
> would be with a dedicated "container" object. On the other hand, by being
> a map, it can be combined with ARRAY_OF_MAPS and HASH_OF_MAPS map-in-maps to
> implement a wide variety of topologies, from one ring buffer for each CPU
> (e.g., as a replacement for perf buffer use cases), to a complicated
> application hashing/sharding of ring buffers (e.g., having a small pool of
> ring buffers with hashed task's tgid being a look up key to preserve order,
> but reduce contention).
> 
> Key and value sizes are enforced to be zero. max_entries is used to specify
> the size of ring buffer and has to be a power of 2 value.
> 
> There are a bunch of similarities between perf buffer
> (BPF_MAP_TYPE_PERF_EVENT_ARRAY) and new BPF ring buffer semantics:
>   - variable-length records;
>   - if there is no more space left in ring buffer, reservation fails, no
>     blocking;
>   - memory-mappable data area for user-space applications for ease of
>     consumption and high performance;
>   - epoll notifications for new incoming data;
>   - but still the ability to do busy polling for new data to achieve the
>     lowest latency, if necessary.
> 
> BPF ringbuf provides two sets of APIs to BPF programs:
>   - bpf_ringbuf_output() allows to *copy* data from one place to a ring
>     buffer, similarly to bpf_perf_event_output();
>   - bpf_ringbuf_reserve()/bpf_ringbuf_commit()/bpf_ringbuf_discard() APIs
>     split the whole process into two steps. First, a fixed amount of space is
>     reserved. If successful, a pointer to a data inside ring buffer data area
>     is returned, which BPF programs can use similarly to a data inside
>     array/hash maps. Once ready, this piece of memory is either committed or
>     discarded. Discard is similar to commit, but makes consumer ignore the
>     record.
> 
> bpf_ringbuf_output() has disadvantage of incurring extra memory copy, because
> record has to be prepared in some other place first. But it allows to submit
> records of the length that's not known to verifier beforehand. It also closely
> matches bpf_perf_event_output(), so will simplify migration significantly.
> 
> bpf_ringbuf_reserve() avoids the extra copy of memory by providing a memory
> pointer directly to ring buffer memory. In a lot of cases records are larger
> than BPF stack space allows, so many programs have use extra per-CPU array as
> a temporary heap for preparing sample. bpf_ringbuf_reserve() avoid this needs
> completely. But in exchange, it only allows a known constant size of memory to
> be reserved, such that verifier can verify that BPF program can't access
> memory outside its reserved record space. bpf_ringbuf_output(), while slightly
> slower due to extra memory copy, covers some use cases that are not suitable
> for bpf_ringbuf_reserve().
> 
> The difference between commit and discard is very small. Discard just marks
> a record as discarded, and such records are supposed to be ignored by consumer
> code. Discard is useful for some advanced use-cases, such as ensuring
> all-or-nothing multi-record submission, or emulating temporary malloc()/free()
> within single BPF program invocation.
> 
> Each reserved record is tracked by verifier through existing
> reference-tracking logic, similar to socket ref-tracking. It is thus
> impossible to reserve a record, but forget to submit (or discard) it.
> 
> Design and implementation
> -------------------------
> This reserve/commit schema allows a natural way for multiple producers, either
> on different CPUs or even on the same CPU/in the same BPF program, to reserve
> independent records and work with them without blocking other producers. This
> means that if BPF program was interruped by another BPF program sharing the
> same ring buffer, they will both get a record reserved (provided there is
> enough space left) and can work with it and submit it independently. This
> applies to NMI context as well, except that due to using a spinlock during
> reservation, in NMI context, bpf_ringbuf_reserve() might fail to get a lock,
> in which case reservation will fail even if ring buffer is not full.
> 
> The ring buffer itself internally is implemented as a power-of-2 sized
> circular buffer, with two logical and ever-increasing counters (which might
> wrap around on 32-bit architectures, that's not a problem):
>   - consumer counter shows up to which logical position consumer consumed the
>     data;
>   - producer counter denotes amount of data reserved by all producers.
> 
> Each time a record is reserved, producer that "owns" the record will
> successfully advance producer counter. At that point, data is still not yet
> ready to be consumed, though. Each record has 8 byte header, which contains
> the length of reserved record, as well as two extra bits: busy bit to denote
> that record is still being worked on, and discard bit, which might be set at
> commit time if record is discarded. In the latter case, consumer is supposed
> to skip the record and move on to the next one. Record header also encodes
> record's relative offset from the beginning of ring buffer data area (in
> pages). This allows bpf_ringbuf_commit()/bpf_ringbuf_discard() to accept only
> the pointer to the record itself, without requiring also the pointer to ring
> buffer itself. Ring buffer memory location will be restored from record
> metadata header. This significantly simplifies verifier, as well as improving
> API usability.
> 
> Producer counter increments are serialized under spinlock, so there is
> a strict ordering between reservations. Commits, on the other hand, are
> completely lockless and independent. All records become available to consumer
> in the order of reservations, but only after all previous records where
> already committed. It is thus possible for slow producers to temporarily hold
> off submitted records, that were reserved later.
> 
> Reservation/commit/consumer protocol is verified by litmus tests in the later
> patch in this series.
> 
> One interesting implementation bit, that significantly simplifies (and thus
> speeds up as well) implementation of both producers and consumers is how data
> area is mapped twice contiguously back-to-back in the virtual memory. This
> allows to not take any special measures for samples that have to wrap around
> at the end of the circular buffer data area, because the next page after the
> last data page would be first data page again, and thus the sample will still
> appear completely contiguous in virtual memory. See comment and a simple ASCII
> diagram showing this visually in bpf_ringbuf_area_alloc().
> 
> Another feature that distinguishes BPF ringbuf from perf ring buffer is
> a self-pacing notifications of new data being availability.
> bpf_ringbuf_commit() implementation will send a notification of new record
> being available after commit only if consumer has already caught up right up
> to the record being committed. If not, consumer still has to catch up and thus
> will see new data anyways without needing an extra poll notification. As will
> be shown in benchmarks in later patch in the series, this allows to achieve
> a very high throughput without having to resort to tricks like "notify only
> every Nth sample", like with perf buffer, to achieve good throughput
> performance.
> 
> For performance evaluation against perf buffer and scalability limits, see
> patch later in the series, adding ring buffers benchmark.
> number of contention
> 
> Comparison to alternatives
> --------------------------
> Before considering implementing BPF ring buffer from scratch existing
> alternatives in kernel were evaluated, but didn't seem to meet the needs. They
> largely fell into few categores:
>   - per-CPU buffers (perf, ftrace, etc), which don't satisfy two motivations
>     outlined above (ordering and memory consumption);
>   - linked list-based implementations; while some were multi-producer designs,
>     consuming these from user-space would be very complicated and most
>     probably not performant; memory-mapping contiguous piece of memory is
>     simpler and more performant for user-space consumers;
>   - io_uring is SPSC, but also requires fixed-sized elements. Naively turning
>     SPSC queue into MPSC w/ lock would have subpar performance compared to
>     locked reserve + lockless commit, as with BPF ring buffer. Fixed sized
>     elements would be too limiting for BPF programs, given existing BPF
>     programs heavily rely on variable-sized perf buffer already;
>   - specialized implementations (like a new printk ring buffer, [0]) with lots
>     of printk-specific limitations and implications, that didn't seem to fit
>     well for intended use with BPF programs.
> 
>   [0] https://lwn.net/Articles/779550/
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h            |  12 +
>  include/linux/bpf_types.h      |   1 +
>  include/linux/bpf_verifier.h   |   4 +
>  include/uapi/linux/bpf.h       |  33 ++-
>  kernel/bpf/Makefile            |   2 +-
>  kernel/bpf/helpers.c           |   8 +
>  kernel/bpf/ringbuf.c           | 409 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  12 +
>  kernel/bpf/verifier.c          | 156 ++++++++++---
>  kernel/trace/bpf_trace.c       |   8 +
>  tools/include/uapi/linux/bpf.h |  33 ++-
>  11 files changed, 643 insertions(+), 35 deletions(-)
>  create mode 100644 kernel/bpf/ringbuf.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index cf4b6e44f2bc..9e3da01f3e9b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -89,6 +89,8 @@ struct bpf_map_ops {
>  	int (*map_direct_value_meta)(const struct bpf_map *map,
>  				     u64 imm, u32 *off);
>  	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
> +	__poll_t (*map_poll)(struct bpf_map *map, struct file *filp,
> +			     struct poll_table_struct *pts);
>  };
>  
>  struct bpf_map_memory {
> @@ -243,6 +245,9 @@ enum bpf_arg_type {
>  	ARG_PTR_TO_LONG,	/* pointer to long */
>  	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
>  	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
> +	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
> +	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
> +	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
>  };
>  
>  /* type of values returned from helper functions */
> @@ -254,6 +259,7 @@ enum bpf_return_type {
>  	RET_PTR_TO_SOCKET_OR_NULL,	/* returns a pointer to a socket or NULL */
>  	RET_PTR_TO_TCP_SOCK_OR_NULL,	/* returns a pointer to a tcp_sock or NULL */
>  	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
> +	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
>  };
>  
>  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> @@ -321,6 +327,8 @@ enum bpf_reg_type {
>  	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
>  	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
>  	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
> +	PTR_TO_MEM,		 /* reg points to valid memory region */
> +	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
>  };
>  
>  /* The information passed from prog-specific *_is_valid_access
> @@ -1585,6 +1593,10 @@ extern const struct bpf_func_proto bpf_tcp_sock_proto;
>  extern const struct bpf_func_proto bpf_jiffies64_proto;
>  extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
>  extern const struct bpf_func_proto bpf_event_output_data_proto;
> +extern const struct bpf_func_proto bpf_ringbuf_output_proto;
> +extern const struct bpf_func_proto bpf_ringbuf_reserve_proto;
> +extern const struct bpf_func_proto bpf_ringbuf_submit_proto;
> +extern const struct bpf_func_proto bpf_ringbuf_discard_proto;
>  
>  const struct bpf_func_proto *bpf_tracing_func_proto(
>  	enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 29d22752fc87..fa8e1b552acd 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -118,6 +118,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
>  #if defined(CONFIG_BPF_JIT)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
>  #endif
> +BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
>  
>  BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
>  BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 6abd5a778fcd..c94a736e53cd 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -54,6 +54,8 @@ struct bpf_reg_state {
>  
>  		u32 btf_id; /* for PTR_TO_BTF_ID */
>  
> +		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
> +
>  		/* Max size from any of the above. */
>  		unsigned long raw;
>  	};
> @@ -63,6 +65,8 @@ struct bpf_reg_state {
>  	 * offset, so they can share range knowledge.
>  	 * For PTR_TO_MAP_VALUE_OR_NULL this is used to share which map value we
>  	 * came from, when one is tested for != NULL.
> +	 * For PTR_TO_MEM_OR_NULL this is used to identify memory allocation
> +	 * for the purpose of tracking that it's freed.
>  	 * For PTR_TO_SOCKET this is used to share which pointers retain the
>  	 * same reference to the socket, to determine proper reference freeing.
>  	 */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index bfb31c1be219..ae2deb6a8afc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -147,6 +147,7 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_SK_STORAGE,
>  	BPF_MAP_TYPE_DEVMAP_HASH,
>  	BPF_MAP_TYPE_STRUCT_OPS,
> +	BPF_MAP_TYPE_RINGBUF,
>  };
>  
>  /* Note that tracing related programs such as
> @@ -3121,6 +3122,32 @@ union bpf_attr {
>   * 		0 on success, or a negative error in case of failure:
>   *
>   *		**-EOVERFLOW** if an overflow happened: The same object will be tried again.
> + *
> + * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
> + * 	Description
> + * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
> + * 	Return
> + * 		0, on success;
> + * 		< 0, on error.
> + *
> + * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
> + * 	Description
> + * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
> + * 	Return
> + * 		Valid pointer with *size* bytes of memory available; NULL,
> + * 		otherwise.
> + *
> + * void bpf_ringbuf_submit(void *data)
> + * 	Description
> + * 		Submit reserved ring buffer sample, pointed to by *data*.
> + * 	Return
> + * 		Nothing.
> + *
> + * void bpf_ringbuf_discard(void *data)
> + * 	Description
> + * 		Discard reserved ring buffer sample, pointed to by *data*.
> + * 	Return
> + * 		Nothing.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3250,7 +3277,11 @@ union bpf_attr {
>  	FN(sk_assign),			\
>  	FN(ktime_get_boot_ns),		\
>  	FN(seq_printf),			\
> -	FN(seq_write),
> +	FN(seq_write),			\
> +	FN(ringbuf_output),		\
> +	FN(ringbuf_reserve),		\
> +	FN(ringbuf_submit),		\
> +	FN(ringbuf_discard),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 37b2d8620153..c9aada6c1806 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -4,7 +4,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init)
>  
>  obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
> +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>  obj-$(CONFIG_BPF_JIT) += trampoline.o
>  obj-$(CONFIG_BPF_SYSCALL) += btf.o
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5c0290e0696e..27321ca8803f 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -629,6 +629,14 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>  		return &bpf_ktime_get_ns_proto;
>  	case BPF_FUNC_ktime_get_boot_ns:
>  		return &bpf_ktime_get_boot_ns_proto;
> +	case BPF_FUNC_ringbuf_output:
> +		return &bpf_ringbuf_output_proto;
> +	case BPF_FUNC_ringbuf_reserve:
> +		return &bpf_ringbuf_reserve_proto;
> +	case BPF_FUNC_ringbuf_submit:
> +		return &bpf_ringbuf_submit_proto;
> +	case BPF_FUNC_ringbuf_discard:
> +		return &bpf_ringbuf_discard_proto;
>  	default:
>  		break;
>  	}
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> new file mode 100644
> index 000000000000..f2ae441a1695
> --- /dev/null
> +++ b/kernel/bpf/ringbuf.c
> @@ -0,0 +1,409 @@
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/filter.h>
> +#include <linux/mm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <uapi/linux/btf.h>
> +
> +#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
> +
> +#define RINGBUF_BUSY_BIT BIT(31)
> +#define RINGBUF_DISCARD_BIT BIT(30)
> +#define RINGBUF_META_SZ 8
> +
> +/* non-mmap()'able part of bpf_ringbuf (everything up to consumer page) */
> +#define BPF_RINGBUF_PGOFF \
> +	(offsetof(struct bpf_ringbuf, consumer_pos) >> PAGE_SHIFT)
> +
> +struct bpf_ringbuf {
> +	wait_queue_head_t waitq;
> +	u64 mask;
> +	spinlock_t spinlock ____cacheline_aligned_in_smp;
> +	u64 consumer_pos __aligned(PAGE_SIZE);
> +	u64 producer_pos __aligned(PAGE_SIZE);
> +	char data[] __aligned(PAGE_SIZE);
> +};
> +
> +struct bpf_ringbuf_map {
> +	struct bpf_map map;
> +	struct bpf_map_memory memory;
> +	struct bpf_ringbuf *rb;
> +};
> +
> +static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> +{
> +	const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
> +			    __GFP_ZERO;
> +	int nr_meta_pages = 2 + BPF_RINGBUF_PGOFF;
> +	int nr_data_pages = data_sz >> PAGE_SHIFT;
> +	int nr_pages = nr_meta_pages + nr_data_pages;
> +	struct page **pages, *page;
> +	size_t array_size;
> +	void *addr;
> +	int i;
> +
> +	/* Each data page is mapped twice to allow "virtual"
> +	 * continuous read of samples wrapping around the end of ring
> +	 * buffer area:
> +	 * ------------------------------------------------------
> +	 * | meta pages |  real data pages  |  same data pages  |
> +	 * ------------------------------------------------------
> +	 * |            | 1 2 3 4 5 6 7 8 9 | 1 2 3 4 5 6 7 8 9 |
> +	 * ------------------------------------------------------
> +	 * |            | TA             DA | TA             DA |
> +	 * ------------------------------------------------------
> +	 *                               ^^^^^^^
> +	 *                                  |
> +	 * Here, no need to worry about special handling of wrapped-around
> +	 * data due to double-mapped data pages. This works both in kernel and
> +	 * when mmap()'ed in user-space, simplifying both kernel and
> +	 * user-space implementations significantly.
> +	 */
> +	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
> +	if (array_size > PAGE_SIZE)
> +		pages = vmalloc_node(array_size, numa_node);
> +	else
> +		pages = kmalloc_node(array_size, flags, numa_node);
> +	if (!pages)
> +		return NULL;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		page = alloc_pages_node(numa_node, flags, 0);
> +		if (!page) {
> +			nr_pages = i;
> +			goto err_free_pages;
> +		}
> +		pages[i] = page;
> +		if (i >= nr_meta_pages)
> +			pages[nr_data_pages + i] = page;
> +	}
> +
> +	addr = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> +		    VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> +	if (addr)
> +		return addr;
> +
> +err_free_pages:
> +	for (i = 0; i < nr_pages; i++)
> +		free_page((unsigned long)pages[i]);
> +	kvfree(pages);
> +	return NULL;
> +}
> +
> +static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
> +{
> +	struct bpf_ringbuf *rb;
> +
> +	if (!data_sz || !PAGE_ALIGNED(data_sz))
> +		return ERR_PTR(-EINVAL);
> +
> +	rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
> +	if (!rb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&rb->spinlock);
> +	init_waitqueue_head(&rb->waitq);
> +
> +	rb->mask = data_sz - 1;
> +	rb->consumer_pos = 0;
> +	rb->producer_pos = 0;
> +
> +	return rb;
> +}
> +
> +static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	u64 cost;
> +	int err;
> +
> +	if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (attr->key_size || attr->value_size ||
> +	    attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> +		return ERR_PTR(-EINVAL);
> +
> +	rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> +	if (!rb_map)
> +		return ERR_PTR(-ENOMEM);
> +
> +	bpf_map_init_from_attr(&rb_map->map, attr);
> +
> +	cost = sizeof(struct bpf_ringbuf_map) +
> +	       sizeof(struct bpf_ringbuf) +
> +	       attr->max_entries;
> +	err = bpf_map_charge_init(&rb_map->map.memory, cost);
> +	if (err)
> +		goto err_free_map;
> +
> +	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
> +	if (IS_ERR(rb_map->rb)) {
> +		err = PTR_ERR(rb_map->rb);
> +		goto err_uncharge;
> +	}
> +
> +	return &rb_map->map;
> +
> +err_uncharge:
> +	bpf_map_charge_finish(&rb_map->map.memory);
> +err_free_map:
> +	kfree(rb_map);
> +	return ERR_PTR(err);
> +}
> +
> +static void bpf_ringbuf_free(struct bpf_ringbuf *ringbuf)
> +{
> +	kvfree(ringbuf);
> +}
> +
> +static void ringbuf_map_free(struct bpf_map *map)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> +	 * so the programs (can be more than one that used this map) were
> +	 * disconnected from events. Wait for outstanding critical sections in
> +	 * these programs to complete
> +	 */
> +	synchronize_rcu();
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	bpf_ringbuf_free(rb_map->rb);
> +	kfree(rb_map);
> +}
> +
> +static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +
> +static int ringbuf_map_update_elem(struct bpf_map *map, void *key, void *value,
> +				   u64 flags)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int ringbuf_map_delete_elem(struct bpf_map *map, void *key)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int ringbuf_map_get_next_key(struct bpf_map *map, void *key,
> +				    void *next_key)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static size_t bpf_ringbuf_mmap_page_cnt(const struct bpf_ringbuf *rb)
> +{
> +	size_t data_pages = (rb->mask + 1) >> PAGE_SHIFT;
> +
> +	/* consumer page + producer page + 2 x data pages */
> +	return 2 + 2 * data_pages;
> +}
> +
> +static int ringbuf_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	size_t mmap_sz;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	mmap_sz = bpf_ringbuf_mmap_page_cnt(rb_map->rb) << PAGE_SHIFT;
> +
> +	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) > mmap_sz)
> +		return -EINVAL;
> +
> +	return remap_vmalloc_range(vma, rb_map->rb,
> +				   vma->vm_pgoff + BPF_RINGBUF_PGOFF);
> +}
> +
> +static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
> +				  struct poll_table_struct *pts)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	poll_wait(filp, &rb_map->rb->waitq, pts);
> +
> +	return EPOLLIN | EPOLLRDNORM;
> +}
> +
> +const struct bpf_map_ops ringbuf_map_ops = {
> +	.map_alloc = ringbuf_map_alloc,
> +	.map_free = ringbuf_map_free,
> +	.map_mmap = ringbuf_map_mmap,
> +	.map_poll = ringbuf_map_poll,
> +	.map_lookup_elem = ringbuf_map_lookup_elem,
> +	.map_update_elem = ringbuf_map_update_elem,
> +	.map_delete_elem = ringbuf_map_delete_elem,
> +	.map_get_next_key = ringbuf_map_get_next_key,
> +};
> +
> +/* Given pointer to ring buffer record metadata and struct bpf_ringbuf itself,
> + * calculate offset from record metadata to ring buffer in pages, rounded
> + * down. This page offset is stored as part of record metadata and allows to
> + * restore struct bpf_ringbuf * from record pointer. This page offset is
> + * stored at offset 4 of record metadata header.
> + */
> +static size_t bpf_ringbuf_rec_pg_off(struct bpf_ringbuf *rb, void *meta_ptr)
> +{
> +	return (meta_ptr - (void *)rb) >> PAGE_SHIFT;
> +}
> +
> +/* Given pointer to ring buffer record metadata, restore pointer to struct
> + * bpf_ringbuf itself by using page offset stored at offset 4
> + */
> +static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
> +{
> +	unsigned long addr = (unsigned long)meta_ptr;
> +	unsigned long off = *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;
> +
> +	return (void*)((addr & PAGE_MASK) - off);
> +}
> +
> +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> +{
> +	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> +	u32 len, pg_off;
> +	void *meta_ptr;
> +
> +	if (unlikely(size > UINT_MAX))
> +		return NULL;
> +
> +	len = round_up(size + RINGBUF_META_SZ, 8);
> +	cons_pos = READ_ONCE(rb->consumer_pos);
> +
> +	if (in_nmi()) {
> +		if (!spin_trylock_irqsave(&rb->spinlock, flags))
> +			return NULL;
> +	} else {
> +		spin_lock_irqsave(&rb->spinlock, flags);
> +	}
> +
> +	prod_pos = rb->producer_pos;
> +	new_prod_pos = prod_pos + len;
> +
> +	/* check for out of ringbuf space by ensuring producer position
> +	 * doesn't advance more than (ringbuf_size - 1) ahead
> +	 */
> +	if (new_prod_pos - cons_pos > rb->mask) {
> +		spin_unlock_irqrestore(&rb->spinlock, flags);
> +		return NULL;
> +	}
> +
> +	meta_ptr = rb->data + (prod_pos & rb->mask);
> +	pg_off = bpf_ringbuf_rec_pg_off(rb, meta_ptr);
> +
> +	WRITE_ONCE(*(u32 *)meta_ptr, RINGBUF_BUSY_BIT | size);
> +	WRITE_ONCE(*(u32 *)(meta_ptr + 4), pg_off);
> +
> +	/* ensure length prefix is written before updating producer positions */
> +	smp_wmb();
> +	WRITE_ONCE(rb->producer_pos, new_prod_pos);
> +
> +	spin_unlock_irqrestore(&rb->spinlock, flags);
> +
> +	return meta_ptr + RINGBUF_META_SZ;
> +}
> +
> +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> +	.func		= bpf_ringbuf_reserve,
> +	.ret_type	= RET_PTR_TO_ALLOC_MEM_OR_NULL,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_CONST_ALLOC_SIZE_OR_ZERO,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static void bpf_ringbuf_commit(void *sample, bool discard)
> +{
> +	unsigned long rec_pos, cons_pos;
> +	u32 new_meta, old_meta;
> +	void *meta_ptr;
> +	struct bpf_ringbuf *rb;
> +
> +	meta_ptr = sample - RINGBUF_META_SZ;
> +	rb = bpf_ringbuf_restore_from_rec(meta_ptr);
> +	old_meta = *(u32 *)meta_ptr;
> +	new_meta = old_meta ^ RINGBUF_BUSY_BIT;
> +	if (discard)
> +		new_meta |= RINGBUF_DISCARD_BIT;
> +
> +	/* update metadata header with correct final size prefix */
> +	xchg((u32 *)meta_ptr, new_meta);
> +
> +	/* if consumer caught up and is waiting for our record, notify about
> +	 * new data availability
> +	 */
> +	rec_pos = (void *)meta_ptr - (void *)rb->data;
> +	cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;
> +	if (cons_pos == rec_pos)
> +		wake_up_all(&rb->waitq);
> +}
> +
> +BPF_CALL_1(bpf_ringbuf_submit, void *, sample)
> +{
> +	bpf_ringbuf_commit(sample, false /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_submit_proto = {
> +	.func		= bpf_ringbuf_submit,
> +	.ret_type	= RET_VOID,
> +	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
> +};
> +
> +BPF_CALL_1(bpf_ringbuf_discard, void *, sample)
> +{
> +	bpf_ringbuf_commit(sample, true /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_discard_proto = {
> +	.func		= bpf_ringbuf_discard,
> +	.ret_type	= RET_VOID,
> +	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
> +};
> +
> +BPF_CALL_4(bpf_ringbuf_output, struct bpf_map *, map, void *, data, u64, size,
> +	   u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	void *rec;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	rec = __bpf_ringbuf_reserve(rb_map->rb, size);
> +	if (!rec)
> +		return -EAGAIN;
> +
> +	memcpy(rec, data, size);
> +	bpf_ringbuf_commit(rec, false /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_output_proto = {
> +	.func		= bpf_ringbuf_output,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg4_type	= ARG_ANYTHING,
> +};
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index de2a75500233..462db8595e9f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -26,6 +26,7 @@
>  #include <linux/audit.h>
>  #include <uapi/linux/btf.h>
>  #include <linux/bpf_lsm.h>
> +#include <linux/poll.h>
>  
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>  			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> @@ -651,6 +652,16 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
>  	return err;
>  }
>  
> +static __poll_t bpf_map_poll(struct file *filp, struct poll_table_struct *pts)
> +{
> +	struct bpf_map *map = filp->private_data;
> +
> +	if (map->ops->map_poll)
> +		return map->ops->map_poll(map, filp, pts);
> +
> +	return EPOLLERR;
> +}
> +
>  const struct file_operations bpf_map_fops = {
>  #ifdef CONFIG_PROC_FS
>  	.show_fdinfo	= bpf_map_show_fdinfo,
> @@ -659,6 +670,7 @@ const struct file_operations bpf_map_fops = {
>  	.read		= bpf_dummy_read,
>  	.write		= bpf_dummy_write,
>  	.mmap		= bpf_map_mmap,
> +	.poll		= bpf_map_poll,
>  };
>  
>  int bpf_map_new_fd(struct bpf_map *map, int flags)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2a1826c76bb6..b8f0158d2327 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -233,6 +233,7 @@ struct bpf_call_arg_meta {
>  	bool pkt_access;
>  	int regno;
>  	int access_size;
> +	int mem_size;
>  	u64 msize_max_value;
>  	int ref_obj_id;
>  	int func_id;
> @@ -399,7 +400,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
>  	       type == PTR_TO_SOCKET_OR_NULL ||
>  	       type == PTR_TO_SOCK_COMMON_OR_NULL ||
>  	       type == PTR_TO_TCP_SOCK_OR_NULL ||
> -	       type == PTR_TO_BTF_ID_OR_NULL;
> +	       type == PTR_TO_BTF_ID_OR_NULL ||
> +	       type == PTR_TO_MEM_OR_NULL;
>  }
>  
>  static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
> @@ -413,7 +415,9 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
>  	return type == PTR_TO_SOCKET ||
>  		type == PTR_TO_SOCKET_OR_NULL ||
>  		type == PTR_TO_TCP_SOCK ||
> -		type == PTR_TO_TCP_SOCK_OR_NULL;
> +		type == PTR_TO_TCP_SOCK_OR_NULL ||
> +		type == PTR_TO_MEM ||
> +		type == PTR_TO_MEM_OR_NULL;
>  }
>  
>  static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
> @@ -427,7 +431,9 @@ static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
>   */
>  static bool is_release_function(enum bpf_func_id func_id)
>  {
> -	return func_id == BPF_FUNC_sk_release;
> +	return func_id == BPF_FUNC_sk_release ||
> +	       func_id == BPF_FUNC_ringbuf_submit ||
> +	       func_id == BPF_FUNC_ringbuf_discard;
>  }
>  
>  static bool may_be_acquire_function(enum bpf_func_id func_id)
> @@ -435,7 +441,8 @@ static bool may_be_acquire_function(enum bpf_func_id func_id)
>  	return func_id == BPF_FUNC_sk_lookup_tcp ||
>  		func_id == BPF_FUNC_sk_lookup_udp ||
>  		func_id == BPF_FUNC_skc_lookup_tcp ||
> -		func_id == BPF_FUNC_map_lookup_elem;
> +		func_id == BPF_FUNC_map_lookup_elem ||
> +	        func_id == BPF_FUNC_ringbuf_reserve;
>  }
>  
>  static bool is_acquire_function(enum bpf_func_id func_id,
> @@ -445,7 +452,8 @@ static bool is_acquire_function(enum bpf_func_id func_id,
>  
>  	if (func_id == BPF_FUNC_sk_lookup_tcp ||
>  	    func_id == BPF_FUNC_sk_lookup_udp ||
> -	    func_id == BPF_FUNC_skc_lookup_tcp)
> +	    func_id == BPF_FUNC_skc_lookup_tcp ||
> +	    func_id == BPF_FUNC_ringbuf_reserve)
>  		return true;
>  
>  	if (func_id == BPF_FUNC_map_lookup_elem &&
> @@ -485,6 +493,8 @@ static const char * const reg_type_str[] = {
>  	[PTR_TO_XDP_SOCK]	= "xdp_sock",
>  	[PTR_TO_BTF_ID]		= "ptr_",
>  	[PTR_TO_BTF_ID_OR_NULL]	= "ptr_or_null_",
> +	[PTR_TO_MEM]		= "mem",
> +	[PTR_TO_MEM_OR_NULL]	= "mem_or_null",
>  };
>  
>  static char slot_type_char[] = {
> @@ -2459,32 +2469,31 @@ static int check_map_access_type(struct bpf_verifier_env *env, u32 regno,
>  	return 0;
>  }
>  
> -/* check read/write into map element returned by bpf_map_lookup_elem() */
> -static int __check_map_access(struct bpf_verifier_env *env, u32 regno, int off,
> -			      int size, bool zero_size_allowed)
> +/* check read/write into memory region (e.g., map value, ringbuf sample, etc) */
> +static int __check_mem_access(struct bpf_verifier_env *env, int off,
> +			      int size, u32 mem_size, bool zero_size_allowed)
>  {
> -	struct bpf_reg_state *regs = cur_regs(env);
> -	struct bpf_map *map = regs[regno].map_ptr;
> +	bool size_ok = size > 0 || (size == 0 && zero_size_allowed);
>  
> -	if (off < 0 || size < 0 || (size == 0 && !zero_size_allowed) ||
> -	    off + size > map->value_size) {
> -		verbose(env, "invalid access to map value, value_size=%d off=%d size=%d\n",
> -			map->value_size, off, size);
> -		return -EACCES;
> -	}
> -	return 0;
> +	if (off >= 0 && size_ok && off + size <= mem_size)
> +		return 0;
> +
> +	verbose(env, "invalid access to memory, mem_size=%u off=%d size=%d\n",
> +		mem_size, off, size);
> +	return -EACCES;
>  }
>  
> -/* check read/write into a map element with possible variable offset */
> -static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> -			    int off, int size, bool zero_size_allowed)
> +/* check read/write into a memory region with possible variable offset */
> +static int check_mem_region_access(struct bpf_verifier_env *env, u32 regno,
> +				   int off, int size, u32 mem_size,
> +				   bool zero_size_allowed)
>  {
>  	struct bpf_verifier_state *vstate = env->cur_state;
>  	struct bpf_func_state *state = vstate->frame[vstate->curframe];
>  	struct bpf_reg_state *reg = &state->regs[regno];
>  	int err;
>  
> -	/* We may have adjusted the register to this map value, so we
> +	/* We may have adjusted the register pointing to memory region, so we
>  	 * need to try adding each of min_value and max_value to off
>  	 * to make sure our theoretical access will be safe.
>  	 */
> @@ -2501,14 +2510,14 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
>  	    (reg->smin_value == S64_MIN ||
>  	     (off + reg->smin_value != (s64)(s32)(off + reg->smin_value)) ||
>  	      reg->smin_value + off < 0)) {
> -		verbose(env, "R%d min value is negative, either use unsigned index or do a if (index >=0) check.\n",
> +		verbose(env, "R%d min value is negative, either use unsigned index or do an if (index >=0) check.\n",
>  			regno);
>  		return -EACCES;
>  	}
> -	err = __check_map_access(env, regno, reg->smin_value + off, size,
> +	err = __check_mem_access(env, reg->smin_value + off, size, mem_size,
>  				 zero_size_allowed);
>  	if (err) {
> -		verbose(env, "R%d min value is outside of the array range\n",
> +		verbose(env, "R%d min value is outside of the memory region\n",
>  			regno);
>  		return err;
>  	}
> @@ -2518,18 +2527,38 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
>  	 * If reg->umax_value + off could overflow, treat that as unbounded too.
>  	 */
>  	if (reg->umax_value >= BPF_MAX_VAR_OFF) {
> -		verbose(env, "R%d unbounded memory access, make sure to bounds check any array access into a map\n",
> +		verbose(env, "R%d unbounded memory access, make sure to bounds check any memory region access\n",
>  			regno);
>  		return -EACCES;
>  	}
> -	err = __check_map_access(env, regno, reg->umax_value + off, size,
> +	err = __check_mem_access(env, reg->umax_value + off, size, mem_size,
>  				 zero_size_allowed);
> -	if (err)
> -		verbose(env, "R%d max value is outside of the array range\n",
> +	if (err) {
> +		verbose(env, "R%d max value is outside of the memory region\n",
>  			regno);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +/* check read/write into a map element with possible variable offset */
> +static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> +			    int off, int size, bool zero_size_allowed)
> +{
> +	struct bpf_verifier_state *vstate = env->cur_state;
> +	struct bpf_func_state *state = vstate->frame[vstate->curframe];
> +	struct bpf_reg_state *reg = &state->regs[regno];
> +	struct bpf_map *map = reg->map_ptr;
> +	int err;
> +
> +	err = check_mem_region_access(env, regno, off, size, map->value_size,
> +				      zero_size_allowed);
> +	if (err)
> +		return err;
>  
> -	if (map_value_has_spin_lock(reg->map_ptr)) {
> -		u32 lock = reg->map_ptr->spin_lock_off;
> +	if (map_value_has_spin_lock(map)) {
> +		u32 lock = map->spin_lock_off;
>  
>  		/* if any part of struct bpf_spin_lock can be touched by
>  		 * load/store reject this program.
> @@ -3211,6 +3240,16 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  				mark_reg_unknown(env, regs, value_regno);
>  			}
>  		}
> +	} else if (reg->type == PTR_TO_MEM) {
> +		if (t == BPF_WRITE && value_regno >= 0 &&
> +		    is_pointer_value(env, value_regno)) {
> +			verbose(env, "R%d leaks addr into mem\n", value_regno);
> +			return -EACCES;
> +		}
> +		err = check_mem_region_access(env, regno, off, size,
> +					      reg->mem_size, false);
> +		if (!err && t == BPF_READ && value_regno >= 0)
> +			mark_reg_unknown(env, regs, value_regno);
>  	} else if (reg->type == PTR_TO_CTX) {
>  		enum bpf_reg_type reg_type = SCALAR_VALUE;
>  		u32 btf_id = 0;
> @@ -3548,6 +3587,10 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>  			return -EACCES;
>  		return check_map_access(env, regno, reg->off, access_size,
>  					zero_size_allowed);
> +	case PTR_TO_MEM:
> +		return check_mem_region_access(env, regno, reg->off,
> +					       access_size, reg->mem_size,
> +					       zero_size_allowed);
>  	default: /* scalar_value|ptr_to_stack or invalid ptr */
>  		return check_stack_boundary(env, regno, access_size,
>  					    zero_size_allowed, meta);
> @@ -3652,6 +3695,17 @@ static bool arg_type_is_mem_size(enum bpf_arg_type type)
>  	       type == ARG_CONST_SIZE_OR_ZERO;
>  }
>  
> +static bool arg_type_is_alloc_mem_ptr(enum bpf_arg_type type)
> +{
> +	return type == ARG_PTR_TO_ALLOC_MEM ||
> +	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL;
> +}
> +
> +static bool arg_type_is_alloc_size(enum bpf_arg_type type)
> +{
> +	return type == ARG_CONST_ALLOC_SIZE_OR_ZERO;
> +}
> +
>  static bool arg_type_is_int_ptr(enum bpf_arg_type type)
>  {
>  	return type == ARG_PTR_TO_INT ||
> @@ -3711,7 +3765,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>  			 type != expected_type)
>  			goto err_type;
>  	} else if (arg_type == ARG_CONST_SIZE ||
> -		   arg_type == ARG_CONST_SIZE_OR_ZERO) {
> +		   arg_type == ARG_CONST_SIZE_OR_ZERO ||
> +		   arg_type == ARG_CONST_ALLOC_SIZE_OR_ZERO) {
>  		expected_type = SCALAR_VALUE;
>  		if (type != expected_type)
>  			goto err_type;
> @@ -3782,13 +3837,29 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>  		 * happens during stack boundary checking.
>  		 */
>  		if (register_is_null(reg) &&
> -		    arg_type == ARG_PTR_TO_MEM_OR_NULL)
> +		    (arg_type == ARG_PTR_TO_MEM_OR_NULL ||
> +		     arg_type == ARG_PTR_TO_ALLOC_MEM_OR_NULL))
>  			/* final test in check_stack_boundary() */;
>  		else if (!type_is_pkt_pointer(type) &&
>  			 type != PTR_TO_MAP_VALUE &&
> +			 type != PTR_TO_MEM &&
>  			 type != expected_type)
>  			goto err_type;
>  		meta->raw_mode = arg_type == ARG_PTR_TO_UNINIT_MEM;
> +	} else if (arg_type_is_alloc_mem_ptr(arg_type)) {
> +		expected_type = PTR_TO_MEM;
> +		if (register_is_null(reg) &&
> +		    arg_type == ARG_PTR_TO_ALLOC_MEM_OR_NULL)
> +			/* final test in check_stack_boundary() */;
> +		else if (type != expected_type)
> +			goto err_type;
> +		if (meta->ref_obj_id) {
> +			verbose(env, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
> +				regno, reg->ref_obj_id,
> +				meta->ref_obj_id);
> +			return -EFAULT;
> +		}
> +		meta->ref_obj_id = reg->ref_obj_id;
>  	} else if (arg_type_is_int_ptr(arg_type)) {
>  		expected_type = PTR_TO_STACK;
>  		if (!type_is_pkt_pointer(type) &&
> @@ -3884,6 +3955,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>  					      zero_size_allowed, meta);
>  		if (!err)
>  			err = mark_chain_precision(env, regno);
> +	} else if (arg_type_is_alloc_size(arg_type)) {
> +		if (!tnum_is_const(reg->var_off)) {
> +			verbose(env, "R%d unbounded size, use 'var &= const' or 'if (var < const)'\n",
> +				regno);
> +			return -EACCES;
> +		}
> +		meta->mem_size = reg->var_off.value;
>  	} else if (arg_type_is_int_ptr(arg_type)) {
>  		int size = int_ptr_type_to_size(arg_type);
>  
> @@ -3920,6 +3998,13 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		    func_id != BPF_FUNC_xdp_output)
>  			goto error;
>  		break;
> +	case BPF_MAP_TYPE_RINGBUF:
> +		if (func_id != BPF_FUNC_ringbuf_output &&
> +		    func_id != BPF_FUNC_ringbuf_reserve &&
> +		    func_id != BPF_FUNC_ringbuf_submit &&
> +		    func_id != BPF_FUNC_ringbuf_discard)
> +			goto error;
> +		break;
>  	case BPF_MAP_TYPE_STACK_TRACE:
>  		if (func_id != BPF_FUNC_get_stackid)
>  			goto error;
> @@ -4644,6 +4729,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>  		mark_reg_known_zero(env, regs, BPF_REG_0);
>  		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
>  		regs[BPF_REG_0].id = ++env->id_gen;
> +	} else if (fn->ret_type == RET_PTR_TO_ALLOC_MEM_OR_NULL) {
> +		mark_reg_known_zero(env, regs, BPF_REG_0);
> +		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> +		regs[BPF_REG_0].id = ++env->id_gen;
> +		regs[BPF_REG_0].mem_size = meta.mem_size;
>  	} else {
>  		verbose(env, "unknown return type %d of func %s#%d\n",
>  			fn->ret_type, func_id_name(func_id), func_id);
> @@ -6583,6 +6673,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
>  			reg->type = PTR_TO_TCP_SOCK;
>  		} else if (reg->type == PTR_TO_BTF_ID_OR_NULL) {
>  			reg->type = PTR_TO_BTF_ID;
> +		} else if (reg->type == PTR_TO_MEM_OR_NULL) {
> +			reg->type = PTR_TO_MEM;
>  		}
>  		if (is_null) {
>  			/* We don't need id and ref_obj_id from this point
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d961428fb5b6..6e6b3f8f77c1 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1053,6 +1053,14 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_perf_event_read_value_proto;
>  	case BPF_FUNC_get_ns_current_pid_tgid:
>  		return &bpf_get_ns_current_pid_tgid_proto;
> +	case BPF_FUNC_ringbuf_output:
> +		return &bpf_ringbuf_output_proto;
> +	case BPF_FUNC_ringbuf_reserve:
> +		return &bpf_ringbuf_reserve_proto;
> +	case BPF_FUNC_ringbuf_submit:
> +		return &bpf_ringbuf_submit_proto;
> +	case BPF_FUNC_ringbuf_discard:
> +		return &bpf_ringbuf_discard_proto;
>  	default:
>  		return NULL;
>  	}
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index bfb31c1be219..ae2deb6a8afc 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -147,6 +147,7 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_SK_STORAGE,
>  	BPF_MAP_TYPE_DEVMAP_HASH,
>  	BPF_MAP_TYPE_STRUCT_OPS,
> +	BPF_MAP_TYPE_RINGBUF,
>  };
>  
>  /* Note that tracing related programs such as
> @@ -3121,6 +3122,32 @@ union bpf_attr {
>   * 		0 on success, or a negative error in case of failure:
>   *
>   *		**-EOVERFLOW** if an overflow happened: The same object will be tried again.
> + *
> + * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
> + * 	Description
> + * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
> + * 	Return
> + * 		0, on success;
> + * 		< 0, on error.
> + *
> + * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
> + * 	Description
> + * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
> + * 	Return
> + * 		Valid pointer with *size* bytes of memory available; NULL,
> + * 		otherwise.
> + *
> + * void bpf_ringbuf_submit(void *data)
> + * 	Description
> + * 		Submit reserved ring buffer sample, pointed to by *data*.
> + * 	Return
> + * 		Nothing.
> + *
> + * void bpf_ringbuf_discard(void *data)
> + * 	Description
> + * 		Discard reserved ring buffer sample, pointed to by *data*.
> + * 	Return
> + * 		Nothing.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3250,7 +3277,11 @@ union bpf_attr {
>  	FN(sk_assign),			\
>  	FN(ktime_get_boot_ns),		\
>  	FN(seq_printf),			\
> -	FN(seq_write),
> +	FN(seq_write),			\
> +	FN(ringbuf_output),		\
> +	FN(ringbuf_reserve),		\
> +	FN(ringbuf_submit),		\
> +	FN(ringbuf_discard),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> -- 
> 2.24.1
> 
> 
