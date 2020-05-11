Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48131CE03C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgEKQPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730640AbgEKQPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 12:15:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3586BC05BD0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so11176794wrc.11
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nn3QJVCLtMqQCDVuxpusYbBzp2Vc+q+5U4KtJW9U8QA=;
        b=VV+NnFUZRb+94s4QQUkdDxme4/gQSD8VC8wcdrq6/FBViNTISmzX2OK9newXpWZ9ZL
         MLF/lkqaqIBjagKP8knJEDfG+kh3KVqtWHtRPEEkb+Z8e3nngna7npedy2r/0tSAciMg
         rn0YqM/aGj4hT3IeNidIoqRd25VYOJDnaXjeesTZwMyUNEXgj+vRV1A/6//VE9zpIySA
         aSLk1VgOt9gAGRhO2AEKRAOHBzjJIBmrVB11YE2J0KHvEMvG/qA3/mSlWio9T++QpNZY
         63xSRtfQq+s+yD5+lmH2nCmkOBwM5GNVXILmfebo1HuziRh9b7egW8K3PAf+o6v8WSZv
         wEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn3QJVCLtMqQCDVuxpusYbBzp2Vc+q+5U4KtJW9U8QA=;
        b=LVsMwGx0DpHo8shjQAD1bxtF45Ca3Pnu788BNbjMdfxLDHvN7KgLGZbFEg7ehXb1ih
         qsBYxRBVS9CcRkghybd53niGaldUk3152voahd7R5RsxmmpBoP9r0CWQlcGNY+wyFeiN
         vZThIrqkSM3BuFENjgIpPJgGPqzlgFiUVNH/uhnPgHN31YU2gDt63xJICRbpB9EQNKY4
         8Wk8zKfsmIDjUfEoILA4y+H2TfAOggD2mhGF4Ftl6cK93X6DPz0TK3WXJbqfHzcvYFuh
         mx10pUjKIUe9jwg557OkNXV6t9Tq2Zr3iVlu8RhLmdSpatMbOpcVyJfBhanfdhZaVEep
         s8qw==
X-Gm-Message-State: AGi0PuYWvsoAxDMNb3SOMb0GX7c7xfMfmn9Iy9G5Gt8OhdmArCOi5ncu
        yafhiOZrSZ82ymI9eecDkrvx4vEjly/jiw==
X-Google-Smtp-Source: APiQypKITtSGqTQH7N2eiumguqWih+VodpzPrw/9j2W8ImXqTv3BAE3eyHj7kS8kmUl+fo3B2cP4Dw==
X-Received: by 2002:adf:f388:: with SMTP id m8mr11588038wro.160.1589213743726;
        Mon, 11 May 2020 09:15:43 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.84])
        by smtp.gmail.com with ESMTPSA id v131sm54734wmb.27.2020.05.11.09.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:15:43 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 4/4] tools: bpf: synchronise BPF UAPI header with tools
Date:   Mon, 11 May 2020 17:15:36 +0100
Message-Id: <20200511161536.29853-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511161536.29853-1-quentin@isovalent.com>
References: <20200511161536.29853-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronise the bpf.h header under tools, to report the fixes recently
brought to the documentation for the BPF helpers.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/include/uapi/linux/bpf.h | 109 ++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 9d1932e23cec..bfb31c1be219 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -675,8 +675,8 @@ union bpf_attr {
  * 		For tracing programs, safely attempt to read *size* bytes from
  * 		kernel space address *unsafe_ptr* and store the data in *dst*.
  *
- * 		Generally, use bpf_probe_read_user() or bpf_probe_read_kernel()
- * 		instead.
+ * 		Generally, use **bpf_probe_read_user**\ () or
+ * 		**bpf_probe_read_kernel**\ () instead.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
@@ -684,7 +684,7 @@ union bpf_attr {
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
  * 		Does not include time the system was suspended.
- * 		See: clock_gettime(CLOCK_MONOTONIC)
+ * 		See: **clock_gettime**\ (**CLOCK_MONOTONIC**)
  * 	Return
  * 		Current *ktime*.
  *
@@ -1543,11 +1543,11 @@ union bpf_attr {
  * int bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address
- * 		*unsafe_ptr* to *dst*. See bpf_probe_read_kernel_str() for
+ * 		*unsafe_ptr* to *dst*. See **bpf_probe_read_kernel_str**\ () for
  * 		more details.
  *
- * 		Generally, use bpf_probe_read_user_str() or bpf_probe_read_kernel_str()
- * 		instead.
+ * 		Generally, use **bpf_probe_read_user_str**\ () or
+ * 		**bpf_probe_read_kernel_str**\ () instead.
  * 	Return
  * 		On success, the strictly positive length of the string,
  * 		including the trailing NUL character. On error, a negative
@@ -1575,7 +1575,7 @@ union bpf_attr {
  *
  * u64 bpf_get_socket_cookie(struct bpf_sock_ops *ctx)
  * 	Description
- * 		Equivalent to bpf_get_socket_cookie() helper that accepts
+ * 		Equivalent to **bpf_get_socket_cookie**\ () helper that accepts
  * 		*skb*, but gets socket from **struct bpf_sock_ops** context.
  * 	Return
  * 		A 8-byte long non-decreasing number.
@@ -1604,6 +1604,7 @@ union bpf_attr {
  * 		The option value of length *optlen* is pointed by *optval*.
  *
  * 		*bpf_socket* should be one of the following:
+ *
  * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
  * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
  * 		  and **BPF_CGROUP_INET6_CONNECT**.
@@ -1672,12 +1673,12 @@ union bpf_attr {
  *
  * 		The lower two bits of *flags* are used as the return code if
  * 		the map lookup fails. This is so that the return value can be
- * 		one of the XDP program return codes up to XDP_TX, as chosen by
- * 		the caller. Any higher bits in the *flags* argument must be
+ * 		one of the XDP program return codes up to **XDP_TX**, as chosen
+ * 		by the caller. Any higher bits in the *flags* argument must be
  * 		unset.
  *
- * 		See also bpf_redirect(), which only supports redirecting to an
- * 		ifindex, but doesn't require a map to do so.
+ * 		See also **bpf_redirect**\ (), which only supports redirecting
+ * 		to an ifindex, but doesn't require a map to do so.
  * 	Return
  * 		**XDP_REDIRECT** on success, or the value of the two lower bits
  * 		of the *flags* argument on error.
@@ -1785,7 +1786,7 @@ union bpf_attr {
  * 		the time running for event since last normalization. The
  * 		enabled and running times are accumulated since the perf event
  * 		open. To achieve scaling factor between two invocations of an
- * 		eBPF program, users can can use CPU id as the key (which is
+ * 		eBPF program, users can use CPU id as the key (which is
  * 		typical for perf array usage model) to remember the previous
  * 		value and do the calculation inside the eBPF program.
  * 	Return
@@ -1812,6 +1813,7 @@ union bpf_attr {
  * 		*opval* and of length *optlen*.
  *
  * 		*bpf_socket* should be one of the following:
+ *
  * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
  * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
  * 		  and **BPF_CGROUP_INET6_CONNECT**.
@@ -1833,7 +1835,7 @@ union bpf_attr {
  * 		The first argument is the context *regs* on which the kprobe
  * 		works.
  *
- * 		This helper works by setting setting the PC (program counter)
+ * 		This helper works by setting the PC (program counter)
  * 		to an override function which is run in place of the original
  * 		probed function. This means the probed function is not run at
  * 		all. The replacement function just returns with the required
@@ -2300,7 +2302,7 @@ union bpf_attr {
  *		**bpf_rc_keydown**\ () again with the same values, or calling
  *		**bpf_rc_repeat**\ ().
  *
- *		Some protocols include a toggle bit, in case the button	was
+ *		Some protocols include a toggle bit, in case the button was
  *		released and pressed again between consecutive scancodes.
  *
  *		The *ctx* should point to the lirc sample as passed into
@@ -2646,7 +2648,6 @@ union bpf_attr {
  *
  * 		*th* points to the start of the TCP header, while *th_len*
  * 		contains **sizeof**\ (**struct tcphdr**).
- *
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -2829,7 +2830,6 @@ union bpf_attr {
  *
  *		*th* points to the start of the TCP header, while *th_len*
  *		contains the length of the TCP header.
- *
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
@@ -2912,7 +2912,7 @@ union bpf_attr {
  * 				// size, after checking its boundaries.
  * 			}
  *
- * 		In comparison, using **bpf_probe_read_user()** helper here
+ * 		In comparison, using **bpf_probe_read_user**\ () helper here
  * 		instead to read the string would require to estimate the length
  * 		at compile time, and would often result in copying more memory
  * 		than necessary.
@@ -2930,14 +2930,14 @@ union bpf_attr {
  * int bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address *unsafe_ptr*
- * 		to *dst*. Same semantics as with bpf_probe_read_user_str() apply.
+ * 		to *dst*. Same semantics as with **bpf_probe_read_user_str**\ () apply.
  * 	Return
- * 		On success, the strictly positive length of the string,	including
+ * 		On success, the strictly positive length of the string, including
  * 		the trailing NUL character. On error, a negative value.
  *
  * int bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
  *	Description
- *		Send out a tcp-ack. *tp* is the in-kernel struct tcp_sock.
+ *		Send out a tcp-ack. *tp* is the in-kernel struct **tcp_sock**.
  *		*rcv_nxt* is the ack_seq to be sent out.
  *	Return
  *		0 on success, or a negative error in case of failure.
@@ -2965,19 +2965,19 @@ union bpf_attr {
  * int bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
  *	Description
  *		For an eBPF program attached to a perf event, retrieve the
- *		branch records (struct perf_branch_entry) associated to *ctx*
- *		and store it in	the buffer pointed by *buf* up to size
+ *		branch records (**struct perf_branch_entry**) associated to *ctx*
+ *		and store it in the buffer pointed by *buf* up to size
  *		*size* bytes.
  *	Return
  *		On success, number of bytes written to *buf*. On error, a
  *		negative value.
  *
  *		The *flags* can be set to **BPF_F_GET_BRANCH_RECORDS_SIZE** to
- *		instead	return the number of bytes required to store all the
+ *		instead return the number of bytes required to store all the
  *		branch entries. If this flag is set, *buf* may be NULL.
  *
  *		**-EINVAL** if arguments invalid or **size** not a multiple
- *		of sizeof(struct perf_branch_entry).
+ *		of **sizeof**\ (**struct perf_branch_entry**\ ).
  *
  *		**-ENOENT** if architecture does not support branch records.
  *
@@ -2985,8 +2985,8 @@ union bpf_attr {
  *	Description
  *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
  *		*namespace* will be returned in *nsdata*.
- *
- *		On failure, the returned value is one of the following:
+ *	Return
+ *		0 on success, or one of the following in case of failure:
  *
  *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
  *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
@@ -3025,8 +3025,8 @@ union bpf_attr {
  * 		a global identifier that can be assumed unique. If *ctx* is
  * 		NULL, then the helper returns the cookie for the initial
  * 		network namespace. The cookie itself is very similar to that
- * 		of bpf_get_socket_cookie() helper, but for network namespaces
- * 		instead of sockets.
+ * 		of **bpf_get_socket_cookie**\ () helper, but for network
+ * 		namespaces instead of sockets.
  * 	Return
  * 		A 8-byte long opaque number.
  *
@@ -3061,57 +3061,66 @@ union bpf_attr {
  *
  *		The *flags* argument must be zero.
  *	Return
- *		0 on success, or a negative errno in case of failure.
+ *		0 on success, or a negative error in case of failure:
  *
- *		* **-EINVAL**		Unsupported flags specified.
- *		* **-ENOENT**		Socket is unavailable for assignment.
- *		* **-ENETUNREACH**	Socket is unreachable (wrong netns).
- *		* **-EOPNOTSUPP**	Unsupported operation, for example a
- *					call from outside of TC ingress.
- *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
+ *		**-EINVAL** if specified *flags* are not supported.
+ *
+ *		**-ENOENT** if the socket is unavailable for assignment.
+ *
+ *		**-ENETUNREACH** if the socket is unreachable (wrong netns).
+ *
+ *		**-EOPNOTSUPP** if the operation is not supported, for example
+ *		a call from outside of TC ingress.
+ *
+ *		**-ESOCKTNOSUPPORT** if the socket type is not supported
+ *		(reuseport).
  *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
  * 		Does include the time the system was suspended.
- * 		See: clock_gettime(CLOCK_BOOTTIME)
+ * 		See: **clock_gettime**\ (**CLOCK_BOOTTIME**)
  * 	Return
  * 		Current *ktime*.
  *
  * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size, const void *data, u32 data_len)
  * 	Description
- * 		seq_printf uses seq_file seq_printf() to print out the format string.
+ * 		**bpf_seq_printf**\ () uses seq_file **seq_printf**\ () to print
+ * 		out the format string.
  * 		The *m* represents the seq_file. The *fmt* and *fmt_size* are for
  * 		the format string itself. The *data* and *data_len* are format string
- * 		arguments. The *data* are a u64 array and corresponding format string
+ * 		arguments. The *data* are a **u64** array and corresponding format string
  * 		values are stored in the array. For strings and pointers where pointees
  * 		are accessed, only the pointer values are stored in the *data* array.
- * 		The *data_len* is the *data* size in term of bytes.
+ * 		The *data_len* is the size of *data* in bytes.
  *
  *		Formats **%s**, **%p{i,I}{4,6}** requires to read kernel memory.
  *		Reading kernel memory may fail due to either invalid address or
  *		valid address but requiring a major memory fault. If reading kernel memory
  *		fails, the string for **%s** will be an empty string, and the ip
  *		address for **%p{i,I}{4,6}** will be 0. Not returning error to
- *		bpf program is consistent with what bpf_trace_printk() does for now.
+ *		bpf program is consistent with what **bpf_trace_printk**\ () does for now.
  * 	Return
- * 		0 on success, or a negative errno in case of failure.
+ * 		0 on success, or a negative error in case of failure:
+ *
+ *		**-EBUSY** if per-CPU memory copy buffer is busy, can try again
+ *		by returning 1 from bpf program.
+ *
+ *		**-EINVAL** if arguments are invalid, or if *fmt* is invalid/unsupported.
+ *
+ *		**-E2BIG** if *fmt* contains too many format specifiers.
  *
- *		* **-EBUSY**		Percpu memory copy buffer is busy, can try again
- *					by returning 1 from bpf program.
- *		* **-EINVAL**		Invalid arguments, or invalid/unsupported formats.
- *		* **-E2BIG**		Too many format specifiers.
- *		* **-EOVERFLOW**	Overflow happens, the same object will be tried again.
+ *		**-EOVERFLOW** if an overflow happened: The same object will be tried again.
  *
  * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
  * 	Description
- * 		seq_write uses seq_file seq_write() to write the data.
+ * 		**bpf_seq_write**\ () uses seq_file **seq_write**\ () to write the data.
  * 		The *m* represents the seq_file. The *data* and *len* represent the
- *		data to write in bytes.
+ * 		data to write in bytes.
  * 	Return
- * 		0 on success, or a negative errno in case of failure.
+ * 		0 on success, or a negative error in case of failure:
  *
- *		* **-EOVERFLOW**	Overflow happens, the same object will be tried again.
+ *		**-EOVERFLOW** if an overflow happened: The same object will be tried again.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
-- 
2.20.1

