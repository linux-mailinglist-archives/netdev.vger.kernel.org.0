Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7D24D570
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 14:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgHUMwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 08:52:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgHUMwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 08:52:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LCpXDa159935;
        Fri, 21 Aug 2020 12:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=QtlQgPEUKDqI5Mad7y9Qd6Mzu/D8Zuxsc3o+KleFeX8=;
 b=iFej8B8a/KDLZuAPCNHO/3vA+6IaN+IUIU4CI4xI/YmHvefQxixzK/RVURu6bJz3NRIB
 ACPMkx7Uxm78v+/3DRaENIt5OnMPW1KFoRKSaGQsLF0MBbWifWZeFkEg2KmESasH9/6q
 B0R01o/jW7B2KdD7/Q7vJYQ1BJBrMYIW/O/0aaeCKD/nrDPB/O6HBpKaiuiIOxt7yT35
 m9jBUI1Kql/Hs17rVo0xFYSCTEhl1E7eTDewdTZAgrSohiFXTPitYVCJ1RFz9mMdNN+j
 KJJwWbKgqWHb99YFYKIxxBuWBMys43EP1NB5Ut11GeEuW+qJt8FUbytPjNHBnP3xMbry jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3322bjjdhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 12:51:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LCmNbo108411;
        Fri, 21 Aug 2020 12:51:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 332536q3f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 12:51:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07LCped8028829;
        Fri, 21 Aug 2020 12:51:40 GMT
Received: from dhcp-10-175-209-93.vpn.oracle.com (/10.175.209.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 12:51:40 +0000
Date:   Fri, 21 Aug 2020 13:51:31 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andriin@fb.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: add perf_buffer APIs for better
 integration with outside epoll loop
In-Reply-To: <20200821025448.2087055-1-andriin@fb.com>
Message-ID: <alpine.LRH.2.21.2008211149530.9620@localhost>
References: <20200821025448.2087055-1-andriin@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=11
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020, Andrii Nakryiko wrote:

> Add a set of APIs to perf_buffer manage to allow applications to integrate
> perf buffer polling into existing epoll-based infrastructure. One example is
> applications using libevent already and wanting to plug perf_buffer polling,
> instead of relying on perf_buffer__poll() and waste an extra thread to do it.
> But perf_buffer is still extremely useful to set up and consume perf buffer
> rings even for such use cases.
> 
> So to accomodate such new use cases, add three new APIs:
>   - perf_buffer__buffer_cnt() returns number of per-CPU buffers maintained by
>     given instance of perf_buffer manager;
>   - perf_buffer__buffer_fd() returns FD of perf_event corresponding to
>     a specified per-CPU buffer; this FD is then polled independently;
>   - perf_buffer__consume_buffer() consumes data from single per-CPU buffer,
>     identified by its slot index.
> 
> These APIs allow for great flexiblity, but do not sacrifice general usability
> of perf_buffer.
>

This is great! If I understand correctly, you're supporting the
retrieval and ultimately insertion of the individual per-cpu buffer fds 
into another epoll()ed fd.  I've been exploring another possibility - 
hierarchical epoll, where the top-level perf_buffer epoll_fd field is used 
rather than the individual per-cpu buffers.  In that context, would an 
interface to return the perf_buffer epoll_fd make sense too? i.e.

int perf_buffer__fd(const struct perf_buffer *pb);

?

When events occur for the perf_buffer__fd, we can simply call
perf_buffer__poll(perf_buffer__fd(pb), ...) to handle them it seems.  
That approach _appears_ to work, though I do see occasional event loss.
Is that method legit too or am I missing something?
 
> Also exercise and check new APIs in perf_buffer selftest.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

A few question around the test below, but

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>


> ---
>  tools/lib/bpf/libbpf.c                        | 51 ++++++++++++++-
>  tools/lib/bpf/libbpf.h                        |  3 +
>  tools/lib/bpf/libbpf.map                      |  7 +++
>  .../selftests/bpf/prog_tests/perf_buffer.c    | 62 +++++++++++++++----
>  4 files changed, 111 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0bc1fd813408..a6359d49aa9d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9390,6 +9390,55 @@ int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
>  	return cnt < 0 ? -errno : cnt;
>  }
>  
> +/* Return number of PERF_EVENT_ARRAY map slots set up by this perf_buffer
> + * manager.
> + */
> +size_t perf_buffer__buffer_cnt(const struct perf_buffer *pb)
> +{
> +	return pb->cpu_cnt;
> +}
> +
> +/*
> + * Return perf_event FD of a ring buffer in *buf_idx* slot of
> + * PERF_EVENT_ARRAY BPF map. This FD can be polled for new data using
> + * select()/poll()/epoll() Linux syscalls.
> + */
> +int perf_buffer__buffer_fd(const struct perf_buffer *pb, size_t buf_idx)
> +{
> +	struct perf_cpu_buf *cpu_buf;
> +
> +	if (buf_idx >= pb->cpu_cnt)
> +		return -EINVAL;
> +
> +	cpu_buf = pb->cpu_bufs[buf_idx];
> +	if (!cpu_buf)
> +		return -ENOENT;
> +
> +	return cpu_buf->fd;
> +}
> +
> +/*
> + * Consume data from perf ring buffer corresponding to slot *buf_idx* in
> + * PERF_EVENT_ARRAY BPF map without waiting/polling. If there is no data to
> + * consume, do nothing and return success.
> + * Returns:
> + *   - 0 on success;
> + *   - <0 on failure.
> + */
> +int perf_buffer__consume_buffer(struct perf_buffer *pb, size_t buf_idx)
> +{
> +	struct perf_cpu_buf *cpu_buf;
> +
> +	if (buf_idx >= pb->cpu_cnt)
> +		return -EINVAL;
> +
> +	cpu_buf = pb->cpu_bufs[buf_idx];
> +	if (!cpu_buf)
> +		return -ENOENT;
> +
> +	return perf_buffer__process_records(pb, cpu_buf);
> +}
> +
>  int perf_buffer__consume(struct perf_buffer *pb)
>  {
>  	int i, err;
> @@ -9402,7 +9451,7 @@ int perf_buffer__consume(struct perf_buffer *pb)
>  
>  		err = perf_buffer__process_records(pb, cpu_buf);
>  		if (err) {
> -			pr_warn("error while processing records: %d\n", err);
> +			pr_warn("perf_buffer: failed to process records in buffer #%d: %d\n", i, err);
>  			return err;
>  		}
>  	}
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 5ecb4069a9f0..15e02dcda2c7 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -590,6 +590,9 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
>  LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
>  LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms);
>  LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
> +LIBBPF_API int perf_buffer__consume_buffer(struct perf_buffer *pb, size_t buf_idx);
> +LIBBPF_API size_t perf_buffer__buffer_cnt(const struct perf_buffer *pb);
> +LIBBPF_API int perf_buffer__buffer_fd(const struct perf_buffer *pb, size_t buf_idx);
>  
>  typedef enum bpf_perf_event_ret
>  	(*bpf_perf_event_print_t)(struct perf_event_header *hdr,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index e35bd6cdbdbf..77466958310a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -299,3 +299,10 @@ LIBBPF_0.1.0 {
>  		btf__set_fd;
>  		btf__set_pointer_size;
>  } LIBBPF_0.0.9;
> +
> +LIBBPF_0.2.0 {
> +	global:
> +		perf_buffer__buffer_cnt;
> +		perf_buffer__buffer_fd;
> +		perf_buffer__consume_buffer;
> +} LIBBPF_0.1.0;
> diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> index c33ec180b3f2..add224ce17af 100644
> --- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> +++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> @@ -7,6 +7,8 @@
>  #include "test_perf_buffer.skel.h"
>  #include "bpf/libbpf_internal.h"
>  
> +static int duration;
> +
>  /* AddressSanitizer sometimes crashes due to data dereference below, due to
>   * this being mmap()'ed memory. Disable instrumentation with
>   * no_sanitize_address attribute
> @@ -24,13 +26,31 @@ static void on_sample(void *ctx, int cpu, void *data, __u32 size)
>  	CPU_SET(cpu, cpu_seen);
>  }
>  
> +int trigger_on_cpu(int cpu)
> +{
> +	cpu_set_t cpu_set;
> +	int err;
> +
> +	CPU_ZERO(&cpu_set);
> +	CPU_SET(cpu, &cpu_set);
> +
> +	err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set), &cpu_set);
> +	if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n", cpu, err))
> +		return err;
> +
> +	usleep(1);
> +
> +	return 0;
> +}
> +
>  void test_perf_buffer(void)
>  {
> -	int err, on_len, nr_on_cpus = 0,  nr_cpus, i, duration = 0;
> +	int err, on_len, nr_on_cpus = 0, nr_cpus, i;
>  	struct perf_buffer_opts pb_opts = {};
>  	struct test_perf_buffer *skel;
> -	cpu_set_t cpu_set, cpu_seen;
> +	cpu_set_t cpu_seen;
>  	struct perf_buffer *pb;
> +	int last_fd = -1, fd;
>  	bool *online;
>  
>  	nr_cpus = libbpf_num_possible_cpus();
> @@ -71,16 +91,8 @@ void test_perf_buffer(void)
>  			continue;
>  		}
>  
> -		CPU_ZERO(&cpu_set);
> -		CPU_SET(i, &cpu_set);
> -
> -		err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
> -					     &cpu_set);
> -		if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
> -				 i, err))
> +		if (trigger_on_cpu(i))
>  			goto out_close;
> -
> -		usleep(1);
>  	}
>  
>  	/* read perf buffer */
> @@ -92,6 +104,34 @@ void test_perf_buffer(void)
>  		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
>  		goto out_free_pb;
>  
> +	if (CHECK(perf_buffer__buffer_cnt(pb) != nr_cpus, "buf_cnt",
> +		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_cpus))
> +		goto out_close;
> +
> +	for (i = 0; i < nr_cpus; i++) {
> +		if (i >= on_len || !online[i])
> +			continue;
> +
> +		fd = perf_buffer__buffer_fd(pb, i);
> +		CHECK(last_fd == fd, "fd_check", "last fd %d == fd %d\n", last_fd, fd);
> +		last_fd = fd;
> +

I'm not sure why you're testing this way - shouldn't it just be a
verification of whether we get an unexpected error code rather
than a valid fd?

> +		err = perf_buffer__consume_buffer(pb, i);
> +		if (CHECK(err, "drain_buf", "cpu %d, err %d\n", i, err))
> +			goto out_close;
> +

I think I'm a bit lost in what processes what here. The first
perf_buffer__poll() should handle the processing of the records
associated with the first set of per-cpu triggering I think.
Is the above perf_buffer__consume_buffer() checking the
"no data, return success" case? If that's right should we do 
something to explicitly check it indeed was a no-op, like CHECK()ing 
CPU_ISSET(i, &cpu_seen) to ensure the on_sample() handler wasn't
called? The  "drain_buf" description makes me think I'm misreading
this and we're draining additional events, so I wanted to check
what's going on here to make sure.

Thanks!

Alan
